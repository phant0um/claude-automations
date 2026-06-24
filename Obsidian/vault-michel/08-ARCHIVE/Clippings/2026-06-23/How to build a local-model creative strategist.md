---
title: "How to build a local-model creative strategist"
source: "https://x.com/VibeMarketer_/status/2067967513246249337"
author:
  - "[[@VibeMarketer_]]"
published: 2026-06-19
created: 2026-06-22
description: "I wanted to know if a local model could do more than generate ad ideas. Could it look at a real Meta ad, read the objective and performance ..."
tags:
  - "clippings"
---
![Image](https://pbs.twimg.com/media/HLLfUscW0AICXF4?format=jpg&name=large)

I wanted to know if a local model could do more than generate ad ideas. Could it look at a real Meta ad, read the objective and performance metrics, and recommend a next test I would actually trust with ad spend?

Not "write 50 more hooks" or "summarize the dashboard," but a real creative strategy call. To be useful, the model had to explain the metric pattern, respect the campaign objective, and recommend a test a creative team could actually run.

Training the model was only one part of it. The real work was proving the answer was worth trusting. So the project turned into something more interesting: building an eval harness for creative strategy.

The input was simple:

- a real creative asset or screenshot
- campaign objective
- performance metrics
- basic context around the ad

The output I wanted was not "make a better ad." I wanted the model to diagnose what was probably happening, explain the metric pattern, respect the campaign objective, and recommend the next creative test.

Checking that became the project, because creative strategy is not just text quality. A good answer has to match the asset, read the metrics, respect the objective, avoid causal overreach, and give the team a test they can run.

## The Problem With AI Creative Strategy

Most AI marketing workflows still look like this:

> prompt -> ideas -> pick whatever sounds good

That's useful for volume, but weak for judgment.

A model can give you 20 hooks, 10 ad angles, 5 landing page sections but if you're spending money on ads, you need a reliable data to decide what to test next.

Does the model see what is actually in the creative? Can it tell the difference between a hook problem and a landing page problem? Can it separate high CTR / low CVR from low CTR / high CVR?

Can it avoid telling you to "optimize the CTA" on every weak ad? Can it recommend a next test that is specific enough for a creative team to produce?

That's the bar. Not "did the model write something smart?" The bar is "did the model produce useful creative judgment"?

![Image](https://pbs.twimg.com/media/HLLkgtXXoAACN3q?format=jpg&name=large)

## The Experiment

The project was a Meta ads creative performance analyst. The model sees one ad example at a time and produces a structured diagnosis plus next tests.

The first version was text-only. It used campaign/ad metadata and performance metrics. The later version became multimodal, so it could inspect creative assets, screenshots, and image/video-derived frames before producing its analysis.

Specifically, this meant fine-tuning a small VLM adapter on real Meta ad examples and then reviewing the outputs against held-out cases.

This was not about beating frontier models on general intelligence (obviously)

It was about whether a small, owned workflow could learn one narrow kind of judgment:

> given this creative, this objective, and this metric pattern, what should we test next?

The goal was not to build an automated media buyer, but simply:

> Can a model learn enough creative strategy judgment to give grounded next-test recommendations from an ad creative and its metrics?

The technical setup:

- curated Meta ad examples
- sanitized local creative assets
- JSONL training/eval records
- VLM LoRA training
- RunPod GPU runs
- structured model outputs
- review interfaces
- rubric scoring
- champion gates

The important part was not any one tool in that stack but more so the entire loop:

> dataset -> model output -> review -> score -> failure cluster -> correction -> promotion gate

That loop is what turned the project from "fine-tune a model" into "build a system that can tell whether the model is improving."

![Image](https://pbs.twimg.com/media/HLLkr_hWIAApKkV?format=jpg&name=large)

## The Dataset Was the First Product

The first mistake would have been grabbing a random pile of ads and hoping the model learned something useful. Creative strategy depends heavily on the shape of the examples, so the dataset had to reflect the kinds of situations a strategist actually sees.

The first serious dataset had 150 enriched Meta ad records from a 90-day export.

Each row kept:

- ad context
- campaign objective
- creative format
- performance metrics
- asset reference
- creative explanation
- performance pattern

The goal was not to build a perfect production dataset. It was to build a useful teaching set, so the records were selected across performance patterns:

- strong ROAS
- high CTR / low CVR
- low CTR / high CVR
- weak ROAS
- expensive clicks
- lead quality risk
- mixed or ambiguous results

![Image](https://pbs.twimg.com/media/HLLk3uOXkAAkBDD?format=png&name=large)

That matters because a model trained only on winners learns the wrong thing. Real creative strategy is mostly about interpreting messy middle cases: ads that get attention but do not convert, ads with low CTR but high-intent clicks, campaigns where a sales-style recommendation would be wrong, and assets too thin to support a confident visual claim.

The dataset had to teach those distinctions.

This was also where the first hard rule showed up:

> Meta ad metrics are signals, not causal proof.

The model was not allowed to say "this creative caused X." It had to frame conclusions as hypotheses. That one constraint changed the whole project, because it forced the system to act more like a strategist and less like a confident dashboard narrator.

## Training Was Not Enough

The first meaningful milestone was not that the model became a great strategist. It was that the model could reliably speak the language of the workflow.

In one run, it produced 72/76 parsed held-out rows immediately. The remaining 4 were structurally valid and only failed because one enum value used Medium instead of lowercase medium. After a tiny normalization step, the outputs were 76/76 schema-valid.

That mattered because structured outputs are the entry ticket for a real workflow. If the JSON breaks, the review interface breaks, the scorer breaks, and the whole loop becomes manual cleanup.

But this is also where the trap shows up. A clean schema can make weak reasoning look more finished than it is. The fields are present, the tone sounds professional, and the answer looks ready to ship. None of that proves the model made a useful strategy call.

So the project had to move from "can the model answer in the right format?" to "can the answer survive review?" For this workflow, a good answer had to match the creative, read the metric pattern correctly, respect the campaign objective, and propose a test a creative team could run.

That became the eval problem. Not "is the output well written?" but "would I let this recommendation influence what we test next?"

## The First Real Failures Were Useful

The useful failures were not dramatic. They were the small mistakes a busy marketer might miss while scanning a polished answer.

One cluster came from thin engagement creatives: giveaway graphics, countdown-style posts, and permission-placeholder frames. The model sometimes wrote as if the product and offer were clearly visible, even when the asset did not support that read. That was not a generic "bad output." It was a visual truthfulness failure.

Another cluster came from traffic campaigns. Some outputs treated a relatively strong CTR as weak. Others jumped into landing-page advice without explaining what the creative itself should change. That was not a schema problem. It was a metric calibration and next-test quality problem.

Those distinctions mattered because they pointed to different fixes. Thin creatives needed better refusal and confidence behavior. Traffic rows needed better examples of objective-specific metric reasoning. Generic CTA advice needed a stricter promotion gate.

This is what made the harness useful. It did not just tell me whether the model was "good." It told me what kind of wrong it was.

## What The Harness Measured

I did not want a generic "quality" score because that would be too vague to improve. The harness needed to measure the parts of creative judgment that actually mattered.

The rubric focused on six criteria:

1. **Visual truthfulness.** Does the model describe what is actually visible in the creative? A multimodal analyst can hallucinate visual details just like a text model can hallucinate facts. If the product is not visible, the model should not pretend it is. If the creative is a placeholder or thin screenshot, the model should lower confidence instead of inventing a rich creative read.
2. **Metric reasoning.** Does the model understand the performance pattern? High CTR / low CVR is different from low CTR / high CVR. High CPC with low CTR points somewhere different than strong ROAS with limited reach. The model had to reason about the metric shape instead of turning every diagnosis into "improve the ad."
3. **Objective discipline.** Does the recommendation respect the campaign objective? A traffic campaign, lead campaign, awareness campaign, and sales campaign should not be diagnosed the same way. The model needed to avoid forcing every ad into a purchase/ROAS frame.
4. **Next-test quality.** Is the recommendation specific enough to run? "Improve CTA" is not a useful next test. "Test a first-frame product demo against the current lifestyle opener to see whether qualified clicks improve" is closer. The model had to recommend tests tied to the creative, the metric pattern, and the objective.
5. **Overall usefulness.** Would a marketer or creative strategist actually use this? This was the practical catch-all. Not every useful answer is perfect, but if the output would not help someone decide what to test next, it did not matter how clean the schema was.
6. **Generic recommendation rate.** This became one of the most useful failure metrics because the model had a habit of drifting into generic CTA/frequency suggestions. That is exactly the kind of behavior a normal average score can hide, so the harness tracked it directly. If a candidate produced cleaner-looking outputs but doubled down on generic advice, it should not be promoted.

![Image](https://pbs.twimg.com/media/HLLlC6LXUAAt_H5?format=png&name=large)

## The Review Interface Changed The Project

The review interface became the place where the harness got real. Instead of reading outputs in isolation, I could inspect:

- the original creative asset
- the campaign objective
- the metrics
- the model diagnosis
- the next tests
- scoring fields
- reviewer notes

That matters because creative strategy cannot be evaluated from the model output alone. If the model says the product is visually prominent, you need the creative next to it. If it says traffic is weak, you need the CTR, CPC, CVR, objective, and context. If it recommends a next test, you need to judge whether that test follows from the evidence.

The interface turned review from vibes into a repeatable workflow. Not just:

> model output -> "looks good"

But:

> source -> output -> rubric -> failure note -> next decision

Once you have that, every review becomes training signal. Not necessarily training data for the model, but training signal for the system.

## The Champion Gate

The next piece was the promotion gate. This is the part that kept the project honest: a new model version could not replace the current champion just because it felt better.

It had to clear concrete thresholds:

- 100% parse rate
- no hard fails
- pass rate above the incumbent
- overall usefulness above the incumbent
- metric reasoning above the incumbent
- next-test quality above the incumbent
- objective discipline above the threshold
- generic CTA/frequency recommendations below the cap

This turned model promotion into an actual decision. That sounds obvious, but it is easy to skip. When you spend time preparing data, launching a GPU job, waiting for training, importing outputs, and reviewing results, you want the new thing to win.

The gate protects you from that bias. It asks a colder question:

> Is this model better at the behavior we actually care about?

If not, it does not ship.

## The Most Useful Result Was A Negative One

The best proof of the harness came from a model I did not promote.

On paper, the later candidate looked like a small improvement. It produced clean outputs, parsed the full evaluation set, and nudged pass rate from 81.6% to 82.9%. If I had only checked parse rate and pass rate, I could have called it a win.

But the rubric showed a different story. Overall usefulness dropped from 4.17 to 4.03. Metric reasoning dropped from 4.21 to 4.09. The biggest warning sign was the next-test behavior: generic CTA/frequency recommendations jumped from 35.5% to 72.4%.

![Image](https://pbs.twimg.com/media/HLLlLe1X0AAJI2H?format=png&name=large)

That changed the interpretation completely. The model was clearing more surface checks, but it was becoming less useful as a creative strategist. It was more likely to give the kind of advice a marketer already knows to ignore.

This is the point of the promotion gate. It protects the workflow from a model that is newer, cleaner, or slightly better on one number, but worse at the job you actually need done.

Without the harness, I probably would have overvalued the pass-rate improvement. With the harness, the decision was simple: keep the incumbent and do not promote the new candidate.

That negative result was more useful than another training run. It showed that the harness could catch a regression that looked like progress.

![Image](https://pbs.twimg.com/media/HLLlR-2XEAEple_?format=png&name=large)

## Why This Matters For AI Marketing Tools

Most AI marketing tools are still judged by output volume and polish. They can generate more hooks, create more variants, write in a brand voice, or turn a dashboard into a decent-looking strategy doc.

Those features are useful, but they are not the same as judgment. If the system cannot tell the difference between a specific next test and a generic suggestion, it will mostly help teams produce more things to review.

The better question is whether the system improves marketing judgment over time. Does every reviewed output make the next run sharper? Do failures become examples? Do weak recommendations become failure categories? Does a new model have to beat the current one before it ships?

That requires a different stack than prompt templates alone. You need examples of good and bad judgment, a rubric, a review surface, failure categories, and a promotion gate. You also need permission to say, "this model is newer, but it is not better."

That is why the harness became more valuable than the fine-tune by itself. The fine-tune changed the model. The harness changed the workflow around the model.

## What I Would Steal From This

If you are building AI for creative strategy, I would not start by training. I would start by defining the judgment loop.

Pick one narrow workflow, such as:

- diagnose one Meta ad
- review one landing page
- score one video hook
- generate one next-test plan
- critique one creative brief

Then define what good means in terms you can score. For creative strategy, that might mean:

- grounded in the asset
- grounded in the metrics
- objective-aware
- specific enough to execute
- avoids causal overreach
- avoids generic advice
- identifies the next test clearly

After that, build the smallest possible review interface: source on one side, model output on the other, rubric underneath. Now every output can become a score, a failure category, or a correction example.

Only then does training become meaningful, because now you can answer the question that actually matters:

> Did the model get better at the work?

## The Bigger Lesson

I still think training matters, especially in domains where the model needs to learn local taste, business context, terminology, and judgment patterns.

But this project made one thing clear: training is not the product. The product is the loop around training: dataset quality, rubric design, review workflow, failure analysis, promotion gates, and operator judgment.

That loop is what turned this from a model experiment into a creative strategy system.

The old workflow was:

> ask AI for ideas -> pick what sounds good -> hope the test works

The better workflow is:

> generate -> diagnose -> score -> compare -> correct -> promote only when the system improves

AI creative tools should not just help marketers make more ideas. They should help marketers build better judgment loops.

That's where the real value is.

Thanks for reading. Follow [@VibeMarketer\_](https://x.com/@VibeMarketer_) for more :)