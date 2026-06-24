---
title: "Apresentamos o JetBrains Central, um sistema aberto para o desenvolvimento de software com agentes"
type: source
source_url: "https://blog.jetbrains.com/pt-br/blog/2026/04/04/apresentamos-o-jetbrains-central-um-sistema-aberto-para-o-desenvolvimento-de-software-com-agentes/"
author: "Luiz Di Bella (JetBrains)"
published: 2026-04-04
created: 2026-06-22
updated: 2026-06-22
score: B
category: ai-agents
tags: [source, ai-agents, jetbrains-central, agent-infrastructure, governance, agent-platform, jetbrains]
---

# Apresentamos o JetBrains Central

JetBrains Central é um sistema aberto para desenvolvimento de software com agentes de IA — conecta ferramentas, agentes e infraestrutura, permitindo que trabalho automatizado seja executado, monitorado e gerenciado através de várias equipes com visibilidade de resultados, custo e desempenho.

## Tese Central

À medida que agentes de IA escalam além de ferramentas individuais, o desenvolvimento de software se torna um sistema distribuído de agentes, ambientes e fluxos de trabalho. A geração de código ficou barata; o desafio real é alinhar desfechos com intenções e gerenciar complexidade operacional/econômica. JetBrains Central transforma fluxos discretos de IA em um sistema unificado de produção com três capacidades: **governança e controle**, **infraestrutura de execução de agentes**, e **otimização e contexto dos agentes**.

## Pontos-Chave

### Contexto de Mercado

- 90% dos 11.000 devs na pesquisa AI Pulse da JetBrains (jan 2026) já usam IA
- 22% já usam agentes de programação por IA; 66% das empresas planejam adotar em 12 meses
- Apenas 13% usam IA em todo o ciclo de SDLC; organizações têm dificuldade em traduzir uso em melhorias mensuráveis

### Três Capacidades Fundamentais

1. **Governança e controle** — políticas, identidade/acesso, observabilidade, auditabilidade, atribuição de custos. Disponível via JetBrains Central Console
2. **Infraestrutura de execução de agentes** — runtimes na nuvem, provisionamento computacional multi-ambiente
3. **Otimização e contexto dos agentes** — contexto semântico compartilhado entre repositórios, encaminhamento de tarefas para tools/modelos apropriados

### Arquitetura em Camadas (não monolítica)

- Conecta ferramentas de dev, agentes de IA, e infraestrutura de desenvolvimento
- Sem amarras tecnológicas: organizações integram novas tools/modelos enquanto preservam sistemas existentes
- Suporta agentes JetBrains e externos: Claude Agent, Codex, Gemini CLI, soluções personalizadas

### Contexto Semântico

- Camada semântica agrega e estrutura continuamente informações de código, arquitetura, comportamento em runtime, e conhecimento organizacional
- Permite agentes operarem com compreensão no nível do sistema (não só prompt-level)
- Encaminhamento inteligente: seleciona modelos, tools, e caminhos de execução apropriados por tarefa
- Colaboração via Slack, Atlassian, Linear — fluxos integrados aos sistemas existentes

### JetBrains Air

- **Air App**: workspace dedicado para devs organizarem tarefas, executarem fluxos assistidos por agentes, revisarem resultados
- **Air Team** (em desenvolvimento): coordenar trabalho entre humanos e agentes, organizar tarefas, executar fluxos multi-step, permanecer alinhados

### Disponibilidade

EAP inicia Q2 2026 com grupo limitado de design partners.

## Conceitos

- [[03-RESOURCES/concepts/agent-systems/agent-platform-architecture]] — arquitetura de plataforma
- [[03-RESOURCES/concepts/agent-systems/agent-orchestration]] — orquestração
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]] — governance
- [[03-RESOURCES/concepts/agent-systems/agent-observability]] — observabilidade
- [[03-RESOURCES/concepts/agent-systems/agent-systems]] — sistemas de agentes
- [[03-RESOURCES/concepts/agent-systems/managed-agents-harness]] — managed agents
- [[03-RESOURCES/concepts/agent-systems/agent-runtime-architecture-patterns-sdb]] — runtime patterns

## Links

- [[03-RESOURCES/entities/MCP]] — MCP usado para integração
- [[03-RESOURCES/entities/anthropic]] — Claude Agent suportado