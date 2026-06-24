---
title: "I Built a 5 Tool AI Stack Where Each Tool Does Something the Others Cannot"
type: source
source: "Clippings/I Built a 5 Tool AI Stack Where Each Tool Does Something the Others Cannot. Here Is the Full Build..md"
original_url: "https://x.com/DamiDefi/status/2060313230585536980"
author: "@DamiDefi"
published: 2026-05-29
created: 2026-05-29
ingested: 2026-05-29
tags: [ai-agents, ai-stack, claude, obsidian, hermes, kimi-k2, cursor, tool-differentiation]
---

## Tese central

Em 2026, usar um único tool para tudo não é workflow — é um martelo procurando pregos. Os operadores que extraem leverage real de AI usam ferramentas especializadas em cada layer: Claude para raciocínio profundo, Obsidian para memória persistente, Hermes Agent para automações recorrentes, Kimi K2.6 para coding em escala com multi-agentes, e Cursor 3 para execução de código com contexto visual do codebase.

## Argumentos principais

- A maior vantagem não é ter mais tools, mas usar a ferramenta certa para cada camada de operação
- Claude, Obsidian, Hermes, Kimi K2.6 e Cursor são insubstituíveis em seus domínios específicos — cada um faz algo que os outros não conseguem replicar nativamente
- O stack funciona como layers que se alimentam: Claude raciocina → Obsidian provê memória acumulada → Hermes executa workflows recorrentes → Kimi K2.6 paraleliza coding em escala → Cursor executa no codebase real com contexto visual
- Nenhuma tool é redundante — remover qualquer uma quebra uma capacidade única

## Key insights por camada

### Layer 1: Claude — Reasoning & Context
- 200K token window sem degradação de coerência — único nível de desempenho nessa capacidade
- Melhor instruction-following mesmo após GPT-5.2 e Gemini 3: honra todos os detalhes de prompts longos na primeira tentativa
- Claude Projects + MCP: memória persistente cross-conversation + live access a external tools = sistema que composta contexto ao longo do tempo e age no mundo
- Dado de independência: Ryz Labs testou 30 dias → ~95% functional accuracy em coding vs ~85% ChatGPT; 70% dos devs preferem Claude para coding por late 2025/early 2026
- **Prompt de reasoning profundo:** "read without producing output, then tell me: central argument, three weakest points, most important implication the author didn't state"

### Layer 2: Obsidian — Memory & Intelligence
- Claude + Obsidian não é aditivo, é multiplicativo: sessão sem vault começa do zero; com vault começa de tudo que você acumulou
- Após 6 meses de captura consistente: Claude pode surfaçar conexões entre notas escritas 8 semanas separadas, identificar padrões antes de você percebê-los conscientemente, flagar contradições entre crenças documentadas em momentos diferentes
- QuickAdd + daily note: captura zero-friction por keyboard shortcut, sem categorização no momento de captura — Claude categoriza e conecta depois
- N8N + Telegram bot: qualquer mensagem de qualquer device vai para o vault Inbox em 30 segundos
- Síntese diária automatizada: não um sumário, uma *síntese* — conexões não-óbvias, padrões formando-se através de semanas, contradições, capture mais valioso para desenvolver

### Layer 3: Hermes Agent — Autonomous Local Automation
- Auto-hosted, model-agnostic, sem telemetria: dados ficam na máquina
- 3-tier memory system + self-evolving skills via GEPA, 647-skill ecosystem
- Quando resolve um problema difícil, escreve uma skill file — o agente de 6 meses é fundamentalmente mais capaz que o inicial
- #1 most-used AI agent no mundo por daily inference volume no OpenRouter (maio 2026), 73k GitHub stars
- Natural language cron: "every weekday at 9am, summarise inbox and post to Slack" é um workflow real, sem syntax de cron
- Model routing em 3 tiers: Gemini Flash Lite (mecânico), Claude Sonnet (ambíguo), Claude Opus (raciocínio profundo) — economiza ~$40 do setup inicial para um usuário documentado

### Layer 4: Kimi K2.6 — Large-Scale Agentic Coding
- Orquestra até 300 sub-agents concorrentes em 4.000 steps — 3x o teto de K2.5 (100 agents, 1.500 steps)
- Open-source, nativo multimodal, livre via API (DeepInfra: `moonshotai/Kimi-K2.6`, context 256K tokens)
- Casos extremos: 5-day continuous-ops agent trace (monitoring/incident response), 12-hour Zig port, 13-hour exchange-core refactor
- Visual-to-code: transforma prompts e inputs visuais em interfaces production-ready com layouts estruturados, elementos interativos e animações

### Layer 5: Cursor 3 — Live Coding Execution
- Lançado 02/04/2026; rebuilt inteiramente em torno de agents
- Agents Window: múltiplos agents simultâneos, cada um em Git worktree próprio — sem interferência, merge quando pronto
- Cloud handoff: inicia task local, entrega para Cursor cloud, fecha laptop, PR aguarda ao reconectar
- Design Mode: conecta ao live app no browser, clica em qualquer elemento UI, agent faz apenas aquela mudança sem tocar nada mais
- 64% Fortune 500; 1M+ desenvolvedores; agent users > Tab autocomplete users (2:1) — inversão de just um ano atrás

## Exemplos e evidências

- Ryz Labs 30-day test: Claude 95% vs ChatGPT 85% em functional accuracy para coding
- 70% dos devs preferem Claude para coding (late 2025/early 2026)
- Hermes Agent: 73k GitHub stars, #1 daily inference volume no OpenRouter (maio 2026)
- 647 skills no ecossistema Hermes
- Kimi K2.6: 300 agents / 4.000 steps (3x K2.5)
- Cursor 3: 64% Fortune 500, 1M+ devs, agents 2:1 sobre Tab autocomplete

## Implicações para o vault

- O posicionamento de Obsidian como "memory layer" que torna Claude multiplicativamente mais poderoso é validação externa do design do vault — especialmente a síntese diária como padrão de operação
- Hermes Agent confirma [[03-RESOURCES/entities/hermes|hermes]] como agente de automação autônoma mais relevante no ecossistema open-source
- Kimi K2.6 e sua capacidade de 300 agents paralelos é novo teto para escala de multi-agent orchestration — atualiza [[03-RESOURCES/entities/Kimi-K2.6]]
- A distinção clear de que Claude = raciocínio/contexto, não execução, é útil para posicionamento no vault
- Cursor 3 Design Mode (click → agent edits only that) é uma capability de execução que merece nota para futura integração

> [!contradiction]
> A fonte atribui a Hermes Agent status de "#1 most-used AI agent world" por daily inference no OpenRouter (maio 2026) — isso pode ser exagerado ou contexto limitado ao OpenRouter. Verificar com fontes adicionais.

## Links

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/entities/Kimi-K2.6]]
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
