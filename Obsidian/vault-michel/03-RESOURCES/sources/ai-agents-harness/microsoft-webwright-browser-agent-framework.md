---
title: "microsoft/Webwright: SWE-style browser agent framework achieving SOTA on long-horizon web tasks"
type: source
source: "Clippings/microsoftWebwright A simple SWE style browser agent framework that achieves SOTA results on long horizon web tasks..md"
original_url: "https://github.com/microsoft/Webwright"
author: "microsoft (Lu Yadong, Xu Lingrui, Huang Chao, Awadallah Ahmed)"
published: 2026-05-04
created: 2026-05-29
ingested: 2026-05-29
tags: [ai-agents, browser-agent, webwright, microsoft, sota, playwright, code-as-action]
---

## Tese central

Webwright inverte a arquitetura dominante de web agents: em vez de tratar a sessão do browser como workspace (state), trata o browser como ambiente que o agente pode lançar, inspecionar e descartar enquanto o workspace real são o código e logs no sistema de arquivos local. Essa inversão — "code-as-action" em vez de "predict-next-web-action" — resulta em SOTA em dois benchmarks reais com apenas ~1.5k linhas de código.

## Argumentos principais

- O paradigma dominant de web agents (agente recebe estado da página atual, prediz ação → click/type/DOM) é um bottleneck para modelos mais fortes: funciona para LLMs fracos, mas não escala com modelos que já são bons em escrever e debugar código
- Webwright separa agente do browser: o browser é simplesmente um ambiente que o agente spawna, inspeciona e descarta. O artefato persistente é o código e os logs no workspace local.
- Code-as-action vs. coordinate prediction: em vez de prever ações discretas por coordenada XY, o agente escreve scripts Playwright completos e os executa — interações multi-step viram programas compactos com loops, funções e abstrações
- Resultado: scripts podem ser reutilizados e parametrizados para tarefas similares, ao contrário de ações step-by-step que são irrepetíveis
- Zero hidden frameworks: core agent loop em ~450 linhas, Playwright environment em ~570 linhas, CLI em ~150 linhas. httpx + pydantic + playwright + typer.
- Roda como plugin/skill nativo em Claude Code, Codex, OpenClaw e Hermes Agent — mesma `skills/webwright/` folder

## Key insights

- **Workspace-as-state, not browser-as-state:** O agente pode escrever scripts exploratórios, spawnar sessões frescas, e decidir quando capturar screenshots — como um engenheiro humano iterando em um script RPA. Isso é qualitativamente diferente de prever o próximo click.
- **Task2UI mode (2026-05-11):** Webwright completa a task e renderiza resultados em uma web app HTML reutilizável — não apenas executa, também produz interface navegável dos resultados
- **Performance SOTA:**
  - Online-Mind2Web (300 tasks): **86.7%** com GPT-5.4 — maior entre harnesses open-source na categoria AutoEval
  - Claude Opus 4.7 atinge **84.7%** (mais forte no hard split: 80.5% vs 76.6% GPT-5.4)
  - Odysseys (200 long-horizon tasks): **60.1%** com GPT-5.4 — **+15.6 pontos** sobre SOTA anterior (Opus 4.6 em 44.5%)
  - +26.6 pontos sobre baseline GPT-5.4 com XY-coordinate prediction
- **Small models + reusable tools:** Scripts gerados podem ser empacotados como CLI tools parametrizadas. Até Qwen-3.5-9B completa tasks bem em Online-Mind2Web sites com 5+ tools disponíveis — demonstra que reutilização de tools compensa capacidade do modelo
- **Comparação arquitetural vs concorrentes:**

| Framework | Paradigma | Action space | O que é "state"? |
|---|---|---|---|
| Stagehand | Hybrid: code + NL primitives | Playwright code ou NL→Playwright | Browser session |
| agent-browser (Vercel) | CLI que outro agente chama | Subcommands discretos | Browser session (daemon) |
| browser-use | Autonomous LLM agent loop | Indexed click/type por LLM | Browser session |
| **Webwright** | **Coding agent com terminal** | **Free-form Python (escreve scripts Playwright)** | **Workspace local** |

- **/webwright:run vs /webwright:craft:** `:run` produz script one-shot para valores literais; `:craft` produz CLI tool parametrizável com flags que defaultam para os valores concretos — pode ser reexecutado com argumentos diferentes
- **Flat agent loop:** prompt → observe → execute script. Legível end-to-end, fácil de debugar, fácil de fazer fork.

## Exemplos e evidências

- Benchmarks (100-step budget):
  - Online-Mind2Web: 86.7% (GPT-5.4), 84.7% (Claude Opus 4.7)
  - Odysseys long-horizon: 60.1% (GPT-5.4), vs 44.5% SOTA anterior com Opus 4.6 e vision+persistent browser
  - Base GPT-5.4 sem Webwright: 33.5%
- Codebase: ~1.5k LoC total
- Backends suportados: OpenAI, Anthropic, OpenRouter (~150-200 linhas cada)
- Publicado em: 2026-05-04, SOTA alcançado de imediato
- Citations: inspirado em SWE-agent/mini-swe-agent para minimal agent loop design

## Implicações para o vault

- Confirma e amplia [[03-RESOURCES/concepts/agent-systems/browser-skills-agents|browser-skills-agents]] — Webwright é um case concreto de que o paradigma code-based supera o paradigma step-by-step para browser agents
- A "workspace-as-state" thesis conecta com [[03-RESOURCES/concepts/pkm-obsidian/file-as-bus|file-as-bus]] — estado em arquivos locais como artefato durável
- O design minimal (1.5k LoC, zero hidden frameworks) é um exemplo de [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering|agentic harness engineering]] em sua forma mais limpa
- Suporte para [[03-RESOURCES/entities/Microsoft-Research-Asia]] — adicionar Webwright como projeto notável
- A estratégia de "small models + reusable tools" é uma evidência nova e importante: supera a dependência de modelos maiores quando tools são bem projetadas

## Links

- [[03-RESOURCES/concepts/agent-systems/browser-skills-agents]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/web-agent-skill-learning]]
- [[03-RESOURCES/entities/Microsoft-Research-Asia]]
- [[03-RESOURCES/entities/Claude Code]]
