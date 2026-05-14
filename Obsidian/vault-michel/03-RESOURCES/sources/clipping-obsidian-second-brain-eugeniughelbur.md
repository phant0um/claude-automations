---
title: "obsidian-second-brain — Claude Code Skill for Obsidian"
type: source
source_type: clipping
category: ai-agents
ingested: 2026-05-05
author: "Eugeniu Ghelbur"
source_url: "https://github.com/eugeniughelbur/obsidian-second-brain"
tags: [obsidian, second-brain, claude-code, llm-wiki, karpathy, auto-synthesis, scheduled-agents]
---

# obsidian-second-brain — Claude Code Skill for Obsidian

**Author:** Eugeniu Ghelbur (AI Automation Engineer @ Single Grain)

## Summary

Extension of Karpathy's LLM Wiki pattern into a self-maintaining Obsidian vault. Key difference: new sources rewrite existing pages (not just append), contradictions reconcile automatically, unnamed patterns are synthesized into new pages, and 4 scheduled agents (nightly close, weekly review, contradiction sweep, vault-health) keep the vault alive without prompting. 31 commands including live research from X, web, and YouTube.

## Key Takeaways
- Evolves Karpathy's append-only wiki into a self-rewriting system
- `/obsidian-reconcile` resolves contradictions automatically
- `/obsidian-synthesize` finds unnamed patterns across notes
- 4 scheduled agents: nightly close, weekly review, contradiction sweep, health check
- AI-first note format: `## For future Claude` preamble + frontmatter for LLM retrieval
- Research toolkit: `/x-read`, `/x-pulse`, `/research`, `/research-deep`, `/youtube`
- 4 role presets available

## Concepts Linked
- [[03-RESOURCES/concepts/second-brain]]
- [[03-RESOURCES/concepts/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/knowledge-compounding]]
- [[03-RESOURCES/concepts/self-evolving-agents]]

## Entities Linked
- [[03-RESOURCES/entities/Obsidian]]
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/Andrej Karpathy]]
