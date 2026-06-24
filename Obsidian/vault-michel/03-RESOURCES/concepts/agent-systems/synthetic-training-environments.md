---
title: Synthetic Training Environments
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [concept, synthetic-data, long-horizon-agents, agentic-rl, productivity-agents, microsoft]
---

# Synthetic Training Environments

Metodologia de geração de ambientes computacionais sintéticos completos — com estrutura de diretórios realista, artefatos ricos e contexto acumulado de usuário específico — para uso como substrato de treinamento de agentes de longo horizonte.

## Problema que Resolve

Agentes de produtividade precisam de contexto denso e específico do usuário (arquivos, histórico, decisões anteriores) para funcionar em cenários reais. Duas abordagens falham:

1. **Trajetórias reais**: inviáveis em escala por privacidade e custo
2. **Dados sintéticos genéricos**: ficam aquém da realidade por ausência de contexto acumulado realista

A solução é **sintetizar o contexto, não apenas a tarefa**.

## Metodologia: Synthetic Computers at Scale (Microsoft)

### Pipeline de Criação

```
Persona → User Profile → Filesystem Policy → Filesystem Planning → Instantiação de Artefatos
```

**Persona** (abundante em escala de bilhões) → expandida em **User Profile** detalhado:
- Identidade, ocupação, cargo, organização
- Histórico de trabalho recente, projetos em curso
- Colaboradores, produtos de trabalho comuns
- Hábitos de documento, nomeação, organização, nível técnico

**Filesystem Policy**: layouts de drives, caminhos padrão, padrões de armazenamento, estilo de nomeação

**Filesystem Planning**: inventário completo de arquivos com paths, tipos, timestamps, origens e **grafo de dependências** inter-artefato (arquivo A é derivado de B, C é versão posterior de B, etc.)

**Instantiação**: artefatos gerados por LLM em ordem topológica do grafo de dependências; arquivos públicos buscados da web e com fallback para síntese

### Pipeline de Simulação

**Dois agentes:**
- **Setup Agent**: lê perfil + computador, cria objetivos de produtividade (~1 mês de trabalho humano, múltiplas entregas profissionais interdependentes) + colaboradores simulados com personalidades, estilos de comunicação e arquivos privados de referência
- **Work Agent**: age como o usuário; navega filesystem para grounding, coordena com colaboradores simulados, incorpora feedback, cria/revisa entregáveis

### Escala dos Experimentos Preliminares

- **1.000 computadores** sintéticos criados
- Cada simulação: **>8 horas** de runtime de agente, **>2.000 turnos** em média
- Sinais de aprendizagem: trajetórias intermediárias + entregáveis finais (outcome-level)

## Escalabilidade Potencial

Personas existem em **escala de bilhões** → metodologia pode escalar para milhões/bilhões de mundos sintéticos com compute suficiente. Cobertura potencial: diversas profissões, papéis, contextos, ambientes, necessidades de produtividade.

## Por que é Diferente de Benchmarks Manuais

| Dimensão | Benchmarks manuais | Synthetic Computers |
|----------|--------------------|---------------------|
| Contexto | Tarefa genérica isolada | Computador completo do usuário |
| Escala | Dezenas-centenas | Potencialmente bilhões |
| Realismo | Toy workflows | Ambientes reais de profissão |
| Diversidade | Limitada por curadoria | Cobre universo de personas |
| Atualidade | Estática | Regenerável com novas personas |

## Recursos Publicados

- 100 computadores sintéticos (50 Windows, 50 macOS)
- Relatórios retrospectivos de 500 simulações
- Dataset: `microsoft/synthetic-computers-at-scale` no HuggingFace

## Conexões

- [[03-RESOURCES/sources/ml-research-papers/synthetic-computers-at-scale-long-horizon-productivity]] — paper primário
- [[03-RESOURCES/entities/Microsoft-Research-Asia]] — lab autora
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — padrões de coordenação multi-agente
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — RL a partir das trajetórias sintéticas
- [[03-RESOURCES/concepts/long-horizon-agent-training]] — treinamento de agentes de longo horizonte (conceito relacionado)
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — contexto como código; complementar à abordagem de contexto denso

## Evidências

- **[2026-06-21]** RL agêntico em ambientes simulados escala bem mas trabalho anterior usava síntese semi-automática ou tarefas pouco difíceis. AutoForge (Alibaba/Tongyi Lab) propõe pipeline unificado de síntese automatizada de ambientes com tarefas difíce... — [[autoforge-automated-environment-synthesis-for-agentic-reinforcement-learning]]
- **[2026-06-21]** Introdução didática a World Models: um agente que aprende uma cópia interna aproximada de como o ambiente se comporta, permitindo prever o próximo estado dado o estado atual + ação, sem precisar agir de fato no ambiente real (rollout ima... — [[how-do-world-models-work]]

## Perspectivas

- **[2026-06-21]** Geração de ambiente via grafo de dependências generaliza out-of-domain (não overfita ao benchmark de treino) — relevante se o Nexus explorar simulação de testes para os próprios agentes. — [[autoforge-automated-environment-synthesis-for-agentic-reinforcement-learning]]
