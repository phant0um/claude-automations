---
title: "SkillOS — Google's Framework for Self-Evolving Agent Skill Curation"
type: source
source_file: Clippings/Skill Curation for Self-Evolving Agents, explained clearly.md
origin: artigo (explicação de paper arXiv:2605.06614)
author: "@neural_avb (AVB)"
published: 2026-05-11
ingested: 2026-05-14
tags: [skillos, google, self-evolving-agents, skill-curation, rl-training, agent-memory, skillrepo]
triagem_score: 10
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

- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — SkillOS é implementação concreta do conceito; adicionar SkillOS como case
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — formato SKILL.md; SkillOS é evolução automática disso
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — SkillRepo como memória semântica evoluída
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — Executor + Curator = multi-agent com papéis fixos
- [[03-RESOURCES/entities/Hermes-Agent]] — Auto-Curator do Hermes é implementação similar do mesmo padrão

---

## Mecanismo de treinamento: por que GRPO funciona aqui

O Curator usa **GRPO (Group Relative Policy Optimization)** — uma variante de RL que avalia cada rollout relativo ao grupo de rollouts da mesma tarefa, sem precisar de um modelo de valor separado. Isso é importante para curadoria de skills porque:

- O sinal de reward é atrasado: skills inseridas em tarefas anteriores só demonstram valor em tarefas futuras
- GRPO lida bem com recompensas esparsas e atrasadas porque compara rollouts entre si, não contra um baseline absoluto
- Não precisa treinar um critic separado, o que reduz instabilidade no treinamento

O **grouped training** é o mecanismo que cria o sinal atrasado necessário: tarefas dentro do mesmo grupo são ordenadas temporalmente, então skills curadas na tarefa t₁ podem ser testadas na tarefa t₂, t₃, ... tₙ do mesmo grupo. Sem esse agrupamento, o Curator não teria como saber se uma skill que inseriu foi útil ou não.

---

## O Compression Reward: evitando skills verbosas

Uma das quatro componentes do reward composite é o **Compression Reward** — penaliza skills que são cópias verbatim das trajetórias que as geraram. Sem essa penalidade, o Curator tende a inserir skills que são essencialmente logs de execução: detalhados, específicos, e completamente inutilizáveis em outros contextos.

O que o Curator aprende via esse reward:
- Substituir valores concretos ("query a tabela `users_prod_2024`") por variáveis ("query a tabela alvo")
- Abstrair sequências específicas em padrões reutilizáveis
- Eliminar passos que foram específicos ao contexto da tarefa original

Isso mapeia diretamente para a regra **No Specifics** do Curator: remover números, nomes próprios e referências específicas, substituindo por variáveis ou conceitos. É tanto uma regra explícita quanto um objetivo de reward.

---

## Generalização cross-model: o resultado mais contra-intuitivo

O resultado que mais chama atenção no paper: um Curator treinado com Qwen3-8B funciona tão bem como Curator para Qwen3-32B e Gemini-2.5-Pro quanto para o próprio Qwen3-8B.

Isso significa que as habilidades de curadoria aprendidas via RL são **independentes de capacidade do modelo executor**. O Curator aprendeu a identificar que tipos de skills generalizam — e esse aprendizado vale para executores mais capazes que ele mesmo.

A implicação prática: você pode treinar um Curator pequeno e barato (8B) e deployar ele como Curator para qualquer executor, inclusive modelos frontier muito maiores. O Curator não precisa ser mais capaz que o executor para curar skills úteis para ele.

---

## Comparação com abordagens de memória existentes

| Abordagem | Quem decide | Critério | Persistência |
|---|---|---|---|
| CLAUDE.md / hot.md manual | Humano | Julgamento editorial | Até o humano editar |
| RAG com embeddings | Sistema (similarity) | Distância vetorial | Até re-indexação |
| Memória episódica (Cognee) | Sistema (clustering) | Frequência + grafo | Poda por relevância |
| SkillOS Curator | LLM treinado via RL | Utilidade futura | Insert/Update/Delete explícito |

A diferença fundamental do SkillOS: o critério de curadoria é **utilidade futura** medida empiricamente, não similaridade semântica, frequência de acesso, ou julgamento humano. O Curator aprende o que é útil pelo que realmente melhora performance do executor em tarefas reais.

---

## Aplicação no vault-michel

O vault já opera com uma estrutura de skills em `04-SYSTEM/skills/` que é curada manualmente. A arquitetura do SkillOS sugere uma evolução:

**Fase 1 (atual):** Skills curadas manualmente — humano revisa e decide o que vai para `04-SYSTEM/skills/`.

**Fase 2 (possível):** Curator leve que monitora quais skills são invocadas com sucesso vs quais levam a re-execução ou correção. Sem treinamento RL, mas com logging de uso.

**Fase 3 (SkillOS completo):** Curator treinado que observa trajetórias de sessão e propõe insertions/updates/deletions ao skill set do vault — revisadas pelo humano antes de aplicar.

O formato de skill do vault (YAML frontmatter + description + workflow) é compatível com o formato do SkillRepo descrito no paper. A migração para curadoria semi-automatizada não exigiria mudança de formato.
