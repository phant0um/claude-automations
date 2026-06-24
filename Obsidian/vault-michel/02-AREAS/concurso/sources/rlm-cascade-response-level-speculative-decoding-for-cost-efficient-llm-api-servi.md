---
title: "RLM-Cascade: Response-Level Speculative Decoding for Cost-Efficient LLM API Serving"
type: source
source: "Clippings/RLM-Cascade Response-Level Speculative Decoding for Cost-Efficient LLM API Serving.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
We present RLM-Cascade, a proxy-layer system that applies speculative decoding at the response level to reduce LLM API costs without requiring model architecture access or a shared vocabulary. A fast, inexpensive draft model generates a candidate response; a capable verify model accepts, enhances, or is bypassed entirely depending on a lightweight complexity router. On a real-world agentic coding workload (Claude Code), RLM-Cascade achieves a draft-use rate of 88.8% across 125 production request

## Argumentos principais
### 1.1 Problem
Frontier large language models such as Claude Opus and GPT-4 deliver state-of-the-art accuracy, but their inference cost is 50–100 $\times$ higher than smaller models. Smaller models reduce cost but degrade quality unpredictably, particularly on tasks requiring multi-step reasoning, code correctness, or precise instruction following. Serving systems therefore require a principled mechanism for capturing the quality of large models at a fraction of the cost, without requiring access to model internals or co-located deployment.
This challenge is especially acute in *agentic coding workloads*, where a coding assistant issues dozens of turns per session, interleaving tool-selection commands (Bash execution, file reads and writes, web searches) with text-generation turns (code synthesis, explanations, documentation). These turn types differ in cost sensitivity and quality requirements: tool-selection turns must emit schema-compliant JSON or they break the client’s execution loop; text-generation turns have more flexible output formats and are more amenable to draft-and-verify pipelines.

### 1.2 Prior Art Gap
Token-level speculative decoding [^1] [^2] achieves significant throughput improvement: a small model drafts $k$ tokens, which a large model verifies in a single forward pass. This works because both models share a vocabulary and logit distributions. The technique is inapplicable when draft and verify models are served through separate HTTP APIs with no access to internal logit distributions.
LLM cascade and routing systems [^3] [^4] route entire requests to one model or another based on predicted difficulty. This reduces cost when cheaper models are sufficient, but provides no fallback mechanism when the cheap model fails. Neither paradigm combines both models on a single request through an API-only interface.

### 1.3 Contributions
1. Response-level speculative decoding at the API layer. We treat the full model response as the unit of speculation, enabling draft/verify pipelines that operate over standard HTTP without logit access.
2. Cross-provider, cross-architecture pipeline. Draft (DeepSeek-V4-Pro, Azure AI Foundry) and verify (claude-opus-4-8 via the Native Opus enterprise endpoint on Google Vertex AI) are heterogeneous models from different providers, connected only through the Anthropic API wire format.
3. Rule-based complexity router with tool-call carve-out. A lightweight keyword classifier routes simple agentic turns directly through DeepSeek (SKIPPED, $\approx$ 2% of Opus cost), complex turns through the draft $\rightarrow$ verify pipeline, and tool-selection turns directly to Opus.

### 2.1 Token-Level Speculative Decoding
The speculative decoding framework of Leviathan et al. [^1] and Chen et al. [^2] achieves lossless throughput gains by exploiting the asymmetry in cost between drafting and verifying tokens. A small draft model $M_{q}$ generates $k$ token candidates $\tilde{x}=(\tilde{x}_{1},\ldots,\tilde{x}_{k})$; a large verify model $M_{p}$ verifies all $k$ tokens in a single forward pass. The acceptance criterion for each token $\tilde{x}_{i}$ is:
$$
P\!\left(\text{accept}\;\tilde{x}_{i}\right)=\min\!\left(1,\;\frac{M_{p}(\tilde{x}_{i}\mid x_{<i})}{M_{q}(\tilde{x}_{i}\mid x_{<i})}\right).

### 2.2 LLM Cascade and Routing
FrugalGPT [^3] learns a routing policy that assigns each request to the cheapest model predicted to answer it correctly, with the policy trained offline on labeled datasets. LLM-Cascade [^4] uses confidence scores to decide whether to escalate to a more capable model. Big-Little LM [^10] generalizes this with dynamic switching based on token-level uncertainty. These systems route whole requests to one model at a time; RLM-Cascade applies *both* models to the same request in a draft-then-verify structure.

### 2.3 Agentic LLM Workloads
Agentic systems such as Claude Code issue structured multi-turn conversations consisting of two qualitatively different turn types:
- Tool-selection turns: The assistant emits a tool\_use content block containing a JSON tool name and parameters. Schema validity is mandatory—a malformed block aborts the execution loop.
- Text-generation turns: The assistant emits a natural-language response (explanations, code, documentation). Output format is flexible; minor imprecisions are generally tolerable.

### 3.1 Architecture Overview
Figure 1 shows the end-to-end architecture. The proxy intercepts all Anthropic API calls from the Claude Code client by setting ANTHROPIC\_BASE\_URL to the proxy’s local address, speaking the Anthropic API wire format on both sides. No client modifications are required.
Figure 1: RLM-Cascade end-to-end architecture. SKIPPED (64–70% of requests): simple turns are routed to DeepSeek only and returned directly to the client with no Opus call (top rail). Draft+Verify: complex turns go to DeepSeek, then the draft is validated by Opus, which emits Accepted (USE\_DRAFT) or Enhanced (rewritten response), arriving at the client via out.west. Direct: tool-selection turns bypass the pipeline and go straight to Opus to guarantee JSON schema compliance (bottom path). Langfuse traces and Prometheus metrics fire asynchronously after the response is returned, adding zero latency to the critical path.

### 3.2 Rule-Based Complexity Router
The router classifies each incoming text-generation request in $O(1)$ time with no model calls. Two hard rules apply first:
Tool-selection bypass: Requests with a non-empty tools field are forwarded directly to Opus. Draft models do not reliably conform to Anthropic’s tool-use JSON schema.
Complexity signals (for tool-free requests) are shown in Table 1. The 1,500-character threshold captures long-context injections that do not match any keyword.

### 3.3 Draft →\\rightarrow Verify Pipeline
For complex requests, the pipeline executes sequentially: (1) DeepSeek-V4-Pro (Azure AI Foundry) generates a draft using the original system prompt and user messages unchanged; (2) the Native Opus endpoint—the enterprise deployment of claude-opus-4-8 on Google Vertex AI that RLM-Cascade wraps—receives the original request concatenated with the draft, wrapped in the enhancement prompt (Appendix A); (3) Langfuse receives a nested trace asynchronously after the client response is returned, adding zero latency to the critical path.

### 3.4 Verdict Protocol
The verify model returns one of two outputs, producing three system-level outcomes summarized in Table 2.
Table 2: Verdict outcomes, triggers, and relative cost.
| Verdict | Trigger | Cost vs. Opus-only |

### 3.5 Hybrid Tool-Call Strategy
Tool-selection turns are identified by a non-empty tools array and forwarded directly to claude-opus-4-8 with no draft stage. In a typical Claude Code session, 70–80% of turns are tool-selection turns; speculative decoding applies only to the remaining 20–30%, which constitutes the pipeline’s reach within any agentic session.

### 3.6 Cost Model
Token pricing (USD per million tokens, as of deployment): DeepSeek-V4-Pro $1.74 input / $3.48 output; claude-opus-4-8 $5.50 input / $27.50 output. The output cost ratio is approximately $8\times$ higher for Opus, making the SKIPPED path the primary economic lever.
Per-verdict cost formulas.  Let $p_{\mathrm{in}}$ = original prompt input tokens, $d_{\mathrm{in}}$ / $d_{\mathrm{out}}$ = draft input/output tokens, and $a_{\mathrm{out}}$ = Opus output tokens in the ENHANCED case (full derivation in Appendix B):
$$

### 3.7 Observability Stack
Langfuse captures per-request nested traces: a root span (end-to-end latency, verdict, total cost), a child span draft (DeepSeek call), and an optional child span enhance (Opus call). The dashboard at /dashboard provides real-time verdict distribution, savings rate, latency percentiles, and per-request history. Prometheus metrics at /metrics/prometheus expose:
[⬇]()
rlm\_requests\_total{verdict="SKIPPED|ACCEPTED|ENHANCED"}

### 4.1 Experimental Setup
We evaluate on three distinct workloads:
1. Service benchmark ($N{=}12$ current run / $N{=}125$ all-time): Requests from live Claude Code sessions routed through the production proxy, covering greetings, factual questions, code generation, SQL, explanation, and refactoring.
2. 20-task extended engineering benchmark: A structured prompt suite covering algorithmic tasks (adaptive rejection sampler, write-compressor, query-optimize), engineering tasks (fix-code-vulnerability, extract-moves-from-video, mteb-retrieve), and standard data-structure tasks. Designed to stress the ENHANCED path.

### 4.2 Verdict Distribution
Table 4 shows verdict proportions across all evaluation sets. The SKIPPED rate is consistently 64–70% regardless of task distribution.
Table 4: Verdict distribution across evaluation sets.
| Evaluation set | $N$ | SKIPPED | ENHANCED | Draft-used |


## Key insights
- Tool-selection turns: The assistant emits a tool\_use content block containing a JSON tool name and parameters. Schema validity is mandatory—a malformed block aborts the execution loop.
- Text-generation turns: The assistant emits a natural-language response (explanations, code, documentation). Output format is flexible; minor imprecisions are generally tolerable.
- Local vLLM* — DeepSeek-R1-Distill-Qwen-7B (4bit, MLX framework)
- Remote Speculate* — DeepSeek-V4-Pro (Azure AI Foundry) $\rightarrow$ Native Opus (Google Vertex AI)
- Remote Native Opus* — claude-opus-4-8 served via the enterprise Native Opus endpoint (Google Vertex AI); this is the production baseline that RLM-Cascade wraps

## Exemplos e evidências
See original source at `Clippings/RLM-Cascade Response-Level Speculative Decoding for Cost-Efficient LLM API Serving.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/Azure]]
