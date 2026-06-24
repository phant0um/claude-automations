---
title: "WebCQ: Cooperative Multi-Agent Deep Reinforcement Learning for Scalable Web GUI Testing"
type: source
source: "Clippings/WebCQ Cooperative Multi-Agent Deep Reinforcement Learning for Scalable Web GUI Testing.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "WebCQ: Cooperative Multi-Agent Deep Reinforcement Learning for Scalable Web GUI Testing"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Yujia Fan, Sinan Wang, Zebang Fei, Yao Qin, Huaxuan Li, Yepang Liu Research Institute of Trustworthy Autonomous Systems, Southern University of Science and TechnologyDepartment of Computer Science and Engineering, Southern University of Science and TechnologyShenzhenChina [12431253,wangsn,12110608,12112016,121

## Argumentos principais
### 1\. Introduction
GUI-based software systems have grown increasingly complex, particularly in large-scale web applications, making automated and scalable testing techniques more important [^17] [^2] [^22]. Among the techniques, end-to-end GUI testing explores applications by generating UI event sequences to simulate open-ended user interactions, aiming to achieve high functional coverage and expose bugs.
Recent studies have demonstrated the potential of reinforcement learning (RL) in GUI testing [^51] [^13] [^24] [^25] [^20] [^31]. For examples, WebExplor [^51] and QExplore [^37] employ the tabular RL algorithm Q-learning [^44] for web exploration. Despite their differences in algorithmic configurations, they both significantly outperform testing approaches based on traditional techniques (e.g., model-based [^6] or search-based [^5] ones). Nonetheless, tabular RL algorithms can easily suffer from the state explosion problem, where the state-action policies (i.e., Q-tables) can quickly grow unbounded as the number of states increases, limiting their practical usages in testing complex web applications. To mitigate this problem, researchers have explored the alternative use of deep reinforcement learning (DRL). DRL agents leverage deep neural networks (DNNs) to capture high-dimensional or continuous state representations, thereby avoiding unbounded Q-table growth. For example, Romdhana et al. [^35] proposed an Android GUI testing framework and evaluated multiple exploration strategies, including policy-based DRL algorithms such as DDPG, TD3, and SAC, as well as baselines like Q-learning and random exploration. They show that SAC achieves the best performance. DQT [^21], a DQN-based Android testing approach, employs graph embedding techniques to effectively identify similarities among app states and actions. This accelerates the discovery of high-value actions, improves instruction coverage, and uncovers more unique failures.
The above approaches employ single-agent paradigms, whose performance is inherently bounded by the limitations of isolated learning. More recently, researchers have explored the use of multi-agent reinforcement learning (MARL) to explore complex GUI environments via parallelized execution and experience sharing. For example, Fastbot [^7] runs multiple Q-learning agents to collectively build a navigation model for Android apps. Fan et al. [^12] show that running multiple RL agents independently leads to significant redundancy in their explored states. And they propose MARG, a framework that incorporates two novel communication schemes to enable effective experience sharing among concurrent RL-based testing agents. Compared to independently running RL agents, MARG can explore significantly more web states and detect more unique failures. However, these multi-agent approaches mostly rely on tabular RL algorithms, leading to severe communication overhead between parallelized agents. In addition, their locator-centric action definitions cannot adequately capture action semantics, i.e., the intended functionality behind an action (e.g., submitting a form). Adequately capturing such semantics is important because it not only preserves the meaning of critical user tasks but also enables more effective validity analysis of dynamic interactions (e.g., clicking elements with unstable XPaths).

### 2.1. Reinforcement Learning
Reinforcement learning (RL) studies how an autonomous agent can learn to make sequential decisions by interacting with an environment to maximize cumulative rewards. A key branch of RL is tabular RL algorithm (e.g., Q-learning [^44]), which estimates a Q-value function $Q(s,a)$ to approximate the expected future reward for taking a specific action $a$ in a given state $s$. However, tabular methods struggle to handle high-dimensional and continuous state spaces. Therefore, the Deep Q-Network (DQN) [^27] leverages a DNN to overcome such a limitation. It approximates the Q-value function $Q(s,a;\theta)$, with $\theta$ denoting the network weights. DQN addresses DNN instability in RL through two pivotal mechanisms:
1. Experience replay: During exploration, state transitions with reward $(s,a,s^{\prime},r)$ will be stored in a replay buffer, from which mini-batches will be sampled for training.
2. Target network: A separate network with weights $\theta^{-}$ periodically copies the main network’s weights $\theta$. It decouples the target value from the current prediction to stabilize training.

### 2.2. Cooperative MARL and QTRAN
Figure 1. QTRAN’s architecture 38
Figure 2. An overview of WebCQ
In cooperative MARL tasks with CTDE paradigm [^45] [^47], agents will select actions based on partial observations but learn strategies through a global policy. This requires each agent to maintain their own Q-function $Q_{i}(s_{i},a_{i})$ while contributing jointly to the optimization of a global Q-function $Q_{\textrm{jt}}(\boldsymbol{s},\boldsymbol{a})$, where $\boldsymbol{s}$ denotes the joint state and $\boldsymbol{a}$ denotes the joint action. However, the challenge lies in how to effectively decompose the global Q-value into individual agent contributions during training. QTRAN (Figure 1) introduces a state-value function $V_{\textrm{jt}}(\boldsymbol{s})$ to account for the discrepancy between the joint Q-function $Q_{\textrm{jt}}$ and the sum of individual agent’s one:

### 3\. Problem Formulation
Given a WUT (website under test), we adopt a multi-agent testing setting where multiple agents interact with their own browser instances to explore the website in parallel. Each agent makes decisions based on its current webpage, while a global objective is to achieve comprehensive exploration and trigger potential failures.
This process can be formulated as a decentralized partially observable Markov decision process (Dec-POMDP) [^30] [^18], defined as $\langle N,\boldsymbol{S},\{A_{i}\}_{i\in\{1,...,N\}},P,\{R_{i}\}_{i\in\{1,...,N\}},\gamma,\{O_{i}\}_{i\in\{1,...,N\}}\rangle$, where $N$ is the number of agents, $\mathcal{S}$ denotes the global state space, $A_{i}$ and $O_{i}$ represent the action space and observation space of agent $i$, respectively, $P$ is the state transition function, $R_{i}$ is the local reward function, and $\gamma$ is the discount factor. In Dec-POMDP, each agent cannot observe the global state and each agent has the same reward function [^47]. At each timestep, agent $i$ has a local state $s_{i}\in O_{i}$, denoting its observation for notational consistency with QTRAN.
Definition 1 (Local State): For agent $i$, a local state $s_{i}$ represents the current webpage observed through its browser instance. A webpage is represented by its HTML document, which encodes both content and structural information. Existing work such as WebExplor converts HTML pages into tag sequences and measures similarity to identify equivalent states [^51]. However, such methods can incur substantial computational overhead for complex webpages [^23] [^13]. To address this limitation, we will propose a more efficient abstract representation for local states (see Section 4.2.1).

### 4.1. Overview
CTDE is widely adopted to address the coordination and partial observability in Dec-POMDPs [^14] [^16]. In cooperative tasks, CTDE enables coordinated learning by allowing a centralized learner to access joint states, actions, and rewards during training, while each agent executes with its own policy based on local states. Given these advantages, QTRAN, an MARL method under the CTDE paradigm, becomes appropriate for the multi-agent web testing task, where effective coordination among agents is crucial.
We propose WebCQ, a cooperative multi-agent web testing approach that follows the CTDE paradigm. As illustrated in Figure 2, the framework decomposes the testing process into two components: (1) DQN-based Decentralized Execution and (2) QTRAN-based Centralized Training. Given a WUT, each agent launches an independent browser instance to access the webpage. The agent constructs the state and action vectors, selects an action using its Q-network, and executes it to trigger a transition stored in the local buffer. The transitions are iteratively collected and sent to the central module for centralized training. To determine when centralized training will be performed, we propose a lightweight synchronization mechanism to coordinate the asynchronous agents. Using the collected data of all agents, the transitions and the computed global reward are stored in the global buffer. Mini-batches are then sampled from the global buffer to update the Q-networks through QTRAN, optimizing both the joint and individual Q-functions. In the following sections, we describe the two components in detail.

### 4.2. DQN-based Decentralized Execution
Figure 3. An example of tag-depth-based state vector
#### 4.2.1. State Vector
Existing work such as WebExplor represents a state as a sequence of HTML tags and relies on sequence similarity for state matching, which incurs substantial computational overhead. One-hot encodings of activities used in Android GUI testing [^35] are unsuitable for web testing, where identifiers like URLs are often dynamic. WebCQ employs a state representation that encodes DOM structural information by capturing tags and their depths. As illustrated in Figure 3, given a predefined list of common HTML tags, we compute the average DOM depth [^42] of elements for each tag (zero for absent tags) to construct the state vector, with an extra dimension for tags outside the list. This method produces fixed-dimensional vectors, enabling efficient state matching and compatibility with neural network models.

### 4.3. QTRAN-based Centralized Training
#### 4.3.1. Adaptation
In the centralized training phase, we employ QTRAN to optimize each agent’s policy. QTRAN was designed for synchronous tasks in shared environments [^41] [^10], where agents observe different parts of a common global state. However, in multi-agent web testing, each agent operates an independent browser with its own webpage context. Therefore, agents’ observations are not drawn from a shared spatial-temporal environment, and action execution across agents is inherently asynchronous. To fill this gap, we introduce two strategies to adapt QTRAN from a synchronous algorithm into the asynchronous scenario:
① Joint state representation. In our task, each agent can only observe its own local state, and no explicit global state exists. Meanwhile, agents’ local states may overlap because they observe pages from the same WUT, either at the same time or at different times. To represent the joint state of all agents, we construct $\boldsymbol{s}$ by concatenating the local state vectors $s_{i}$ of each agent: $\boldsymbol{s}=(s_{1};s_{2};\dots;s_{N})$. This joint state preserves the unique perspectives of individual agents and provides the joint Q-function with a comprehensive view of the WUT for learning coordinated policies.

### 5\. Experimental Setup
Table 1. Settings of the compared approaches and WebCQ
| Group | Approach | Description | $\gamma$ | $\alpha$ | $\varepsilon$ |
| --- | --- | --- | --- | --- | --- |

### 5.1. Research Questions
To evaluate the performance of WebCQ, we conducted a series of experiments to investigate the following research questions:
- RQ1 (Tool Performance): How does WebCQ perform when testing real-world web applications, and how does it compare to state-of-the-art methods?
- RQ2 (Ablation Study): What is the impact of multi-agent communication and the use of an advanced MARL algorithm (i.e., QTRAN) on WebCQ’s performance?

### 5.2. Compared Approaches
#### 5.2.1. State-of-the-Art Methods
To answer RQ1, we evaluated WebCQ against two representative state-of-the-art web testing tools. Table 1 summarizes their key features and major parameters.
WebExplor is a representative single-agent, Q-learning-based web testing approach, with a DFA dynamically built for error recovery [^51]. We selected WebExplor as a baseline since it achieves the state-of-the-art performance among single-agent web testing approaches [^51]. To fairly compare with WebCQ in a multi-agent scenario, we simultaneously run $N$ independent WebExplor processes and merge their testing results, denoted as $\textit{WebExplor}^{N}$.

### 5.3. Configurations
For WebExplor and MARG’s hyper-parameters, we retained the values of discount factor $\gamma$, learning rate $\alpha$ and exploration rate $\varepsilon$ from their original papers. For WebCQ and its ablation variants, we set $\gamma=0.5$ as well. However, considering the different magnitudes of value updates in DRL networks compared to Q-table, we adjusted the learning rate $\alpha$ to 0.001 [^36]. To better adapt to the dynamics of DNN training, we adopted a linearly decaying exploration strategy [^48], such that $\varepsilon$ decreases linearly over time:
$$
\varepsilon(t)=\varepsilon_{\text{max}}-\min\left(\frac{2t}{T_{\text{total}}},1\right)\times(\varepsilon_{\text{max}}-\varepsilon_{\text{min}})

### 5.4. Subject Websites
Table 2. Subject websites (WUTs)
| Name | Category | URL |
| --- | --- | --- |

### 5.5. Implementation and Environment
Similar to MARG’s practice, WebCQ also adopts a client-server architecture. On the agent side, web testing automation is supported by Selenium-Python, while the centralized controller schedules agents using Python’s built-in threading module. All policy networks are implemented in PyTorch (version 2.3.1) with default weight initialization. Specifically, each network is a DenseNet [^19] of four fully connected layers, where every layer receives the concatenated outputs of all preceding layers. For experiments with the state-of-the-art methods WebExplor and MARG, we obtained the executable programs by contacting their authors and adapted them to our experimental environment.
We ran all our experiments on a server running Ubuntu 22.04 and Chrome 117. The server has 32 CPU cores (64 threads), 128GB RAM, and two NVIDIA Quadro RTX 6000 GPUs, and is connected to the Internet with a Gigabit Ethernet.

### 6.1. RQ1: Tool Performance
#### 6.1.1. Method
We compared WebCQ against two state-of-the-art methods, WebExplor and MARG, all configured with five agents. We ran each method on each WUT for three hours and repeated six times to mitigate the threat of randomness. The total experimental time is comparable to that of existing studies [^51] [^21] [^12] [^3].
Following previous work in automatic web GUI testing [^26] [^12] [^43], we use the number of explored states, executed unique actions, and detected failures to measure the performance of web exploration approaches. Notably, we used the definition of “URL with element set” to represent the metric “explored states”, which is consistent to that in MARG’s experimental setting. The “detected failures” were collected by filtering relevant messages from the web browser’s console log (such as JavaScript errors, network failures, and rendering warnings) and then deduplicated for fair comparisons.

### 6.2. RQ2: Ablation Study
#### 6.2.1. Method
We followed the same experimental settings and metrics as in RQ1 (Section 6.1.1). We compared WebCQ with two ablation variants (Section 5.2.2) to assess the performance gains from our key design innovations.
#### 6.2.2. Result


## Key insights
- To the best of our knowledge, we are the first to formulate the multi-agent web GUI testing task as a Dec-POMDP problem and to introduce QTRAN for effective agent cooperation.
- We have proposed a novel MARL-based web GUI testing approach, WebCQ, and experimentally demonstrated that it achieves state-of-the-art performance in terms of exploration efficiency, failure-triggering effectiveness, and scalability.
- To facilitate future research and industry practice, we have published the source code of WebCQ and all experimental data in: [).
- Page similarity $R_{\text{sim}}$: To encourage exploration of diverse pages, we identify the most similar previously visited page $p^{*}$ of the current page $p$ using the APIMiner metric [^8]. The $R_{\text{sim}}$ is then evaluated piecewise:
- Execution frequency $R_{\text{exec}}$: Since similar pages often share identical UI events, repeated executions usually yield redundant exploration. To mitigate this, $R_{\text{exec}}$ assigns a bonus to new actions and provides a diminishing reward for repeated executions:
- Temporal compensation $R_{\text{time}}$: During long-term exploration, rewards can become sparse: many states were already explored, leading to diminishing rewards. Following DQT [^21], we use a time-based reward term $R_{\text{time}}$ that increases with execution time:
- RQ1 (Tool Performance): How does WebCQ perform when testing real-world web applications, and how does it compare to state-of-the-art methods?
- RQ2 (Ablation Study): What is the impact of multi-agent communication and the use of an advanced MARL algorithm (i.e., QTRAN) on WebCQ’s performance?
- RQ3 (Coordination Overhead): Can WebCQ reduce the coordination overhead over parallel agents during the testing period compared to the tabular-RL approach MARG?
- RQ4 (Effect of Agent Numbers): How does the number of agents affect the overall performance of WebCQ when testing large-scale websites?

## Exemplos e evidências
See original source at `Clippings/WebCQ Cooperative Multi-Agent Deep Reinforcement Learning for Scalable Web GUI Testing.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/reinforcement-learning]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
