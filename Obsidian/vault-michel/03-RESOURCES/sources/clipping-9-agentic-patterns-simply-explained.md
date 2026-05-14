---
title: "9 Agentic Patterns, Simply Explained"
type: source
source_type: clipping
category: ai-agents
ingested: 2026-05-05
tags: [agentic-patterns, workflow-patterns, agent-patterns, system-design, llm-architecture, prompt-chaining, routing, parallelization, orchestrator-workers, reflection, react, tool-use]
---

# 9 Agentic Patterns, Simply Explained

**Source:** https://newsletter.systemdesign.one/p/agentic-design-patterns  
**Author:** [[03-RESOURCES/entities/Neo-Kim]]  
**Published:** 2026-04-22

## Summary

This article from System Design Newsletter #140 presents a practical escalation ladder for building LLM-powered systems, covering nine design patterns split between workflow patterns (code controls the flow) and agent patterns (LLM controls the flow). The central principle is to start with the simplest setup that works — a direct API call — and only escalate when the simpler approach actually fails. Workflow patterns include prompt chaining, routing, parallelization (sectioning and voting), and orchestrator-workers; agent patterns cover reflection, tool use, ReAct, planning, and the evaluator-optimizer loop. The key insight is that 70-80% prototype stalls are usually prompt quality issues, not architecture gaps. Most production systems should not need to go beyond parallelization.

## Key Takeaways

- Start with direct API calls (summarization, classification, extraction) before adding any workflow complexity
- Escalate to workflow patterns when a task has many steps AND fixed steps knowable in advance
- Escalate to agent patterns only when the number and type of steps are unknown until runtime
- Prompt chaining = sequential LLM calls with validation gates between steps (like CI/CD pipelines)
- Routing = classifier sends input to the right handler (cheap vs expensive model based on complexity)
- Parallelization has two variants: **sectioning** (different jobs in parallel, merge results) and **voting** (same job multiple times, consensus)
- Orchestrator-workers: central LLM breaks task into dynamic subtasks; workers don't talk to each other
- Agent patterns define constraints (tools, budget, stop conditions) instead of steps
- Reflection = LLM generates, reviews its own output, iterates; same model can be generator and critic
- ReAct = Reason + Act loop: the dominant agent execution pattern
- "You write more code handling exceptions than doing actual work" = signal to switch to agent pattern
- Move to complex pattern only after simpler one has actually failed, not when it feels limiting

## Concepts Linked

- [[03-RESOURCES/concepts/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agentic-agents]]
- [[03-RESOURCES/concepts/subagent-spawning]]
- [[03-RESOURCES/concepts/hierarchical-orchestration]]
- [[03-RESOURCES/concepts/prompt-caching]]
- [[03-RESOURCES/concepts/agentic-patterns]]

## Entities Linked

- [[03-RESOURCES/entities/Neo-Kim]]
