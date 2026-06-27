---
name: check-resolvable
description: "Use when auditing resolver vs filesystem drift, after renames, or weekly on Fridays. Detects ghost agents, dead links, orphan triggers, unregistered skills, and usage orphans (registered but never invoked by any agent/rotina)."
skill: check-resolvable
version: 1.2
author: Nexus Agent System
schedule: semanal (sexta-feira, pós-review)
tags: [audit, resolver, drift, maintenance, governance]
---

# Skill: Check Resolvable

## Propósito
Auditar se todos os agentes e skills existentes no filesystem estão registrados no resolver (AGENTS.md) e acessíveis por trigger. Detecta: agentes fantasmas (existem mas não são roteáveis), dead links (registrados mas não existem), triggers obsoletos.

---

## Condições de Ativação
Ative esta skill quando:
- Semanalmente (sexta-feira, após drift-review)
- Após instalação de novo agente ou skill
- Após remoção/reorganização de `04-SYSTEM/agents/`
- **Após qualquer rename de arquivo/diretório no vault** (quick-check mode — ver § Rename Guard)
- Usuário solicitar `@check-resolvable` ou "auditoria de resolver"

## Quando NÃO Usar
- Para verificar funcionalidade de agentes (use `@verify`)
- Para auditar segurança de agentes (use `@guard`)
- Após criar 1 agente já registrado em AGENTS.md — check-resolvable é para drift, não confirmação imediata
- Se AGENTS.md acabou de ser reescrito integralmente (diff será ruidoso)

---

## Modelo por Etapa

| Etapa | Modelo Claude | Justificativa |
|-------|--------------|---------------|
| Scan filesystem (bash) | — | Zero tokens |
| Parse AGENTS.md | `claude-haiku-4-5` | Extração mecânica |
| Diff filesystem vs resolver | `claude-haiku-4-5` | Comparação mecânica |
| Relatório + sugestões | `claude-haiku-4-5` | Estruturação |

---

## Protocolo de Execução

### PASSO 1 — Scan Filesystem *(bash, 0 tokens)*
```bash
# Agentes: todos os .md na raiz de cada sistema + core/ (flatten 2026-06; sem 00-SYSTEM-PROMPTS/)
find 04-SYSTEM/agents/ -name "*.md" \
  -not -path "*/docs/*" -not -path "*/skills/*" \
  -not -path "*/memory/*" -not -path "*/_index/*" \
  -not -path "*/adr/*" \
  -not -name "README.md" -not -name "progress.md" \
  -not -name "standards.md" -not -name "project-setup.md" -not -name "*-project-setup.md" \
  -not -name "_template.md" \
  | sort > /tmp/agents-fs.txt

# Skills: todos os .md em 04-SYSTEM/skills/
find 04-SYSTEM/skills/ -name "*.md" | sort > /tmp/skills-fs.txt
```

### PASSO 2 — Parse AGENTS.md *(Haiku)*
Extrair de AGENTS.md:
- Todos os slugs de agentes mencionados (coluna "Agente" das tabelas)
- Todos os slugs de skills mencionados (tabela "Skills Disponíveis")
- Todos os triggers mapeados (tabela "Regras de Roteamento")

### PASSO 3 — Diff *(Haiku)*

| Check | Condição de falha |
|-------|-------------------|
| **Agente fantasma** | Existe em filesystem, não consta em AGENTS.md |
| **Dead link** | Consta em AGENTS.md, não existe em filesystem |
| **Skill não registrada** | Existe em `04-SYSTEM/skills/`, não consta na tabela de skills |
| **Skill usage orphan** | Registrada em AGENTS.md mas 0 referências em agentes/rotinas/wiki (ninguém invoca) |
| **Trigger órfão** | Trigger em "Regras de Roteamento" aponta para agente inexistente |
| **Sistema sem roteamento** | Pasta de sistema em `agents/` sem nenhuma entrada em "Regras de Roteamento" |

### PASSO 4 — Relatório *(Haiku)*

```
=== CHECK-RESOLVABLE REPORT | <timestamp> ===

FILESYSTEM:
  Agentes encontrados: N
  Skills encontradas: M

RESOLVER (AGENTS.md):
  Agentes registrados: X
  Skills registradas: Y
  Rotas definidas: Z

FINDINGS:
  🔴 Agentes fantasma (existem, não roteáveis): [lista]
  🔴 Dead links (registrados, não existem): [lista]
  🟡 Skills não registradas: [lista]
  🟡 Triggers órfãos: [lista]
  ⚪ Sistemas sem roteamento: [lista]

AÇÃO SUGERIDA:
  [para cada finding: fix específico]
```

---

## Restrições
- NUNCA modificar AGENTS.md automaticamente — apenas reportar
- Agentes ficam na raiz de cada *-system/ + core/ (flatten 2026-06; não há mais subpasta 00-SYSTEM-PROMPTS/)
- Rodar depois de drift-review (drift-review audita docs vs código; check-resolvable audita resolver vs filesystem)

---

## Rename Guard (Quick-Check Mode)

**Quando rodar:** Ao final de qualquer sessão que envolveu rename de arquivos/diretórios no vault. Não esperar o pipeline-diario ou a auditoria semanal — drift de wikilinks é mais barato de fixar na hora que dias depois.

### Protocolo Quick-Check

1. **Identificar renames da sessão** — listar arquivos/dirs renomeados
2. **Buscar wikilinks quebrados** — para cada rename, buscar `[[old-path]]` em todo o vault
3. **Reportar** — lista de arquivos com wikilinks apontando para o path antigo
4. **Fix ou reportar** — se poucos (<10), patchear; se muitos, logar em `04-SYSTEM/wiki/errors.md` para batch fix

### Comando rápido

```bash
# Para cada arquivo renomeado de old-name para new-name:
grep -r "old-name" --include="*.md" . | grep "\[\["
```

### Critério de conclusão

- [ ] Zero wikilinks apontando para paths renomeados nesta sessão
- [ ] Ou: wikilinks quebrados logados em errors.md com contagem

---

## Completion

- [ ] Wikilinks path-style verificados (path existe no filesystem)
- [ ] Bare-name wikilinks resolvidos por filename lookup (single-match = inbound)
- [ ] Code blocks filtrados (não são refs reais)
- [ ] Dead-refs reais vs ambíguos distinguidos
- [ ] Zero wikilinks apontando para paths renomeados OU quebrados logados em errors.md

## Failure modes

- **Code block false positive**: ref-graph walk gera DEAD-REFs de code blocks → filtrar antes de reportar
- **Bare-name inflation**: scanner só conta path-style → bare names também são inbound válido
- **Skill v1 vs v2 não integrada**: skill com -v2 nunca integrada ao pipeline → flag como orphan de integração

---

## Pitfalls## Pitfalls

1. **Ref-graph walk false positives de code blocks:** A função `refs_of()` que extrai paths de backtick-delimited code blocks (ex: `02-AREAS/fiap/fase-1/CONTENT\.md`) gera DEAD-REFs que não existem — são placeholders/exemplos em documentação, não refs reais. Antes de reportar dead-refs de um ref-graph walk, filtrar code blocks ou verificar se o path contém caracteres de escape (`\.`), placeholders (`YYYY`, `NN`, `$file`, `...`), ou segments de exemplo (`path/to`). Achado 2026-06-22: 375 arquivos no fecho CLAUDE.md prof.2, ~40 DEAD-REFs reportados, 0 reais após filtragem.

2. **Bare-name wikilinks resolvem no Obsidian:** Um wikilink `[[ai-agents]]` sem path resolve no Obsidian por fuzzy match de filename — mas um scanner que só conta path-style links (`[[path/to/file]]`) como inbound vai superestimar orphans. Para orphan scanning acurado, resolver bare names por filename lookup (single-match = inbound; multi-match = ambiguous = skip).

3. **Skill usage orphan vs skill não registrada:** Uma skill pode estar registrada em AGENTS.md (passa no diff filesystem↔resolver) mas ainda assim ser órfã de uso — nenhum agente, rotina, ou wiki a referencia. Achado 2026-06-24: `adversarial-gate-v2` registrada em 0 locais canônicos, única menção em relatório gerado. **Fix:** após o diff PASSO 3, rodar um passo extra de usage audit — para cada skill, grep por referências (wikilink, backtick, skill:name, @trigger) em `agents/`, `07-QUEUE/rotinas/`, `wiki/`, `AGENTS.md`. Skills com 0 refs = usage orphans. Falsos positivos comuns: skills de nome genérico (`brief`, `trace`, `probe`, `council`) — palavra aparece como substantivo comum, não como referência à skill. Para essas, confirmar com pattern estrutural: `[[...skill-name]]`, `skill:name`, `skills/<path>/name`.

4. **Skill v1 vs v2 — versão não integrada:** Quando uma skill tem versões (v1, v2), a versão nova pode ser criada mas nunca integrada ao pipeline/rotina que a originou. Achado 2026-06-24: `adversarial-gate-v2` foi criada como evolução de v1 para batches de ingest >20, mas nunca foi referenciada na rotina `pipeline-semanal.md` nem no moc-skills. **Fix:** ao detectar skill com sufixo `-v2` (ou `-vN`), verificar se a versão anterior está ativa em rotinas/agentes. Se sim, confirmar que a nova versão também está integrada — ou flag como orphan de integração. **Resolved 2026-06-24:** `adversarial-gate-v2` integrada em `pipeline-semanal.md` v5.2 (F2.10 Batch Quality Gate), `AGENTS.md` v1.5, e `moc-skills.md`. v1 mantida para gate in-flight; v2 roda como gate pós-batch.
