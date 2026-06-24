---
title: "Introducing the Cloudflare One stack- agent-powered deployment"
source: "https://blog.cloudflare.com/cloudflare-one-stack/"
author:
published: 2026-06-17
created: 2026-06-22
description: "The Cloudflare One stack is a library of agent skills that gives any AI agent the knowledge it needs to plan, deploy, and manage a Zero Trust environment — no migration calls required."
tags:
  - "clippings"
---
## Introducing the Cloudflare One stack: agent-powered deployment

This post is also available in [简体中文](https://blog.cloudflare.com/zh-cn/cloudflare-one-stack), [Polski](https://blog.cloudflare.com/pl-pl/cloudflare-one-stack) and [Português](https://blog.cloudflare.com/pt-br/cloudflare-one-stack).

![](https://cf-assets.www.cloudflare.com/zkvhlag99gkb/1rSFTMc6RrcA4Hy9Q4NS8P/74e45c2a0c541ebe6ca59ec8e0f35ff0/Introducing-the-Cloudflare-One-stack--agent-powered-deployment)

Adopting or migrating to a Zero Trust network architecture can be a daunting task. Before a single policy changes, teams have to recall how their network is actually built: which applications exist, their authentication and authorization constructs, how traffic flows between them, and any assumptions the current architecture makes. This hands-on process requires practitioners to decode the intent behind every security and routing policy in place.

Today, we’re releasing the Cloudflare One stack, a [set of skills](https://github.com/cloudflare/skills) you give to your agent to configure, deploy, and manage your Zero Trust environment for you. This toolkit is designed to help automate the process of learning an entirely new security suite and mapping your existing one into Cloudflare.

Cloudflare has worked with thousands of customers through exactly this process. That repetition built expertise on where migrations stall, what questions come up every time, and what it takes to move forward. The Cloudflare One stack packages that expertise and makes it more accessible than ever.

### The agent gap in network security

Teams are already using agents to write code, triage alerts, and automate workflows. Organizations are increasingly asking for Cloudflare-provided tooling to help agents execute on security workflows. On their own, agents are not trained on the nuances of an organization's specific network topology or vendor configurations.

By providing prescriptive and authoritative guidance, organizations can layer this context into their existing toolkit to make better use of the security products they are already deploying.

Cloudflare has long been the easiest-to-deploy SASE vendor in the market. The stack extends that philosophy to agents: it gives them the context, tools, and structured reasoning they need to operate on your security infrastructure.

## What is the Cloudflare One stack?

The Cloudflare One stack is [a collection of skills](https://github.com/cloudflare/skills) that can be used with any agent. As with [any skill](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills), you can use them standalone, layer in your own context, or build tooling on top. It was purpose-built to help security practitioners across the entire lifecycle of evaluating, deploying, and managing [Cloudflare One](https://developers.cloudflare.com/cloudflare-one/).

The stack was built by synthesizing hand-curated knowledge from employees with tens of thousands of hours of experience working with customers on Cloudflare One products. It contains tools for planning, managing, and implementing your user and agent security infrastructure on Cloudflare. It also contains handpicked logic for migrating from legacy vendors like [Zscaler](https://blog.cloudflare.com/descaler-program/) and Palo Alto Networks.

When used in conjunction with the [Cloudflare code mode MCP server](https://developers.cloudflare.com/agents/model-context-protocol/mcp-servers-for-cloudflare/), the stack gives agents a typed interface to the Cloudflare API. Agents can query your live account, inspect configurations, and make changes through a curated set of Cloudflare-recommended workflows rather than ad-hoc API calls.

## What’s in the stack?

The Cloudflare One stack ships as two lightweight skill files: cloudflare-one and cloudflare-one-migration. Together they cover migrating to, building an implementation for, managing, and troubleshooting your Cloudflare One deployment:

- **Remote access and VPN replacement** with Cloudflare Access
- **User, network, device, and data security** with Cloudflare Gateway
- **Connectivity** with Cloudflare Tunnel, Cloudflare Mesh, and Cloudflare WAN
- **Migration guidance** with explicit detail for moving from other SASE vendors
- **Network diagram interpretation and generation**, so you can visualize proposed changes to your network in a way that is easy for you and your team to understand
- **Vendor concept translation**, which maps concepts between SASE vendors to reduce the barrier to evaluating and switching providers
- **Troubleshooting and operations**, with the Digital Experience Monitoring (DEX) toolkit and automated rule recommendations

## How it works

The stack is available in the [Cloudflare Skills](https://github.com/cloudflare/skills) repository. Each skill file contains structured knowledge, decision trees, and tool definitions that agents load automatically when the context matches. Give this to your agent and let it help you set up, configure, and manage your Zero Trust environment:

The cloudflare-one skill covers general product guidance. For example, if you ask an agent for the best way to replace your VPN infrastructure with Cloudflare Tunnel or Cloudflare Mesh, the skill knows how to:

1. Inventory your existing VPN applications and identify which connectivity model each requires
2. Map each application to the appropriate Cloudflare primitive — self-hosted Access application, Tunnel-connected service, or Mesh-connected network segment
3. Generate a recommended deployment sequence that minimizes disruption during cutover
4. Produce a configuration summary your team can review before making any changes

The cloudflare-one-migration skill covers vendor-to-vendor translation. For example, if you ask an agent to migrate your Zscaler Private Access applications to Cloudflare Access, the skill knows how to:

1. Map Zscaler application definitions to Cloudflare Access application definitions
2. Transform Zscaler user groups and policies into Cloudflare Access policies
3. Use the Cloudflare API to create the equivalent resources in your account
4. Generate a summary of what was migrated and what requires manual review

The migration logic in the stack is the same logic used in Cloudflare's [Descaler](https://blog.cloudflare.com/descaler-program/) and [Deskope](https://blog.cloudflare.com/deskope-program-and-asdp-for-descaler/) programs. Those programs have already moved enterprise customers from Zscaler and Netskope to Cloudflare One in hours rather than months. The stack makes that capability available to any customer or partner, at any time, without waiting for a scheduled engagement.

### More ways to use the stack

The Cloudflare One stack can also:

- Recommend security rules based on traffic seen in your live account
- Automatically migrate your existing Zscaler Private Access applications into self-hosted Cloudflare Access applications
- Investigate anomalies in your secure web gateway HTTP logs and build rules to resolve issues users are seeing
- Report on user stability with the DEX toolkit and take actions to improve user latency in key scenarios

Whether you are loading the skill from an agent or building custom tooling on top, the Cloudflare One stack handles all of these use cases and more.

## For partners, too

While this simplifies ongoing management for customers who have already adopted the Cloudflare One product suite, it is also a tool for the Cloudflare partner network. Partners can use it to help their customers deploy faster, manage more effectively, troubleshoot with increased accuracy, and drive issues to resolution.

## What's next

You can start using the Cloudflare One stack today. To get the most out of the stack, pair it with the Cloudflare [code mode MCP server](https://developers.cloudflare.com/cloudflare-one/access-controls/ai-controls/mcp-portals/#code-mode). The MCP server gives your agent live access to the Cloudflare API through a single, compressed interface that keeps authentication credentials out of the model context.

The Cloudflare One stack will continue to expand as Cloudflare One products evolve. New skills for additional migration sources and more advanced troubleshooting workflows are already in development.

As we learn more about how customers and partners utilize these skills files, we plan to build more robust tooling around these skills. If you are a customer or partner and want to share feedback on what the stack should handle next, reach out through your account team or open an issue in the repository.

[Cloudflare One](https://blog.cloudflare.com/tag/cloudflare-one/) [Zero Trust](https://blog.cloudflare.com/tag/zero-trust/) [Agents](https://blog.cloudflare.com/tag/agents/)