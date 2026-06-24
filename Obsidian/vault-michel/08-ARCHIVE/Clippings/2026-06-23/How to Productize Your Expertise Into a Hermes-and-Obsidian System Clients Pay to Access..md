---
title: "How to Productize Your Expertise Into a Hermes-and-Obsidian System Clients Pay to Access."
source: "https://x.com/neil_xbt/status/2068884902078992537"
author:
  - "[[@neil_xbt]]"
published: 2026-06-21
created: 2026-06-22
description: "Selling your time has a hard ceiling and you already know where it is.There are only so many hours in a week. Every dollar you earn from exp..."
tags:
  - "clippings"
---
![Image](https://pbs.twimg.com/media/HLYkn2pWcAAJJwM?format=jpg&name=large)

**Selling your time has a hard ceiling and you already know where it is.**

There are only so many hours in a week. Every dollar you earn from expertise is tied to an hour you spend delivering it. When you are fully booked, you are done.

The only way to earn more is to raise your rate or work more hours, and both of those run out fast. This is the structural trap of every expert who sells their knowledge directly: the income is capped by the calendar, and the calendar does not expand.

The escape from that trap has always been the same idea: turn what you know into something that delivers value without you being present for it. A book. A course. A piece of software. The problem is that all of those historically required you to either become a different kind of professional, an author, a course creator, a software company, or to flatten your expertise into a static format that cannot adapt to the specific situation in front of it. A book cannot answer a follow-up question. A course cannot apply its framework to your particular case.

That limitation is what changed.

You can now encode your expertise into a system that holds your knowledge, applies your frameworks to a client's specific situation, remembers everything across every interaction, and improves over time, all without you in the room. The system is built from two tools: Obsidian to hold the structured knowledge, and Hermes Agent to apply it with persistent memory and self-improving skills. Clients pay to access the system rather than to access your hours.

This article is how to build that, who it works for, and how to price access to a version of your own expertise that runs without you.

## What Productizing Expertise Actually Means Here

The phrase "productize your expertise" usually means writing a course or a template pack. That is not what this is.

A course transfers your knowledge to someone who then has to apply it themselves. A template gives them a starting point they have to fill in. Both put the work back on the client. What you are building instead is a system that does the applying. The client brings their specific situation, and the system applies your frameworks, your decision logic, and your accumulated judgment to that situation, producing the kind of output the client would otherwise have paid for your hours to get.

The distinction matters because it determines what the client is paying for. With a course, they pay for information and do the work. With this system, they pay for the work to be done, by a system that thinks the way you think because you encoded how you think into it.

Two components make this possible. Obsidian holds the knowledge layer: your frameworks, your decision trees, your domain expertise, your worked examples, all in structured plain-text files. Hermes Agent is the application layer: it reads the knowledge, applies it to the client's input, remembers every past interaction with that client through its persistent memory, and refines its skills as it handles more cases. The knowledge is yours. The agent is what makes it queryable, applicable, and persistent.

The result is not a static product. It is a living system that gets better at applying your expertise the more it is used, which is something no book or course has ever been able to do.

## Whose Expertise This Works For

Not all expertise productizes equally well into this format. The expertise that works best shares three characteristics, and identifying whether yours qualifies is the first decision.

It has to be framework-driven rather than purely intuitive. If the way you deliver value can be expressed as a set of principles, decision rules, and repeatable processes, even partially, it can be encoded. A financial advisor who follows a consistent methodology for assessing a client's situation can encode that methodology. A consultant who applies the same diagnostic framework to every engagement can encode the framework. Expertise that is genuinely pure intuition with no expressible structure does not productize, but most professional expertise has far more structure than the expert assumes.

It has to apply to a recurring situation rather than a unique one. The system delivers value by applying your frameworks to client situations that resemble situations you have handled before. A marketing consultant who repeatedly helps businesses with the same category of problem has recurring situations. A lawyer who handles the same type of contract review across many clients has recurring situations. The more your work repeats in shape while differing in detail, the better it productizes.

And it has to produce an output the client can act on. The system needs to deliver something concrete: an analysis, a plan, a recommendation, a document, a diagnosis. Expertise whose value is purely in conversation and rapport does not encode well. Expertise that culminates in a deliverable does.

If your expertise is framework-driven, applies to recurring situations, and produces actionable output, it is a candidate for this system. Most professional consulting, advisory, analytical, and diagnostic expertise meets all three criteria.

## Building the Knowledge Layer in Obsidian

The Obsidian vault is where your expertise lives in a form the agent can read and apply. The structure separates the different kinds of knowledge the system needs.

```text
expertise-system/
├── CLAUDE.md            (how the agent applies the expertise)
├── frameworks/         (your core methodologies and decision logic)
├── examples/           (worked cases showing the frameworks applied)
├── reference/          (domain knowledge, standards, facts)
├── intake/             (how to gather what a case needs)
├── clients/            (per-client memory and history)
└── outputs/            (templates for the deliverables)
```

The frameworks folder is the heart of the system. This is where you encode the actual methodology that makes your expertise valuable. Not a vague description of your approach. The specific decision logic: when you see this, you check that; if the answer is this, you recommend that; the factors you weigh and how you weigh them. The more precisely you can express your own decision-making, the better the system applies it.

Encoding a framework looks like this. Take one process you run repeatedly in your work and write it out as explicit logic:

```text
# Framework: [Name of your methodology]

## When This Applies
[The situation that triggers this framework]

## The Inputs Required
[What information you need before you can apply it]

## The Decision Logic
1. First, assess [factor]. 
   - If [condition], then [direction]
   - If [condition], then [different direction]
2. Then evaluate [factor], weighing [considerations]
3. [Continue through your actual process]

## The Output
[What this framework produces and in what form]

## Common Mistakes
[Where people get this wrong, including where you got it 
wrong before you learned better]

## Worked Example
[A real case, anonymized, showing the framework applied 
from input to output]
```

The "common mistakes" and "worked example" sections are what separate a system that applies your expertise well from one that applies it mechanically. The mistakes encode your hard-won judgment about where the framework goes wrong. The worked example gives the agent a concrete pattern to match against, which dramatically improves the quality of its application to new cases.

Build one framework completely before building others. A single well-encoded framework that handles your most common client situation is a working product. You expand the system by adding frameworks over time.

## Building the Application Layer in Hermes

Hermes is what turns the static knowledge in Obsidian into a system clients interact with. Install it, set Claude as the model that powers it, and point it at your expertise vault.

The configuration that defines how the agent applies your expertise lives in the CLAUDE.md at the root of the vault:

```text
# Expertise System — CLAUDE.md

## What This System Does
This system applies [your name]'s [domain] expertise to 
client situations. It reads the frameworks in frameworks/, 
applies them to the client's specific input, and produces 
the deliverable defined in outputs/.

## How to Handle a Client Request
1. Identify which framework applies to their situation
2. Check intake/ for what information the framework requires
3. If information is missing, ask the client for it before 
   proceeding
4. Apply the framework's decision logic to their specific case
5. Reference the worked examples to calibrate the application
6. Produce the output in the format defined in outputs/
7. Save the interaction to the client's file in clients/

## Standards
- Apply the framework faithfully. Do not improvise beyond 
  what the encoded expertise supports.
- When a situation falls outside the encoded frameworks, 
  say so clearly rather than guessing. Flag it for [your name] 
  to handle directly.
- Reference the common mistakes section to avoid known errors.

## Memory
Every client interaction is saved to clients/[client-name].md.
Read the client's history before responding to them so the 
system remembers their situation across sessions.
```

The instruction to flag situations outside the encoded frameworks is critical. It is what keeps the system trustworthy. A productized expertise system that confidently improvises beyond what you actually know how to do produces bad outputs that damage your reputation. A system that knows its boundaries and escalates the edge cases to you stays reliable and protects the expertise it represents.

Hermes's persistent memory is what makes the system feel like working with you rather than with a generic tool. Because every client interaction is saved and read back before each new response, the system remembers a client's situation, their history, and their previous outputs across every session. The client experiences continuity, the same way they would with a human advisor who remembers them, which is a large part of what they are paying for.

## How Clients Access It and What They Pay For

There are three models for selling access to the system, in increasing order of price and decreasing order of your involvement.

The managed model is the highest-touch and the easiest to start with. Clients send their situations to you, you run them through the system, you review the output, and you deliver it. The system does the work; you provide the quality assurance and the relationship. This is the safest way to begin because you catch any errors before they reach the client, and it lets you refine the frameworks based on real cases before you ever let clients touch the system directly. Price this as a retainer, $500 to $2,000 per month depending on volume and the value of the output.

The supervised access model gives clients direct access to the system through a Hermes interface, often a Telegram bot, with you monitoring and stepping in when the system flags something outside its frameworks. The client gets immediate answers from your encoded expertise; you handle the edge cases the system escalates. This scales better than the managed model because clients self-serve the routine cases. Price it as a subscription, $200 to $800 per month per client.

The licensed model is the highest-leverage and requires the most mature system. You license the entire system to a client or a company to run themselves, with you providing updates and maintenance. This is appropriate once the frameworks are thoroughly tested and the system handles the large majority of cases without escalation. Price it as a significant setup fee plus ongoing licensing, because the client is getting a permanent asset built from your expertise.

Most people start with the managed model, move to supervised access as the system proves reliable, and offer the licensed model to the clients who want to bring the capability fully in-house. The progression matches the maturity of the system: the more cases it has handled and the more its frameworks have been refined, the more autonomously it can run.

## Why This Compounds Where Selling Hours Does Not

The decisive advantage of this model over selling your time is that it improves while requiring less of you, which is the exact opposite of how an hourly practice behaves.

Every case the system handles, through Hermes's self-improving skill system, refines how it applies your frameworks. The skills it builds from completed cases make the next similar case faster and more accurate. Your hourly practice does not work this way. The hundredth client engagement takes the same number of hours as the first, because your time does not compound. The system's hundredth case is handled better than the first, because the system learns.

The knowledge layer compounds too. Every framework you encode makes the system capable of handling a wider range of client situations. Every worked example you add improves the quality of its application. Every edge case you handle directly and then encode becomes a case the system handles itself next time. The vault grows more valuable with each addition, and that value is captured permanently rather than evaporating the way the value of an hour worked does.

And the income decouples from your time. With the supervised and licensed models, the system serves clients while you are doing something else, including building more of the system or simply not working. The ceiling that caps every hourly expert, the finite number of hours in a week, stops being the constraint. The constraint becomes how much of your expertise you have encoded and how many clients you have sold access to, both of which can grow without consuming more of your hours.

## The Honest Constraints

This model is powerful and it is not effortless, and the honest version of what it requires matters before you commit to building it.

Encoding your expertise is real work. Writing out your decision logic explicitly, with the precision the system needs, forces you to articulate things you currently do by instinct. This is genuinely difficult and sometimes uncomfortable, because it reveals the places where your own process is less defined than you assumed. The upside is that the act of encoding often improves your own thinking, but it is not a weekend task. Encoding one framework well takes real effort.

The system needs supervision until it is proven. Letting clients access an unsupervised version of your expertise before you have validated that it applies your frameworks correctly is a reputation risk. The managed model exists precisely so you can run real cases through the system and catch its errors before any client sees them. Skipping that validation phase is the main way this goes wrong.

And it does not replace the part of your expertise that is genuinely irreplaceable. The system handles the framework-driven, recurring, output-producing portion of your work. The judgment calls at the edges, the genuinely novel situations, the relationship and trust that some clients are really paying for, those remain yours. The system frees you from the repeatable portion so you can focus on the portion that actually requires you, which is usually the more valuable and more interesting part anyway.

## Start by Encoding One Framework

The full system sounds large. The first step is small and concrete.

Take the single process you run most often in your work, the framework you apply to the most common client situation you handle. Write it out using the framework template above. The decision logic, the inputs, the common mistakes, one worked example. Be as precise as you can about how you actually make the decisions, not how you would describe them in a sentence.

Then set up Hermes with Claude, point it at a vault containing that one framework, and run a real past case through it. Compare what the system produces to what you produced when you handled that case yourself.

The gap between those two outputs tells you exactly what to refine. Close that gap, and you have a system that applies one piece of your expertise as well as you do. That single working framework is a product you can sell access to through the managed model today.

Everything after that is adding frameworks and moving up the access models as the system earns your trust.

**Your expertise is currently trapped inside your hours. The first encoded framework is how it starts getting out.**