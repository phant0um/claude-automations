---
title: "Hermes Agent + Obsidian Vault = AI Brain"
type: source
source: "Clippings/Hermes Agent + Obsidian Vault = AI Brain.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Obsidian + Hermes Agent é o setup concreto para um segundo cérebro funcional: Obsidian armazena contexto como arquivos markdown legíveis por humanos, Hermes lê esse contexto, executa trabalho com ferramentas e cron jobs, e escreve resultados de volta ao vault — mantendo o markdown como source of truth inspecionável e editável.

## Argumentos principais

- O vault deve ser a camada de memória legível por humanos; Hermes é o executor que lê, age e escreve de volta — não uma caixa preta que lembra coisas em algum lugar que você nunca abre
- Filesystem MCP com boundary explícito: Hermes acessa apenas a pasta do vault, não o laptop inteiro — isso é a diferença entre "ferramenta útil" e "agente que fica assustador"
- Regra de ouro: primeiro 7 dias output-only em `05-HERMES-OUTPUTS/` — não deixar o agente espalhar arquivos pelo vault antes do sistema ser confiável
- Construir um workflow de cada vez, não sete automações no dia 1

## Key insights

- Estrutura mínima recomendada: `00-INBOX/` → `01-DAILY/` → `02-PROJECTS/` → `03-NOTES/` → `04-RESOURCES/` → `05-HERMES-OUTPUTS/` (briefings/, inbox/, projects/, research/, reviews/) → `06-SYSTEM/` (CLAUDE.md, templates/)
- O arquivo `06-SYSTEM/CLAUDE.md` é um "steering file" — toda skill recorrente parte daí em vez de perguntar as mesmas coisas; deve ser atualizado semanalmente
- Os 5 workflows que valem construir primeiro (em ordem): (1) morning brief (prova o loop completo), (2) inbox processor (propõe filing, não move automaticamente na semana 1), (3) project health check (revela onde você está se enganando), (4) weekly synthesis (conecta daily notes + projects + outputs), (5) connection finder (sugere wikilinks via relatório, você decide)
- Safety setup: scope filesystem MCP apenas ao vault, proibir deleção nos primeiros dias, exigir review para mudanças de status de projeto e conteúdo sensível, secrets nunca entram no vault
- Cron jobs devem ser instruções de operação explícitas: skill a usar + pastas a ler + onde escrever + o que não fazer + quando pedir review

## Exemplos e evidências

- Comando de instalação: `curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash`
- MCP setup: `hermes mcp add obsidian_fs --command npx --args -y @modelcontextprotocol/server-filesystem "/path/to/vault"`
- Skill starter para morning brief: SKILL.md com 6 passos (ler CLAUDE.md → daily note → projetos → última weekly review → gerar brief → salvar em `05-HERMES-OUTPUTS/briefings/YYYY-MM-DD-morning-brief.md`)
- Cron example: `hermes cron create "0 6 * * *"` com prompt explícito de operação
- "Build it like a reliable system, not like a weekend Notion template"

## Implicações para o vault

Este guia é uma versão externa do que o vault-michel já implementa — com Hermes em vez de Claude Code. A estrutura de pastas sugerida (`00-INBOX` através `06-SYSTEM`) é muito próxima da estrutura atual do vault. O padrão de steering file (`CLAUDE.md`) é idêntico ao que já existe. Valida a arquitetura atual e oferece refinamentos: o pattern de output-zone dedicada e a construção incremental de um workflow por vez. A connection finder skill descrita é análoga ao `connection-finder.md` existente neste vault.

## Links

- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/concepts/pkm-obsidian]]
- [[03-RESOURCES/concepts/second-brain]]
- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]
- [[03-RESOURCES/concepts/externalized-memory]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
