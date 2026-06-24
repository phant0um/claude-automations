---
title: "OpenClaw-Skill: Collective Skill Tree Search for Agentic Large Language Models"
source: "https://arxiv.org/html/2606.16774v1"
author:
published:
created: 2026-06-22
description:
tags:
  - "clippings"
---
Tianyi Lin <sup>1</sup>, Chuanyu Sun <sup>1</sup> <sup>1</sup>, Jingyi Zhang <sup>2</sup>, Changxu Wei <sup>1</sup>, Huanjin Yao <sup>3</sup>, Shunyu Liu <sup>2</sup>,  
Xikun Zhang <sup>4</sup>, Liu Liu <sup>5</sup>, Jiaxing Huang <sup>1</sup>  
<sup>1</sup> The Hong Kong Polytechnic University  
<sup>2</sup> Nanyang Technological University  
<sup>3</sup> Tsinghua University  
<sup>4</sup> Royal Melbourne Institute of Technology  
<sup>5</sup> Beijing University of Aeronautics and Astronautics Equal contribution.Corresponding author.

###### Abstract

Equipping Large Language Model (LLM) agents with effective skills is crucial for solving complex tasks in real-world systems like OpenClaw. In this work, we aim to develop a framework that automatically constructs such reusable skills to enhance LLMs in tool use, multi-step reasoning, and dynamic environment interaction. To this end, we propose Collective Skill Tree Search (CSTS), a novel tree-search-based skill construction framework that constructs structured, diverse and generalizable tree of skills. The core idea of CSTS is to leverage collective intelligence to jointly search, identify and compose effective skills via two iterative phases: Collective Skill Node Generation (CSN-Gen) and Collective Skill Node Assessment (CSN-Assess). CSN-Gen exploits collective knowledge from multiple models to explore diverse candidate skills for each subtask, enabling comprehensive skill exploration. CSN-Assess employs multiple models as judges to evaluate and select skill nodes with two scoring mechanisms: (1) collective quality scoring that aggregates independent evaluations to produce a robust estimate of skill effectiveness, and (2) collective transferability scoring that explicitly verifies whether a skill generalizes well across different models. With CSTS, we construct a set of comprehensive tree of skills along with skill-augmented training data, enabling models to effectively learn and utilize skills. Besides, we introduce Collective Skill Reinforcement Learning, which actively selects multiple relevant skills from the tree to broaden solution-space exploration, avoid being trapped by a single skill and its resulting homogeneous or suboptimal solutions. As a result, our trained model, OpenClaw-Skill, exhibits outstanding agentic capabilities in long-horizon planning, tool use and generalization over challenging benchmarks.

## 1 Introduction

Large Language Model (LLM) agents have recently demonstrated strong potential for solving complex real-world tasks through natural language instructions [^36] [^3] [^13] [^12], particularly in interactive environments such as OpenClaw [^37], where LLM agents [^26] [^61] [^44] are required to coordinate files, tools, web pages, execution feedback, and intermediate artifacts over multiple steps. To further improve the reliability and generalization of such OpenClaw-like systems, recent studies have introduced the concept of “skills” [^52] [^10] [^27], which encapsulate compact and reusable procedural strategies for accomplishing recurring subtasks, such as tool use, verification, and error recovery.

However, current skills [^4] are largely handcrafted and require substantial manual design and maintenance, making large-scale skill construction costly, time-consuming, and labor-intensive, thereby significantly limiting scalability.

To address this issue, recent studies [^52] [^2] [^65] have explored automatic skill construction and maintenance. For example, by distilling LLM agent execution experiences and raw trajectories into reusable procedural knowledge, SkillRL [^51] learns a skill bank from past interactions to facilitate policy improvement while Trace2Skill [^33] consolidates trajectory-local lessons and common patterns into agent skills. In addition, CoEvoSkills [^65] enables skill refinement by integrating skill generation with surrogate verification, allowing skills to be iteratively evaluated and revised according to execution feedback.

![Refer to caption](https://arxiv.org/html/2606.16774v1/x1.png)

Figure 1: Motivation. Current skill construction paradigms generally face several limitations: (a) Skill Fragmentation, capturing merely local procedures for isolated subtasks; (b) Limited Diversity, suffering from the inherent biases of a single model; and (c) Poor Transferability, exhibiting clear performance drops across different LLM backbones. To tackle these challenges, we propose CSTS, a novel tree-search-based skill construction framework that constructs structured, diverse, and generalizable tree of skills, empowering LLMs in solving sophisticated tasks in real-world systems.

Despite these advances, most current paradigms for skill construction and maintenance still face several limitations, particularly for long-horizon tasks in real-world interactive environments such as OpenClaw, as illustrated in Figure 1: (1) Skill Fragmentation: Current methods often produce fragmented and unstructured skills that merely capture local procedures for individual subtasks, but lack explicit mechanisms to orchestrate skill sequences, handle long-term dependencies, and verify execution across multiple steps; (2) Limited Skill Diversity: existing approaches typically construct the skill from a narrow set of trajectories generated by a single model. As a result, the constructed skills are inherently biased toward the problem-solving preferences of that model, limiting their coverage across diverse task types and reasoning strategies. (3) Limited Skill Transferability: Skills acquired through current methods often exhibit limited generalization ability. In particular, their performance tends to degrade clearly when transferred to different backbone LLMs.

To tackle these challenges, we propose Collective Skill Tree Search (CSTS), a new tree-search-based skill construction framework that constructs structured, diverse and generalizable skills for LLM agents, enhancing their capability in solving sophisticated real-world tasks. Specifically, CSTS works by leveraging collective intelligence to jointly search, identify and compose effective skills iteratively towards cohesive and reliable “tree of skills”. CSTS operates through two iterative phases: Collective Skill Node Generation (CSN-Gen) and Collective Skill Node Assessment (CSN-Assess). In skill node generation phase, CSN-Gen exploits collective knowledge from multiple models to explore diverse candidate skills for the current subtask, enabling rich and comprehensive skill discovery. In skill node assessment phase, CSN-Assess employs multiple models as judges to evaluate and select skill nodes with strong effectiveness and transferability through two scoring mechanisms. The first is collective skill quality scoring, where multiple judges independently assess the skill quality and aggregate their evaluations into a robust score. The second is collective skill transferability scoring, which works by measuring whether a skill synthesized by one model can effectively benefit other models, thereby explicitly encouraging the selection of highly generalizable skills.

In this way, our proposed CSTS enables structured, diverse, and transferable skill construction: (1) “Tree of skills” mitigates skill fragmentation. By modeling skills as nodes and subtask-solving procedures as paths, CSTS transforms isolated local skills into structured, dependency-aware skill hierarchies, enabling LLM agents to effectively compose and orchestrate skill sequences across complex multi-stage tasks. (2) The design of collective skill node generation enhances skill diversity. By aggregating candidate skills from multiple heterogeneous models, CSN-Gen explicitly alleviates single-model bias and enriches the skill space with diverse and complementary behavioral patterns, thereby reducing overfitting to specific reasoning styles. (3) The design of collective skill transferability scoring improves skill transferability. By requiring skills synthesized by one model to effectively benefit other models, this mechanism explicitly encourages capturing skills that generalize well across different backbone LLMs, leading to generalizable performance.

Based on our proposed CSTS, we construct a set of comprehensive tree of skills together with skill-augmented training data for complex tasks under OpenClaw-style systems. By using these skill-augmented training data, we first train our model via Supervised Fine-Tuning (SFT). In addition, we propose Collective Skill Reinforcement Learning (CSRL) to further optimize the model and obtain our final model, termed OpenClaw-Skill. Specifically, for each task, our CSRL actively selects multiple relevant skills from the tree of skills to substantially broaden the exploration of the solution space, thereby preventing the model from being trapped in a single skill and its resulted homogeneous or suboptimal solutions. As a result, the model is allowed to adaptively fit the most appropriate skill among multiple candidate skills, significantly improving the flexibility, robustness, and effectiveness of skill reinforcement learning.

The main contributions of this work are summarized as follows. First, we introduce Tree Search into skill construction for LLM agents and propose Collective Skill Tree Search (CSTS), which leverages collective intelligence to jointly search, identify and compose effective skills iteratively towards cohesive and reliable “tree of skills”. Second, we construct a set of comprehensive tree of skills and skill-augmented training data for complex tasks in OpenClaw-style systems, enabling models to learn procedural knowledge from collective agent experiences. Third, we introduce Collective Skill Reinforcement Learning (CSRL), which further optimize capabilities of the model by actively selecting multiple skills to broaden the exploration of the solution space, thereby preventing the model from being trapped in a single skill and its induced homogeneous and low-quality solutions. Fourth, we develop OpenClaw-Skill, a series of models with outstanding capabilities in long-horizon planning, tool use, error recovery and cross-task generalization, demonstrating superior performance on multiple challenging benchmarks.

## 2 Related Works

### 2.1 Large Language Model Agents

Recent advances have transformed large language models [^46] [^47] [^57] [^18] [^17] [^16] [^15] [^14] [^38] from static text generators into interactive agents capable of interleaving reasoning, action, and environment feedback [^39] [^29] [^11] [^49] [^64]. ReAct [^61] first established a simple yet influential reasoning–acting paradigm for sequential decision-making and tool use, while WebVoyager [^22] and OSWorld [^55] pushed LLM agents toward more realistic web and computer-use tasks. This shift has driven the emergence of agent harnesses that expose models to filesystems, browsers, and desktop applications. OpenClaw [^37] firstly exemplifies a move beyond toy environments toward real-world persistent runtimes with messaging interfaces, sessions, tools, and structured workspace state. Building on this paradigm, DeerFlow [^9] and Hermes [^34] further extend OpenClaw by enabling richer access to memory, sandboxed, and communication. ClawGym [^7] and OpenClaw-RL [^50] take initial steps toward studying data generation and model training in such Claw-style environments. Nevertheless, how to automatically construct effective skills to guide LLM agents to accomplish complex tasks in real-world systems remains a significant open challenge.

### 2.2 Skills for Large Language Model Agents

Anthropic first introduced the concept of skills [^4] as reusable procedural knowledge that encapsulates instructions and tool-usage patterns, enabling agents to dynamically extend their capabilities at inference time. Recently, a growing body of work has begun to explore the evaluation, generation, and utilization of LLM skills [^66] [^48] [^24] [^56] [^58] [^65] [^33] [^2] [^52] [^10] [^23] [^28]. For example, SkillRL [^52] constructs a SkillBank and learns skill invocation policies via reinforcement learning. Trace2Skill [^33] consolidates trajectory-local lessons into skill repositories. Despite recent progress, current skill construction paradigms still suffer from several limitations, especially for long-horizon tasks in real-world environments such as OpenClaw, including skill fragmentation, limited skill diversity, and weak skill transferability. Different from previous approaches, our CSTS introduces a novel tree-search-based skill construction framework that builds structured, diverse, and generalizable trees of skills, empowering LLM agents to solve sophisticated tasks in real-world systems.

### 2.3 Tree Search

Tree search has emerged as an important paradigm for improving decision-making and LLM reasoning [^26] [^60] [^59] [^67] [^45] [^62]. A representative example is AlphaGo [^45], which combines neural network priors with tree search to enable strategic planning and decision-making, achieving remarkable performance in complex board and video game environments [^45] [^62]. Tree Search for Language Model Agents showed that explicit search over action trajectories can substantially improve success rates in realistic web environments [^26]. Inspired by these advances, we introduces the concept of “tree search” into automatic skill construction, and propose CSTS, a novel framework that decomposes complex tasks into subtasks and leverages collective intelligence to jointly search, identify and compose effective skills iteratively towards cohesive and reliable “tree of skills”.

## 3 Method

We first present Collective Skill Tree Search (CSTS) that constructs structured, diverse, and transferable tree of skills via collective intelligence, and describe training data construction with CSTS and model training. We then introduce Collective Skill Reinforcement Learning (CSRL) that further optimizes the model by comparing trajectories conditioned on different skills under the same subtask.

### 3.1 Collective Skill Tree Search

The core idea of CSTS is to utilize collective intelligence to jointly search, identify and compose effective skill iteratively towards cohesive and reliable “tree of skills”. Specifically, CSTS first conducts (1) Complex Task Decomposition, and then operates via two iterative phases, including (2) Collective Skill Node Generation (CSN-Gen) and (3) Collective Skill Node Assessment (CSN-Assess), which together organize skills into a tree, where each layer corresponds to a subtask and each node denotes a candidate skill. A path through the tree represents a compositional skill path that specifies how local skills are selected and ordered across subtasks.

Complex Task Decomposition. Given a complex task $T$, CSTS first decomposes it into an ordered sequence of subtasks:

$$
T\rightarrow(t_{1},t_{2},\ldots,t_{M}).
$$

This decomposition identifies the main procedural stages, such as locating files, inspecting configurations, constructing commands, executing tools, diagnosing failures, and verifying outputs. It defines the skill-tree depth: the $m$ -th layer corresponds to subtask $t_{m}$. CSTS then performs skill generation and assessment for each subtask layer.

![Refer to caption](https://arxiv.org/html/2606.16774v1/x2.png)

Figure 2: Overview of our OpenClaw-Skill with CSTS and CSRL. Given a complex agentic task, CSTS first decomposes it into subtasks and iteratively constructs skill nodes for each subtask. For each subtask, CSN-Gen summarizes diverse trajectories from multiple heterogeneous agents into candidate collective skill nodes. CSN-Assess then evaluates and selects these nodes via collective skill quality assessment and collective skill transferability assessment. The selected skill nodes form a tree-structured search space, where each path represents a compositional skill plan capturing stage-wise dependencies across subtasks. The bottom panel shows CSRL, where the model generates skill-conditioned trajectory groups and is optimized with a Collective Skill GRPO Update using relative advantages across skills under the same subtask.

Collective Skill Node Generation (CSN-Gen). For each subtask $t_{m}$, CSTS collectively generates multiple candidate skill nodes from trajectories produced by a group of models. Let

$$
\mathcal{M}=\{M_{1},M_{2},\ldots,M_{N}\}
$$

denote the set of participating models. Each model $M_{n}$ attempts to solve the same subtask $t_{m}$ and produces an execution trajectory:

$$
\tau_{m,n}=\pi_{\theta_{n}}(\cdot\mid t_{m})=\left(t_{m},\{(\psi_{m,n}^{\ell},a_{m,n}^{\ell},o_{m,n}^{\ell})\}_{\ell=1}^{L_{m,n}},r_{m,n}\right),
$$

where $\psi_{m,n}^{\ell}$, $a_{m,n}^{\ell}$, and $o_{m,n}^{\ell}$ denote the intermediate reasoning state, agent action, and observation or execution feedback at step $\ell$, respectively. The action $a_{m,n}^{\ell}$ may correspond to a tool call, file operation, code execution, or textual response, depending on the interaction context. The scalar $r_{m,n}$ denotes the final execution outcome or correctness signal of the trajectory.

Collective skill node generation mitigates single-model bias by exposing skill construction to diverse procedural evidence for the same subtask. Different models may explore different solution routes, encounter different failure modes, and reveal different verification opportunities. This diversity is important for constructing candidate skills that cover a broader range of planning, execution, diagnosis, and recovery patterns.

To efficiently obtain diverse candidate skills, CSTS uses a shared skill synthesizer $\Phi_{\mathrm{skill}}$ to summarize each trajectory into a candidate skill node:

$$
s_{m,n}=\Phi_{\mathrm{skill}}(t_{m},\tau_{m,n}).
$$

The resulting candidate skill set for subtask $t_{m}$ is

$$
\mathcal{S}_{m}=\{s_{m,1},s_{m,2},\ldots,s_{m,N}\}.
$$

Each skill $s_{m,n}$ describes a reusable procedure for solving $t_{m}$, including its applicable context, required inputs, recommended actions, expected outputs, verification criteria, and recovery strategies. Since trajectory generation is performed in parallel across models and skill synthesis is applied uniformly to each trajectory, CSN-Gen improves both the efficiency and diversity of candidate skill construction.

Collective Skill Node Assessment (CSN-Assess). After generating candidate skills for each subtask, CSTS evaluates each skill node from two complementary perspectives: collective skill quality and collective skill transferability. For collective skill quality assessment, multiple judge models independently evaluate whether a skill is clear, executable, complete, and relevant to the target subtask. Given the judge score $q_{m,n}^{j}$ assigned by judge $j$, the collective quality score of skill $s_{m,n}$ is defined as

$$
Q_{m,n}=\frac{1}{J}\sum_{j=1}^{J}q_{m,n}^{j}.
$$

For collective skill transferability assessment, CSTS further measures whether a skill synthesized from one model can benefit other models. Specifically, skill $s_{m,n}$, distilled from the trajectory of model $M_{n}$ on subtask $t_{m}$, is shared with the remaining models $\{M_{k}\}_{k\neq n}$. Each model $M_{k}$ then uses $s_{m,n}$ as additional context to solve the same subtask $t_{m}$, producing a skill-conditioned rollout:

$$
\tilde{\tau}_{m,n}^{k}\sim\pi_{\theta_{k}}(\cdot\mid t_{m},s_{m,n}),\qquad k\neq n.
$$

Let $r_{m,n}^{k}$ denote the verification score of the rollout $\tilde{\tau}_{m,n}^{k}$. The transferability score is computed over the $N-1$ models that did not produce the original skill:

$$
\mathrm{Tran}_{m,n}=\frac{1}{N-1}\sum_{\begin{subarray}{c}k=1\\
k\neq n\end{subarray}}^{N}r_{m,n}^{k}.
$$

This design favors skills that are not merely effective for the model from which they are distilled, but can also provide reusable procedural guidance to other models. The final score of a candidate skill node combines its collective quality and transferability:

$$
\mathrm{Score}(s_{m,n})=Q_{m,n}+\mathrm{Tran}_{m,n}.
$$

For each subtask $t_{m}$, CSTS selects the highest-scoring skill node as

$$
s_{m}^{\star}=\operatorname*{arg\,max}_{s_{m,n}\in\mathcal{S}_{m}}\mathrm{Score}(s_{m,n}).
$$

The selected nodes are then organized according to the task decomposition $T=(t_{1},\ldots,t_{M})$. Specifically, the skill path for the complex task $T$ is defined as

$$
S_{T}^{\star}=(s_{1}^{\star},s_{2}^{\star},\ldots,s_{M}^{\star}),
$$

where each $s_{m}^{\star}$ provides procedural guidance for subtask $t_{m}$. In this way, $S_{T}^{\star}$ is not a single skill, but an ordered composition of subtask-level skills for solving the full task $T$.

CSTS uses the selected skill path $S_{T}^{\star}$ to augment agent trajectories with structured skill guidance, yielding skill-augmented training data. These data are subsequently used for supervised fine-tuning (SFT), enabling the policy to learn the basic procedural structure before reinforcement learning. For each task $T$, we construct an SFT instance

$$
(T,S_{T}^{\star},\tau_{T}^{\star})\in\mathcal{D}_{\mathrm{SFT}},
$$

where $S_{T}^{\star}$ is the selected compositional skill path and $\tau_{T}^{\star}$ is the demonstration trajectory assembled from the model rollouts that produced the selected skills. The SFT objective is

$$
\mathcal{L}_{\mathrm{SFT}}(\theta)=-\mathbb{E}_{(T,S_{T}^{\star},\tau_{T}^{\star})\sim\mathcal{D}_{\mathrm{SFT}}}\log\pi_{\theta}\left(\tau_{T}^{\star}\mid T,S_{T}^{\star}\right).
$$

### 3.2 Collective Skill Reinforcement Learning

Although CSTS provides structured skill paths for supervised initialization, the resulting policy is not explicitly optimized to distinguish which skill-conditioned strategies are more effective when multiple candidate skills are available for the same subtask. To address this, we introduce Collective Skill Reinforcement Learning (CSRL), which extends group-relative policy optimization to skill-conditioned rollout groups.

For each subtask $t_{m}$, given its candidate skill set $\mathcal{S}_{m}$, the old policy samples $G$ rollouts conditioned on each skill:

$$
\tau_{m,n}^{g}\sim\pi_{\theta_{\mathrm{old}}}(\cdot\mid t_{m},s_{m,n}),\qquad g=1,\ldots,G.
$$

All rollouts for the same subtask form a collective skill-conditioned group

$$
\mathcal{B}_{m}=\{\tau_{m,n}^{g}\mid s_{m,n}\in\mathcal{S}_{m},\;g=1,\ldots,G\}.
$$

Each rollout is evaluated by a verifier or reward model as $r_{m,n}^{g}=R(t_{m},s_{m,n},\tau_{m,n}^{g})$, where the reward may reflect final task success, tool-use correctness, intermediate verification, and recovery from execution errors.

Instead of normalizing rewards only within rollouts generated from the same skill, CSRL computes relative advantages over the whole collective group $\mathcal{B}_{m}$. Specifically, with group mean $\mu_{m}$ and standard deviation $\sigma_{m}$, the advantage is

$$
A_{m,n}^{g}=\frac{r_{m,n}^{g}-\mu_{m}}{\sigma_{m}+\delta},\qquad\mu_{m}=\frac{1}{|\mathcal{B}_{m}|}\sum_{\tau_{m,n}^{g}\in\mathcal{B}_{m}}r_{m,n}^{g},\quad\sigma_{m}=\operatorname{Std}\{r_{m,n}^{g}\mid\tau_{m,n}^{g}\in\mathcal{B}_{m}\}.
$$

This cross-skill normalization makes each rollout compete with trajectories generated under alternative skills for the same subtask, encouraging the policy to favor more effective skill-conditioned strategies.

We then optimize the policy with a GRPO-style clipped objective. For each rollout $\tau_{m,n}^{g}$, let $L_{m,n}^{g}$ denote its length, and let

$$
h_{m,n,<\ell}^{g}=\{(\psi_{m,n,j}^{g},a_{m,n,j}^{g},o_{m,n,j}^{g})\}_{j<\ell}
$$

denote the interaction history before step $\ell$, including previous reasoning states, actions, and observations. The action-level probability ratio is then defined as

$$
\rho_{m,n,\ell}^{g}(\theta)=\frac{\pi_{\theta}\left(a_{m,n,\ell}^{g}\mid t_{m},s_{m,n},h_{m,n,<\ell}^{g}\right)}{\pi_{\theta_{\mathrm{old}}}\left(a_{m,n,\ell}^{g}\mid t_{m},s_{m,n},h_{m,n,<\ell}^{g}\right)}.
$$

For compactness, we define the clipped surrogate term as

$$
u_{m,n,\ell}^{g}(\theta)=\min\left(\rho_{m,n,\ell}^{g}(\theta)A_{m,n}^{g},\operatorname{clip}(\rho_{m,n,\ell}^{g}(\theta),1-\epsilon,1+\epsilon)A_{m,n}^{g}\right).
$$

Then, the CSRL loss is defined as follows to train our final model, OpenClaw-Skill:

$$
\mathcal{L}_{\mathrm{CSRL}}(\theta)=-\mathbb{E}_{t_{m},\mathcal{B}_{m}}\left[\frac{1}{|\mathcal{B}_{m}|}\sum_{\tau_{m,n}^{g}\in\mathcal{B}_{m}}\frac{1}{L_{m,n}^{g}}\sum_{\ell=1}^{L_{m,n}^{g}}u_{m,n,\ell}^{g}(\theta)\right].
$$

Through this objective, CSRL increases the likelihood of actions from high-reward rollouts whose advantages are positive relative to the collective skill-conditioned group, while suppressing ineffective skill-conditioned behaviors. In this way, CSTS constructs the collective skill space, and CSRL converts the relative effectiveness of different skills into a direct policy optimization signal.

## 4 Experiments

In this section, we first provide implementation details, and then present main results on two real-world agentic benchmarks, i.e., QwenClawBench and PinchBench, which cover a broad range of long-horizon agentic tasks involving tool use, file operations, code execution, web interaction, multi-step decision making, etc. In final, we provide ablation studies and discussion on our methods.

### 4.1 Implementation Details

We conduct experiments based on four popular backbones, including Qwen3-4B, Qwen3-8B, Qwen3.5-4B, and Qwen3.5-9B. During training, CSTS first decomposes each task into subtasks, collects multi-agent rollouts, synthesizes candidate skill nodes, and constructs skill-augmented trajectories. Using CSTS, we collect 2K high-quality SFT examples and fine-tune each model for 2 epochs on 8 H100 GPUs with a learning rate of $5\times 10^{-6}$. We evaluate on QwenClawBench and PinchBench, reporting category-level and overall scores for the former, and best-run and mean success rates for the latter.

### 4.2 Main Results

Table 1: Comparis In this section, we first provide implementation detail, and then present main results, trained with CSTS-generated data and CSRL, against other models on QwenClawBench across multiple task categories [^40] [^42].

<table><tbody><tr><td>Model</td><td>WAO</td><td>SOA</td><td>KMM</td><td>FQT</td><td>DAM</td><td>SVM</td><td>CS</td><td>RIR</td><td>Overall</td></tr><tr><td colspan="10">Closed-source models</td></tr><tr><td>Claude Opus 4.6 <sup><a href="#fn:6">6</a></sup></td><td>57.8</td><td>57.3</td><td>55.6</td><td>48.5</td><td>54.3</td><td>76.8</td><td>67.3</td><td>71.0</td><td>59.5</td></tr><tr><td>Qwen3.6-Plus <sup><a href="#fn:43">43</a></sup></td><td>56.2</td><td>52.2</td><td>55.1</td><td>46.6</td><td>56.1</td><td>76.9</td><td>62.6</td><td>67.5</td><td>57.4</td></tr><tr><td>GPT-5.4 <sup><a href="#fn:35">35</a></sup></td><td>55.2</td><td>54.3</td><td>57.9</td><td>38.4</td><td>52.6</td><td>70.6</td><td>71.1</td><td>63.7</td><td>56.7</td></tr><tr><td>MiMo-V2-Pro <sup><a href="#fn:54">54</a></sup></td><td>57.1</td><td>49.1</td><td>57.3</td><td>46.4</td><td>53.4</td><td>74.0</td><td>60.6</td><td>64.9</td><td>56.5</td></tr><tr><td colspan="10">Open-source / open-weight models</td></tr><tr><td>GLM-5.1 <sup><a href="#fn:63">63</a></sup></td><td>63.1</td><td>53.3</td><td>58.8</td><td>39.4</td><td>49.4</td><td>75.7</td><td>66.9</td><td>70.8</td><td>58.7</td></tr><tr><td>Kimi-K2.5 <sup><a href="#fn:32">32</a></sup></td><td>51.6</td><td>51.5</td><td>50.7</td><td>39.3</td><td>46.3</td><td>62.2</td><td>60.2</td><td>59.8</td><td>51.9</td></tr><tr><td>DeepSeek-V3.2-Thinking <sup><a href="#fn:19">19</a></sup></td><td>45.5</td><td>46.8</td><td>49.7</td><td>35.6</td><td>57.1</td><td>63.8</td><td>63.7</td><td>60.7</td><td>50.7</td></tr><tr><td>MiniMax-M2.7 <sup><a href="#fn:31">31</a></sup></td><td>46.6</td><td>46.5</td><td>53.7</td><td>40.6</td><td>54.2</td><td>62.7</td><td>51.7</td><td>58.7</td><td>50.5</td></tr><tr><td>Gemma4-31B <sup><a href="#fn:21">21</a></sup></td><td>–</td><td>–</td><td>–</td><td>–</td><td>–</td><td>–</td><td>–</td><td>–</td><td>41.7</td></tr><tr><td>Gemma4-26B-A4B <sup><a href="#fn:21">21</a></sup></td><td>–</td><td>–</td><td>–</td><td>–</td><td>–</td><td>–</td><td>–</td><td>–</td><td>38.7</td></tr><tr><td>Qwen3-4B <sup><a href="#fn:47">47</a></sup></td><td>6.6</td><td>10.8</td><td>7.1</td><td>0.8</td><td>7.2</td><td>2.5</td><td>6.3</td><td>13.2</td><td>7.0</td></tr><tr><td>OpenClaw-Skill-Qwen3 4B</td><td>13.5</td><td>10.2</td><td>21.9</td><td>2.9</td><td>10.1</td><td>11.3</td><td>23.3</td><td>7.2</td><td>12.8 <math><semantics><msup><mrow><mtext>5.8</mtext> <mo>↑</mo></mrow></msup> <annotation>{}^{\color[rgb]{0,.5,.5}\definecolor[named]{pgfstrokecolor}{rgb}{0,.5,.5}{\textbf{\scriptsize 5.8}\uparrow}}</annotation></semantics></math></td></tr><tr><td>Qwen3-8B <sup><a href="#fn:47">47</a></sup></td><td>17.3</td><td>7.9</td><td>13.0</td><td>2.0</td><td>14.2</td><td>13.1</td><td>9.3</td><td>10.7</td><td>11.5</td></tr><tr><td>OpenClaw-Skill-Qwen3 8B</td><td>12.7</td><td>15.9</td><td>18.2</td><td>5.8</td><td>9.4</td><td>22.0</td><td>34.3</td><td>13.3</td><td>15.8 <math><semantics><msup><mrow><mtext>4.3</mtext> <mo>↑</mo></mrow></msup> <annotation>{}^{\color[rgb]{0,.5,.5}\definecolor[named]{pgfstrokecolor}{rgb}{0,.5,.5}{\textbf{\scriptsize 4.3}\uparrow}}</annotation></semantics></math></td></tr><tr><td>Qwen3.5-4B <sup><a href="#fn:41">41</a></sup></td><td>24.3</td><td>28.8</td><td>34.2</td><td>15.4</td><td>34.3</td><td>48.3</td><td>55.4</td><td>24.4</td><td>31.5</td></tr><tr><td>OpenClaw-Skill 4B</td><td>35.8</td><td>46.1</td><td>46.7</td><td>7.8</td><td>33.2</td><td>51.5</td><td>61.0</td><td>54.1</td><td>41.2 <math><semantics><msup><mrow><mtext>9.7</mtext> <mo>↑</mo></mrow></msup> <annotation>{}^{\color[rgb]{0,.5,.5}\definecolor[named]{pgfstrokecolor}{rgb}{0,.5,.5}{\textbf{\scriptsize 9.7}\uparrow}}</annotation></semantics></math></td></tr><tr><td>Qwen3.5-9B <sup><a href="#fn:41">41</a></sup></td><td>26.6</td><td>39.9</td><td>58.8</td><td>15.4</td><td>19.9</td><td>33.2</td><td>30.2</td><td>44.8</td><td>34.5</td></tr><tr><td>OpenClaw-Skill 9B</td><td>32.3</td><td>43.3</td><td>60.2</td><td>14.2</td><td>28.4</td><td>70.9</td><td>78.4</td><td>50.1</td><td>44.9 <math><semantics><msup><mrow><mtext>10.4</mtext> <mo>↑</mo></mrow></msup> <annotation>{}^{\color[rgb]{0,.5,.5}\definecolor[named]{pgfstrokecolor}{rgb}{0,.5,.5}{\textbf{\scriptsize 10.4}\uparrow}}</annotation></semantics></math></td></tr></tbody></table>

#### Results on QwenClawBench.

Table 1 shows that OpenClaw-Skill brings consistent overall gains across all evaluated Qwen backbones. The overall score improves by 5.8 points for Qwen3-4B, 4.3 points for Qwen3-8B, 9.7 points for Qwen3.5-4B, and 10.4 points for Qwen3.5-9B. Notably, OpenClaw-Skill 4B and OpenClaw-Skill 9B, which are built on Qwen3.5 backbones by default, reach 41.2 and 44.9 overall, respectively.

The gains are most evident on categories involving long-horizon tool use and execution feedback. For instance, OpenClaw-Skill 9B improves SVM from 33.2 to 70.9 and CS from 30.2 to 78.4, while OpenClaw-Skill 4B improves RIR from 24.4 to 54.1. This suggests that CSTS-generated skills and CSRL improve the model’s ability to follow procedural guidance, verify intermediate states, and recover from execution errors.

Table 2: Comparison of OpenClaw-Skill, trained with CSTS-generated data and CSRL, against other models on PinchBench [^25] over 23-task original version and its 123-task expanded version.

<table><tbody><tr><th>Model</th><td colspan="2">PinchBench (23 tasks)</td><td colspan="2">PinchBench (123 tasks)</td></tr><tr><th></th><td>Best (%)</td><td>Average (%)</td><td>Best (%)</td><td>Average (%)</td></tr><tr><th colspan="5">Closed-source models</th></tr><tr><th>Claude-Opus-4.6 <sup><a href="#fn:6">6</a></sup></th><td>93.3</td><td>81.6</td><td>88.9</td><td>67.5</td></tr><tr><th>Claude-Haiku-4.5 <sup><a href="#fn:5">5</a></sup></th><td>89.5</td><td>77.4</td><td>90.3</td><td>58.9</td></tr><tr><th>GPT-5.4 <sup><a href="#fn:35">35</a></sup></th><td>90.5</td><td>79.4</td><td>–</td><td>–</td></tr><tr><th>Gemini-3.1-Pro-Preview <sup><a href="#fn:20">20</a></sup></th><td>86.7</td><td>77.5</td><td>81.7</td><td>80.2</td></tr><tr><th>MiMo-V2-Pro <sup><a href="#fn:54">54</a></sup></th><td>87.4</td><td>80.4</td><td>–</td><td>–</td></tr><tr><th colspan="5">Open-source / open-weight models</th></tr><tr><th>MiniMax-M2.7 <sup><a href="#fn:31">31</a></sup></th><td>89.8</td><td>82.8</td><td>–</td><td>–</td></tr><tr><th>MiMo-V2-Flash <sup><a href="#fn:53">53</a></sup></th><td>88.8</td><td>69.7</td><td>–</td><td>–</td></tr><tr><th>Qwen3.6-Plus <sup><a href="#fn:43">43</a></sup></th><td>63.9</td><td>63.3</td><td>82.8</td><td>62.6</td></tr><tr><th>GPT-OSS-120B <sup><a href="#fn:1">1</a></sup></th><td>67.1</td><td>52.0</td><td>47.4</td><td>44.5</td></tr><tr><th>GPT-OSS-20B <sup><a href="#fn:1">1</a></sup></th><td>66.0</td><td>50.3</td><td>41.8</td><td>37.5</td></tr><tr><th>Nemotron-3-Super-120B-A12B <sup><a href="#fn:8">8</a></sup></th><td>–</td><td>–</td><td>50.6</td><td>38.6</td></tr><tr><th>Llama 4 Maverick <sup><a href="#fn:30">30</a></sup></th><td>46.1</td><td>34.8</td><td>–</td><td>–</td></tr><tr><th>Qwen3-4B <sup><a href="#fn:47">47</a></sup></th><td>45.2</td><td>31.8</td><td>22.4</td><td>13.6</td></tr><tr><th>OpenClaw-Skill-Qwen3-4B</th><td>64.5</td><td>47.9</td><td>31.1</td><td>20.8</td></tr><tr><th>Qwen3-8B <sup><a href="#fn:47">47</a></sup></th><td>49.8</td><td>35.4</td><td>27.9</td><td>18.3</td></tr><tr><th>OpenClaw-Skill-Qwen3 8B</th><td>64.9</td><td>49.2</td><td>33.0</td><td>22.5</td></tr><tr><th>Qwen3.5-4B <sup><a href="#fn:41">41</a></sup></th><td>71.0</td><td>55.7</td><td>60.9</td><td>45.9</td></tr><tr><th>OpenClaw-Skill 4B</th><td>71.5</td><td>56.4</td><td>61.4</td><td>47.6</td></tr><tr><th>Qwen3.5-9B <sup><a href="#fn:41">41</a></sup></th><td>67.5</td><td>53.8</td><td>61.1</td><td>47.1</td></tr><tr><th>OpenClaw-Skill 9B</th><td>72.8</td><td>58.9</td><td>68.2</td><td>53.6</td></tr></tbody></table>

#### Results on PinchBench.

Table 2 reports results on PinchBench. OpenClaw-Skill consistently improves the corresponding Qwen backbones on both the 23-task early benchmark and the 123-task expanded benchmark. On the 23-task setting, OpenClaw-Skill 9B improves Qwen3.5-9B from 67.5 to 72.8 in best success rate and from 53.8 to 58.9 in average success rate. On the 123-task setting, the gain is more evident: OpenClaw-Skill 9B improves the best score from 61.1 to 68.2 and the average score from 47.1 to 53.6. The 4B models also show consistent gains. OpenClaw-Skill 4B improves Qwen3.5-4B from 60.9 to 61.4 in best score and from 45.9 to 47.6 in average score on the 123-task setting. For the smaller Qwen3 backbones, OpenClaw-Skill also improves the average score from 13.6 to 20.8 for Qwen3-4B and from 18.3 to 22.5 for Qwen3-8B. These results suggest that CSTS-generated skills and CSRL improve both peak performance and average execution robustness across different PinchBench versions.

### 4.3 Ablation Study

Table 3 studies the contribution of each component in OpenClaw-Skill using Qwen3.5-9B as the backbone. Starting from the base model, adding CSN-Gen improves the overall score from 34.5 to 39.8, showing that diverse skills distilled from collective trajectories provide useful procedural supervision. Further incorporating CSN-Assess increases the score to 42.8, indicating that multi-judge quality assessment and cross-model transferability evaluation help filter noisy or less reusable skill nodes. Finally, adding CSRL further improves the score to 44.9, demonstrating that reinforcement learning over skill-conditioned rollout groups provides additional policy improvement beyond skill-based SFT. Overall, the ablation confirms that both CSTS-based skill construction and CSRL-based policy optimization contribute to the final performance gain.

Table 3: Ablation study of OpenClaw-Skill on QwenClawBench.

<table><thead><tr><th rowspan="2">Setting</th><th colspan="2">CSTS</th><th rowspan="2">CSRL</th><th rowspan="2">Overall</th></tr><tr><th>CSN-Gen</th><th>CSN-Assess</th></tr></thead><tbody><tr><th>Qwen3.5-9B</th><td>–</td><td>–</td><td>–</td><td>34.5</td></tr><tr><th>+ CSN-Gen</th><td>✓</td><td>–</td><td>–</td><td>39.8</td></tr><tr><th>+ CSN-Gen + CSN-Assess</th><td>✓</td><td>✓</td><td>–</td><td>42.8</td></tr><tr><th>OpenClaw-Skill</th><td>✓</td><td>✓</td><td>✓</td><td>44.9</td></tr></tbody></table>

## 5 Conclusion

In this paper, we present OpenClaw-Skill, a framework with automatic skill construction and skill-augmented training to enhance LLM agents on complex tasks on real-world sytems like OpenClaw. At the core of our framework is Collective Skill Tree Search (CSTS), a novel tree-search-based skill construction framework that builds structured, diverse, and generalizable skills for LLM agents, improving their ability to solve sophisticated real-world tasks. CSTS operates through two iterative phases: Collective Skill Node Generation and Collective Skill Node Assessment. Together, these phases leverage collective intelligence to iteratively search, identify, and compose effective skills into cohesive and reliable trees of skills. Furthermore, we introduce Collective Skill Reinforcement Learning, which further optimizes the policy over skill-conditioned rollout groups and encourages the model to favor more effective procedural strategies. Extensive experiments on QwenClawBench and PinchBench, together with ablation studies and qualitative analyses, demonstrate that OpenClaw-Skill consistently achieves strong performance on diverse long-horizon tasks involving tool use, file operations, web interaction, and execution feedback.

[^1]: S. Agarwal et al. (2025) gpt-oss-120b & gpt-oss-20b model card. arXiv preprint arXiv:2508.10925. Cited by: Table 2, Table 2.

[^2]: S. Alzubi, N. Provenzano, J. Bingham, W. Chen, and T. Vu (2026) EvoSkill: automated skill discovery for multi-agent systems. arXiv preprint arXiv:2603.02766. External Links: [Link](https://arxiv.org/abs/2603.02766) Cited by: §1, §2.2.

[^3]: Anthropic (2025) Claude-4-sonnet. Cited by: §1.

[^4]: Anthropic (2025-10) Equipping agents for the real world with agent skills. Note: [https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills) Anthropic Engineering Blog Cited by: §1, §2.2.

[^5]: Anthropic (2025) Introducing Claude Haiku 4.5. Note: [https://www.anthropic.com/news/claude-haiku-4-5](https://www.anthropic.com/news/claude-haiku-4-5) Accessed: 2026-05-07 Cited by: Table 2.

[^6]: Anthropic (2026) Introducing claude opus 4.6. Note: [https://www.anthropic.com/news/claude-opus-4-6](https://www.anthropic.com/news/claude-opus-4-6) Accessed: 2026-05-07 Cited by: Table 1, Table 2.

[^7]: F. Bai, H. Song, S. Sun, D. Cheng, Y. Yang, C. Hao, R. Li, F. Chang, Y. Wei, R. Tao, B. Dai, J. Yang, and W. X. Zhao (2026) ClawGym: a scalable framework for building effective claw agents. arXiv preprint arXiv:2604.26904. External Links: [Link](https://arxiv.org/abs/2604.26904) Cited by: §2.1.

[^8]: A. Blakeman et al. (2025) NVIDIA Nemotron 3: efficient and open intelligence. arXiv preprint arXiv:2512.20856. Cited by: Table 2.

[^9]: ByteDance (2026) DeerFlow: deep exploration and efficient research flow. Note: Official repository, accessed 2026-05-07 External Links: [Link](https://github.com/bytedance/deer-flow) Cited by: §2.1.

[^10]: S. Chen, J. Gai, R. Zhou, J. Zhang, T. Zhu, J. Li, K. Wang, Z. Wang, Z. Chen, K. Kaleb, N. Miao, S. Gao, C. Lu, M. Li, J. He, and Y. W. Teh (2026) SkillCraft: can llm agents learn to use tools skillfully?. arXiv preprint arXiv:2603.00718. External Links: [Link](https://arxiv.org/abs/2603.00718) Cited by: §1, §2.2.

[^11]: S. Chen, Y. Liu, W. Han, W. Zhang, and T. Liu (2024) A survey on llm-based multi-agent system: recent advances and new frontiers in application. arXiv preprint arXiv:2412.17481. Cited by: §2.1.

[^12]: W. Chiang, Z. Li, Z. Lin, Y. Sheng, Z. Wu, H. Zhang, L. Zheng, S. Zhuang, Y. Zhuang, J. E. Gonzalez, et al. (2023) Vicuna: an open-source chatbot impressing gpt-4 with 90%\* chatgpt quality. See https://vicuna. lmsys. org (accessed 14 April 2023) 2 (3), pp. 6. Cited by: §1.

[^13]: G. Comanici, E. Bieber, M. Schaekermann, I. Pasupat, N. Sachdeva, I. Dhillon, M. Blistein, O. Ram, D. Zhang, E. Rosen, et al. (2025) Gemini 2.5: pushing the frontier with advanced reasoning, multimodality, long context, and next generation agentic capabilities. arXiv preprint arXiv:2507.06261. Cited by: §1.

[^14]: D. Dai et al. (2024) DeepSeekMoE: towards ultimate expert specialization in mixture-of-experts language models. arXiv preprint arXiv:2401.06066. Cited by: §2.1.

[^15]: DeepSeek-AI (2024) DeepSeek llm: scaling open-source language models with longtermism. arXiv preprint arXiv:2401.02954. Cited by: §2.1.

[^16]: DeepSeek-AI (2024) DeepSeek-v2: a strong, economical, and efficient mixture-of-experts language model. arXiv preprint arXiv:2405.04434. Cited by: §2.1.

[^17]: DeepSeek-AI (2024) DeepSeek-v3 technical report. arXiv preprint arXiv:2412.19437. Cited by: §2.1.

[^18]: DeepSeek-AI (2025) DeepSeek-r1: incentivizing reasoning capability in llms via reinforcement learning. arXiv preprint arXiv:2501.12948. Cited by: §2.1.

[^19]: DeepSeek-AI (2025) DeepSeek-V3.2 release. Note: [https://api-docs.deepseek.com/news/news251201](https://api-docs.deepseek.com/news/news251201) Accessed: 2026-05-07 Cited by: Table 1.

[^20]: Google (2026) Gemini 3.1 Pro: a smarter model for your most complex tasks. Note: [https://blog.google/innovation-and-ai/models-and-research/gemini-models/gemini-3-1-pro/](https://blog.google/innovation-and-ai/models-and-research/gemini-models/gemini-3-1-pro/) Accessed: 2026-05-07 Cited by: Table 2.

[^21]: Google (2026) Gemma 4: byte for byte, the most capable open models. Note: [https://blog.google/innovation-and-ai/technology/developers-tools/gemma-4/](https://blog.google/innovation-and-ai/technology/developers-tools/gemma-4/) Accessed: 2026-05-07 Cited by: Table 1, Table 1.

[^22]: H. He, W. Yao, K. Ma, W. Yu, Y. Dai, H. Zhang, Z. Lan, and D. Yu (2024) WebVoyager: building an end-to-end web agent with large multimodal models. In Proceedings of the 62nd Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers), Bangkok, Thailand, pp. 6864–6890. External Links: [Document](https://dx.doi.org/10.18653/v1/2024.acl-long.371), [Link](https://aclanthology.org/2024.acl-long.371/) Cited by: §2.1.

[^23]: G. Jiang, Z. Su, X. Qu, and Y. R. Fung (2026) XSkill: continual learning from experience and skills in multimodal agents. arXiv preprint arXiv:2603.12056. Cited by: §2.2.

[^24]: Y. Jiang et al. (2026) SoK: agentic skills – beyond tool use in llm agents. arXiv preprint arXiv:2602.20867. Cited by: §2.2.

[^25]: Kilo Code (2026) PinchBench: OpenClaw LLM Model Benchmarking. Note: [https://pinchbench.com/](https://pinchbench.com/) Accessed: 2026-05-07 Cited by: Table 2.

[^26]: J. Y. Koh, S. M. McAleer, D. Fried, and R. Salakhutdinov (2025) Tree search for language model agents. Transactions on Machine Learning Research. External Links: [Link](https://openreview.net/forum?id=QF0N3x2XVm) Cited by: §1, §2.3.

[^27]: X. Li, W. Chen, Y. Liu, S. Zheng, X. Chen, Y. He, Y. Li, B. You, H. Shen, J. Sun, S. Wang, B. Li, Q. Zeng, D. Wang, X. Zhao, Y. Wang, R. Ben Chaim, Z. Di, Y. Gao, J. He, Y. He, L. Jing, L. Kong, X. Lan, J. Li, S. Li, Y. Li, Y. Lin, X. Liu, X. Liu, H. Lyu, Z. Ma, B. Wang, R. Wang, T. Wang, W. Ye, Y. Zhang, H. Xing, Y. Xue, S. Dillmann, and H. Lee (2026) SkillsBench: benchmarking how well agent skills work across diverse tasks. arXiv preprint arXiv:2602.12670. External Links: [Link](https://arxiv.org/abs/2602.12670) Cited by: §1.

[^28]: Z. Lu, Z. Yao, J. Wu, C. Han, Q. Gu, X. Cai, W. Lu, J. Xiao, Y. Zhuang, and Y. Shen (2026) SKILL0: in-context agentic reinforcement learning for skill internalization. arXiv preprint arXiv:2604.02268. Cited by: §2.2.

[^29]: J. Luo, W. Zhang, Y. Yuan, Y. Zhao, J. Yang, Y. Gu, et al. (2025) Large language model agent: a survey on methodology, applications and challenges. arXiv preprint arXiv:2503.21460. Cited by: §2.1.

[^30]: Meta AI (2025) The Llama 4 herd: the beginning of a new era of natively multimodal ai innovation. Note: [https://ai.meta.com/blog/llama-4-multimodal-intelligence/](https://ai.meta.com/blog/llama-4-multimodal-intelligence/) Accessed: 2026-05-07 Cited by: Table 2.

[^31]: MiniMax (2026) MiniMax M2.7: early echoes of self-evolution. Note: [https://www.minimax.io/news/minimax-m27-en](https://www.minimax.io/news/minimax-m27-en) Accessed: 2026-05-07 Cited by: Table 1, Table 2.

[^32]: Moonshot AI (2026) Kimi K2.5: visual agentic intelligence. Note: [https://www.kimi.com/blog/kimi-k2-5](https://www.kimi.com/blog/kimi-k2-5) Accessed: 2026-05-07 Cited by: Table 1.

[^33]: J. Ni, Y. Liu, X. Liu, Y. Sun, M. Zhou, P. Cheng, D. Wang, E. Zhao, X. Jiang, and G. Jiang (2026) Trace2Skill: distill trajectory-local lessons into transferable agent skills. arXiv preprint arXiv:2603.25158. External Links: [Link](https://arxiv.org/abs/2603.25158) Cited by: §1, §2.2.

[^34]: Nous Research (2026) Hermes agent. Note: Official repository, accessed 2026-05-07 External Links: [Link](https://github.com/NousResearch/hermes-agent) Cited by: §2.1.

[^35]: OpenAI (2026) Introducing GPT-5.4. Note: [https://openai.com/index/introducing-gpt-5-4/](https://openai.com/index/introducing-gpt-5-4/) Accessed: 2026-05-07 Cited by: Table 1, Table 2.

[^36]: OpenAI (2026) OpenAI gpt-5 system card. arXiv preprint arXiv:2601.03267. External Links: [Link](https://arxiv.org/abs/2601.03267) Cited by: §1.

[^37]: OpenClaw (2026) OpenClaw. Note: Official documentation and repository, accessed 2026-05-07 External Links: [Link](https://docs.openclaw.ai/) Cited by: §1, §2.1.

[^38]: L. Ouyang, J. Wu, X. Jiang, et al. (2022) Training language models to follow instructions with human feedback. arXiv preprint arXiv:2203.02155. Cited by: §2.1.

[^39]: A. Plaat, M. van Duijn, N. van Stein, M. Preuss, P. van der Putten, and K. J. Batenburg (2025) Agentic large language models, a survey. arXiv preprint arXiv:2503.23037. Cited by: §2.1.

[^40]: Qwen Team and Alibaba Data (2026-04) QwenClawBench: real-user-distribution benchmark for openclaw agents. External Links: [Link](https://arxiv.org/html/2606.16774v1/github.com/SKYLENAGE-AI/QwenClawBench) Cited by: Table 1.

[^41]: Qwen Team (2026) Qwen3.5: towards native multimodal agents. Note: [https://qwen.ai/blog?id=qwen3.5](https://qwen.ai/blog?id=qwen3.5) Accessed: 2026-05-07 Cited by: Table 1, Table 1, Table 2, Table 2.

[^42]: Qwen Team (2026) Qwen3.6-35B-A3B. Note: [https://qwen.ai/blog?id=qwen3.6-35b-a3b](https://qwen.ai/blog?id=qwen3.6-35b-a3b) Accessed: 2026-05-07 Cited by: Table 1.

[^43]: Qwen Team (2026) Qwen3.6-Plus: towards real world agents. Note: [https://qwen.ai/blog?id=qwen3.6](https://qwen.ai/blog?id=qwen3.6) Accessed: 2026-05-07 Cited by: Table 1, Table 2.

[^44]: T. Schick, J. Dwivedi-Yu, R. Dessi, R. Raileanu, M. Lomeli, E. Hambro, L. Zettlemoyer, N. Cancedda, and T. Scialom (2023) Toolformer: language models can teach themselves to use tools. In Advances in Neural Information Processing Systems, Vol. 36, pp. 68539–68551. External Links: [Link](https://openreview.net/forum?id=Yacmpz84TH) Cited by: §1.

[^45]: D. Silver, J. Schrittwieser, K. Simonyan, I. Antonoglou, A. Huang, A. Guez, T. Hubert, L. Baker, M. Lai, A. Bolton, et al. (2017) Mastering the game of go without human knowledge. nature 550 (7676), pp. 354–359. Cited by: §2.3.

[^46]: Q. Team (2024) Qwen2.5 technical report. arXiv preprint arXiv:2412.15115. Cited by: §2.1.

[^47]: Q. Team (2025) Qwen3 technical report. arXiv preprint arXiv:2505.09388. Cited by: §2.1, Table 1, Table 1, Table 2, Table 2.

[^48]: G. Wang, Y. Xie, W. Jiang, et al. (2023) Voyager: an open-ended embodied agent with large language models. arXiv preprint arXiv:2305.16291. Cited by: §2.2.

[^49]: L. Wang, C. Ma, X. Feng, et al. (2023) A survey on large language model based autonomous agents. arXiv preprint arXiv:2308.11432. Cited by: §2.1.

[^50]: Y. Wang, X. Chen, X. Jin, M. Wang, and L. Yang (2026) OpenClaw-rl: train any agent simply by talking. arXiv preprint arXiv:2603.10165. External Links: [Link](https://arxiv.org/abs/2603.10165) Cited by: §2.1.

[^51]: P. Xia, J. Chen, H. Wang, J. Liu, K. Zeng, Y. Wang, S. Han, Y. Zhou, X. Zhao, H. Chen, et al. (2026) Skillrl: evolving agents via recursive skill-augmented reinforcement learning. arXiv preprint arXiv:2602.08234. Cited by: §1.

[^52]: P. Xia, J. Chen, H. Wang, J. Liu, K. Zeng, Y. Wang, S. Han, Y. Zhou, X. Zhao, H. Chen, Z. Zheng, C. Xie, and H. Yao (2026) SkillRL: evolving agents via recursive skill-augmented reinforcement learning. arXiv preprint arXiv:2602.08234. External Links: [Link](https://arxiv.org/abs/2602.08234) Cited by: §1, §1, §2.2.

[^53]: Xiaomi MiMo Team (2025) MiMo-V2-Flash. Note: [https://github.com/XiaomiMiMo/MiMo-V2-Flash](https://github.com/XiaomiMiMo/MiMo-V2-Flash) Accessed: 2026-05-07 Cited by: Table 2.

[^54]: Xiaomi MiMo Team (2026) MiMo-V2-Pro. Note: [https://mimo.xiaomi.com/mimo-v2-pro](https://mimo.xiaomi.com/mimo-v2-pro) Accessed: 2026-05-07 Cited by: Table 1, Table 2.

[^55]: T. Xie, D. Zhang, J. Chen, X. Li, S. Zhao, R. Cao, T. J. Hua, Z. Cheng, D. Shin, F. Lei, Y. Liu, Y. Xu, S. Zhou, S. Savarese, C. Xiong, V. Zhong, and T. Yu (2024) OSWorld: benchmarking multimodal agents for open-ended tasks in real computer environments. In Advances in Neural Information Processing Systems, Vol. 37, pp. 52040–52094. Note: Datasets and Benchmarks Track External Links: [Document](https://dx.doi.org/10.52202/079017-1650), [Link](https://proceedings.neurips.cc/paper_files/paper/2024/hash/5d413e48f84dc61244b6be550f1cd8f5-Abstract-Datasets_and_Benchmarks_Track.html) Cited by: §2.1.

[^56]: R. Xu and Y. Yan (2026) Agent skills for large language models: architecture, acquisition, security, and the path forward. arXiv preprint arXiv:2602.12430. Cited by: §2.2.

[^57]: A. Yang et al. (2024) Qwen2 technical report. arXiv preprint arXiv:2407.10671. Cited by: §2.1.

[^58]: Y. Yang, J. Li, Q. Pan, et al. (2026) AutoSkill: experience-driven lifelong learning via skill self-evolution. arXiv preprint arXiv:2603.01145. Cited by: §2.2.

[^59]: H. Yao, J. Huang, W. Wu, J. Zhang, Y. Wang, S. Liu, Y. Wang, Y. Song, H. Feng, L. Shen, and D. Tao (2024) Mulberry: empowering MLLM with o1-like reasoning and reflection via collective monte carlo tree search. CoRR abs/2412.18319. External Links: [Link](https://doi.org/10.48550/arXiv.2412.18319), [Document](https://dx.doi.org/10.48550/ARXIV.2412.18319), 2412.18319 Cited by: §2.3.

[^60]: S. Yao, D. Yu, J. Zhao, I. Shafran, T. Griffiths, Y. Cao, and K. Narasimhan (2023) Tree of thoughts: deliberate problem solving with large language models. In Advances in Neural Information Processing Systems 36: Annual Conference on Neural Information Processing Systems 2023, NeurIPS 2023, New Orleans, LA, USA, December 10–16, 2023, A. Oh, T. Naumann, A. Globerson, K. Saenko, M. Hardt, and S. Levine (Eds.), Vol. 36. External Links: [Link](https://papers.nips.cc/paper_files/paper/2023/hash/271db9922b8d1f4dd7aaef84ed5ac703-Abstract-Conference.html) Cited by: §2.3.

[^61]: S. Yao, J. Zhao, D. Yu, N. Du, I. Shafran, K. R. Narasimhan, and Y. Cao (2023) ReAct: synergizing reasoning and acting in language models. In The Eleventh International Conference on Learning Representations, External Links: [Link](https://openreview.net/forum?id=WE_vluYUL-X) Cited by: §1, §2.1.

[^62]: W. Ye, S. Liu, T. Kurutach, P. Abbeel, and Y. Gao (2021) Mastering atari games with limited data. Advances in neural information processing systems 34, pp. 25476–25488. Cited by: §2.3.

[^63]: Z.AI (2026) GLM-5.1: towards long-horizon tasks. Note: [https://z.ai/blog/glm-5.1](https://z.ai/blog/glm-5.1) Accessed: 2026-05-07 Cited by: Table 1.

[^64]: G. Zhang, H. Geng, X. Yu, et al. (2025) The landscape of agentic reinforcement learning for llms: a survey. arXiv preprint arXiv:2509.02547. Cited by: §2.1.

[^65]: H. Zhang, S. Fan, H. P. Zou, Y. Chen, Z. Wang, J. Zhou, C. Li, W. Huang, Y. Yao, K. Zheng, X. Liu, X. Li, and P. S. Yu (2026) CoEvoSkills: self-evolving agent skills via co-evolutionary verification. arXiv preprint arXiv:2604.01687. External Links: [Link](https://arxiv.org/abs/2604.01687) Cited by: §1, §2.2.

[^66]: Z. Zhang, K. Shi, S. Huang, et al. (2026) SkillFlow: benchmarking lifelong skill discovery and evolution for autonomous agents. arXiv preprint arXiv:2604.17308. Cited by: §2.2.

[^67]: A. Zhou, K. Yan, M. Shlapentokh-Rothman, H. Wang, and Y. Wang (2024-21–27 Jul) Language agent tree search unifies reasoning, acting, and planning in language models. In Proceedings of the 41st International Conference on Machine Learning, R. Salakhutdinov, Z. Kolter, K. Heller, A. Weller, N. Oliver, J. Scarlett, and F. Berkenkamp (Eds.), Proceedings of Machine Learning Research, Vol. 235, pp. 62138–62160. External Links: [Link](https://proceedings.mlr.press/v235/zhou24r.html) Cited by: §2.3.