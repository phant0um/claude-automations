---
title: Agent Trust Layer
type: concept
status: developing
created: 2026-05-31
updated: 2026-05-31
tags: [ai-agents, quality, verification, trust, coding-agents]
---

# Agent Trust Layer

Camada de qualidade entre um coding agent e o pull request. Build verde não prova qualidade — o trust layer preenche o gap entre "código compilou" e "código faz o que devia fazer".

## O Problema

Coding agents (Claude Code, Cursor, Codex) baratearam a escrita de código mas não aumentaram a confiabilidade. O feedback loop humano se tornou o primeiro gate de qualidade — isso é backwards.

**Superfície de ataque de um agente = tudo que o modelo pode chamar** — não só o modelo em si. Principle of least privilege se aplica a ferramentas MCP tanto quanto a permissões de sistema.

## 4 Componentes

### 1. Feedback Sensors (in-loop)
Compiler, type check, lint, testes focados, mutation testing (`cargo-mutants`), fuzzing (`WuppieFuzz`). Agente recebe falhas **enquanto trabalha**, não após abrir PR.

### 2. Semantic Evals
Código compila ≠ código faz a coisa certa. Evals semânticos validam: tests gerados cobrem comportamento esperado, policy logic preserva regras de negócio, tool-use workflows seguem contrato. LLM-as-a-judge + golden samples.

### 3. Zonas de Refatoração
Trechos de código classificados por risco de mudança:
- 🟢 Verde: seguro mover/refatorar (código novo, sem dependentes críticos)
- 🟡 Amarelo: atenção (dependentes internos, cobertura parcial)
- 🔴 Vermelho: risco alto (contratos externos, sem testes, produção crítica)

### 4. Provenance Trails
Log de cada ação do agente: arquivo lido, ferramenta chamada, decisão tomada. Permite auditoria humana sem ter que entender todo o diff.

## Camada Externa (OpenRouter Guardrails pattern)

Proteção que opera **antes do modelo** — prompt injection defense, DLP (PII detection via Presidio), budget enforcement per-entity, workspace/member/key hierarchy. Sem alterar código.

**Diferença:** feedback sensors = dentro do loop de execução do agente; guardrails externos = antes de qualquer chamada ao modelo.

## Relação com Vault

| Componente vault | Equivalente trust layer |
|-----------------|------------------------|
| `guard` agent | Feedback sensor pós-write |
| `verify` agent | Semantic eval de output |
| `spec` agent | Define zona vermelha (contrato) |
| `errors.md` | Provenance trail de falhas |

## Para Agentes Assíncronos (Devin pattern)

Agentes assíncronos (triggered por evento, schedule, outro agente) precisam retornar **artefatos verificados** — não apenas "tarefa concluída":
- Test plan fundamentado no código real
- Setup script determinístico
- Evidence trail da verificação executada

## Fontes
- [[03-RESOURCES/sources/ai-agents-harness/coding-agents-need-trust-layer-bibryam]]
- [[03-RESOURCES/sources/ai-agents-harness/verifying-agentic-development-at-scale-devin]]
- [[03-RESOURCES/sources/ai-agents-harness/openrouter-guardrails-agent-governance]]

## Relacionado
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]]
- [[03-RESOURCES/concepts/agent-systems/spec-driven-development]]
