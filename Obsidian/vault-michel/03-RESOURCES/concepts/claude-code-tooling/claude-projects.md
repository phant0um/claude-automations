---
title: Claude Projects
type: concept
status: developing
tags: [claude, projects, knowledge-base, workflow, colaboração, rag]
created: 2026-04-19
updated: 2026-04-19
---

# Claude Projects

Workspaces auto-contidos em Claude.ai com memória própria, histórico de chats, knowledge base e instruções customizadas. Resolvem o problema de ter que re-fazer upload dos mesmos documentos e re-explicar contexto em cada nova conversa.

> [!key-insight] Distinção central
> **Projects** = onde fica o conhecimento (o QUÊ). **Skills** = como Claude executa tarefas (o COMO). Os dois se complementam: uma skill pode referenciar o conhecimento num project.

## O que um Project contém

- **Knowledge base** — documentos uploadados (PDF, DOCX, CSV, TXT, HTML, Google Drive)
- **Instructions** — como Claude deve se comportar em TODOS os chats do projeto
- **Chat history** — todas as conversas dentro do project
- **Memory** — contexto acumulado ao longo do tempo

## Quando criar um Project

Crie quando o workflow tiver:
- Materiais de referência usados repetidamente (meeting notes, survey results, brand guidelines)
- Requisitos consistentes de formato/tom/estilo
- Necessidade de colaboração de equipe com a mesma base

## Instructions — o que incluir

```
- Contexto do trabalho: "Este project é para criar conteúdo de marketing B2B"
- Process instructions: "Primeiro considere estrutura, depois escreva o draft"
- Preferências de tom: "Tom profissional mas conversacional. Evite jargão."
- Requisitos específicos: "Sempre inclua CTA no final de copy de marketing"
```

## RAG automático

Quando o knowledge base se aproxima do limite do context window, o Project ativa automaticamente **Retrieval Augmented Generation (RAG)**:
- Ao invés de carregar TODOS os documentos na memória, Claude busca apenas o mais relevante
- Expande capacidade em até **10x**
- Indicador visual quando ativado
- Experiência de uso idêntica para o usuário

## Permissões (Team/Enterprise)

| Nível | O que pode fazer |
|---|---|
| Can view | Ver conteúdo, acessar knowledge, conversar — sem modificar |
| Can edit | Modificar instructions, update knowledge, gerenciar membros |
| Owner | Controle total, incluindo quem pode ver o project |

## Projects vs Skills

| | Projects | Skills |
|---|---|---|
| Purpose | Armazenam conhecimento | Definem processos |
| Best for | Contexto de longo prazo, referências, colaboração de time | Workflows repetíveis, multi-step, metodologia consistente |
| Exemplo | Hub de cliente, base de pesquisa | Brand guidelines, criação de PDF, análise de dados |
| Como persiste | Disponível em todos os chats do project | Instruções aplicadas quando skill é invocada |

## Exemplos práticos

- **Q4 Product Launch** — specs, competitive analysis, messaging notes
- **Research Buddy** — revisão competitiva, user research, customer feedback
- **Client Account Hub** — brand guidelines, deliverables passados, histórico de comunicação
- **Job Description Generator** — JDs antigas, team charters, headcount requests

## Enterprise Search

Projects de escala organizacional. Ver [[03-RESOURCES/concepts/claude-enterprise-search]].

## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/claude-101-anthropic-course]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — o complemento procedimental

## Evidências
- **[2026-06-24]** Claude é uma workbench de longo prazo, não search box. 10 passos: Project → identity → Instructions → Memory →... — [[claude-zero-base-workbench-guide]]
- **[2026-06-24]** Tutorial eve: scaffold → set model → analyst persona → run. npx eve init cria agente com dev server, agent.ts define... — [[your-first-agent-eve]]
