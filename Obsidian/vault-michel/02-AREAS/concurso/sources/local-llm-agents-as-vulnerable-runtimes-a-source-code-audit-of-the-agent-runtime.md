---
title: "Local LLM Agents as Vulnerable Runtimes: A Source-Code Audit of the Agent Runtime Layer"
type: source
source: "Clippings/Local LLM Agents as Vulnerable Runtimes A Source-Code Audit of the Agent Runtime Layer.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
Local LLM agents such as OpenClaw and Nanobot run directly on end-user machines and act on host resources—the shell, filesystem, browser, stored credentials, and messaging applications—through natural-language goals. In effect, these agents have become privileged software runtimes that mediate between user intent, model outputs, and host-level actions. Existing research has characterized this landscape through prompt injection, malicious skills, marketplace risks, or black-box behavioral evaluat

## Argumentos principais
### 1 Introduction
Local LLM agents, such as OpenClaw [^25] and Nanobot [^12], operate directly on end-user machines to execute natural-language goals by planning, reasoning, and acting. Unlike developer tools and SDKs (e.g., LangChain [^14] or LlamaIndex [^15]), these agents are end-user installable programs with direct access to host resources, including the shell, filesystem, browser, stored credentials, and messaging applications.
This deep system integration changes what these agents fundamentally are. A local LLM agent is not merely a model wrapper or a tool-use policy; it is a privileged software runtime. It accepts untrusted input, constructs prompts, parses model output, dispatches tool calls, loads third-party skills, writes to memory, opens network connections, and enforces permissions, all while holding direct authority over the user’s machine. The implementation components such as prompt builders, parsers, tool dispatchers, skill loaders, memory writers, network clients, and permission gates are mediating between natural-language goals, model outputs, and host-level actions. Together, these components form the software runtime of the agent and require systematic auditing.
However, existing works on LLM-agent safety study risks at the ecosystem or behavioral level. One line of work analyzes the malicious skills and unsafe agent actions in marketplace ecosystems [^16] [^11] [^2] [^13], while another conducts black-box behavioral measurements of agents under emerging attacks and defenses [^10] [^26] [^6]. Both treat the agent as a closed box and reason about its inputs and outputs. No prior work has systematically opened the agent’s own source tree to audit the runtime components. As a result, this runtime layer remains an unexamined safety boundary.

### 2.1 Local LLM Agents as Privileged Runtimes
Local LLM agents differ from developer frameworks and SDKs in a way that is easy to overlook but central to their risk profile. Those frameworks are libraries: a developer imports them, supplies the surrounding application, and decides what privileges the resulting program holds. Local agents such as OpenClaw [^25], Nanobot [^12], and PicoClaw [^23] invert this relationship. They ship as complete, end-user installable programs that already contain the planning loop, the tool integrations, and the host bindings, and they run with the full privileges of the user who launches them.
This makes a local agent a software runtime in the conventional system sense: a long-lived process that ingests untrusted input, transforms it through several internal stages, and emits privileged actions on the host. The input is a natural-language goal; the privileged actions include executing shell commands, reading and writing arbitrary files, driving a web browser, sending and receiving messages, and using stored credentials such as API keys and passwords. Between input and action lies a pipeline of implementation components, the prompt builder, parser, tool dispatcher, skill loader, memory writer, network client, and permission gate, each of which inspects or rewrites data on its way to the host. We refer to this pipeline collectively as the agent runtime. Crucially, every stage in it executes with the same host privileges as the agent as a whole, so the runtime offers no internal privilege boundary that would contain a fault in any single component.

### 2.2 Existing Agent-Safety Perspectives
The risks of LLM agents have drawn growing attention, and current efforts cluster around three concerns. The first is the *model*: prompt injection and jailbreaks, where adversarial texts hidden in instructions, retrieved documents, or tool results steer an agent into unintended actions [^10] [^26] [^6]. The second is *third-party content*: the skills and marketplaces that local agents draw on, where malicious entries appear at scale, over 300 malicious skills on repositories such as ClawHub [^13], and hundreds more that exfiltrate credentials through the model context [^2]. The third is the *agent as a whole*, treated as a black box and measured by its end-to-end behavior in deployment, where tens of thousands of instances have been found exposed online and open to remote code execution [^5].
What these concerns share is their vantage point: each reasons about the agent through its inputs, prompts and skills, or its outputs, observed behavior, while taking the code that mediates between them to be correct. The implementation that performs that mediation—the runtime (as defined in Section 2.1)—has not itself been treated as an object of security analysis.

### 2.3 Why Runtime Auditing Matters
A local agent’s safety is usually argued one component at a time: the model is aligned, the skills are vetted, the sandbox confines the shell. None of these arguments covers the code that sits between the components. The agent runtime is what parses an instruction into a structured intent, assembles that intent into a prompt, reads the model’s reply, selects a tool, marshals its arguments, writes the result into memory, and checks a permission before the call goes through. A model that refuses a dangerous request does not help if the parser strips the refusal; a benign skill does not help if the loader runs its setup hook before the permission gate; a sandbox does not help if the dispatcher resolves the tool path outside it. The components can each be correct and the agent still be unsafe, because what matters is whether the runtime preserves the guarantees the components assume.
These are ordinary software faults: an unsanitized prompt builder may be an injection sink, a parser that evaluates a model-emitted argument may correspond to CWE-94 (Improper Control of Generation of Code (’Code Injection’)), a skill loader that unpickles a marketplace payload may correspond to CWE-502 (Deserialization of Untrusted Data), and a permission gate placed after its side effect may be a check that runs too late. What makes them different from the same bugs in an ordinary program is the authority behind them. The runtime holds the shell, the filesystem, and the user’s stored credentials, so a missing check is not a contained defect but a direct path from untrusted input to a privileged action on the host. The marketplace skills and exposed deployments discussed in Section 2.2 place pressure on exactly this layer: the input arrives from outside, but the severity of what follows is decided inside the runtime, by whether the loader inspects what it runs and the dispatcher constrains what it invokes. That is the layer prior work leaves unaudited, and the layer this paper aims to address.

### 3 Agent Runtime Vulnerability Taxonomy
As noted earlier (Section 2), the agent runtime is a privileged layer whose implementation has gone unaudited. To audit it, we first need to know which weaknesses to audit for. This section answers that question by building a taxonomy of the implementation-level vulnerabilities that can arise in a local agent runtime: we derive the categories from a threat model rather than naming them by intuition (Section 3.1), then define each one in terms of the runtime component it implicates (Section 3.2). The result is the set of targets the rest of the paper aims to detect.

### 3.1 Deriving the Taxonomy from STRIDE
Auditing a class of software that has not been audited before raises a prior question: “what should we look for"? Enumerating vulnerability categories by intuition risks both omission and overlap, so we instead derive them from STRIDE [^17], a threat-modeling framework [^22] that classifies threats into six categories and applies them to each trust boundary in a system’s data-flow diagram. STRIDE gives us a principled way to move from the runtime’s structure to the weaknesses that structure admits.
We begin by constructing the data-flow diagram of the OpenClaw agent runtime. Three trust boundaries dominate it. The first is where user input enters the agent core. The second is where the core hands work to tool and skill execution. The third is where the agent reaches out to external resources over the network. These are the points where the runtime takes in something it does not control and turns it into something privileged, which is exactly where STRIDE directs attention.
At each boundary we asked three questions: (i) what attacker-controlled data crosses it, (ii) what privileged operation follows once the data is across, and (iii) what implementation component mediates that transition. The first question locates the untrusted input, the second locates the consequence, and the third names the runtime component an auditor would actually inspect. Answering these three questions at the three boundaries is what turns an abstract threat model into a set of concrete code-level targets, and it is the step that ties the taxonomy to the runtime components defined in Section 2.1.

### 3.2 Resulting Taxonomy
Each category corresponds to one of the three questions answered at a trust boundary: an untrusted input, a privileged operation it reaches, and the component that should have stood between them.
CAT-1: Prompt Handling. Untrusted text enters prompt construction or memory. The agent assembles its prompt from user goals, retrieved documents, tool outputs, and stored memory, and any of these can carry instructions the developer never intended the model to follow. The mediating components are the prompt builder and the memory writer. A weakness here lets external text reach the model as if it were trusted instruction, whether in the current turn through injection or in a later turn through contaminated memory.
CAT-2: Tool/Skill Execution. Model- or user-controlled data influences the filesystem, the shell, or skill loading. Once the model decides to act, the runtime turns its output into concrete operations: it resolves a path, builds a shell command, or loads a skill module. The mediating components are the tool dispatcher and the skill loader. A weakness here lets a crafted argument or a malicious skill escape the intended operation, producing the path traversal, command injection, and unsafe-load patterns familiar from ordinary software but reached here through model output.

### 3.3 Formulating Trust Boundaries around the Taxonomy
The five categories above, derived from STRIDE, also admit a complementary reading as the trust boundaries crossed by data on its way through the agent runtime. Each category $C_{i}$ corresponds to a boundary $B_{i}$ where a particular class of untrusted data meets a particular class of privileged operation. Each boundary corresponds to a sanitization barrier, guarding a distinct sink class and answering one yes/no question at runtime.
$B_{1}$  Pre-prompt Sanitization (CAT-1)
Sinks. prompt builder; memory writer.

### 3.4 Taxonomy Scope
This taxonomy is not intended to exhaust all possible agent failures; it captures the implementation-level weakness classes observable in disclosed OpenClaw advisories and relevant to static auditing. Failures that arise only at runtime, that depend on the model’s semantic judgment, or that live outside the runtime in the model weights or the surrounding deployment fall outside its scope, and we return to several of these as limitations in Section 9.
Figure 1: Overview of ClawAudit ’s taxonomy → \\rightarrow rule benchmark pipeline. The framework derives an agent-runtime taxonomy, encodes domain-specific static-analysis rules, and evaluates them against disclosed source-code-level advisories.

### 4.1 Overview
As shown in Figure 1, ClawAudit is a static auditing framework for local LLM agent runtimes. It consists of three stages:
1. Taxonomy-guided vulnerability modeling (Section 3);
2. Domain-specific rule construction in two static-analysis backends, Semgrep (YAML pattern rules) and CodeQL (Datalog queries over a relational program representation);

### 4.2 Rule Development
For each taxonomy category, we inspect vulnerable code snapshots from disclosed advisories (Section 5.1) and identify recurring implementation structures. We then encode each structure twice, as a Semgrep YAML rule and as a CodeQL query, so that every ClawAudit rule has parallel implementations in both backends.
- The Semgrep rule expresses the pattern as a syntactic template over the AST with metavariable regular expressions constraining identifier names and pattern-not-inside clauses excluding common safe surroundings.
- The CodeQL query expresses the same pattern as a declarative predicate over the program’s relational representation, typically including a small auxiliary predicate that captures the absence of a sanitizing guard in the enclosing function.

### 4.3 Advisory-Level Detection and Attribution
ClawAudit produces raw static-analysis findings rather than advisory-level labels. A raw finding is a tuple consisting of a rule identifier, file path, line number, and matched code snippet. To evaluate whether such findings recover disclosed vulnerabilities, we define an attribution rule that maps raw findings to advisories in OpenClawBench.
For each advisory, we identify the files modified by its fix commit. A configuration is considered to detect the advisory if it emits at least one finding in one of these modified files when run on the vulnerable revision of the agent runtime. We use this file-level attribution for two reasons. First, many fixes restructure the vulnerable function, move validation logic into helpers, or modify call sites rather than the original sink, making line-level or hunk-level matching brittle. Second, advisory patches often touch the nearest repair location rather than every location causally involved in the vulnerability, so requiring a finding to fall exactly inside the edited hunk would under-count detections that correctly flag the vulnerable operation nearby.
This attribution rule is intentionally recall-oriented. It asks whether a rule set points the auditor to a file implicated by the disclosed fix, not whether the exact vulnerable expression has been localized with proof-level precision. The choice has two limitations. It may over-count detections when a modified file contains unrelated risky patterns that are not the vulnerability fixed by the advisory. It may also under-count detections when the true root cause lies outside the files modified by the fix commit, for example when the patch repairs a downstream guard while the analyzer reports an upstream source. We therefore treat file-level attribution as an approximation suitable for comparing recall across rule sets, and separately evaluate live-code finding volume and manual precision in Section 6.5 to characterize triage cost.

### 5.1 Data Collection
We construct OpenClawBench from publicly disclosed GitHub Security Advisories (GHSAs) associated with the OpenClaw repository. Starting from the GitHub Security Advisories REST API, we fetched all 602 published advisories covering the period of 2026-01-31 through 2026-05-15.
For each advisory, we recovered the fix commit by joining against the OSV.dev database (which exposes fix-commit references that the GitHub advisory API does not). We then used the parent of the fix commit as the vulnerable revision and downloaded each modified file at that revision. After excluding 130 advisories whose fix commits could not be recovered, and 26 whose snapshots contained no scannable JavaScript or TypeScript, we retained 446 advisories with vulnerable source-code snapshots. For each resulting advisory we record the advisory identifier, the vulnerable source-code snapshot, the modified file set, the CWE label, the severity level, and the publication date.

### 5.2 Temporal Train/Test Split
To measure generalization to vulnerabilities unseen during rule development, we partition the 446 advisories temporally rather than randomly. We fix 2026-04-01 as the cutoff: 229 advisories published before the cutoff form the *rule-derivation set* (train), and 217 advisories published on or after the cutoff form the *held-out test set*. Rule development used only the 229 train advisories, and the 217 test advisories were collected only after all rules had been committed. The held-out test set is evaluated exactly once, without iteration, mirroring real-world deployment where rules are written from past disclosures and applied to future, never-seen vulnerabilities. Also, no advisory text, vulnerable snapshot, patch diff, or file path from the test partition was inspected during rule writing. The CWE distribution of test advisories was not known during rule development either.

### 5.3 Benchmark Statistics
#### Severity, CWE, and category labels.
Every advisory in OpenClawBench carries three labels we treat as ground truth: a severity bucket, a CWE class, and a taxonomy category. The severity bucket and CWE class come directly from the advisory’s GHSA metadata as assigned by the OpenClaw maintainers and the GitHub Security Advisories reviewers; we do not re-classify them. The four severity buckets correspond to CVSS v3 score ranges, namely *critical* (CVSS $\geq 9.0$), *high* (CVSS $7.0$ – $8.9$), *medium* (CVSS $4.0$ – $6.9$), and *low* (CVSS $0.1$ – $3.9$); their CVSS provenance makes them comparable across advisories without requiring our own judgment. The taxonomy category is the one extra label we attach, assigned by walking the boundary decision procedure of Section 3.3.
#### Distributions.


## Key insights
- The Semgrep rule expresses the pattern as a syntactic template over the AST with metavariable regular expressions constraining identifier names and pattern-not-inside clauses excluding common safe surroundings.
- The CodeQL query expresses the same pattern as a declarative predicate over the program’s relational representation, typically including a small auxiliary predicate that captures the absence of a sanitizing guard in the enclosing function.
- Semgrep Baseline: Semgrep Pro with --config auto, covering ${\approx}2{,}815$ built-in and community rules.
- Semgrep + ClawAudit: the Semgrep baseline augmented with ClawAudit’s 47 domain-specific (i.e. agent-runtime-specific) YAML rules.
- CodeQL Baseline: the javascript-security-extended query suite, covering 104 built-in queries.
- CodeQL + ClawAudit: the CodeQL baseline augmented with ClawAudit’s 30 domain-specific (i.e. agent-runtime-specific) queries.

## Exemplos e evidências
See original source at `Clippings/Local LLM Agents as Vulnerable Runtimes A Source-Code Audit of the Agent Runtime Layer.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Rust]]
