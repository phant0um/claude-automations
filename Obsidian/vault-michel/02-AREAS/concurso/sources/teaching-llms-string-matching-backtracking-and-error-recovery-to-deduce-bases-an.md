---
title: "Teaching LLMs String Matching, Backtracking, and Error Recovery to Deduce Bases and Truth Tables for the Combinatorially Exploding Bit Manipulation Puzzles"
type: source
source: "Clippings/Teaching LLMs String Matching, Backtracking, and Error Recovery to Deduce Bases and Truth Tables for the Combinatorially Exploding Bit Manipulation Puzzles.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
This paper presents the key ideas and algorithmic innovations developed during our participation in the NVIDIA Nemotron Model Reasoning Challenge, focusing specifically on the Bit Manipulation Puzzles, which was widely considered one of the most challenging tasks to fully solve. In this task, the objective is to discover a hidden logical rule that transforms a given set of input binary strings into outputs, and then accurately apply that rule to a new, unseen input. Large Language Models (LLMs) 

## Argumentos principais
### 1 Introduction
Modern Artificial Intelligence excels at generating fluent text and heuristic reasoning, but exact, deterministic algorithmic logic remains one of its most difficult frontiers. A rigorous benchmark for this capability is the “Bit Manipulation” puzzle, featured as a core category in the NVIDIA Nemotron Model Reasoning Challenge. In these puzzles, an AI system must reverse-engineer a hidden mathematical formula simply by observing a few examples of how one 8-bit binary string transforms into another. To solve the puzzle, the model must deduce the exact sequence of operations applied to the inputs and accurately predict the output for a novel, unseen binary string.
Traditional methodologies approach this sequence-to-sequence translation by prompting the Large Language Model (LLM) to reverse-engineer an abstract syntax tree of boolean logic gates (e.g., AND, OR, XOR) and spatial operators (e.g., left shifts, right shifts, circular rotations). However, this approach collides directly with the mathematical reality of the problem: the search space of possible operations is astronomically large.
To illustrate this intractability, consider the full feature space of 22 possible base transformations (the original bit x, plus 7 left shifts, 7 right shifts, and 7 circular rotations). If a hidden rule relies on exactly three of these bases, there are $\binom{22}{3}=1,540$ unique base combinations. However, to form an executable mathematical rule, these three bases must be ordered into a syntax tree and connected using the allowed operations (XOR, AND, OR, NOT, as well as majority or choice functions). For any three selected bases, there are $3!=6$ ways to order them. If we connect them using two sequential binary gates (including their negated variants, yielding 6 options per gate), we generate $3!\times 6\times 6=216$ distinct structural equations per subset. Thus, even for a rudimentary three-variable rule, an LLM attempting to brute-force the formula would have to evaluate a search space exceeding $330,000$ unique combinations ($1,540\times 216$).

### 2 Preliminaries and Core Concepts
To understand why our approach abandons traditional logic-gate simulation, it is first necessary to establish the conceptual framework we use to analyze bit manipulation. Instead of viewing the problem through the lens of complex logic gates and bitwise arithmetic, we transformed the sequence-to-sequence translation into a discrete base-selection and string-matching problem. This requires understanding three foundational concepts: Bases, Empirical Truth Tables, and Isolating Output-Influencing Bases via Minimal Bitflips.

### 2.1 Bases
Figure 1: Spatial mapping of input bits to form the bases for target output Bit 6 (red) across the three base classes: Right Shifts (1), Circular Shifts (2), and Left Shifts (3). The curved arrows trace how each individual offset (e.g., $R_{1}$, $C_{2}$, or $L_{3}$) retrieves its value from a specific position in the input string or from padded zeros (dashed).
Our approach begins by deconstructing the sequence-to-sequence translation paradigm. Instead of mapping an entire 8-bit input directly to an 8-bit output, we break down a single 8-bit example into eight independent 1-bit transformations.
Predicting a single output bit $y$ at position $i$ based solely on the input bit at the exact same position $i$ is insufficient if the logical rule involves bits moving across the sequence (via shifts or rotations). To natively bypass this, we define a set of 22 spatial pointers, which we call Bases. These bases allow us to directly query the status of any input bit that could potentially influence our target output bit:

### 2.2 Empirical Truth Tables
Because our generated bases contain only binary values (0 and 1), any underlying logical rule—no matter how complex the combination of AND, OR, or XOR gates—can be perfectly represented by a simple Truth Table. This mathematical property completely eliminates the need to deduce an explicit algebraic equation.
Once we identify the specific subset of bases that dictate the output, we do not need to figure out how they are mathematically connected. We simply observe the existing dataset and record the target output for each state. This insight dramatically simplifies the problem: the task is reduced entirely to discovering which subset of bases to look at, replacing algebraic derivation with straightforward data observation.

### 2.3 Isolating Output-Influencing Bases via Minimal Bitflips
Figure 2: Isolating output-influencing bases by comparing rows with different target outputs. When two nearly identical 22-base arrays yield different outputs (0 vs. 1), the differing bases must be responsible for the state change.
In our expanded 22-dimensional Boolean base space, asking an Auto-Regressive LLM to natively deduce the correct logical mapping is highly prone to hallucination. We bypass this spatial arithmetic calculation entirely by leveraging a foundational principle of logic and string similarity: If two nearly identical base configurations yield different outputs, the cause of the output change must lie strictly within the bases that differ.
By splitting the 64 target output bits into two classes—outputs resulting in 0 and 1—we systematically compare their 22-base arrays. We map every 0-output row to a 1-output row with the smallest Hamming distance to isolate the “Minimal BitFlips.” These differing bits act as strict logical constraints, which we refer to as Flip Traces.

### 3 Solver Algorithm
We now translate our theoretical framework into an algorithm that completely solves the puzzle from start to finish. The overarching goal of this pipeline is to unify string matching and structured search to autonomously deduce the hidden logic rule.
As visualized in Figure 3, the solver operates in three distinct phases: first, it uses string similarity to find the logical constraints; second, it employs a “guess-and-check” backtracking search to find a perfectly valid subset of bases; and finally, it synthesizes the empirical truth table to predict the target string.
Figure 3: End-to-End Flowchart of the Bit Manipulation Solver. The algorithm isolates logical constraints via string matching, iteratively searches for valid bases via backtracking, and ultimately synthesizes the final truth table to solve the puzzle.

### 3.1 Phase 1: Feature Extraction and String Matching
The algorithm begins by generating the 22 bases for all 64 independent bits in the puzzle examples. To figure out which bases actually influence the output, we leverage simple string similarity.
By comparing the rows that output 0 with the rows that output 1, the algorithm identifies the minimal structural differences required to trigger a state change. These differing bases are extracted as Flip Traces (our “clues”). These traces serve as the absolute logical constraints of the puzzle: any valid Boolean rule must select at least one base from every trace to mathematically explain why the outputs changed. This naturally frames the next step as a classic Set Cover problem, as demonstrated in Box 2.

### 3.2 Phase 2: Backtracking Search and Collision Verification
With our list of constraints defined, the algorithm must find the absolute smallest combination of bases that “covers” every trace. We execute a structured search process.
The search utilizes frequency-guided depth first search. When the algorithm encounters traces with multiple possibilities, it ranks the bases by how often they appear globally. It greedily “guesses” the most frequent bases first, naturally favoring the simplest logical rules.
However, simply finding a set of bases that covers our traces is not enough; we must verify against all the 64 rows. To prove the rule is universally sound, the algorithm performs a Global Collision Verification. It evaluates the currently guessed bases across all 64 rows of the global dataset.

### 3.3 Phase 3: Truth Table Synthesis and Target Prediction
Once the backtracking algorithm successfully discovers a subset of bases that covers all traces and passes the 64-row collision check without any contradictions, the search concludes. The hypothetical mapping generated during the verification step is now mathematically proven to be the universally correct Truth Table.
To complete the puzzle, the algorithm processes the unseen target input string. It generates the 22 spatial bases for the target and isolates the specific optimal bases discovered by our search. By querying our proven Truth Table sequentially from Bit 0 up to Bit 7, it constructs the final 8-bit output prediction, flawlessly completing the puzzle.

### 4 Interactive Reasoning SFT and Tokenization
While Section 3 describes a deterministic and mathematically rigorous solver, standard LLMs cannot natively execute Python algorithms. The final challenge is embedding this search-and-verify logic into the model’s parametric memory. We achieve this through two machine learning innovations: Strict Bit Tokenization and Interactive Reasoning via Dynamic Masking.

### 4.1 Overcoming Spatial Bias via Strict CoT Token Generation
In sequence-to-sequence bit manipulation, the model’s attention mechanism relies heavily on the strict spatial alignment of bits. However, standard Byte-Pair Encoding (BPE) tokenizers are optimized for natural language and frequently merge adjacent numbers. For example, an 8-bit string like 10100011 might be arbitrarily chunked into tokens like \[1010\], \[00\], and \[11\]. This arbitrary chunking destroys the 2D spatial grid required to compare 64 dataset rows horizontally.
Normally, this is resolved by modifying the tokenizer rules. However, the competition constraints restricted submissions strictly to Low-Rank Adaptation (LoRA) weights, meaning the base tokenizer could not be modified. The input prompt would inevitably suffer from arbitrary BPE chunking.
To bypass this architectural constraint, we engineered a workaround entirely within the training data. While we could not control how the model read the input prompt, we could control how it generated its reasoning. During the Supervised Fine-Tuning (SFT) data packing phase, we implemented a custom script that bypassed standard tokenization for the Chain-of-Thought (CoT) and final answer. By using regular expressions to isolate binary sequences, we manually mapped every 0 and 1 to their individual, single-character token IDs.

### 4.2 Interactive Reasoning SFT via Dynamic Masking
Developing robust error recovery—the ability to recognize a logical failure and backtrack to an alternative hypothesis—is a critical component of reasoning. Typically, teaching models this behavior requires computationally expensive Reinforcement Learning (RL) frameworks. Operating under strict compute constraints (utilizing only contest-provided hardware), we engineered a highly efficient alternative to instill this capability purely within standard offline Supervised Fine-Tuning (SFT).
</span><span id="S4.SS2.p2.pic1.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.p2"></span><span id="S4.SS2.p2.pic1.3.3.3.3.3.3.3.3.3.3.3.3.3.3.3.3.3.p3"></span></span></foreignObject></g></g></svg>
Instead of forcing the LLM to internally compute and memorize the massive 64-row global dataset to check its own work (which is computationally wasteful and prone to hallucination), we simulated an interactive environment. During training data generation, whenever the LLM proposes a candidate subset of bases, an automated external “Oracle” evaluates the guess against the true, hidden 64-row dataset. The Oracle then explicitly injects a prompt back into the context window, informing the LLM whether the guess was flawless or if a collision occurred (Box 4).

### 5 Experimental Results and Evaluation
To validate the efficacy of our base-selection formulation and Interactive Reasoning SFT, we evaluated both the theoretical upper bound of our deterministic solver and the final inferential performance of the fine-tuned LLM.
It is important to note the extreme logistical constraints under which these results were achieved. Entering the competition in the final two weeks, all training and inference were conducted strictly within the 30-hour per-participant GPU compute budget provided by the Kaggle platform. We trained for a total of approximately 1,200 steps while manually checkpointing and resuming to navigate the platform’s 12-hour session limits.

### 5.1 Algorithmic Upper Bound and Deterministic Limits
Prior to training the LLM, we evaluated our Python-based deterministic solver across a rigorous validation set of $1,602$ bit manipulation puzzles to establish the theoretical upper limit of our formulation. The algorithm achieved a global accuracy of 98.63% ($1,580/1,602$).
An algorithmic autopsy of the 22 unsolved puzzles revealed that these failures were not due to any structural limitation in our 22-base formulation (as $K>3$ failures accounted for 0% of errors). Instead, these puzzles represent objectively under-determined systems where the ground-truth rule cannot be mathematically deduced from the provided examples:
- Out-Of-Distribution (OOD) Target States (27.3%): In 6 puzzles, the target input required evaluating a Boolean state that was completely absent from the 8 provided examples. Because the required transition logic was never demonstrated, solving the puzzle is mathematically impossible without blind guessing.

### 5.2 LLM Performance and Ablation Study
To evaluate the model’s ability to internalize this algorithm, we conducted an ablation study comparing two sequential training regimes. Our first model was fine-tuned exclusively on our synthetic DFS traces (Synthetic Only). For our second model, we took the last checkpoint of this synthetic-only training and continued fine-tuning it exclusively on the competition’s original dataset (Synthetic + Original).
As detailed in Table 1, the Synthetic Only model achieved an outstanding 96.13% global accuracy, successfully retaining nearly the entire capability of our deterministic solver.
<table><thead><tr><th></th><th></th><th colspan="2">Synthetic Only</th><th colspan="2">Synthetic + Original</th></tr><tr><th>Complexity</th><th>Count</th><th>Accuracy</th><th>Avg Tok.</th><th>Accuracy</th><th>Avg Tok.</th></tr></thead><tbody><tr><th><math><semantics><mrow><mi>K</mi> <mo>=</mo> <mn>1</mn></mrow> <annotation>K=1</annotation></semantics></math> Base</th><th>154</th><td>94.16%</td><td>4868</td><td>94.16%</td><td>4864</td></tr><tr><th><math><semantics><mrow><mi>K</mi> <mo>=</mo> <mn>2</mn></mrow> <annotation>K=2</annotation></semantics></math> Bases</th><th>898</th><td>97.88%</td><td>4879</td><td>98.44%</td><td>4901</td></tr><tr><th><math><semantics><mrow><mi>K</mi> <mo>=</mo> <mn>3</mn></mrow> <annotation>K=3</annotation></semantics></math> Bases</th><th>550</th><td>93.82%</td><td>5347</td><td>88.55%</td><td>5567</td></tr><tr><th>Overall</th><th>1602</th><td>96.13%</td><td>5039</td><td>94.63%</td><td>5126</td></tr></tbody></table>


## Key insights
- Bases and Truth Table Formulation: We reframe logic-gate deduction into a base-selection task, leveraging string similarity (minimal bit flips) between outputs to isolate primitive transformations (“bases”) and deduce their truth tables without complex arithmetic.
- Backtracking DFS and Error Recovery: We formalize a search process that tests candidate bases, detects logical collisions across examples in a puzzle, and backtracks upon failure to perform robust error recovery.
- Bit Tokenization and Interactive Reasoning SFT: We force the tokenizer to encode binary strings as individual, single-bit tokens, and use dynamic masking to simulate external oracle feedback—training the model to hypothesize, self-evaluate, and backtrack natively.
- x (Original): Looks directly at the input bit at the target position $i$.
- R1-R7 (Right Shifts): Act as left-pointing spatial pointers. For instance, if the puzzle requires a Right Shift of $k$ ($R_{k}$), the output value at target index $i$ retrieves the input bit located $k$ positions to its left (at index $i-k$ under left-to-right indexing).
- L1-L7 (Left Shifts): Act as right-pointing spatial pointers. For instance, a Left Shift of $k$ ($L_{k}$) at target index $i$ retrieves the input bit located $k$ positions to its right (at index $i+k$).
- C1-C7 (Circular Rotations): Act as wrapping pointers. For instance, $C_{k}$ at target index $i$ retrieves the input bit $k$ positions to its right, wrapping around to the left side of the array if the boundary is exceeded.
- Single-Bit Flips (Mandatory Bases): If two rows differ in their output, but only one base is different between them (a Hamming distance of 1), we have absolute mathematical certainty. That flipped base must be the reason the output changed. It is locked in as a mandatory base.
- Multi-Bit Flips (Logical Constraints): If two rows differ in their output and multiple bases differ, logic dictates that the change in output was caused by one of those flipped bases, or a combination of them. This trace acts as an explicit logical OR constraint.

## Exemplos e evidências
See original source at `Clippings/Teaching LLMs String Matching, Backtracking, and Error Recovery to Deduce Bases and Truth Tables for the Combinatorially Exploding Bit Manipulation Puzzles.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/Python]]
