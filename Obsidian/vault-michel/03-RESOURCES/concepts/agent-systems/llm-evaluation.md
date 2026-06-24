---
title: LLM Evaluation
type: concept
domain: agent-systems
created: 2026-05-28
updated: 2026-05-28
tags: [concept, evaluation, llm-judge, agent-eval, metrics]
---

# LLM Evaluation

Conjunto de metodologias para avaliar qualidade, confiabilidade e performance de LLMs e agentes em produção. Inclui: métricas quantitativas, LLM-as-a-Judge, benchmarks de agentes e avaliação estatística.

## Por que é difícil

Avaliação de LLMs não é como testar software convencional:
- **Saída não-determinística** — mesma entrada gera saídas diferentes
- **Critérios subjetivos** — "boa resposta" depende de contexto, persona, objetivo
- **Distribuição de teste ≠ produção** — benchmark pode não capturar falhas reais
- **Custo de label humana** — escalar avaliação humana é caro e lento

## Taxonomia de Métodos

### 1. Métricas automáticas (referência)

Requerem "ground truth" (resposta correta conhecida):

| Métrica | O que mede | Limitação |
|---------|-----------|-----------|
| **Exact Match** | Resposta idêntica à referência | Rígido demais para linguagem natural |
| **ROUGE** | Sobreposição de n-gramas | Não captura semântica |
| **BLEU** | Precisão de n-gramas (tradução) | Correlação fraca com qualidade humana |
| **BERTScore** | Similaridade semântica (embeddings) | Mais robusto; ainda imperfeito |
| **Pass@K** | % de vezes que código passa em testes | Gold standard para coding benchmarks |

### 2. LLM-as-a-Judge

Usar um LLM (geralmente mais capaz) para avaliar saídas de outro LLM.

**Padrões:**
- **Single-answer grading** — juiz avalia uma resposta em escala (1–10)
- **Pairwise comparison** — juiz escolhe entre A e B ("qual é melhor?")
- **Reference-guided** — juiz compara com resposta de referência

**Vantagens:** escala, custo baixo, flexível para critérios complexos.

**Vieses conhecidos:**
- **Position bias** — prefere a primeira opção em pairwise
- **Verbosity bias** — prefere respostas mais longas
- **Self-enhancement bias** — modelos favorecem saídas parecidas com as suas

**Mitigação:** múltiplos juízes, randomizar ordem, usar CoT no juiz.

### 3. Human Evaluation

Anotadores humanos avaliam segundo rubrica. Gold standard, mas caro e lento. Usado para:
- Calibrar benchmarks automáticos
- Validar LLM-as-a-Judge
- Avaliar dimensões subjetivas (tom, criatividade, alinhamento)

### 4. Agent Evaluation

Avaliação específica para agentes (não apenas respostas): ferramentas usadas, trajetória, custo, segurança.

**Métricas-chave:**
| Métrica | Definição |
|---------|-----------|
| **Task completion rate** | % de tasks completadas com sucesso |
| **Tool call accuracy** | % de chamadas de ferramenta corretas |
| **Trajectory efficiency** | Passos usados vs. mínimo necessário |
| **Token cost per task** | Custo médio em tokens por task completa |
| **Error recovery rate** | % de erros que o agente consegue recuperar |
| **Safety violations** | Ações fora da política (crítico para produção) |

### 5. Evaluating in Production (AlphaEval)

Abordagem: usar dados reais de produção para avaliação contínua.

- **Shadow mode** — novo modelo roda em paralelo sem servir usuários; compara saídas
- **A/B testing** — split de tráfego real; mede métricas de negócio
- **Preference logging** — usuário implicitamente sinaliza preferência (cliques, edições, refusals)
- **Online judges** — LLM-as-a-Judge avalia cada conversa em produção

## Avaliação Estatística

Testar se diferença entre modelos é **significativa** (não ruído):

- **Bootstrap resampling** — estima variância de métricas sem assumir distribuição
- **McNemar's test** — compara dois modelos no mesmo conjunto de testes
- **Effect size** — além de p-value; diferença de 2% pode ser estatisticamente sig. mas irrelevante
- **Confidence intervals** — sempre reportar CI, não só média

Regra: com N < 500 amostras, diferenças < 5% raramente são confiáveis.

## Benchmarks de Referência

| Benchmark | Foco | Notas |
|-----------|------|-------|
| **MMLU** | Conhecimento geral (57 domínios) | Saturado em modelos top |
| **HumanEval / MBPP** | Coding — pass@k | Standard para code LLMs |
| **MT-Bench** | Instrução multi-turn | Usa LLM-as-a-Judge |
| **LMSYS Chatbot Arena** | Pairwise humano em produção | Gold standard de preferência |
| **SWE-Bench** | Resolução de issues reais do GitHub | Difícil; testar capacidade de agente de código |
| **AgentBench** | Tarefas multi-step de agente | DB, OS, Web, etc. |

## Relacionado

- [[03-RESOURCES/concepts/agent-systems/harness-engineering|Harness Engineering]] — eval pipeline como parte do harness
- [[03-RESOURCES/concepts/agent-systems/floor-raising-vs-benchmark-maxing|Floor Raising vs Benchmark Maxing]] — implicações de eval para estratégia
- [[03-RESOURCES/entities/AgingBench|AgingBench]] — benchmark de degradação de agentes ao longo do tempo
- [[03-RESOURCES/sources/ai-agents-harness/clipping-29-llm-eval-concepts|Source — 29 LLM Eval Concepts]]
- [[03-RESOURCES/sources/ai-agents-harness/agent-evaluation-detailed-guide|Source — Agent Evaluation Detailed Guide]]
- [[03-RESOURCES/sources/ai-agents-harness/evaluating-agents-in-production-alphaeval|Source — Evaluating Agents in Production]]
- [[03-RESOURCES/sources/ml-research-papers/applying-statistics-to-llm-evaluations|Source — Applying Statistics to LLM Evaluations]]
- [[03-RESOURCES/sources/llm-evals-funnel-not-fork|Source — Better Experiments with LLM Evals (Spotify): evals como funil pré-experimento, não substituto; calibração offline-online]]
