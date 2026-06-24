---
title: Self-Writing Vault
type: concept
status: developing
tags: [obsidian, pkm, automation, claude-code, mcp, n8n, knowledge-compounding]
created: 2026-05-09
updated: 2026-06-09
---

# Self-Writing Vault

Padrão arquitetural onde um vault Obsidian deixa de ser repositório passivo para se tornar sistema de inteligência ativo: lê a si mesmo, processa conteúdo e deposita outputs de volta — sem intervenção humana para cada operação.

Introduzido por [[03-RESOURCES/entities/CyrilXBT]] em maio 2026.

## O shift fundamental

| Modelo archival (padrão) | Modelo operacional (self-writing) |
|--------------------------|-----------------------------------|
| Evento → você escreve → você arquiva | Evento → sistema lê → sistema processa → output arquivado automaticamente |
| Vault cresce; intelligence para | Vault cresce; intelligence cresce junto |
| Busca manual | Conexões descobertas autonomamente |

## Três camadas necessárias

1. **Knowledge layer** — Obsidian (Markdown estruturado, taxonomia consistente)
2. **Connection layer** — MCP (`server-filesystem`) dando ao Claude acesso direto read/write
3. **Intelligence layer** — Claude Code + workflows agendados ou triggerados

Remover qualquer camada colapsa o sistema num subconjunto menos potente.

## Padrões estruturais obrigatórios

- `Generated/` — outputs autônomos (nunca editar manualmente)
- `Queue/` — interface assíncrona: arquivo com verbo+tópico → Claude processa → output em Generated/
- `CLAUDE.md` como constituição: hard rules, projetos ativos, voz, prioridades

## Workflows canônicos

1. **Daily Context Generator** — síntese matinal automática (N8N cron 6h)
2. **Connection Finder** — conexões não-óbvias entre notas novas e arquivo existente
3. **Queue Processor** — execução assíncrona de tarefas dropadas pelo usuário
4. **Weekly Synthesis** — retrospectiva estruturada semanal
5. **Project Auto-Updater** — overview de projeto atualizado a cada mudança
6. **Knowledge Distillation Engine** — destilação mensal de grupos de notas

## Efeito de compounding

O self-writing vault não aprende no sentido de machine learning, mas no sentido prático: outputs do mês 3 são melhores que os da semana 1 porque o sistema tem 3 meses de pensamento do usuário para trabalhar. Cada workflow se beneficia de cada nota que já foi escrita.

## Diferença do [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] tradicional

Second Brain tradicional: você deposita, você busca. Self-writing vault: o sistema deposita, o sistema conecta, você revisa. A agência se inverte.

## Infraestrutura de automação

N8N self-hosted (~$5/mês DigitalOcean) como trigger system. Padrão por workflow: `Cron/FileWatch → HTTP Request (Claude API) → File Write → Notificação`.

## Padrão @zeuuss_01 — Hermes + Obsidian (Jun 2026)

Convergência independente via [[03-RESOURCES/entities/hermes]] em vez de N8N: 1 comando instala a camada de memória (Obsidian Local REST API + provider nativo Hermes). Resultado documentado: 1.400 notas, 23 skills em 6 semanas, <$20/mês, 0h manutenção manual.

**Insight chave**: o gargalo nunca foi captura — foi **ativação**. Cada nota nova aumenta o custo de manutenção enquanto a memória de trabalho humana permanece constante. Quando a ativação roda em agente, disciplina deixa de ser o fosso e vira o gargalo.

**SOUL.md como lente operacional** (não personalidade): obsessões atuais + como quer ser desafiado + o que nunca quer. Sem ele, o agente lê o vault como biblioteca de conteúdo; com ele, como sua operação.

Ver: [[03-RESOURCES/sources/obsidian-hermes-autonomous-system]]

## Evidências
- **[2026-06-22]** Guia replicável do padrão Obsidian (Vault) + Claude Code (Brain): vault melhora a cada uso porque conhecimento persiste em arquivo versionável, não em chat efêmero — confirma arquitetura "LLM Wiki" como base do self-writing vault — [[03-RESOURCES/sources/how-to-build-an-ai-second-brain-with-claude-and-obsidian-full-guide-he-s-getting-smarter-every-da]]

## Ver também

- [[03-RESOURCES/sources/pkm-obsidian-second-brain/obsidian-vault-writes-back-cyrilxbt]] — fonte principal (CyrilXBT, mai 2026)
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/obsidian-vault-smarter-every-day-automation]] — artigo anterior do mesmo autor (4 camadas, N8N)
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/jarvis-obsidian-claude-code-cyrilxbt]] — arquitetura JARVIS do mesmo autor
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] — conceito fundacional que este padrão estende
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] — mecanismo de valor crescente
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]] — padrão relacionado de manutenção de wiki por LLM
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — mecanismo de hooks Claude Code usado nos workflows
