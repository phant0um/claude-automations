---
title: "Synthetic Computers at Scale for Long-Horizon Productivity Simulation"
type: source
source_file: "Clippings/Synthetic Computers at Scale for Long-Horizon Productivity Simulation.md"
url: "https://arxiv.org/html/2604.28181v1"
authors: [Tao Ge, Baolin Peng, Hao Cheng, Jianfeng Gao]
org: Microsoft
dataset: "huggingface.co/datasets/microsoft/synthetic-computers-at-scale"
created: 2026-05-14
updated: 2026-05-14
tags: [source, synthetic-data, long-horizon, productivity, agent-training, agentic-rl, microsoft]
triagem_score: 9
---

# Synthetic Computers at Scale

## Core Contribution

A scalable methodology for generating synthetic user computer environments — complete with realistic personas, filesystem hierarchies, and content-rich artifacts — to serve as grounding environments for long-horizon productivity simulations. Each environment is then used to run month-equivalent agentic work sessions that produce rich experiential training signals for improving agents in productivity scenarios.

## The Problem Being Solved

Real long-horizon productivity work (reports, spreadsheets, presentations spanning weeks) requires agent access to rich, user-specific context: existing files, project history, collaborator feedback, and evolving work state. But real user computers contain private data, making real trajectory collection at scale impossible. Generic synthetic data fails because it lacks the user-specific context that grounds real work.

**Three guiding principles:**
1. Productivity work is context-heavy by nature
2. The key challenge is using rich user context over long horizons
3. Synthetic data must synthesize the context, not only the task

## Method: Synthetic Computer Creation Pipeline

**Phase 1 — Persona elaboration:**
- Start from large persona pools (abundant at billion scale)
- Expand persona → detailed user profile (identity, occupation, responsibilities, document habits, naming preferences, collaborators, current projects)

**Phase 2 — Filesystem planning:**
- Generate user-specific filesystem policy (drive layout, storage patterns, organization style, naming conventions)
- Plan file inventory: logical paths, artifact types, timestamps, cross-file dependencies

**Phase 3 — Artifact instantiation:**
- Populate directory with realistic, content-rich artifacts (Word docs, Excel sheets, PDFs, presentations)
- Content reflects user's actual work context, project history, and collaborator communications

**Phase 4 — Long-horizon simulation:**
- Setup agent: creates productivity objectives tailored to the computer's user (~1 month of human work, multiple professional deliverables)
- Work agent: acts as that user, navigates filesystem, coordinates with simulated collaborators, iteratively produces deliverables
- Each run: **>8 hours agent runtime, >2,000 turns on average**

## Scale of Preliminary Experiments

- **1,000 synthetic computers** created (50/50 Windows/macOS split in released subset of 100)
- 900 used for training signal extraction, 100 held-out for evaluation
- Releases: 100 synthetic computers + 500 retrospective analysis reports

## Evaluation

### Rubric-Based Outcome Scoring
- Judge agent (Claude Opus 4.6 via Claude Code SDK) scores final deliverables against per-computer rubric
- 5 simulation runs per computer → merged rubric for generality
- Baseline score distribution: most computers score **60–80%** (substantial room for improvement)

### In-Domain Results (occupation skills)
- Experience extracted from 900 training simulations → occupation-specific skills
- Skill-augmented agent: mean rubric score **61.6% → 68.6%**
- Skill-augmented agent wins on **83/100 test computers** vs baseline
- Scaling trend: 10 training computers → marginal gain; 100→64% wins, 500→75% wins, 900→83% wins
- With 10 computers: some harm (skill mismatch) — occupation coverage matters

### Out-of-Domain Evaluation
- Tested on real productivity benchmarks beyond synthetic distribution
- Shows significant improvement — demonstrates experiential learning generalizes

## Key Insight: Environment-Conditioned Synthetic Data

The methodology's core claim: synthetic data without realistic user environments degenerates into generic, toy workflows. The environment IS the signal — the agent must navigate actual filesystem structure, reference real files, and coordinate with realistic collaborators to produce grounded work.

**Claude Cowork is cited** as the frontier product requiring this capability: long-horizon agents grounded in entire user computers.

## Implications for Vault

- Directly relevant to [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — provides a scalable environment generation substrate
- Addresses the "environment diversity" challenge identified in agentic RL literature
- Extends [[03-RESOURCES/concepts/llm-ml-foundations/synthetic-data-for-agents]] thinking beyond code/math to realistic productivity work
- The persona-driven pipeline could scale to billions of environments — theoretical ceiling for synthetic data diversity

## Connections

- [[03-RESOURCES/concepts/llm-ml-foundations/synthetic-data-for-agents]] — concept page for this pattern
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — RL framework this enables
- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-length]] — the training bottleneck this methodology addresses by providing grounded environments
- [[03-RESOURCES/concepts/ai-strategy-org/dual-data-flywheel]] — complementary approach to agentic data diversity
- [[03-RESOURCES/entities/Microsoft-Research-Asia]] — authoring lab (MSRA affiliation)
- [[03-RESOURCES/entities/Claude-Cowork]] — cited product requiring this capability

## Por que o ambiente é o sinal, não apenas o cenário

A distinção conceitual mais importante do paper é que ambientes sintéticos sem conteúdo específico do usuário produzem dados de treino genéricos. Um filesystem de "gerente de projeto" com documentos fictícios sobre projetos fictícios não reflete o que um agente real precisaria fazer — porque o agente real navegaria documentos com context histórico, referências a pessoas reais, convenções de nomenclatura idiossincráticas, e dependências entre arquivos que refletem a evolução real de um projeto ao longo do tempo.

A geração de artefatos como função da persona (identidade, responsabilidades, histórico de documentação, convenções de nomenclatura) é o que cria essa textura realista. Não é apenas "qual tipo de arquivo", mas "como esse arquivo específico seria nomeado por essa pessoa, com quais referências a outros arquivos, e com quais evidências de evolução ao longo do tempo." Essa especificidade é o que permite que agents treinados nesse ambiente generalizem para computadores reais.

## A curva de escala de 10→900 computadores tem implicações de custo

A progressão de wins — 10 computadores: dano marginal; 100: 64% wins; 500: 75% wins; 900: 83% wins — sugere que o retorno por computer adicionado é decrescente mas significativo até pelo menos 900. Para organisations que precisam treinar agents em domínios específicos (jurídico, médico, financeiro), isso implica que collections de ~100-500 synthetic computers por domínio-occupação são o ponto de investimento mais eficiente.

A questão de coverage de ocupação é crítica: o dano observado com 10 computadores provavelmente reflete mismatch de ocupação — skills extraídas de um subconjunto pequeno de ocupações sendo aplicadas a computers de ocupações diferentes. Isso é uma falha de diversidade de treino, não de qualidade do método.

## Relação com o vault-michel como ambiente sintético pessoal

O vault-michel é, em miniatura, exatamente o tipo de ambiente que o paper descreve: um filesystem organizado por uma persona específica (Michel Csasznik, estudante ADS + prep concurso + knowledge worker) com convenções idiossincráticas (kebab-case, tipos de documento, hierarquia de pastas), dependências entre arquivos (wikilinks), e evolução histórica (timestamps, sources). Um agent treinado no vault-michel via simulação seria melhor em navegar o vault-michel do que um agent treinado em dados genéricos — o mesmo princípio do paper em escala pessoal.
