---
title: "Obsidian + Kimi K2.6 turned my 7,000 notes into a $15,000month research system"
type: source
category: pkm-obsidian-second-brain
source: "https://x.com/noisyb0y1/status/2066856811404087519"
created: 2026-06-16
ingested: 2026-06-16
tags: [pkm, obsidian, research-system, monetization]
---

# Obsidian + Kimi K2.6 turned my 7,000 notes into a $15,000month research system

## Tese Central

Obsidian + LLM integration can turn a personal knowledge base into a revenue-generating research system: the vault provides context, the model provides synthesis, and the output provides value.

---

## Conteudo Original

![Image](https://pbs.twimg.com/media/HJ_Xmx6WAAAigY5?format=jpg&name=large)

There are people making $10,000-40,000 a month in consulting and product work - and their main advantage isn't that they're smarter or work longer hours. It's that their knowledge works while they sleep, and a vault with thousands of notes connected to Kimi Agent Swarm returns in a single run what would take another person several days to produce manually.

The problem every person faces who tries to stay on top of their field looks the same regardless of what you do. You consume a ton of content - reading articles, watching videos, downloading PDFs, jotting down ideas on the go - and a year later hundreds of saved materials sit as dead weight you'll never return to. Information without a system that actively works with it is just digital clutter that grows bigger every year.

Obsidian solves storage. Kimi K2.6 turns what you've accumulated into opportunities. Together they do what most people consider impossible for one person without a team.

```text
ChatGPT remembers one conversation - then forgets everything.
Obsidian remembers years - but does nothing on its own.
Kimi K2.6 works on top of those years - and turns them into action.
```

**What Obsidian is in 30 seconds**

Obsidian is a free note-taking app where every note is a plain markdown file on your disk - not in some company's cloud, just text files in folders that stay with you forever. That collection of files is called a vault and more than six million people use this approach because your knowledge belongs to you and doesn't disappear with a subscription.

![Image](https://pbs.twimg.com/media/HJ_dg0-XMAAbBo-?format=jpg&name=large)

Most AI has a fundamental problem. When a chat ends, the knowledge stays inside the context window - and disappears with it. In Obsidian everything works differently.

```text
Article
↓
Note
↓
Vault
↓
Kimi Analysis
↓
New Insight
↓
New Note
↓
Vault grows
```

Every new idea returns back into the system. So a vault doesn't just accumulate information - it accumulates the results of your own thinking. And that's exactly what makes it the ideal foundation for Kimi K2.6.

But here's where most people stop and lose the main advantage. They accumulate notes - and that's it. Ten thousand notes without a system that activates them isn't an asset, it's even more chaos than a hundred notes. A vault on its own generates nothing - it just stores. And that's exactly where Kimi K2.6 comes in.

**Case 1 - Entrepreneur: years of reading become a list of opportunities**

Imagine an entrepreneur who spends five years reading books, saving articles, listening to podcasts and writing down ideas. Seven thousand notes have accumulated and somewhere in there is a business idea he returned to twenty times - but he doesn't remember where exactly and never saw the pattern because nobody manually reviews seven thousand notes.

One prompt changes this completely:

```text
Analyze my entire vault.

Find:
- repeated startup ideas
- recurring business opportunities
- markets I mention more than 10 times
- unsolved problems I keep returning to
- ideas that connect across multiple domains

Generate:
- top 20 opportunities ranked by how often they recur
- why I repeatedly return to each one
- which ideas have the strongest signal across my notes
```

Kimi moves through the entire vault in parallel through Agent Swarm and returns what the person would never have seen themselves - patterns across thousands of notes, connections between ideas from different years, markets they subconsciously return to again and again. Research that used to take weeks or simply never happened takes one run.

Consultants charge $5,000-15,000 for market opportunity reports. Yours already exists inside your vault - you just needed a system to surface it.

**Case 2 - Student: vault becomes a personal teacher**

A student accumulates lectures, papers and notes over years of studying that also turn into dead weight - going through everything before an exam is impossible, and figuring out exactly where the knowledge gaps are is even harder to do on your own.

```text
Go through all my lecture notes and research papers.

Find:
- concepts I wrote about but explained incompletely
- topics where my notes contradict each other
- knowledge gaps between connected subjects

Then:
- create a personalized learning roadmap
- generate practice questions from my own notes
- explain my weakest areas using examples
  from my own writing
```

Tests and explanations are generated from the student's own notes rather than the model's general knowledge. Kimi teaches you what you actually studied, in your own context, and finds exactly your gaps - what a tutor would do for $50-100 an hour the vault does for cents in API costs.

**Case 3 - Company: buried knowledge becomes strategy**

In any company over a few years thousands of documents accumulate - meeting notes, customer feedback, support tickets, roadmaps. Nobody remembers what's in there and the most valuable insights sit buried in documents from past quarters that nobody will ever open again.

```text
Analyze our entire knowledge base.

Find:
- customer complaints that repeat across multiple sources
- product requests mentioned more than 20 times
- problems competitors consistently fail to solve
- patterns in feedback from churned customers
- opportunities we discussed but never acted on

Deliver:
- strategic report with prioritized opportunities
- evidence from actual documents for each finding
- which findings have the strongest data support
```

Every finding is backed by real documents from the base rather than invented by the model. Companies pay consultants $20,000-50,000 for strategic analysis that takes weeks - the same analysis based on the company's internal knowledge takes one run and gives an answer grounded in real data rather than general recommendations from an outside consultant seeing the business for the first time.

**How to connect your vault to Kimi - the mechanics**

First step - install the Smart Connections plugin in Obsidian (4,700+ stars on GitHub, 786,000+ downloads). It indexes your entire vault through embeddings and finds semantic connections between notes automatically - it sees that two notes are about the same thing even if you never linked them, and turns the knowledge graph from a pretty visualization into a real search mechanism.

```text
{
  "mcpServers": {
    "obsidian": {
      "command": "node",
      "args": ["/path/to/obsidian-mcp/index.js"],
      "env": {
        "OBSIDIAN_VAULT_PATH": "/path/to/your/vault"
      }
    }
  }
}
```

Second step - connect your vault to the agent through an MCP server. There are ready solutions on GitHub - StevenStavrakis/obsidian-mcp, cyanheads/obsidian-mcp-server. The config takes a minute:

<video preload="auto" tabindex="-1" playsinline="" aria-label="Embedded video" poster="https://pbs.twimg.com/tweet_video_thumb/HJ_eR12WMAAFB6o.jpg" src="https://video.twimg.com/tweet_video/HJ_eR12WMAAFB6o.mp4" type="video/mp4" style="width: 100%; height: 100%; position: absolute; background-color: black; top: 0%; left: 0%; transform: rotate(0deg) scale(1.005);"></video>

![](https://pbs.twimg.com/tweet_video_thumb/HJ_eR12WMAAFB6o.jpg?name=large)

GIF

After this the agent sees your entire vault and can read notes, search through them and write new ones. Before, the memory of Claude, ChatGPT and Kimi were three isolated islands - through MCP the vault becomes one shared memory for all agents that doesn't disappear when a session closes.

```text
Before:                       Now:
Claude Memory  - island        Obsidian Vault
ChatGPT Memory - island        ↓ via MCP
Kimi Memory    - island        Claude | Kimi | Gemini
```

Third step - Document to Skill, a feature unique to Kimi K2.6. You upload your best note about how you structure research or analysis - and Kimi captures its structural DNA. Every subsequent piece of research comes out in your format, in your style, with your approach. The more quality notes you convert into skills the less generic the results become and the more they look like your work rather than a templated AI output.

```text
Vault
↓ Document to Skill
Your frameworks become agent skills
↓ Agent Swarm (300 agents, 4,000 steps)
Results in your style - not templated
```

**Why this compounds over time**

This is the most important difference from a regular AI chat that most people don't notice right away. Every result Kimi returns gets saved back into the vault as a new note, and the next research run starts with that new knowledge already in the base. The base gets smarter with every run and the advantage it gives grows over time rather than staying static.

Most people collect information. Very few build systems that turn information into opportunities.

```text
Regular AI chat:
Question -> Answer -> Closed tab -> Forgotten

Vault + Kimi:
Question -> Research based on your knowledge
-> Answer -> Saved to vault
-> Next query starts smarter
```

People who understood this earlier than others are already building something that's hard to catch up to quickly - a vault accumulated over years, skills refined across hundreds of documents, an Agent Swarm that gets more precise with every run because the base underneath it keeps growing. This isn't an advantage that disappears when a new model drops. It's an advantage that compounds over time and gets bigger the longer you build it.

```text
Kimi K2.6 Agent Swarm:
300 parallel agents per single run
4,000 coordinated steps
256K context window - holds your entire vault at once
Output: real files, reports, strategies - not chat responses

Smart Connections:
4,700+ stars on GitHub
786,000+ downloads
Automatic semantic search across your entire vault

Cost to start this system:
Obsidian - free
Smart Connections - free
MCP servers - open source
You only pay for Kimi API usage
```

ChatGPT forgets after every conversation. Your vault remembers years - and now knows how to work with that.

Most people read. A few build. The gap between them is a knowledge base that becomes a more valuable asset every month instead of an archive collecting dust.

**You build your own life - so choose the right path. / If this was useful - follow /**
