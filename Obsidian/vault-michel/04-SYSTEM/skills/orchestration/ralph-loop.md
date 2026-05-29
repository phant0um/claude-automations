---
skill: ralph-loop
version: 1.0
author: Nexus Agent System
tags: [long-running, multi-session, context-reset, planner, evaluator]
---

# Skill: Ralph Loop

## Propósito
Executar tarefas de desenvolvimento de longa duração (>30 min, múltiplas features) de forma autônoma, usando arquitetura Planner → Generator → Evaluator com context resets para evitar context anxiety e self-evaluation bias.

---

## Condições de Ativação
Ative esta skill quando:
- A tarefa envolver construção de aplicação completa a partir de 1–4 frases de prompt
- O build estimado for >30 min ou >5 features
- A tarefa envolver múltiplas sessions de coding (long-running)

NÃO ative para: features isoladas já especificadas (use `spec-lifecycle`); hotfixes; tarefas <15 min.

---

## Modelo por Etapa

| Agente | Modelo Claude | Justificativa |
|--------|--------------|---------------|
| Planner | `claude-haiku-4-5` | Expansão de prompt → spec, low-cost |
| Generator (build) | `claude-sonnet-4-6` | Geração de código padrão |
| Generator (escalada) | `claude-opus-4-7` | Apenas se 3+ sprints consecutivos falharem no QA |
| Evaluator (QA) | `claude-sonnet-4-6` | Avaliação com Playwright MCP, custo moderado |
| Context Handoff Writer | `claude-haiku-4-5` | Apenas se modelo não suportar compaction |

> **Default (Opus 4.6+, Sonnet 4.6+):** usar compaction automática. Sem context resets, sem handoff.md. Session contínua.
> **Fallback (modelos anteriores):** context resets + handoff.md conforme protocolo abaixo.

---

## Protocolo de Execução

### AGENTE 1 — Planner *(Haiku)*
**Input**: prompt de 1–4 frases do usuário
**Output**: `progress.md` com spec completa

Instruções:
- Seja **ambicioso no escopo** — a spec deve superar o que um agente solo produziria
- Foque em: deliverables e contexto de produto (NÃO detalhes técnicos de implementação)
- Inclua: features principais, user stories, critérios de aceitação
- Identifique oportunidades para integrar features de AI/agente no produto
- Carregue e aplique o `frontend-design-skill.md` se o produto tiver UI

### AGENTE 2 — Generator *(Sonnet; Opus se 3+ falhas)*
**Loop por sprint** (ou sessão contínua com compaction se modelo suportar):

**PRÉ-SPRINT — Sprint Contract**:
- Generator propõe: o que será construído + como será verificado
- Evaluator revisa a proposta (confirma alinhamento com spec)
- Iterate até acordo antes de escrever código

**BUILD**:
- Trabalhe feature por feature seguindo a spec
- Use git para versionamento a cada sprint
- Ao final de cada feature: self-evaluate antes de chamar o QA

**CONTEXT RESET** *(fallback — apenas modelos sem compaction nativa)*:
- Escreva `handoff.md`: estado atual, features completas, próximos passos, bugs conhecidos
- Reset do contexto + carregamento de `handoff.md` no início da nova sessão
- **Skip se usando Opus 4.6+ ou Sonnet 4.6+** — compaction automática substitui este passo

### AGENTE 3 — Evaluator/QA *(Sonnet)*
**Critérios de avaliação** (cada um com threshold mínimo):
1. **Funcionalidade** (threshold: 8/10) — features do sprint contract funcionam?
2. **Design/UX** (threshold: 7/10) — interface é utilizável e coerente?
3. **Qualidade de Código** (threshold: 7/10) — código limpo, sem dead code?
4. **Profundidade de Produto** (threshold: 7/10) — vai além do mínimo viável?

**Instruções críticas para o Evaluator**:
- Use Playwright MCP para INTERAGIR com o app — não avalie por screenshots estáticos
- Seja **cético por padrão** — Claude tende a aprovar trabalho medíocre
- Teste edge cases, não apenas happy paths
- Se identificar um bug: seja específico sobre localização (arquivo, linha, condição)
- PROIBIDO: identificar um problema e depois concluir "não é crítico" sem justificativa forte

Se qualquer critério abaixo do threshold → SPRINT FAIL → Generator recebe feedback e refaz.

---

## Artefatos de Saída
- `progress.md` — spec expandida pelo Planner
- `handoff.md` — estado de sessão para context reset
- `sprint-contracts/sprint_<N>.md` — contratos negociados
- `qa-reports/qa_<N>.md` — relatórios do Evaluator
- Codebase completo com git history

---

## Restrições
- NUNCA o Evaluator aprova um sprint onde "a feature central não funciona"
- NUNCA o Generator ignora o sprint contract — ele é lei para aquele sprint
- NUNCA use Opus para o Planner (desperdício — é trabalho de template)
- Se o build atingir 10+ rounds de QA sem convergir: pause, relate ao usuário, solicite spec simplificação
