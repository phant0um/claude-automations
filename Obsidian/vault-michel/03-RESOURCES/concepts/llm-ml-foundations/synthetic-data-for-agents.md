---
title: Synthetic Data for Agents
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [concept, synthetic-data, agent-training, agentic-rl, long-horizon, environment-generation, productivity]
---

# Synthetic Data for Agents

The practice of generating synthetic environments, tasks, and trajectories at scale to train agents, particularly for scenarios where real data is unavailable, private, or prohibitively expensive to collect. Quality of synthetic data depends critically on how well it simulates the context and environment complexity of real tasks — not just the tasks themselves.

## The Core Tension

Generic synthetic data (task description + expected output) fails for complex agents because:
- Real work is grounded in **accumulated context**: prior files, project history, collaborator decisions
- Without grounding context, agents learn task-solving in a vacuum and fail to transfer
- Realistic environments are heterogeneous, artifact-rich, and person-specific

**Key principle** (from Microsoft Synthetic Computers paper): synthetic data must synthesize the **context**, not only the task.

## Approaches in the Vault

### 1. Dual Data Flywheel (AgenticQwen)

[[03-RESOURCES/concepts/ai-strategy-org/dual-data-flywheel]] — generates increasingly hard agentic tasks via LLM-driven curriculum. Focused on tool-calling and API tasks. Scalable but still bounded by task diversity.

### 2. Behavior Tree Expansion

[[03-RESOURCES/concepts/agent-systems/behavior-tree-expansion]] — compositionally generates agentic tasks by expanding behavior trees. Good for structured workflows.

### 3. Synthetic Computers at Scale (Microsoft, 2026)

The most ambitious approach: generate entire synthetic user computers from personas, then run month-equivalent productivity simulations on them.

**Pipeline:**
1. Persona → detailed user profile (identity, occupation, collaborators, work habits)
2. User profile → filesystem policy + file inventory plan
3. Plan → populated synthetic computer (Word/Excel/PPT artifacts, realistic directory structure)
4. Computer → long-horizon simulation (setup agent creates objectives; work agent executes across computer)

**Scale demonstrated**: 1,000 computers, >8h runtime per simulation, >2,000 turns/run

**Key result**: occupation-specific skills extracted from 900 simulations improve agent performance on 100 held-out computers — mean rubric score 61.6% → 68.6%; wins on 83/100. Scaling shows clear trend: 10 computers → ~0 gain; 100 → 64% wins; 500 → 75%; 900 → 83%.

**Theoretical ceiling**: personas abundant at billion scale → methodology could produce millions/billions of synthetic user worlds with sufficient compute.

## Comparison: Code/Math vs Productivity Synthetic Data

| Dimension | Code/Math (DeepSeek-R1, etc.) | Productivity (Synthetic Computers) |
|-----------|-------------------------------|-------------------------------------|
| Environment | Static problem statement | Rich filesystem + collaborators |
| Verification | Executable / checkable answer | Rubric over multi-artifact deliverable |
| Horizon | Short–medium (single problem) | Long (month of work, 2,000+ turns) |
| Context dependency | Minimal | Critical (must navigate existing files) |
| Scalability | Very high (programs are cheap) | Moderate (8h+ per simulation) |

## Relation to Agentic RL

Synthetic data quality sets the ceiling on what [[03-RESOURCES/concepts/agent-systems/agentic-rl]] can learn. The "environment diversity" problem identified in agentic RL literature — that agents need diverse *environments*, not just diverse prompts — is directly addressed by persona-driven synthetic computer generation.

Connection to [[03-RESOURCES/concepts/llm-ml-foundations/horizon-length]]: long-horizon training requires stable learning signals across thousands of steps. Rich synthetic environments provide denser intermediate grounding vs sparse out-of-context tasks.

## Sources

- [[03-RESOURCES/sources/ml-research-papers/synthetic-computers-at-scale-microsoft]] — Microsoft Synthetic Computers paper
- [[03-RESOURCES/sources/ml-research-papers/clipping-agenticqwen-small-agentic-llm-dual-flywheels]] — AgenticQwen dual flywheel
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — RL framework consuming this data
- [[03-RESOURCES/entities/Microsoft-Research-Asia]] — Microsoft Research authoring lab
