---
title: "NanoGPT-Bench — Intology AI"
type: source
source_url: "https://www.intology.ai/blog/nanogpt-bench"
author: "Intology AI / Soren Dunn"
published: 2026-05-18
ingested: 2026-05-28
tags: [benchmark, ai-research, coding-agents, nanogpt, autonomous-research, claude-code, codex, evaluation]
---

# NanoGPT-Bench — Intology AI

## Tese central

Agentes de coding (Claude Code, Codex, Autoresearch) recuperam menos de 10% do progresso humano em 5 meses no NanoGPT Speedrun com 512 H100-horas cada. O gap principal: humanos fazem pesquisa algorítmica (~76% do tempo); agentes fazem hyperparameter tuning (~90% do tempo).

## Key insights

- **Setup:** agentes partem do world record humano de 3 set 2025 (pós-cutoff de todos os modelos fronteira) e trabalham autônomo sem internet. Métrica: speedup válido no training time até perda de validação 3.28.
- **Resultados:** Autoresearch=9.3%, Claude Code Opus 4.6=8.2%, Codex GPT-5.4=8.6% do progresso humano em 5 meses (63.2 segundos de speedup total pelos humanos).
- **Diferença qualitativa:** humanos incluem mudanças algorítmicas em ~76% dos records; agentes em <10% das submissões. Codex evita pesquisa algorítmica quase totalmente. Claude e Autoresearch raciocinam sobre ela mas raramente implementam.
- **Padrão de raciocínio sem ação:** Autoresearch considerou reduzir value embeddings de 3 para 2 em 17 ocasiões separadas mas nunca implementou.
- **Locus exception:** o record humano #31 foi na verdade do sistema Locus (Intology AI) que implementou um kernel triton fundido — único agente que atingiu nível de pesquisa algorítmica humana.
- **Contaminação:** zero records pós-3 set 2025 descritos com abordagem específica por nenhum modelo; 0.7-5.9% de match em abordagem geral (baixo).
- **Taxonomia de submissões:** Algorithmic Research (ML/systems) → Engineering Optimizations → Hyperparameter Tuning — hierarquia útil para avaliar qualquer sistema de auto-pesquisa.

## Implicações para o vault

- Evidência empírica forte para [[03-RESOURCES/concepts/llm-ml-foundations/recursive-self-improvement]] — agentes atuais não fazem pesquisa algorítmica de forma autônoma.
- Complementa [[03-RESOURCES/concepts/llm-ml-foundations/world-model-l1-l2-l3]] e [[03-RESOURCES/sources/ml-research-papers/automated-weak-to-strong-researcher]] — gap real entre coding agents e pesquisa científica.
- Útil para contextualizar capacidades e limites do [[03-RESOURCES/entities/Claude Code]] em tarefas de R&D de longa duração.
- A distinção hyperparameter tuning vs. algorithmic research é um framework de avaliação reusável para qualquer benchmark de agentes.

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/recursive-self-improvement]]
- [[03-RESOURCES/concepts/agent-systems/]]
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/Andrej Karpathy]] — autoresearch harness usado como baseline
