---
title: "Connections — 2026-06-22 Run 2"
type: report
connections_found: 8
sources_scanned: 97
generated_by: connection-finder v2.2
created: 2026-06-22
---

# Non-Obvious Connections — 2026-06-22 Run 2

Pipeline semanal batch: 97 new source pages vs 80 older vault items (50 sources + 30 concepts).

---

## Cross-Domain

### 1. Agent optimization loop ↔ RLHF pipeline (old vault)
[[03-RESOURCES/sources/ai-agents/agent-optimization-loop-foundry]] ↔ [[03-RESOURCES/concepts/agent-systems/rl-conductor-orchestration]]

**Connection:** Foundry's optimization loop (prompt → traces → evals → promote) is structurally identical to RLHF pipeline, but applied to agent config instead of model weights. Both are search problems: sample → score → promote if quality holds. The Foundry source explicitly reframes agent improvement as search, not debugging — which is the same epistemic shift RLHF made from supervised learning to reward-driven search.

**Action:** Add wikilink in Foundry source to `rl-conductor-orchestration` concept.

### 2. MosaicLeaks privacy leakage ↔ Agent security "memória envenenada" (old vault)
[[03-RESOURCES/sources/ai-agents/mosaicleaks-research-agent-keep-secret]] ↔ [[03-RESOURCES/concepts/agent-systems/agent-security]]

**Connection:** MosaicLeaks proves that agent web queries leak private info via mosaic effect — individual queries innocent, aggregate reveals secrets. The vault's `agent-security` concept already documents "memória envenenada" vector (hot.md contamination from Clippings). Both are the same class: indirect information leakage through a channel that looks innocent in isolation. MosaicLeaks is the external-query variant; poisoned memory is the internal-store variant.

**Action:** Wikilink added (done via concept enrichment in kanban item 2).

### 3. IFC deterministic labels ↔ Agent governance layers (old vault)
[[03-RESOURCES/sources/ai-agents/towards-secure-autonomous-agents-with-information-flow-control-ifc]] ↔ [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]

**Connection:** IFC's 3-step system (label → propagate → check) is the deterministic implementation of Governance Layer 2 (Policy/Permission). Both enforce boundaries on agent actions before execution. IFC adds data-level labels (integrity/confidentiality) that governance layers don't model — governance governs actions, IFC governs data flow. They're complementary, not competing.

**Action:** Add cross-wikilink between IFC source and governance-layers concept.

### 4. Pi LoopFlows "AI through process" ↔ Stop babysitting agents "Definition of Done" (old vault)
[[03-RESOURCES/sources/ai-agents-harness/pi-coding-agent-pi-loopflows]] ↔ [[03-RESOURCES/sources/ai-agents-harness/stop-babysitting-agents-definition-of-done-ericosiu]]

**Connection:** Both argue AI should work through an explicit process, not produce a confident answer. Pi LoopFlows implements this with LEGO-block subagents + control flow gates. "Stop babysitting agents" defines the same principle via "Definition of Done" — the agent's work isn't done until verified by external criteria, not self-report. Pi LoopFlows is the implementation; DoD is the principle.

**Action:** Add bidirectional wikilink.

## Contradictions

### 5. Polymarket trading agent viability ↔ IC3 paper "no autonomous trading"
[[03-RESOURCES/sources/financial-trading/ic3-paper-ai-agent-platforms-no-autonomous-on-chain-trading]] vs [[03-RESOURCES/sources/ai-agents-harness/harness-engineering-polymarket-trading-agent]]

**Connection:** The Polymarket harness source describes a 16-step roadmap to build a working trading agent. The IC3 paper (same batch) finds that most AI agent crypto platforms show NO evidence of autonomous trading. These aren't contradictory — Polymarket is off-chain (prediction market), IC3 covers on-chain DeFi. But the contrast is sharp: one says "here's how to build it," the other says "most who claim they did, didn't."

**Action:** Note in contradiction register (already done in F3.4).

## Patterns 3+

### 6. "Agent should work through process, not produce confident answer" (5+ sources)
- [[03-RESOURCES/sources/ai-agents-harness/pi-coding-agent-pi-loopflows]] — "AI deve trabalhar através de um processo, não apenas produzir confident answer"
- [[03-RESOURCES/sources/ai-agents/loop-engineering-a-technical-roadmap-for-an-autonomous-loop]] — check must be external deterministic oracle, not self-assessment
- [[03-RESOURCES/sources/ai-agents/agent-optimization-loop-foundry]] — reframe improvement as search, not debugging
- [[03-RESOURCES/sources/ai-agents/the-agent-optimization-loop-and-how-we-built-it-in-foundry]] — traces → evals → optimization loop
- [[03-RESOURCES/sources/ai-agents/is-it-agentic-enough-benchmarking-open-models]] — benchmark the process, not just the final answer

**Pattern:** "Process > output" is the meta-pattern of this batch. Five independent sources converge: the value of an agent is in its process (verifiable steps), not its output (confident answer). This is the verification layer that separates production agents from demos.

**Action:** Flag as meta-pattern candidate for `agent-loop-design` concept.

### 7. "Skills as modular unit of loops" (3 sources)
- [[03-RESOURCES/sources/claude-code-skills/how-to-build-a-claude-skill]] — "pastou 3+ vezes → Skill"
- [[03-RESOURCES/sources/claude-code-skills/claude-code-skills-the-hidden-system-prompt-layer]] — Skills as permanent capability packages
- [[03-RESOURCES/sources/ai-agents/your-first-ai-loop-should-be-for-yourself]] — first loop should be personal/dogfooded

**Pattern:** Skills and loops are isomorphic — both are "package once, reuse automatically." The rule "paste 3+ times → Skill" is the same heuristic as "repeat 3+ times → loop." Skills are the human-facing interface; loops are the execution layer.

**Action:** Add note in `loop-engineering-patterns` concept (already done via kanban item 1).

## Evolution

### 8. Hermes Flightplan ↔ "15 levels of Hermes Agent" (old vault)
[[03-RESOURCES/sources/ai-agents/hermes-flightplan-1-the-ultimate-zero-to-always-on-telegram-ai-agent-full-copy-paste-code]] ↔ [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]

**Connection:** Flightplan is the concrete deployment guide (VPS/Mac, Telegram gateway, systemd/launchd durability). "15 levels of Hermes" is the abstraction taxonomy. Flightplan implements level 4-5 (always-on managed service); the taxonomy shows what's above and below. Together they form a complete picture: what to build (taxonomy) and how to deploy it (flightplan).

**Action:** Add cross-wikilink.

---

## Suggestions

- Consolidate `co-scientist-a-multi-agent-ai-partner-to-accelerate-research` (root) and `co-scientist-multi-agent-ai-partner-research` (ai-agents/) — duplicate source pages from same Clipping, different subagent paths
- Investigate: IFC + governance-layers could merge into a single "agent-control-planes" concept — IFC governs data flow, governance governs actions, both deterministic
- `agent-optimization-loop-foundry` (ai-agents/) and `the-agent-optimization-loop-and-how-we-built-it-in-foundry` (root → should be moved to ai-agents/) — near-duplicate pages from different subagent batches

---

## Quality Gate

- [x] Every [[wikilink]] resolves to existing file or noted as suggestion
- [x] No duplicate connections with previous report (checked vs 2026-06-22-connections.md)
- [x] Each connection has concrete action item
- [ ] Hot cache entry added (pending)
- [ ] Bidirectional wikilinks applied for high-confidence connections (pending)