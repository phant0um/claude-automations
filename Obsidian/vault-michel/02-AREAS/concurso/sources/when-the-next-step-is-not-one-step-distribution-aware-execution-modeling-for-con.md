---
title: "When the Next Step Is Not One Step: Distribution-Aware Execution Modeling for Concurrent Go Programs"
type: source
source: "Clippings/When the Next Step Is Not One Step Distribution-Aware Execution Modeling for Concurrent Go Programs.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
Training a model to predict the next step in a concurrent program is harder than it looks: two runs of the same program from the same trace prefix can produce different next events, both valid, because the scheduler is nondeterministic. A model trained against a single label is learning to guess one outcome of a random process. We turn this around and use the nondeterminism as a training signal.

## Argumentos principais
### 1 Introduction
A model trained on execution traces learns to predict what a program does, not just what it looks like. This is the idea behind Code World Models (CWMs): trained on runtime state snapshots after each statement, a language model learns the state transition function, which improves verification, debugging, and code generation [^1]. For sequential Python the approach works well.
But it rests on a quiet assumption: that execution is deterministic. Given a state and the next statement, there is one next state. For concurrent code that assumption fails. When goroutines run in parallel and communicate over channels, the scheduler interleaves them differently on every run. The same prefix can be followed by a block, a start, or an unblock, all equally valid. Train a model to predict a single next event here and you are asking it to memorize one arbitrary outcome of a random process. It will learn very little.
This is not a minor technicality. Concurrency bugs, deadlocks, data races, goroutine leaks, have no sequential analogue. They depend on schedule, evade unit tests, and are hard even for experts to anticipate [^3] [^4]. If execution-trace models are to be useful where the bugs are hardest, they must handle the nondeterminism that defines the setting.

### 2 Background and Related Work
Code world models and execution traces. A world model learns an environment’s transition function: state and action in, next state out [^1]. CWMs apply this to program execution, training on action-state pairs from interpreter traces so the model predicts the next action and resulting state from a partial trace [^1]. Meta’s 32B CWM, trained on Python traces and agentic trajectories, showed that this grounding improves coding and reasoning [^1]. A follow-up study of CWM failure modes found that errors concentrate in two regimes: token-budget exhaustion on long traces and string-valued state confused by subword tokenization [^2]. Both studies assume deterministic, sequential execution.
Concurrency and LLMs. Concurrent code introduces nondeterministic scheduling and bug classes, races, deadlocks, starvation, that have no sequential equivalent. Unit-test evaluation cannot systematically explore thread schedules [^3]. The CONCUR benchmark targets concurrent code generation, judged by model checking [^3]. Our problem is different: modeling the execution of concurrent programs as a learned transition function, using scheduling nondeterminism as a distributional target. The GoKer/GoBench corpus of real Go concurrency bugs [^4] provides our held-out test programs.
Distribution matching and calibration. Training against a target distribution rather than a point label is an established technique: soft-target objectives improve language-model calibration, often using an empirical distribution from a few hundred samples as the target [^5] [^6]. Our contribution is not distribution matching itself but its source. The nondeterminism of concurrent execution, observed through repeated runs, gives a principled empirical target over next events. We are not aware of prior work deriving distributional training targets from concurrent execution traces.

### 3 Problem Formulation
We consider Go programs that spawn multiple goroutines. The runtime tracer emits scheduler events and we work with six event types covering goroutine lifecycle and synchronization:
$$
\mathcal{E}=\{\textsf{GoBlock},\ \textsf{GoCreate},\ \textsf{GoEnd},\ \textsf{GoSched},\ \textsf{GoStart},\ \textsf{GoUnblock}\}.

### 4 Dataset and Evaluation Setup
Programs. We assembled 130 concurrent Go programs in three groups (Table 2). Hand-crafted programs cover channel, mutex, select, pipeline, waitgroup, and fan-in/out patterns, with intentional deadlocks, races, and leaks. Generated programs are synthesized with randomized parameters and optional injected bugs, each verified to compile. Real-world programs are reduced concurrency-bug kernels from the GoKer/GoBench corpus [^4], drawn from production systems including CockroachDB, Kubernetes, gRPC, etcd, Istio, and Moby. Each program carries metadata describing outcome, pattern, goroutine count, and expected nondeterminism.
Table 2: Program corpus. All 66 real-world GoKer programs are held out from training, so accuracy on those programs measures out-of-distribution generalization to code the model never saw during fine-tuning.
| Group | Count | Source |

### 5 Method
Format. Each example renders the program source, the partial trace as JSON, and the current goroutine states, then asks for the next event. The point target is a JSON object {"event\_type":..., "goroutine\_id":...}; the distribution target is the six-way vector $\hat{p}_{g}$. Prompts are left-truncated at the source so the target is never cut off.
Cross-entropy baseline. We fine-tune Qwen2.5-Coder (1.5B and 7B) with cross-entropy over response tokens using 4-bit QLoRA (rank 16, $\alpha{=}32$, gradient checkpointing). To approximate the empirical distribution under a point loss, examples are duplicated in proportion to observed next-event frequency.
KL distribution loss. The distribution objective adds a KL term at the token position that discriminates between event types. With logits $z$ restricted to the six event-type tokens, $q=\mathrm{softmax}(z)$, and empirical target $\hat{p}_{g}$,

### 6 Results
Table 3: Next-event accuracy on the held-out real-world GoKer set. Fine-tuning on concurrent traces from hand-crafted programs generalizes to real production bugs, outperforming both the zero-shot baseline and Gemini 3.5 Flash. Distribution training with KL loss achieves comparable accuracy to cross-entropy while improving calibration (Section 7).
| Model | Accuracy |
| --- | --- |

### 7 Analysis: Where the Ceiling Comes From
Per-event accuracy. Table 5 breaks accuracy down by event type. The model learns common lifecycle events, GoStart at 47%, GoCreate at 44%, GoBlock at 36%, but never predicts GoEnd or GoSched (both 0%) and rarely gets GoUnblock right (8%).
Table 5: Per-event accuracy of the KL model on GoKer, alongside train and test frequency. Two events with near-zero training frequency, GoEnd and GoSched, are never predicted correctly. Meanwhile GoCreate achieves 44% accuracy from only 1.5% of training examples, suggesting the model reasons from program structure rather than label frequency.
| Event | Train freq. | Test freq. | Accuracy |

### 8 The Select-Block Leak Signature
One distributional pattern in our data has a formal explanation rather than a statistical one. In a subclass of goroutine leaks, we consistently observe $P(\textsf{GoUnblock})=0$ at every trace depth across all five runs of those programs.
Consider a goroutine $G$ that enters a select statement at time $t$, where none of the case conditions can ever be satisfied by the remaining execution. We call this a *select-block leak*. For such $G$, a GoUnblock event is impossible for all $t^{\prime}>t$, and so $P(\textsf{GoUnblock})=0$ in the empirical next-event distribution for any split taken after $G$ ’s first GoBlock.
The reason is straightforward. In Go, GoUnblock fires only when another goroutine sends to or closes a channel that $G$ is waiting on, or releases a mutex that $G$ is waiting to acquire. If no reachable goroutine in the remaining execution can do either, then GoUnblock never fires. This is a consequence of the scheduler’s semantics, not something the model learns. It holds regardless of how many select cases $G$ has; we verified this for both two-case and four-case selects.

### 9 Threats to Validity
Our grouping of runs by split depth is an approximation. We treat runs at the same depth as sharing a prefix family, but because interleavings differ, the actual prefixes are structurally comparable rather than identical. This can blur the empirical distribution targets, particularly for programs with high nondeterminism where many interleavings are equally likely.
The runtime tracer does not expose channel buffer occupancy, mutex ownership, or local variable values. The model reasons from a partial view of program state, which bounds achievable accuracy and explains some of the confusion in event types like GoUnblock that depend on synchronization state the model cannot see.
Several of our secondary analyses rest on small samples. The calibration correlation ($\rho=0.412$, $p=0.007$) is statistically significant, but the anomaly detection result ($n{=}9$, Cohen’s $d=0.29$) is not. We report effect sizes throughout rather than drawing conclusions from isolated $p$ -values.

### 10 Conclusion
We reformulated next-event prediction for concurrent programs as distribution estimation over empirical nondeterministic targets. A 7B model fine-tuned on fewer than a thousand Go traces generalizes to real production concurrency bugs better than a strong zero-shot large model, and distribution training with a KL objective matches cross-entropy accuracy while improving calibration. The 35–36% accuracy ceiling traces to rare-event failure and train-test distribution shift, and multi-step predictions lose coherence after roughly one step because the model was never trained on trajectories.
Three directions follow directly from these findings. Training on trajectories rather than individual steps is the most direct path to extending multi-step coherence. Encoding channel and mutex state in the trace representation would let the model reason about synchronization, not just goroutine lifecycle events. Rebalancing the training set toward the event mix of real Go code would address the class-imbalance ceiling that currently prevents the model from learning rare but important event types. We release the dataset, the cross-entropy and KL adapters, and all tooling to support this line of work.

### Appendix: Artifacts and Compute
All artifacts are publicly released. Code, tooling, and scripts are available at [^7]. The benchmark dataset is released as [^8]. The cross-entropy and KL fine-tuned 7B adapters are released as [^9] and [^10] respectively; both are 4-bit QLoRA adapters runnable on a single 20 GB GPU.
Total compute cost was $12 for fine-tuning on a RunPod RTX 4000 Ada and $60 for Gemini API inference across all zero-shot evaluations.
[^1]: FAIR CodeGen Team: CWM: An Open-Weights LLM for Research on Code Generation with World Models. arXiv:2510.02387 (2025)


## Key insights
- We show that a 7B model fine-tuned on fewer than a thousand concurrent traces reaches 36.2% next-event accuracy on held-out production bugs from CockroachDB, Kubernetes, gRPC, and etcd, beating Gemini 3.5 Flash zero-shot (34.8%) and the same model without fine-tuning (28.6%).
- We show that training with a KL objective against empirical distributions matches cross-entropy on accuracy (35.8% vs. 36.2%) while improving calibration: Expected Calibration Error drops from 0.205 to 0.169 and model entropy correlates with program nondeterminism.
- We derive a formal leak signature for select-blocked goroutines, showing that $P(\textsf{GoUnblock})=0$ at every trace depth follows from Go scheduler semantics, not from learning.
- We report where the approach falls short: accuracy plateaus near 35–36% regardless of model or objective, rare event types are never learned, and multi-step predictions lose scheduler coherence after roughly one step.

## Exemplos e evidências
See original source at `Clippings/When the Next Step Is Not One Step Distribution-Aware Execution Modeling for Concurrent Go Programs.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Gemini]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Python]]
- [[03-RESOURCES/entities/Kubernetes]]
