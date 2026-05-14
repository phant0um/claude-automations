---
title: "How to Build a JARVIS Inside Obsidian With Claude Code — The Full Setup"
type: source
author: "@cyrilXBT"
created: 2026-04-24
updated: 2026-04-24
tags: [obsidian, claude-code, second-brain, jarvis, pkm, content-production]
source_file: "Downloads/Arquivar2/How to Build a JARVIS Inside Obsidian With Claude Code — The Full….md"
---

# How to Build a JARVIS Inside Obsidian With Claude Code

**Autor:** [@cyrilXBT](https://x.com/cyrilXBT)

## Resumo

Guia completo para construir um sistema "JARVIS" — segundo cérebro + sistema de produção de conteúdo — dentro do Obsidian usando Claude Code. Diferente do [[03-RESOURCES/concepts/life-operating-system]] (Sid Bharath, focado em execução de tarefas pessoais), este guia foca em **geração de conteúdo e inteligência composta** ao longo do tempo.

## O que o sistema faz

1. **Captura** tudo com zero fricção (INBOX)
2. **Conecta** ideias automaticamente através do vault
3. **Gera briefs** de conteúdo a partir das conexões
4. **Escreve** no estilo exato do dono

## Estrutura do Vault

```
JARVIS/
├── 00-INBOX/                  # Capturas brutas — velocidade, não estrutura
├── 01-CAPTURES/
│   ├── observations/
│   ├── reactions/
│   ├── patterns/
│   ├── questions/
│   └── numbers/
├── 02-CONNECTIONS/            # Insights sintetizados de 2+ notas
├── 03-BRIEFS/                 # Fila de produção — hook + closer prontos
├── 04-PUBLISHED/              # Arquivo com dados de performance
└── 05-CLAUDE/
    ├── CLAUDE.md              # Arquivo mais importante do sistema
    ├── skills/
    └── context/
```

**Decisão arquitetural crítica:** organizar por tipo de nota (observations, patterns...) e não por tópico. Isso permite que Claude Code encontre conexões cross-domain automaticamente.

## Plugins essenciais

| Plugin | Função |
|--------|--------|
| Templater | Templates dinâmicos com lógica |
| Dataview | Query do vault como banco de dados |
| QuickAdd | Captura de nota com um atalho |
| Obsidian Git | Backup automático para GitHub a cada hora |

## CLAUDE.md — Arquivo mais importante

Seções obrigatórias:
- **Identity** — quem é o dono, o que faz, qual audiência, pillars
- **Vault Structure** — descrição de cada pasta
- **My Voice** — estilo de escrita em termos específicos
- **Hard Rules** — o que nunca fazer (arquivos .env, PUBLISHED, estrutura)
- **Primary Jobs** — 5 jobs: process inbox, connection sessions, generate briefs, write content, log performance

> Regra: 80% do CLAUDE.md deve ser restrições negativas — mais preciso que afirmações.

## As 4 Skills

### Skill 1: Process Inbox
**Trigger:** "process my inbox"

Processo:
1. Lê cada nota em 00-INBOX
2. Classifica no subfolder correto de CAPTURES
3. Afina nota bruta em uma frase precisa
4. Adiciona exatamente 3 tags
5. Reporta padrões notados + uma conexão a explorar

**Quality bar:** nota afiada deve ser específica o suficiente para um estranho entender sem contexto adicional.

### Skill 2: Weekly Connections
**Trigger:** "run connection session"

4 tipos de conexão:
- **TYPE A:** Mesmo princípio subjacente em dois domínios diferentes
- **TYPE B:** Contradição entre notas que cria tensão interessante
- **TYPE C:** Padrão conectando 3+ notas em um insight ainda sem nome
- **TYPE D:** Pergunta de uma nota que outra acidentalmente responde

Mínimo 3, máximo 5 conexões. Só as não-óbvias.

### Skill 3: Generate Brief
**Trigger:** "generate a brief for [topic]"

5 campos obrigatórios:
1. **ONE THING** — insight único em uma frase (se não couber, ideia não está pronta)
2. **PROOF** — exemplo real, número ou resultado (nada vago)
3. **READER TRANSFORMATION** — o que o leitor sabe/sente ao final
4. **THREE HOOKS** (rankeados) — agressivo / curioso / pessoal
5. **THREE CLOSERS** (rankeados) — closer é escrito antes do meio, sempre

### Skill 4: Write Content
**Trigger:** "write the brief for [topic]"

Estrutura: hook → proof → body → closer. Indistinguível do conteúdo escrito pelo dono.

## Ritual Diário (20 minutos)

| Minutos | Ação |
|---------|------|
| 1–5 | Capturar para INBOX — raw, sem polimento |
| 6–10 | "process my inbox" |
| 11–15 | "conexões dos últimos 14 dias?" |
| 16–20 | "generate a brief for [conexão mais surpreendente]" |

**Resultado:** brief pronto antes de abrir qualquer rede social.

## Sessão Semanal (domingo)

1. "run weekly connections skill" (últimos 7 dias)
2. Revisar CONNECTION notes criadas
3. Escolher as 2 mais fortes
4. Brief nas 2 → segunda-feira com 2 peças prontas para escrever

## Loop de Performance (mensal)

Adicionar dados ao PUBLISHED após cada peça:
```
impressions: 443,000
bookmarks: 11,678
engagement_rate: 0.04%
top_comment: [comentário com mais replies]
what_worked: Netflix format hook + Obsidian + Claude Code
```

Sessão mensal: Claude analisa PUBLISHED e retorna:
- Tópicos com mais bookmarks/impression
- Formatos de hook que superaram média
- 3 ângulos ainda não explorados
- Combinações para dobrar

## Compounding ao longo do tempo

- 30 dias: nunca sem ideias
- 90 dias: conteúdo mais específico, conectado, original
- 6 meses: vault como inteligência genuína — captura → conexão → feedback composto

## Conexões no vault

- [[03-RESOURCES/concepts/life-operating-system]] — abordagem complementar (Sid Bharath): execução de tarefas vs produção de conteúdo
- [[03-RESOURCES/concepts/second-brain]] — base conceitual PKM
- [[03-RESOURCES/concepts/claude-skills]] — as 4 skills deste sistema são instâncias de SKILL.md
- [[03-RESOURCES/concepts/obsidian-jarvis-content-system]] — conceito extraído deste guia
- [[03-RESOURCES/concepts/context-engineering]] — CLAUDE.md rico = contexto focado = melhor output
- [[03-RESOURCES/concepts/claude-folder-anatomy]] — 05-CLAUDE/ é análogo ao .claude/
