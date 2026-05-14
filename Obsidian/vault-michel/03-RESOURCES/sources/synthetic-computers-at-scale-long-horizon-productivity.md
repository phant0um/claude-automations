---
title: "Synthetic Computers at Scale for Long-Horizon Productivity Simulation"
type: source
source_type: paper
arxiv: "2604.28181"
authors: [Tao Ge, Baolin Peng, Hao Cheng, Jianfeng Gao]
institution: Microsoft
url: "https://arxiv.org/html/2604.28181v1"
dataset: "https://huggingface.co/datasets/microsoft/synthetic-computers-at-scale"
created: 2026-05-13
ingested: 2026-05-13
tags: [paper, long-horizon-agents, synthetic-data, productivity-agents, microsoft, agentic-rl]
---

## Resumo

Paper da Microsoft que apresenta **Synthetic Computers at Scale** — metodologia escalável para criar ambientes computacionais sintéticos, realistas e específicos para cada usuário, e rodar sobre eles **simulações de produtividade de longo horizonte** para gerar dados de treinamento para agentes.

## Problema Central

Agentes de produtividade precisam de contexto rico e específico do usuário para funcionar bem em cenários reais. Coletar trajetórias reais é inviável em escala (privacidade, custo). Dados sintéticos genéricos ficam aquém da realidade porque carecem do contexto acumulado de um computador de verdade.

**Três princípios guia:**
1. Trabalho de produtividade é condicionado por contexto denso (arquivos, histórico, decisões anteriores).
2. O desafio-chave é usar esse contexto ao longo de horizontes longos.
3. Dados sintéticos precisam sintetizar o *contexto*, não apenas a *tarefa*.

## Metodologia

### 1. Criação do Computador Sintético

**Fluxo:** Persona → User Profile → Filesystem Policy → Filesystem Planning → Instantiação

- **Persona** (abundantes em escala de bilhões) → expandida em **User Profile** detalhado: identidade, ocupação, responsabilidades, histórico de trabalho, projetos em curso, colaboradores, produtos, hábitos de documento e organização.
- **Filesystem Policy**: define layout de drives, caminhos padrão, padrões de armazenamento, estilo de nomeação, nível de organização.
- **Filesystem Planning**: lista completa de arquivos com paths lógicos, tipos, timestamps, origens e dependências inter-artefato.
- **Instantiação**: gera conteúdo real dos artefatos (docs, planilhas, apresentações) condicionado ao plano.

Exemplo de persona: Margaret Elaine Forsythe, Senior Financial Advisor na Meridian Wealth Partners, 16+ anos de experiência, usa Excel/Word/PowerPoint, altamente organizada.

### 2. Simulação de Longo Horizonte

**Dois agentes:**
- **Setup Agent**: lê o perfil do usuário e o computador, cria objetivos de produtividade personalizados (~1 mês de trabalho humano, múltiplas entregas profissionais).
- **Work Agent**: age como o usuário, navega o filesystem, coordena com colaboradores simulados, incorpora feedback, cria/revisa entregáveis.

**Escala dos experimentos preliminares:**
- 1.000 computadores sintéticos
- Cada simulação: >8 horas de runtime de agente, >2.000 turnos em média
- Sinaliza de aprendizagem: trajetórias intermediárias (como o agente busca, planeja, revisa, coordena, recupera de falhas) + entregáveis finais

### 3. Validação

Melhorias significativas no desempenho do agente tanto em tarefas **in-domain** quanto **out-of-domain** de produtividade.

## Recursos Publicados

- 100 computadores sintéticos (50 Windows, 50 macOS)
- Relatórios de análise retrospectiva de 500 simulações de longo horizonte
- Dataset: [huggingface.co/datasets/microsoft/synthetic-computers-at-scale](https://huggingface.co/datasets/microsoft/synthetic-computers-at-scale)

## Escalabilidade

Personas existem em escala de bilhões → metodologia pode escalar para **milhões ou bilhões de mundos sintéticos de usuário** com compute suficiente. Cobertura potencial: diversas profissões, papéis, contextos, ambientes e necessidades de produtividade.

## Importância Estratégica

> "Scalable synthetic computer creation, together with at-scale simulations, is highly promising as a foundational substrate for **agent self-improvement and agentic reinforcement learning** in long-horizon productivity scenarios."

## Conceitos Relacionados

- [[03-RESOURCES/concepts/long-horizon-agent-training]]
- [[03-RESOURCES/concepts/synthetic-training-data]]
- [[03-RESOURCES/concepts/persona-driven-environment-generation]]
- [[03-RESOURCES/concepts/agentic-reinforcement-learning]]

## Entidades Relacionadas

- [[03-RESOURCES/entities/Microsoft-Research]]
- [[03-RESOURCES/entities/Tao-Ge]]

## Cross-links

- [[03-RESOURCES/sources/on-training-large-language-models-for-long-horizon-tasks-an-empirical-study-of-horizon-length]] — estudo empírico sobre horizon length em treinamento; contexto complementar
- [[03-RESOURCES/sources/coordination-as-an-architectural-layer-for-llm-based-multi-agent-systems-an-information-controlled-empirical-study-on-prediction-markets]] — coordenação como camada arquitetural; relacionado a multi-agent productivity
- [[03-RESOURCES/concepts/multi-agent-orchestration]]
