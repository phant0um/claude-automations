---
title: "X Thread — Fullstack Agent System"
status: ready
created: 2026-05-14
---

# X Thread Draft — Fullstack Agent System

---

**[1/8]**
I built a complete dev team with 6 AI agents.

This isn't a chatbot that answers questions.
It's a team of senior engineers that thinks, writes real code, and runs tests.

Thread on how it works 🧵

---

**[2/8]**
The system has 6 members:

🎯 Maestro — breaks down and delegates (plans only, never codes)
⚙️ Stratum — APIs, DB, microservices
🎨 Facet — React/Vue, accessibility, performance
☁️ Bastion — AWS, Terraform, CI/CD, K8s
🧠 Neuron — ML, ETL, LLMs, RAG systems
🔴 Sentinel — security review with veto power

---

**[3/8]**
The biggest mistake in multi-agent systems is letting the Orchestrator do everything.

Here Maestro is "thin" — it only plans and delegates.
The specialists are "thick" — code, tests, evidence.

No agent ships a deliverable without:
✅ Code
✅ Running tests
✅ Execution log

---

**[4/8]**
Model routing by task type:

🔴 Opus 4.7 → architectural decisions, threat modeling, RAG design
🟡 Sonnet 4.6 → code implementation, technical analysis
🟢 Haiku 4.5 → unit tests, YAML, docs, configs

Result: ~60–75% savings vs. using Opus for everything.

---

**[5/8]**
Coordination via File-as-Bus — not via conversation history.

State in `progress.md`.
Artifacts in `workspace/`.
Evidence in `docs/logs/`.

Each agent reads what it needs, writes where defined.
Minimal context, maximum quality.

---

**[6/8]**
The system has a Constitution — 6 principles that govern all agents:

1. Evidence before code
2. Security by default
3. Tests are not optional
4. Closed scope by default
5. Fail early, fail visibly
6. The system improves every cycle

Sentinel has technical veto over any deploy.

---

**[7/8]**
How to use with Claude Code:

```bash
# Activate the full team (global)
cp Orchestrator.md ~/.claude/CLAUDE.md

# Or activate a specialist per project
cp Backend-Dev.md ./CLAUDE.md   # API repo (Stratum)
cp Infra-Cloud.md ./CLAUDE.md   # infra repo (Bastion)
```

Conditional rules by path: `.claude/rules/*.md`

---

**[8/8]**
Full system on GitHub:
→ github.com/mchlcs/fullstack-agent

Includes:
📁 6 agent prompts (YAML frontmatter format)
📋 System Constitution
🗺️ Model map by activity
📐 ADR template
📊 progress.md (File-as-Bus)

Based on: Nexus, AiScientist, AHE.

---

*Notes:*
- URL confirmed: github.com/mchlcs/fullstack-agent ✅
- Tweet 8: add README screenshot if available
- Consider splitting into 2 threads: technical (devs) and outcome (builders)
