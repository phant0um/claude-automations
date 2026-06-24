---
title: Agent Evaluation in Production
type: concept
status: developing
created: 2026-04-19
updated: 2026-05-19
tags: [agent-evaluation, benchmarks, production-ai, llm-as-a-judge, metrics]
---

# Agent Evaluation in Production

Avaliação de agentes em produção difere fundamentalmente de avaliação em benchmarks de pesquisa — não apenas em dificuldade, mas em tipo.

## O Gap Pesquisa vs Produção

Benchmarks de pesquisa selecionam habilidades: instruction following preciso, raciocínio determinístico, outputs curtos.

Produção demanda: tolerância para ambiguidade, julgamento específico de domínio, deliverables de longo horizonte, format compliance sob padrões do stakeholder.

> O melhor agente em produção (Claude Code + Opus 4.6) alcança apenas 64.41/100 em tarefas reais — gap substancial mesmo para sistemas de ponta. — AlphaEval (2026)

## Framework de Construção de Benchmark (AlphaEval)

Processo de 4 etapas para construir avaliações executáveis a partir de requisitos reais:

1. **Partner Engagement** — empresas com clientes pagantes e workflows profissionais reais
2. **Requirement Elicitation** — ~1 mês; workflow discovery → scope negotiation → ground truth co-construction
3. **Task Formalization** — pacote padronizado: `query.md` + `task.yaml` + `files/` + `.eval/rubric.py`
4. **Iterative Validation** — 3–4 ciclos; critérios evoluem com capacidades dos agentes

## 5 Paradigmas de Avaliação

| Paradigma | Quando usar | Exemplo |
|---|---|---|
| Reference Answer Verification | Ground truth existe | Shortlist de candidatos vs decisão real de RH |
| Formal Logic Verification | Constraints verificáveis programaticamente | Otimização de BOM com constraints de procurement |
| Rubric-based Evaluation | Qualidade holística | Relatório de pesquisa financeira |
| Execution-based Verification | Output executável | UI testing de app mobile gerado pelo agente |
| LLM-as-a-Judge | Cross-cutting semântico | Avaliação de profundidade analítica |

Boa prática: ≥2 paradigmas por tarefa (avg. 2.8 no AlphaEval).

## Scaffold vs Model — Descoberta Crítica

**O scaffold importa tanto quanto o modelo.** Mesmo modelo, resultado diferente:
- Claude Opus 4.6: 64.41 (Claude Code) vs 61.85 (Cursor) vs 53.45 (Codex) — spread de 11 pontos
- GPT-5.2: 54.91 (GitHub Copilot) vs 39.47 (Claude Code) — spread de 15 pontos

**Implicação:** Avaliar modelos isolados é insuficiente. É preciso avaliar o sistema completo (modelo + scaffold).

## Score vs Valor Econômico

Rankings de score ≠ rankings de valor econômico. Configuração com score maior pode entregar menos valor se o score vier de domínios de baixo valor econômico.

**Decisão correta:** selecionar agentes pelo portfolio de domínios da organização, não pelo score agregado.

## 6 Failure Modes de Produção

Invisíveis a benchmarks centrados em código:

1. **Cascade dependency failure** — erro no anchor propaga por toda a cadeia de raciocínio
2. **Subjective judgment collapse** — agentes falham em soft-skill inference; score 2–3× menor que tarefas quantificáveis
3. **Information retrieval failures** — hallucination (~30%), imprecise retrieval (~35%), positive-information bias (~10%); agentes sistematicamente perdem eventos negativos
4. **Cross-section logical inconsistency** — falta de mecanismo de coerência global em outputs longos
5. **Constraint misinterpretation** — violam constraints implícitos; "synergy blindness"; fabricam solução quando não há solução viável
6. **Format compliance failures** — output correto mas incompatível com consumo downstream

## Desafios de Construção

- **Productive ambiguity**: desambiguar totalmente destrói o que torna tarefas de produção difíceis
- **Criteria drift**: padrões de qualidade sobem à medida que capacidades dos agentes melhoram
- **Environment fidelity**: ambientes de produção ricos difíceis de reproduzir em sandbox
- **Quantifying subjective judgment**: decomposição em dimensões verificáveis inevitavelmente perde informação

## Valor Econômico como Métrica

Alternativa concreta a scores abstratos: anotar tarefas com custo de substituição humana.

AlphaEval: 94 tarefas = 2.420 horas profissionais = $154K–$231K.
- Melhor configuração: $110K–$165K em valor entregue
- Gap entre configurações: $40K–$60K — base para decisão econômica de seleção de agentes

## Estratégia Multi-Agente

Em vez de uma configuração universal, rotear tipos de tarefa para diferentes configurações:
- Claude Code + Opus para finance e research
- Copilot + Opus para procurement
- Decisão baseada em portfolio de domínios, não score agregado

## Evals como Primitiva de Plataforma

[[03-RESOURCES/concepts/agent-systems/agent-platform-architecture]] (Agno / Ashpreet Bedi, 2026) trata evals como componente nativo: `Case` objects com `input`, `criteria`, `expected_tool_calls`, resultados em Postgres, visualizados em `os.agno.com` ao lado de sessions e traces. Cron schedule semanal detecta drift antes que usuários percebam. Ver [[03-RESOURCES/sources/guides-courses-howtos/how-to-build-an-agent-platform]].

## Long-Horizon Eval Patterns (Wolfe, 2026)

Agentes de longo horizonte requerem eval diferente de avaliações de prompt único:

- **Trajectory eval**: avaliar sequência de ações, não apenas output final
- **Intermediate checkpoints**: verificar estado intermediário em tasks multi-step
- **Autonomy spectrum**: tarefas variam em grau de supervisão requerida — eval deve mapear isso
- **Complexity × autonomy matrix**: alta autonomia + alta complexidade = failure mode mais provável

Desafio específico: agentes que "parecem certos" no output mas tomaram caminho errado (falsa positiva de resultado).

## World Model Learning em Agents (ECHO, 2026)

**ECHO** (DimitrisPapail + VaishShrivas): CLI agents treinados com RL que aprendem world model do terminal como side-effect do treinamento.

Técnica: durante RL, não mascarar tokens de output do terminal — o agente aprende a prever respostas do ambiente junto com aprender as ações corretas.

Resultado: todos os evals melhoram. Agents com world model interno agem melhor porque predizem consequências antes de executar.

**Implicação para eval**: um agente que modela o ambiente tem performance mais estável que um que age por padrão de token. Métricas de eval devem capturar consistency cross-rollout, não apenas success rate.

## Evidências
- **[2026-06-22]** Tese executiva (Satya Nadella + Handshake AI): evals privados ligados a outcome de negócio são a IP estratégica central de qualquer programa de IA — 5 pilares (simulação com edge cases, estratégia por função, segurança não resolvida pela era SaaS, routing só funciona com eval que valide modelo barato, fine-tuning padroniza não ensina conhecimento) — [[03-RESOURCES/sources/evals-the-strategic-ip-that-will-define-the-next-era-of-ai]]

## Relacionados

- [[03-RESOURCES/entities/AlphaEval]] — benchmark de referência
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]] — paradigma de avaliação semântica
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — arquitetura dos sistemas avaliados
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — RL para agents (inclui world model learning)
- [[03-RESOURCES/sources/ai-agents-harness/evaluating-agents-in-production-alphaeval]] — paper completo
- [[03-RESOURCES/sources/agent-evaluation-wolfe]] — guia detalhado (Cameron Wolfe PhD)
- [[03-RESOURCES/sources/ai-agents-harness/echo-terminal-agents-world-models]] — ECHO paper (world model)
- **[2026-06-24]** Eve define evals como uma única função async test(t) que dirige o agente e asserta inline — mesma shape para... — [[cases]]
- **[2026-06-24]** t.judge.autoevals são assertions model-backed com judge model separado do agente sob teste — 4 graders (factuality,... — [[judge-eve-llm-judge]]
- **[2026-06-24]** Eve evals = scored checks que rodam agente contra sessions reais via HTTP surface, capturando regressões em prompt/tool... — [[overview-eve-evals]]
- **[2026-06-24]** Agent loops (/loop, /goal) sem external validator geram 'Beautiful Nonsense' — output que passa toda validação interna... — [[the-missing-piece-in-every-agent-loop]]
- **[2026-06-24]** Deep Research fracassa porque gera, não verifica. Próxima etapa = Discoverative Intelligence: agent team com roles... — [[from-generate-to-verify-ai]]
