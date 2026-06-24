---
title: Mixture of Experts (MoE)
type: concept
status: developing
created: 2026-05-01
updated: 2026-05-01
tags:
  - llm
  - architecture
  - sparsity
  - efficiency
---

## Definition

A **Mixture of Experts (MoE)** is an LLM architecture where a router selects a subset of expert modules for each token, rather than activating all parameters. Only the selected experts process the token, reducing FLOPs while increasing total parameters.

```
Token → Router → Select K experts (out of N) → Combine outputs
```

## Key Trade-offs

| Aspect | Dense Model | MoE Model |
|--------|---|---|
| Total Parameters | Low | High (1.5x-10x) |
| Active Parameters per Token | All | K/N fraction |
| FLOPs per Token | High | Low (up to 10x) |
| Memory Bandwidth | Moderate | High (all-to-all routing) |
| Latency | Fast | Variable (routing overhead) |

## LatentMoE (NVIDIA Innovation)

[[03-RESOURCES/sources/ml-research-papers/nemotron-3-super-hybrid-mamba-attention-moe|Nemotron 3 Super]] introduced **LatentMoE**, addressing key inefficiencies in standard MoE:

### Standard MoE Problems
1. **Memory bottleneck:** Each expert has size d×m; reading all experts costs d×K per token
2. **Communication overhead:** Routing volume = d×K in distributed settings
3. **Quality degradation:** Reducing d or K directly hurts model quality

### LatentMoE Solution
1. **Reduce hidden dimension d** while preserving effective nonlinear budget K·m
2. **Keep K·m constant** to maintain quality
3. **Scale total experts N and top-K together** to expand expert combination space exponentially
4. **Hardware-aware design:** Optimize for actual inference costs (memory bandwidth + distributed communication)

**Result:** Better accuracy-per-parameter AND accuracy-per-FLOP than standard MoE.

## Nemotron 3 Super Configuration

- Total experts per layer: **512**
- Top-K activated: **22** (4.3% sparsity)
- MoE latent dimension: 1024
- Active parameters: 12.7B / 120.6B total (10.5% active)

## Applications

1. **Cost-effective inference:** Serve 120B model with 12B active cost
2. **Long-context:** Higher throughput enables longer sequences
3. **Specialization:** Different experts can specialize in domains/tool-types

## Related Concepts

[[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]] · [[03-RESOURCES/concepts/llm-ml-foundations/speculative-decoding]] · [[03-RESOURCES/concepts/agent-systems/hybrid-architectures]]

---

**Sources:** [[03-RESOURCES/sources/ml-research-papers/nemotron-3-super-hybrid-mamba-attention-moe]]
