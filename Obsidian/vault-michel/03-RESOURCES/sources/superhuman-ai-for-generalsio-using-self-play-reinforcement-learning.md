---
title: "Superhuman AI for Generals.io Using Self-Play Reinforcement Learning"
type: source
source: "Clippings/Superhuman AI for Generals.io Using Self-Play Reinforcement Learning.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
We present a superhuman AI agent for Generals.io, a real-time strategy game that requires both long-horizon planning and short-term tactics under strong imperfect information. Trained for four days on $4\times$ NVIDIA H200 GPUs, our agent reaches #1 on the public 1v1 leaderboard of over 5,000 human players, leading the second-ranked player by the same margin that separates second place from 25th, and beats the two top-ranked humans head-to-head with a combined 199–70 record across 269 ladder mat

## Argumentos principais
### I Introduction
Games have driven much of modern deep reinforcement learning, from Chess and Go [^16] to Poker [^11] [^4], Stratego [^13], StarCraft II [^21], and Dota 2 [^1].
The training pipeline behind many of these results decomposes into two nested loops. An *inner loop* trains a single policy with reinforcement learning—typically a policy gradient—against a pool of opponents. An *outer loop* constructs that pool: it decides which policies enter it, how they are weighted, and when to introduce new ones. Fictitious play and its neural counterpart NFSP [^7] aggregate past best-responses into an average policy that becomes the inner-loop opponent; the double-oracle family [^10] and PSRO [^9] grow a population by best-responding to a meta-Nash over the existing set; the AlphaStar league [^21] maintains a structured pool of main agents, main exploiters, and league exploiters. The outer loop is what differs across approaches; the inner loop is, modulo neural architecture and regularization, a policy improvement step.
A natural question is whether the outer loop is doing essential work at scale, or whether a sufficiently well-tuned inner loop suffices on its own. On small imperfect-information benchmarks, Rudolph et al. [^14] report that a generic policy gradient with a simple regularizer matches or exceeds full PSRO, NFSP, and CFR pipelines once carefully tuned. Sokota et al. [^18] extend this to a large game, reaching superhuman play in Stratego with a single regularized policy-gradient learner [^17]. At real-time strategy (RTS) scale, the most directly comparable data point is OpenAI Five [^1], which reached superhuman Dota 2 with pure PPO self-play (no league, no behavior cloning), but relied on dense hand-tuned reward shaping. What remains less clear is whether the same conclusion holds under sparse win/loss reward alone, and which specific ingredients of the recipe are actually load-bearing.

### Contributions
- A JAX-native Generals.io environment <sup>1</sup> that reaches tens of millions of frames per second on a single GPU and supports all three game modes through a shared action and observation interface, enabling research in cooperative and general-sum multi-agent reinforcement learning.
- A superhuman agent from policy-gradient methods <sup>2</sup> (Sections V and VI). A single transformer policy trained end-to-end with sparse win/loss reward, sample filtering, and an exponential moving average (EMA) of policy parameters reaches #1 on the public 1v1 leaderboard by a large margin and beats the top two individual humans head-to-head $27$ – $12$ and $172$ – $58$ respectively.
- Ablations (Section VII) that isolate which ingredients of the recipe carry the weight. We find that a parameter EMA, rather than the last iterate, is consistently the stronger deployment policy, and that top-advantage filtering, training on only the highest-advantage fraction of collected samples rather than on all of them, is more efficient in both wall-clock time and sample efficiency.

### II-A Policy-Gradient Methods in Zero-Sum Games
Rudolph et al. [^14] hypothesize that, with proper tuning, generic policy-gradient methods are competitive with or superior to specialized game-theoretic alternatives (CFR [^23], fictitious play [^3], double-oracle [^10], PSRO [^9]) in imperfect-information games, and support this with a large exploitability study on small-size benchmarks. Sokota et al. [^18] and Perolat et al. [^13] apply the same idea at scale, using two regularized policy gradients, magnetic mirror descent (MMD) [^17] and R-NaD respectively, to reach top-level play in Stratego. We add a case study in a large real-time strategy game, with results consistent with their hypothesis.

### II-B Prior Generals.io Work
Bhatia et al. [^2] highlighted Generals.io as a promising testbed for AI research and built a data-collection and bot-integration framework, releasing a rule-based agent, Flobot. Xu et al. [^22] likewise framed Generals.io as a cost-effective analogue of Dota 2 and StarCraft II, and proposed a hierarchical self-play agent (HASP) that reaches a reported 77% win rate against Flobot. Neither released an RL-friendly environment supporting the vectorized parallel rollouts that large-scale training depends on. Both agents are also far below the community-developed Human.exe, the strongest *non-learning* agent, which wins close to 100% of games against either. Human.exe combines a wide range of graph algorithms and dynamic programming, and was until recently the top bot on the leaderboard. Straka and Schmid [^19] introduced a gym-like, NumPy-based Generals.io environment and trained a PPO agent that reached a top-25 placement on the 1v1 leaderboard, above Human.exe, relying on behavior cloning from expert replays, potential-based reward shaping, and population-based self-play.

### III Preliminaries
We focus on 1v1 Generals.io, modeled as a two-player partially observable stochastic game (POSG) [^6]; the formalism extends naturally to the 2v2 and free-for-all modes our environment also supports (Section IV-E). At each turn $t$, the global state is $s_{t}$; each player $i\in\{0,1\}$ observes $o_{t}^{(i)}$ rather than the full state and selects an action $a_{t}^{(i)}\sim\pi_{\theta}(\cdot\mid h_{t}^{(i)})$ from a shared policy used in self-play, where $h_{t}^{(i)}=\phi\big(o_{1}^{(i)},\dots,o_{t}^{(i)}\big)$ augments the current observation with memory of earlier ones (Appendix A). The joint action $a_{t}=(a_{t}^{(0)},a_{t}^{(1)})$ drives a deterministic transition $s_{t+1}=f(s_{t},a_{t})$; randomness enters only through the initial-state distribution, which samples the map layout and the two generals’ positions. Imperfect information arises both from the fog of war and from the simultaneity of moves: each player chooses without observing the other’s action. The reward is sparse, terminal, and zero-sum: at the end of the game the winner receives $r=+1$ and the loser $r=-1$.
The agent is trained by self-play to maximize the expected terminal outcome $\mathbb{E}_{\tau\sim\pi_{\theta}}[r]$ with Proximal Policy Optimization (PPO) [^15], an on-policy policy-gradient algorithm; we refer the reader unfamiliar with reinforcement learning to Sutton and Barto [^20] for a thorough introduction. At each iteration we collect a batch of self-play trajectories under the current policy $\pi_{\theta_{k}}$, estimate the advantage $\hat{A}_{t}$ of each action, and update $\theta$ by ascending the clipped surrogate
$$

### IV Game Description
Generals.io is a multiplayer real-time strategy game on a grid with partial observability. Each player commands an army that grows over time, expands across the grid, and tries to capture the opponent’s *general* while defending their own. Resource allocation, opponent modeling, and deception under fog of war together support a wide range of strategies and emergent behaviors. The same rule set covers 1v1, 2v2, and free-for-all formats (Fig. 1), exposed through our JAX-native environment via a shared gym-like interface.
The rest of this section walks through the rules in detail: how maps are generated, what each player sees, how armies grow, and how movement and combat resolve. We then describe the team and free-for-all variants, sketch the strategic depth the rules give rise to, and close with the JAX environment we release alongside the agent.
Figure 2: Three views of the same game state: (a) perfect-information view; (b) the red player’s view; (c) the blue player’s view. Crowns mark bases; numbers are unit counts.

### IV-A Grid Generation
In the official Generals.io game, matches are played on an $H\times W$ grid (up to $23\times 23$) populated with four cell types: *plain* (traversable), *mountain* (impassable), *general* (a player’s base), and *castle* (army-generating cell). The map generator fills a random $20\%$ of cells with mountains and places $9$ – $11$ neutral castles, each pre-loaded with $40$ – $50$ neutral units. The two generals are placed at least $17$ steps apart, and each player is guaranteed at least one neutral castle within radius $6$ of their general.

### IV-B Ownership and Partial Observability
Each cell is either neutral or owned by a single player. A fog-of-war mechanic restricts each player’s view to the cells they own together with the Moore (8-cell) neighborhood around them; all other cells are hidden (Fig. 2). In parallel, a public global scoreboard (Fig. 3) exposes each player’s total owned-cell count and aggregate army count. By watching how these totals evolve, both players can infer what the opponent is doing despite the fog of war, for instance whether they are expanding or consolidating, and bound the maximum army the opponent could have stockpiled at their base.
Refer to caption

### IV-C Army Growth
Players grow their armies through two production mechanisms acting on different timescales. Generals and owned castles produce one unit every other turn. In addition, every $50$ turns the entire territory ticks: each plain cell the player owns gains one unit simultaneously. Capturing a neutral castle requires paying down its $40$ – $50$ starting units through combat; once captured, it produces like any owned castle.

### IV-D Movement and Combat
Gameplay advances in turns; in the browser version each turn lasts $0.5$ seconds, and all players’ moves are resolved simultaneously. On each turn, a player selects one of their owned cells and a cardinal direction, dispatching either all-but-one unit or exactly half of the cell’s units to the neighboring cell. Players may also pass, leaving the board unchanged.
Combat is resolved by subtraction. If the destination is empty, the dispatched units simply move there. If it is held by an enemy army, the two stacks cancel one-for-one and whichever side is larger survives with the remaining difference, taking ownership of the cell (ties leave the cell with its previous owner). The win condition is to capture the opponent’s general: move an army onto the general’s cell and win the resulting combat.

### IV-E Team and Free-for-All Variants
The same mechanics scale to multi-player formats with two natural modifications. In free-for-all with $N$ players, capturing another player’s general transfers all of their cells to the captor along with half of their total army, and the captured general is converted into a regular castle. The last general standing wins. In team play (2v2), moving onto an ally-owned cell transfers the cell’s ownership to the mover while pooling the ally’s units there into the moving stack, rather than subtracting them as enemy units would. Allies share the win/loss condition: the team loses when both of its generals have been captured.

### IV-F Strategic Complexity
Several interacting mechanics give Generals.io its strategic depth. *Fog of war* injects persistent uncertainty: a player must infer the opponent’s general location, army composition, and intent from local observations and the global scoreboard. *Deception* emerges naturally: feints toward one flank can mask a real attack elsewhere, and a player can route an army around the opponent through the fog and strike their general from behind once it is left undefended. *Tempo* is central: capturing territory just before the $50$ -turn reinforcement tick yields a disproportionate payoff, while over-expanding leaves the army too thin to repel a focused attack. *Snowballing* compounds early advantages, since each captured cell contributes to future production, so small early mistakes can cascade into game-deciding asymmetries. Capturing a castle is the clearest instance of a longer-horizon investment: it yields a permanent boost to production, but the army spent on the capture leaves the player materially weaker for a stretch of turns, so the agent must time the investment to a window when the opponent cannot exploit the gap.

### IV-G JAX Environment
Prior research on Generals.io has relied either on a non-vectorizable bot-integration framework [^2] or on a NumPy-based vectorized environment coupled to a PyTorch training stack [^19], the latter reporting around $3{,}500$ steps per second on a 12-core CPU. We reimplement the environment, the rollouts, and the training loop in JAX, so that the entire pipeline can be jit-compiled end-to-end and dispatched to a GPU as a single graph. Observations, rewards, fog-of-war masking, army production, combat resolution, and the spawn-distance curriculum are all expressed as pure functions over a flat PyTree of game state. This yields a peak throughput of $50.7$ M environment steps per second on a single H200 GPU (Table I), more than four orders of magnitude above the prior CPU baseline, and a $32\times$ speedup of the full training loop on the same hardware as that prior work.
TABLE I: Throughput of the JAX environment on a single NVIDIA H200 GPU, by number of parallel environments.
| Environments | Frames Per Second |

### V Agent
This work introduces an AI for Generals.io trained from random initialization by self-play reinforcement learning, without any human demonstrations or hand-engineered priors. The remainder of this section describes the key components of the agent.

### V-A Network Architecture
Fig. 4 shows the overall architecture. The policy is parameterized by a transformer torso. The environment produces a feature tensor $o\in\mathbb{R}^{C\times H\times W}$, where $H$ and $W$ are the grid’s height and width and $C=38$ channels encode the current observation together with a memory augmentation (for example, the location of the opponent’s base once it has been spotted). The spatial tensor is split into $3\times 3$ patches, and each patch is embedded into a single input token. Two additional non-spatial tokens carry global temporal statistics rather than per-cell features: a 512-step sliding window of the opponent’s total army count and a matching window of their total land count, each projected by an MLP into a single token. These trajectories let the agent infer what the opponent is doing behind the fog of war, whether they are expanding or consolidating, from the way the scoreboard totals evolve.
Value and policy heads sit on top of the torso; the policy head produces an $H\times W\times 9$ distribution that, for each source cell, assigns a probability to each of nine actions: pass, or one of two move types (send all units or send half) in each of the four cardinal directions ($1+2\times 4=9$). Transformer hyperparameters are listed in Table II; Appendix A gives the observation-channel layout.
TABLE II: Network hyperparameters.


## Key insights
- A JAX-native Generals.io environment <sup>1</sup> that reaches tens of millions of frames per second on a single GPU and supports all three game modes through a shared action and observation interface, enabling research in cooperative and general-sum multi-agent reinforcement learning.
- Correspondence: straka@kam.mff.cuni.cz

###### Abstract

We present a superhuman AI agent for Generals.io, a real-time strategy game that requires both long-horizon planning and short-term tactics under strong imperfect information.
- An *outer loop* constructs that pool: it decides which policies enter it, how they are weighted, and when to introduce new ones.
- - A superhuman agent from policy-gradient methods <sup>2</sup> (Sections V and VI).
- Section V describes the agent: network architecture, training objective, spawn-distance curriculum, parameter EMA, and top-advantage filtering.
- Section VI reports the human-leaderboard result and head-to-head scores against the top two humans and the strongest non-learning bot.
- [^2] highlighted Generals.io as a promising testbed for AI research and built a data-collection and bot-integration framework, releasing a rule-based agent, Flobot.
- [^22] likewise framed Generals.io as a cost-effective analogue of Dota 2 and StarCraft II, and proposed a hierarchical self-play agent (HASP) that reaches a reported 77% win rate against Flobot.
- Both agents are also far below the community-developed Human.exe, the strongest *non-learning* agent, which wins close to 100% of games against either.
- Straka and Schmid [^19] introduced a gym-like, NumPy-based Generals.io environment and trained a PPO agent that reached a top-25 placement on the 1v1 leaderboard, above Human.exe, relying on behavior cloning from expert replays, potential-based reward shaping, and population-based self-play.

## Exemplos e evidências
See original source at `Clippings/Superhuman AI for Generals.io Using Self-Play Reinforcement Learning.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/token]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
