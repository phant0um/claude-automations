---
title: "Loop Engineering and The Missing Compiler"
source: "https://x.com/IntuitMachine/status/2068808668393451770"
author:
  - "[[@IntuitMachine]]"
published: 2026-06-21
created: 2026-06-22
description: "Loop engineering as the search for the verifier a kind of work never came withWe usually describe a compiler by what it makes. It turns sour..."
tags:
  - "clippings"
---
![Image](https://pbs.twimg.com/media/HLXigHYWIAA0dDn?format=jpg&name=large)

Loop engineering as the search for the verifier a kind of work never came with

We usually describe a compiler by what it makes. It turns source code into something a machine can run. But that is not what a compiler is to the person using it. To someone writing code, **a compiler is a thing that refuses to let them be wrong in a particular way.** You write a type mismatch and it stops you cold. You cannot sweet-talk it, you cannot keep rephrasing the mistake until it relents, and its refusal is plain for anyone else to see — run the same code on another machine and you get the same verdict. **A compiler, experienced rather than defined, is three things welded together**: something that **pushes back when you err**, something that **cannot be argued out of its judgment,** and **a verdict that is public and repeatable.**

Programming is unusual in that all three arrive free, bundled with the language. You do not build the resistance; you inherit it. This is the quiet reason coding agents work as well as they do — not because the models are sharper at code than at prose, but because **code is the rare domain where reality checks the work for you, automatically, every time you hit run.** The agent proposes, and the world disposes, at no cost to anyone.

**Loop engineering is what you do when that gift is absent**. Seen this way, it is not mainly about autonomy or prompting or clever orchestration. **It is the work of noticing that a given kind of task** **has no compiler** **— and building the closest thing you can.**

## The work is to notice the compiler is missing

A loop, in the engineering sense, is the scaffolding you wrap around an agent so that it tries, gets told no, and tries again. Strip that scaffolding down and every serious part of it is one of the compiler's three properties, rebuilt by hand because the domain did not supply it.

The tests and the continuous-integration checks are the resistance — the part that pushes back when the work is wrong, manufactured deliberately because nothing in the task pushes back on its own. The independent reviewer, the second pass that did not write the code, is the unarguable judge — installed precisely because the thing that did the work cannot be trusted to grade it. The audit trail at the end — the summary, the diff, the commands run, the risks named — is the public verdict, the record that lets someone who was not in the loop confirm what happened. Good loop engineering is just these three reconstructed faithfully. Bad loop engineering is an agent talking to itself, which is to say a compiler with the resistance, the independence, and the public verdict all quietly removed.

So the first move of the discipline is diagnostic, not constructive. **Before you design the loop, you ask: what would a compiler be** **for this task****, and does one already exist?** If it does, use it. If it does not, you have found the thing the loop has to fabricate.

## Every abstraction level wants its own compiler

The reason "compiler" has to be plural is that a real codebase already runs a stack of them. The formatter, the linter, the type-checker, the test suite, the human reviewer — these are not one verifier but five, and each one checks a different height of claim. The formatter rules on whitespace. The linter rules on style. The type-checker rules on whether the pieces fit. The tests rule on whether the program behaves. The reviewer rules on whether the design is sound. They form a ladder, and each rung verifies something the rung below it cannot see.

What changes as you climb the ladder is the verdict itself. Down low, it is instant, automatic, and external: a type error is decided in milliseconds by something outside you, with no judgment involved. Higher up, the verdict gets slower, less automatic, and less external. "Does this architecture hold up" cannot be settled in milliseconds, cannot be settled without judgment, and cannot be fully settled by anything but a person. The check at the top of the ladder still does the same essential thing as the check at the bottom — take a claim and force it down against something real — but it has to reach much further to touch reality, and the touch is less certain when it gets there.

This is the load-bearing half of the framing. **Loop engineering is not the search for** **a** **missing compiler but for the missing compiler** **at a given level****.** The practical question for any piece of work is: which rung am I standing on, and what would a verifier have to be here — at this abstraction level, for this kind of claim?

## The replicas are samplers, not oracles

The framing needs an honest demotion before it can be trusted, because a real compiler and a hand-built one are not the same kind of object. A compiler is total and deterministic: it checks every case, every time, with no gaps and no opinions. **The verifiers you build by hand are partial and probabilistic.** A test suite only checks the cases you thought to write. A reviewer only catches what they happen to notice. A pilot or an experiment only measures the slice of the world you instrumented. Each is a sample of reality standing in for the compiler's complete coverage.

This means you never quite get the compiler's guarantee out the other end. You get a probabilistic shadow of it, and **the size of the shadow is the real craft.** The skill in loop engineering is **choosing the cheapest sample of reality that still genuinely resists** — a check small enough to run constantly but real enough that the work cannot fake its way past it. "Recreating compilers" is exactly right about the function you are reproducing and slightly generous about the reliability you actually achieve. You are building compiler-grade machinery out of materials that only approximate a compiler.

## Independence is the part that is easy to fake

A compiler's authority comes from one property above the others: it cannot share your framing. It engages your code on its own terms, so when it disagrees with you, the disagreement is information rather than an echo. Reproduce everything about a compiler except this, and you have built something worse than nothing.

This is the characteristic way loop engineering fails. Reaching for a second agent as a reviewer is the natural move when you need an independent judge, and it is also the easiest place to manufacture a counterfeit one — a checker that emits crisp pass/fail verdicts but lives in the same kind of head as the worker, so the two can agree, confidently and silently, on the same blind spot. A verdict from something that shares your assumptions is theater dressed as verification. The better practitioners half-know this already; it is why the honest loop manuals warn that an agent reviewing an agent is not a substitute for a real check. A thing can be shaped exactly like a compiler — same inputs, same crisp outputs — and still not be one, because the one property that made the compiler trustworthy is the invisible one, and the invisible one is the first to be dropped.

## The tower has a top floor

Keep climbing the ladder and you eventually run out of compiler to build, and it is worth being precise about why. As the claims get more abstract, the thing you check them against gets steadily less external. The linter checks against a written rule. The test checks against an execution. The pilot checks against the world, slowly and expensively but really. Then you reach claims like "is this the wise strategy," "is this in good taste," "is this even the right question" — **and there is no external referent left to compile against at all.**

The temptation is to read this as a compiler that has not been built yet, a gap that better tooling will eventually close. It is more honest, and more useful, to treat it as a level where no compiler can exist. The felt sense of what counts as good work is not a fact about the external world that a checker could measure; it cannot be installed in a verifier, only grown, and where it is grown independently it tends to diverge in exactly the places no one ever jointly tested. Above this line the strategy has to change rather than scale. **You stop trying to** **compile** **the judgment and start trying to make it** **auditable** **— surfacing the reasoning and the evidence so completely that a human can take the verdict themselves.** The tower has a top floor, and the right move on it is not to keep stacking verifiers but to hand the judgment, fully documented, to a person.

## A compiler needs a spec; some work is writing the spec

There is a deeper thing the metaphor leaves out, and it is the part that matters most for the hardest work. A compiler presupposes a specification. It can only check your code because the language's rules are already defined — "correct" exists, fixed and external, before the checking begins. That assumption is invisible precisely because, in programming, it almost always holds.

But **a large share of serious knowledge work is the part** **before** **the spec exists.** Much of research, analysis, and strategy is figuring out what the question is, inventing the frame that makes a problem tractable, and deciding what would even count as a good answer. That work has no compiler analogue, because there is nothing to check against until it is done. It is a different activity from verification — closer to rotating a problem through every framing you can find and seeing which one survives contact with the facts — and no verifier, however good, performs it for you. So loop engineering, even perfected, addresses only the verification half of the work and leaves the discovery half untouched. **The category error to avoid is believing that a sharper verifier will do your thinking; the verifier can only tell you whether you met a standard, never which standard was worth meeting.**

## What good loop engineering actually is

Put the qualifications back together and the framing turns from a metaphor into a working method. The right question stops being "how autonomous can I let the agent be" and becomes a short interrogation of the task. What would a compiler be at this level of abstraction? How cheap a replica of it can I build that still genuinely resists and is genuinely independent? How far up the ladder does my replica reach before the referent thins out and the only move left is to publish the judgment for a human? And which part of this work is not verification at all, but the discovery of the very standard a compiler would have needed?

A good loop engineer, in that light, is something like a verification archaeologist. They dig for the compiler the domain never shipped, build the most faithful replica the materials allow, stack those replicas up the abstraction ladder as far as they will go, and — this is the part that separates the discipline from wishful automation — mark clearly where the replicas stop. They know which floors of the tower have a real verifier, which have only a sampled and fallible one, and which have none because the judgment there is irreducibly human or because the spec itself has not yet been written.

The measure of a loop, then, **is the quality of the compiler you can build for the level you happen to be standing on:** tight where a unit test exists, loose and slow where only a pilot does, and absent where the work is taste or discovery. And the wisdom of a loop engineer is knowing the levels where the right move is to stop building compilers altogether and hand the judgment, with all its evidence laid out, to a person who can be trusted to feel the difference.