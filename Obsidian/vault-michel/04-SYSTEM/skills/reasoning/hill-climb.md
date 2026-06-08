---
skill: hill-climb
version: 1.0
author: Nexus Agent System
tags: [eval, improve, regression, harness]
---

# Skill: Hill Climb

## Propósito
Executar o ciclo completo de avaliação → diagnóstico → correção de um agente existente, iterando até que todos os casos passem ou o limite de rounds seja atingido.

---

## Condições de Ativação
Ative esta skill quando:
- O usuário solicitar `@hill [nome-do-agente]` ou `run hill-climb.md on [agente]`
- Um agente registrar taxa de falha >20% em evals consecutivos
- Pós-deploy de nova feature (regressão preemptiva)

NÃO ative para: agentes sem eval suite definida; queries simples sem histórico de falhas.

---

## Modelo por Etapa

| Etapa | Modelo Claude | Justificativa |
|-------|--------------|---------------|
| Leitura de INSTRUCTIONS + derivação de probes | `claude-haiku-4-5` | Leitura estruturada, baixo custo |
| Execução de probes via cURL/API | `claude-haiku-4-5` | Chamadas repetitivas, sem raciocínio profundo |
| Julgamento PASS/FAIL de cada probe | `claude-sonnet-4-6` | Precisão na avaliação semântica |
| Diagnóstico de falha + seleção de lever | `claude-sonnet-4-6` | Análise causal moderada |
| Edição cirúrgica do agente (.py / INSTRUCTIONS) | `claude-sonnet-4-6` | Requer coerência de código |
| Re-run suite completo final (anti-regressão) | `claude-haiku-4-5` | Verificação mecânica |

---

## Protocolo de Execução

### Round de Avaliação (máx. 5 rounds, para mais cedo se tudo passar)

**PASSO 1 — Derivar Probes** *(Haiku)*
- Verificar se existe `06-GENERATED/probe/<slug>-probe-*.md` (output de `/probe`):
  - SIM → carregar suite existente como base, complementar se necessário
  - NÃO → derivar probes a partir de `agents/<slug>.md` (identidade + restrições + fora do escopo)
- Target: 8–12 probes cobrindo: golden-path, edge cases, tool-selection, adversariais (prompt injection, input malformado, desvio de propósito)
- Salve em `evals/cases_<slug>.py` no formato `{input, rubric, expected_tool}` (AgentAsJudgeEval + ReliabilityEval)
- Referência: [[04-SYSTEM/skills/reasoning/probe]] para geração de suite adversarial completa

**PASSO 2 — Executar Probes** *(Haiku)*
- Para cada probe, dispare via `cURL` contra o container local
- Leia a resposta + tool calls dos logs do container
- Registre: `probe_id | status(PASS/FAIL) | resposta | tool_calls_reais | tool_calls_esperados`

**PASSO 3 — Julgar Falhas** *(Sonnet)*
- Se `/score-drift` foi rodado antes: usar o relatório como pré-classificação das dimensões com drift
- Se falha é ambígua (não encaixa claramente em nenhum tipo): rodar `/trace <slug> <comportamento>` antes de diagnosticar
- Para cada FAIL: classifique o tipo de falha segundo a taxonomia:
  - `MISSING_RULE` → regra ausente nas INSTRUCTIONS
  - `WRONG_TOOL` → ferramenta errada disparada
  - `HALLUCINATION` → resposta factualmente incorreta
  - `OVERSPEC_RUBRIC` → rubric de avaliação muito restrita
  - `CONTEXT_LOSS` → agente perdeu contexto de turns anteriores
  - `ADVERSARIAL_BYPASS` → falhou em input hostil

**PASSO 4 — Corrigir** *(Sonnet)*
- Selecione um lever por falha:
  - `MISSING_RULE` → adicione/refine regra nas INSTRUCTIONS
  - `WRONG_TOOL` → ajuste seleção de ferramenta no prompt
  - `HALLUCINATION` → adicione restrição explícita + exemplo
  - `OVERSPEC_RUBRIC` → relaxe o critério no eval case
  - `CONTEXT_LOSS` → aumente `num_history_runs`
  - `ADVERSARIAL_BYPASS` → adicione anti-rationalization clause
- Edite `agents/<slug>.py`, hot-reload o container (`docker restart <slug>`)
- Re-execute **apenas os probes que falharam** *(Haiku)*

**PASSO 5 — Anti-regressão** *(Haiku)*
- Se todos os probes do round passaram, execute a suite completa
- Se algum probe previamente verde quebrou: reverta a última edição e registre como `REGRESSION_RISK`

---

## Artefatos de Saída
- `evals/cases_<slug>.py` — suite atualizada
- `evals/results_<slug>_<timestamp>.json` — histórico de runs
- `agents/<slug>.py` — agente endurecido
- `AGENTS.md` — seção do agente atualizada com data do último hill-climb

---

## Restrições
- NUNCA edite o agente sem antes registrar o estado anterior (git commit ou backup)
- NUNCA marque um probe como PASS se a resposta contiver alucinação factual, mesmo que a rubric esteja satisfeita
- NUNCA remova um probe existente para fazer o rate subir — apenas melhore o agente
- Máximo de 5 rounds. Ao atingir o limite, gere relatório de falhas pendentes e aguarde intervenção humana
