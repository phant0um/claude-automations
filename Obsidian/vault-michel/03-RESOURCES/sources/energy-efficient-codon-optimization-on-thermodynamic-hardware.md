---
title: "Energy-efficient Codon Optimization on Thermodynamic Hardware"
type: source
source: "Clippings/Energy-efficient Codon Optimization on Thermodynamic Hardware.md"
created: 2026-06-23
ingested: 2026-06-23
score: D
tags: [ai-agents, source-page]
---

## Tese central
The growing energy demand for computation is becoming increasingly unsustainable. Thermodynamic computing, which harnesses physical thermal fluctuations as a computational resource rather than suppressing them, offers orders-of-magnitude energy savings for probabilistic and combinatorial tasks. Pharmaceutical R&D, heavily reliant on computational optimization and sampling, is a natural application domain.

## Argumentos principais
### 1 Introduction
Recent large-scale investments in artificial intelligence and computational workloads are placing increasing strain on the global energy infrastructure. Every year, U.S. companies spend an amount exceeding the inflation-adjusted cost of the Apollo program on AI-focused data centers. With demand projected to grow from 59 GW in 2025 to more than 120 GW by 2030 [^10], there are concerns that the energy demand for data centers is becoming unsustainable. At the same time, demand driven increases in model sizes and deployment footprints continue to grow rapidly, creating an urgent need for more efficient computing paradigms.
Existing AI systems are optimized for GPU hardware which was originally designed for computer graphics and whose suitability for machine learning was only discovered accidentally decades later. Had different cost effective hardware architectures been available, algorithms may well have evolved in a different and possibly more energy-efficient direction. This interplay between algorithm research and hardware availability, known as the “hardware lottery” [^8], entrenches hardware-algorithm pairings that may be far from optimal. Prudent planning calls for systematic exploration of alternative computing architectures [^11].
Figure 1: Thermodynamic computing overview. (a) A picture of a system containing two of Extropic’s prototype thermodynamic computing chips. These chips implement probabilistic computing primitives and are used to confirm the correct operation of these primitives and to measure their energy consumption. (b) Schematic of a thermodynamic sampling unit (TSU). The chip contains a grid of interconnected probabilistic bits (p-bits), two-colored for parallel block Gibbs updates. The host programs weights, the chip performs rapid sampling, and the host reads back the result. (c) Stochastic optimization on an energy landscape. Thermal fluctuations enable the system to explore broadly and escape local minima, converging toward low-energy solutions.

### 2 Results
Table 2: Optimization quality on the SARS-CoV-2 spike protein ($L=1{,}273$) for two parameter settings (see Section 4.1). We report the final energy (mean $\pm$ std across 512 independent chains) and the best score found across all chains. Lower scores indicate better solutions. The number of sweeps chosen is the minimal number of sweeps that achieves a score close to the best score achieved by all methods.
<table><thead><tr><th>Setting</th><th>Method</th><th>Mean score <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> std</th><th>Best score</th></tr></thead><tbody><tr><td rowspan="3">Standard (Fox)</td><td>Potts model (10 sweeps)</td><td><math><semantics><mrow><mtext>234.6</mtext> <mo>±</mo> <mn>0.2</mn></mrow> <annotation>\textbf{234.6}\pm 0.2</annotation></semantics></math></td><td>234.0</td></tr><tr><td>Ising model (<math><semantics><mrow><mn>2</mn> <mo>×</mo> <msup><mn>10</mn> <mn>4</mn></msup></mrow> <annotation>2\times 10^{4}</annotation></semantics></math> sweeps, DWE)</td><td><math><semantics><mrow><mn>243.0</mn> <mo>±</mo> <mn>0.8</mn></mrow> <annotation>243.0\pm 0.8</annotation></semantics></math></td><td>240.5</td></tr><tr><td>Genetic algorithm (tuned)</td><td><math><semantics><mrow><mn>234.8</mn> <mo>±</mo> <mn>0.4</mn></mrow> <annotation>234.8\pm 0.4</annotation></semantics></math></td><td>233.9</td></tr><tr><td rowspan="3">Hard</td><td>Potts model (10 sweeps)</td><td><math><semantics><mrow><mtext>445.2</mtext> <mo>±</mo> <mn>1.0</mn></mrow> <annotation>\textbf{445.2}\pm 1.0</annotation></semantics></math></td><td>444.0</td></tr><tr><td>Ising model (<math><semantics><mrow><mn>4</mn> <mo>×</mo> <msup><mn>10</mn> <mn>4</mn></msup></mrow> <annotation>4\times 10^{4}</annotation></semantics></math> sweeps, DWE)</td><td><math><semantics><mrow><mn>452.8</mn> <mo>±</mo> <mn>1.1</mn></mrow> <annotation>452.8\pm 1.1</annotation></semantics></math></td><td>449.2</td></tr><tr><td>Genetic algorithm (tuned)</td><td><math><semantics><mrow><mn>446.4</mn> <mo>±</mo> <mn>1.0</mn></mrow> <annotation>446.4\pm 1.0</annotation></semantics></math></td><td>444.4</td></tr></tbody></table>

### 2.1 Problem setup
We benchmark all methods using the SARS-CoV-2 spike protein, a biologically relevant sequence of $L=1{,}273$ amino acids (requiring $3{,}819$ mRNA nucleotides), using *Escherichia coli* K-12 as the host organism. The energy function to be minimized is a weighted combination of three terms (see Section 4.1 and Fig. 3a): a codon usage penalty ($w_{f}=0.1$) that favors codons commonly used in the host, a GC content term ($w_{\text{GC}}=1$) that penalizes deviation from a target GC fraction of $\rho_{T}=0.5$, and a repeat penalty ($w_{R}=0.1$) that discourages long runs of identical nucleotides across codon boundaries. These weights follow the formulation of [^6] and reflect commonly used values in codon optimization practice.
We evaluate three optimization methods. First, a Potts model sampler that operates directly on categorical codon variables (see Section 4.2 and Fig. 3b) using simulated annealing with block Gibbs updates (10 sweeps). Second, an Ising model sampler that encodes the categorical variables into binary spins via domain-wall encoding (see Section 4.4 and Fig. 3b,c) and performs simulated annealing with simultaneous penalty ramping ($2\times 10^{4}$ sweeps). Third, a genetic algorithm (GA) baseline reimplemented from [^6] with more carefully tuned parameters (population 200, $1{,}000$ generations, mutation rate $0.003$; see Section 4.6 for sensitivity analysis).

### 2.2 Optimization quality
Table 2 summarizes the optimization quality achieved by each method under both the standard weights from [^6] and the harder parameter setting described in Section 4.1. Under both settings, all three methods produce solutions of comparable quality. The Potts model and GA achieve essentially identical performance, while the Ising model scores slightly higher, which is expected given the overhead of the binary encoding.
The key observation is that all methods effectively achieve the same optimization quality under both parameter settings, within ${\sim}4\%$ of each other, making the solution quality interchangeable and the energy consumption the decisive differentiator. All energy estimates below are for the standard parameter setting from [^6].

### 2.3 Energy consumption
We estimate the energy required to solve the codon optimization problem on thermodynamic hardware and compare it to conventional GPU execution (see Section 4.7 for full methodology). The TSU energy model, validated against prototype hardware measurements [^11], estimates $E_{\text{cell}}\approx 1.3$ fJ per spin per Gibbs step.
#### Ising chip.
The Ising model uses $N=3{,}147$ binary spins (p-bits) and $K=2\times 10^{4}$ Gibbs iterations. The estimated energy is:

### 2.4 Scaling considerations
Solving the codon optimization problem for the spike protein requires $3{,}147$ spins in the Ising formulation, well within the capacity of near-term TSU designs (${\sim}250{,}000$ p-bits). This leaves substantial headroom for larger proteins, longer mRNA constructs, or more complex energy functions incorporating additional biological objectives. The chain-like graph structure of the problem, with a maximum node degree of 12, maps naturally to the sparse, locally-connected topology of a TSU.
At a random number generator (RNG) decorrelation time of ${\sim}100$ ns (measured from prototype hardware [^11]), a full Gibbs step on a 4-colorable graph takes ${\sim}400$ ns. The $2\times 10^{4}$ -step Ising optimization would therefore complete in approximately $8$ ms on a TSU which is more than fast enough for integration into real-time computational pipelines.

### 3 Discussion
This work demonstrates that a real world pharmaceutical optimization problem can be efficiently mapped to thermodynamic hardware, with energy savings of five to nine orders of magnitude compared to conventional computing (Table 3). By taking a concrete pharmaceutical application from problem formulation through hardware mapping to energy estimation grounded in prototype measurements, it provides a template for evaluating thermodynamic computing on applied problems.
The Potts formulation is algorithmically superior to the Ising encoding: it uses fewer variables ($1{,}273$ categorical vs. $3{,}147$ binary), requires fewer sampling sweeps (10 vs. $2\times 10^{4}$), and achieves slightly better scores. However, building Ising (p-bit) hardware is substantially simpler than building Potts (p-dit) hardware. A TSU capable of running the Ising formulation could be commercially available within one to two years, while categorical hardware remains further out. Crucially, the ${\sim}100\times$ energy gap between the projected Potts chip and the Ising chip is modest compared to the $10^{5}$ – $10^{9}$ times advantage that *both* enjoy over GPUs. This favors the Ising formulation as the practical near-term path.
We acknowledge several limitations: The codon optimization objective used here is a simplified version of what production pipelines employ; more involved formulations may include terms for mRNA secondary structure, CpG dinucleotide content, and untranslated region effects [^6]. These can be incorporated as additional local or pairwise energy terms without fundamentally changing the graph structure or hardware requirements; The energy estimates for the Potts chip are projections based on extrapolation from prototype measurements, while the Ising estimates rest on a validated physical model with close agreement to experimental data [^11].; Finally, codon optimization itself is not the computational bottleneck in drug development, but it does serve as a concrete, accessible proof of concept that the pipeline from problem formulation through hardware mapping to energy estimation is viable.

### 4.1 Codon optimization problem
Given a protein sequence of $L$ amino acids $a_{1},\ldots,a_{L}$, the codon optimization problem is to select a synonymous codon $c_{p}\in S_{p}$ at each position $p$ to produce an mRNA sequence with desirable expression properties in a target host organism [^7] [^16] [^2]. The set $S_{p}$ contains all codons encoding amino acid $a_{p}$, with $|S_{p}|\in\{1,2,3,4,6\}$ depending on the amino acid.
The objective is to minimize the energy function:
$$

### 4.2 Potts model formulation
The codon optimization problem maps naturally to a Potts model [^19]: each amino acid position $p$ becomes a categorical random variable $X_{p}$ with $|S_{p}|$ states, one for each synonymous codon. All variables are padded to $K_{\text{max}}=6$ states, with invalid states receiving a large positive bias that effectively excludes them.
Figure 3: From codons to Ising spins. (a) The codon optimization problem: each amino acid in a protein sequence is encoded by a triplet codon, with multiple synonymous options. The goal is to choose codons that optimize usage frequency, GC content, and repeat avoidance. (b) Potts model representation with domain-wall encoding. Each amino acid position becomes a categorical variable in a chain graph (top); the chain is 2-colorable, enabling parallel block Gibbs updates. Each K -state Potts variable is encoded as − 1 K{-}1 binary spins in a thermometer pattern (bottom), where the domain wall position encodes the categorical state. (c) Full Ising graph for a short protein segment. Intra-position constraint edges enforce validity; inter-position edges encode codon interactions. The graph is 4-colorable for parallel updates. The spike protein maps to 3,147 spins.
The Potts energy decomposes into unary biases $h_{p}(k)$ (from the codon usage term and validity constraints) and pairwise interactions $J_{p}(k,k^{\prime})$ (from the repeat penalty between adjacent positions $p$ and $p+1$):

### 4.3 Adaptive GC coefficient
The GC content term in Eq. 2 couples all positions through a global quadratic constraint. Expanding this term directly would require all-to-all pairwise interactions, which is incompatible with the sparse connectivity of a TSU. All-to-all connectivity also increases the chromatic number of the graph to be equal to the total number of nodes, which completely prevents sampling blocks of nodes in parallel. Instead, we approximate it with an adaptive linear term: a per-chain coefficient $\lambda$ that modifies the unary bias of each codon proportionally to its GC count:
$$
\tilde{h}_{p}(k)=h_{p}(k)+\lambda\cdot g(c_{p}^{(k)}).

### 4.4 Ising embedding via domain-wall encoding
Binary spin hardware (with p-bits) is simpler to build and closer to commercial availability than categorical hardware (with p-dits). To make the codon optimization problem executable on a binary TSU, we compile the Potts model into an Ising model using domain-wall encoding (DWE) [^3] [^1] [^4].
A $K$ -state Potts variable is represented by $K{-}1$ binary spins $s_{1},\ldots,s_{K-1}\in\{-1,+1\}$ arranged in a chain. Valid states follow a thermometer pattern: state $k$ corresponds to $s_{1}=\cdots=s_{k}=+1$ and $s_{k+1}=\cdots=s_{K-1}=-1$. The “domain wall”—the boundary between the $+1$ and $-1$ regions—encodes the Potts state. Invalid configurations (with a $-1$ followed by a $+1$) are penalized by ferromagnetic nearest-neighbor couplings of strength $P/4$ within each position’s spin chain, adding $K{-}2$ constraint edges per position.
DWE offers several advantages over the more common one-hot encoding [^13]. First, the constraint graph is a chain ($K{-}2$ edges) rather than a clique ($K(K{-}1)/2$ edges), yielding a much sparser graph. Second, the chain constraint is 2-colorable, which at most doubles the chromatic number of the overall graph—unlike one-hot, which requires $K$ colors for its penalty clique, which can therefore increase the chromatic number of the graph $K$ -fold. Since the chromatic number of the graph determines how many sampling steps are required per Gibbs iteration, the one-hot encoding is typically $K/2$ -times slower than DWE per Gibbs iteration, on top of possibly also requiring a far greater number of Gibbs iterations due to its slow mixing. Third, mixing at the domain wall boundary is independent of the penalty strength $P$: the ferromagnetic contributions from the two neighbors cancel, so the Gibbs conditional depends only on the bias landscape. This eliminates the exponential mixing slowdown [^12] that plagues one-hot encoding at large $P$ [^1]. Fourth, DWE has been proven optimal in the number of binary variables for quadratic interactions [^1].

### 4.5 Simulated annealing and P-ramping
Both the Potts and Ising models use simulated annealing with a log-spaced inverse temperature schedule:
$$
\beta_{t}=\beta_{\text{min}}\cdot\left(\frac{\beta_{\text{max}}}{\beta_{\text{min}}}\right)^{t/T}

### 4.6 Genetic algorithm baseline
Genetic algorithms are widely used for codon optimization [^6] [^17]. As a baseline, we reimplemented the GA from [^6] in JAX, with full JIT compilation of the generation loop and multi-chain parallelism. After systematic parameter tuning, the best configuration uses a population of 200, $1{,}000$ generations, 10 elite and 2 lucky survivors per generation, and a mutation rate of $0.003$.
The GA’s performance is sensitive to parameter choice. The default mutation rate of $0.05$ from Fox et al. yields substantially worse scores (${\sim}550$ – $600$), suggesting that the crossover operator provides sufficient exploration and high mutation rates are counterproductive, disrupting good partial solutions faster than selection can preserve them.

### 4.7 Energy estimation methodology
#### TSU energy model.
We use the energy model from [^11] (Appendix E), which provides a physical model of an all-transistor Boltzmann machine Gibbs sampler. The energy per spin per Gibbs step is $E_{\text{cell}}\approx 1.3$ fJ, which includes contributions from the RNG (${\sim}350$ aJ), biasing circuitry, clocking, and inter-cell communication. This model captures all central functional units of the hardware and has been validated against measurements from a prototype chip, with agreement within an order of magnitude.
For the Ising chip, the total energy is $E=K\times N\times E_{\text{cell}}$, where $K$ is the number of Gibbs iterations and $N$ is the number of spins. For the Potts chip, we use a physical model of p-dit hardware extrapolated from the same prototype measurements, yielding ${\sim}0.084$ nJ per Gibbs sweep for $L=1{,}273$ Potts nodes.


## Key insights
- The *codon usage* term $u(c)=|\log(f(c)/f_{\text{max}}^{(a)})|$ measures how rare codon $c$ is in the host relative to the most common codon for its amino acid, using host-specific codon frequency tables [^14]. This term is *unary*: it depends on each position independently.
- The *GC content* term penalizes deviation of the overall GC fraction from a target $\rho_{T}$, where $g(c)\in\{0,1,2,3\}$ counts the G and C nucleotides in codon $c$. This term is *global*: it couples all positions.
- The *repeat penalty* $r(c_{p},c_{p+1})=m(c_{p},c_{p+1})^{2}-1$ penalizes long runs of identical nucleotides across codon boundaries, where $m$ is the length of the longest contiguous run in the 6-character concatenation. This term is *pairwise*: it depends on adjacent positions only.

## Exemplos e evidências
See original source at `Clippings/Energy-efficient Codon Optimization on Thermodynamic Hardware.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/harness]]
- [[03-RESOURCES/concepts/llm-ml-foundations/diffusion]]
- [[03-RESOURCES/concepts/software-engineering/proof]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/AWS]]
