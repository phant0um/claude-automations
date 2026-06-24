---
title: "Autoresearch your way into improving your models + harness. How we beat reported SOTA results"
type: source
source: "Clippings/Autoresearch your way into improving your models + harness. How we beat reported SOTA results.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, harness-engineering, autoresearch, model-tuning, benchmarks, occams-razor]
---

## Tese central
Todo sistema agêntico é, na verdade, duas coisas empilhadas — um modelo e o harness ao redor dele (prompts, scaffold, skills, forma de extrair e checar respostas) — e ambos são "espaços de parâmetros" que decidem o desempenho do sistema. A maioria dos sistemas de autoresearch otimiza apenas um dos dois (harness OU pesos, raramente ambos no mesmo loop, contra o mesmo objetivo). O **evo** (orquestrador open-source de autoresearch, agora em v0.5) ataca os dois ao mesmo tempo — e, ao apontar essa busca dupla para o benchmark LawBench, não só bateu o recorde "viral" anterior como descobriu que a melhor solução **não usa LLM nenhum**.

## Argumentos principais
- **Framing central — "leverage = base model × harness × a verifiable loop"**: três fatores multiplicativos. Por anos, só o primeiro (modelo) se movia em qualquer cadência — um novo modelo saía e tudo a jusante mudava junto. Os outros dois eram seus, mas difíceis de mover sistematicamente. Um loop auto-aperfeiçoável é o que os faz mover: apontá-lo para o harness e os pesos, contra um objetivo verificável, "trabalha o produto inteiro em vez de um fator dele".
- **O que é o evo**: orquestrador de autoresearch open-source. Você dá a ele um sistema, uma definição de "melhor" e um orçamento. Ele gera hipóteses, roda cada uma em seu próprio workspace isolado, pontua o resultado e mantém uma árvore de tentativas — estendendo o que funciona, podando o que não funciona — enquanto um **auditor** checa cada mudança aceita para que o otimizador não consiga "trapacear" a métrica (gaming the metric).
- **evo v0.5 — a virada**: agora o loop faz as duas coisas no mesmo run, contra o mesmo objetivo, decidindo sozinho onde gastar o orçamento — pode fazer fine-tuning de pesos do modelo (SFT, LoRA, RL) **e** reescrever o harness (prompts, scaffold, skills) como movimentos no mesmo tabuleiro.
- **Por que querer os dois ao mesmo tempo**: "o modelo e o harness se cobrem mutuamente". Uma falha que você tentaria resolver com um treino pode ser mais barata de corrigir com um prompt melhor ou um passo de retrieval — e às vezes é o oposto. Você raramente sabe de antemão qual caminho é o certo; só a busca sistemática revela.
- **O teste escolhido — LawBench**: tarefa simples de enunciar (ler um caso criminal chinês e escolher a acusação certa, 1 de 191 opções), mas difícil de resolver bem. Um startup bem financiado havia viralizado no X com seu sistema "auto-aperfeiçoável" reportando **0.701** — conseguido treinando os pesos de um modelo aberto de 120B. O evo replicou exatamente o setup publicado pelo concorrente (mesmo benchmark, mesma divisão treino/teste, mesmo grader, mesmo modelo de 120B disponível para treinar) — "no head start for evo: just the cases, the grader, and one instruction - get the highest score, any way you can."
- **Occam's razor encontrado por busca, não assumido a priori**: o evo de fato tentou o caminho caro — fez fine-tuning do modelo de 120B, com múltiplos runs de LoRA. Os ganhos não apareceram: o modelo fine-tuned sozinho pontuou baixo, e toda tentativa de se apoiar nele apenas regrediu para o resto do pipeline. O evo então **podou** essa abordagem e chegou a uma "lean classical pipeline" — sem LLM, rodando em máquina de baixo desempenho, sem GPU.
- **A conclusão chave**: "evo doesn't decide up front where the score will come from. It searches across the whole space — model and harness — and returns the best solution it finds, not the flashiest." Aqui isso significou pular o fine-tune de 120B que todo mundo tenta primeiro, e enviar um classificador simples que pontuou mais alto.
- **Compromisso com abertura**: evo, o benchmark, o grader, o harness vencedor e o run completo estão todos publicados — incluindo um dashboard ao vivo com cada experimento e cada hipótese tentada, no mesmo formato de uma divulgação anterior do autor.
- O autor convida quem quiser montar loops de autoresearch similares na própria organização a entrar em contato (hello@evo-hq.com), e agradece a @vishnuvig e jarvislabs.ai pela ajuda com computação.

## Key insights
- **A descoberta mais contra-intuitiva**: a solução vencedora não tem LLM dentro — um pipeline clássico, leve, roda numa máquina sem GPU — e isso só foi descoberto porque o sistema buscou no espaço inteiro (modelo + harness) em vez de assumir de antemão "isso é um problema que se resolve treinando um modelo grande".
- **Evidência empírica direta de que "ajustar o harness pode bater treinar pesos"** — uma confirmação prática e mensurável da tese de que harness engineering é, muitas vezes, mais alavancável que model engineering, e que a busca sistemática (não a intuição do engenheiro) deveria decidir onde investir o orçamento.
- **O papel do "auditor"**: cada mudança aceita pelo loop passa por uma checagem de um auditor separado, especificamente para impedir que o otimizador "jogue" (game) a métrica — um padrão de governança que ecoa o "gate" descrito no artigo da Anthropic sobre as quatro camadas de auto-aperfeiçoamento (ver [[03-RESOURCES/sources/anthropic-says-claude-writes-80-of-its-code-here-are-4-layers-and-7-st]]).
- **A métrica de leverage como produto, não soma** (`base model × harness × verifiable loop`) é um framing memorável e citável: implica que melhorar qualquer um dos três fatores por si só tem retorno limitado, e que o ganho composto vem de mover todos simultaneamente contra um objetivo verificável.
- **evo é host-agnóstico**: funciona através de Claude Code, Codex, Cursor e outros hosts — outro ponto de convergência com a tese de "harness portável" presente nos outros três artigos do batch.

## Exemplos e evidências
- Tabela de scores no benchmark LawBench (escolher 1 de 191 acusações possíveis a partir de um caso criminal chinês):
  - **0.173** — agente simples, sem ajuste (plain agent, no tuning)
  - **0.450** — recorde anterior
  - **0.701** — lançamento "viral" do sistema concorrente (após treinar um modelo de 120B)
  - **0.776 (0.7766)** — evo, novo recorde
- O evo rodou **40 experimentos** sozinho: escolheu abordagens, construiu, pontuou, ramificou o que funcionou, repetiu — fez fine-tuning do modelo de 120B, construiu e ajustou uma série de classificadores, e os colocou em uma árvore de busca competitiva, mantendo vencedores e podando o resto.
- evo é open source: [github.com/evo-hq/evo](https://github.com/evo-hq/evo); o benchmark e grader também estão publicados, junto com "the full run" em uma página compartilhada (evo-hq.com/shared).
- O artigo refere-se a uma divulgação anterior do mesmo autor sobre para onde o evo estava indo — confirmando que a v0.5 (capacidade dupla modelo+harness) era um roadmap anunciado que se concretizou.

## Implicações para o vault
- Reforça e fornece evidência empírica concreta para [[03-RESOURCES/concepts/agent-systems/harness-adaptation]] e [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]]: aqui há um caso real, mensurável e auditável onde otimizar o harness (e até remover o modelo) superou o caminho de "treinar um modelo maior".
- Conecta diretamente com [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]] e [[03-RESOURCES/sources/anthropic-says-claude-writes-80-of-its-code-here-are-4-layers-and-7-st]] — ambos descrevem loops "propose → score/validate → keep or discard", aqui chamado de "hypothesis → isolated run → score → tree of attempts pruned/extended", com um "auditor" no papel do gate.
- O framing `base model × harness × verifiable loop` é candidato a ser referenciado em [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]] e [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]] como uma fórmula sintética da "alavancagem" de um sistema agêntico.
- O achado "Occam's razor found by search" é um contraponto valioso à narrativa comum de "modelo maior = melhor": vale como exemplo concreto em qualquer página sobre [[03-RESOURCES/concepts/agent-systems/floor-raising-vs-benchmark-maxing]] — buscar a solução mais simples que vence, não a mais sofisticada.
- evo sendo host-agnóstico (Claude Code, Codex, Cursor) reforça o padrão de "harness portável" que aparece também em [[03-RESOURCES/sources/anthropic-says-claude-writes-80-of-its-code-here-are-4-layers-and-7-st]] (loop self-evolving funcionando em Claude Code/Codex/Hermes/OpenClaw) e em [[03-RESOURCES/sources/build-an-orchestration-mode]].
- Não foram encontradas contradições diretas com páginas existentes — o achado complementa, em vez de contradizer, [[03-RESOURCES/concepts/agent-systems/agentic-rl]] (já que o evo testou e descartou RL/fine-tuning como caminho vencedor para esse caso específico, sem refutar sua utilidade geral).

## Links
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
- [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/floor-raising-vs-benchmark-maxing]]
- [[03-RESOURCES/sources/anthropic-says-claude-writes-80-of-its-code-here-are-4-layers-and-7-st]]
- [[03-RESOURCES/sources/build-an-orchestration-mode]]
