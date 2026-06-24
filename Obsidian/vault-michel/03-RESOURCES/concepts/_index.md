---
title: Conceitos — Portal
type: portal
status: developing
created: 2026-04-14
updated: 2026-05-31
tags: [index, concepts, portal, vault]
---

# Conceitos — Portal

Ideias atômicas reutilizáveis — um conceito por nota, linkado de onde for referenciado.

> **Auto-list:** lista flat de todos concepts via Obsidian sidebar. Este portal é curado por tema.

## Como usar

- Cada nota = um conceito único
- Título em minúsculas com hífens: `prompt-engineering.md`
- Linke para cá quando um conceito aparecer em outras notas

## Domínios (255+ conceitos)

- [[03-RESOURCES/concepts/agent-systems/_index|Agent Systems]] (70)
- [[03-RESOURCES/concepts/ai-strategy-org/_index|AI Strategy & Organization]] (27)
- [[03-RESOURCES/concepts/claude-code-tooling/_index|Claude Code & Tooling]] (32)
- [[03-RESOURCES/concepts/dev-foundations/_index|Dev Foundations]] (29)
- [[03-RESOURCES/concepts/finance-trading/_index|Finance & Trading]] (6)
- [[03-RESOURCES/concepts/learning-cognition/_index|Learning & Cognition]] (13)
- [[03-RESOURCES/concepts/llm-ml-foundations/_index|LLM & ML Foundations]] (46)
- [[03-RESOURCES/concepts/pkm-obsidian/_index|PKM & Obsidian]] (32)

## Refactor Wiki — 2026-05-02

Consolidação Karpathy-aligned: 115 → 107 files. MCP cluster (3→1), Token cluster (3→2), Claude tooling (-2 stubs). Ver [[04-SYSTEM/wiki/hot]] para detalhes.

## Conceitos Recentes (2026-05-14 — Memory/RSI/Self-Improving Pretraining batch)

- [[03-RESOURCES/concepts/ai-strategy-org/c-theta-engineering]] — C-engineering (context) vs θ-engineering (weights); todos os sistemas de memória agêntica atual são C; gap de generalização provado (Ω(k²) vs O(d))
- [[03-RESOURCES/concepts/llm-ml-foundations/recursive-self-improvement]] — RSI: capacidade de IA acelerar desenvolvimento de futuras IAs; METR time horizon dobra a cada 4 meses (dados pós-2023); sandbagging como complicação de alinhamento

## Conceitos Recentes (2026-05-14 — Conductor RL / Synthetic Computers)

- [[03-RESOURCES/concepts/agent-systems/rl-conductor-orchestration]] — 7B modelo treina via RL para orquestrar LLMs maiores; supera GPT-5/Gemini/Claude; topologias recursivas como test-time scaling
- [[03-RESOURCES/concepts/llm-ml-foundations/synthetic-data-for-agents]] — geração de ambientes sintéticos ricos (persona→filesystem→artefatos) para treinar agentes de longa duração; estado da arte: Synthetic Computers at Scale (Microsoft)

## Conceitos Recentes (2026-05-09 — Agent VFS / Strukto AImirage)

- [[03-RESOURCES/concepts/pkm-obsidian/virtual-filesystem-llm]] — Unix semantics são LLM-native; VFS como interface universal para agents; bash > SDK/MCP para fluência
- [[03-RESOURCES/concepts/agent-systems/agent-vfs-pattern]] — padrão: montar backends heterogêneos como árvore de diretórios; dispatcher + two-layer cache; workspaces portáteis

## Conceitos Recentes (2026-05-09 — First Principles Thinking)

- [[03-RESOURCES/concepts/learning-cognition/first-principles-reasoning]] — raciocínio a partir de verdades fundamentais irredutíveis; oposto da analogia; SpaceX / Feynman / Aristotle
- [[03-RESOURCES/concepts/learning-cognition/analogical-vs-first-principles]] — analogia é rápida mas tem teto; first principles rompe o teto; Type 1 vs Type 2 de Bezos
- [[03-RESOURCES/concepts/learning-cognition/mental-models]] — frameworks cognitivos; Munger: modelos fundamentais vs. copiados; capacidade de adaptação depende de entender o porquê

## Conceitos Recentes (2026-05-09 — AI Learning System)

- [[03-RESOURCES/concepts/agent-systems/ai-tutor-pattern]] — LLM as personalized tutor; 7-module system; outperforms courses via diagnosis + active generation; neil_xbt
- [[03-RESOURCES/concepts/pkm-obsidian/personal-curriculum]] — diagnostic-driven individualized learning map; skips known material; refreshed every 2–3 weeks
- [[03-RESOURCES/concepts/pkm-obsidian/socratic-learning-loop]] — LLM leads learner to understanding via questions; active generation > passive consumption
- [[03-RESOURCES/concepts/pkm-obsidian/spaced-learning-llm]] — LLM generates review questions at 3/7/14-day intervals; no flashcard app needed; integration questions for deep understanding

## Conceitos Recentes (2026-05-09 — Obsidian Automation)

- [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]] — vault que cresce em inteligência sem esforço manual proporcional; loop de feedback (captura → processamento → surface back → contexto mais rico); @cyrilXBT
- [[03-RESOURCES/concepts/pkm-obsidian/scheduled-ingest-routine]] — cron job (N8N 6h) que processa captures e gera daily brief com conexões, padrão semanal e pergunta; vault te encontra, você não encontra o vault

## Conceitos Recentes (2026-05-31 — Hermes+Obsidian / Personal Agent Stack / Skill Security)

- [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]] — API+CLI > local file > browser automation > screen automation; confiabilidade do agente é função da superfície de ferramenta; nicbstme / Codex personal stack
- [[03-RESOURCES/concepts/agent-systems/skill-security-scanner]] — 26,1% skills AI contêm vulnerabilidades (42k analisados); pipeline static+LLM; 64 padrões 16 categorias; SkillSpector NVIDIA; taxa de maliciosos 5,2%; executáveis 2,12× mais vulneráveis

## Conceitos Recentes (2026-05-29 — Personal Corpus / Local AI / Security / AI OS / Knowledge Graph)

- [[03-RESOURCES/concepts/pkm-obsidian/personal-corpus]] — corpus pessoal acumulado no vault é o único moat irreproduzível de 2026; modelos/skills/prompts commoditizam; corpus não; estrutura tipo-based (não domínio-based) crítica para cross-domain reasoning
- [[03-RESOURCES/concepts/pkm-obsidian/local-llm-privacy]] — Obsidian + LM Studio + Smart Connections como stack offline completo; tradeoff consciente: privacidade vs. capacidade máxima; modelos 7B–13B viáveis em laptops modernos
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-security]] — 3 mecanismos de vazamento (leitura direta, grep, runtime output); 5 tiers de deny rules; deny rules são controle soft, não hard boundary; vulnerabilidade Adversa AI (abril 2026)
- [[03-RESOURCES/concepts/ai-strategy-org/ai-operating-system]] — Four C's framework (Context, Connections, Capabilities, Cadence); Instructions ≠ Capabilities; Bike Method para autonomia gradual; Default Shift (Claude Code, não browser)
- [[03-RESOURCES/concepts/claude-code-tooling/knowledge-graph-code]] — Tree-sitter + LLM para codebases; `/understand-knowledge` para Karpathy-pattern wikis; grafos que ensinam > grafos que impressionam

## Conceitos Recentes (2026-05-09 — AI Moat)

- [[03-RESOURCES/concepts/ai-strategy-org/ai-organizational-moat]] — organizational shape as the durable AI moat; companies compete on identity, not just product or comp; shape determines who can exist there
- [[03-RESOURCES/concepts/ai-strategy-org/talent-density-as-strategy]] — deliberate concentration of exceptional people as competitive lever; recruiting tempo, colocation, average-person problem; @JayaGup10

## Conceitos Recentes (2026-05-09 — Autobrowse)

- [[03-RESOURCES/concepts/agent-systems/browser-agent-amnesia]] — browser agents re-descobrem cada site do zero a cada run; discovery tax infinita; memoria e o gargalo real, nao raciocinio
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] — converter run bem-sucedida em SKILL.md durable via convergencia iterativa; strategy.md compounding; mesmo formato human-written vs agent-graduated
- [[03-RESOURCES/concepts/ai-strategy-org/mythos-moment-ai]] — inflection point onde capacidade vira confiavel em producao; argumento que o momento para browser agents ja chegou via memory, nao via modelo melhor

## Conceitos Recentes (2026-05-09)

- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-length]] — action sequence length as independent RL training bottleneck; distinct from reasoning complexity; Kim et al. (2026) / MSRA
- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-reduction]] — macro actions + subgoal decomposition to shorten effective horizon; enables horizon generalization to unseen longer tasks
- [[03-RESOURCES/concepts/llm-ml-foundations/credit-assignment]] — negative advantage diffusion in large vocabularies; why sparse rewards compound catastrophically at long horizons
- [[03-RESOURCES/concepts/ai-strategy-org/powerful-ai-definition]] — Amodei's definition: Nobel-level intelligence, millions of instances at 10–100x speed; rejects "AGI" label
- [[03-RESOURCES/concepts/ai-strategy-org/compressed-21st-century]] — 50–100 years of biological/medical progress in 5–10 AI-accelerated years
- [[03-RESOURCES/concepts/ai-strategy-org/genius-in-a-datacenter]] — summary phrase for powerful AI: country of geniuses, collaborating at scale
- [[03-RESOURCES/concepts/ai-strategy-org/marginal-returns-to-intelligence]] — economic framework for AI age; limiting factors when intelligence is very high
- [[03-RESOURCES/concepts/ai-strategy-org/biological-freedom]] — AI-accelerated biology gives individuals full control over biological processes, lifespan, cognition

## Conceitos Recentes (2026-05-05)

- [[03-RESOURCES/concepts/ai-strategy-org/dual-data-flywheel]] — closed-loop curriculum: flywheel generates harder tasks from model failures; reasoning + agentic tracks; AgenticQwen / Alibaba
- [[03-RESOURCES/concepts/agent-systems/behavior-tree-expansion]] — expands linear agentic workflows into multi-branch decision trees for RL training data; 4 phases incl. adversarial mock-user
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — RL on long-horizon tool-use with rubric-based 0-1 subgoal rewards; fully simulated environments; GRPO optimizer
- [[03-RESOURCES/concepts/ai-strategy-org/linkedin-gtm-system]] — sistema Claude Code como execution layer do LinkedIn motion para SaaS founders; 5 skills core; CLAUDE.md como voice profile; Modal deployment; sub-agent batching
- [[03-RESOURCES/concepts/agent-systems/internalized-multi-agent-debate]] — IMAD; SFT+GRPO destila debate multi-agente em único LLM; 6–21% dos tokens; agent subspaces identificáveis; Yi/Mueller/Lee (BU 2026)
- [[03-RESOURCES/concepts/llm-ml-foundations/activation-steering]] — adiciona vetores ao hidden state para amplificar/suprimir comportamentos; CAA; difference-in-means; AI safety e interpretabilidade
- [[03-RESOURCES/concepts/pkm-obsidian/company-brain]] — framework 3-layer de memória organizacional (factual/interaction/action); emerge do indivíduo para fora; Ashwin Gopinath / Sentra AI
- [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]] — Layer 1 do Company Brain; proveniência, permissões, ownership, freshness, relacionamentos entre artefatos; por que RAG não é suficiente
- [[03-RESOURCES/concepts/pkm-obsidian/semantic-file-system]] — camada de memória onde os relacionamentos ao redor de um artefato importam tanto quanto o artefato; modelo de armazenamento exigido para memória factual durável
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-rational-agency-gap]] — gap entre otimização de next-token (LLM) e maximização de utilidade esperada (agente racional formal); falhas irremediáveis por prompt engineering; Burkov
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-five-layer-architecture]] — 5 camadas arquiteturais do Claude Code como agent dev kit: CLAUDE.md (memória) → Skills (conhecimento) → Hooks (guardrails) → Subagents (delegação) → Plugins (distribuição)

## Conceitos Recentes (2026-04-19)

- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] — framework AlphaEval; 5 paradigmas de avaliação; scaffold vs model; 6 failure modes de produção; valor econômico como métrica
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]] — LLM avalia output de outro LLM via rubrica; substantial agreement (κ=0.72 three-way); vieses de self-preference e self-enhancement
- [[03-RESOURCES/concepts/pkm-obsidian/subliminal-learning]] — transmissão oculta de traits comportamentais via distilação; fenômeno geral provado matematicamente; relevância crítica para AI safety

## Conceitos Recentes (2026-04-17)

- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — Model Context Protocol; 5 servidores essenciais; workflows encadeados; FastMCP
- [[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]] — bundle Skills+Connectors+Commands+Subagents; 11 plugins Anthropic open source
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — injeções automáticas por evento (UserPromptSubmit etc.); context enrichment automático
- [[03-RESOURCES/concepts/llm-ml-foundations/vector-search]] — busca semântica (vsearch) vs keyword (BM25); QMD; Second Brain
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — orquestrador + subagentes; 5 padrões; single-agent ceiling; -84.3% intervenções
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — art de preencher a context window certa; substituto da iteração; Karpathy
- [[03-RESOURCES/concepts/agent-systems/resolver-pattern]] — tabela de roteamento para contexto; 200 linhas substituem 20k; context rot
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — 4 camadas (lista→markdown→vector→graph); episódica/semântica/procedural; Cognee
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — KV cache; 90% desconto em cache reads; 92% hit rate no Claude Code; 3 regras
- [[03-RESOURCES/concepts/ai-strategy-org/agentic-video]] — geração de vídeo por AI agents via HTML+CSS+JS; HyperFrames como implementação de referência
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — protocolo que conecta LLMs a data streams externos; TradingView MCP como caso de uso
- [[03-RESOURCES/concepts/ai-strategy-org/solo-saas-stack-2026]] — stack mínima (Open SaaS+Supabase+Repomix+Claude+Vercel+Stripe) para solo founder
- [[03-RESOURCES/concepts/llm-ml-foundations/local-ai]] — agentes rodando 100% local; Ollama; OpenJarvis v1.0; "Intelligence Per Watt" como nova métrica de avaliação

## Conceitos Recentes (2026-05-31)

- [[03-RESOURCES/concepts/agent-systems/agent-trust-layer]] — camada de qualidade entre coding agent e PR; 4 componentes: feedback sensors, semantic evals, zonas de refatoração, provenance trails
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — atualizado: taxonomia TsinghuaC3I ST/LT/Experience; mapeamento vault (hot.md=ST, sources/=LT, errors.md=Experience)
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — atualizado: SkillOpt (Microsoft) — otimização formal de skills em espaço de texto; +59.7pp, 920 tokens ótimos, sem alterar pesos

## Conceitos por Área

### Programação
> Adicione links conforme criar.

### Direito / Concurso
> Adicione links conforme criar.

### Inteligência Artificial
> Adicione links conforme criar.
