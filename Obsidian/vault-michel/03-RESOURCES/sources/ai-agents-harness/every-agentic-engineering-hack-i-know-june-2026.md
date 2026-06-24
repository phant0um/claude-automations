---
title: "Every Agentic Engineering Hack I Know (June 2026)"
type: source
source: "Clippings/Every Agentic Engineering Hack I Know (June 2026).md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

O autor (@mvanhorn) documenta 22 hacks práticos para Agentic Engineering — o uso profissional de agentes de IA (Claude Code + Codex) para ship software real. A tese central é que a engenharia tradicional (80% coding, 20% planning) deve ser invertida: o planejamento vai para planos estruturados que os agentes executam mecanicamente, enquanto o humano atua como "sinal de gosto" (direção, julgamento, curadoria) — não como mão de obra.

## Argumentos principais

- **Plan.md é o artefato central**: criar um `plan.md` antes de qualquer tarefa (via `/ce-plan`) é a regra número 1. O plano usa agentes de pesquisa em paralelo para investigar o codebase, soluções passadas e documentação externa, depois consolida abordagem, arquivos a tocar, critérios de aceitação e padrões.
- **O plano é para o agente, não para o humano**: o humano deve fazer o plano mas não necessariamente lê-lo integralmente — o plano disciplina o agente a não cortar atalhos. O humano interage via perguntas inline (TLDR, eli5).
- **`/ce-plan` serve para trabalho não-técnico também**: estratégia, análise competitiva, síntese de livros/transcrições — a técnica de "faça um plano para o plano" antes de executar elimina a preguiça do LLM.
- **Voice-to-LLM**: transcrição imperfeita funciona porque o modelo preenche as lacunas. Setup: Monologue ou Wispr Flow no Mac, ditado nativo no iOS.
- **Múltiplas sessões paralelas (cmux)**: 4-6 abas com tarefas diferentes simultâneas. Enquanto uma planej a, outra executa, outra corrige bugs.
- **Terminal padrão abrindo diretamente no Claude**: eliminar o custo de fricção de iniciar uma sessão aumenta drasticamente a quantidade de sessões iniciadas.
- **Email para o Claude (AgentMail)**: qualquer email enviado para um inbox dedicado abre uma nova sessão Claude Code e executa a tarefa descrita no assunto/corpo.
- **Dangerously Skip Permissions**: com 6 sessões paralelas, pedir confirmação para cada ação é inviável. `skipDangerousModePermissionPrompt: true` + hook de som quando termina.
- **Claude planeja, Codex executa**: dois $200/mês em paralelo como dois motores. Claude em planejamento e revisão, Codex em builds grandes paralelos.
- **last30days**: pesquisa paralela em Reddit, X, YouTube, HN, GitHub antes de qualquer plano. Grunda o plano em conhecimento atual da comunidade, não em dados de treino.
- **Transcrições Granola raw no contexto**: não resumir primeiro — jogar a transcrição completa (inclusive tangentes) e deixar o modelo extrair o que importa vs. o codebase e planos anteriores.
- **Human Signal**: com 6 agentes, o trabalho do humano é fornecer gosto, direção e o loop de react-and-redirect. O raro e valioso é o julgamento humano, não a digitação.
- **HyperFrames para vídeo**: vídeo como HTML que um agente escreve — mesmo loop que código, saída é MP4.
- **Notas como base de conhecimento do agente**: Bear, Obsidian, gbrain, supermemory apontados para o agente criam RAG pessoal composto.
- **Skills reutilizáveis**: qualquer workflow feito mais de 2x vira uma skill permanente — o agente aprende o shape de uma skill existente para criar a nova.
- **Remote work**: Mac mini em casa + Mosh + Tmux + remote control para trabalhar de qualquer lugar sem perder sessões.
- **Proof para compartilhar planos com colegas não-técnicos**: plano.md no Proof vira link com comentários inline que voltam para o loop do agente.
- **Open source via mesmo loop**: PRs reais em Python, Go, OpenCV e outros via `/ce-plan` + `/ce-work`.
- **AI Psychosis**: aviso honesto — construir com agentes vicia como um videogame. O perigo não é o launch vazio, é sumir no build e perder as pessoas ao redor.

## Key insights

- **Inversão do ratio planejamento/execução**: tradicional é 80% coding, 20% planning. Agentic Engineering inverte — o pensamento vai no plano, a execução é mecânica. Isso é a mudança fundamental.
- **O plano como checkpoint que sobrevive a context blowups**: se o contexto estourar, um novo session aponta para o plan.md e continua de onde parou. O plano é o estado persistente.
- **"Faça um plano para o plano"**: pedir ao LLM primeiro para planejar *como* vai produzir o deliverable (não o deliverable em si) elimina a preguiça. "Ask for the deliverable directly and it cuts corners. Ask it to first plan how it will produce the deliverable, then execute that plan, and it does the deep version every time."
- **Voice funciona com LLM porque o modelo preenche lacunas**: a transcrição não precisa ser perfeita — o receptor entende contexto e adivinha o que o microfone errou. Isso é diferente de voice-to-anything-else.
- **Agentes paralelos não exigem supervisão constante**: som como notificação quando sessão termina é não-negociável com 6 sessões. Walk away, come back when you hear it.
- **last30days como grounding em conhecimento atual**: usar pesquisa paralela antes de planejar evita que o plano se baseie em dados de treinamento de 6 meses atrás — ex.: decisão Vercel agent-browser vs Playwright baseada em threads da comunidade recentes.
- **Skills como compounding**: escrever uma skill uma vez faz cada sessão futura mais rápida — isso é o "compounding" do Compound Engineering. O autor tornou-se top contributor do próprio plugin por este loop.
- **Email como interface de agente**: AgentMail transforma email em trigger de sessão Claude — allowlist de segurança (DKIM/SPF), três componentes (daemon, backends, sender).
- **Printing Press**: frota de CLIs para serviços do mundo real (Tesla, Instacart, ESPN, Alaska Airlines) com autenticação via Agent Cookie (sessão real do browser). Agentic Engineering que executa tarefas da vida real, não só código.
- **Prova de que funciona**: last30days (27K stars), Printing Press (4K+ stars), Agent Cookie, top contributor em Python, Go, OpenCV — tudo em 2026 via este workflow.

## Exemplos e evidências

- **Bun rewrite** (mencionado indiretamente como referência de dynamic workflows): 750,000 linhas em 11 dias — validação de que agentic engineering faz projetos de quarter em dias.
- **Granola transcript → product proposal → hire**: transcrição de 90min de almoço jogada raw no Claude Code → proposta enviada na mesma noite → pessoa contratada full time.
- **PRs em projetos top**: Python (cpython), Go (golang/go), OpenCV, Vercel Agent Browser, Compound Engineering (#3), Superpowers (#3), GStack (#4), Paperclip (#4), Camoufox (#2).
- **last30days 27K stars**: começou como skill pessoal, virou open source.
- **Printing Press 4K+ stars, 320+ PRs**: factory de CLIs agent-native.
- **M5 Max 64GB RAM ainda esgota bateria em 1h** com 6 sessões + Codex rodando — validando a intensidade computacional do workflow.
- **Este artigo foi escrito via cmux + Monologue + Proof**: o próprio artigo é produto do workflow que descreve.

## Implicações para o vault

- Confirma e expande o conceito de skills em [[03-RESOURCES/concepts/ai-agents/agent-skills]] — especialmente o loop "skill aprende de skill existente".
- O conceito de plan.md como checkpoint de contexto complementa estratégias de context engineering documentadas em outros sources desta ingestão.
- A ideia de "human as signal" (gosto, direção, curadoria) é uma definição operacional útil do papel humano em sistemas multi-agente.
- Printing Press + Agent Cookie representam uma categoria nova: CLIs para tarefas da vida real, não só código — expande o escopo de "agentic engineering".
- Referência explícita a Obsidian como ferramenta de knowledge base do agente — relevante para o próprio vault-michel.

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-skills]]
- [[03-RESOURCES/concepts/ai-agents/context-engineering]]
- [[03-RESOURCES/concepts/ai-agents/multi-agent-orchestration]]
- [[03-RESOURCES/sources/lessons-from-building-claude-code-how-we-use-skills]]
- [[03-RESOURCES/sources/how-to-master-context-engineering-in-claude-code-5-patterns-and-13-steps-anthropic-engineers-use]]
