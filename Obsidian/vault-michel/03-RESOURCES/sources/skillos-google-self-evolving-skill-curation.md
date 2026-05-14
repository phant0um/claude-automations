---
title: "SkillOS — Google's Framework for Self-Evolving Agent Skill Curation"
type: source
source_file: Clippings/Skill Curation for Self-Evolving Agents, explained clearly.md
origin: artigo (explicação de paper arXiv:2605.06614)
author: "@neural_avb (AVB)"
published: 2026-05-11
ingested: 2026-05-14
tags: [skillos, google, self-evolving-agents, skill-curation, rl-training, agent-memory, skillrepo]
---

# SkillOS — Google's Framework for Self-Evolving Agent Skill Curation

> [!key-insight] Core insight
> SkillOS trata o gerenciamento de skills como um sistema operacional: um LLM "Curator" treinado via RL observa as trajetórias do agente executor e decide automaticamente quais skills inserir, atualizar ou deletar — sem supervisão humana.

## Sections

### Arquitetura: 3 Componentes

1. **Agent Executor (Frozen)**: LLM ator que recupera skills do SkillRepo via BM25 e executa tarefas. Não é treinado — melhora puramente por ter skills melhores.
2. **Skill Curator (Trainable)**: LLM separado que observa trajetórias do executor e decide como atualizar o SkillRepo. Treinado via GRPO. Opera com três tool calls: `new_skill_insert`, `skill_update`, `skill_delete`.
3. **SkillRepo**: repositório de skills em Markdown com YAML frontmatter. Cada skill: nome, descrição (crítica para BM25), workflow, quando NÃO usar.

### Formato de Skill

```markdown
---
name: <Human-readable skill name>
description: <One-sentence what/when/why/how summary — usado no BM25 retrieval>
---
[Workflow step-by-step]
[When NOT to use]
[Worked examples]
```

### Pipeline de Treinamento (4 Fases)

1. **Executor roda**: recupera top-5 skills via BM25, executa tarefa, gera trajetória + sinal de correção (LLM-as-Judge: Qwen3-32B)
2. **Curator recebe**: task description + past skills + agent trajectory + result
3. **Curator age**: emite tool calls para Insert/Update/Delete no SkillRepo
4. **Reward composite**: 
   - Task Outcome Reward (skills curadas ajudaram tarefas futuras?)
   - Function Call Reward (% de tool calls válidas e executadas)
   - Compression Reward (penaliza copiar trajetória verbatim)
   - Content Quality Reward (Qwen3-32B julga semanticamente)

### Insight Central: Grouped Training

Skills de tarefas anteriores são diretamente testáveis em tarefas posteriores do mesmo grupo — isso cria o sinal de treinamento atrasado necessário para RL.

**A maior queda de performance**: remover task grouping (61.2 → 57.3) — confirma que aprender de sequências de tarefas relacionadas é o core insight.

### Resultados

- SkillOS supera baselines memory-free e memory-based em ALFWorld, WebShop, AIME (math)
- **Generalization**: Curator treinado com Qwen3-8B funciona com Qwen3-8B, Qwen3-32B e Gemini-2.5-Pro em test time
- **Insight contra-intuitivo**: Gemini-2.5-Pro como curator direto (SkillOS-gemini) underperforma vs Curator treinado via RL — reasoning forte ≠ boa curadoria; curadoria via RL é "grounded in executor capacity"

### Regras do Curator (Obrigatórias)

- **No Specifics**: remover números/nomes específicos; substituir com variáveis/conceitos
- **No Hallucination**: só incluir fatos suportados pela trajetória real
- **Atomic & Modular**: cada skill auto-contida e reutilizável em isolamento
- **Actionable**: orientação concreta, não vaga

### Diferença vs Anthropic Skills Architecture

Anthropic skills incluem resource files e código executável. SkillOS aprende apenas a porção text/prose — future work possível.

## Conexões

- [[03-RESOURCES/concepts/self-evolving-agents]] — SkillOS é implementação concreta do conceito; adicionar SkillOS como case
- [[03-RESOURCES/concepts/claude-skills]] — formato SKILL.md; SkillOS é evolução automática disso
- [[03-RESOURCES/concepts/agent-memory-architecture]] — SkillRepo como memória semântica evoluída
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — Executor + Curator = multi-agent com papéis fixos
- [[03-RESOURCES/entities/Hermes-Agent]] — Auto-Curator do Hermes é implementação similar do mesmo padrão
