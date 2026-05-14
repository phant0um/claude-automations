---
title: Claude 101 — Curso Oficial Anthropic
type: source
source_type: official-course
author: Anthropic
created: 2026-04-19
updated: 2026-04-19
tags: [claude, anthropic, curso-oficial, prompting, projects, skills, artifacts, connectors]
---

# Claude 101 — Curso Oficial Anthropic

Curso introdutório oficial da Anthropic sobre uso de Claude. Cobre toda a stack de produtos e features: desde o primeiro prompt até Research mode, Enterprise Search e ferramentas especializadas.

> [!key-insight] Posição desta fonte
> É o guia canônico de uso do Claude para usuários de negócios (Claude.ai, Pro, Team, Enterprise). Não é sobre Claude Code/desenvolvimento — é sobre colaboração com IA no dia a dia de trabalho.

## Estrutura do curso

1. **What is Claude** — Constitutional AI, capabilities, planos
2. **First conversation** — framework de prompts: Stage + Task + Rules
3. **Getting better results** — iteração, desafios comuns, 4D Framework para AI Fluency
4. **Desktop app: Chat, Cowork, Code** — três modos distintos
5. **Projects** — workspaces persistentes com knowledge base e instructions
6. **Artifacts** — outputs interativos standalone (docs, código, HTML, SVG, Mermaid, React)
7. **Skills** — pacotes de instrução para workflows repetíveis
8. **Connectors** — integração com ferramentas via MCP
9. **Enterprise Search** — busca organizacional cross-tool
10. **Research mode** — investigação agentica multi-fonte
11. **Use cases por role** — Sales, Marketing, Finance, HR, Legal, Research
12. **Outros produtos** — Claude Code, Slack, Excel, Chrome

## Framework de prompts (3 elementos)

```
1. Setting the stage → Papel, contexto, objetivo
2. Defining the task  → Ação específica (write, analyze, build)
3. Specifying rules   → Formato, tom, exemplos
```

## 4D Framework para AI Fluency

Ver [[03-RESOURCES/concepts/4d-framework-ai-fluency]] — framework acadêmico (Dakan + Feller) com 4 competências.

## Distinção Projects vs Skills

| | Projects | Skills |
|---|---|---|
| Purpose | Armazenam conhecimento que Claude referencia | Definem processos que Claude executa |
| Best for | Contexto de longo prazo, materiais de referência, colaboração | Workflows repetíveis, multi-step, metodologia consistente |
| Exemplo | Hub de cliente, base de pesquisa | Brand guidelines, criação de PDF, análise de dados |
| Persistência | Disponível em todos os chats do projeto | Instruções aplicadas quando a skill é invocada |

Ver [[03-RESOURCES/concepts/claude-projects]] e [[03-RESOURCES/concepts/claude-skills]].

## Cowork — features-chave

- **Folder access** — aponta Claude a uma pasta local
- **Scheduled tasks** — tarefas recorrentes automáticas
- **Subagents** — workers paralelos para partes do task
- **Dispatch** — continua tasks no mobile (app + desktop aberto)
- **Browser use** — Claude navega Chrome diretamente
- **Computer use** — controle total do computador (preview)
- **Protected environment** — sandbox nas pastas autorizadas

## Modelos de interação do Code tab

| Modo | O que faz |
|---|---|
| Ask | Propõe toda mudança, espera aprovação |
| Code | Aplica mudanças mas confirma antes de rodar comandos |
| Plan | Detalha abordagem completa antes de tocar qualquer coisa |

## Research mode — como funciona

1. Extended Thinking ativado automaticamente
2. Claude planeja abordagem
3. Múltiplas buscas em cadeia (cada uma alimenta a próxima)
4. Síntese cross-source
5. Output com citações verificáveis

Duração: 5–45 minutos dependendo de complexidade.

## Fontes e links

- [[03-RESOURCES/concepts/4d-framework-ai-fluency]]
- [[03-RESOURCES/concepts/claude-projects]]
- [[03-RESOURCES/concepts/claude-artifacts]]
- [[03-RESOURCES/concepts/claude-connectors]]
- [[03-RESOURCES/concepts/claude-research-mode]]
- [[03-RESOURCES/concepts/claude-skills]]
- [[03-RESOURCES/entities/Rick-Dakan]]
- [[03-RESOURCES/entities/Joseph-Feller]]
