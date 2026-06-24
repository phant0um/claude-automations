---
title: "Vercel Flags: Platform-native feature flags"
type: source
source: "Clippings/Vercel Flags Platform-native feature flags.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [concurso, source-page]
---

## Tese central
---
title: "Vercel Flags: Platform-native feature flags"
source: "
author:
  - "[[Malavika Tadeusz]]"
  - "[[Dominik Ferber]]"
published: 2026-06-22
created: 2026-06-23
description: "Vercel Flags is a platform-native feature flag provider built into the Vercel developer platform, server-side by default with zero impact on page performance."
tags:
  - "clippings"
---
At Vercel, feature flags are how we ship. From new features to model updates in v0, and even infrastructure changes like a producti

## Argumentos principais
### What is Vercel Flags
Vercel Flags lets you create feature flags, define targeting rules by user attributes, segments, or environment, run progressive rollouts, and flip kill switches if something breaks in production.
From your code, you read flags through [Flags SDK](), an open-source, provider-agnostic library we maintain with first-class adapters for [Next.js]() and [SvelteKit](). If you are using another framework, you can consume Vercel Flags using the built-in OpenFeature provider.
The [Vercel Flags dashboard]() sits alongside your project and deployments, where you can create and manage flags.

### Why framework-native matters
Other flag providers give you a generic SDK to wire through your framework yourself, and a separate dashboard to manage flags in. Vercel Flags is built into the Vercel platform, so you manage flags in the same dashboard as your deployments, and your code reads them through the framework-native Flags SDK.

### Server-side evaluation
When a flag is evaluated on the client, users see a loader, a flicker, or a layout shift. The browser can't render the correct view until the flag value comes back. The Flags SDK evaluates on the server instead. With Next.js React Server Components, you read the flag with `await` during render. The correct view is determined server-side and the browser renders it directly, with no separate flag request. That value comes from Vercel Flags, where a configuration change propagates to every region within milliseconds.
```tsx
import { showNewFeature } from "@/flags"

### Automatic flag registration
Vercel Flags registers flags automatically. Define one in code, deploy, and it appears in the dashboard as a draft. Promote the draft when you're ready to configure targeting and roll out. Remove the flag from your code and the dashboard marks it as unreferenced, so you always know what's safe to archive. The flags you write are the flags you manage, with no separate list to keep in sync by hand.
```typescript
import { flag } from "flags/next"

### Precompute
Static pages are fast and consistent because they are served from the CDN regions closest to you and your users. But adding a flag makes a page dynamic. Either you render server-side and lose CDN delivery, or you fetch the flag client-side and get layout shift back. However, Flags SDK comes with an optional, advanced pattern that solves this. Precompute lets you build all variants at build time, distribute them through the CDN, and have [Routing Middleware]() (the `proxy.ts` file in Next.js) route each user to the right one. Every page stays static and loads with no layout shift.
**Note:** Precompute is an advanced but powerful pattern. [Read the docs]() to learn more.

### Agent-native flag management
The [`vercel flags`]() CLI exposes the same flag management from your terminal, so you and your coding agents can create flags, configure targeting, run rollouts, and archive them.

### Overriding flags in the browser
[Flags Explorer](), built into the [Vercel Toolbar](), lets you override any flag in your browser session to test a variant. The shared configuration stays untouched and you do not redeploy.

### Vercel ships on Vercel Flags
While [we made Vercel Flags generally available]() in April 2026, we've been using it internally for over a year. The [v0]() team is a good example of what this looks like at scale, with hundreds of flags active at any given moment.
Here are some examples of what teams put behind flags:
- New features under development

### Get started
Once shipping code and releasing a feature are separate stages, you can start to just ship things with a level of confidence that you couldn't get from PRs alone.
[Vercel Flags]() is available on every plan. The [`vercel flags`]() CLI allows you and your agents to create, inspect, manage rollouts, and archive flags from anywhere.
Read the [Vercel Flags documentation]() to get started, or ask your agent for help with the [Flags SDK skill]().


## Key insights
- "[[Malavika Tadeusz]]"
- New features under development
- AI model routing per user or segment
- Operational kill switches
- Database migrations and provider swaps
- Beta access for early customers or internal teams

## Exemplos e evidências
See original source at `Clippings/Vercel Flags Platform-native feature flags.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
