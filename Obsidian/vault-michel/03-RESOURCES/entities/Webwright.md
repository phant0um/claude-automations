---
title: Webwright
type: entity
category: framework
created: 2026-05-29
updated: 2026-05-29
tags: [browser-agent, microsoft, playwright, sota, code-as-action, web-tasks]
---

# Webwright

Framework open-source de browser agent desenvolvido pela [[03-RESOURCES/entities/Microsoft-Research-Asia]] (Lu Yadong, Xu Lingrui, Huang Chao, Awadallah Ahmed). Publicado em 2026-05-04. Alcançou SOTA em dois benchmarks reais de web tasks com apenas ~1.5k linhas de código.

## Filosofia

> "No multi-agent system, no graph engine, no plugin layer, no hidden orchestration — just a terminal, a browser, and a model."

Inverte o paradigma dominante: o browser é um ambiente que o agente **lança, inspeciona e descarta** — não o workspace. O artefato persistente é o **código e logs no workspace local**. Isso é o que Webwright chama de "workspace-as-state".

## Performance

| Benchmark | Resultado | Comparação |
|---|---|---|
| Online-Mind2Web (300 tasks, N=100) | **86.7%** (GPT-5.4) | Maior entre harnesses open-source |
| Online-Mind2Web | **84.7%** (Claude Opus 4.7) | Mais forte no hard split (80.5%) |
| Odysseys long-horizon (200 tasks, N=100) | **60.1%** (GPT-5.4) | +15.6pt sobre SOTA anterior |
| Odysseys SOTA anterior | 44.5% (Opus 4.6, vision+persistent browser) | |
| Base GPT-5.4 sem Webwright | 33.5% | +26.6pt com Webwright |

## Arquitetura

- Core agent loop: ~450 linhas
- Playwright environment: ~570 linhas
- CLI: ~150 linhas
- Backends: OpenAI, Anthropic, OpenRouter (~150-200 linhas cada)
- Dependências: `httpx`, `pydantic`, `playwright`, `typer`
- Flat loop: prompt → observe → execute script

## Comandos principais

- `/webwright:run` — script one-shot para valores literais da task
- `/webwright:craft` — CLI tool parametrizável e reutilizável
- Task2UI mode: renderiza resultados em web app HTML navegável

## Integração como plugin/skill

Roda nativamente como plugin em: Claude Code, OpenAI Codex, OpenClaw, Hermes Agent — mesma `skills/webwright/` folder funciona em todos.

Instalação Claude Code:
```
/plugin marketplace add microsoft/Webwright
/plugin install webwright@webwright
```

## Diferencial chave

Scripts gerados podem ser parametrizados como CLI tools — até Qwen-3.5-9B completa tasks bem em sites com 5+ tools disponíveis. Isso demonstra que reutilização de tools compensa capacidade do modelo.

## Fontes

- [[03-RESOURCES/sources/ai-agents-harness/microsoft-webwright-browser-agent-framework]]
