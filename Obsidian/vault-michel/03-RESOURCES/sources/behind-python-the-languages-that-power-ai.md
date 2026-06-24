---
title: "Behind Python: The Languages That Power AI"
type: source
source: "Clippings/Behind Python The Languages That Power AI.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [ai-agents, source-page]
---

## Tese central
Python dominates AI development, yet the numerical work behind frameworks like PyTorch and NumPy is executed in C, C++, or Rust. When a developer must implement an algorithm without such libraries—because none exists, the target is resource-constrained, or a new system is being built—which language should they choose? This paper answers that question empirically.

## Argumentos principais
### 1 Introduction
Artificial intelligence (AI) systems are commonly developed using a layered software architecture. At the application level, data scientists and engineers rely heavily on high-productivity languages such as Python for experimentation, model development, and orchestration. However, the computational kernels that enable modern AI frameworks to achieve competitive performance are frequently implemented in lower-level compiled languages. NumPy relies extensively on C-based numerical routines, while frameworks such as PyTorch and TensorFlow build their performance-critical components in C++ and CUDA. More recently, Rust has gained adoption in AI infrastructure projects such as Hugging Face Tokenizers and Polars due to its combination of performance and memory safety. Julia, in contrast, was designed specifically to bridge the traditional gap between productivity and high-performance numerical computing through just-in-time compilation and a unified language ecosystem [^1] [^2] [^3] [^4].
This reality raises a practical question that remains insufficiently explored in literature. Developers often need to implement algorithms themselves, whether because no suitable library exists, a target environment imposes strict resource constraints, or they are building the next generation of AI infrastructure. In these situations, which programming language offers the best balance between execution speed, memory efficiency, and development effort? While compiled languages are often assumed to offer better performance than interpreted languages, the magnitude of this advantage and the extent to which it depends on the characteristics of specific AI workloads remain unclear.
Prior research has extensively compared programming languages from the perspectives of execution time, energy consumption, memory usage, and programmer productivity. Studies such as Prechelt’s empirical comparison of seven languages [^5], the Computer Language Benchmarks Game [^6], and the large-scale evaluation of energy efficiency by Pereira et al. [^7] provide valuable insights into language design trade-offs. Similarly, Bugden and Alahmar investigated Rust’s ability to deliver performance comparable to C and C++ while maintaining stronger safety guarantees [^8]. However, these studies largely rely on synthetic workloads or systems-oriented benchmarks such as recursive algorithms, sorting routines, numerical kernels, and tree-processing tasks. Although useful for evaluating language runtimes and compilers, these workloads do not necessarily reflect the computational patterns found in artificial intelligence algorithms.

### 2.1 Programming-Language Performance Evaluation
The empirical comparison of programming languages has been an active research area for decades. One of the earliest influential studies was conducted by Prechelt [^5], who compared seven programming languages using a common software-development task and highlighted the trade-offs between development effort and execution performance. Since then, the Computer Language Benchmarks Game [^6] has become one of the most widely referenced resources for cross-language performance comparisons, providing implementations of standardized computational benchmarks across dozens of programming languages. Nanz and Furia further expanded this line of research by analyzing implementations from the Rosetta Code repository and comparing languages in terms of performance, conciseness, and other software quality attributes [^9].
More recent work has expanded the scope of language evaluation beyond execution speed. Pereira et al. [^7] analyzed twenty-seven programming languages and demonstrated significant relationships among execution time, memory consumption, and energy efficiency. Their results reinforced the notion that language choice can have measurable consequences not only for performance but also for resource utilization. Similarly, Bugden and Alahmar [^8] examined Rust’s safety-oriented design and found that it can achieve performance comparable to traditional systems languages while reducing classes of memory-related errors.
Although these studies provide valuable evidence regarding language behavior, most rely on synthetic or systems-oriented workloads such as recursive computations, sorting algorithms, regular-expression processing, and numerical kernels. Consequently, their findings cannot be directly generalized to AI workloads, whose computational characteristics often include iterative optimization, dense numerical computation, population-based search, and rule-based inference. The present work adopts the methodological strengths of this literature while focusing specifically on algorithms representative of artificial intelligence.

### 2.2 Programming Languages in Modern AI Infrastructure
Modern AI software is characterized by a separation between user-facing productivity layers and performance-critical computational kernels. Python dominates AI development due to its extensive ecosystem and ease of use, yet the underlying numerical computations are frequently delegated to native implementations. NumPy provides array programming capabilities through optimized C routines [^2], while PyTorch relies heavily on C++ and CUDA backends to deliver high-performance tensor operations [^3].
At the same time, alternative language ecosystems have emerged. Julia was designed to overcome the so-called “two-language problem,” in which prototypes are written in high-level languages and later rewritten in lower-level languages for performance. Through LLVM-based just-in-time compilation, Julia aims to provide both developer productivity and near-native execution speed [^1] [^10]. Rust has gained increasing attention in AI infrastructure because its ownership model provides memory safety without garbage collection, making it attractive for performance-critical libraries and tooling. Go has similarly found widespread use in distributed systems, cloud infrastructure, and model-serving environments due to its simplicity, concurrency primitives, and deployment characteristics.
Despite these developments, existing evaluations typically measure the performance of language ecosystems rather than the languages themselves. When implementations rely on optimized libraries, the dominant computational work is often executed in C, C++, Rust, or GPU kernels regardless of the language visible to the user. As a result, there remains a need for controlled studies that isolate the effect of the programming language itself through from-scratch implementations of AI algorithms.

### 2.3 AI Algorithms as Benchmark Workloads
Benchmark selection is a critical factor in programming-language evaluation because different computational patterns show different aspects of language runtimes and compiler optimizations. To obtain a broad coverage of artificial intelligence workloads, this study focuses on five well-established algorithms that represent distinct AI paradigms.
$K$ -means clustering remains one of the most widely used unsupervised learning techniques and serves as a representative example of iterative distance-based optimization [^11] [^12]. $K$ -nearest neighbors ($k$ -NN) provides a classic instance-based learning method whose computational cost is dominated by distance calculations and comparison operations [^13]. Multilayer perceptrons trained through backpropagation represent the foundation of modern neural-network learning and exercise dense numerical computation and gradient-based optimization [^14]. Genetic algorithms exemplify evolutionary computation through population-based search and stochastic optimization [^15]. Finally, Mamdani fuzzy inference systems remain among the most influential approaches in fuzzy logic and rule-based intelligent systems [^16].
These algorithms were selected not because they represent the current state of the art, but because their definitions are mature, reproducible, and broadly understood. Together, these algorithms cover a broad range of computational patterns, including floating-point intensive computation, exhaustive search, iterative optimization, stochastic evolution, and rule-based inference. This diversity allows an examination of whether language performance remains consistent across different types of AI workloads. To the best of the authors’ knowledge, no previous study has compared from-scratch implementations of such a diverse set of AI algorithms across Python, C, C++, Rust, Go, and Julia using a common experimental framework.

### 3 Methodology
The comparison rests on a single idea: if every language solves a byte-for-byte identical problem, then any gap in time or memory is a property of the language, not of the computation. The rest of this section makes that idea concrete, describing the languages and toolchain (Sect. 3.1), the five algorithms and their parameters (Sect. 3.2), the determinism protocol that equalizes the workload across languages (Sect. 3.3), and the measurement protocol (Sect. 3.4).

### 3.1 Languages and Toolchain
The six languages (Python, C, C++, Rust, Go, and Julia) were motivated in Sect. 2; the concrete toolchain on which they run is fixed here. They span the design space along three axes that matter for AI workloads: execution model (interpreted, JIT-compiled, ahead-of-time compiled), memory management (garbage-collected vs. manual/ownership), and abstraction level. Table 1 lists the compiler or runtime and the optimization settings used for each. All experiments run on an Apple MacBook with an M1 Pro processor (six performance and two efficiency cores) and 16 GB of unified memory, under macOS. Each language uses its standard, idiomatic optimization settings; none uses SIMD intrinsics, hand-vectorization, or external numerical libraries.
Table 1: The six languages, their toolchains, and optimization settings. Versions are pinned in the reproducibility artifact.
| Language | Toolchain | Optimization |

### 3.2 Benchmark Algorithms
The five benchmarks are sized so that the fastest languages, C and C++, run for roughly $0.35$ – $0.75$  s apiece: long enough to dwarf timer noise, short enough that even Python finishes the full suite in hours rather than days. Table 2 lists the parameters; the descriptions below fix the details that must match across languages for the outputs to agree: initialization, tie-breaking, and stopping rules. Several of the choices below (squared distances, ReLU with mean-squared error, the Rosenbrock objective, and triangular membership functions) follow from the bit-exactness requirement motivated in Sect. 3.3.
$k$ -means (data mining).
Lloyd’s algorithm on $N{=}100{,}000$ points in $D{=}4$ dimensions with $K{=}10$ clusters and $1000$ fixed iterations (no early stopping, for determinism). Centroids are initialized to the first $K$ points; each point is assigned to the nearest centroid by squared Euclidean distance, ties broken to the lowest index; centroids are recomputed as cluster means.

### 3.3 Cross-Language Fairness and Determinism
Cross-language fairness is enforced through two design choices. First, each language implements the same algorithm with identical parameters, written idiomatically but without external libraries. Second, all randomness is generated by a single 64-bit linear congruential generator (LCG), reproduced verbatim in all six languages:
$$
s_{i+1}=(a\,s_{i}+c)\bmod 2^{64},\qquad u_{i}=(s_{i}\gg 33)\,/\,2^{31},

### 3.4 Metrics and Measurement Protocol
Five metrics are reported, covering both runtime cost and developer cost.
M1 (wall-clock time) and M2 (peak resident set size) are measured together. Each benchmark is executed under /usr/bin/time -l, which reports ru\_maxrss on macOS, and timed with hyperfine using 10 measured runs after 3 warmup runs. Standard output is redirected to /dev/null, although each program still computes and prints its checksum to prevent dead-code elimination.
M3 (binary size) is the size of the compiled executable as reported by stat. It is not applicable to Python and Julia. M4 (lines of code) is measured with wc -l, summed across the five benchmark implementations and excluding build files. M5 (compilation time) is the cold-build wall time of the five benchmarks after clearing the toolchain cache. Like binary size, it is not applicable to Python and Julia.

### 3.5 Reproducibility
The study is deliberately not containerized. On Apple silicon, Docker runs Linux inside a virtual machine, changing the operating system, system libraries, and toolchains while introducing additional virtualization overhead. Since the objective is to measure native execution time and memory consumption on the target platform, all experiments are performed directly on the host system.
Reproducibility instead relies on the determinism protocol described in Sect. 3.3. Every implementation executes the same algorithm, consumes the same pseudo-random inputs, and produces the same validation fingerprints. As a result, any machine can reproduce the workload exactly, although absolute execution times may differ across hardware and software environments.
All source code, benchmark harnesses, raw result files, and toolchain versions are included in the artifact. The complete benchmark suite can be reproduced with a single command (bash harness/run\_all.sh).

### 4 Results
The runtime metrics are presented first (M1 wall-clock time, M2 peak memory), followed by the developer-cost metrics (M3 binary size, M4 lines of code, M5 compilation time). All timings are the mean of ten runs after three warmups; the relative standard deviation stayed under $4\%$ on every language–benchmark pair and under $1.5\%$ in the large majority, confirming a quiet measurement environment.

### 4.1 Execution Time (M1)
Table 3 reports mean wall-clock time for all thirty language–benchmark pairs, together with each language’s geometric-mean slowdown relative to C. Figure 1 shows the same data on a logarithmic scale.
Table 3: Mean wall-clock time in seconds (ten runs after three warmups). The last column is the geometric mean of each language’s per-benchmark slowdown relative to C. Lower is better; the fastest entry per benchmark is in bold.
| Language | $k$ -means | $k$ -NN | MLP | GA | Fuzzy | Geo. $\times$ C |

### 4.2 Peak Memory (M2)
Table 4 reports mean peak resident set size, visualized in Fig. 2. The manual- and ownership-managed languages (C, C++, and Rust) remain below $6$  MiB on every benchmark. Go’s garbage-collected runtime increases average memory usage to $6.3$  MiB. Python’s interpreter overhead raises this figure to roughly $28$  MiB. Julia is the clear outlier: its JIT compiler and runtime maintain approximately $\sim\!224$  MiB resident regardless of the workload, a fixed cost that dwarfs the benchmark data itself and may become a significant consideration in memory-constrained deployments.
Table 4: Mean peak resident set size in MiB (ru\_maxrss via /usr/bin/time -l). Lower is better; lowest per benchmark in bold.
| Language | $k$ -means | $k$ -NN | MLP | GA | Fuzzy | Mean |

### 4.3 Developer-Cost Metrics (M3–M5)
Table 5 reports binary size, lines of code, and compilation time. Binary size spans nearly two orders of magnitude: C and C++ produce $\sim\!34$  KB executables, Rust $373$  KB (due to monomorphization and a statically linked runtime), and Go $2.5$  MB (including its runtime and garbage collector).
Lines of code, summed across the five benchmark implementations, are surprisingly similar across languages. C++ ($397$) and C ($406$) are the most concise, while Python ($406$) requires essentially the same amount of code as C. Go ($541$) is the most verbose, largely due to explicit error handling and the use of conventional loops for numeric kernels.
Compilation is sub-second per benchmark for C and C++. Rust’s $8.7$  s cold build reflects its heavier optimization pipeline and monomorphization, which contribute to its runtime performance.

### 5.1 RQ1: Time and Memory Ranking
The three execution-time tiers identified in Sect. 4 provide a direct answer to RQ1, but the implications become clearer when execution time and memory consumption are considered together. C, C++, and Rust are observed to form a high-performance tier whose execution times differ by less than $10\%$ on average. Within this group, the choice is unlikely to be driven by performance alone. Instead, considerations such as memory safety, tooling, and ecosystem maturity become increasingly important.
A more substantial distinction appears in the managed-language tier. Julia achieves considerably better execution times than Go, but this advantage is accompanied by a much larger memory footprint. Across all benchmarks, Julia maintains a resident memory usage of approximately $224$,MiB regardless of workload size, whereas Go remains below $10$,MiB. As a result, the relative attractiveness of these languages depends strongly on deployment constraints. Where execution speed is the primary concern, Julia may be preferable; where memory availability is limited, Go presents a more balanced alternative.
More broadly, execution-time rankings and memory rankings do not necessarily coincide. Language selection therefore depends not only on raw performance but also on the resource constraints of the target environment.


## Key insights
- At the application level, data scientists and engineers rely heavily on high-productivity languages such as Python for experimentation, model development, and orchestration.
- However, the computational kernels that enable modern AI frameworks to achieve competitive performance are frequently implemented in lower-level compiled languages.
- First, it provides a controlled benchmark of five AI algorithms implemented from scratch in six programming languages.
- Similarly, Bugden and Alahmar [^8] examined Rust’s safety-oriented design and found that it can achieve performance comparable to traditional systems languages while reducing classes of memory-related errors.
- Rust has gained increasing attention in AI infrastructure because its ownership model provides memory safety without garbage collection, making it attractive for performance-critical libraries and tooling.
- Go has similarly found widespread use in distributed systems, cloud infrastructure, and model-serving environments due to its simplicity, concurrency primitives, and deployment characteristics.
- As a result, there remains a need for controlled studies that isolate the effect of the programming language itself through from-scratch implementations of AI algorithms.
- ### 2.3 AI Algorithms as Benchmark Workloads

Benchmark selection is a critical factor in programming-language evaluation because different computational patterns show different aspects of language runtimes and compiler optimizations.
- They span the design space along three axes that matter for AI workloads: execution model (interpreted, JIT-compiled, ahead-of-time compiled), memory management (garbage-collected vs.
- Because both the generator and the order in which its values are consumed are identical across implementations, every benchmark receives the same sequence of pseudo-random inputs.

## Exemplos e evidências
See original source at `Clippings/Behind Python The Languages That Power AI.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/harness]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Apple]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]
- [[03-RESOURCES/entities/CUDA]]
