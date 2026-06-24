---
title: "Agentic AI Systems Should Be Designed as Marginal Token Allocators"
type: source
source: "Clippings/Agentic AI Systems Should Be Designed as Marginal Token Allocators.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
This position paper argues that agentic AI systems should be designed and evaluated as *marginal token allocation economies* rather than as text generators priced by the unit. We follow a single request—a developer asking a coding agent to fix a failing test—through four economic layers that today are designed in isolation: a router that decides which model answers, an agent that decides whether to plan, act, verify, or defer, a serving stack that decides how to produce each token, and a trainin

## Argumentos principais
### 1 Introduction
Consider a developer who types “the CI test on auth/login is failing—fix it” into a modern coding agent. Before a single line of code is touched, the system has already made four economic decisions. A *router* decides whether to spend a cheap model (fast triage, possibly wrong) or a frontier model (slow, expensive, more likely correct) [^8] [^30]. An *agent policy* decides how the chosen model should spend its tokens—reading the repository, planning, editing, running tests, or asking the developer to clarify [^45] [^39] [^44]. A *serving stack* decides how to produce those tokens, juggling prefill for the long context, decode for the patch, and KV cache for the test logs [^20] [^34] [^46] [^14]. And a *training pipeline* decides, after the dust settles, whether this trace is worth learning from—rollout, verifier, or update tokens to spend now for capability later [^32] [^11] [^7] [^47].
Each layer charges a different price for what looks, on the API invoice, like the same token. The router prices a token in dollars per million; the agent prices it in expected risk of an irreversible action; the serving stack prices it in queueing delay; the trainer prices it in marginal capability gain over a discount horizon. This decoupling is hidden by the dominant accounting fiction—tokens are units of text, billed at a flat rate [^6]. That fiction was workable when LLMs were chat completions. It is misleading once tokens cause actions, occupy infrastructure, and become training data.
This position paper argues that *agentic AI systems should be designed and evaluated as marginal token allocation economies*, in which routers, agents, serving schedulers, and trainers are mechanisms that decide where the next unit of tokenized computation should be spent under joint quality, cost, latency, and risk constraints. The claim is narrower than “token economics is a complete theory of AI” and stronger than “tokens are billed by the unit.” We argue that a *single* first-order condition—marginal benefit equals marginal cost plus latency cost plus risk cost—is the right minimum vocabulary, because the four layers above are not parallel engineering problems but vertical slices of one allocation problem. The router screens the demand side, the agent contracts on the action side, the serving stack produces on the supply side, and the trainer accumulates capital on the investment side. They are the same equation, evaluated at four shadow prices that today no single layer can see.

### 2 One Equation, Four Prices
#### The primitive object.
Let an LLM *system* face a stream of tasks. For each task it has a finite set of *token uses*, indexed by $i$, between which it must allocate computation. Concretely, $i$ ranges over choices such as {cheap model, frontier model, retrieval, planning, tool call, verifier, prefill capacity, decode capacity, KV transfer, RL rollout, reward computation, gradient update}. Each use $i$ has a marginal quality contribution $\Delta Q_{i}$, a marginal compute cost $\Delta C_{i}$, a marginal latency cost $\Delta L_{i}$, and a marginal risk $\Delta R_{i}$ (e.g., probability of a wrong action weighted by its consequence). Let $V$ denote task value. The system should spend the next token on
$$

### 3 One Request, Four Layers
We now follow the developer’s request from §1 through each layer of the stack and show that each layer is solving Equation 1 at a different price. The narrative deliberately preserves the request’s identity: the same task picks up new prices as it descends.

### 3.1 Demand: Routing as a Screening Mechanism
The first decision is which model answers. Naively one would route by “best quality per dollar.” That intuition is wrong in the same way that posting a single price is wrong in a market with heterogeneous buyers [^42].
A request has a hidden type $\theta=(V,d,r,\lambda)$: task value, difficulty, risk sensitivity, latency sensitivity. The router observes only $x$, a noisy signal of $\theta$. Its problem is the screening problem of [^41] and [^29]: design a mapping $m^{*}(x)$ such that the chosen model maximizes Equation 1 restricted to the model index,
$$

### 3.2 Action: Agents as Principal–Agent Contracts
The chosen model now enters the agent loop. The router has answered “which model”; the agent must answer “what should it do.” This is where the same token’s price changes again, because tokens used to summarize a file and tokens used to commit a patch carry different consequences [^45] [^37] [^44].
#### The autonomy contract.
Let $a\in[0,1]$ denote autonomy (0 = always ask, 1 = act freely) and $t$ be the token budget. The user’s expected utility is

### 3.3 Supply: Serving as Production
Each token the agent commands must be physically produced. Modern stacks separate prefill and decode [^34] [^46], page KV cache [^20], and chunk requests [^1]. Speculative decoding [^22] adds a verifier stage. These are exactly the moves a microeconomic theorist would predict in a multi-stage production system with heterogeneous resources [^4].
Let $G_{p},G_{d},K,N$ denote prefill GPU capacity, decode GPU capacity, KV-cache storage/bandwidth, and interconnect bandwidth. Token output is $Y_{\text{tok}}=F(G_{p},G_{d},K,N)$ and latency $L=L_{p}(G_{p})+L_{d}(G_{d})+L_{K}(K,N)$. The cost-minimizing producer satisfies the equimarginal condition,
$$

### 3.4 Capital: Caches and RL Training as Investment
After the developer’s test passes, two streams of tokens persist. The KV blocks for the repo prefix and the test logs may be cached for the next request; the trace itself may be added to the next post-training run. Both are *capital* —past tokens that lower the marginal cost or raise the marginal quality of future tokens.
#### Caches and memory as inventory.
Let $S_{t}$ denote the stock of cached or memorized content (KV blocks [^20], retrieval embeddings [^23], or agent notes [^33]). Its dynamics are

### 4 The Cost of Local Optimization
We have followed one request through four layers and seen that each layer’s mechanism is a different reading of Equation 1. We now turn from synthesis to diagnosis. The unified view sharpens what counts as a failure: a system fails not when it is slow or expensive in absolute terms, but when its allocation deviates predictably from Equation 1. The seven failure modes in Table 2 are not independent observations across heterogeneous systems; they are the corner cases of Equation 1 when one of the four prices ($V$, $\Delta C_{i}$, $\lambda$, $\rho$) is held at zero or at infinity by a layer that does not see it.
Table 2: Marginal token allocation predicts a small set of recurring failure modes across heterogeneous LLM systems. Each row is a violation of Equation 1 or Equation 2.
| Failure mode | Allocation violated | Where observed |

### 5 Alternative Views
#### Token economics is a metaphor, not a theory.
A reasonable critic will argue that “marginal,” “screening,” and “investment” are loose analogies. The analogies are formal, not rhetorical: each layer reduces to a first-order condition (Equations 1, 4, 7, 9, 11) testable on logs. The framework is falsifiable: a system that violates the relevant first-order condition should be Pareto-dominated by one that does not, and this can be checked empirically.
#### The right primitive is FLOPs, not tokens.

### 6 Discussion
#### Implications for system design.
Five design and evaluation principles follow directly from Equation 1. *Token-aware evaluation* should report the four prices ($V$, $\Delta C_{i}$, $\lambda$, $\rho$) and the realized allocation per request, not only aggregate accuracy and dollar cost. *Risk-adjusted routing* should publish a regret bound against Equation 4 or an incentive-compatible menu (Eq. 5), not a cost–quality scatter plot. *Autonomy pricing* should make the action class explicit and price irreversible actions higher than reversible ones, in line with Equation 7. *Congestion-priced serving* should expose shadow prices for prefill, decode, and KV resources, so that upstream allocators can read them in real time and respond to the operator’s binding constraints rather than to a flat per-token list price. *RL token budgeting* should equalize marginal capability gain across rollouts, verifiers, and updates (Eq. 12) and depreciate stale rollouts at the rate $\delta$ implied by drift, not at the rate implied by an arbitrary epoch boundary. None of these principles requires new mathematics beyond Section 2; what they require is a single, instrumented price vector visible to all four layers.
#### Limitations.

### 7 Conclusion
We have argued that agentic AI systems should be designed and evaluated as marginal token allocation economies. The argument is built on three load-bearing claims. First, four ostensibly separate layers—routing, agent policy, serving, and post-training—are vertical slices of a single allocation problem characterized by Equation 1, with prices that are formally Lagrange multipliers of the joint feasibility set. Second, recurring failures across the stack (over-routing, over-delegation, under-verification, congestion, stale rollouts, cache misuse) are corner cases of that equation when one of the four prices is mis-set, and they are predictable rather than incidental. Third, a Pareto-efficient allocation across the four layers requires only that the layers see a common, complete price vector—a condition that current production stacks systematically fail. The prescription is not centralization; it is shared price discovery. Returning to the developer with a failing test, the request is not a single completion but a chain of allocations: model tier, action authority, serving resources, and future training value. Today’s systems price these decisions separately, producing silent downgrades, runaway autonomy, latency spikes, and noisy learning signals. The next generation of agentic AI systems will not be defined only by cheaper tokens or larger models, but by mechanisms that allocate marginal computation closest to the risk-adjusted equilibrium.

### Appendix A Open Problems
The framework leaves a focused set of open problems. (1) *Estimation of $\Delta Q_{i}$ from logs* via causal inference / off-policy evaluation [^32], with calibrated variance. (2) *Risk pricing*: an empirical proxy for $\rho\Delta R_{i}$ that incorporates the Knightian component of Section 2. (3) *Mechanism-design routing*: do incentive-compatible menus (Eq. 5) outperform silent routing under strategic users, and how should reasoning budgets be calibrated to per-task certainty signals [^13]? (4) *Internal shadow prices*: serving APIs that expose prefill, decode, and KV shadow prices upstream, building on schedulers that already learn request-level priorities [^14]. (5) *RL portfolios*: when SFT, DPO, and online RL—together with architectural variants such as speculative rollouts [^7] and concern-separated agentic pipelines [^47] —are treated as token-investment assets, what is the efficient frontier in the (variance, capability gain) plane? (6) *Distributed equilibrium*: can the multi-tenant equilibrium of Section 2 be implemented as a clearing protocol, or must it be approximated by admission control plus priority queueing, and how should caches report depreciation $\delta_{S}$ in Equation 10?

### Appendix B Broader impact
Treating agentic AI as a token economy makes *who pays for what* explicit, which we view as a prerequisite for accountability. A user whose request is silently downgraded does not currently see the routing decision; a tenant whose latency degrades because of an unrelated long-context workload cannot identify the externality; a workforce whose tasks are delegated to an autonomous agent has no menu of oversight intensities to choose from. Instrumented prices make these decisions auditable, which is a public good. They are not, however, a substitute for governance: a mis-set $\rho$ on irreversible actions can still cause harm at speed, and an information-rent-extracting router can still be unfair even if it is welfare-maximizing in expectation. The framework should be read as a tool for diagnosis and design, not as a normative claim that markets settle every question. In particular, we are not arguing that decentralized token markets will spontaneously solve agentic-AI design; the history of computation markets [^9] [^42] shows that decentralization without instrumented prices typically produces pathological equilibria, and current LLM markets—bundled pricing, opaque routing, unpriced congestion—are precisely such an environment. The argument is that agentic systems should be designed with the prices written down, so that internal optimization, external pricing, and human oversight are aligned to the same first-order condition.
[^1]: A. Agrawal, N. Kedia, A. Panwar, J. Mohan, N. Kwatra, B. S. Gulavani, A. Tumanov, and R. Ramjee (2024) Taming throughput-latency tradeoff in llm inference with sarathi-serve. External Links: 2403.02310, [Link]() Cited by: §1, §2, §2, §3.3.
[^2]: A. Ahmadian, C. Cremer, M. Gallé, M. Fadaee, J. Kreutzer, O. Pietquin, A. Üstün, and S. Hooker (2024) Back to basics: revisiting reinforce-style optimization for learning from human feedback in llms. Annual Meeting of the Association for Computational Linguistics. Cited by: §3.4, §3.4.


## Key insights
- We show that all four layers are solving the *same* first-order condition—marginal benefit equals marginal cost plus latency cost plus risk cost—with different index sets and different prices.
- The framing is deliberately minimal: we do not propose a complete theory of AI economics.
- ## 1 Introduction

Consider a developer who types “the CI test on auth/login is failing—fix it” into a modern coding agent.
- A *router* decides whether to spend a cheap model (fast triage, possibly wrong) or a frontier model (slow, expensive, more likely correct) [^8] [^30].
- An *agent policy* decides how the chosen model should spend its tokens—reading the repository, planning, editing, running tests, or asking the developer to clarify [^45] [^39] [^44].
- The router prices a token in dollars per million; the agent prices it in expected risk of an irreversible action; the serving stack prices it in queueing delay; the trainer prices it in marginal capability gain over a discount horizon.
- The router screens the demand side, the agent contracts on the action side, the serving stack produces on the supply side, and the trainer accumulates capital on the investment side.
- (i) We formulate a single optimality condition—marginal token allocation—and show that routers, agents, serving stacks, and trainers are instances of it (Section 2).
- (ii) We trace one request through all four layers, using standard tools from microeconomics: screening with hidden types [^3] [^41], principal–agent contracts [^29] [^16], multi-stage production with congestion [^35] [^43], and capital accumulation [^40] (Section 3).
- (iii) We show that recurring failures across the stack—over-routing, over-delegation, under-verification, congestion, stale rollouts, cache misuse—are corner cases of the same equation when one of the four prices is mis-set (Section 4).

## Exemplos e evidências
See original source at `Clippings/Agentic AI Systems Should Be Designed as Marginal Token Allocators.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/AWS]]

## Minha Síntese
**O que muda:** Sistemas agenticos devem ser projetados como economias de alocação marginal de tokens — router, agent, serving e training são fatias verticais de uma única equação com quatro preços diferentes (custo, latência, risco, ganho de capacidade).

**Conexão pessoal:** O conceito de token-economy conecta diretamente com o concept de [[03-RESOURCES/concepts/agent-systems/token-economy]] no vault — a ideia de que falhas recorrentes são corner cases quando um preço é mis-set.

**Próximo passo:** Avaliar se o Hermes Agent pode expor shadow prices (de latência, risco) para upstream allocators tomarem decisões melhores.
