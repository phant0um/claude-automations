---
title: Hierarchical Orchestration
type: concept
status: developing
created: 2026-04-19
updated: 2026-04-19
tags: [multi-agent, orchestration, long-horizon, agent-as-tool, delegation]
---

# Hierarchical Orchestration

Padrão de organização de sistemas multi-agente onde um Orchestrator top-level gerencia stage-level planning e delega trabalho especializado a agents hierárquicos via interface uniforme (Agent-as-Tool).

## Princípio: Thin Control over Thick State

- **Thin control:** Orchestrator raciocina no nível de stages, vê apenas summaries e workspace map compacto. Não carrega o workspace completo no contexto ativo.
- **Thick state:** Estado detalhado do projeto (análises, código, logs, resultados) é externalizado em artefatos duráveis — o [[03-RESOURCES/concepts/pkm-obsidian/file-as-bus]].
- **Progressive disclosure:** Specialists expandem para contexto local rico durante execução, via reads direcionados de artefatos, não por herança do histórico completo.

## Agent-as-Tool

Design crítico: cada Tier-1 specialist é exposto ao Orchestrator com a mesma interface callable de ferramentas comuns (shell, file, web). Isso torna delegação uma *ação no espaço de decisão do Orchestrator*, não um protocolo separado.

**Implicação:** Delegação é seletiva, não mandatória. Orchestrator pode executar operações leves diretamente e só invoca specialists quando o benefício esperado supera o custo de coordenação.

## Tiers no AiScientist

```
Tier-0: Orchestrator
  → Workspace map + stage summaries
  → Delegação via Agent-as-Tool

Tier-1: Specialists
  → Paper Comprehension  (paper → impl details + target metrics)
  → Prioritization       (compreensão → execution contract)
  → Implementation       (full mode: build | fix mode: patch)
  → Experimentation      (run → compare metrics → log)
  → Generic Helper       (subtarefas avulsas)

Tier-2: Subagents
  → Leaf workers escopados dentro de um Specialist
  → Não spawnam camadas mais profundas
  → Ex: structure extraction, env setup, resource download
```

## Evidência Empírica

Comparação AiScientist vs baselines não-hierárquicos (BasicAgent/AIDE):
- Mesmo a variante *sem* File-as-Bus supera BasicAgent em +4.74 pts (PaperBench) e +9.09 pts Any Medal (MLE-Bench Lite)
- Indica que hierarquia de roles especializados contribui materialmente *além* da continuidade de estado

## Diferença vs Multi-Agent Simples

| Aspecto | Multi-Agent Flat | Hierarchical Orchestration |
|---|---|---|
| Delegação | Protocolo separado | Action no espaço do Orchestrator |
| Contexto do Orchestrator | Pode crescer indefinidamente | Thin — só summaries + workspace map |
| Especialização | Qualquer agente pode fazer qualquer coisa | Roles alinhados com stages do workflow |
| Reinicialização de contexto | Acumula entre calls | Reinicializado a cada invocação (continuidade via artefatos) |

## Relação com outros padrões

- [[03-RESOURCES/concepts/pkm-obsidian/file-as-bus]] — substrato de estado que torna thin control possível
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — padrão mais geral; hierarchical orchestration é implementação específica
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — thin control é context engineering aplicado ao control plane

## Ver também

- [[03-RESOURCES/concepts/pkm-obsidian/file-as-bus]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/entities/AiScientist]]

## Padrão Supervisor na Prática (Anthropic)

A Anthropic define o pattern de três formas segundo o nível de controle delegado:
- **Full orchestration**: controle supervisório completo sobre interações e execução
- **Routing-focused**: especializa em decisões de delegação, passa comunicação ao especialista
- **Hybrid coordination**: supervisor envolvido seletivamente por complexidade da tarefa

Subagentes podem ter seus próprios subagentes — o supervisor vê apenas o team leader, não delegações internas. Isso é equivalente à abstração de Tier-2 no AiScientist.

**Context management** é o desafio central: context editing (limpar tool calls stale), memory tools (persistência cross-session), cap de ~25k tokens por resposta para evitar context exhaustion.

Exemplo canônico: marketing agency com supervisor "Marketing Director Agent" + especialistas (Market Research, Creative Design, Copywriting, Media Planning).

## Fontes

- [[03-RESOURCES/sources/building-effective-ai-agents-anthropic]] — supervisor pattern + implementation variations (Anthropic, 2026)
- [[03-RESOURCES/sources/ml-research-papers/toward-autonomous-long-horizon-engineering-ml-research]] (arXiv 2604.13018)
