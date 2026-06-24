---
title: "Prompt caching"
type: source
source: "Clippings/Prompt caching.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, claude-api, prompt-caching, kv-cache, ttl, pricing, cache-breakpoints, extended-thinking]
---

## Tese central
Documentação de referência completa da Anthropic sobre prompt caching: como funciona o mecanismo de cache de prefixo (hash cumulativo, lookback de 20 blocos, hierarquia `tools→system→messages`), os dois modos de uso (automatic caching vs. explicit breakpoints), tabela de preços por modelo, TTLs (5 minutos padrão / 1 hora pago), pré-aquecimento de cache (`max_tokens: 0`), interação com extended thinking, e isolamento de dados por workspace/organização.

## Argumentos principais

### Mecânica fundamental
- **Prompt caching referencia o prefixo inteiro** — `tools`, `system`, e `messages`, nessa ordem, até e incluindo o bloco marcado com `cache_control`.
- **Fluxo de uma requisição cacheada:** (1) o sistema verifica se o prefixo até o breakpoint já está cacheado de uma query recente; (2) se sim, usa a versão cacheada, reduzindo tempo e custo; (3) caso contrário, processa o prompt completo e cacheia o prefixo assim que a resposta começa.
- **TTL padrão: 5 minutos**, renovado sem custo adicional a cada uso. Existe duração de **1 hora a custo adicional**.
- **"Ephemeral" é o único tipo de cache suportado atualmente.**

### Duas formas de habilitar
1. **Automatic caching** — um único campo `cache_control` no nível top da requisição; o sistema aplica o breakpoint automaticamente ao último bloco cacheável e o move adiante conforme a conversa cresce. Ideal para conversas multi-turn.
2. **Explicit cache breakpoints** — `cache_control` em blocos de conteúdo individuais, para controle granular de exatamente o que é cacheado (útil quando seções mudam em frequências diferentes).

### Como funciona a automatic caching em conversas multi-turn
- O ponto de cache se move automaticamente: cada nova requisição cacheia tudo até o último bloco cacheável; conteúdo anterior é lido do cache. Tabela de exemplo mostra Request 1/2/3 com o breakpoint avançando de User(2) → User(3) → User(4), e o sistema lendo "System through User(N-1) from cache" e escrevendo apenas o delta.
- TTL: por padrão 5 minutos; pode-se especificar 1 hora via `{ "cache_control": { "type": "ephemeral", "ttl": "1h" } }` a 2x o preço de input base.
- Compatível com explicit breakpoints — quando combinados, o breakpoint automático usa um dos 4 slots de breakpoint disponíveis.
- **Edge cases:** se o último bloco já tem `cache_control` explícito com o mesmo TTL, automatic caching é no-op; com TTL diferente, retorna 400; se já existem 4 breakpoints explícitos, retorna 400 (sem slots); se o último bloco não é elegível como alvo, o sistema busca silenciosamente para trás até achar um bloco elegível — se não achar nenhum, pula o caching.
- Disponível na Claude API, Claude Platform on AWS, e Microsoft Foundry (beta). **Bedrock e Vertex AI não suportam automatic caching.**

### Explicit cache breakpoints — os "3 princípios centrais"
1. **Cache writes acontecem apenas no breakpoint.** Marcar um bloco com `cache_control` escreve exatamente uma entrada de cache: hash do prefixo terminando naquele bloco. O hash é cumulativo — mudar qualquer bloco no ou antes do breakpoint produz hash diferente na próxima requisição.
2. **Cache reads olham para trás por entradas que requisições anteriores escreveram.** O sistema computa o hash do prefixo no breakpoint e verifica correspondência; se não encontra, anda um bloco por vez para trás procurando hash que bata com algo já cacheado. **Procura por escritas anteriores, não por conteúdo estável.**
3. **A janela de lookback é de 20 blocos**, contando o próprio breakpoint como a primeira posição. Se nenhuma correspondência é encontrada nessa janela, a verificação para (ou recomeça do próximo breakpoint explícito).
- **Exemplo de lookback numa conversa crescente:** Turn 1 (10 blocos, breakpoint no 10) escreve entrada no bloco 10; Turn 2 (15 blocos, breakpoint no 15) acerta cache no bloco 10 (dentro da janela), processa só 11-15 e escreve nova entrada no 15; Turn 3 (35 blocos, breakpoint no 35) verifica 20 posições (35 a 16), não encontra nada — a entrada do bloco 15 está uma posição **fora** da janela, então não há cache hit; adicionar um segundo breakpoint no bloco 15 resolveria.
- **Erro comum documentado: breakpoint em conteúdo que muda a cada requisição** — exemplo com 5 blocos estáticos + bloco 6 variável (timestamp + mensagem do usuário); colocar `cache_control` no bloco 6 produz hash diferente a cada vez, o lookback nunca encontra entrada anterior nas posições 5-1 (nada foi escrito ali), e cada requisição paga cache write fresco sem nunca ter um read. **A solução é mover o breakpoint para o bloco 5** (último bloco estável). Automatic caching cai na mesma armadilha por padrão.
- **Regra de ouro:** colocar `cache_control` no último bloco cujo prefixo é idêntico entre as requisições que devem compartilhar cache.
- **Até 4 breakpoints** podem ser definidos — úteis para cachear seções com frequências de mudança diferentes, ou para garantir cache hit quando uma conversa crescente empurra o breakpoint 20+ blocos além da última escrita (limitação documentada explicitamente: o lookback só encontra entradas que requisições anteriores já escreveram).
- **Breakpoints não custam nada por si só** — cobrança é só por cache writes (125% do input base para TTL de 5 min), cache reads (10% do preço de input base), e tokens de input regulares não-cacheados.

### Limitações de cache
- **Comprimento mínimo cacheável** varia por modelo: 4.096 tokens (Claude Mythos Preview, Opus 4.7/4.6/4.5), **1.024 tokens** (Opus 4.8, Sonnet 4.6/4.5, Opus 4.1/4 deprecated, Sonnet 4 deprecated), 4.096 (Haiku 4.5), 2.048 (Haiku 3.5). Prompts mais curtos não são cacheados — sem erro, apenas processados sem cache; verificar se `cache_creation_input_tokens` e `cache_read_input_tokens` são ambos 0.
- **Concorrência:** uma entrada de cache só fica disponível depois que a primeira resposta começa — para acertos em requisições paralelas, esperar a primeira resposta antes de enviar as seguintes.
- **Matching exato:** cache hits requerem 100% de correspondência de texto e imagens até e incluindo o bloco com cache control.

### O que pode/não pode ser cacheado
- **Pode:** definições de tools, blocos de conteúdo no array `system`, mensagens de texto (user e assistant), imagens e documentos (em turnos user), tool use e tool results.
- **Não pode:** thinking blocks **não podem ser cacheados diretamente** com `cache_control` — mas PODEM ser cacheados junto com outro conteúdo quando aparecem em turnos assistant anteriores (e contam como input tokens quando lidos do cache); sub-content blocks como citations não podem ser cacheados diretamente (cachear o bloco de documento top-level); blocos de texto vazios não podem ser cacheados.

### O que invalida o cache (tabela completa)
| Mudança | Tools | System | Messages | Nota |
|---|---|---|---|---|
| Definições de tools | ✘ | ✘ | ✘ | invalida tudo |
| Web search toggle | ✓ | ✘ | ✘ | modifica system prompt |
| Citations toggle | ✓ | ✘ | ✘ | modifica system prompt |
| Speed setting (`fast` vs standard) | ✓ | ✘ | ✘ | invalida system + messages |
| Tool choice | ✓ | ✓ | ✘ | só afeta blocos message |
| Imagens (add/remove) | ✓ | ✓ | ✘ | afeta blocos message |
| Parâmetros de extended thinking | ✓ | ✓ | ✘ | afeta blocos message |
| Resultados não-tool em requests com extended thinking | ✓ | ✓ | depende do modelo | em Opus 4.5+/Sonnet 4.6+ thinking blocks são preservados (✓); em modelos anteriores e todos os Haiku, thinking blocks são removidos e mensagens subsequentes saem do cache (✘) |

- **Mid-conversation system messages** (Opus 4.8): permitem adicionar instrução de sistema no meio da conversa sem invalidar caches de system ou messages — anexar `{"role": "system"}` em vez de editar o campo `system` top-level. Ver [[03-RESOURCES/sources/mid-conversation-system-messages]].

### Cache com thinking blocks (extended thinking)
- Thinking blocks não podem ser marcados com `cache_control` diretamente, mas são cacheados como parte do conteúdo da requisição em chamadas subsequentes com tool results.
- Quando lidos do cache, contam como input tokens nas métricas de uso.
- **Padrões de invalidação:** cache permanece válido quando só tool results são fornecidos como mensagens user; em **Opus 4.5+ e Sonnet 4.6+**, thinking blocks são preservados por padrão mesmo com conteúdo user não-tool-result, então o cache permanece válido; em **modelos anteriores e todos os Haiku**, conteúdo user não-tool-result invalida o cache e remove todos os thinking blocks anteriores do contexto.

### Tracking de performance
- Três campos de `usage`: `cache_creation_input_tokens` (escritos ao criar entrada nova), `cache_read_input_tokens` (recuperados do cache), `input_tokens` (tokens **após** o último breakpoint — não eligíveis para cache).
- Fórmula: `total_input_tokens = cache_read_input_tokens + cache_creation_input_tokens + input_tokens`.
- Exemplo numérico: 100.000 tokens cacheados lidos + 0 novos escritos + 50 tokens de mensagem do usuário = 100.050 tokens totais processados, mas `input_tokens` reporta só 50.

### 1-hour cache duration
- Disponível em Claude API, Claude Platform on AWS, Amazon Bedrock (legacy e atual), Vertex AI, Microsoft Foundry (beta).
- Ativado via `"cache_control": { "type": "ephemeral", "ttl": "1h" }`.
- Resposta inclui objeto `cache_creation` detalhado: `{ ephemeral_5m_input_tokens, ephemeral_1h_input_tokens }`.
- **Quando usar 1h:** prompts usados com cadência menor que 5 minutos mas mais que 1 hora (ex.: side-agents agênticos que demoram mais de 5 min, conversas longas onde o usuário pode não responder logo); quando latência importa e follow-ups podem vir além de 5 min; quando se quer melhorar utilização de rate limit (cache hits não são deduzidos do rate limit).
- **Mixing TTLs:** entradas de TTL mais longo devem aparecer **antes** de TTLs mais curtos (1h antes de 5min). A API determina 3 posições de cobrança: `A` (maior cache hit), `B` (maior bloco 1h após A), `C` (último bloco com cache_control). Cobrança: cache read tokens para `A`; cache write de 1h para `(B-A)`; cache write de 5min para `(C-B)`.

### Pre-warming the cache
- **Mecanismo:** `max_tokens: 0` faz a API ler o prompt no modelo e escrever o cache no breakpoint, retornando imediatamente sem gerar output (`content: []`, `stop_reason: "max_tokens"`, `usage` totalmente populado).
- O breakpoint deve ficar no último bloco **compartilhado** com a requisição de follow-up (ex.: fim do system prompt), não na mensagem placeholder — caso contrário a entrada fica chaveada ao placeholder. Isso exige um **explicit breakpoint**, já que automatic caching colocaria o breakpoint no último bloco (o placeholder).
- A mensagem placeholder pode ser qualquer string não-vazia (ex.: `"warmup"`); seu conteúdo é lido pelo modelo mas nunca respondido.
- Pre-warm incorre em cobrança de cache write se o prefixo ainda não estiver cacheado — verificar `usage.cache_creation_input_tokens`. **Zero output tokens são cobrados.**
- **Padrão de uso típico:** disparar pre-warm na inicialização da app (ou em intervalo agendado), depois enviar requisições reais de usuário.
- **Limitações — `max_tokens: 0` é rejeitado com `invalid_request_error` se:** `stream: true`; extended thinking habilitado; structured outputs habilitado; `tool_choice` do tipo `{"type": "tool", ...}` ou `{"type": "any"}`. Também é rejeitado dentro de Message Batches (pre-warming visa TTFT, que não se aplica a batch, e a entrada de cache provavelmente expiraria antes do follow-up rodar).
- **Substitui o workaround `max_tokens: 1`:** `max_tokens: 0` é preferível — não produz output (nada para descartar), nenhum output token é cobrado, e a intenção é inequívoca.

### Armazenamento e isolamento de dados
- **A partir de 5 de fevereiro de 2026, prompt caching usa isolamento em nível de workspace** em vez de organização — caches são isolados por workspace dentro da mesma organização. Aplica-se à Claude API, Claude Platform on AWS e Microsoft Foundry (beta); **Bedrock e Vertex AI mantêm isolamento em nível de organização**.
- Caches nunca são compartilhados entre organizações diferentes, mesmo com prompts idênticos.
- KV cache representations e hashes criptográficos ficam **apenas em memória**, não são armazenados em repouso. Entradas de cache têm vida mínima de 5 minutos (padrão) ou 1 hora (estendido), depois são deletadas prontamente (não imediatamente).
- Prompt caching (automático e explícito) é **elegível para ZDR** — Anthropic não armazena o texto bruto de prompts ou respostas.
- Caching não tem efeito sobre a geração de output tokens — a resposta é idêntica à que seria recebida sem caching.

## Key insights

- A distinção mais sutil e provavelmente mais subestimada da doc: **"the lookback does not find stable content behind your breakpoint and cache it. It finds entries that prior requests already wrote."** — isso significa que conteúdo estável "atrás" de um breakpoint mal posicionado *nunca* será cacheado automaticamente; o erro de colocar o breakpoint no bloco variável é um anti-padrão que silenciosamente queima dinheiro (cache write toda vez, nunca um read).
- A janela de lookback de 20 blocos é uma restrição estrutural que cria um "buraco" em conversas que crescem rápido: se cada turno adiciona ≥20 blocos, o write do turno anterior cai fora da janela do turno seguinte — daí a recomendação de adicionar um segundo breakpoint próximo da posição que vai precisar de hit.
- A tabela de invalidação revela hierarquia em cascata: mudar `tools` invalida tudo; mudar `system` (via toggles de web search/citations/speed) invalida system+messages mas preserva tools; mudar `tool_choice`/imagens/thinking params só invalida messages. Entender essa hierarquia é o que permite estruturar prompts para minimizar blast radius de mudanças frequentes.
- O comportamento de thinking blocks em cache é **model-dependent** de forma não-óbvia — Opus 4.5+/Sonnet 4.6+ preservam thinking blocks por padrão (cache válido), enquanto modelos anteriores e todo o Haiku descartam (cache inválido). Isso é uma trap de portabilidade: código testado em Sonnet 4.6 pode se comportar de forma diferente (e mais cara) em Haiku.
- "Cache hits are not deducted against your rate limit" é um motivo de uso do cache de 1h que vai além de custo — é uma alavanca de **rate limit utilization**, relevante para quem opera perto dos tetos de tier.
- O `max_tokens: 0` pre-warming é uma capacidade relativamente nova que substitui formalmente o hack `max_tokens: 1` — sinal de que a Anthropic está formalizando padrões que a comunidade já praticava de forma improvisada.
- A mudança de isolamento de cache de organização → workspace (efetiva 5 fev 2026) é uma quebra silenciosa de comportamento para quem usa múltiplos workspaces — quem migra precisa revisar a estratégia de cache porque hits que existiam antes podem deixar de existir.

## Exemplos e evidências

- **Tabela de pricing por modelo** (preço por milhão de tokens): Opus 4.8/4.7/4.6/4.5 = $5 base / $6.25 (5m write) / $10 (1h write) / $0.50 (read) / $25 output; Opus 4.1/4 deprecated = $15/$18.75/$30/$1.50/$75; Sonnet 4.6/4.5/4 = $3/$3.75/$6/$0.30/$15; Haiku 4.5 = $1/$1.25/$2/$0.10/$5; Haiku 3.5 = $0.80/$1/$1.60/$0.08/$4.
- **Multiplicadores de pricing:** cache write de 5min = 1.25x o preço de input base; cache write de 1h = 2x; cache read = 0.1x.
- Exemplo de resposta de pre-warming completo com `usage.cache_creation: { ephemeral_5m_input_tokens: 5120, ephemeral_1h_input_tokens: 0 }`, `input_tokens: 8`, `cache_read_input_tokens: 0`.
- Exemplo de código Python completo com `prewarm_cache()` chamado no startup e `respond()` para requisições reais subsequentes.
- Exemplo de extended-thinking + tool use mostrando 3 requests sequenciais e como thinking blocks acumulam/persistem (ou não, dependendo do modelo) através delas.
- Lista de casos de uso ideais: prompts com muitos exemplos, grandes contextos/background, tarefas repetitivas com instruções consistentes, conversas multi-turn longas; e cenários otimizáveis: agentes conversacionais, coding assistants, processamento de documentos longos, sets de instruções detalhados (recomendação: 20+ exemplos de alta qualidade no prompt cacheado), uso agêntico de ferramentas, "talk to books/papers/docs/transcripts".

## Implicações para o vault

- **Esta é a documentação canônica que fundamenta** o conceito já existente [[03-RESOURCES/concepts/agent-systems/prompt-caching]] — confirma os números citados lá (cache reads ~10% do preço base, writes ~125%, TTL de 5 min) e adiciona uma camada de profundidade mecânica (hash cumulativo, lookback de 20 blocos, hierarquia de invalidação) que o concept atual não detalha.
- O concept do vault descreve "hot.md como cache anchor" — esta doc valida diretamente essa estratégia: "Place cached content at the prompt's beginning... Place the breakpoint on the last block that stays identical across requests." A receita "stable prefix first" do vault é literalmente a "Key takeaway" desta página oficial.
- **Possível atualização ao concept:** adicionar a explicação do "common mistake" (breakpoint em conteúdo variável) como um anti-padrão nomeado — é exatamente o tipo de erro que pode ocorrer silenciosamente em pipelines automatizados como o `pipeline-diario` se um timestamp ou ID dinâmico acabar antes do breakpoint.
- A nota sobre **isolamento de cache por workspace (fev/2026)** é nova informação que pode não estar refletida no concept atual — vale avaliar se o vault/Nexus opera em múltiplos workspaces da Anthropic (não parece ser o caso, mas é bom registrar).
- Conecta-se a [[03-RESOURCES/sources/mid-conversation-system-messages]], que é tratado nesta própria doc como a forma de adicionar instruções operacionais sem quebrar o cache — os dois documentos formam um par natural.
- Sem contradições com o concept existente — esta fonte é um aprofundamento e validação, não uma correção.

## Links
- [[03-RESOURCES/concepts/agent-systems/prompt-caching]]
- [[03-RESOURCES/sources/mid-conversation-system-messages]]
- [[03-RESOURCES/sources/pdf-support]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
