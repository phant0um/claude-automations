---
title: "MosaicLeaks: Can Your Research Agent Keep a Secret?"
type: source
source: "Clippings/MosaicLeaks Can your research agent keep a secret?.md"
author: "Alexander Gurung, Rafael Pardinas (ServiceNow)"
published: 2026-06-18
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, privacy, security, multi-hop, research-agents, servicenow]
score: A
---

## Tese Central

Deep research agents que combinam documentos privados locais com tools externos (web retrieval) criam risco de privacidade: queries externas podem leakar informação sensível. MosaicLeaks mostra que agentes frequentemente leakam informação privada, e training só para task performance piora o leak. A solução: treinar privacy com PA-DR (Privacy-Aware Deep Research).

## Pontos-Chave

1. **Mosaic effect**: queries individualmente benignas (cloud migration milestone, January security disclosure, vendor name) combinam para revelar private facts. Adversário vê só query log, reassembles fragments.
2. **3 níveis de leakage**: Intent (adversary infere research questions), Answer (query log responde private questions), Full-information (query log contem private facts verifiáveis sem perguntar).
3. **Benchmark**: 1,001 multi-hop research chains over local enterprise docs + controlled web corpus. 559 training, 98 validation, 344 held-out test chains. Interleaves local e web sub-questions.
4. **"Just tell it not to leak" não funciona**: prompt discouraging leakage ajuda slightly para alguns models mas inconsistent. Qwen3-4B: leakage 34% → 25.5%, mas strict success 48.7% → 44.5%. Behavioral change = fewer queries, não safer construction.
5. **Training for performance piora leak**: task-only RL sobe strict success 48.7% → 59.3%, mas leakage 34% → 51.7%. Modelo aprende a pack mais context em queries — melhor para retrieve, pior para privacy.
6. **PA-DR (Privacy-Aware Deep Research)**: combina 2 rewards. (1) Situational task reward: julga cada call contra calls no mesmo stage/hop. (2) Learned privacy reward: Qwen3-4B classifier estima 2 risks (direct leak + mosaic leak). Penaliza o maior.
7. **Resultado**: PA-DR sobe strict success 48.7% → 58.7% enquanto reduz answer/full-info leakage 34.0% → 9.9%. Mais baixo que base model's 34.0%. Não buscou menos — fez *more* queries mas dropping revealing details.
8. **Situational rewards**: 5-6x mais sample-efficient que outcome-only RL. Compara matching calls em vez de scorear rollout inteiro.

## Conceitos

- Mosaic effect: fragments benignos combinam para revelar privado
- Intent/Answer/Full-information leakage hierarchy
- Privacy-performance tension: queries mais informativas = melhor retrieve + pior privacy
- Situational rewards: credit assignment per-call ao invés de per-rollout
- PA-DR: task reward + learned privacy reward
- "You can't prompt privacy in. You have to train it in."

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[03-RESOURCES/concepts/agent-systems/agent-privacy]]
- [[03-RESOURCES/concepts/llm-ml-foundations/credit-assignment]]