---
skill: 12-factor-check
version: 1.0
trigger: "@12-factor [slug]" | "/12-factor-check [agente]"
model: claude-haiku-4-5
tags: [audit, reliability, production, agents, 12-factor, architecture]
source: "[[03-RESOURCES/sources/ai-agents-harness/12-factor-agents-humanlayer]]"
---

# Skill: 12-Factor Check

## Propósito

Auditar um agente contra os 12 princípios de confiabilidade de produção (12-Factor Agents). Diferente de `guard` (segurança OWASP) e `governance-audit` (layers de governança): 12-factor-check avalia se o agente é *arquiteturalmente confiável* — escalável, debugável, testável.

**Princípio base:** As melhores aplicações LLM em produção são majoritariamente código determinístico com LLM nos pontos certos — não loops "bag-of-tools".

---

## Condições de Ativação

Ative quando:
- Novo agente criado (gate pré-deploy)
- Agente vai para uso em produção / alta frequência
- `rotina-audit-mensal` detecta score-drift em agente crítico
- Revisão arquitetural de agente existente

NÃO ative para: skills (não são agentes); rotinas (são workflows, não agentes LLM); análise de segurança (→ guard).

---

## Modelo

Haiku — checklist estruturado, sem raciocínio profundo.

---

## Os 12 Fatores (adaptados para vault)

| # | Fator | O que verificar |
|---|-------|----------------|
| F1 | **Own your intent translation** | Agente converte linguagem natural em tool calls estruturados? Ou apenas "responde"? |
| F2 | **Own your prompts** | Prompts são literais no agent file (versionáveis)? Ou delegados a framework/template opaco? |
| F3 | **Own your context window** | Agente gerencia o que entra no contexto? Ou injeta tudo sem filtro? |
| F4 | **Tools are structured outputs** | Tools declaradas com schema claro? Execução é código determinístico, não LLM ad-hoc? |
| F5 | **Unify state** | Estado de execução = estado de negócio? Sem estados ocultos fora do agent file? |
| F6 | **Launch/Pause/Resume** | Agente pode ser pausado e retomado sem perda de contexto? |
| F7 | **Human in the loop** | Operações irreversíveis têm HITL gate explícito no agent file? |
| F8 | **Own your control flow** | Grafo de controle explícito no agent file? Ou LLM decide o fluxo livremente? |
| F9 | **Compact errors** | Erros são capturados e compactados no contexto? Sem loops infinitos de retry? |
| F10 | **Small, focused** | Agente faz UMA coisa? Ou tem >10 tools sobrepostas e múltiplos propósitos? |
| F11 | **Trigger from anywhere** | Pode ser ativado via CLI, hook, API e session? |
| F12 | **Stateless reducer** | `(state, event) → new_state + actions`? Estado vem do input, não de memória interna? |

---

## Protocolo

### 1. Ler Agent File *(Haiku)*

Ler `04-SYSTEM/agents/00-core/<slug>.md` completo.

### 2. Score por Fator

Para cada F1–F12:
```
Score: PASS | PARTIAL | FAIL | N/A
Evidência: [citação ou observação do agent file]
```

**N/A válido para:** F6 (run longa — vault-agents raramente pausam), F11 (agentes de vault não precisam de API externa).

### 3. Score Composto

```
Score = (PASS×1 + PARTIAL×0.5) / fatores_aplicáveis
```

| Faixa | Status |
|-------|--------|
| ≥0.85 | ✅ Production-ready |
| 0.70–0.84 | ⚠️ Needs improvement |
| <0.70 | 🔴 Not production-ready |

### 4. Output

```
12-FACTOR CHECK: <slug> v<versão>

F1  Own intent translation:  PASS/PARTIAL/FAIL
F2  Own prompts:             PASS/PARTIAL/FAIL
F3  Own context:             PASS/PARTIAL/FAIL
F4  Tools structured:        PASS/PARTIAL/FAIL
F5  Unified state:           PASS/PARTIAL/FAIL
F6  Launch/Pause/Resume:     PASS/PARTIAL/FAIL/N/A
F7  Human in the loop:       PASS/PARTIAL/FAIL
F8  Own control flow:        PASS/PARTIAL/FAIL
F9  Compact errors:          PASS/PARTIAL/FAIL
F10 Small & focused:         PASS/PARTIAL/FAIL
F11 Trigger from anywhere:   PASS/PARTIAL/FAIL/N/A
F12 Stateless reducer:       PASS/PARTIAL/FAIL

SCORE: X.XX — [✅ / ⚠️ / 🔴]

FALHAS CRÍTICAS (FAIL em F7, F8, F10):
  [lista com localização no agent file]

RECOMENDAÇÃO:
  Score ≥0.85: OK — próxima revisão em 30d
  Score 0.70–0.84: @extend para corrigir PARTIALs
  Score <0.70: @spec novo design antes de @extend
```

---

## Restrições

- F7 (HITL) FAIL = flag imediata — agente sem HITL em op irreversível é bloqueante
- F10 (focused) FAIL = flag — agente com >10 tools ou múltiplos propósitos precisa ser dividido
- NUNCA dar PASS em F7 se o agent file não tiver seção "Restrições" com confirmação explícita para ops destrutivas

---

## Relacionado

- [[04-SYSTEM/agents/00-core/guard]] — F7 (HITL) intersecta com LLM08 (Excessive Agency); guard complementa mas não substitui
- [[04-SYSTEM/skills/core/governance-audit]] — governa *mandato e escopo*; 12-factor-check governa *arquitetura de confiabilidade*
- [[04-SYSTEM/agents/00-core/hill]] — recebe failing factors como levers específicos para corrigir
- [[04-SYSTEM/skills/reasoning/score-drift]] — score-drift mede drift de comportamento; 12-factor-check mede qualidade arquitetural
