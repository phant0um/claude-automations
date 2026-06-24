---
title: "Context Engineering for AI Agents: The Complete Playbook"
type: source
source: "Clippings/Context Engineering for AI Agents The Complete Playbook.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Agentes de IA degradam após ~10-15 passos não porque o modelo piorou, mas porque o que o modelo *vê* degradou — fenômeno chamado context rot. Context engineering (organizar o que o modelo vê) é descrito como "o trabalho", não um extra: prompt engineering é um subconjunto dele. O artigo consolida quatro estratégias (Write, Select, Compress, Isolate) e quatro modos de falha (Poisoning, Distraction, Confusion, Clash) que cobrem todas as técnicas de context engineering existentes.

## Argumentos principais
- Analogia da LangChain: o modelo é a CPU, a janela de contexto é a RAM. Assim como o computador desacelera quando a RAM enche, o raciocínio do agente degrada quando a janela de contexto fica cheia.
- Estudo da Chroma avaliando 18 modelos de fronteira (GPT-4.1, Claude 4, Gemini 2.5, Qwen3, outros): todos degradam conforme o input cresce, e a degradação começa bem antes do limite — não é um "penhasco", é um declínio contínuo (ex: janela de 200K tokens pode mostrar degradação significativa já em 50K).
- O problema "Lost in the Middle": LLMs têm uma curva de atenção em U — início e fim do contexto são bem lembrados, o meio é largamente ignorado. Pesquisadores mediram queda de acurácia >30 pontos percentuais quando a informação relevante se move do início para o meio do contexto. Usuários de Claude Code relatam degradação de qualidade em 40-60% da capacidade do contexto — bem antes de qualquer limite duro.
- Sete categorias competem pela mesma janela finita: system prompt, definições de ferramentas, resultados de chamadas de ferramentas, conhecimento recuperado (RAG), histórico de conversação, memória (curto e longo prazo), estado do agente (plano atual, todo list, scratchpad). Context engineering é decidir quem vence.

## Key insights

### As 4 estratégias (framework da LangChain)
1. **Write** — dar ao agente formas de persistir informação fora da janela de contexto, porque se a informação não foi escrita antes da compactação, ela se perde para sempre. Três formas: *scratchpads* (ferramenta de notas durante a tarefa — a "think tool" da Anthropic melhorou performance em até 54% em certas tarefas no benchmark tau-bench); *rules files* (memória procedural persistente, ex: CLAUDE.md, lido a cada sessão, nunca esquece os fundamentos); *memory extraction* (fatos, preferências e padrões aprendidos salvos entre sessões, fora da janela de contexto inteiramente).
2. **Select** — não dar tudo ao agente, dar o que ele precisa agora. RAG tradicional: o sistema decide (busca → injeta no prompt → estático, one-shot). RAG agêntico: o agente decide (busca, refina queries, escolhe ferramentas, determina quando tem informação suficiente — processo iterativo). O problema de seleção de ferramentas é o que mais trava as pessoas: agente com 40+ ferramentas pode ter 10.000 tokens de definições de ferramentas em contexto antes de qualquer trabalho começar. Fix: RAG sobre descrições de ferramentas (busca semântica para mostrar só as relevantes ao passo atual) — o paper RAG-MCP testou isso e mediu acurácia de seleção de ferramenta subindo de 14% para 43% (3x), com uso de tokens cortado pela metade. Anthropic chama isso de estratégia híbrida: carregar contexto essencial antecipadamente (CLAUDE.md) e fazer recuperação just-in-time para o resto.
3. **Compress** — mesmo com boa seleção, contexto acumula; comprimir em 3 pontos: antes de entrar no contexto (chunkar documentos grandes, rerank para só os chunks mais úteis entrarem, resumir outputs de ferramentas on-the-fly); enquanto o agente trabalha (resumo rolante do histórico — padrão popular: manter as últimas 10 mensagens verbatim + resumir tudo mais antigo; trimming forçado ao atingir limiar de tamanho; Claude Code auto-compacta a 95% da capacidade, preservando decisões arquiteturais e os 5 arquivos mais recentemente acessados); depois que o agente já agiu sobre algo (limpar resultado de ferramenta usado há 15 passos, substituir por resumo de uma linha ou remover — o agente não precisa do texto completo de uma página web buscada 20 passos atrás).
4. **Isolate** — a estratégia mais poderosa; o problema não é só espaço, é contaminação (buscas detalhadas da fase de pesquisa ainda sentadas em contexto quando o agente passa para escrever código tornam-se ruído distraindo o modelo). Subagentes: agente pai delega subtarefa focada a um subagente, que trabalha em janela limpa própria e retorna apenas um resumo condensado — toda a sujeira da busca fica isolada e nunca poluiu o pai. State schema isolation (abordagem do LangGraph): desenhar o estado do agente para que campos diferentes guardem tipos diferentes de contexto, e o LLM só vê os campos relevantes ao passo atual; resultados de ferramentas ficam num campo "backstage" invisível até serem explicitamente exibidos.

### Os 4 modos de falha (Drew Breunig)
1. **Context Poisoning**: uma alucinação ou erro entra em contexto e o agente referencia repetidamente, compondo a partir do erro do passo 5 em todo passo seguinte. Fix: validar outputs de ferramenta antes de entrarem em contexto; após recuperar de um erro, comprimir o histórico da tentativa fracassada (não deixar 10 passos de debug visível quando só a resolução importa).
2. **Context Distraction**: contexto fica tão longo que o modelo passa a depender excessivamente do histórico recente, repetindo em vez de sintetizar um plano novo. Fix: resumir e cortar agressivamente, mesmo com janela grande disponível — janela grande não significa enchê-la.
3. **Context Confusion**: conteúdo superfluo leva a decisões de baixa qualidade — exemplo citado: modelo falhando num benchmark com 46 ferramentas (mesmo dentro do limite de contexto) mas funcionando bem com apenas 19 — as ferramentas não eram demais para o contexto reter, eram demais para o modelo raciocinar claramente. Fix: gerenciamento dinâmico de ferramentas via RAG-MCP.
4. **Context Clash**: informação nova contradiz algo já em contexto (ex: system prompt diz uma coisa, documento recuperado diz outra) e o agente não consegue reconciliar, produzindo comportamento inconsistente. Fix: estabelecer ordem clara de autoridade (system prompt > fatos recuperados > histórico de conversação), validar informação nova contra contexto existente antes de injetar, usar tags XML/headers claros.

### System prompts para agentes (não chatbots)
- Prompt de chatbot define tom; prompt de agente define arquitetura — control flow, qual ferramenta usar quando, o que fazer em erro, quais guardrails seguir. Mais próximo de "job description para empregado autônomo" que personalidade.
- Anthropic chama de escrever na "altitude certa": prescritivo demais ("se billing E reembolso E valor>$100, chame ferramenta X") é frágil e quebra em todo edge case não previsto; vago demais ("seja útil e use as ferramentas apropriadas") não dá nada ao agente para decidir bem. O ponto certo: específico o bastante para guiar comportamento autônomo, flexível o bastante para julgamento em situações novas — heurísticas fortes, não regras rígidas.
- Dicas práticas: organizar com XML tags/markdown headers (Background, Instructions, Tool Guidance); começar minimal e iterar sobre falhas; "minimal não significa curto" — um system prompt complexo pode ter milhares de tokens, desde que cada token ganhe seu lugar; usar few-shot examples em vez de tentar descrever toda regra em palavras.

### KV-Cache: a razão financeira para se importar com ordem de contexto
- Se o prefixo do contexto (início) permanece igual entre chamadas de API, o provedor reusa a computação cacheada e só processa os tokens novos no final — rápido e barato. Reordenar ou mudar a parte inicial do contexto invalida o cache, forçando recomputação total.
- Diferença de custo no Claude Sonnet: tokens de input cacheados $0.30/milhão vs. não-cacheados $3.00/milhão — diferença de 10x. Para um agente fazendo 30-40 chamadas de API por tarefa, isso acumula rápido.
- Regras práticas: conteúdo estável no TOPO do contexto (system prompt, definições de ferramentas — qualquer coisa que não muda entre turnos); conteúdo dinâmico no FUNDO (histórico de conversação, passo atual, estado do agente); não adicionar/remover ferramentas dinamicamente no meio da conversa (invalida o cache) — usar **tool masking** em vez de remoção (manter todas as definições estáveis no prefixo cacheado, só marcar as irrelevantes como indisponíveis para a fase atual).

### O workflow de "Frequent Intentional Compaction" (Dex Horthy, CEO HumanLayer)
- Apresentado no AI Engineer Code Summit; time relatou shippar ~35.000 linhas de código para um codebase Rust grande numa sessão de 7 horas.
- Método: estruturar o trabalho do agente em fases; cada fase produz um artefato compactado; cada fase nova começa com janela de contexto fresca contendo só aquele artefato. Permanecer deliberadamente abaixo de 40-60% da janela de contexto sempre.
- **Fase 1 — Research**: subagentes exploram o codebase, leem arquivos, traçam fluxos de dados, mapeiam arquitetura (tudo fica isolado em contexto de subagente, nunca toca o pai = Isolate). Output: um `research.md` compacto — paths de arquivo, assinaturas de função, padrões, gotchas (Write). Reset de contexto: pesquisa bruta usou 60-80% da janela; o artefato de pesquisa comprime para 15-20% (Compress).
- **Fase 2 — Planning**: janela nova contendo só o documento de pesquisa + definição do problema; agente produz plano de implementação detalhado — este é o checkpoint de revisão humana mais importante (pegar erros de lógica aqui é fácil e grátis; depois custa horas).
- **Fase 3 — Implementation**: outra janela fresca contendo só o plano; agente segue passo a passo; para tarefas complexas, um `progress.md` rastreia o que foi completado e o que resta (Write).

### Como plataformas diferentes lidam com isso
- **Claude Code**: retrieval híbrido — CLAUDE.md carrega antecipadamente, glob/grep fazem navegação just-in-time do codebase; auto-compactação a 95% preservando decisões arquiteturais e os 5 arquivos mais recentes; pode gerar subagentes para subtarefas complexas, cada um com contexto limpo próprio. Filosofia: "fazer a coisa mais simples que funciona."
- **Manus**: ordenação de contexto KV-cache-aware (prefixo estável, sufixo dinâmico), tool masking em vez de remoção; pipeline de compressão de observação (todo output de ferramenta processado antes de entrar no contexto do agente); todo list persistente para rastreamento de estado; sistema de arquivos como memória de overflow para contexto despejado. Construído para escala (centenas de milhares de usuários).
- **ChatGPT Agent**: abordagem visual-primeiro — agente interage com GUI de navegador, screenshots adicionados como snapshots visuais; tokens visuais são caros, então o agente é seletivo sobre quantidade de screenshots; usa RL para aprender estratégias ótimas de uso de ferramenta através de milhares de máquinas virtuais em vez de programar explicitamente.
- **Google ADK**: abordagem arquitetural mais principiada — três princípios: separar armazenamento de apresentação (estado durável ≠ o que aparece em cada chamada de API); transformações explícitas (processadores nomeados, ordenados, testáveis e composíveis que transformam contexto); escopar contexto por padrão (toda chamada de modelo vê só o mínimo necessário de informação). Disciplina de engenharia sobre artesanato de prompt.

### O pipeline universal de turno de agente
Toda plataforma seria converge no mesmo loop de 5 passos por turno: **Collect** (input do usuário, histórico, resultados de ferramenta, docs recuperados, estado do agente) → **Select** (o que é relevante para este passo dentro do orçamento de tokens restante) → **Compress** (resumir, truncar, ou reestruturar para caber) → **Arrange** (conteúdo estável primeiro para cache, dinâmico por último) → **Assemble + call** (contexto final → chamada de API → output → loop).

## Exemplos e evidências
- Estudo Chroma: 18 modelos de fronteira, todos degradando antes do limite duro.
- Paper RAG-MCP: seleção de ferramenta 14%→43% de acurácia, tokens cortados pela metade.
- "Think tool" da Anthropic: +54% de performance em tarefas específicas no tau-bench.
- KV-cache: $0.30/milhão (cacheado) vs $3.00/milhão (não-cacheado) no Claude Sonnet — 10x.
- Caso Dex Horthy/HumanLayer: 35.000 linhas de código em 7 horas via Frequent Intentional Compaction.

## Implicações para o vault
Esta é a fonte mais densa e completa do batch sobre context engineering — consolida e amplia substancialmente os concepts já existentes `context-engineering`, `context-rot`, `context-rotation` e `kv-cache-llms`, adicionando o framework de 4 estratégias (Write/Select/Compress/Isolate) e os 4 modos de falha de Drew Breunig que ainda não estavam documentados explicitamente nesses concepts. O caso Dex Horthy/Frequent Intentional Compaction é um padrão prático aplicável diretamente ao próprio workflow do Nexus (pipeline de ingestão em fases F1-F2-F3 já segue uma lógica similar de "fresh context per phase").

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]]
- [[03-RESOURCES/concepts/learning-cognition/context-rotation]]
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-subagents]]
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/anthropic]]
