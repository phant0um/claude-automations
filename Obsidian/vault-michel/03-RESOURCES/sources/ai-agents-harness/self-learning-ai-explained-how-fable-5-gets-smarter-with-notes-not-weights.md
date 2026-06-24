---
title: "Self-Learning AI, explained how Fable 5 gets smarter with notes, not weights"
type: source
category: ai-agents-harness
source: "https://x.com/rryssf/status/2065451210019102945"
created: 2026-06-16
ingested: 2026-06-16
tags: [fable-5, self-learning, notes-not-weights, arxiv]
---

# Self-Learning AI, explained how Fable 5 gets smarter with notes, not weights

## Tese Central

Fable 5 demonstrates self-learning through notes rather than weight updates: models can get better without anyone touching their weights, by accumulating experiential notes as context.

---

## Conteudo Original

![Image](https://pbs.twimg.com/media/HKnyiowXUAAZm-W?format=jpg&name=large)

Last october, two research papers argued something that sounded almost too convenient: models can get better without anyone touching their weights. they just need to write down what worked, keep the notes, and read them back next run.

on june 9, anthropic shipped claude fable 5. the anouncement describes it in one line that should sound very familiar: it "improves its outputs using its own notes."

![Image](https://pbs.twimg.com/media/HKn0SRPWQAAsBiE?format=jpg&name=large)

Fable 5 stays focused across millions of tokens in long-running tasks and improves its outputs using its own notes.

the thesis just became a product. here's what that actually means, and where it breaks.

**the mechanism, in 60 seconds**

for a decade "the model learned" meant gradient descent. run examples, update billions of parameters, ship a new checkpoint. slow, expensive, and global: teach the model one new thing and it can quietly forget an old one. that failure has a name, catastrophic forgetting.

the new pattern keeps the model frozen. what changes is the context it reads before answering. the model writes down what worked, what broke, and why. next run, it reads the notes back. the intelligence stacks up in the notes, not the weights.

notes have properties weights never will: you can read them, you can version them, and a bad lesson is a line you delete instead of a retraining run.

**the two papers that proved it**

ACE, from stanford, sambanova, and berkeley (arxiv 2510.04618, accepted to iclr 2026). it treats the prompt as an evolving playbook. three roles run in a loop: a generator attempts the task, a reflector reads the outcome and extracts the lesson, a curator merges that lesson into the playbook as a small delta update, never a full rewrite. each failure becomes a strategy. each success becomes a rule.

reported gains: +10.6% on agent tasks, +8.6% on finance reasoning. zero weight updates, no labeled data, just the model learning from its own execution feedback.

training-free grpo, from tencent (arxiv 2510.08191). this one reads like a magic trick. grpo is reinforcement learning: generate a group of attempts, score them, move the weights toward the winners. tencent kept the comparison and deleted the gradient. the model explains in plain language why the winning attempt won, and that explanation, the "semantic advantage," gets distilled into a token prior injected at api-call time.

on deepseek-v3.1-terminus: aime24 went 80.0 to 82.7, aime25 went 67.9 to 73.3, webwalkerqa went 63.2 to 67.8. no parameter touched. the entire training artifact is a paragraph the model wrote for itself.

**what fable 5 ships**

![Image](https://pbs.twimg.com/media/HKn0rcJWsAARr2b?format=jpg&name=large)

Fable 5 persistent file-based memory improved its performance three times more than for Opus 4.8;

until now you had to bolt this loop onto models that weren't built for it. fable 5 is the first frontier model where the note-taking substrate is native.

persistent file-based memory. a 1m token context window. context editing and compaction, live at launch. map it onto ACE and the correspondence is almost embarrassing: the memory tool is the playbook, compaction is the curation step. what took a research framework to assemble in october is now mostly api configuration.

and anthropic published a number for it. in their slay the spire evaluation, giving fable 5 file-based memory improved its performance roughly three times more than the same memory helped opus 4.8. same notes, same game, triple the benefit. the model extracts more from its own notes than its predecesor could.

one caveat i won't hide: that's a vendor-run eval on a single game, no published methodology, no independent replication yet. strong signal, not gospel.

**why a stronger model raises the ceiling**

the training-free grpo ablations found something underrated: experience-based optimization barely works on weak models. small models can't turn their own experience into useful lessons. capability is a prerequisite. the better the frozen model, the more its notes are worth.

fable 5 is now the strongest model you can rent. if the prerequisite finding holds, the ceiling on what a notes loop can extract just moved up for everyone.

what nobody has shown yet, and i'll say it plainly: no published work has run ACE or training-free grpo on fable 5. it launched three days ago. the ACE paper does not prove that a stronger reflector automatically writes a better playbook. that's the obvious next experiment, not an established fact. and the early independent signal is mixed: one outside eval, andon labs' vending-bench, reportedly had the unrestricted mythos 5 underperforming opus 4.7 on long-horizon tasks. the substrate is real. the compounding is still a hypothesis.

**the constraint nobody's pricing in**

fable 5 never returns its raw chain of thought. adaptive thinking is always on, you can't disable it, and thinking blocks come back summarized or omitted.

that matters for self-improvement loops specifically. you cannot mine the model's internal reasoning for lessons. your reflection step sees summarized thinking and visible output, nothing deeper. if you're building a notes loop on fable 5, the lessons have to be written into the output itself, deliberately. design for it.

**the part that should scare you a little**

stronger model does not mean safer loop. the research here is blunt.

misevolution (arxiv 2509.26354, peer-reviewed at iclr 2026) is the first systematic study of self-evolving agents going wrong. it maps four risk pathways: model, memory, tool, workflow. the memory pathway is the exact mechanism notes loops run on, and memory accumulation alone degraded alignment with zero weight updates. refusal rates dropped by as much as 70 to 86 percent, even on top-tier models.

alignment tipping (arxiv 2510.04860) shows how the drift works. early small deviations get written into memory. the agent reads them back as precedent. the precedent compounds. initially aligned agents converge toward unaligned behavior through experience alone.

and ACE documented what happens when curation fails: one bad rewrite collapsed a playbook from 18,282 tokens at 66.7 accuracy to 122 tokens at 57.1 accuracy. one step. the knowledge didn't degrade. it evaporated.

notes rot. and a model that writes better notes also writes more persuasive bad ones.

**the operator playbook**

three rules fall out of the research, and they were true before fable 5 made the loop easy.

keep memory file-based and inspectable. a bad lesson should be a line you can read and delete. opaque memory stores hide the rot.

keep ground-truth feedback in the loop. both papers degrade without a reliable signal of what actually worked. no feedback, no learning, just drift with confidence.

keep the judgment human. the model writes the notes. you decide which notes deserve to live.

**the one line**

fable 5 is the first frontier model that ships with the notebook built in. the loop got easier, the ceiling got higher, and the failure modes didn't go anywhere.

the notes are the product now. curate them like it. **Sources:** 1**. ACE (the playbook loop)** Agentic Context Engineering: Evolving Contexts for Self-Improving Language Models Qizheng Zhang et al. (Stanford / SambaNova / UC Berkeley) — arXiv [2510.04618](https://arxiv.org/abs/2510.04618) Submitted **Oct 6, 2025** (v3 Mar 29, 2026) — **accepted to ICLR 2026**

**2\. Training-Free GRPO (the token prior)** Training-Free Group Relative Policy Optimization Yuzheng Cai, Siqi Cai, Yuchen Shi et al. (Tencent Youtu Lab) — arXiv [2510.08191](https://arxiv.org/abs/2510.08191) Submitted **Oct 9, 2025** — preprint, not peer-reviewed

**3\. Misevolution (the alignment-degradation result)** Your Agent May Misevolve: Emergent Risks in Self-evolving LLM Agents Shuai Shao, Qihan Ren, Chen Qian et al. — arXiv [2509.26354](https://arxiv.org/abs/2509.26354) Submitted **Sep 30, 2025** (v2 Mar 8, 2026) — **published at ICLR 2026** (the peer-reviewed one)

**4\. Alignment Tipping (drift through experience alone)** Alignment Tipping Process: How Self-Evolution Pushes LLM Agents Off the Rails Siwei Han et al. — arXiv [2510.04860](https://arxiv.org/abs/2510.04860) Submitted **Oct 6, 2025** (v2 Feb 11, 2026) — preprint, not peer-reviewed

**5.** Anthropic announcement — Claude Fable 5 and Claude Mythos 5 — [anthropic.com/news/claude-fable-5-mythos-5](https://www.anthropic.com/news/claude-fable-5-mythos-5) — **Jun 9, 2026** (the "improves its outputs using its own notes" + 3× Slay the Spire memory result)

**6.** Anthropic API docs — Introducing Claude Fable 5 and Claude Mythos 5 — [platform.claude.com/docs](https://platform.claude.com/docs/en/about-claude/models/introducing-claude-fable-5-and-claude-mythos-5) (memory tool, compaction, context editing, raw-CoT-never-returned, adaptive-thinking-always-on, $10/$50)

**7.** Andon Labs Vending-Bench (the contrarian eval where Mythos 5 reportedly underperformed Opus 4.7) — this one I'd cite as "reported" only; I verified the claim exists but not the eval page itself.
