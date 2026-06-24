---
title: "Harness Updating Is Not Harness Benefit: Disentangling Evolution Capabilities in Self-Evolving LLM Agents"
type: source
source: "Clippings/Harness Updating Is Not Harness Benefit Disentangling Evolution Capabilities in Self-Evolving LLM Agents.md"
url: "https://arxiv.org/html/2605.30621v1"
authors: [Minhua Lin, Juncheng Wu, Zijun Wang, Zhan Shi, Yisi Sang, Bing He, Zewen Liu, Tianxin Wei, Zongyu Wu, Zhiwei Zhang, Dakuo Wang, Xiang Zhang, Benoit Dumoulin, Cihang Xie, Yuyin Zhou, Suhang Wang, Hanqing Lu]
affiliations: [Penn State, UC Santa Cruz, Amazon, Emory University, UIUC, Northeastern University]
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, self-evolution, harness, llm-agents, paper, research]
---

## Tese central

Harness updating (produzir atualizações úteis ao harness a partir de execução) e harness benefit (beneficiar-se de um harness atualizado durante task solving) são **duas capacidades distintas e desacopladas** da capacidade base do modelo. A capacidade base prediz essas duas capacidades de formas diferentes — e o budget de capacidade deve ir para o agente (task-solving), não para o evolver.

## Argumentos principais

### 1. Harness-updating é plana em relação à capacidade base

Quando se varia o evolver mantendo o agente fixo:
- O spread entre o melhor e o pior evolver é de **no máximo 3,1 pp** em qualquer benchmark.
- Nenhum modelo vence em todos os benchmarks — o ranking do evolver reshuffles por domínio.
- O modelo mais pequeno testado (Qwen3.5-9B) produz updates com ganhos comparáveis ao Claude Opus 4.6.
- **Consequência:** Não vale escalar o evolver. O post-evolution score é dominado pela capacidade do agente, não do evolver.

### 2. Harness-benefit é não-monotônica na capacidade base

Quando se varia o agente mantendo o evolver fixo:
- **Modelos mid-tier** (GPT-OSS-120B, Qwen3-235B) se beneficiam mais.
- **Modelos strong-tier** (Opus 4.6, Sonnet 4.6) se beneficiam menos — efeito teto (já resolvem muitas tasks sem harness).
- **Modelos weak-tier** (Qwen3-32B) se beneficiam menos — *mas não pelo mesmo motivo*. Têm headroom, mas não conseguem aproveitá-lo. Dois failure modes específicos explicam isso.

### 3. Dois failure modes em modelos weak-tier

**Harness Activation Failure** — o modelo não invoca o harness:
- Qwen3-32B: skill-load rate de apenas 25,1% vs ~96% em modelos strong-tier.
- Causa: o modelo identifica a skill certa mas a embute numa ação multi-key; o ambiente não reconhece como válida e a skill nunca entra no contexto.

**Harness Adherence Failure** — o modelo carrega o harness mas não o segue:
- Qwen3-32B: HFR (Harness-Following Rate) de 0,142 vs 0,757 para Opus 4.6.
- Qwen3-235B tem skill-load rate de 0,961 (quase igual a Opus) mas HFR de apenas 0,350 — demonstra que activation e adherence são ortogonais.
- Adherence decai ao longo da trajetória: Qwen3-32B vai de 0,52 → 0,13 (drift -0,39); Opus 4.6 mantém 0,89 → 0,80 (drift -0,09). Weak models perdem aderência 4× mais rápido.

## Key insights

| Achado | Implicação prática |
|--------|-------------------|
| Harness-updating é plana — 9B = Opus para este papel | Não gaste budget em evolver poderoso; gaste no agente |
| Post-evolution score dominado pelo agente, não pelo evolver | Escalar o evolver tem retorno muito limitado |
| Harness-benefit é não-monotônica | Mid-tier models são o sweet spot para ROI em self-evolution |
| Skill-load rate ~25% em weak models | Harness invocation deve ser aprendida explicitamente em training |
| Adherence decay 4× maior em weak models | Long-horizon instruction following é bottleneck crítico |
| Activation e adherence são ortogonais | Diagnóstico requer ambos: SLR + HFR + LPR separados |

## Exemplos e evidências

**Case study SkillsBench `flink-query`:** Opus 4.6 como agente. Sem evolver: score 0,67 (omite FINISH-event filter). Com Qwen3.5-9B como evolver: score 1,0. Com Opus 4.6 como evolver: score 1,0. As duas skills são proceduralmente isomórficas — mesmos 5 steps, diferindo apenas em detalhes de implementação.

**Extreme pairings:** Mesmo pareando o agente mais fraco com seu melhor evolver contra o agente mais forte com seu pior evolver, o agente forte vence por 18,6 a 35,2 pp em todos os benchmarks.

**Aderência por fase (SkillsBench):**

| Fase | Qwen3-32B (weak) | GPT-OSS (mid) | Opus 4.6 (strong) |
|------|-----------------|---------------|-------------------|
| Harness loaded | 0,52 | 0,67 | 0,89 |
| Mid turn | 0,22 | 0,48 | 0,79 |
| Final turn | 0,13 | 0,43 | 0,80 |
| Drift | -0,39 | -0,24 | -0,09 |

**Benchmarks utilizados:**
- SWE-bench Verified (500 tasks, 12 repos GitHub — software engineering)
- MCP-Atlas (500 tasks, 36 MCP servers, 220 tools — tool orchestration)
- SkillsBench (86 tasks, 11 domínios — skill-based execution)

**Modelos testados:** Claude Opus 4.6, Sonnet 4.6, Haiku 4.5; Qwen3-235B-A22B, Qwen3-32B, Qwen3.5-9B; GPT-OSS-120B.

## Implicações para o vault

1. **Budget de capacidade para o agente, não o evolver:** O vault usa Opus/Sonnet para orquestração — correto. Subagentes de ingest podem usar Haiku sem prejudicar a qualidade dos harness updates.

2. **Harness invocation como skill de primeira classe:** Agentes do vault que consomem skills (guard, hill, verify) devem ter exemplos explícitos de como invocar skills corretamente, não apenas tê-las disponíveis. Skill invocation não é óbvia para modelos mid-tier.

3. **Long-horizon adherence como critério de qualidade:** Pipeline tasks longas (ingest batch, audit) com modelos Haiku → monitorar se o agente perde aderência ao harness ao longo da execução. Adicionar checkpoints de re-injeção do harness.

4. **Self-evolution via `hill`:** O agente hill é o evolver do vault. Dado que harness-updating é plana, não é necessário usar Opus para o hill agent — Sonnet ou mesmo Haiku podem produzir updates de qualidade comparável. O modelo importa mais no agente que *usa* o harness.

5. **Diagnóstico tripartido:** Quando um agente não se beneficia de uma skill/harness atualizado, distinguir: (a) não invocou a skill, (b) invocou mas não seguiu, (c) seguiu mas a skill era ruim. O paper fornece o framework SLR+HFR+LPR para isso.

## Links

- [[03-RESOURCES/concepts/agent-systems/managed-agents-harness]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]]
- [[03-RESOURCES/concepts/agent-systems/halo-harness-self-optimization]]
