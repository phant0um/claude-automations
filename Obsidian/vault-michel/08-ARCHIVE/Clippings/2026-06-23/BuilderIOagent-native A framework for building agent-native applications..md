---
title: "BuilderIO/agent-native: A framework for building agent-native applications."
source: "https://github.com/BuilderIO/agent-native"
author:
published:
created: 2026-06-22
description: "A framework for building agent-native applications. - BuilderIO/agent-native"
tags:
  - "clippings"
---
## Agent-Native

## The framework for agent-native apps

Agent-Native is an open-source framework for building robust agents that act inside real apps, not just chat next to them. It gives you primitives for product-grade agentic software: shared actions, SQL-backed state, identity, tools, skills, jobs, observability, and UI surfaces that all work together. Bring your own database, hosting provider, model stack, and app code.

```
// One action powers UI, agent, HTTP, MCP, A2A, and CLI.
export default defineAction({
  schema: z.object({
    emailId: z.string(),
    body: z.string(),
  }),
  run: async ({ emailId, body }) => {
    await db.insert(replies).values({ emailId, body });
  },
});
```
- **Actions**: Define work once. Use it from UI, agent, API, MCP, A2A, and CLI.
- **Agent runtime**: Chat, tools, skills, memory, jobs, observability, and handoffs ship together.
- **Backend agnostic**: Plug in any Drizzle-supported SQL database and Nitro-compatible host.

## Agents and UIs, Fully Connected

The agent and the UI are equal citizens of one system. Every action works both ways: click it or ask for it.

[![Agents and UIs fully connected](https://camo.githubusercontent.com/aa9d699f575f21916411b9080da9be0ee71aa1d7716c48228738249fd7781032/68747470733a2f2f63646e2e6275696c6465722e696f2f6170692f76312f66696c652f617373657473253246594a494762346930316a7677305352644c3542742532466164633165396539333638653461386362316234646262356161653561616132)](https://camo.githubusercontent.com/aa9d699f575f21916411b9080da9be0ee71aa1d7716c48228738249fd7781032/68747470733a2f2f63646e2e6275696c6465722e696f2f6170692f76312f66696c652f617373657473253246594a494762346930316a7677305352644c3542742532466164633165396539333638653461386362316234646262356161653561616132)

- **Everything syncs**: One database, one state. Changes from either side show up instantly on the other.
- **Real-time multiplayer**: Humans and agents edit the same document together, with the agent as a first-class peer.
- **Context-aware**: The agent knows what you're looking at. Select text, hit Cmd+I, and tell it what to do.
- **Agents call agents**: Tag another agent from any app and they coordinate over A2A.
- **Self-improving**: The agent can add features, fix bugs, and refine the UI over time.

## Templates

Start with a full featured template. Each one is a complete, 100% free and open-source SaaS app: cloneable, not scaffolded, except you own the code and can customize everything.

| **Calendar**  [![Calendar template](https://camo.githubusercontent.com/953ba6ad4e96227b4fa5c78a5612e0cd1370bf997102213edbb8e8adfbd85c86/68747470733a2f2f63646e2e6275696c6465722e696f2f6170692f76312f696d6167652f617373657473253246594a494762346930316a7677305352644c35427425324666623663336234383363613234616233623663336137353861656365656634633f666f726d61743d776562702677696474683d383030)](https://agent-native.com/templates/calendar)  **Agent-Native Google Calendar, Calendly**  Manage events, sync with Google Calendar, and share a public booking page with AI scheduling. | **Content**  [![Content template](https://camo.githubusercontent.com/901af4ee5646656527b17f5ddb4aeaa55328e2b62ffe5b8356748c14c10d2278/68747470733a2f2f63646e2e6275696c6465722e696f2f6170692f76312f696d6167652f617373657473253246594a494762346930316a7677305352644c35427425324638396263666336313036333034626662616638656338613763636437323165623f666f726d61743d776562702677696474683d383030)](https://agent-native.com/templates/content)  **Open-source Obsidian for MDX**  Edit local Markdown/MDX files, generate rich interactive custom blocks, and draft, rewrite, or publish with an agent. | **Plans**  [![Plans template](https://camo.githubusercontent.com/3f879b3310441000ae88f02e6ea62af44f210dd7e78c6c093c6a8699f973bf02/68747470733a2f2f63646e2e6275696c6465722e696f2f6170692f76312f696d6167652f617373657473253246594a494762346930316a7677305352644c35427425324662366634323133616337636334326565623130633132653863636461383933363f666f726d61743d776562702677696474683d383030)](https://agent-native.com/templates/plan)  **Visual plan mode for coding agents**  Install `/visual-plan` and `/visual-recap` so your coding agent can plan before it builds and recap changes after they land. High-level code reviews with diagrams, wireframes, annotations, and review links. |
| --- | --- | --- |
| **Slides**  [![Slides template](https://camo.githubusercontent.com/00ca4570f3cde1e1c3398819a0f0f1cb71c7a9fa9d4ad14158906205fa2668c4/68747470733a2f2f63646e2e6275696c6465722e696f2f6170692f76312f696d6167652f617373657473253246594a494762346930316a7677305352644c35427425324632633039623435316434306334613734613839613338643639313730633264383f666f726d61743d776562702677696474683d383030)](https://agent-native.com/templates/slides)  **Agent-Native Google Slides, Pitch**  Generate and edit React-based presentations via prompt or point-and-click. | **Analytics**  [![Analytics template](https://camo.githubusercontent.com/0f05a5deb67fe23b1d5bdf1e77096cc31e7f9f69164d9c33a0f3f34c4e33505d/68747470733a2f2f63646e2e6275696c6465722e696f2f6170692f76312f696d6167652f617373657473253246594a494762346930316a7677305352644c35427425324634393333613830636333313334643765383734363331663638386265383238613f666f726d61743d776562702677696474683d383030)](https://agent-native.com/templates/analytics)  **Agent-Native Amplitude, Mixpanel**  Connect analytics data sources, prompt for real charts, and build reusable dashboards. | **Clips**  [![Clips template](https://camo.githubusercontent.com/860291d0c9bb6a28387840d4da31ddc114fa8fe35c2c55c5dbd67e571c158d0b/68747470733a2f2f63646e2e6275696c6465722e696f2f6170692f76312f696d6167652f617373657473253246594a494762346930316a7677305352644c35427425324636373862653561353031613134616238613530386535663762633932633436383f666f726d61743d776562702677696474683d383030)](https://agent-native.com/templates/clips)  **Agent-Native Loom**  Record your screen with auto-transcripts, shareable links, and an agent that summarizes, captions, and edits clips on demand. |

View the full template gallery at **[agent-native.com/templates](https://agent-native.com/templates)**.

## Try it with a skill

Don't want to scaffold a whole app yet? Add visual planning and PR recaps to Claude Code, Codex, Cursor, Pi, OpenCode, GitHub Copilot / VS Code, and similar agents with one command:

```
npx @agent-native/core@latest skills add visual-plan
```

![Visual plan and recap in action](https://raw.githubusercontent.com/builderio/skills/main/media/visual-recap.gif)

Visual plan and recap in action

You get two slash commands:

- **`/visual-plan`**: before the agent writes code, it opens a structured, reviewable plan with inline diagrams, UI wireframes, file-by-file implementation maps, and annotations you can comment on and approve.
- **`/visual-recap`**: after changes land, it turns a PR or git diff into a high-altitude visual recap with a shareable review link instead of a raw diff.

See the **[Skills Guide](https://agent-native.com/docs/skills-guide#app-backed-skills)** for more.

## Quick Start

One command to start a new project locally.

```
npx @agent-native/core@latest create my-app
cd my-app
pnpm install
pnpm dev
```

`create` first asks how you want to start:

- **Full template(s)**: clone one or more complete apps into a workspace. Pick Mail + Calendar + Forms and you get all three wired up and sharing auth.
- **Chat**: a single app with a minimal chat UI and the browser shell already wired, the simplest way to get a UI.
- **Headless**: a single action-first app with no UI shell. The CLI walks you through calling your first action and agent, and you can add a UI later.

Prefer flags? `create my-app --template mail`, `--headless`, or `--standalone` skip the prompt.

## The Best of Both Worlds

|  | SaaS Tools | Raw AI Agents | Internal Tools | Agent-Native |
| --- | --- | --- | --- | --- |
| **UI** | Polished but rigid | None | Mixed quality | Full UI, fork & go |
| **AI** | Bolted on | Powerful | Shallowly connected | Agent-first, integrated |
| **Customization** | Can't | Instructions and skills | Full, but high maintenance | Agent modifies the app |
| **Ownership** | Rented | Somewhat yours | You own the code | You own the code |