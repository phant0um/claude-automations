---
title: "How to Build an AI Second Brain With Claude and Obsidian (Full Guide) He's getting smarter every da"
source: "https://x.com/0xclayn/status/2069109138861211801"
author:
  - "[[@0xclayn]]"
published: 2026-06-22
created: 2026-06-22
description: "Here is the rewritten version of the hook/intro:Your best ideas are currently bleeding out across a dozen different places. Buried in random..."
tags:
  - "clippings"
---
![Image](https://pbs.twimg.com/media/HLbzgRHWwAAg2GT?format=jpg&name=large)

## Here is the rewritten version of the hook/intro:

Your best ideas are currently bleeding out across a dozen different places. Buried in random notes apps, lost in open browser tabs, or trapped in closed AI chats you’ll never find again. Every time you sit down to work, you’re wasting energy rebuilding context from scratch.

**A "Second Brain" fixes this entirely.**

Imagine a single, unified knowledge base with an AI sitting on top of it—reading, connecting, and expanding your thoughts. No more re-explaining yourself at the start of every session. The system already knows everything. You just ask, and it retrieves answers from your entire digital footprint.

This is the **LLM Wiki** pattern that Andrej Karpathy popularized in April 2026. While standard chat histories decay into useless noise, this setup actually gets sharper every single day you use it. And it only takes an evening to build.

Here is the ultimate, step-by-step walkthrough. Even if you’ve never touched Obsidian or Claude Code, you’ll be able to set this up. Every single click and command is mapped out below.

![Image](https://pbs.twimg.com/media/HLbvf1jWkAELbEF?format=jpg&name=large)

## What We Are Actually Building

**Two specific tools, two distinct jobs:**

- **Obsidian is the Vault.** A free, local notes app that keeps everything as plain text files directly on your computer. Your notes link to each other, creating a visual graph of how your ideas connect over time. Because it lives on your machine and not in a corporate cloud, you own your data forever.
- **Claude is the Brain.** Sitting directly on top of your vault, the AI reads your entire knowledge base. It files new information where it belongs, creates smart links to existing notes, and synthesizes answers across your whole history.

The beauty of this setup? The entire thing is just raw text files. You aren't locked into a single AI ecosystem. If a better model comes out next year, you just point it at the same folder. You own the infrastructure, not the tool.

## Step 1: Install & Set Up Claude Desktop

1. Head over to \[[claude.com/download](https://claude.com/download)\]([https://claude.com/download](https://claude.com/download)) and grab the desktop app for Windows or Mac. Run the setup and log in.
2. Ensure you are on a paid tier (Pro is **$20/month**), as the free version won’t support the necessary features.
3. Look at the top menu and select the **Code** tab. This launches **Claude Code-**the specific environment capable of interacting with your local file system.

## Step 2: Spin Up Your Obsidian Vault

1. Go to obsidian.md, download the app for free, and open it.
2. Select **Create new vault** on the startup screen. Name it something simple like brain, choose a local directory to host it, and hit create. This directory is your new local database.
3. Test the core mechanic: create a quick note, type a sentence, and use double brackets to link a word, like \[\[goals\]\]. This creates an internal link. Later on, Claude will handle this link generation automatically.

## Step 3: Open the Connection Inside Obsidian

**To allow Claude to communicate with your vault, you need to open a local gateway using a plugin:**

1. In Obsidian, click the **Settings gear** (bottom left) -> **Community plugins** -> **Turn on community plugins**.
2. Click **Browse**, search for **Local REST API**, then install and enable it.
3. Open the **Local REST API** settings from your installed list. You’ll see a long string of characters called the **API Key**. Copy this key and keep it handy for the next phase.

## Step 4: Bridge Claude to Your Vault

Now, we wire Claude to your local directory using MCP (Model Context Protocol).

1. Go back to your **Claude Code** tab.
2. Paste the command below into the prompt line. Make sure to replace PASTE-YOUR-KEY-HERE with the API key you copied from Obsidian.

```text
claude mcp add-json obsidian-vault '{ "type": "stdio", "command": "uvx", "args": ["mcp-obsidian"], "env": { "OBSIDIAN_API_KEY": "PASTE-YOUR-KEY-HERE", "OBSIDIAN_HOST": "127.0.0.1", "OBSIDIAN_PORT": "27124" } }'
```

> **Crucial Detail:** When copying the key from Obsidian, do not include the word "Bearer" if it appears in front of it. Paste **only** the string of letters and numbers.

**Test the connection:** Once the command runs, ask Claude: "List every file in my Obsidian vault." If Claude spits back your test notes, you’re officially live. If it throws an error, double-check that Obsidian is still running in the background and that the plugin is fully enabled.

## Step 5: Initialize Your Identity

An empty database is useless. Instead of manually writing your bio, let Claude interview you to build your profile.

**In your Claude panel, paste this prompt:**

> "You are setting up my second brain. Interview me ONE question at a time to build my profile. Ask about: who I am/what I do, my goals for this year, how I want you to talk to me, my strengths/weaknesses, and my current projects. Wait for each answer before the next question. When finished, write everything into a file called CLAUDE.md at the vault root, structured with headers, so you load it automatically every session."

Answer honestly, like you're briefing a new co-founder. Once finished, Claude saves this file to your root directory. From this point on, your core context is locked in-you will never have to re-explain yourself.

## Step 6: Scaffold Your Projects

Your root CLAUDE.md is the strategy layer. Real work happens inside dedicated project folders, keeping Claude focused on one specific job at a time without mixing up your data.

**Tell Claude to build your workspace pipeline (swap youtube-channel with your actual project):**

> "Create a project folder in my vault called youtube-channel. Inside it, create four folders: Inputs, Process, Outputs, Feedback. Then write a CLAUDE.md inside that project folder describing what this project is, its primary goal, and your specific role in helping me hit it. Interview me if you need details."

**This creates a clean, automated pipeline:**

- **Inputs:** Raw ideas & assets
- **Process:** Active drafting/coding
- **Outputs:** Finished, ready-to-ship work
- **Feedback:** Results, metrics, and data

## Step 7: Scope Down Your Focus

To keep Claude operating at peak sharpness, avoid working out of your giant main vault. Scope Claude down so it only sees the immediate task at hand.

1. In Obsidian, click your vault name (bottom left).
2. Select **Manage vaults** → **Open folder as a vault**.
3. Choose your specific project folder (e.g., youtube-channel) and click **Trust**.

Now, Claude reads only that project's sub-CLAUDE.md. The macro-vault handles your high-level planning; the micro-vault is where you execute and ship.

## Step 8: Program Reusable "Skills"

A skill is a saved, repeatable workflow that Claude executes on command. If you do a task more than once, automate it. Inside your project vault, paste:

> "I want to turn this into a reusable skill. Here is how I do \[insert your task\], with an example: \[paste your steps or example text\]. Save this as a markdown skill file inside this project's skills folder, with a clear name and a description of when to trigger it."

Moving forward, you don't need to give long instructions. Just say: "Run the \[name\] skill on this data," and Claude executes your exact workflow instantly. Build them for client onboarding, content creation, script drafting, or financial sorting.

## Step 9: Wire in Live Data (Calendar & Email)

Static data is only half a brain. To make it dynamic, plug in real-time updates. Want to link your Google Calendar? Drop this command into your Claude Code terminal:

```text
claude mcp add google-workspace uvx workspace-mcp --tools calendar
```

Follow the secure Google OAuth prompt to grant access. Now you can run automations like: "Check my schedule for today, extract the action items from each meeting into my tasks folder, and flag any blocker without a clear next step."

> **The Golden Rule of AI Safety:** Control access at the permission level, never through text. Telling an AI agent "don't delete this" is just a suggestion. If the API key permits deletion, assume an error will eventually happen. Always use **read-only** and tightly scoped keys.

## Step 10: Put It on Autopilot

Once your skills are defined, schedule them so the system maintains itself while you sleep. Inside Claude Desktop, navigate to the **Schedule** tab in the sidebar, hit **\+ New task**, and configure it:

- **Frequency:** Daily, 7:00 AM
- **Folder:** Your main vault directory
- **Prompt:** "Scan the vault. Process any new items sitting in the Inputs folders, move them to the correct directory, and link them to existing concepts. Flag notes that require updating and write a brief 3-line summary of what changed overnight."

You’ll wake up every morning to a database that literally organized itself.

## Bonus: Skip the Grind with Ready-Made Repos

**If you want to bypass the manual setup, the open-source community has already packaged this framework. Search GitHub for these high-value starters:**

- claude-obsidian by **AgriciDaniel**: Built explicitly around the Karpathy wiki pattern. It auto-scaffolds the vault structure and includes environment presets tailored for creators, builders, and executives.
- obsidian-second-brain by **eugeniughelbur**: Packs over 40 native slash-commands (like /obsidian-save or /obsidian-find) and works flawlessly across Claude, Codex, and Gemini.
- second-brain-starter by **coleam00**: An end-to-end Python/Obsidian framework that interviews you, designs a custom workflow, and generates your setup automatically.

## The Reality Shift

- **Before this:** Claude completely forgets you the second you close the tab. Every session starts cold. You waste cognitive energy manually feeding context to a chat box.
- **After this:** Claude possesses a permanent memory of your business, thoughts, and strategy. You have a local vault you fully control, an AI that picks up exactly where it left off, and a knowledge graph that scales while you sleep.

**It’s the exact same monthly AI subscription-but a fundamentally superior machine.**

**You aren't just adjusting a chat tool; you’re building your own cognitive infrastructure. And because it's built on raw text, it belongs to you forever.**

**Almost everyone will read this guide and do absolutely nothing. But the few who take action today will open their knowledge graph a month from now and realize it remembers critical connections they completely forgot. You will never go back to an empty prompt box again.**

**If this breakdown brought you value, click follow for more deep dives on leveraging AI, system architectures, and frameworks that scale.**

<video preload="auto" tabindex="-1" playsinline="" aria-label="Embedded video" poster="https://pbs.twimg.com/tweet_video_thumb/HLbzmAlWoAA5Lhm.jpg" src="https://video.twimg.com/tweet_video/HLbzmAlWoAA5Lhm.mp4" type="video/mp4" style="width: 100%; height: 100%; position: absolute; background-color: black; top: 0%; left: 0%; transform: rotate(0deg) scale(1.005);"></video>

![](https://pbs.twimg.com/tweet_video_thumb/HLbzmAlWoAA5Lhm.jpg?name=large)

GIF