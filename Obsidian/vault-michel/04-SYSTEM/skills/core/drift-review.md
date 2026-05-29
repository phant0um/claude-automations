---
skill: drift-review
version: 1.0
author: Nexus Agent System
tags: [review, drift, sync, docs, config, maintenance]
---

# Skill: Drift Review

## Propósito
Varrer o repositório em busca de inconsistências entre documentação, código e configuração — e corrigir mecanicamente o que for automático, sinalizando o que requer intervenção humana.

---

## Condições de Ativação
Ative esta skill quando:
- `@review` for chamado manualmente
- Antes de qualquer release ou deploy
- Após refatoração significativa (>500 linhas modificadas)
- Semanalmente (cron recomendado: toda sexta-feira)

NÃO ative durante: implementação ativa de feature (timing errado); emergências.

---

## Modelo por Etapa

| Etapa | Modelo Claude | Justificativa |
|-------|--------------|---------------|
| Varredura estrutural do repo | `claude-haiku-4-5` | Leitura mecânica de arquivos |
| Detecção de drift semântico | `claude-sonnet-4-6` | Comparação de significado, não apenas texto |
| Auto-fix de drift mecânico | `claude-haiku-4-5` | Edições simples e verificáveis |
| Relatório de drift não-automático | `claude-haiku-4-5` | Geração de lista estruturada |

---

## Protocolo de Execução

### PASSO 1 — Varredura Estrutural *(Haiku)*
Verifique mecanicamente:
- Todos os arquivos `agents/*.py` estão registrados em `app/main.py`?
- Todas as env vars lidas no código estão em `example.env` e `AGENTS.md`?
- Todos os paths referenciados em `.md` ainda existem no filesystem?
- Todos os scripts em `/scripts` fazem o que a docstring afirma?
- Todos os agents em `AGENTS.md` têm arquivo correspondente em `agents/`?

### PASSO 2 — Detecção de Drift Semântico *(Sonnet)*
Para cada agente, compare:
- INSTRUCTIONS do arquivo `.py` vs. descrição em `AGENTS.md` — divergem?
- Exemplo de uso na documentação vs. comportamento atual (baseado em evals recentes)?
- Skills referenciadas vs. skills existentes em `skills/`?

### PASSO 3 — Auto-Fix *(Haiku)*
Corrija automaticamente (sem perguntar):
- Arquivo renomeado mas não atualizado nas referências → atualiza referências
- Entrada faltando em `example.env` → adiciona com placeholder
- Agente faltando no diagrama de arquitetura → adiciona entrada
- Path quebrado em `.md` → marca como `[LINK QUEBRADO - <caminho-esperado>]`

### PASSO 4 — Relatório de Drift Não-Automático *(Haiku)*
Para cada item que requer decisão humana:
```markdown
## [DRIFT] <descrição curta>
**Arquivo**: <path>
**Problema**: <o que diverge>
**Impacto**: ALTO | MÉDIO | BAIXO
**Ação recomendada**: <próximo passo sugerido>
```

---

## Artefatos de Saída
- Correções inline nos arquivos afetados
- `DRIFT-REPORT-<timestamp>.md` — lista de itens pendentes de decisão humana

---

## Restrições
- NUNCA auto-fix em lógica de agente (INSTRUCTIONS) — apenas estrutura/config
- NUNCA delete arquivos durante o drift review — apenas sinaliza
- Se >20 items de drift forem encontrados: alerte antes de auto-fix (pode indicar problema maior)
