---
skill: check-resolvable
version: 1.0
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
# Agentes: todos os .md em 00-SYSTEM-PROMPTS/ ou raiz de sistema
find 04-SYSTEM/agents/ -name "*.md" \
  -not -path "*/docs/*" -not -path "*/skills/*" \
  -not -path "*/memory/*" -not -path "*/_index/*" \
  -not -path "*/00-mocs/*" -not -path "*/adr/*" \
  -not -name "README.md" -not -name "progress.md" \
  -not -name "standards.md" -not -name "project-setup.md" \
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
- NUNCA ignorar agentes em subpastas (00-SYSTEM-PROMPTS/ conta como agente)
- Rodar depois de drift-review (drift-review audita docs vs código; check-resolvable audita resolver vs filesystem)
