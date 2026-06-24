---
title: LLM-as-a-Judge
type: concept
status: developing
created: 2026-04-19
updated: 2026-05-19
tags: [agent-evaluation, llm-evaluation, rubric, semantic-evaluation]
---

# LLM-as-a-Judge

Paradigma de avaliação onde um LLM avalia a qualidade do output de outro LLM (ou do mesmo modelo) usando rubricas estruturadas.

## Como Funciona

1. Define-se uma rubrica com pontos avaliáveis e pesos (w_k)
2. Um LLM juiz (ex: Claude Opus 4.6) avalia cada ponto de rubrica (e_k ∈ [0,1])
3. Score final: `s_task = Σ w_k · e_k`

## Aplicações em Produção

Usado no AlphaEval para domínios onde critérios não são facilmente formalizáveis:
- Finance & Investment: qualidade de relatórios de pesquisa
- Technology Research: profundidade analítica com evidências de fontes
- Healthcare: análise de políticas de reimbursement

## Confiabilidade

AlphaEval meta-evaluation (1.000 julgamentos, 2 anotadores humanos):

| Par | Concordância | Cohen's κ |
|---|---|---|
| Humano A vs Humano B | 84.7% | 0.691 |
| Humano A vs LLM-Judge | 85.0% | 0.697 |
| Humano B vs LLM-Judge | 89.7% | 0.780 |
| Three-way (Fleiss) | 79.7% | 0.720 |

Resultado: **substantial agreement range** — LLM-as-a-Judge é confiável como avaliador.

## Vieses Conhecidos

- **Self-preference**: LLM tende a favorecer outputs gerados por si mesmo (Panickssery et al., 2024)
- **Self-enhancement**: LLM tende a ser mais leniente — no AlphaEval, o juiz concordou mais com o anotador leniente (κ=0.780) que com o estrito (κ=0.697)

## Limitações

- Não substitui verificação formal para tarefas com constraints rígidos (procurement, eCRF numérico)
- Melhor usado como componente de avaliação multi-paradigma (≥2 paradigmas por tarefa)

## Framework Completo de LLM Eval (29 Conceitos)

LLM-as-a-Judge é 1 de 29 conceitos no framework completo de eval para engineers:

**Primitivos de eval**: Criteria → Quality Dimensions → Rubric → Test Cases → Golden Set → Pass/Fail Threshold → Eval Coverage

**Métodos de scoring**: Human Evaluation (gold standard) → Heuristic/Code → Semantic Similarity → Task Metrics (BLEU/ROUGE/Execution) → **LLM-as-Judge** → Pointwise vs Pairwise

**Problemas fundamentais**:
- *Non-determinism*: mesmo prompt → outputs diferentes. Uma passagem não é veredicto.
- *Fuzzy correctness*: não há "resposta única". Definir "bom" = decisão de produto.
- *Silent regression*: sem eval sistemática, mudança de prompt = aposta cega.

**Princípio operacional**: setar temperature=0 em eval runs. Reportar mean + variance, não só score. Golden set = artefato crítico; versionar e atualizar com falhas reais de produção.

→ [[03-RESOURCES/sources/ai-agents-harness/clipping-29-llm-eval-concepts]] — fonte completa (29 conceitos, Gavel/Zomato case study)

## Relacionados

- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] — contexto de uso em produção
- [[03-RESOURCES/entities/AlphaEval]] — benchmark que usa LLM-as-a-Judge em múltiplos domínios
- [[03-RESOURCES/concepts/learning-cognition/adaptive-thinking]] — Extended Thinking usado em contextos de avaliação complexos

## Evidências
- **[2026-06-19]** Padrão "council": painel de modelos responde em paralelo, um modelo-juiz frontier lê tudo e escreve a melhor versão combinada — supera o melhor modelo solo (69 vs 65,3/100 em benchmark OpenRouter); sem etapa de síntese é só um router, não um council — [[03-RESOURCES/sources/fable-intelligence-model-council]]
- **[2026-06-19]** Método STORM usa Claude como seu próprio peer reviewer (scores de confiança, bias check, missing perspective) na 4ª fase do pipeline de pesquisa — [[03-RESOURCES/sources/stanford-storm-method-claude-research]]
- **[2026-06-22]** Modelo A descobre vulnerabilidade, modelo B (diferente provedor) valida — força avaliação por pesos lógicos/dados de treino distintos, evitando que o modelo "grade sua própria homework". — [[03-RESOURCES/sources/build-your-own-vulnerability-harness]]
- **[2026-06-24]** Scaling adversarial evaluation of large language models requires two things at once: a way to genera — [[adversabench-automated-llm-red-teaming]]
- **[2026-06-24]** Loka transformed customer voice interactions by building a conversational AI agent with Amazon Nova  — [[how-loka-built-a-natural-low-latency-voice-agent-with-amazon-nova-2-sonic]]
- **[2026-06-24]** t.judge.autoevals são assertions model-backed com judge model separado do agente sob teste — 4 graders (factuality,... — [[judge-eve-llm-judge]]
- **[2026-06-24]** Eve evals = scored checks que rodam agente contra sessions reais via HTTP surface, capturando regressões em prompt/tool... — [[overview-eve-evals]]
