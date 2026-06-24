---
title: "Lingering Authority: Revocable Resource-and-Effect Capabilities for Coding Agents"
type: source
source: "Clippings/Lingering Authority Revocable Resource-and-Effect Capabilities for Coding Agents.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
Coding agents often receive broad tool access for an entire task, even when a resource is needed only for one subgoal. We call this gap lingering authority: a temporary resource/effect capability remains exposed after the episode that justified it has closed. Portico is a reference monitor for revocable capabilities exposed to the planner.

## Argumentos principais
### 1 Introduction
Coding agents turn natural-language tasks into tool calls over repositories, tests, shells, package managers, network clients, and version control. They often start with more authority than the task needs. The key problem is temporal: authority justified for one subgoal can become stale once that subgoal closes. If the agent later uses this stale authority, the planner-tool interface has exposed *lingering authority*: a temporary resource/effect capability that remains exposed after the grant episode that justified it closed.
Consider a task that propagates a timeout from src/api.py to src/serialization.py. The initial phase needs the API file, the focused API test, and the test command. The contract declares serialization access as an on-demand boundary capability. A planner request may select that declared rule, but it cannot create new authority. A plausible note such as notes/packaging.md is outside the task. The desired behavior is to deny the note, grant serialization authority for the boundary episode, and revoke that authority when the episode closes. A static allowlist or sandbox may make the serialization file reachable for the whole run. The security question is whether it should remain available to the planner for the whole run.
Existing defenses address adjacent layers: hostile content or proposed actions \[promptinjection, injecagent, asb, toolemu, agentdojo, agentharm, agentalign, toolhijacker, promptarmor, llamafirewall\], tool and protocol trust \[mcp\_landscape, breakingprotocol, securingmcp, smcp, mcpsecbench, mcptox, systematicmcp, mcpitp, ama, maltool\], and reachability or execution checks after tool selection \[isolategpt, sandboxescapebench, agentcgroup, ace, saga, agentspec, pcas, maris, miniscope, agentbound, progent, cmtf, racg\]. They leave an earlier choice open: which otherwise admissible authority should be visible to the planner now, and when should temporary authority disappear? If a broad read option remains in the planner interface, the model can keep planning around it even when a later monitor would reject some calls. The exposed interface is therefore part of the security state.

### 2 A Concrete Authority-Lifecycle Trace
The running timeout task exposes lingering authority with one false side request and one legitimate boundary request. The task is to propagate an optional timeout parameter from src/api.py into src/serialization.py. At the start, the planner only needs the API file, the focused API test, and pytest. The serialization file is declared as an on-demand boundary capability; a planner request can select that existing rule for evaluation but cannot create the rule. Packaging notes such as notes/packaging.md are outside the task. Table 1 gives the step-by-step trace.
Table 1: Timeout-propagation authority trace.
| Step | Planner event | Portico decision and visible capabilities |

### 3 Problem and Threat Model
We study authority exposure before a tool call runs. The planner is untrusted: it proposes tool invocations, and the runtime arbiter decides which invocations exist on the mediated interface and which ones may execute. Host isolation is held fixed. Our question is which task capabilities should be exposed now, and when temporary authority should disappear. The running example and Figure 1 illustrate the distinction: reachability, execution-time denial, plan integrity, and task-wide legitimacy still leave open which capabilities are exposed at the current phase. With host and sandbox fixed, planner outputs are untrusted requests, and the only variable is the capability interface exposed through the mediated path before execution.
#### System model.
We consider a coding agent whose planner emits structured invocations over a repository and a small set of external resources. The tool interface includes file reads and writes, shell/test execution, dependency management, network fetch, and git-related tooling. A runtime authority arbiter sits between the planner and those tools. Every compared condition uses the same execution substrate, sandbox profile, and low-level mediation path; what changes is the authority exposed to the planner before execution.

### 4 Model of Capabilities and Interfaces
#### Planner interface as runtime state.
For task $\tau$, the monitor decides which tool-mediated actions can be proposed through the planner interface and which capabilities can produce effects after validation. Each requested action maps through the typed catalog to an authority descriptor
$$

### 5 Portico as a Reference Monitor
Portico sits between the planner and tools. It owns the lifecycle state around live grants $L_{t}$, derives the executable capability set $V_{t}$ from the contract and live handles, and removes temporary authority at closure. Host isolation constrains execution after handoff. Portico controls authority exposed to the planner before it.
#### Inputs.
Portico uses three inputs: a task contract with initial scope, forbidden resources, declared expansions, and closure events; a typed tool catalog that maps runtime tools to privileges, resources, effects, and intent classes; and a policy vocabulary for global deny rules such as credential-file denies, network egress denies, curl | sh, and git push. Planner text can request authority; the monitor decides whether to grant it.

### 6 Experimental Questions and Setup
The evaluation uses explicit scope contracts to observe exposure, expansion, and closure separately. Broad SWE benchmarks measure end-to-end capability but merge these effects into one success score \[agentbench, agentboard, webarena, visualwebarena, workarena, mind2web, gaia, osworld, androidworld, bmoca, mobileworld, swebench, swepolybench\]. We use four task-oriented suites: three controlled security fixtures and one pinned real-repository suite.
#### Research questions.
The evaluation is organized around four questions:

### 7 Results
The results follow the lifecycle: exposure, expansion, closure, and real-repository integration. Portico full trades some raw completion for stricter scope control. The key comparison is closure: a task-wide non-revoking comparator can know which authority is legitimate and still leave it available after its justification ends.
Table 5: Global trade-off snapshot from the main Qwen3-Coder 30B study: five reproducibility repeats per scenario or episode over 17 Suite-A scenarios, 37 Suite-B episodes, and 14 Suite-C episodes.
| Metric | Full | Static | Sandbox | Portico full | Portico core |

### 7.1 RQ1: Minimization Reduces Unsafe Effects
#### Suite-A safety result.
Suite A is the cleanest exposure test. Full access violates every run and has average blast radius 6.65. Static allowlists and coarse sandboxing lower exposure but still leave violation rates at 0.82 and 0.86. Both Portico variants drive violations and blast radius to 0.00: 0/17 scenarios and 0/85 repeated executions record violations. The scenario-level reading is therefore the same as the run-level reading for the Portico rows.
#### Limitations of deployment baselines.

### 7.2 RQ2: Grants Recover Legitimate Boundary Work
#### Core is safe but brittle.
Portico core keeps scope compliance at 1.00 and violations at 0.00, but Suite-B success drops to 0.21 because many tasks need boundary-adjacent or auxiliary resources. A narrow initial envelope is safe but brittle: it preserves scope by stopping when legitimate work crosses a declared boundary.
#### Controlled grants recover the boundary.

### 7.3 RQ3: Closure Removes Temporary Authority
#### Strong non-revoking comparator.
The task-wide non-revoking comparator starts with the same initial envelope as Portico full, receives the same grant in the same turn, and permits the same actions during the episode. The only removed mechanism is closure. Once success, scope, and unsupported-probe denial before closure match, the late-reread endpoint measures remaining stale capability.
Figure 3: Semantic meaning of authority closure. Both rows start from the same initial envelope and issue the same grant at the same point; only Portico removes that authority before late reread.

### 7.4 RQ4: Lifecycle Behavior Appears on Real Repositories
#### Real-repository setup.
The real-repository suite uses the same contract style on pinned snapshots of ItsDangerous, Click, Flask, Jinja, Werkzeug, Pluggy, Requests, and HTTPX. It keeps the lifecycle question task-bounded while replacing the synthetic layout with real files and module boundaries.
#### Real-repository results.

### 8 Discussion
#### What the results mean.
The key finding is the lifetime split: a task-wide non-revoking comparator can preserve task success, scope compliance, and unsupported-probe denial before closure, yet still leave temporary capabilities available. Portico removes that residual exposure. The measured object is the executed effect and the lifetime that exposed it. The all-visible same-policy comparator adds a narrower visibility check: broader visibility yields more blocked forbidden proposals on the post-closure diagnostic without producing executed forbidden effects. A boundary-extension check reverses the blocked-proposal direction while preserving safety, so interface pressure remains diagnostic. Closure is the stronger claim; the coarse all-visible action filter remains a deployment diagnostic with different policy granularity.
#### Utility and contracts.

### 9 Related Work
#### Adjacent defenses.
Prompt-injection and misuse benchmarks show that untrusted content can redirect tool-using agents, including tool-selection hijacking before sandbox handoff \[promptinjection, injecagent, asb, toolemu, agentdojo, agentharm, agentalign, toolhijacker\]. Guardrails and firewalls sanitize prompts or filter proposed actions \[promptarmor, llamafirewall, designpatterns, firewalls, causalarmor\]. MCP-security and tool-poisoning research covers descriptor discovery, provenance, poisoning, and trust propagation \[mcp\_landscape, breakingprotocol, securingmcp, smcp, mcpsecbench, mcptox, systematicmcp, mcpitp, ama, maltool\]. Portico starts after that layer: it assumes a trusted typed tool interface and bounds the resource/effect authority exposed by valid descriptors.
#### Capability lifetime and revocation.

### 10 Conclusion
Coding-agent authority has a lifetime. Portico makes it explicit in the task contract: initial capabilities, requestable grants, trusted closure events, and global deny rules. A boundary request mints opaque resource/effect handles. Closure removes those handles from the next interface and rejects stale replay before effects occur.
The experiments isolate that lifetime. A non-revoking comparator receives the same grant at the same turn, performs the same pre-closure work, and still permits 10/10 post-closure reuses; Portico denies them. Stale-effect audits cover file writes, git mutation, and network egress, including six live traces. The same-policy diagnostic keeps forbidden effects at zero while showing the planning cost of a broader interface. Each grant records its reason, closure, and renewal path.

### Ethical Considerations
This work studies how to reduce harmful authority in tool-using coding agents. The artifact includes adversarial scenarios such as dependency mutation, exfiltration pivots, and unauthorized version-control actions, but they are intentionally scoped to local benchmark repositories and stubbed resources. Their purpose is to measure defensive value, not to operationalize misuse against real systems.
The main stakeholders are repository maintainers, developers using coding agents, organizations deploying agent runtimes, and researchers who reuse the artifact. The main potential harms are misuse of the benchmark lures outside a defensive setting, a false sense of security from an incomplete contract, overblocking of legitimate developer work, and accidental exposure if someone adapts the harness to repositories that contain real secrets.
We reduce these risks in four ways. First, the adversarial cases run against synthetic fixtures or pinned public repositories with no live credentials. Second, network activity is disabled or routed to stubbed endpoints, and the benchmark does not include live exfiltration infrastructure. Third, the artifact is framed as a defensive evaluation harness: it records policy violations, grant decisions, and revocations rather than providing an exploitation workflow. Fourth, the paper states the deployment dependency explicitly: Portico is a monitor for explicit task contracts under complete mediation, not a replacement for sandboxing, review, logging, or careful contract authoring.


## Key insights
- It defines no-stale-use for resource- and effect-specific capabilities exposed to the planner: authority from a closed grant must disappear from later interfaces and be invalid at execution.
- It formalizes exposure minimality, justified expansion, and authority closure around a request–grant–invoke protocol, and implements them in Portico with epoch-bound grant handles.
- It evaluates bounded lifetime on controlled fixtures and pinned real repositories, showing reduced post-closure stale-capability availability and lower blocked-proposal pressure than an all-visible same-policy interface in the post-closure diagnostic.
- RQ1: Capability minimization. Does minimizing exposed capabilities reduce unsafe effects relative to open access, static allowlists, and coarse sandboxing?
- RQ2: Justified expansion. Can controlled expansion recover legitimate cross-boundary utility without reintroducing broad upfront exposure?
- RQ4: Real-repository lifecycle. Does the same grant/revoke behavior appear on pinned real repositories?

## Exemplos e evidências
See original source at `Clippings/Lingering Authority Revocable Resource-and-Effect Capabilities for Coding Agents.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/compiler]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/Codex]]
- [[03-RESOURCES/entities/Gemini]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
