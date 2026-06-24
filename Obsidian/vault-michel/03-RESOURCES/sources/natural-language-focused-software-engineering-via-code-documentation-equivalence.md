---
title: "Natural Language-Focused Software Engineering via Code-Documentation Equivalence"
type: source
source: "Clippings/Natural Language-Focused Software Engineering via Code-Documentation Equivalence.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [articles, source-page]
---

## Tese central
---
title: "Natural Language-Focused Software Engineering via Code-Documentation Equivalence"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Aryaz Eghbali [0000-0001-9763-8147]( "ORCID identifier") CISPA Helmholtz Center for Information SecurityStuttgartGermany [aryaz.egh@gmail.com](), Zhongxin Liu [0000-0002-1981-1626]( "ORCID identifier") Zhejiang UniversityHangzhouChina [liu˙zx@zju.edu.cn]() and Michael Pradel [0000-0003-1623-498X]( "ORCID identifier")

## Argumentos principais
### 1\. Introduction
Source code, written in formal programming languages, is often difficult to read and understand, especially for complex codebases or when the code is written by someone else. Hence, most programming languages support natural language documentation in the form of comments and docstrings, allowing developers to describe code intent more clearly. Such documentation has been shown to be beneficial in improving code comprehension and facilitating collaboration among developers [^13] [^16]. However, time constraints and the continuous evolution of code can lead to documentation that is incomplete, outdated, or inaccurate [^11] [^13] [^16] [^18]. Such documentation, or simply no documentation at all, can hinder the understanding of the code and delay the development process.
[⬇]()
…

### 2\. Approach
We first define the novel concept of *documentation-to-code equivalence* as a property of a piece of documentation relative to a code snippet (Section 2.1). Then, we present our Documentary approach to automatically generate equivalent documentation for a given code snippet (Section 2.2).

### 2.1. Definition of Documentation-to-Code Equivalence
Suppose we have a piece of code $c$, a piece of documentation $d$ that is intended to document $c$, and some surrounding context $\mathit{ctx}$ that provides additional information about the code, such as other functions, classes, or modules in the same file or project. Furthermore, let $L$ be a large language model (LLM) that can generate code from natural language prompts. The *documentation-to-code equivalence* property is defined as follows: The documentation $d$ is equivalent to the code piece $c$, with respect to an LLM $L$ and the surrounding context $\mathit{ctx}$, if $L$ can generate $c$ from $(d,ctx)$. If this property holds, we say that $d$ is an *equivalent documentation* for $c$.
The above formulation is general and can be instantiated with different kinds of code, documentation, context, and LLMs. In the remainder of this paper, we focus on function-level docstrings as the documentation, function bodies as the code, and the whole source code file as the surrounding context.

### 2.2. Generating Equivalent Documentation
Figure 2. Overview of the iterative approach to generate equivalent documentation.
We present an automatic approach, called Documentary, to generate equivalent documentation. Given a function signature, its body, and the surrounding context, Documentary produces a docstring that is equivalent to the function body, according to the definition in Section 2.1.
Figure 2 shows an overview of Documentary. Documentary starts by generating code from the existing documentation (if none exists, it uses only the surrounding context). Then, using the same LLM that generated the code as a judge [^3] [^6], the approach compares the generated code with the original code to determine whether they are equivalent. If they are not equivalent, the approach generates a brief description of the differences between the two code snippets. This description is then used to generate new documentation that is more specific and accurate. Documentary repeats this process until the generated documentation is equivalent to the given code snippet, i.e., the code generated from the documentation is judged to be equivalent to the original code, or until a maximum number of iterations is reached.

### 3\. Applications
We consider two common software engineering tasks—output prediction and code editing—and in our evaluation, show how equivalent documentation benefits both human developers and LLMs when performing these tasks.

### 3.1. Code Understanding via Output Prediction
The first task we consider is code understanding, where we use output prediction as a proxy task. In this task, given a function signature and its documentation, the goal is to predict the output of the function for a given input. This task reveals how much behavioral information the documentation contains about the function. Since many downstream software engineering tasks, such as test generation, bug detection, and code editing, require understanding the behavior of the code on a certain input, improvements in this task can also benefit those tasks.
[⬇]()
def \_\_init\_\_(self, app: ASGIApp) -> None:

### 3.2. Code Editing
As the second task, we consider code editing. This task represents a scenario in which a developer wants to modify a function based on a natural language description of the change. In this task, given a code snippet $c_{old}$ with its documentation $d_{old}$ and a change description $m$, the goal is to modify the code to $c_{new}$.
For example, consider commit c718248 in the keras-team/keras repository, which describes the change in the code as ”Validate positive height and width in image resize”. Figure 11 shows the change in function resize, where a check for negative dimensions is added that raises a ValueError if either dimension is negative.
[⬇]()

### 4\. Evaluation
We evaluate our approach and the utility of the generated documentation in downstream tasks, addressing the following research questions:
1. How effective is our approach in generating equivalent docstrings?
2. How transferable are equivalent docstrings across different LLMs?

### 4.1. Experimental Setup
#### 4.1.1. Datasets
We use two datasets from previous work as the basis for our evaluations. The first dataset is CoDocBench [^22], which is a dataset of pairs of code and docstring changes in the history of 203 popular Python projects on GitHub. The second dataset is DyPyBench [^8], which is a dataset of 50 popular projects across various domains that have executable tests. From the union of these datasets (252 unique projects), we create three datasets for our evaluation.
The first dataset, which we call the *code-docstring equivalence dataset*, is used for RQs1–4, where we want to evaluate the behavioral equivalence of the generated code piece with the human-written code. Therefore, we use test execution as the ground truth for behavioral equivalence. To this end, for each project in the union of the datasets, we try to run the test suite by installing the dependencies using the pipreqs package [^1]. From the executable projects, we take the functions that are covered at least 50% by the tests. This results in 2437 functions from 12 projects. We then sample at most 25 functions from each project, which results in a total of 238 functions. These functions range from 2 to 168 lines of code, with an average of 16 and median of 9 lines of code. Most functions lack docstrings; only 47% are documented.

### 4.2. RQ1: Generating Equivalent Documentation
We run Documentary on each function in the dataset to obtain an equivalent docstring. For cases where Documentary fails to generate an equivalent docstring, we use the last generated docstring as its best effort. Then we prompt the LLM to generate the body of the function, based on the context, the function signature, and the generated docstring. Finally, we run the tests to check if the generated code behaves the same as the original code. If the test results of the generated code match the test results from the original code, we consider the generated docstring to be equivalent to the code. We report the success rate, and precision, which show how often Documentary generates a docstring equivalent to the code, and how often docstrings that Documentary claims to be equivalent are actually equivalent, respectively.
As shown in Table 2, Documentary generates equivalent docstrings in 53.4% of the cases. When claiming that a generated docstring is equivalent to the code, then for 66.4% of these cases the generated docstrings are indeed equivalent to the code.
Figure 13 shows how the length of the function, measured in lines of code (LoC), affects the success rate of generating equivalent documentation. Unsurprisingly, the success rate decreases as the function length increases, which is expected as longer functions are more complex and harder to describe in a docstring. However, Documentary consistently outperforms the baseline across all function lengths except one, where there is only one function that the baseline is able to generate equivalent docstring.

### 4.3. RQ2: Model Independence
To evaluate how useful equivalent documentation is across different models, we run an experiment where we generate equivalent documentation using one LLM, and then use that documentation to generate code using different LLMs. We then run the tests to check if the generated code is equivalent to the original code. If the test results match the test results from the original code, we consider the generated code to be equivalent to the original code. For the model used in Documentary, we use gpt-4.1-nano, and we use gpt-5-nano, and gemini-2.5-flash-lite as the other LLMs used for generating code from the equivalent documentation.
For each function, we first generate equivalent documentation using gpt-4.1-nano and our approach. Then, for cases where Documentary declares the generated documentation as equivalent, we use the generated documentation to generate code using gpt-5-nano, and gemini-2.5-flash-lite. Finally, we run the tests to check if the generated code is equivalent to the original code. For gpt-5-nano, 89.6% of the generated code are equivalent to the original code, and for gemini-2.5-flash-lite, 74.7% of the generated code are equivalent to the original code. Comparing these results with Documentary’s precision of 88.9% (obtained when using gpt-4.1-nano for code generation), we see that other LLMs generate equivalent code at a similar rate.
These results show that equivalent documentation can be generated and used by different LLMs. More importantly, this also shows that equivalent documentation can persist in the code and provide its benefits while the LLMs evolve.

### 4.4. RQ3: Ablation Study
We study the effects of the number of iterations and the size limit on the effectiveness of generating equivalent documentation. For the number of iterations, we run our approach with a maximum of 10 iterations and a size limit of 2x, and report the distribution of the iteration count when the approach decides that the generated documentation is equivalent to the code. If the original docstring is already equivalent to the code, the iteration count is zero. Iteration counts greater than zero mean that the approach generates the docstring after that many attempts. As shown in Fig. 14, most (75%) equivalent documentation is generated within five iterations, and the median number of iterations is two.
Figure 14. Distribution of the number of iterations when generating equivalent docstrings.
For the size limit, we run our approach with a maximum of 10 iterations and size limits of 0.5x, 1x, 2x, and 3x. Figure 15 shows the success rate and the precision of the generated equivalent documentation for different size limits. Our results show that a size limit of 1x provides the best precision and success rate. We suspect that a size limit greater than 1x encourages the LLM to generate verbose docstrings that contain unnecessary information, which can confuse the LLM in generating the code from the docstring.

### 4.5. RQ4: Costs
We measure the runtime and monetary costs of generating equivalent documentation using Documentary. This experiment measures the time it takes to run Documentary per function in seconds using Python’s time.perf\_counter, as well as the number of input and output tokens when running Documentary on a function. We then calculate the cost of generating an equivalent docstring, based on the current pricing of gpt-4.1-nano.
Regarding time, it takes 33.8 seconds to generate an equivalent docstring on average per function. Figure 16 shows that for most functions it takes less than a minute to generate an equivalent docstring. Regarding token consumption, Documentary uses 78,144 input tokens and 3,173 output tokens, on average, for an attempt at generating an equivalent docstring for a function. Given the pricing of gpt-4.1-nano at $0.10 per 1M input tokens and $0.40 per 1M output tokens in February 2026, the average cost of generating an equivalent docstring for a function is $0.009. As shown in Fig. 16, most functions require less than 200K input tokens and 10K output tokens, resulting in a cost of less than $0.03 per function.
Furthermore, for large codebases to adopt equivalent documentation, the cost can be reduced by batching the generation and using cached input tokens as the context for multiple functions that contain the same prefix. Given the reasonable costs of our current approach, we leave such optimizations for future work.

### 4.6. RQ5: Equivalent Documentation for LLMs (Code Understanding)
We run an experiment to evaluate how well equivalent docstrings help LLMs understand the behavior of a function without seeing the code, as specified in Section 3.1. For this experiment, we use the *output prediction dataset* described in Section 4.1.1. For each test in the dataset, we first generate an equivalent docstring for the function-under-test using Documentary. If Documentary fails to generate an equivalent docstring, we fall back to using a docstring generated by the LLM, as in the baseline. Then, we prompt the LLM with the function signature, the equivalent docstring, and the test code, and ask it to predict the output of each assertion in the test as a valid Python expression. Finally, we compare the AST of the predicted output with the AST of the actual output in the assertion statement, and consider a match as a correct prediction.
The metrics we report are the number of correctly predicted assertions, the average percentage of correctly predicted assertions per test, and the number of tests where all assertions are correctly predicted. We compare the results of Documentary with the predictions from the original docstring and the baseline defined in Section 4.1.2.
Table 3 shows that using equivalent docstrings improves the number of correctly predicted assertions by 4.0–15.9, the average percentage of correctly predicted assertions per test by 0.6–17.3, and the number of tests where all assertions are correctly predicted by 5.6–19.0 absolute percentage points, compared to using human-written docstrings, and LLM generated docstrings. The results show that an equivalent docstring allows the LLM to not only implement the correct behavior, as shown in Section 4.2, but also predict the behavior of the function.

### 4.7. RQ6: Equivalent Documentation for Human Developers (Code Understanding and Code Editing)
We evaluate the effectiveness of equivalent docstrings for human developers by conducting a user study with 11 participants. The demographic statistics of the participants are shown in Table 4.
Table 4. Demographic statistics of the participants in the user study.
(a) Numerical attributes.


## Key insights
- A novel property (documentation-to-code equivalence) that describes a strong semantic relationship between code and its documentation.
- An iterative approach, called Documentary, to automatically generate equivalent documentation for a given code snippet.
- Empirical evidence of the benefits of equivalent documentation in two common software engineering tasks, code understanding and code editing.
- How much did the docstring help you in understanding the code?
- How much did the docstring help you in modifying the code?
- How difficult was this task?
- How confident are you in your solution?

## Exemplos e evidências
See original source at `Clippings/Natural Language-Focused Software Engineering via Code-Documentation Equivalence.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Gemini]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
