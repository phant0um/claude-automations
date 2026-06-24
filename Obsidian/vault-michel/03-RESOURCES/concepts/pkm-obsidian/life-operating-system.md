---
title: Life Operating System
type: concept
status: developing
tags: [claude-code, personal-assistant, automation, workflow, productivity, life-management]
updated: 2026-05-19
---

# Life Operating System

## O que é

Um "Life OS" é um sistema integrado de automação pessoal que gerencia tanto trabalho quanto vida via AI agent. O termo foi popularizado por [[03-RESOURCES/entities/Sid-Bharath]] no artigo [[03-RESOURCES/sources/guides-courses-howtos/how-i-built-jarvis-personal-ai-assistant]] com o projeto "Jarvis".

Distingue-se de um PKM (Personal Knowledge Management) por ser **ativo**: não apenas armazena informação, mas age — planeja, faz follow-up, rascunha, rastreia, revisa — automaticamente.

## Diferença de um Second Brain

| Dimensão | Second Brain (PKM) | Life Operating System |
|----------|-------------------|----------------------|
| Foco | Capturar e recuperar conhecimento | Executar e automatizar tarefas |
| Ação | Passivo (você consulta) | Ativo (age por você) |
| Integrações | Arquivos locais | Gmail, Calendar, APIs externas |
| Exemplo | [[03-RESOURCES/entities/Obsidian]] + QMD | Jarvis (Claude Code) |

## Arquitetura do Jarvis (referência)

```
jarvis/
├── CONTEXT.md           # identidade, preferências, como trabalha
├── daily/               # planos diários (YYYY-MM-DD.md)
├── projects/
│   └── client-x/
│       └── CLAUDE.md    # contexto do projeto (ativa via path-scoping)
├── contacts/            # CRM markdown (clients, network, personal)
├── tracking/            # habits, fitness, goals
├── workflows/           # commands reutilizáveis
└── scripts/             # gerados pelo Claude automaticamente
```

O arquivo `CONTEXT.md` é o identity file — equivalente ao system prompt de um agent, mas em linguagem natural descrita pelo próprio usuário em entrevista com Claude.

## Princípio central: All Your Work is Code

Toda tarefa administrativa repetitiva é uma série de chamadas de API e operações de arquivo. Claude Code executa essas operações sem que o usuário precise entender a implementação.

**Pergunta de diagnóstico:** "Am I doing the same thing I did last week, just with different data?" Se sim, é candidato à automação via Life OS.

## Workflows-chave

- **`/plan-day`** — combina calendário + tasks + email urgente → plano priorizado
- **`/email-triage`** — categoriza emails (URGENT/THIS WEEK/FYI/ARCHIVE) + rascunha respostas
- **`/weekly-review`** — lê todos os planos da semana + conta tasks + identifica follow-ups atrasados
- **`/follow-up-check`** — identifica contatos sem resposta + rascunha follow-ups personalizados

## Mental shift necessário

De AI como **research assistant** (responde perguntas, você age):
- "Quais são as melhores estratégias para email?" → você implementa

Para AI como **executive assistant** (age por você):
- "Check my email and draft responses for anything urgent" → Claude executa

**Pergunta certa:** "O que eu delegaria a um assistente humano se tivesse um?" — essa é a roadmap do Life OS.

## Jornada de adoção (recomendada)

1. Task tracking simples (tasks.md) — 1 semana
2. Email integration (Gmail OAuth) — ~15 min setup
3. Calendar integration (reutiliza credenciais)
4. Primeiro workflow composto (/plan-day)
5. CRM pessoal (contacts.md auto-atualizado)
6. Expansão para vida pessoal (tracking/)
7. Iteração contínua por conversa

## Personal CFO — Implementação Financeira do Life OS

Padrão descrito por [[03-RESOURCES/entities/Miles-Deutscher]] em [[03-RESOURCES/sources/pkm-obsidian-second-brain/claude-personal-cfo-investor-os-guide]]. Aplica a arquitetura do Life OS especificamente a finanças pessoais.

### Folder architecture

```
Investment Folder/
├── instructions.md        # role + regras operacionais do Claude
├── memory.md              # change log auto-atualizado (ver abaixo)
├── investor-one-pager.md  # identidade do investidor (output da entrevista)
└── financials/
    ├── pnl-summary.md
    └── bank-statement-[month]-[year].md
```

### memory.md como change log auto-atualizado

O arquivo `memory.md` é o equivalente financeiro do `CONTEXT.md` do Jarvis — mas com uma diferença crucial: a regra em `instructions.md` obriga Claude a **atualizar o arquivo imediatamente** quando nova informação surge na conversa (mudanças de vida, novos ativos, evolução de tese, constraints).

Estrutura: entradas em ordem cronológica reversa, cada uma datada. Append-only — nunca sobrescrever.

```markdown
# Change Log
**14 Apr 2026**
Investor one-pager finalised. Goals reframed from numerical to mindset states.

**24 Mar 2026**
Drawdown tolerance restated: can sleep through 60% paper drawdown.

*New entries go above this line.*
```

Este é o mecanismo que elimina o "context amnesia" — Claude nunca esquece preferências financeiras porque é forçado a persistí-las no arquivo.

### Investor One-Pager — Entrevista 7 fases McKinsey

Antes de montar o folder, gera-se o `investor-one-pager.md` via entrevista estruturada em 7 fases com Claude:

1. Situation & Constraints (residência, renda, liquidez, tempo disponível)
2. Capital & Horizon (bandas de capital, split tático/core/geracional)
3. Philosophy & Mindset (crenças do próprio usuário, não citações de livros)
4. Behavioural Nuance (blind spots, gatilhos históricos, guardrails existentes)
5. Preferences & Anti-Preferences (o que compra / o que categoricamente não compra)
6. Goals em forma de mindset, não numérica
7. Stress Tests — 4 hipotéticos agressivos para expor gaps entre filosofia declarada e comportamento provável

Regras do interviewer: uma pergunta por vez, sem fluff, sem elogio, contradições nomeadas diretamente, documento final na voz do usuário.

Output: arquivo markdown que funciona como context document permanente injetável em qualquer sessão AI ou conversa com advisor.

### Acesso mobile

| Padrão | Mecanismo |
|--------|-----------|
| Telegram BotFather | Cria bot no Telegram para acesso ao CFO em tempo real; automated market reports |
| Claude Dispatch | Cowork → Dispatch; conecta em ~60s; acessa pastas desktop pelo celular |

### NotebookLM — pipeline YouTube→contexto financeiro

Ingere transcritos de vídeos financeiros do YouTube no NotebookLM, depois consulta: "based on this video and market thesis, how should I adjust my portfolio?" Ver [[03-RESOURCES/concepts/pkm-obsidian/notebooklm-integration]].

## Relação com outros conceitos do vault

- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — CLAUDE.md por projeto é o padrão de path-scoping aplicado ao Life OS
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — CONTEXT.md como identity file rico elimina reexplicação a cada sessão
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] — complementar: PKM captura conhecimento; Life OS executa tarefas
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — workflows do Jarvis são equivalentes funcionais de hooks automatizados
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — Jarvis é harness pattern implementado via conversa, sem código manual

## Custos (2026)

- Claude Pro: $20/mês
- Claude Max: $100-200/mês (uso intenso)
- Google Cloud APIs: gratuitas em volumes pessoais típicos

## Evidências

- **[2026-06-21]** A progressão da IA é chatbot (2023) → copiloto (2024) → agente (2025) → infraestrutura pessoal (2026). Personal AI Infrastructure (PAI) — life OS construído sobre Claude Code, com 12.100 stars/1.700 forks — exemplifica essa última camada... — [[a-developer-built-an-operating-system-for-his-life-on-top-of-claude-it-saves-him]]
