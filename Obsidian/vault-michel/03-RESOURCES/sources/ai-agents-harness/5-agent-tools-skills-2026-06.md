---
title: "5 ferramentas/skills para agentes — Agent Reach (internet access), Open Notebook (NotebookLM open-source), last30days-skill, PM Skills Marketplace, Taste Skill"
type: source
source: "Clippings/ (5 clippings, ver Links abaixo)"
created: 2026-06-13
tags: [source, ai-agents, claude-skills, agent-tooling, open-source]
---

## Tese central

5 repos open-source (2026-06) que estendem o que agentes Claude Code/Cowork
podem fazer: dar "olhos" para a internet inteira (Agent Reach), substituir
NotebookLM por stack 100% local/multi-model (Open Notebook), pesquisar
qualquer tópico nos últimos 30 dias com scoring por engajamento real
(/last30days), 100+ skills de product management encadeáveis (PM Skills
Marketplace), e dar "bom gosto" visual a UIs geradas por IA (Taste Skill).
Todos seguem o padrão SKILL.md / `npx skills add` já documentado em
[[03-RESOURCES/sources/claude-code-skills/mattpocock-additional-skills-2026-06]].

---

## 1. Agent-Reach (Panniantong)

Source: [github.com/Panniantong/Agent-Reach](https://github.com/Panniantong/Agent-Reach)

### Argumentos principais

- **Problema**: agentes sabem escrever código mas "ficam cegos" na internet
  — sem legendas de YouTube, sem busca no Twitter (API paga), Reddit bloqueia
  IPs de servidor (403), Xiaohongshu exige login, B站 bloqueia downloaders
  genéricos.
- **Solução = capability layer, não wrapper**: Agent Reach não reimplementa
  leitura — ele **seleciona, instala, faz diagnóstico (`agent-reach doctor`)
  e roteia** entre ferramentas open-source já existentes. Cada plataforma
  tem lista ordenada de backends "primário → fallback" (ex: Twitter:
  twitter-cli → OpenCLI → bird; Bilibili: bili-cli → OpenCLI → search API,
  porque yt-dlp foi bloqueado pelo anti-scraping da B站 em 2026-06).
- **Instalação em 1 frase**: cola um prompt apontando para `install.md`, o
  próprio agente executa todo o setup (detecta Node/gh/mcporter, configura
  Exa via MCP grátis, registra SKILL.md). 6 canais funcionam sem config
  (web via Jina Reader, YouTube, RSS, GitHub público, busca via Exa, V2EX);
  canais com login (Twitter, Xiaohongshu, Reddit, LinkedIn) via cookie
  export (Cookie-Editor) ou OpenCLI com sessão de browser.
- **Segurança**: credenciais só locais (`~/.agent-reach/config.yaml`, modo
  600), modo `--safe` não instala nada automaticamente, `--dry-run` previa
  ações, arquitetura plugável (troca um channel sem afetar outros). Aviso
  explícito: contas com cookie (Twitter/Xiaohongshu) devem ser secundárias —
  risco de ban por comportamento de API não-browser.
- **Manutenção como serviço**: "接入方式会换代，你不用操心" — quando uma
  plataforma muda anti-scraping (ex: B站 bloqueou yt-dlp em mar/2026), o
  projeto atualiza o roteamento e o usuário não percebe.

### Implicações para o vault

Ferramenta candidata para qualquer rotina do vault que precise de pesquisa
web ampliada (ex: F1 do pipeline-diario, `ingest-report`). Atenção ao aviso
de segurança sobre cookies — se adotado, usar conta secundária dedicada, não
a conta pessoal do usuário, alinhado com [[04-SYSTEM/agents/core/guard]].

---

## 2. Open Notebook (lfnovo)

Source: [github.com/lfnovo/open-notebook](https://github.com/lfnovo/open-notebook)

### Argumentos principais

- **Posicionamento**: alternativa open-source/self-hosted/privacy-first ao
  Google NotebookLM — "your sensitive research stays completely private".
- **Diferenciais vs. NotebookLM**: 18+ providers de IA (OpenAI, Anthropic,
  Ollama, LM Studio, Vertex, Groq, etc. — escolha de custo/privacidade),
  podcasts com 1-4 speakers configuráveis (NotebookLM trava em 2), API REST
  completa (automação total), deploy via Docker em qualquer lugar, busca
  full-text + vetorial, content transformations customizáveis.
- **Stack**: Python/FastAPI + Next.js/React + SurrealDB (via Docker
  compose), setup em ~2min (`docker compose up -d` → configurar provider de
  IA na UI).
- **Suporte a modelos de raciocínio** (DeepSeek-R1, Qwen3) e "fine-grained
  context control" — escolher exatamente o que compartilhar com o modelo.

### Implicações para o vault

Alternativa self-hosted ao padrão "raw → wiki → query" que já existe no
vault via Obsidian+Claude — não substitui o setup atual, mas é referência
para "knowledge base" com podcast generation e API REST, caso o vault
precise de uma camada de consumo externa (ex: gerar podcast de resumos
semanais a partir de `04-SYSTEM/wiki/hot.md`). Suporte a Ollama reforça
[[04-SYSTEM/wiki/model-routing|Model Routing Tiers]] (tier local).

---

## 3. /last30days-skill (mvanhorn)

Source: [github.com/mvanhorn/last30days-skill](https://github.com/mvanhorn/last30days-skill)

### Argumentos principais

- **Tese**: "Google aggregates editors. /last30days searches people." Busca
  em paralelo Reddit, X, YouTube (transcripts completos), TikTok, Instagram
  Reels, HN, Polymarket (odds = dinheiro real), GitHub, Digg, Threads,
  Pinterest, Bluesky, Perplexity, web — sintetiza num brief ranqueado por
  **engajamento real** (upvotes/likes/odds), não SEO.
- **v3 — "intelligent search"**: antes de buscar, resolve *onde* buscar —
  "Peter Steinberger" → @steipete (X) + GitHub profile + subreddits certos,
  bidirecional (pessoa↔empresa↔produto). Isso é o que permite achar conteúdo
  que v2/Google nunca achariam.
- **Outras features v3**: "Best Takes" (segundo judge pontua humor/virality,
  não só relevância), cluster merging cross-source (mesma história em
  Reddit+X+YouTube = 1 item), comparações single-pass ("X vs Y" em 1 pass
  em vez de 3 — 12min→3min), GitHub person-mode (PRs/merge rate de uma
  pessoa), modo ELI5, briefs HTML standalone exportáveis
  (`--emit=html`), modo `--store` com SQLite para monitoramento de
  tendências + watchlist/briefing scripts agendados.
- **Zero-config**: Reddit (com comentários via JSON público), HN, Polymarket,
  GitHub funcionam sem chave. Outras fontes via bring-your-own-keys.
- **Casos de uso reais citados**: prep de reunião (descobre o que alguém fez
  nos últimos 30 dias que não está no LinkedIn), comparação de ferramentas
  com dados ao vivo (estrelas GitHub via API, não posts antigos), entender
  eventos em desenvolvimento (guerra Irã-EUA com odds Polymarket), aprender
  prompting técnico atualizado da comunidade.

### Implicações para o vault

Ferramenta de research mais avançada do cluster — o padrão "resolve onde
buscar antes de buscar" + "scoring por engajamento real" + "merge de
clusters cross-source" é uma versão produtizada do que a triagem do
pipeline-diario faz manualmente para Clippings. O modo `--store` +
watchlist/briefing é candidato direto para automatizar
[[04-SYSTEM/agents/core/ingest-report|ingest-report]] (síntese semanal)
com dados vivos em vez de só Clippings estáticos.

---

## 4. PM Skills Marketplace (phuryn/pm-skills)

Source: [github.com/phuryn/pm-skills](https://github.com/phuryn/pm-skills)

### Argumentos principais

- **68 skills + 42 workflows encadeados em 9 plugins**, cobrindo todo o
  ciclo de product management: discovery (13 skills — brainstorm, ICE/RICE,
  Opportunity Solution Tree de Teresa Torres), strategy (12 skills — Lean
  Canvas, Business Model Canvas, SWOT/PESTLE/Porter's/Ansoff), execution (16
  skills — PRD, OKRs, sprint, retro, pre-mortem, stakeholder map, "red-team"
  adversarial de plano), market research (7 — personas, TAM/SAM/SOM,
  competitor analysis), data analytics (3 — SQL/cohort/A-B test), GTM (6 —
  ICP, growth loops, battlecards), marketing/growth (5 — North Star metric,
  positioning), toolkit (4 — resume, NDA, privacy policy, proofread), e
  **AI shipping kit** (2 skills/5 commands — documenta apps "vibe-coded",
  audita gap entre intenção documentada e código real, mapa de cobertura de
  testes, audit estático de segurança/performance).
- **Skills carregam automaticamente** quando relevantes (sem invocação
  explícita); commands (`/discover`, `/write-prd`, etc.) encadeiam múltiplas
  skills num workflow ponta-a-ponta e sugerem próximos comandos.
- **Base teórica explícita**: cada skill referencia um framework de autor
  conhecido (Teresa Torres, Marty Cagan, Alberto Savoia, Ash Maurya, etc.) —
  "rigor de frameworks PM no fluxo diário, não na estante".
- **AI Shipping Kit (`pm-ai-shipping`)** é o destaque mais transferível:
  `/ship-check` transforma repo vibe-coded em "reviewer-ready packet"
  (arquitetura, fluxos de permissão, secrets, cobertura de testes) +
  `intended-vs-implemented` — encontra onde código diverge da documentação,
  com evidência citada de ambos os lados.
- Compõe com **PM Brain** (markdown files numa pasta, Claude lê antes de
  responder e escreve depois, sweep semanal — "no vector DB, no cloud, no
  agent memory tricks").

### Implicações para o vault

`strategy-red-team` (adversarial stress-test de plano) e
`intended-vs-implemented` (gap entre docs e código) são skills
**diretamente aplicáveis** ao SO do vault — o segundo é essencialmente o que
`04-SYSTEM/agents/core/review` (drift) já faz, mas como skill portável.
PM Brain é mais uma confirmação do padrão "markdown + sweep periódico" já em
uso (hot.md + pipeline-diario). Para `02-AREAS/fiap/` (projeto MVC/Fintech),
os 68 skills de PM (PRD, user stories, roadmap, métricas) são aplicáveis a
qualquer entrega de projeto FIAP que simule um ciclo de produto.

---

## 5. Taste Skill (Leonxlnx)

Source: [github.com/Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill)

### Argumentos principais

- **Tese**: "stops the AI from generating boring, generic slop" — skills
  portáveis (`npx skills add`) que dão direção visual forte a UIs geradas
  por agentes, em vez do "design genérico de IA" padrão.
- **3 dials ajustáveis** (1-10) no skill principal: `DESIGN_VARIANCE`
  (layout: centrado/limpo ↔ assimétrico/moderno), `MOTION_INTENSITY`
  (animação: hover ↔ scroll/magnetic), `VISUAL_DENSITY` (informação por
  viewport: espaçoso ↔ dashboard denso).
- **10 variantes especializadas**: v2 default (infere linguagem de design
  do brief + os 3 dials + GSAP skeletons + banimento de em-dash), variante
  GPT/Codex (mais agressiva), image-to-code (gera referências → analisa →
  implementa), redesign (audita UI existente antes de mudar), soft (UI
  premium/calma), minimalist (estilo Notion/Linear), brutalist (Swiss
  type/contraste forte), output-enforcement (combate outputs incompletos),
  stitch (compatível com Google Stitch + export `DESIGN.md`).
- **Skills de geração de imagem** (web/mobile/brand kit) — produzem apenas
  imagens de referência, para alimentar pipeline image→code.

### Implicações para o vault

Mesmo padrão "design system primeiro, stop-and-ask depois" do artigo 1 de
[[03-RESOURCES/sources/claude-code-cowork/4-prompts-best-ui-design-system]]
(Moonchild), mas produtizado como skill instalável com dials numéricos.
Diretamente aplicável a qualquer entrega de frontend FIAP (MVC) — instalar
`design-taste-frontend` ou `redesign-existing-projects` antes de gerar
telas evita o "drift" de UI documentado naquele artigo.

## Links

- [[03-RESOURCES/sources/claude-code-skills/mattpocock-additional-skills-2026-06]]
- [[03-RESOURCES/sources/claude-code-cowork/4-prompts-best-ui-design-system]]
- [[04-SYSTEM/agents/core/guard]]
- [[04-SYSTEM/agents/core/review]]
- [[04-SYSTEM/wiki/model-routing]]
