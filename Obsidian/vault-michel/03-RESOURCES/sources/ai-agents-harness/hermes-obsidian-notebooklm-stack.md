---
title: "Wire Hermes + Obsidian + NotebookLM (2026 Build Guide)"
type: source
category: ai-agents
source: "Clippings/Wire Hermes + Obsidian + NotebookLM (2026 Build Guide).md"
url: "https://www.tonyreviewsthings.com/wire-hermes-agent-obsidian-notebooklm-stack/"
author: "Tony Simons (@tonysimons_)"
published: 2026-06-07
created: 2026-06-09
ingested: 2026-06-09
tags: [source, ai-agents, obsidian, hermes, notebooklm, pkm-obsidian, automation]
---

# Wire Hermes + Obsidian + NotebookLM (2026 Build Guide)

## Tese central

Um cron job Hermes pode ler o vault Obsidian, enviar novas fontes a um notebook NotebookLM, fazer uma pergunta com grounding, e escrever a resposta de volta ao vault — totalmente automático, custo zero de tokens LLM na etapa de coleta.

Os três tools cobrem três jobs distintos que se tocam apenas nas costuras:
- **Obsidian** — substrato durável, markdown local-first que você possui
- **NotebookLM** — sandbox de pesquisa delimitada, LLM grounded nas fontes que você fez upload
- **Hermes** — operador que roda o loop em schedule, move bytes entre os dois, mantém memória de quem você é entre sessões

## Argumentos principais

1. **No-agent cron mode é o primitivo barato:** 10 linhas de bash, zero tokens LLM, escala a milhares de arquivos sem tocar endpoint pago. Maioria dos leitores não sabe que essa parte do Hermes existe.

2. **Prove the cheap primitive first:** Step 6 (cron) antes de Steps 4, 5, 7 (skills LLM-calling). Se o cron roda limpo e os arquivos certos chegam no notebook certo, o resto é série de adições, não nova arquitetura.

3. **O loop é o produto, não as notas:** Hermes transforma dois tools estáticos (Obsidian + NotebookLM) em loop. Sem operador agendado, não há loop.

4. **NotebookLM não tem API pública (consumidor):** `notebooklm-py` v0.7.1+ usa Playwright para dirigir a UI web. Enterprise tem API standalone. Wrapper pode quebrar sem aviso — ter fallback.

## Key insights

- **`find -newer .last-pushed`** é o mecanismo de idempotência: cron que roda duas vezes numa hora não faz double-upload. Sentinel file `.last-pushed` garante delta correto.
- **Nunca rephrase via Hermes a resposta do NotebookLM:** perde a cadeia de citação. Sempre pull direto do `notebooklm ask` response. Se quiser versão mais compacta, re-enviar para NotebookLM — não trocar de operador.
- **Notebook ID como variável first-class:** track `notebook_id` em `Sources/.notebook-id`; skill de pull faz assert antes de chamar. "I don't have any sources" = notebook resetado ou ID errado.
- **Secrets nunca em skill files:** todo credential em `~/.hermes/.env` referenciado por env var. Notebook ID é constante commitável; Bearer token não.
- **MCP wire:** `hermes mcp add --url https://127.0.0.1:27124/mcp/ --auth header obsidian` salva token em `MCP_OBSIDIAN_API_KEY`. Config YAML idêntico ao padrão de outros MCP servers.
- **Local REST API v4.1.3 (2026-06-04):** corrigiu path-traversal vulnerability. Atualizar antes de ir live.
- **8am briefing como observable loop:** `Briefings/YYYY-MM-DD.md` gerado por cron diário — vault como destino de outputs, não só fonte.

## Exemplos e evidências

### Cron script core (Step 6)
```bash
#!/usr/bin/env bash
set -euo pipefail
NOTEBOOK_ID="${NOTEBOOK_ID:?set NOTEBOOK_ID in ~/.hermes/.env}"
VAULT_SOURCES="$HOME/Documents/MainVault/Sources"
LAST_PUSHED="$VAULT_SOURCES/.last-pushed"

find "$VAULT_SOURCES" -maxdepth 1 -name '*.md' -newer "$LAST_PUSHED" \
  | while read -r file; do
      if notebooklm source add "$NOTEBOOK_ID" "$file" >/dev/null 2>&1; then
        echo "$(date -u +%FT%TZ) ok $file" >> "$LAST_PUSHED".log
      else
        echo "$(date -u +%FT%TZ) FAIL $file" >> "$VAULT_SOURCES/.errors"
      fi
    done
touch "$LAST_PUSHED"
```

### Hermes skill: obsidian-notebooklm-push
SKILL.md em `~/.hermes/skills/obsidian-notebooklm-push/` — lista arquivos em `Sources/` via MCP Obsidian mais novos que `.last-pushed`, chama `notebooklm source add` para cada um, atualiza sentinel. Falha por arquivo = log em `.errors`, não aborta o run.

### Hermes skill: obsidian-notebooklm-pull
SKILL.md em `~/.hermes/skills/obsidian-notebooklm-pull/` — chama `notebooklm ask "$QUESTION" --notebook "$NOTEBOOK_ID" --format json`, extrai answer + citation list, escreve `Research/YYYY-MM-DD-<slug>.md` via MCP Obsidian com frontmatter completo (question, timestamp, notebook_id, citations). Abort se resposta sem citações — grounding é o ponto.

### 4 failure modes identificados
1. Hermes hallucinating citation — rephraseou a resposta internamente, perdeu grounding
2. Ask to empty notebook — notebook ID mudou entre push e pull
3. Vault/notebook drift — rename em Obsidian desincroniza citation path
4. Secrets em skill files — hardcoded token ou notebook ID no SKILL.md

### Custo
| Plan | Preço |
|------|-------|
| Google AI Free | $0 |
| Google AI Plus | $7.99/mo |
| Google AI Pro | $19.99/mo |

Hermes = MIT open source. Obsidian = free personal. Loop inteiro roda no free tier para a maioria dos builders.

## Implicações para o vault

- **vault-michel já tem o substrato:** pasta `Sources/` equivalente ao padrão descrito; `Clippings/` = feed de captura pronto.
- **Hermes Obsidian provider v0.14 já documentado** em [[03-RESOURCES/entities/hermes]] — `hermes mcp add` é o mesmo wire descrito aqui, confirmação cruzada de padrão.
- **no-agent cron mode** é alternativa de custo zero ao pipeline-diário agendado atual — útil para sync Obsidian→NotebookLM de forma contínua sem consumir tokens Claude.
- **`notebooklm-py` vs `notebooklm-mcp-cli`** — este artigo usa `notebooklm-py` (teng-lin); [[03-RESOURCES/concepts/pkm-obsidian/notebooklm-integration]] documenta `notebooklm-mcp-cli` (jacob-bd). Dois wrappers diferentes para o mesmo produto sem API pública.
- **Morning briefing pattern:** `Briefings/YYYY-MM-DD.md` via cron é paralelo ao `05-DAILY/` do vault — considerar integração.

## Links

- [[03-RESOURCES/entities/hermes]] — entidade Hermes, Obsidian provider v0.14, dreaming plugin
- [[03-RESOURCES/entities/NotebookLM]] — produto Google, acesso programático
- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]] — arquitetura 7-layer memory + self-improvement
- [[03-RESOURCES/concepts/pkm-obsidian/notebooklm-integration]] — padrão de integração NotebookLM (via jacob-bd wrapper)
- [[03-RESOURCES/sources/hermes-agent/hermes-agent-obsidian-vault-integration]] — integração nativa v0.14
- [[03-RESOURCES/sources/hermes-agent/hermes-kanban-field-manual-tonysimons]] — mesmo autor, field manual Kanban
- [[03-RESOURCES/sources/hermes-agent/hermes-dreaming-reviewable-self-improvement]] — plugin dreaming, mesmo autor (@tonysimons_)
