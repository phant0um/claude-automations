---
title: "Evaluating Agents in Production — AlphaEval"
type: source
created: 2026-04-19
tags: [agent-evaluation, benchmarks, production-ai, alphaeval, llm-as-a-judge]
triagem_score: 8
source_file: .raw/articles/Evaluating Agents in Production.md
---

# Evaluating Agents in Production — AlphaEval

## Visão Geral

Paper acadêmico apresentando **AlphaEval**, um benchmark de 94 tarefas provenientes de 7 empresas reais com clientes pagantes, cobrindo 6 domínios ocupacionais O*NET. O objetivo é inverter a lógica dos benchmarks tradicionais: em vez de selecionar artefatos e criar critérios de avaliação retroativamente, parte de requisitos reais de produção e constrói avaliações executáveis a partir deles.

## Framework de Construção (Requirement-to-Benchmark)

4 etapas:

1. **Partner Engagement** — seleção de empresas com workflows profissionais reais (não simulados); critérios: tarefas autênticas, agentes no core do negócio, diversidade de input, expertise de domínio
2. **Requirement Elicitation** — ~1 mês por empresa; 3 fases: workflow discovery → scope negotiation → ground truth co-construction
3. **Task Formalization** — pacote padronizado: `query.md` + `task.yaml` + `files/` + `.eval/rubric.py` + `ground_truth.json`
4. **Iterative Validation** — 3–4 ciclos de refinamento por empresa; critérios evoluem junto com as capacidades dos agentes

## Os 6 Domínios e Tarefas

| Domínio | Tarefas | Avaliação |
|---|---|---|
| Human Resources (13-1071) | 11 | F1 score vs decisões reais de recrutamento |
| Finance & Investment (13-2051) | 22 | LLM-as-a-Judge + validação estrutural |
| Procurement & Operations (13-1020) | 23 | Verificação de constraints + otimização |
| Software Engineering (15-1252) | 11 | End-to-end UI testing automatizado |
| Healthcare & Life Sciences (29-9099) | 16 | LLM-as-a-Judge + verificação numérica |
| Technology Research (15-1221) | 11 | LLM-as-a-Judge com rubrica ponderada |

## Resultados — 14 Configurações Testadas

Melhor resultado: **Claude Code + Opus 4.6 = 64.41/100**

Configurações testadas com 6 modelos (Claude Opus 4.6, GPT-5.2, Gemini 3 Pro, Kimi K2.5, GLM-5, MiniMax M2.5) e 4 scaffolds (Claude Code, Codex, GitHub Copilot, Cursor).

**Descobertas-chave:**
- Absolute scores baixos: o melhor alcança apenas 64.41 — gap substancial entre benchmark de pesquisa e produção
- **Scaffold importa tanto quanto o modelo**: mesmo Opus 4.6 varia de 53.45 (Codex) a 64.41 (Claude Code) — spread de 11 pontos
- GPT-5.2 varia de 39.47 (Claude Code) a 54.91 (GitHub Copilot) — spread de 15 pontos
- **Rankings de score ≠ rankings de valor econômico**: Codex+Opus (53.45) > Claude Code+Gemini (50.78) em score, mas entrega menos valor econômico
- HR é o domínio mais difícil: máximo de 38.91 (agentes não conseguem replicar julgamento humano de contratação)

## Valor Econômico Entregue

94 tarefas = 2.420 horas profissionais (~60 person-weeks) = $154K–$231K em custo humano equivalente.
- Melhor configuração entrega $110K–$165K de valor
- Pior configuração entrega $70K–$105K
- Gap de $40K–$60K entre configurações — base quantitativa para seleção de agentes

## 6 Failure Modes de Produção

1. **Cascade dependency failure** — erro no anchor de Day 1 propaga por todos os cálculos subsequentes (eCRF); erro de indústria propaga por toda análise financeira
2. **Subjective judgment collapse** — agentes extraem qualificações factuais mas falham em soft-skill inference; tarefas quantificáveis pontuam 2–3× mais que julgamento holístico
3. **Information retrieval failures** — 5 modos: hallucination (~30%), imprecise retrieval (~35%), rigid search (~15%), attribution confusion (~10%), positive-information bias (~10%); agentes sistematicamente perdem eventos negativos (falências, colapsos)
4. **Cross-section logical inconsistency** — TAM de $50B em uma seção, $80B duas páginas depois; ausência de mecanismo de coerência global em outputs longos
5. **Constraint misinterpretation** — otimizam objetivo explícito violando constraints implícitos; "synergy blindness" (otimização independente vs conjunta); fabricam soluções quando não há solução viável
6. **Format compliance failures** — output substantivamente correto mas incompatível com consumo downstream; o failure mode mais específico de produção

## Infraestrutura de Avaliação

3 abstrações: Task Runner (lifecycle) + Evaluator Registry (roteamento para paradigmas) + Execution Sandbox (Docker isolado).

Score padronizado: `s_task = Σ w_k · e_k ∈ [0,1]`

Confiabilidade estatística (Claude Code + Opus 4.6, 3 runs): overall ±1.83. Cohen's κ LLM-as-a-Judge vs humanos: 0.697–0.780 (substantial agreement).

## Paradigmas de Avaliação

- Reference Answer Verification
- Formal Logic Verification
- Rubric-based Evaluation (LLM-as-a-Judge: Claude Opus 4.6)
- Execution-based Verification (UI testing)
- Média: 2.8 paradigmas por tarefa

## Por que scaffold importa tanto quanto modelo

O resultado mais importante do AlphaEval para decisões práticas é o spread de scaffold: o mesmo Opus 4.6 vai de 53.45 (Codex) a 64.41 (Claude Code) — diferença de 11 pontos. GPT-5.2 tem spread ainda maior: 15 pontos entre scaffolds. Isso é maior do que a diferença entre modelos com o mesmo scaffold.

A implicação é que equipes que focam exclusivamente em qual modelo usar estão otimizando o segundo fator mais importante. O scaffold — o harness de orquestração, as ferramentas disponíveis, a estratégia de context management — determina mais o outcome do que a escolha entre modelos de ponta no mesmo tier.

Isso também explica por que os rankings de score não correspondem a rankings de valor econômico: um scaffold que usa o modelo mais eficientemente pode entregar mais valor com modelo ligeiramente inferior, especialmente quando custo por task é considerado.

## O domínio HR como limite atual dos agentes

O máximo de 38.91 no domínio HR é o dado mais revelador sobre as limitações atuais. As tarefas de HR no AlphaEval requerem soft-skill inference — avaliar candidatos não apenas por qualificações declaradas mas por inferências sobre fit cultural, potencial de crescimento, e adequação a dinâmicas de equipe específicas.

Agentes extraem qualificações factuais corretamente mas falham sistematicamente no julgamento holístico. Isso não é um problema de contexto ou ferramentas — é uma limitação de capability de inferência sob ambiguidade intencional. Decisões de contratação são ambíguas por design: diferentes gestores razoáveis chegam a conclusões diferentes, e o "ground truth" nos dados de referência reflete julgamento de um conjunto específico de humanos.

O resultado quantifica algo que era intuitivo: tarefas quantificáveis pontuam 2-3× mais do que tarefas que requerem julgamento holístico. Para o planejamento de automação com agentes, isso é um mapa de onde não investir (pelo menos por enquanto).

## Conceitos Relacionados

- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] — framework completo
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]] — paradigma de avaliação semântica
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — arquitetura dos sistemas avaliados
- [[03-RESOURCES/entities/AlphaEval]] — o benchmark em si
- [[03-RESOURCES/entities/Claude-Opus-47]] — modelo top neste período; Opus 4.6 é o predecessor
- [[03-RESOURCES/entities/Claude Code]] — melhor scaffold no benchmark
