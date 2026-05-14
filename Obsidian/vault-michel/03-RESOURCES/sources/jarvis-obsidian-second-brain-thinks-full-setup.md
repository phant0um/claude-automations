---
title: "Most Second Brains Are Filing Cabinets. This One Thinks. I Built JARVIS In Obsidian. (Full Setup)"
type: source
source_file: "clippings/Most Second Brains Are Filing Cabinets. This One Thinks. I Built JARVIS In Obsidian. (Full Setup).md"
author: "@DamiDefi"
published: 2026-05-08
ingested: 2026-05-09
url: https://x.com/DamiDefi/status/2052714650483970066
tags: [jarvis, obsidian, second-brain, claude-code, setup-guide, vault-structure, content-production, pkm]
---

# Most Second Brains Are Filing Cabinets. This One Thinks.

**Autor:** [[03-RESOURCES/entities/DamiDefi]] | 2026-05-08 | Thread no X

## Tese central

A maioria dos vaults Obsidian prometem capturar seu pensamento mas não fazem nada com ele. São filing cabinets com busca melhor. A diferença deste sistema é **compounding**: depois de 30 dias é mais inteligente que no dia 1; depois de 6 meses conhece seu conteúdo melhor que qualquer dashboard de analytics.

Powered by [[03-RESOURCES/entities/Claude Code]] rodando dentro do diretório do vault, usando um `CLAUDE.md` como contrato de identidade.

> [!note] Relação com source anterior
> Este guia é estruturalmente idêntico ao [[03-RESOURCES/sources/jarvis-obsidian-claude-code-cyrilxbt]] (por @cyrilXBT). Mesma arquitetura de pastas, mesmas 4 skills, mesmo ritual diário. A diferença: DamiDefi é uma fonte independente publicada em maio 2026, atribuindo a si mesmo a autoria do setup. Ver [[03-RESOURCES/entities/DamiDefi]] para contexto.

## Os 4 jobs do sistema (em sequência)

1. **Captura** — zero fricção, raw, INBOX
2. **Conexão** — cross-domain, por princípio subjacente (não por keyword)
3. **Brief** — hook + closer prontos antes de escrever
4. **Loop de performance** — cada peça publicada retroalimenta o vault

## Estrutura do vault

```
JARVIS/
├── 00-INBOX/                  # Capturas brutas — velocidade, não estrutura
├── 01-CAPTURES/
│   ├── observations/
│   ├── reactions/
│   ├── patterns/
│   └── numbers/
├── 02-CONNECTIONS/            # Insights sintetizados de 2+ notas
├── 03-BRIEFS/                 # Fila de produção
├── 04-PUBLISHED/              # Arquivo com dados de performance
└── 05-CLAUDE/
    ├── CLAUDE.md
    ├── skills/
    └── context/
```

**Decisão arquitetural-chave:** organizar por **tipo** de nota, não por tópico. Tipo cria colisões; tópico cria silos. Colisões produzem conteúdo original.

## Setup (8 passos)

### Pré-requisitos
- Obsidian (obsidian.md — gratuito, markdown local)
- Claude Code: `npm install -g @anthropic/claude-code`
- Anthropic API key: `export ANTHROPIC_API_KEY=...`

### Step 1 — Vault architecture
Criar estrutura de pastas acima. Cada pasta tem um único job.

### Step 2 — 4 plugins essenciais
| Plugin | Função |
|--------|--------|
| Templater | Templates dinâmicos com lógica |
| Dataview | Query do vault como banco de dados |
| QuickAdd | Captura com um atalho (zero fricção) |
| Obsidian Git | Backup automático para GitHub a cada hora |

### Step 3 — CLAUDE.md (o arquivo mais importante)
Seções obrigatórias:
- **Identity** — nome, tópicos, audiência específica, content pillars
- **Vault Structure** — cada pasta descrita com precisão
- **My Voice** — estilo em termos concretos, não "conversacional e direto"
- **Hard Rules** — nunca tocar .env, nunca modificar PUBLISHED sem instrução explícita
- **Primary Jobs** — 5: process inbox, connections, briefs, write, log performance

> "Vague CLAUDE.md files produce vague output. Spend 45 minutes on it — the highest-leverage 45 minutes in the entire build."

### Step 4 — Conectar Claude Code ao vault
```bash
cd ~/path/to/JARVIS-vault
claude
```
Teste imediato: `Read my CLAUDE.md and tell me in two sentences what you understand about this vault, then tell me one thing that is missing or unclear.`

### Step 5 — As 4 skills

**Skill 1: Process Inbox** (`05-CLAUDE/skills/process-inbox.md`)
- Lê INBOX, afina nota bruta em 1 frase precisa, 3 tags (pillar + type + topic), arquiva com data
- Quality bar: nota afiada deve funcionar standalone, lida por um estranho

**Skill 2: Weekly Connections** (`05-CLAUDE/skills/weekly-connections.md`)
- 4 tipos: TYPE A (cross-domain), TYPE B (contradição), TYPE C (pattern 3+), TYPE D (pergunta-resposta)
- Mínimo 3, máximo 5. Só conexões não-óbvias. Se o escritor encontraria sozinho → não qualifica.

**Skill 3: Generate Brief** (`05-CLAUDE/skills/generate-brief.md`)
- ONE THING + PROOF (número real) + READER TRANSFORMATION + THREE HOOKS + THREE CLOSERS
- Closer é escrito antes do meio, sempre

**Skill 4: Write Content** (`05-CLAUDE/skills/write-content.md`)
- Estrutura: hook → proof → body → closer
- Voice check: nenhuma frase deve soar como AI genérica

### Step 6 — Ritual diário (20 min)
| Minutos | Ação |
|---------|------|
| 1–5 | Capturar raw para INBOX |
| 6–10 | "process my inbox" |
| 11–15 | "conexões dos últimos 14 dias?" |
| 16–20 | "generate a brief for [conexão mais surpreendente]" |

### Step 7 — Sessão semanal (domingo)
Run weekly connections em 7 dias completos → review CONNECTIONS → 2 melhores → brief nas 2 → segunda com 2 peças prontas.

### Step 8 — Performance loop (mensal)
Logar após cada publicação em 04-PUBLISHED:
```
impressions: 443,000
bookmarks: 11,678
hook_used: [hook exato]
what_worked: [avaliação honesta]
```
Sessão mensal: bookmarks/impression por tópico, formatos acima da média, ângulos inexplorados.

## Troubleshooting

- **Vault fica ruidoso:** INBOX com notas > 48h não processadas → deletar (não arquivar)
- **Claude Code perde contexto:** fechar e reabrir sessão antes de rodar skills em vault grande
- **CLAUDE.md deriva da voz real:** revisar a cada 60 dias comparando com seus melhores posts recentes

## Compounding ao longo do tempo

- 30 dias: nunca sem ideias (03-BRIEFS cheio)
- 90 dias: conexões surpreendentes de 3 meses atrás
- 6 meses: vault conhece sua audiência melhor que analytics — lê conteúdo + dados juntos

## Conexões no vault

- [[03-RESOURCES/sources/jarvis-obsidian-claude-code-cyrilxbt]] — guia anterior estruturalmente idêntico (@cyrilXBT)
- [[03-RESOURCES/sources/how-i-built-jarvis-personal-ai-assistant]] — Jarvis focado em life OS (Sid Bharath)
- [[03-RESOURCES/concepts/obsidian-jarvis-content-system]] — conceito consolidado deste padrão
- [[03-RESOURCES/concepts/second-brain]] — base conceitual PKM
- [[03-RESOURCES/concepts/claude-skills]] — as 4 skills são instâncias do padrão SKILL.md
- [[03-RESOURCES/concepts/knowledge-compounding]] — princípio do vault que aprende com o tempo
- [[03-RESOURCES/concepts/context-engineering]] — CLAUDE.md como núcleo de contexto rico
- [[03-RESOURCES/entities/Obsidian]] — ferramenta base
- [[03-RESOURCES/entities/Claude Code]] — camada de inteligência
- [[03-RESOURCES/entities/DamiDefi]] — autor
