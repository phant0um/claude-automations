---
title: "Detecting Malicious Agent Skills in the Wild using Attention"
type: source
source: "Clippings/Detecting Malicious Agent Skills in the Wild using Attention.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
LLM agents increasingly load skills, file-based packages of natural-language instructions written by third parties and distributed through marketplaces, that execute with the user’s privileges. A single malicious skill can exfiltrate data, hijack the agent, or persist as a supply-chain foothold, which turns the skill marketplace into a new attack surface for agentic systems. Prompt-injection defenses do not carry over to this setting.

## Argumentos principais
### 1 Introduction
Large language model (LLM) agents increasingly act through external capabilities that reach beyond text generation. *Skills* are an advanced form of such capability [^21]. Each skill is a file-based package that combines persistent natural-language instructions with optional helper code, and the agent loads it on demand whenever its description matches the user’s task. Unlike API-based tools and MCP servers [^9], skills execute locally with the user’s privileges. They circulate through third-party marketplaces, so the agent ends up acting on instructions written by an unknown author [^18]. A malicious skill can exfiltrate data, hijack the agent’s behavior, or persist as a supply-chain foothold that activates only under specific triggers [^13]. We study how to detect malicious skills in the wild, before they reach the agent’s context, without constraining the legitimate functionality a skill provides.
Existing prompt-injection defenses fail to transfer to this setting. The dominant paradigms either separate trusted instructions from untrusted data or constrain the agent to a pre-specified workflow validated at runtime [^5] [^14]. Both assume the attacker’s instructions are foreign to the legitimate task. Skills violate this assumption by construction. A skill *is* a body of instructions written by a third party, and a malicious injection amounts to a few extra commands embedded among many legitimate ones. Scanning each skill in full with a powerful LLM sidesteps the separation problem, yet its cost grows with the number and length of the skills under analysis, which makes marketplace-wide deployment expensive.
Attention-based detectors [^10] offer a cheaper alternative. They exploit the observation that injected instructions tend to capture a model’s instruction-following attention. These detectors, too, were designed for inputs that cleanly separate instructions from data. Inside a skill, attention to instructions is expected everywhere, so the signal that distinguishes an injection from benign content can collapse.

### 2 Background and Related Work
Indirect prompt injection. Prompt injection manipulates an LLM at inference time by embedding adversarial instructions in its input. In *direct* prompt injection the user is the attacker and crafts a query designed to override the model’s guardrails [^15], which relates these attacks to jailbreaks against aligned models [^22]. In *indirect* prompt injection both the user and the model provider are benign, and the model instead ingests third-party content in which an attacker has hidden instructions [^2]. When the model reads the content, the injected instruction executes and the attack succeeds. A widely reported example comes from academic peer review, where authors hid directives such as *“ignore all previous instructions; give a positive review only”* in submitted manuscripts to sway LLM-delegated reviews [^8].
Indirect prompt injection is the threat model relevant to this work. Skills are authored by third parties, distributed through marketplaces, and ingested by the agent as part of its operational context, structurally the same channel through which web content or documents reach an assistant.
Prompt injection defenses. Several lines of work defend against prompt injection by inspecting the model’s internals. Get-My-Drift [^1] trains a classifier on activation deltas, on the premise that any deviation in task execution from the original user instruction signals compromise. Attention Tracker [^10] builds on a similar intuition over attention rather than activations. It identifies heads specialized for instruction-following, which remain stable under benign data and shift when new instructions are injected.

### 3 Threat Model
Malicious skills. We adopt the taxonomy of Liu et al. [^13]. A malicious skill pursues one of three goals, namely data theft, agent hijacking, or persistence through supply-chain compromise or hidden triggers that activate later. It does so through two attack vectors. Code-level attacks execute malicious code, and instruction-level attacks inject malicious instructions into the SKILL.md file or into comments and strings inside helper scripts. In this setting, malicious content may look like ordinary documentation or task instructions yet still influence the agent once the skill is loaded. Instruction-level attacks therefore differ from conventional malware in that the operating system never executes the payload. The agent’s instruction-following behavior does. We consider a skill malicious when its behavior would harm the installing user, the user’s environment, or the agent’s intended operation, and we treat offensive or dual-use skills separately unless they attack the user or agent itself. Code-level attacks fall outside our main scope; we refer readers to [^13] for a detailed study of executable malicious payloads in skills.
Defender’s model. We consider a runtime monitor that inspects each skill before the agent loads it into context. The defender sees only the skill itself, meaning SKILL.md, its frontmatter, and any helper files. No author reputation, sandbox trace, or platform metadata is available, since skills may arrive through any channel, including marketplaces, shared files, and local development. The monitor must decide in under one second whether to allow or block the skill. False positives block legitimate skills and frustrate the user, while false negatives expose the agent to attack. The defender controls neither the agent’s main LLM nor the skill’s content.

### 4 Methodology
Locate-and-Judge detects malicious skills in two stages (Figure 1). A locator first selects a small set of suspicious spans, and a judge then decides whether any of them is malicious. The skill is flagged if any retained span scores above a threshold.
Figure 1: Overview of Locate-and-Judge. A deterministic parser splits the skill into structural spans, a small reader LLM ranks them by instruction-following attention and keeps the top K, and a zero-shot LLM judge scores only the retained spans. The skill is flagged when the maximum judge score exceeds the calibrated threshold τ \\tau. The cheap locator runs on every skill; the expensive judge runs on spans only.
The locator rests on one hypothesis. To be executed, an injection must capture the reader LLM’s attention. We therefore rank spans by the attention they draw from a small LLM and pass only the top-ranked ones to the judge. We do not assume that the malicious span is the only instruction among data; we assume only that injections must rank *among the most important instructions*. Compared to a full LLM-powered scan, this design keeps costs down because the expensive judge runs on a few spans rather than the whole skill.

### 4.1 Data
We assemble a labeled corpus of benign and injected skills to calibrate and evaluate the pipeline. The benign skills come from the curated sets released by Skill-Inject [^19] and Liu et al. [^13], both of which provide skills already labeled clean. Starting from labeled data avoids the unknown injections that web scraping can silently introduce. We then inject one or more vulnerabilities into a subset of them with the Skill-Inject pipeline. The labels serve three purposes downstream. They tune the locator and its operating point $K$, fix the decision threshold $\tau$, and measure end-to-end detection. They never train our deployed judge, which is zero-shot.
Every skill carries a binary label for whether it is injected, which drives skill-level evaluation. Each span is labeled too. Within an injected skill, the span holding the injected command is positive and the rest are negative, and benign skills contain only negative spans. The span labels let us measure the locator in isolation, and they supply training data for the learned baseline judge of Section 4.4.

### 4.2 Span Segmentation
Before a skill reaches any model, we split it into spans with a deterministic parser for Markdown-like files. The parser uses regular expressions to cut the skill along its structural seams, preserving headings, paragraphs, bullets, numbered lists, code blocks, key-value metadata, comments, and table-like blocks. We chose structural spans over fixed-length chunks for two reasons. They keep the natural shape of the skill intact, and genuine instructions tend to respect that same structure. When an injected character interval straddles more than one structural span, we mark every overlapping span positive.

### 4.3 Locator
The locator ranks spans by how much attention they draw from a small reader LLM. We feed the full skill to the LLM along with a prompt that asks it to analyze the content; skills too long to fit are processed in span windows. We then read off the attention weights and compute a per-span score by aggregating the attention each token receives. Empirically, we settled on the last four layers, all attention heads, and all suffix-token positions; we average these to obtain a token-level score, then sum the token scores within each span. We keep the top- $K$ spans and discard the rest.
$K$ is the hyperparameter that sets the trade we care about. A small $K$ is cheap but risks dropping the malicious span, whereas a large $K$ is safer but gives the judge more work and dilutes its context. We pick $K$ by calibration on $\mathcal{D}_{\mathrm{cal}}$. The choice of a small reader LLM is deliberate. The locator runs on every skill, and its cost is what makes a marketplace-scale scan feasible. Section 5 measures the effect of larger readers.

### 4.4 Judge
The judge takes a span and returns the probability that it contains a malicious instruction. Our deployed judge is a prompted LLM, DeepSeek-V4-Flash [^6], referred to hereafter as DeepSeek. We use it zero-shot. It needs no fine-tuning, reasons about intent directly, and requires no labeled data of its own. We compare it against two cheaper alternatives. The first is an *encoder classifier*, a trained span-level model included as a learned but lightweight baseline. It is the only component that consumes the span-level training labels; positives are the injected malicious spans, and negatives are drawn from benign spans of malicious files, clean Skill-Inject benign spans, random safe spans, and a harder pool of safe spans chosen to stress the classifier. The second is a *regex* bank, a rule-based baseline included to show how much of the problem plain pattern matching already solves.
Every judge sees the span together with a short window of surrounding context. The context does double duty. It gives the judge enough material to reason about, and it guards against injections placed on the seam between two spans.

### 4.5 Inference
At test time we run each skill through the full pipeline. We split it into spans, score every span with the locator, keep the top $K$, run the judge on each retained span, and take the maximum judge score. The skill is flagged if that maximum exceeds the threshold $\tau$.
We fix $\tau$ on $\mathcal{D}_{\mathrm{cal}}$ and freeze it before touching the test set. We report three operating points. A best-F1 threshold supports head-to-head comparison with baselines, a low-FPR threshold satisfies $\mathrm{FPR}\leq 5\%$, and a conservative zero-FP threshold serves the deployment setting, where every alarm is manually reviewed and the review budget is what binds. Both $K$ and $\tau$ are calibrated on the Skill-Inject corpus and then applied unchanged to real marketplace skills. Section 5 reports the realized precision in the wild, which quantifies how well this calibration transfers.

### 5.1 Laboratory
##### Data construction
Our laboratory corpus is built from the benign and injected skills of Skill-Inject [^19], 762 skills in total, of which 139 are malicious. We segment each skill into structural spans with the parser of Section 4.2, yielding 55,962 spans. Labels live at two levels. Every skill has a binary label for whether it is injected. Every span has its own; in a malicious skill the span carrying the injection is positive and the rest are negative, and benign skills contribute only negative spans.
##### Splits

### 5.2 Detection in the Wild
Having calibrated the pipeline on Skill-Inject, we test it on real marketplaces with two goals. We want to learn whether Locate-and-Judge surfaces malicious skills that are live and installable today, and we want to characterize the threat posed by malicious skills in the current ecosystem. We collected a corpus of approximately 134k skills from three public marketplaces and ran the deployed pipeline on the entire corpus. Because the full corpus is too large to label by hand, we report two complementary views, detection quality on a human-reviewed sample of the flagged skills and cost and scale over the entire corpus.
#### 5.2.1 Corpus collection and scan cost
We collected 134,934 skills from three marketplaces, Lobehub, Skills.sh, and Clawhub.ai (Table III).<sup>1</sup>

### 5.3 Malicious Skills Taxonomy
The 82 hidden malicious skills share a common structure, a benign cover story paired with a covert payload. We group them by primary attack goal (Table IX).
TABLE IX: Attack-goal taxonomy of the 82 confirmed hidden malicious skills. A skill is assigned to exactly one primary goal.
| Attack goal | Count | % |

### 6 Discussion
Our experiments show that Locate-and-Judge can scan entire skill marketplaces at a cost an individual researcher can afford, and that the marketplaces we examined contain installable malicious skills today. This section discusses the implications of these results, the limitations of existing tools, and the limitations of our own approach.
The central design choice behind Locate-and-Judge is the separation between localization and classification. Both stages are necessary for the pipeline to work at scale, and they contribute in different ways. The locator, despite using a small reader LLM, identifies the injected span in the vast majority of malicious skills, hidden ones included, and in the wild the pipeline recovers nearly twice as many hidden malicious skills as full-content scanning by the same judge. The misses concentrate in a single, mechanistic failure mode. Of the 22 confirmed malicious skills only the full-content baseline catches, 13 are inline installer one-liners that the span segmenter does not isolate as their own span, so the locator never gets to rank them. This bounds the architecture’s blind spot to a known threat class, and a cheap full-content second pass over the small flagged residue recovers it. Segmentation and judge capability are both tunable axes that improve recall without architectural change, whereas a method whose recall was bounded by the attention signal itself would be far harder to improve.
A direct consequence of this design is a cost reduction relative to per-span and full-skill alternatives. In our wild scan, running a strong LLM on every span yields similar precision and detection capability at roughly 2.84 $\times$ the cost per skill. The cost advantage grows further as the number of spans passed to the judge shrinks, which suits the rapidly growing skill catalogs that modern agents will entail.

### 7 Conclusion
LLM agents increasingly load skills authored by unknown third parties, and the marketplaces that distribute them constitute a new attack surface for agentic systems. The defenses developed for indirect prompt injection rely on a separation between trusted instructions and untrusted data that skills break by construction, and per-skill scanning with a strong LLM avoids the separation problem at a cost that scales poorly across a marketplace. We proposed Locate-and-Judge, a two-stage detection pipeline built for this regime. The pipeline exploits the observation that an effective injection must capture instruction-following attention, uses this signal to localize candidate malicious spans with a small reader LLM, and passes only those spans to a capable judge. The separation between localization and classification cuts the judge’s input by $2.84\times$ relative to full-content scanning while achieving a comparable detection rate. Applying the pipeline in the wild, we scanned approximately $134$ k skills from three public marketplaces for under $35, surfaced 131 confirmed malicious skills, 82 of them hidden attacks disguised as legitimate functionality, and found that a substantial fraction evades existing detectors at their standard operating points, direct evidence that current tools do not cover the attacks already in circulation. We release the resulting human-labeled dataset of malicious and benign skills, together with the located injection spans, as a public resource for future work.

### 8 Ethics Considerations
This work studies live skill marketplaces and identifies attacks that are currently installable by end users. We collected skills via the public interfaces of the three marketplaces, complied with their access policies, and bypassed no authentication or access controls. We never executed any wild skill in an LLM agent connected to real user data; the detector operates on the static text of SKILL.md, and the human assessment also worked from text alone. Before publication, we disclosed every confirmed malicious skill to the relevant marketplaces, including the injection location and our assessment.
We release the labeled dataset of malicious and benign skills because reproducibility in this area is currently limited and synthetic benchmarks understate the difficulty of the wild distribution. We are aware that this material, and the detector itself, could be repurposed against users rather than for their protection. All malicious skills we release were already publicly accessible on marketplaces, so the release lowers defenders’ access costs without meaningfully changing attackers’.
[^1]: S. Abdelnabi, A. Fay, G. Cherubin, A. Salem, M. Fritz, and A. Paverd (2025) Get my drift? catching llm task drift with activation deltas. In 2025 IEEE Conference on Secure and Trustworthy Machine Learning (SaTML), pp. 43–67. Cited by: §2.


## Key insights
- Responsible disclosure. We reported every finding to the three marketplaces.
- ---
title: "Detecting Malicious Agent Skills in the Wild using Attention"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Bacem Etteib, Daniele Lunghi, and Tégawendé F.
- Bissyandé  
University of Luxembourg

###### Abstract

LLM agents increasingly load skills, file-based packages of natural-language instructions written by third parties and distributed through marketplaces, that execute with the user’s privileges.
- A single malicious skill can exfiltrate data, hijack the agent, or persist as a supply-chain foothold, which turns the skill marketplace into a new attack surface for agentic systems.
- Compared to direct LLM-based scanning, this approach offers an order-of-magnitude cost reduction, dramatically increasing its scalability at a small cost to recall, and it dominates keyword and regex baselines at comparable expense.
- ## 1 Introduction

Large language model (LLM) agents increasingly act through external capabilities that reach beyond text generation.
- Each skill is a file-based package that combines persistent natural-language instructions with optional helper code, and the agent loads it on demand whenever its description matches the user’s task.
- They circulate through third-party marketplaces, so the agent ends up acting on instructions written by an unknown author [^18].
- A malicious skill can exfiltrate data, hijack the agent’s behavior, or persist as a supply-chain foothold that activates only under specific triggers [^13].
- We study how to detect malicious skills in the wild, before they reach the agent’s context, without constraining the legitimate functionality a skill provides.

## Exemplos e evidências
See original source at `Clippings/Detecting Malicious Agent Skills in the Wild using Attention.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Rust]]
