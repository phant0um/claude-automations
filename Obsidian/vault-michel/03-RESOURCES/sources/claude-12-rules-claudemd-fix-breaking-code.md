---
title: "Claude Keeps Breaking Your Code — 12 Rules That Fix It (CLAUDE.md)"
type: source
source: Clippings/Claude Keeps Breaking Your Code Because You're Missing One File. Here Are the 12 Rules That Fix It. 1.md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, claude-code, claudemd, source, score-B]
---

## Tese central
CLAUDE.md é operating system para como Claude se comporta no codebase — não prompt, não preference list. 12 rules updated para mid-2026 ecosystem. Compliance ~80% sob 200 lines; past 200 drops sharply. Original 4 rules (Karpathy complaint → Forrest Chang repo, 120K stars) são start point mas insuficiente.

## Key insights
- CLAUDE.md advisory: ~80% compliance under 200 lines, drops sharply past 200
- 3 wrong approaches: bloat (>4K tokens, 30% compliance), skip (5x token waste), paste-once-forget (silently breaks)
- Original 4 rules from Karpathy complaint: don't assume (ask), don't overbuild, don't touch unasked code, +1

## Links
- [[03-RESOURCES/concepts/claude-code-tooling/claude-md-behavioral-contract]]
- [[03-RESOURCES/concepts/claude-code-tooling/claudemd-self-improvement-loop]]
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
- [[03-RESOURCES/entities/Forrest-Chang]]