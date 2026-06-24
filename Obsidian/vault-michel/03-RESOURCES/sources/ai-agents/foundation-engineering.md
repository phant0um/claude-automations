---
title: "构架师教程：Foundation Engineering (地基工程)"
type: source
created: 2026-06-23
updated: 2026-06-23
tags:
  - ai-agents
  - loop-engineering
  - foundation-engineering
  - control-systems
  - type-systems
  - judgment
  - open-tsc
  - source
---

# 构架师教程：Foundation Engineering (地基工程)

**Source:** [X post by @dashen_wang](https://x.com/dashen_wang/status/2069293474206376042) · Published 2026-06-23
**Author:** [dashen.wang](https://dashen.wang/) — "AI 时代最严厉的父亲"
**Series:** 构架师系列 · 地基工程篇 (Architect Series · Foundation Engineering)

## Central Thesis

Loop Engineering is the wrong name. What everyone calls "Loop Engineering" is actually **Foundation Engineering** — the real work is not in the loop (the switch), but in the foundation beneath it: defining "what counts as correct," building multi-layer sensor networks, and sinking judgment into the cheapest possible enforcement mechanisms. A loop is a 1885 thermostat: a closed-loop control system. The only revolution is that the **actuator** changed from specialized (heating coil, compressor) to general and cheap (language model). Everything else — setpoint, sensor, controller, state — is centuries old.

> **A loop is not a way to delegate code. It is a way to delegate judgment.** The real work is making that delegated judgment impossible to forge.

## Structure

### Part 1: Demystification — A Loop is a Thermostat from 1885

A loop is a **closed-loop control system**, identical to a thermostat:
1. **Setpoint** — the goal (26 degrees / "all tests green, zero type errors")
2. **Actuator** — the executor (compressor / coding agent)
3. **Sensor** — the judge (temperature sensor / independent model or type checker)
4. **Controller** — the loop logic ("not there yet, continue")
5. **State** — memory (current room temp / disk state)

Historical timeline:
- 1788: Watt's centrifugal governor (first automatic feedback loop)
- 1885: Honeywell's electric thermostat
- 1948: Wiener's Cybernetics
- Your body: blood sugar, temperature — loops running for millions of years

**The only thing that changed**: the actuator went from "can do one thing" to "can do almost anything" (language model). Execution became abundant and nearly free. What remains scarce: the setpoint and the sensor — "what counts as correct."

> "Something becomes extremely abundant, its price approaches zero; its complementary scarce good skyrockets."

### Part 2: The Real Substance — What a Loop Actually Needs

#### Five Irreducible Parts

1. **Intent (Setpoint)** — where you want it to go
2. **Execution (Actuator)** — the agent that writes code
3. **Judgment (Sensor)** — reads "are we there yet?"
4. **Memory (State)** — lives on disk, not in conversation
5. **Control (Controller)** — the outer shell: not done → another round; done → stop

#### The Brutal Truth: Four of Five Are Free

Execution, control, triggering, and memory are all built into mature tools. **Loop Engineering as a "discipline" — the part that can be taught as a course — is precisely the part that's already free.**

The only part that can't be substituted: **Judgment (the third part).**

> "The scarce skill in the loop era is not writing prompts — that's last era's craft, depreciating fast. The scarce skill is writing 'completion conditions' — legislating."

**Harvey** (legal AI, $11B valuation) proved this: they didn't train a new model, they changed the "cage," not the "horse." When rubric quality is high, agents climb surprisingly well along the correct direction.

#### First Iron Law: The Worker Cannot Grade Itself

A model is the worst judge of its own work — it has a sycophancy bias baked into its weights. The judgment must come from something **independent** from the executor (maker/checker separation).

But one checker isn't enough. You need **falsification**, not verification:
- Verification asks "can it run?" — finds evidence it's right
- Falsification asks "if it's actually wrong, how would I discover that?"

> **Iron Law: No attack path, no severity.** → In loop terms: **No evidence path, no judgment.**

#### The Type Checker as Sensor

`tsc` (TypeScript's type checker) is the cheapest, coldest, most incorruptible judgment sensor:
- It never flatters
- It judges 10,000 times the same as once
- It's nearly free
- Its error messages contain repair instructions ("expected X, got Y at line Z")

**Strong types = high-precision sensors.** `any` is putting a blindfold on your loop.

### Part 3: Granularity — The Watershed Between Amateur and Professional

Judgment isn't about having it or not — it's about **resolution**. There are three granularities that must be aligned:

1. **Task granularity** — how big a chunk per loop iteration
2. **Verification granularity** — how fine the judge can localize failures
3. **Memory granularity** — how detailed the on-disk records are

#### The Nyquist Criterion for Loops

> **Verification granularity must be finer than task granularity.**

Otherwise you get a **Blind Loop** (盲循环): a loop that runs fast, self-iterates, and confidently reports "complete" — but its judgment is too coarse to see its own rot. It delivers a time bomb stamped "completed."

This is the **Nyquist Sampling Theorem** moved to loops: feedback frequency and precision must exceed the change frequency and amplitude, or bugs "alias" into "correct."

#### The Nine-Layer Judgment Ladder

```
Expensive, slow, unreliable, sycophantic
┌──────────────────────────────────────────────────┐
│ 1. Human review          (most expensive)          │
│ 2. LLM as judge          (sycophantic, drifts)      │
│ 3. Visual/multimodal      (screenshots, pixel diff)  │
│ 4. Tests/property tests   (deterministic, needs you)│
│ 5. Runtime behavior       (real requests, concurrency)│
│ 6. Contract/schema/assert (gate at boundary)        │
│ 7. Semantic relations    (who calls who, rename)    │
│ 8. Type checker (tsc)    (free, instant, cold)      │
│ 9. Compiler itself       (can't even compile)       │
└──────────────────────────────────────────────────┘
Cheap, fast, deterministic, cold
```

#### Judgment Descent (判定下沉)

> **The core engineering action of the loop era:** Push "what counts as correct" from the most expensive, slowest, most unreliable layer down to the cheapest, fastest, most deterministic layer.

- What can be judged at layer 8-9 (type/compiler) → never leave to layer 1-2 (human/LLM)
- What can be judged at layer 7 (semantic) → never leave to layer 4 (tests)
- What can be judged at layer 3 (visual) → never leave to layer 2 (LLM judge)

Each layer catches **different kinds of bugs**. Skip a layer, and that layer's bugs become invisible.

#### Memory Granularity: Store Trajectories, Not Snapshots

Correct memory granularity = **events**: who, when, what, result, who said it. Append-only, never modify. This is OpenTSC's spine: **store trajectories, not snapshots.**

### Part 4: Systematization — From a Trick to a World That Never Pauses

A loop is a trick. Systematization turns a trick into an organ — loops that feed, verify, and remember each other, forming something that runs and grows on its own.

#### Loop of Loops = Cybernetic Org Chart (VSM)

Using the Viable System Model (VSM):
- **Operations** (doers) — models/agents
- **Coordination** (don't step on each other) — built-in isolation
- **Control** (verification) — you define standards
- **Intelligence** (what to do next) — you define priorities
- **Policy** (legislation) — **only you**

The lower you go, the less delegable. Policy — legislation — is always only you.

#### Intelligence Layer: Use the World's Implementations as a Mirror

The most valuable intelligence capability: hold your implementation up against a million open-source repos. "How do others handle token refresh? What pitfalls have they hit?" The gap between your implementation and the ecosystem's mirror is a high-value input for your judgment.

#### Calibration Loop: Let the System Face Reality

Two calibration mechanisms:
1. **Awake**: Force predictions with deadlines, then backfill actual results. Did performance really improve?
2. **Asleep**: The system replays past judgments, extracts patterns, validates them on **holdout sets** (unseen tasks). If a pattern performs better on unseen tasks → encode into the codebase. If not → discard.

> **Iron Law: Any judgment encoded into the codebase must pass holdout-set validation.** You can't test yourself with your training set — that's self-hypnosis.

#### Comprehension Debt (理解债)

> Your system produces, but your understanding doesn't grow with production. The gap is comprehension debt.

More dangerous than technical debt: "code runs but I can't understand my own repo." The loop accelerates output but not your understanding — this scissors gap is the growth rate of comprehension debt.

Endgame: you own a company you can't read, a system you're afraid to modify, code that runs but nobody knows why. You're not the legislator — you're the hostage.

> **Systematization's acceptance criterion is not "can run" — it's "can be reviewed."**

### Part 5: TSC Thinking — Compiling Judgment into Machines

The double meaning: `tsc` (TypeScript's type checker) and TSC (the author's philosophy, "the soul, judgment itself).

**Types are the minimal executable version of legislator thinking.** When you write `interface Account { balance: Cents }`, you're legislating: "in my world, account balance must be Cents, not dollars, not string, not undefined." `tsc` enforces this — any loop, any model, any future collaborator that violates it is stopped.

> **Legislation is Programming.** The hottest "programming language" in three years won't compile to CPU — it will compile to "what counts as correct."

### Part 6: The Dog and the Architect

> "In the AI era, even a dog can do development." — the author
> "If ordinary people can't use it, no matter how good the tech, it's waste." — Master Jin (金师傅)

Both are right. Development has been split in two:
- **Execution layer**: once the foundation is built, pressing "start" requires no skill. This is good news — delegate it entirely.
- **Legislation layer**: making "press start" something even a dog can do — building foundations, legislating, defining "what counts as correct," sinking judgment, aligning granularity, laying nine sensor layers, building reviewable memory, guarding calibration, paying off comprehension debt, building the translation layer for ordinary people. This is the real engineering — **surrender not one inch.**

### Part 7: Predictions for Three Years Out

1. **IDEs will die** — "environments" become the product. Work unit shifts from "file" to "intent." Developer splits into: Legislator, Loop Rancher, and the dog that presses start.
2. **Judgment Coverage** — a new metric replacing test coverage. "How much of your 'what counts as correct' is encoded into deterministic machine-checkable layers?" This will predict company survival better than PE or DAU.
3. **Feedback Infrastructure** — a new category. CI/CD automated delivery; the next decade automates judgment. Multi-modal sensor networks (types, call relations, runtime behavior, pixel diff). The model arms race ends; the feedback infrastructure arms race begins.
4. **Economy splits along the Verifiability Line** — highly verifiable work (backend logic, migrations) becomes nearly free; low-verifiability work (taste, aesthetics, whether to do it, human relationships) becomes expensive.
5. **Blind Loop Catastrophe** — within 18-30 months, a series of production disasters traced to blind loops. Survivors will be those who built deep foundations today.
6. **Moats Move from Models to Memory** — the most valuable AI company in 2029 won't have the strongest model. It will have the deepest judgment存量, the most accurate calibration, the most reviewable append-only memory stream.
7. **Judgment-as-Code** — a new "programming" where you write not implementations but judgments, compiled into loop self-verification rubrics. Legislation is programming.

## The New Name

> Not Loop Engineering. **Foundation Engineering (地基工程).**

Because all development, from Watt's governor to today, has always been one thing: **laying foundations.** AI didn't change that — it just made the building above the foundation go up so fast that even a dog could build it. So the foundation itself, for the first time, became the only thing that matters.

> "Build your loop. But build it like someone who intends to remain an engineer, not like a dog that only presses 'start.'"

## Minha Síntese

Um dos textos mais densos e ambiciosos sobre engenharia de agentes de 2026. dashen.wang argumenta que "Loop Engineering" é um nome errado — o nome correto é **Foundation Engineering** (地基工程), porque todo o valor está no que está *abaixo* do loop, não no loop em si. A tese central alinha perfeitamente com [[03-RESOURCES/sources/ai-agents/loop-engineering-delegating-judgment-not-code]] (ambos defendem que o loop delega julgamento, não código), mas vai muito mais fundo ao mapear uma **escada de nove camadas de julgamento** e propor "judgment descent" como ação central: empurrar "o que conta como correto" das camadas caras e lentas (humano, LLM) para as baratas e determinísticas (tipo, compilador). O conceito de **Blind Loop** (盲循环) — um loop que executa rápido mas cuja granularidade de verificação é grossa demais para ver a própria podridão — é o equivalente de "comprehension debt" do artigo do @leanxbt, mas formalizado via Nyquist Sampling Theorem. As sete previsões são notavelmente ousadas e internamente consistentes: a economia se racha pela "linha de verificabilidade," feedback infrastructure substitui CI/CD, e moats migram de modelos para memória. Para o vault, este texto é a contrapartida teórica/chinesa do artigo do @leanxbt — mesmo insight fundamental, tradição intelectual diferente. O conceito de "judgment coverage" como métrica que substitui "test coverage" vale indexar como conceito.