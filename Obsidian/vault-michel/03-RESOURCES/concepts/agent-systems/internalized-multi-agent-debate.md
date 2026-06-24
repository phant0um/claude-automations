---
title: "Internalized Multi-Agent Debate (IMAD)"
type: concept
status: developing
created: 2026-05-05
updated: 2026-05-05
tags: [concept, ai-agents, multi-agent, post-training, internalized-reasoning, grpo, distillation]
---

# Internalized Multi-Agent Debate (IMAD)

**Definição:** Técnica de post-training que destila o processo de multi-agent debate em um único LLM via pipeline SFT + RL (GRPO), atingindo performance comparável ao debate explícito com até 93% menos tokens.

Proposta por Yi, Mueller e Lee (Boston University, 2026). [[03-RESOURCES/sources/ml-research-papers/clipping-latent-agents-post-training-multi-agent-debate]]

## Motivação

[[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] com debate explícito melhora raciocínio mas é caro: múltiplos modelos por múltiplos rounds geram transcripts longos antes de produzir a resposta. IMAD resolve: treina um único modelo para conduzir o debate **internamente**, na sua latent space.

## Pipeline de Dois Estágios

```
Dataset de debate (3 agentes, 2 rounds, GPT-3.5-turbo)
         ↓
Stage 1: SFT — Structure Learning
  → modelo aprende formato completo de debate a partir de traces integrais
  → tags estruturais são críticas: <|Agent 1|>, <|Round 1|>, <|Consensus|>
         ↓
Stage 2: GRPO — Internalization
  → reward = w_fmt * R^fmt + w_clip * R(y;l)
  → w_fmt decai → 0 (remove incentivo para verbalizar estrutura)
  → limite l anneals 2000 → 500 tokens (torna verbalização inviável)
  → única estratégia viável: raciocínio multi-perspectiva na latent space
```

## Resultados em Benchmarks

| Modelo | IMAD vs Debate | Tokens (% do Debate) |
|---|---|---|
| LLaMA-3.1 8B | +2.17pp GSM8K | 6–11% |
| Qwen 2.5 7B | comparável | 7–17% |
| Mistral Nemo 12B | +18.97pp GSM8K | 6–21% |

IMAD generaliza para domínios não treinados (MMLU-Pro, BBH) mesmo treinado só em aritmética — o debate internalizado transfere capabilities gerais de raciocínio, não task-specific.

## Agent Subspaces (Achado Mecanístico)

Após IMAD, o modelo desenvolve **direções linearmente separáveis** no espaço de ativação correspondentes a cada agente:

- Extraídas via [[03-RESOURCES/concepts/llm-ml-foundations/activation-steering]] (CAA / difference-in-means)
- Persistem após RL como subspaces identificáveis — colaboração não colapsa
- Steering efetivo com α ≥ 0.5 para distinguir personas

Implicação: IMAD não apenas memoriza outputs; constrói estrutura interna representando perspectivas múltiplas.

## Aplicação: Controle de Comportamento

Agent subspaces permitem supressão dirigida de traits indesejados via negative steering:

- **Evil trait**: supressão completa (score→0) com α=-3 a -5 no IMAD; base model mantém comportamento residual
- **Hallucination trait**: supressão parcial (trait mais distribuído) — ambos os modelos suprimem, mas IMAD preserva task performance (GSM8K estável)
- Base model colapsa em performance com steering extremo; IMAD mantém coerência

Implicação para AI safety: internalization cria behavioral subspaces mais separáveis, facilitando controle cirúrgico sem degradar capabilities gerais.

## Contraste com Abordagens Existentes

| Método | Treina em | Token efficiency |
|---|---|---|
| Explicit Debate | — (runtime) | baseline (5757–8887 tokens) |
| DebateGPT | Só resposta final | alta, mas underperforms |
| SFT only | Trace completo | médio |
| **IMAD (SFT+RL)** | Trace + RL dinâmico | 6–21% do debate |

## Limitações

- Testado em formato fixo (3 agentes, 2 rounds); configurações hierárquicas ou mais complexas inexploradas
- Qualidade depende de SFT bem-sucedido — LLaMA confiável, outros modelos ocasionalmente falham
- Benefícios mais pronunciados em modelos ≥7B

## Ver também

- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] — SFT + GRPO como técnicas base
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — contexto de sistemas multi-agente
- [[03-RESOURCES/concepts/llm-ml-foundations/activation-steering]] — mecanismo de controle de agent subspaces
- [[03-RESOURCES/concepts/llm-ml-foundations/test-time-scaling]] — abordagem alternativa para mais compute no inference
- [[03-RESOURCES/sources/ml-research-papers/clipping-latent-agents-post-training-multi-agent-debate]]
