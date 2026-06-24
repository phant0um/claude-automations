---
title: "How Responsible AI Changes In The Agent Era"
type: source
source: "https://x.com/TheTuringPost/status/2069207700169183488"
created: 2026-06-22
updated: 2026-06-22
tags: [ai-agents, responsible-ai, microsoft, google-deepmind, governance, agent-safety]
---

## Tese Central

Responsible AI está se tornando infrastructure para AI agents: runtime controls, system accountability, human oversight, e safeguards para tools que actuam. Sai de principles e output review para agent controls, runtime monitoring, e system-level accountability. Não é mais policy department fora da engineering room — tem que estar dentro do system design. Agents que actuam mudam a forma: output pode ser action, e cada step pode parecer razoável isolado enquanto a sequence drift do goal.

## Pontos-Chave

1. **Shift fundamental**: Chat AI tinha built-in pause (human decide o que fazer com output). Agents que actuam — output pode ser action. Agents criam workflows, não apenas outputs. Cada step razoável isolado, sequence drift.
2. **Sarah Bird (Microsoft)**: Capability jumps mensais abrem applications mas exigem Responsible AI tools para new surfaces of risk. Agentic coding rewrite o SDLC que Responsible AI practice foi built around. Human review de 3 dias parece absurdo quando work levou 2 horas.
3. **Google DeepMind AI Control Roadmap**: "Build as if the agent may go wrong." Beyond traditional model alignment — system-level security, assurance mesmo quando alignment é imperfect.
4. **Moving from principles to technical**: Goal não é apenas state responsible behavior — fazer behavior testable, enforceable, observable, adjustable. Principles definem goal, regulations definem obligations, reviews checkam readiness — mas nenhum pode interrupt bad tool call.
5. **Reading the machine**: Forms são weak interface entre governance e realidade. Code knows more. Traces know more. Tool calls know more. Runtime behavior knows more. Se Responsible AI precisa operar em machine speed, tem que ler a máquina.
6. **Co-innovation**: Model training, post-training, low-latency systems, large-scale engineering, applied science, linguistics, legal, policy. Não se resolve só com tecnologia ou só com policy.

## Conceitos

- **Responsible AI as infrastructure**: runtime controls, system accountability, safeguards dentro do system design
- **Agent workflow drift**: cada step razoável isolado, sequence drift do goal
- **Reading the machine**: governance via code/traces/tool calls em vez de questionários
- **Testable, enforceable, observable, adjustable**: behavior Responsible AI precisa ser

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
- [[03-RESOURCES/sources/ai-agents/securing-internal-systems-against-increasingly-capable-and-imperfectly-aligned-ai]]