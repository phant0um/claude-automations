---
title: "PM OS v2: The Memory Loop"
type: source
source: "Clippings/PM OS v2 The Memory Loop.md"
url: "https://x.com/nurijanian/status/2053364576369172940"
author: "@nurijanian"
published: 2026-05-10
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central

PM OS (sistema de IA para Product Managers) v1-1.8 ajuda a pensar e produzir artefatos (PRDs, strategy docs, críticas de planos), mas sofre de um failure mode: depois que uma reunião muda o projeto, a próxima sessão de IA "começa do mundo antigo" — não sabe o que mudou. PM OS v2 introduz um **loop de memória** com três funções: (1) decidir o que merece virar memória, (2) aprender lentamente contexto de fundo faltante, e (3) usar a fatia certa de memória antes de ajudar de novo. O objetivo não é "a IA lembra de tudo", mas "a IA lembra das partes do trabalho de produto que merecem memória".

## Argumentos principais

- **O problema do v1**: artefatos (PRDs, docs de estratégia) ficam presos no momento em que foram criados. Quando uma decisão de liderança muda o roadmap (ex.: "matar feature X, focar em Y até Q3"), a próxima sessão de IA não sabe disso — usuário tem que recontextualizar manualmente toda vez.
- **Os três trabalhos da memória de agente**:
  1. Decidir o que merece virar memória.
  2. Aprender lentamente o contexto de fundo faltante.
  3. Usar a fatia certa de memória antes de ajudar de novo.
- **Contexto escapa pelas frestas**: motivo de uma mudança de roadmap, preocupação de um stakeholder que suavizou uma recomendação, premissa que o time passou a carregar, risco que todos concordaram ser real mas ninguém escreveu, pergunta em aberto que deveria voltar antes da próxima decisão. Essas são as partes que importam depois e que se perdem em notas de reunião, threads de Slack, transcrições, docs de estratégia incompletos e chats longos com IA.
- **Analogia de Eric Kandel** (*In Search of Memory*, Nobel): memória dá continuidade à experiência; sem ela, experiência se fragmenta em momentos isolados. PM OS v2 não quer registrar tudo — quer evitar que o projeto perca o fio.
- **O Intake Desk (`/capture-memory from this meeting note`)**: usuário fornece uma fonte (nota de reunião colada, path de artefato, transcrição, update rápido). PM OS lê e **propõe** um pequeno número de fatos do projeto a guardar — não salva a nota inteira, não engole a transcrição, não vasculha pastas, não decide silenciosamente o que vira histórico. Mostra um preview e pergunta o que salvar.
- **Princípio de seleção (Kandel)**: o sistema nervoso abstrai o mundo em vez de copiá-lo. Uma transcrição é uma gravação; uma decisão é a abstração que permite o trabalho futuro continuar.
- **Categorias deliberadamente pequenas de memória**: decisions, risks, assumptions, open questions, stakeholder context, changed recommendations, source updates, accepted PRD deltas. Objetivo declarado: "não quero que a primeira versão seja inteligente, quero que seja difícil de usar mal."
- **Versão "boa" vs "ruim" de uma memória**: ruim = "Sarah disse que estava preocupada que o CEO achasse o plano de onboarding ruim." Boa = "Confiança do stakeholder de design está baixa após o roadmap mudar para retenção." A segunda preserva o fato de produto e descarta a redação privada.
- **`/daily-drip` — hábito de contexto lento**: PM OS ocasionalmente faz UMA pergunta útil e específica (não genérica), e espera — sem segunda pergunta até a primeira ser respondida, pulada, adiada, parada ou arquivada. Regra existe porque "personalização" fica perturbadora rápido se o sistema parecer "faminto" por contexto.
- **Roteamento da resposta**: ao receber uma resposta ao daily-drip, PM OS decide que TIPO de contexto é — memória de projeto (ex.: risco de confiança de design no roadmap atual), contexto estável de stakeholder, sensível e deve ser descartado, ou precisa de confirmação antes de ser arquivado.
- **Analogia das experiências de Aplysia de Kandel**: memória de longo prazo funciona melhor com treino espaçado e descanso do que com um burst comprimido — daily-drip aplica a mesma lógica de "toques pequenos e espaçados constroem contexto durável melhor que uma entrevista de setup gigante".
- **Recall packet (read path)**: em vez de colar todos os eventos salvos no prompt (recall ruim quase tão perigoso quanto captura ruim), PM OS constrói um "pacote de recall" pequeno: decisões recentes, riscos ativos, perguntas em aberto, premissas, restrições, referências de fonte, saúde da memória. Analogia: working memory, não archive search — traz o passado relevante para o presente o suficiente para agir, sem arrastar todo o histórico do projeto.
- **Roadmap de construção do v2**: 1) save path (capture), 2) hábito de contexto lento (daily-drip), 3) read path (recall).

## Key insights

- Sistemas de memória mais ambiciosos citados como referência de onde a categoria pode ir: **OpenClaw Memory and Search** (indexação local, hybrid search, memória ativa, promoção em background) e **Hermes Agent Memory and Sessions** (camada séria de sessão/memória com arquivos de memória escopados, busca SQLite, sumarização, escritas atômicas, scanning de escritas arriscadas). PM OS v2 começa num ponto mais estreito que esses.
- Mudança de comportamento esperada do `/status`: antes — "Projeto atual: retention-reset. Arquivos recentes: strategy.md, meeting.md. Próximo passo recomendado: rodar /strategy." Depois — "Projeto atual: retention-reset. Memória diz que liderança moveu Q3 de mobile para retenção, confiança de design está baixa, e compromissos de mobile seguem não resolvidos. Próximo passo recomendado: preparar reunião de alinhamento de roadmap com /meeting."
- Dentro de workflows, se a tensão atual já está na memória, PM OS deve abrir com uma pergunta mais afiada em vez de uma intake genérica — ex.: "Vejo que a tensão atual é a mudança de Q3 de mobile para retenção, mais a preocupação do design de que onboarding está sendo abandonado. Esta reunião é principalmente para alinhar design, resetar expectativas de liderança, ou decidir o que acontece com os compromissos de mobile?"

## Exemplos e evidencias

- Exemplo completo de meeting note → proposta de memória: nota diz "Leadership wants to pause mobile work and move roadmap toward retention by Q3. Design is worried onboarding will look abandoned. Team needs to decide what happens to current onboarding commitments." → PM OS sugere: decision (mudança de foco Q3), risk (preocupação de design), open question (compromissos de onboarding existentes).
- Referências externas: deepwiki.com/openclaw/openclaw (3.4.3 memory-and-search) e deepwiki.com/NousResearch/hermes-agent (4.3 memory-and-sessions).

## Implicacoes para o vault

- O framework de **três trabalhos da memória** (decidir o que vira memória / aprender contexto de fundo devagar / usar a fatia certa antes de ajudar) mapeia diretamente para a arquitetura de memória do vault: `04-SYSTEM/wiki/hot.md` (recall packet), `MEMORY.md` (categorias seletivas), e o processo de ingest (decidir o que vira fato persistente vs. ruído).
- O padrão **"propor, não salvar direto"** (Intake Desk com preview) é relevante para o workflow de ingest do vault — atualmente o ingest-agent cria/edita diretamente; vale considerar se sources de baixa confiança deveriam passar por um preview/aprovação antes de virar memória persistente (já parcialmente coberto pela triagem A/B/C do pipeline-diario).
- A distinção **"versão ruim vs. versão útil"** de uma memória (transcrição crua vs. fato abstraído) é diretamente aplicável a `04-SYSTEM/wiki/errors.md` e a qualquer entrada de memória do vault — preferir fatos destilados a citações longas.
- `/daily-drip` (uma pergunta por vez, espaçada, sem pressionar) é um padrão de UX de captura de contexto que poderia inspirar futuras interações do Nexus com o usuário (ex.: perguntas pontuais durante sessões, em vez de questionários grandes).
- Conecta com **[[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]**, **[[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]**, **[[03-RESOURCES/concepts/agent-systems/agent-memory-layers]]** e **[[03-RESOURCES/concepts/agent-systems/agent-shared-memory]]** — PM OS v2 é um caso de produto real implementando princípios discutidos nesses concepts (camadas de memória, captura seletiva, recall packets).
- Relevante para **[[03-RESOURCES/concepts/pkm-obsidian/hot-cache]]** e **[[03-RESOURCES/concepts/pkm-obsidian/dream-cycle-self-consolidation]]** — o ciclo capture → distill → recall do PM OS v2 é estruturalmente análogo ao ciclo de consolidação do vault.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
- [[03-RESOURCES/concepts/agent-systems/agent-shared-memory]]
- [[03-RESOURCES/concepts/pkm-obsidian/hot-cache]]
- [[03-RESOURCES/concepts/pkm-obsidian/dream-cycle-self-consolidation]]
