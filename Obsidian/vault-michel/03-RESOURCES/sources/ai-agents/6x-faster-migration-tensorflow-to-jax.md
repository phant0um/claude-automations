---
title: "6x Faster Migration from TensorFlow to JAX — Google Multi-Agent System"
type: source
source_url: "https://cloud.google.com/blog/topics/developers-practitioners/6x-faster-migration-from-tensorflow-to-jax"
author: "Jamie Rogers, Parthasarathy Ranganathan"
published: 2026-05-06
created: 2026-06-22
score: A
category: ai-agents
tags: [source, ai-agents, multi-agent, code-migration, google, jax, tensorflow, software-engineering]
---

# 6x Faster Migration from TensorFlow to JAX

Google's AI and Infrastructure team deployed a specialized multi-agent system for large-scale production model migration from TensorFlow to JAX, achieving 6.4-8x speedup over manual migration.

## Tese Central

Generic single-agent coding assistants fail at massive, systemic codebase migrations because they lose context over long workflows, hallucinate APIs, and can't produce buildable code across entire repositories. Google solved this with a specialized multi-agent architecture combining deterministic static analysis, hierarchical playbooks, and rigorous verification.

## Arquitetura Multi-Agent

Three specialized agents with distinct roles:

### Planner Agent
- Uses **deterministic, compiler-based static analysis** to map the codebase's entire dependency tree
- Breaks migration into discrete step-by-step plan
- Works from **leaf nodes** (layers without unmigrated dependencies) upward
- Ensures migration happens logically, not randomly

### Orchestrator Agent
- Acts as **project manager**
- Dynamically groups plan steps into manageable chunks to keep context window focused
- Injects necessary domain knowledge
- Handles **failure recovery** if a step doesn't build

### Coder Agent
- Built as a **reasoning and acting agent** (ReAct pattern)
- Integrated directly into internal IDE tools
- Can read files, write code, run builds, execute unit tests
- Operates in a **test-and-fix loop**, self-correcting until compilable, verifiable component

## Playbooks Hierárquicos

Scalable, hierarchical system of Playbooks — from general repository instructions to highly specific "golden examples" distilled from successful manual migrations.

- Client-specific Playbook (e.g., tailored to YouTube's ranking model infrastructure) avoids generic hallucinations
- Strictly adheres to internal coding standards
- **Framework-agnostic**: adaptable to migrations between any two languages or frameworks

## Verificação de Qualidade

### Quantitative Verification
For each unit of code: **algorithmic gradient ascent** to find maximum error between original TF layer and new JAX layer — mathematically verifying functional equivalence.

### Qualitative Evaluation
**Blind-audit LLM Judge** scores migrated code against a framework-agnostic architectural checklist, ensuring critical domain-specific logic is captured.

## Resultados

- 6.4x to 8x speedup on real-world YouTube models (thousands of lines, hundreds of layers, deep metric dependencies)
- Tasks that took SWE-months reduced to weeks of AI-assisted generation + expert human review
- Engineers act as **reviewers and architects** rather than manual translators

## Por que é Score A

- **Diretamente aplicável** ao vault: padrão de arquitetura multi-agent para tarefas long-horizon
- Valida [[03-RESOURCES/concepts/agent-systems/agent-loop-design|agent loop design]] com test-and-fix loop
- Evidência real de produção (não teórica) — Google-scale migration
- Conecta a [[03-RESOURCES/concepts/agent-systems/agent-model-routing|model routing]] (Planner deterministic + Coder LLM)
- Verificação matemática = [[03-RESOURCES/concepts/llm-ml-foundations/generator-verifier-loop|generator-verifier pattern]] em produção

## Conexões Vault

- [[03-RESOURCES/concepts/agent-systems/agent-architecture]] — arquitetura multi-agent especializada
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]] — test-and-fix loop pattern
- [[03-RESOURCES/concepts/llm-ml-foundations/generator-verifier-loop]] — verificação como camada separada
- [[03-RESOURCES/entities/Google-Critique]] — Google AI research
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — IDE integration pattern

## Minha Síntese

A separação Planner (determinístico) / Orchestrator (contexto) / Coder (LLM+test) é o padrão mais maduro visto até agora para long-horizon tasks. A lição principal não é "multi-agent é melhor" — é que **deterministic analysis deve vir antes do LLM**, não depois. O Planner mapeia com compilador, não com LLM. O Coder só age sobre um plano já validado estruturalmente.

Para o vault: o pipeline-semanal já segue esse padrão parcialmente (F1.0 bash heurística antes de AI scoring). Mas faltam playbooks hierárquicos — golden examples de ingests bem-sucedidas poderiam melhorar significativamente a qualidade do triagem-agent.

**Próximo passo**: criar 2-3 golden examples de source pages Score A para usar como few-shot no ingest-agent.