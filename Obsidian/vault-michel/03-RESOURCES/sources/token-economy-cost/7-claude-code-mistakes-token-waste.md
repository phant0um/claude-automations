---
title: "The 7 Claude Code Mistakes That Mass Waste Your Tokens"
type: source
author: "@zodchiii"
source: "https://x.com/zodchiii/status/2054492434831135095"
published: 2026-05-13
ingested: 2026-05-14
tags: [claude-code, token-economy, mcp, hooks, context-management, subagents, clippings]
triagem_score: 9
---

# The 7 Claude Code Mistakes That Mass Waste Your Tokens

**Author:** [[@zodchiii]]
**Published:** 2026-05-13

## Summary

Thread enumerating 7 patterns that cause silent, compounding token waste in Claude Code sessions. Core insight: Claude resends the entire conversation history on every turn — a 30-message session burns 232k tokens. Most users attribute degraded quality to the model itself, but the culprit is a bloated setup consuming tokens before the first prompt lands.

Tracked real-world result: 63% reduction in token usage from applying all 7 fixes simultaneously.

## The 7 Mistakes

### 1. Using Opus for everything
Opus costs 5x more per token than Sonnet. Most coding tasks don't need deep reasoning. Default to Sonnet; switch to Opus only for complex architecture or multi-file debugging; use Haiku for throwaway questions. For subagents:
```
export CLAUDE_CODE_SUBAGENT_MODEL="claude-sonnet-4-5-20250929"
```

### 2. Never running /compact (or too late)
Autocompact triggers at ~95% by default — by then the session is already bloated. Set trigger at 70% for normal work, 50% for noisy workflows (log analysis, debugging). Use custom compact instructions to preserve what matters:
```
/compact preserve architecture decisions, files changed, failing tests, and next steps
```
Rule: compact when the productive part of the conversation is clear, not when Claude starts forgetting.

### 3. MCP servers loaded that you're not using
Every connected MCP server loads full tool definitions into context on every turn. Some servers add **18,000+ tokens** just by being connected. 5 servers = ~90k tokens overhead per turn before the first prompt. Run `/mcp` and remove anything not actively in use. One developer found **160 registered skills eating ~25k tokens per call**. Another had a system prompt bloated to 607k tokens from accumulated plugins. Vercel found skills never invoked in 56% of test cases.

### 4. No preprocessing hooks for large files
Claude reading a 10,000-line log file costs thousands of tokens. A `PreToolUse` hook filters before Claude sees it:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash(cat *log*)",
      "hooks": [{
        "type": "command",
        "command": "grep -n 'ERROR\\|WARN' $file | head -50"
      }]
    }]
  }
}
```

Claude sees 50 relevant lines instead of 10,000 — **99.5% token reduction** on log analysis.

### 5. Subagent fan-out on simple tasks
Agent teams use ~7x more tokens than standard sessions. Each subagent runs as a separate Claude instance with its own context window.

| Task | Approach |
|------|----------|
| Simple bug fix | Single session, no agents |
| Code review | 2–3 focused subagents |
| Large refactor across files | Agent team justified |
| "Improve this codebase" | Never — too vague, infinite burn |

Vague requests trigger broad scanning. Specific requests like "add input validation to the login function in auth.ts" let Claude work efficiently with minimal file reads.

### 6. Re-explaining your project every session
Without CLAUDE.md and /memory, first 3–5 messages = 3,000–5,000 wasted tokens per session on setup. Fix:
```
/init            → generate CLAUDE.md from your project
/memory add "…"  → persist facts between sessions
```
Warning: keep CLAUDE.md lean. A 5,000-token CLAUDE.md costs 5,000 tokens every turn.

### 7. Not clearing between tasks
Finishing a debug session and starting a new feature in the same chat carries all debug context forward — error logs, stack traces, wrong approaches — into every subsequent message.
```
/clear    → clean slate (switching tasks completely)
/compact  → summarize and continue (staying on same task)
```
Rule: **new task = new chat. No exceptions.**

## The Math

| Metric | Before | After |
|--------|--------|-------|
| Average session | 230,000 tokens | 85,000 tokens |
| Model | Opus everywhere (5x) | Sonnet for 80% |
| MCP overhead | 5 servers ~90k/turn | 2 servers ~20k/turn |
| Log analysis | 10k+ tokens/file | 50 tokens/file |
| Project re-explanation | 5k tokens/session | 0 (CLAUDE.md + /memory) |
| **Total reduction** | | **~63%** |

## One-Minute Fix

1. `/model sonnet` — switch default model
2. `/mcp` — remove unused servers
3. Add the log-filter `PreToolUse` hook to `settings.json`

## Related Concepts
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — PreToolUse log filter pattern (Mistake 4)
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — 18k+ tokens per server loaded
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] — why /compact timing matters
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — fat skills + thin harness philosophy
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — when subagent fan-out costs vs saves

## Related Sources
- [[03-RESOURCES/sources/ai-agents-harness/claude-code-agents-zodchiii]] — other zodchiii thread on agents
- [[03-RESOURCES/sources/token-economy-cost/clipping-17-token-saving-techniques]] — complementary token reduction techniques
- [[03-RESOURCES/sources/token-economy-cost/fix-claude-code-rate-limits-quality]] — /compact, model switching strategies
