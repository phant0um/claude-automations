---
title: SkillOS
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [google, self-evolving-agents, skill-curation, rl-training, skillrepo, agent-memory]
---

# SkillOS

Framework do Google (arXiv:2605.06614) que trata gerenciamento de skills de agentes como um sistema operacional: um LLM "Curator" treinado via RL observa trajetórias do executor e mantém automaticamente um repositório de skills (SkillRepo).

## Analogia SO

| SO | SkillOS |
|----|---------|
| Kernel | Skill Curator (treinado via GRPO) |
| Filesystem | SkillRepo (Markdown files) |
| Processos | Agent Executor (frozen) |
| I/O | BM25 retrieval + tool calls |

## Componentes

- **Agent Executor (Frozen)**: recupera top-5 skills via BM25 e executa; não é treinado
- **Skill Curator (Trainable)**: observa trajetórias e decide Insert/Update/Delete no SkillRepo; treinado via GRPO sem KL divergence penalty (encoraja exploração)
- **SkillRepo**: arquivos Markdown com YAML frontmatter; description field crítico para BM25

## Reward Composto (4 componentes)

1. Task Outcome — skills curadas ajudaram tarefas futuras no grupo?
2. Function Call — % de tool calls válidas e executadas
3. Compression — penaliza copiar trajetória verbatim (distilação real)
4. Content Quality — Qwen3-32B julga semanticamente

## Insight: Curadoria ≠ Reasoning

Gemini-2.5-Pro direto como curator underperforma vs Curator treinado via RL especialmente para executores fracos. Reasoning forte não garante boa curadoria — curadoria precisa ser grounded na capacidade real do executor.

## Relação com SKILL.md Anthropic

SkillOS aprende apenas a porção text/prose das skills. Anthropic skills incluem resource files e código executável. Formato compatível, escopos diferentes.

## Resultados

- Supera baselines memory-free e memory-based em ALFWorld, WebShop, AIME
- Full SkillOS: 61.2 vs sem task grouping: 57.3 (maior impacto)
- Generaliza para executores não vistos durante treino

## Sources

- [[03-RESOURCES/sources/claude-code-skills/skillos-google-self-evolving-skill-curation]] — explicação completa do paper

## Related

- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — categoria conceitual mais ampla
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — formato SKILL.md base
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — SkillRepo como camada semântica
- [[03-RESOURCES/entities/Hermes-Agent]] — Auto-Curator do Hermes implementa padrão similar via heurísticas (não RL)
