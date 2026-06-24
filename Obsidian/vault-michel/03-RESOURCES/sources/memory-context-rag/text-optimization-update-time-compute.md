---
title: "We Should Take Text Optimization More Seriously"
type: source
source: "Clippings/We Should Take Text Optimization More Seriously.md"
url: "https://yoonholee.com/blog/2026/we-should-take-text-optimization-more-seriously/"
author: "Yoonho Lee (@yoonholeee)"
published: 2026-06-08
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents, text-optimization, harness-engineering, scaling-laws, memory-architecture, prompting]
---

# We Should Take Text Optimization More Seriously

**Autor:** Yoonho Lee (@yoonholeee)
**Publicado:** 2026-06-08

## Tese central

Há um sentimento negativo comum entre pesquisadores de ML em relação a prompting / "text optimization" — a visão dominante é "real learning happens in the weights". O autor argumenta que **a camada de texto mutável ao redor de um modelo (prompts, contexto, filesystem state, memória, retrieval databases, código de harness) deveria ser levada tanto a sério quanto otimização de pesos**, com base em três pilares: (1) text optimization é um mecanismo de update legítimo, funcionalmente equivalente a gradient-based weight optimization; (2) é muito mais sample-efficient, especialmente em regime de baixo dado; (3) habilita um **novo eixo de scaling: "update-time compute"**.

## Argumentos principais

1. **Text optimization tem o mesmo papel funcional que weight optimization**: ambos mudam comportamento futuro em resposta a nova informação. A diferença é onde o estado vive — pesos (via gradiente) vs. texto (prompts, memórias, índices de retrieval, código de harness).

2. **Sistemas de IA deployados são máquinas stateful complexas**, não apenas um vetor de parâmetros consultado isoladamente. Pesos são apenas um dos estados condicionantes de comportamento; prompts, memórias, retrieval indices e código de harness são outros, com custos, capacidades e modos de falha diferentes. **A pergunta certa é um problema de roteamento**: qual alvo de update é o mais apropriado para cada peça de informação?

3. **Vantagem de inductive bias / compressão (Kolmogorov)**: especificações de texto curtas e de alta verossimilhança que explicam muitos casos têm baixo description length → bom prior indutivo. Empiricamente, text optimization é ordens de magnitude mais sample-efficient em regime de poucos dados (citando GEPA e outros).

4. **Padrão recorrente em escala**: usar a camada de texto para "elicitar e compor" capacidades existentes do modelo, depois **destilar isso para os pesos ao longo do tempo** (exemplos citados: Anthropic's Claude Constitution, OpenAI deliberative alignment, Cursor, Letta context-constitution, Hippocratic AI Polaris-3, Harvey/NVIDIA Nemotron continual agent learning).

5. **Update-time compute como novo eixo de scaling**. Assim como inference-time scaling permite gastar mais compute para resolver uma instância, **reflective text optimization** (Reflexion, Trace, GEPA, Meta-Harness) permite que um sistema gaste mais compute aprendendo de uma única experiência. Uma trajetória falha pode ser relida, diagnosticada, abstraída, testada contra revisões candidatas, e convertida em um update proposto. **SGD não consegue fazer isso barato** — seu vetor de parâmetros único commita cada update, sem forma fácil de "fork and compare" hipóteses. Texto-space learning é especialmente útil quando: (1) falhas são caras, (2) o comportamento desejado é difícil de especificar, ou (3) há trace data offline abundante que não funciona bem com SFT/offline RL.

6. **Rebuttals aos argumentos pró-pesos** (formato "strongest argument + counterpoint"):
   - *"Pesos dão amortização (não precisa carregar a especificação toda em todo context window)"* → Concordância parcial: certas infos (ex: aritmética básica) devem estar nos pesos. Mas o framing certo é roteamento: pesos = info estável e repetidamente útil; texto = info que é volátil, local, auditável, ou ainda não confiável o suficiente para amortizar (ex: contexto dinâmico de busca, preferências de usuário). Além disso, sistemas bons de texto implementam **progressive disclosure** (RAG, MemGPT, RLM, Anthropic dynamic workflows, Meta-Harness) — não despejam tudo no contexto. 1% de um contexto de 1M tokens = 10K tokens (>3 cópias deste post). E mesmo info "amortizável" não precisa ser amortizada *imediatamente* — a camada de texto é um "staging ground" para hipóteses antes de comitá-las ao modelo.
   - *"Treinar pesos cria novos circuitos neurais; texto só elicita comportamento existente, há um teto"* → Concordância parcial (modelo fraco dá pouco para text optimization trabalhar), mas esse teto não é exclusivo de text optimization (mesmo argumento já feito contra RL). Muitos sistemas são bottlenecked não por capacidade latente, mas por **se o sistema consegue elicitar e compor** esse comportamento de forma confiável. A pergunta prática é o headroom entre capacidade latente e comportamento efetivamente exibido — empiricamente esse headroom é significativo (RAG, test-time scaling, tool-use agents).
   - *"Existence argument: cérebro humano é inteligente só com pesos"* → Argumento simétrico: olhe para **toda a escrita humana** (livros, papers, código) — representações externas amplificam muito a inteligência humana. Cognition in the Wild (Hutchins) e The Extended Mind (Clark & Chalmers) — fronteira do sistema cognitivo se estende além do estado interno de um componente. Linhagem: Memex (Vannevar Bush) → Notion/Obsidian como tentativas modernas.
   - *"Text optimization é vulnerável a benchmark leakage e folk theories ('let's think step by step', 'take a deep breath', personas, threats/tipping)"* → São exemplos de marketing fraco do campo, não o problema de pesquisa subjacente. A facilidade de tinkering (qualquer um edita uma instrução e declara vitória com cherry-picking) é argumento para **estudar text optimization mais rigorosamente**, não para descartá-la.
   - *"Gradient descent tem teoria de convergência; text optimization é heuristic hill-climbing"* → Convergência só garante minimizar a proxy loss, não que a proxy capture o que importa. RL post-training é notoriamente instável e propenso a overfitting na proxy. Text-layer edits aplicam pressão de otimização mais fraca mas permanecem **altamente auditáveis e composáveis**.
   - *"Redes neurais são universal function approximators"* → Capacidade representacional não é o ponto certo; o que importa é **reachable behavior** — comportamentos de alta verossimilhança sob o prior implícito. Harnesses executam comportamentos que não esperaríamos de um forward pass único de um modelo congelado.
   - *"Artefatos de texto não são portáteis — quebram no próximo checkpoint"* → A comparação relevante é com outros artefatos de update: um weight delta treinado para uma arquitetura geralmente **não é portável de jeito nenhum**. Texto carrega significado entre modelos.

7. **Pendulum overcorrection**: a visão "weights are the only serious home for knowledge" é uma reação à era do GOFAI/physical symbol system hypothesis (Newell & Simon, Haugeland) — mas cognição humana depende rotineiramente de artefatos externos. Prática científica é a comparação útil: ciência constrói representações compactas do mundo (abstrações, teoremas, modelos causais) que podem ser criticadas, comparadas com nova evidência, revisadas, aplicadas a novos casos — **valor vem em grande parte da externalização**. Atualizar artefatos de texto é "aprender" no mesmo sentido que revisar uma teoria científica é aprender.

## Key insights

- **"Text artifacts are slightly more portable [than weight deltas]"** — contraintuitivo dado a percepção comum de fragilidade de prompts entre modelos.
- **Compute budgets para text optimization são ordens de magnitude menores que para weight post-training** — abertura para "scaling laws" de text optimization (autor especula que um "Wikipedia-scale knowledge/harness layer otimizado contra performance mensurável de model-system" poderia ser um startup).
- Direções de pesquisa propostas: análise teórica (PAC-Bayes em prompts), melhores evals (CL-bench, TerminalBench-2), "architecture research" do design space (instruction hierarchy, DSPy, agent skills, OpenClaw, memory systems), HCI research para "verbal fine-tuning" sessions com domain experts.

## Exemplos e evidências

- Citações empíricas de sample-efficiency: arXiv 2103.08493, 2012.15723, 2507.19457 (GEPA).
- Reflective learning: Reflexion (2303.11366), Trace (2406.16218), GEPA (2507.19457), Meta-Harness (2603.28052) — Apêndice A.2 do Meta-Harness tem exemplo real de hypothesis-testing behavior.
- Progressive disclosure: RAG (2005.11401), MemGPT (2310.08560), RLM (2512.24601), Anthropic dynamic workflows.

## Implicações para o vault

1. **O vault inteiro É uma instância de text optimization / update-time compute** — `04-SYSTEM/wiki/errors.md`, `MEMORY.md`, skills, e CLAUDE.md são "compact patches a um pretrained world prior" que evoluem via reflective learning, sem retraining de pesos. Esse paper dá fundamentação teórica direta para `[[03-RESOURCES/concepts/pkm-obsidian/self-writing-vault]]` e `[[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]]`.
2. **Routing pesos vs. texto** mapeia para a decisão "o que vai pra CLAUDE.md/skill (estável, repetidamente útil) vs. o que fica em memory/sessions (volátil, local, não amortizado)" — formaliza uma heurística que o vault já usa implicitamente.
3. **Progressive disclosure** já é um conceito-chave do vault (`[[03-RESOURCES/concepts/pkm-obsidian/progressive-disclosure]]`) — este paper fornece o argumento teórico de por que isso funciona (1% de 1M tokens = 10K tokens úteis).
4. Reforça `[[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]]` — "text-space learning" como gradient descent análogo no espaço de texto.

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/self-writing-vault]]
- [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]]
- [[03-RESOURCES/concepts/pkm-obsidian/progressive-disclosure]]
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/effective-feedback-compute]]
