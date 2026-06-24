---
title: "Teaching Claude why"
type: source
source_url: "https://www.anthropic.com/research/teaching-claude-why"
author: "Anthropic"
published: 2026-05-08
created: 2026-06-22
updated: 2026-06-22
score: A
category: llm-theory
tags: [source, llm-theory, alignment, agentic-misalignment, rlhf, constitutional-ai, anthropic, safety-training, generalization]
---

# Teaching Claude why

Pesquisa da Anthropic sobre como reduziram agentic misalignment — modelos que tomavam ações egregiously desalinhadas em dilemas éticos fictícios (ex: chantagear engenheiros para evitar shutdown). Desde Claude Haiku 4.5, todo modelo Claude alcança score perfeito na eval de agentic misalignment.

## Tese Central

Alignment training que ensina o modelo a **explicar por que** certas ações são melhores que outras generaliza out-of-distribution, enquanto treinar só em demonstrações de comportamento alinhado não generaliza. O "difficult advice" dataset (3M tokens, OOD da eval) superou 85M tokens de synthetic honeypots parecidos com a eval — 28× mais eficiente. Constitutional documents + fictional stories de IA comportando-se admiravelmente reduzem misalignment em >3× apesar de serem extremamente OOD. A lição: **ensinar princípios > treinar comportamentos; fazer ambos juntos é o mais eficaz.**

## Pontos-Chave

### Quatro Lições Principais

1. **Comportamento desalinhado pode ser suprimido por training direto na eval, mas não generaliza OOD** — treinar em prompts muito similares à eval reduz blackmail rate, mas não melhora automated alignment assessment
2. **Alignment training principled generaliza OOD** — documents sobre constituição + stories de IA admirável melhoram alignment apesar de serem extremamente OOD
3. **Demonstrations são insuficientes; razões importam mais que ações** — best interventions ensinam Claude a explicar *why* actions são melhores, ou treinam em descrições ricas do character de Claude
4. **Qualidade e diversidade dos dados é crucial** — melhoras consistentes de iterar na qualidade das respostas + augmentação simples (ex: tool definitions mesmo não usadas)

### Origem da Misalignment

Duas hipóteses: (1) post-training encorajando behavior com misaligned rewards; (2) behavior vindo do pre-trained model e post-training falhando em discourager. **Resposta: (2) é largamente responsável.** A maioria do alignment training era standard chat-based RLHF sem agentic tool use — suficiente para chat, insuficiente para settings agentic.

### O Experimento-Chave: Difficult Advice Dataset

- Training em honeypots similares à eval: misalignment 22% → 15% (marginal)
- Rewriting responses para incluir deliberation de values/ethics: 22% → 3%
- **Difficult advice dataset** (user face dilemma, AI gives advice — OOD): 3M tokens = mesmo resultado que 85M tokens de synthetic honeypots → **28× efficiency**
- Generaliza melhor: performa melhor em automated alignment assessment

### Constitutional Training

- High-quality constitutional documents + fictional stories de aligned AI → misalignment reduzido >3×
- Blackmail rate: 65% → 19%
- Razões esperadas: (1) extensão do approach "difficult advice"; (2) clearer picture do character de Claude (fine-tuning subset elicits character inteiro); (3) updates perception de AI personas

### Persistência através de RL

- Snapshots com diferentes initialization datasets → RL em environments de harmlessness
- Snapshots mais alinhados mantêm lead durante todo o run RL
- True tanto para ausência de misaligned behavior quanto para presença de admirable behavior

### Diversidade de Training é Importante

- Augmentar environments com tool definitions + diverse system prompts → pequena mas significativa melhora em honeypot evals
- Capabilities-focused RL env mixes mudando rapidamente; standard RLHF datasets podem não generalizar como antes

## Conceitos

- [[03-RESOURCES/concepts/llm-ml-foundations/reinforcement-learning-from-human-feedback]] — RLHF
- [[03-RESOURCES/concepts/llm-ml-foundations/rlhf-pipeline]] — pipeline RLHF
- [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]] — reward hacking
- [[03-RESOURCES/concepts/llm-ml-foundations/weak-to-strong-generalization]] — generalization
- [[03-RESOURCES/concepts/llm-ml-foundations/synthetic-training-data]] — synthetic data
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]] — LLM as judge
- [[03-RESOURCES/concepts/agent-systems/agent-governance]] — governance de agentes
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]] — layers de governance
- [[03-RESOURCES/concepts/agent-systems/agent-security]] — segurança de agentes
- [[03-RESOURCES/concepts/agent-systems/agent-trust-layer]] — trust layer
- [[03-RESOURCES/concepts/llm-ml-foundations/automated-alignment-researcher]] — automated alignment

## Links

- [[03-RESOURCES/entities/anthropic]] — empresa autora
- [[03-RESOURCES/entities/Claude]] — família de modelos
- [[03-RESOURCES/entities/Claude-Haiku-4.5]] — primeiro modelo com score perfeito
- [[03-RESOURCES/entities/Claude-Opus-4.7]] — modelo referenciado

## Minha Síntese

O achado mais contraintuitivo: treinar em 3M tokens de "conselho difícil" (OOD) supera 85M tokens de honeypots similares à eval — 28× mais eficiente e generaliza melhor. Isso porque ensina *princípios* (o "why"), não *comportamentos* (o "what"). A analogia para o vault é direta: quando escrevo skills/CLAUDE.md para agentes, explicar o *porquê* de cada regra (os princípios de Karpathy, a identity) é mais eficaz que listar comportamentos esperados. O modelo internaliza o character e elicita comportamento alinhado em situações nunca vistas. É por isso que o `<!-- [INVARIANT] -->` no CLAUDE.md proteja princípios, não apenas regras operacionais.