---
title: Vercel Skills CLI — Agent Skills Ecosystem
type: source
created: 2026-04-27
updated: 2026-04-27
tags: [agent-skills, cli, vercel, ecosystem]
source_file: .raw/articles/skills.md
---

# Vercel Skills CLI — Open Agent Skills Ecosystem

CLI tool for managing [[Agent Skills]] across 40+ coding agents (OpenCode, Claude Code, Cursor, Codex, etc.). Symlink-based single source of truth.

## Core Commands

**Install**
```bash
npx skills add owner/repo [--global] [--skill name] [-a agent]
```

**List/Update/Remove**
- `npx skills list` — installed skills
- `npx skills find [query]` — interactive search
- `npx skills update [skills]` — sync to latest
- `npx skills remove [skills]` — uninstall

**Create**
```bash
npx skills init [name]  # → SKILL.md template
```

## Installation Scopes

| Scope | Flag | Location | Use |
|-------|------|----------|-----|
| Project | (default) | `.agent/skills/` | Team-shared, version-controlled |
| Global | `-g` | `~/.agent/skills/` | Cross-project access |

**Methods:** Symlink (recommended, single source) vs. Copy (isolated, fallback)

## SKILL.md Format

```markdown
---
name: my-skill
description: What this does
metadata:
  internal: false  # hide from discovery if true
---

# My Skill

Instructions for agent use.

## When to Use
Scenarios where applicable.

## Steps
1. First
2. Then
```

Required: `name`, `description`

## Supported Agents (40+)

Claude Code, OpenCode, Cursor, Cline, Codex, Cursor, GitHub Copilot, VS Code Copilot, Continue, OpenHands, Roo Code, etc.

Compatibility table varies: basic skills = all; `allowed-tools` = 30+; `context: fork`, Hooks = Claude Code only.

## Skill Discovery Paths

Priority:
1. Root SKILL.md
2. `skills/`, `skills/.curated/`, `skills/.experimental/`, `skills/.system/`
3. Agent-specific: `.claude/skills/`, `.cursor/skills/`, etc.
4. Plugin manifest: `.claude-plugin/marketplace.json`
5. Recursive fallback

## Spec & Community

- **Spec:** [[Agent Skills Specification]] (agentskills.io)
- **Registry:** skills.sh
- **GitHub:** vercel-labs/agent-skills

---

**Author:** Vercel Labs  
**License:** MIT  
**Key Insight:** Reusable instruction sets for agents, with cross-platform compatibility and CLI-driven installation.
