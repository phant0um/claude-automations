---
title: "Garry Tan Built a 24/7 AI Engineering Team for Free"
type: source
source_file: Clippings/Garry Tan Built a 247 AI Engineering Team for Free.md
origin: thread X
author: "@Suryanshti777"
ingested: 2026-05-14
tags: [gstack, garry-tan, yc, software-factory, ai-native, multi-agent, open-source]
---

# Garry Tan Built a 24/7 AI Engineering Team for Free

> [!key-insight] Insight principal
> GStack não é uma ferramenta de coding — é uma "software factory" para a era AI-native: divide o workflow em papéis operacionais especializados (CEO, QA, Security, Designer, SRE...) e força todas as conversas necessárias antes da implementação via `/office-hours`.

## Content summary

### O que é GStack

GStack é um sistema open-source MIT que trata AI como um time com papéis especializados:

| Papel | Responsabilidade |
|-------|-----------------|
| CEO | Visão e priorização |
| Staff Engineer | Arquitetura |
| QA Lead | Testes e qualidade |
| Security Officer | Vulnerabilidades |
| Designer | UX e estética |
| Release Engineer | Deploy e verificação |
| DevEx Reviewer | Experiência de desenvolvimento |
| SRE | Confiabilidade |
| Technical Writer | Documentação |

### Comandos-chave

- `/office-hours` — interroga a ideia de produto antes de implementar: pain points, premissas ocultas, scope traps, falhas. Mais próximo de conversa com YC partner do que de assistente de código.
- `/review`, `/qa`, `/cso`, `/benchmark`, `/ship` — camadas de verificação agressiva

### A inovação real: Process > Prompting

> "A mediocre prompt inside a strong operational system beats a brilliant prompt inside chaos."

GStack codifica disciplina de workflow diretamente no ciclo de desenvolvimento:
**Think → Plan → Build → Review → Test → Ship → Reflect**

### QA com browser real (Playwright)

Lança browser real, clica botões, navega flows, encontra estados quebrados, gera regression tests — não simula.

### O insight da frase de Karpathy (Março 2026)

> "I don't think I've typed like a line of code probably since December."

O bottleneck não é mais digitar código — é **orquestração**. GStack ataca exatamente esse bottleneck via automação de processo, não de sintaxe.

### Browser layer como diferencial subestimado

- Sessões autenticadas persistentes
- Multi-tab, navegação real, handoffs entre agents
- Expande AI para o trabalho que acontece dentro de browsers (QA, admin panels, CMS, dashboards)

### Suporta múltiplos modelos/harnesses

Claude Code, Codex CLI, Cursor, Gemini, OpenClaw — convergindo para infraestrutura, não tooling.

### Garry Tan reportou (rodando YC full-time)

- 3 production services
- 40+ features
- Fator limitante: não "posso codificar isso?" mas "posso coordenar sistemas efetivamente?"

## Conexões

- [[03-RESOURCES/entities/Garry-Tan]] — atualizar com GStack detail
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — roles especializados
- [[03-RESOURCES/concepts/resolver-pattern]] — routing e governance
- [[03-RESOURCES/sources/ai-agent-stack-2026]] — stack complementar
- [[03-RESOURCES/entities/Andrej Karpathy]] — frase citada como turning point
