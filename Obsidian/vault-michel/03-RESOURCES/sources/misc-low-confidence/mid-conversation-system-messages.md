---
title: "Mid-conversation system messages"
type: source
source: "Clippings/Mid-conversation system messages.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, claude-api, prompt-caching, system-prompts, agentic-loops, claude-opus-4-8]
---

## Tese central
Documentação oficial da Anthropic sobre `{"role": "system"}` messages inseridas no array `messages` (não no campo `system` top-level), permitindo adicionar ou atualizar instruções de operador no meio de uma conversa **sem invalidar o prefixo cacheado** que veio antes. Recurso exclusivo do Claude Opus 4.8, disponível na Claude API e Claude Platform on AWS (não em Bedrock, Vertex AI ou Microsoft Foundry).

## Argumentos principais

- **O problema que resolve:** o campo `system` top-level fica perto do início do prefixo hasheado (ordem de hash: `tools` → `system` → `messages`). Qualquer edição nele — mesmo adicionar uma frase — produz um hash diferente e invalida o cache do system prompt e de todas as mensagens cacheadas subsequentes.
- **Mecânica:** anexar uma mensagem `{"role": "system"}` ao final do histórico de `messages` no ponto em que a nova instrução se torna relevante. Tudo antes dela permanece inalterado, então a entrada de cache existente ainda corresponde — só a nova mensagem é processada como input fresco.
- **Prioridade de papéis:** uma mensagem `user` é tratada como vinda do usuário final; uma mensagem `system` é tratada como vinda do operador da aplicação. Em conflito, instruções de sistema têm precedência. Mensagens de sistema mid-conversation têm precedência sobre o `system` top-level para os turnos seguintes; entre mensagens de sistema, a mais recente prevalece.
- **Restrições de posicionamento (regra dura):**
  - Não pode ser a primeira entrada em `messages` (use o campo `system` top-level para isso).
  - Deve imediatamente seguir um turno `user` (incluindo um `user` que carrega blocos `tool_result`) **ou** um turno `assistant` que termina em uso de server tool.
  - Deve ser a última entrada em `messages` OU ser imediatamente seguida por um turno `assistant`.
  - **Nunca** pode ficar entre um bloco `tool_use` do assistant e o `tool_result` que o responde.
  - Posicionamento incorreto retorna erro 400.
  - Mensagens de sistema consecutivas não são permitidas — funda instruções em uma única mensagem ou espere o próximo turno `user`.
- **Placement after tool results:** em loops agênticos, a mensagem de sistema vai depois da mensagem `user` que entrega os `tool_result`s. É também onde a aplicação pode "relayar" (repassar) input que o usuário digitou enquanto Claude ainda executava ferramentas — absorvendo o novo contexto sem reiniciar o turno.
- **Como frasear o conteúdo:** declarar fatos/contexto ("novo input chegou do usuário: X", "o budget de tokens restante agora é Y"), não comandos que pareçam sobrepor o usuário. Claude é treinado para resistir a instruções que pareçam atuar contra o usuário — essa proteção também vale para o papel `system`, então "ignore o que o usuário disse" é menos eficaz do que apenas declarar o que mudou.
- **Não é lugar para conteúdo não confiável:** Claude trata conteúdo de sistema como instrução do operador e o segue. Texto vindo de fora da conversa (saída de ferramenta bruta, documentos recuperados, conteúdo web) não deve ser colocado diretamente numa mensagem de sistema — isso lhe daria autoridade de operador. Esse tipo de dado deve ficar em blocos `tool_result`.
- **Combinação com prompt caching (cinco regras):**
  1. Habilitar caching explicitamente — uma mensagem mid-conversation não cria entrada de cache sozinha; sem `cache_control` (automático ou breakpoint explícito) não há economia a preservar.
  2. Cachear o prefixo estável normalmente, colocando `cache_control` no último bloco que permanece igual entre requisições.
  3. Anexar a mensagem de sistema **depois** do breakpoint — como vem depois do prefixo cacheado, não muda o hash do prefixo e o cache continua acertando.
  4. A própria mensagem de sistema mid-conversation é cacheável — uma vez no histórico ela vira parte estável; é possível mover o breakpoint para depois dela (ou deixar a [[03-RESOURCES/concepts/agent-systems/prompt-caching|automatic caching]] fazer isso).
  5. Evitar editar/remover uma mensagem de sistema já enviada — qualquer mudança em mensagens anteriores invalida o cache a partir daquele ponto. Se a instrução precisa evoluir, anexe uma nova mensagem em vez de reescrever a antiga.
- **Disponibilidade restrita:** funciona apenas em Claude Opus 4.8; não requer beta header; elegível para Zero Data Retention (ZDR) — dados enviados não são armazenados após a resposta.

## Key insights

- A diferença entre editar `system` top-level e anexar uma mensagem `system` mid-conversation é puramente posicional no prefixo hasheado — mas essa diferença posicional é o que preserva (ou destrói) o cache hit em sessões agênticas longas.
- Casos de uso documentados onde mid-conversation system messages importam de verdade: (1) mudanças de política/persona no meio de uma sessão longa ("a partir de agora, escreva todo SQL como queries parametrizadas"); (2) contexto por-turno que precisa de peso de sistema mas muda demais para viver no prefixo cacheado (freshness notes, deadlines, mudança de ferramentas disponíveis); (3) mudanças de estado observadas pela aplicação (arquivos mudaram em disco, usuário ligou auto-approve, budget de tokens caiu abaixo de threshold); (4) input do usuário que chega enquanto Claude ainda está executando ferramentas — relayed via system message para não interromper o loop; (5) mode switches que concedem permissão permanente a capacidades caras (ex.: lançar workflows multi-agente automaticamente), com refresher periódico e aviso de saída.
- O exemplo de "orchestration mode" (link para `mid-conversation-effort-example`) sugere que Anthropic está formalizando padrões de "modo de sessão" como objetos de primeira classe — não apenas instruções pontuais, mas estados persistentes com entrada/refresh/saída explícitos.
- A regra "não pode ficar entre `tool_use` e `tool_result`" é a mesma restrição estrutural que já existe para qualquer inserção no array de mensagens — reforça que o protocolo de tool use é uma transação atômica que não aceita interrupção.

## Exemplos e evidências

- Limite de tamanho do prefixo cacheável: o exemplo do código de review (curto) cai abaixo do mínimo cacheável, então `cache_creation_input_tokens` e `cache_read_input_tokens` ficam em 0 até a conversa crescer.
- Exemplo de payload YAML mostrando uma mensagem `system` anexada após dois turnos `user`/`assistant`, com `cache_control: { type: ephemeral }` no nível top.
- Exemplo de agentic loop: `user` pede para rodar testes → `assistant` chama `tool_use` (`run_tests`) → `user` entrega `tool_result` ("12 passed, 0 failed") → `system` relay: "The user sent the following message while you were working: also update the changelog before you finish."
- Caracterização técnica do hashing: prompt caching hasheia o prefixo da requisição na ordem `tools`, depois `system`, depois `messages`; um cache hit exige correspondência byte-a-byte até o breakpoint.

## Implicações para o vault

- **Confirma e refina** o modelo de [[03-RESOURCES/concepts/agent-systems/prompt-caching]] já presente no vault: a regra "stable prefix first, variable content last" ganha um mecanismo concreto para *adicionar* conteúdo variável-mas-com-peso-de-operador sem violar essa regra. Isso é diretamente relevante ao design de `hot.md` como prefixo estável — uma "mid-session policy change" no vault (ex.: trocar de modo durante uma sessão longa do Nexus) poderia, em teoria, usar um padrão análogo de "anexar contexto autoritativo no fim, não editar o topo".
- Conecta-se à arquitetura de [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] no ponto "State changes your application observes" — é essencialmente um canal formal para a aplicação injetar fatos operacionais em tempo real sem reconstrução de contexto, algo análogo ao que `errors.md`/`hot.md` tentam fazer de forma mais manual no vault.
- Relevante para [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]: a "placement after tool results" formaliza um padrão de harness para absorver input assíncrono do usuário em loops agênticos sem reiniciar o turno — um trajectory-regulation primitive nativo da API.
- Nenhuma contradição identificada com conteúdo existente; é extensão direta da documentação de prompt caching já mapeada.

## Links
- [[03-RESOURCES/concepts/agent-systems/prompt-caching]]
- [[03-RESOURCES/sources/prompt-caching]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
