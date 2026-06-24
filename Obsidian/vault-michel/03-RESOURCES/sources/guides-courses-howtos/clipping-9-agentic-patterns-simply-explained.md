---
title: "9 Agentic Patterns, Simply Explained"
type: source
source_type: clipping
category: ai-agents
ingested: 2026-05-05
tags: [agentic-patterns, workflow-patterns, agent-patterns, system-design, llm-architecture, prompt-chaining, routing, parallelization, orchestrator-workers, reflection, react, tool-use]
triagem_score: 9
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

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]]
- [[03-RESOURCES/concepts/agentic-patterns]]

## Entities Linked

- [[03-RESOURCES/entities/Neo-Kim]]

## Pattern Mechanism Details

### Prompt Chaining

Sequential LLM calls where the output of step N becomes (part of) the input to step N+1. Validation gates between steps (assertion checks, format validators, confidence thresholds) catch failures early rather than propagating corrupt intermediate results downstream.

The CI/CD analogy is precise: a chain without gates is a pipeline that fails silently at the end. Gates make failures loud and early — cheaper to diagnose than a broken final output.

**When to use:** tasks with clearly ordered phases where each phase produces a checkable artifact. Document generation (outline → section draft → revision → final), data transformation (extract → clean → transform → validate), multi-step reasoning where intermediate answers are independently verifiable.

### Routing

A classifier front-end directs requests to specialized handlers. The classifier itself is typically a smaller, cheaper model — its only job is categorization, not response generation.

**Binary routing:** cheap model handles ≤ medium complexity; expensive model handles high complexity. The classifier decides which bin. Savings materialize when ≥ 70% of traffic falls in the cheap bin.

**Multi-class routing:** tasks route to specialist handlers (code questions → code handler; factual queries → retrieval handler; creative tasks → generative handler). Specialists are tuned or prompted for their specific domain, producing higher quality than a generalist on everything.

**Failure mode:** a weak classifier misfires frequently, sending complex queries to cheap models and wasting expensive model capacity on easy queries. The classifier's accuracy is the bottleneck — test it independently.

### Parallelization — Sectioning vs. Voting

**Sectioning:** a document or codebase is split into N non-overlapping sections. N workers process sections simultaneously. Results are concatenated or merged by an orchestrator. Reduces wall-clock time proportional to N (with diminishing returns from coordination overhead).

**Voting:** the same task is sent to K independent model instances. Outputs are compared; the majority answer (for factual/multiple-choice tasks) or highest-confidence output (for generative tasks) is selected. Does not reduce cost — multiplies it by K — but increases reliability. Use when the cost of a wrong answer exceeds K × generation cost.

The distinction matters because they target different problems: sectioning targets latency, voting targets accuracy. Conflating them leads to using voting on latency-constrained tasks (expensive, no speed gain) or sectioning on accuracy-constrained tasks (no reliability gain).

### ReAct — Reason + Act Loop

The dominant agent execution pattern. The model alternates between two phases:
1. **Reason:** given the current state and history, what should I do next? Produce a thought.
2. **Act:** execute the chosen action (tool call, search, code execution). Observe the result.

The observation feeds back into the next Reason step. The loop terminates on a stop condition (task complete, max iterations, budget exhausted).

**Why ReAct outperforms chain-of-thought alone:** CoT reasons but cannot act. ReAct grounds reasoning in real observations — errors in reasoning are corrected by actual tool results, not by the model predicting what results would be.

**Implementation detail:** the `<thought>` blocks in ReAct are not shown to the user in production deployments. They serve as scratchpad. The cost of ReAct is proportional to loop depth — shallow loops (1-3 actions) are cheap; deep loops (10+ actions) accumulate significant context.

### Reflection — Self-Critique Without External Feedback

The same model (or a second instance of the same model) reviews its own output and iterates. The generator produces output; the critic identifies flaws; the generator revises; repeat until stop condition.

**When the same model is both generator and critic:** useful when the generator has access to reasoning during critique that it didn't use during generation (different system prompt, different framing). A common failure mode: the same model convincing itself the wrong answer is correct — the critique reinforces the original error.

**When two models are used:** generator and critic can be different models or different system prompts. Cross-model reflection catches more errors but doubles or triples cost.

## Escalation Decision Framework — Practical Checklist

Before adding any pattern, verify:

- [ ] Have I profiled where the current single-call system fails? (Profile before escalating)
- [ ] Is the failure a prompt quality issue? (Rewrite the prompt first — 70-80% of stalls are here)
- [ ] Are the steps fixed and known in advance? (Yes → workflow pattern; No → agent pattern)
- [ ] Do I have a measured quality baseline to compare against after adding complexity?
- [ ] Am I adding this pattern because a simpler approach actually failed, not because it feels limiting?

The last question is the most important. Most 2026 multi-agent systems are over-engineered for their actual quality requirements. Orchestrator-workers with 5 agents where 2 would suffice is not sophistication — it is unnecessary cost and failure surface.

## Relevance to vault-michel

The vault's agent architecture (40+ specialists + Nexus orchestrator) maps to the orchestrator-workers pattern at scale, with Kanban-style durable state in the task queue (`07-QUEUE/`). The escalation ladder in this source validates the architectural decision: single agent → parallelization → orchestrator-workers → durable board, each transition justified by a specific failure mode in the previous tier.
