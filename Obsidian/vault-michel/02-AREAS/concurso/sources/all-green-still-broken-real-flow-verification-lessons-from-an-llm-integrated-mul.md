---
title: "All Green, Still Broken: Real-Flow Verification Lessons from an LLM-Integrated, Multi-Market Web Application"
type: source
source: "Clippings/All Green, Still Broken Real-Flow Verification Lessons from an LLM-Integrated, Multi-Market Web Application.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
Modern web applications increasingly combine three ingredients that are hard to test: output from large language models, multi-market internationalization, and browser-driven front-ends over external data sources. We report on a production rental-search assistant whose automated suite grew to 1,553 test cases in six weeks. The suite passed continuously, yet user-facing defects continued to reach production.

## Argumentos principais
### KEY INSIGHTS
- A large, passing test suite can miss whole classes of defect. A component test replaces the uncontrolled side of a boundary with a stand-in to run deterministically. That stand-in hides the seam. In the system studied, about 44 percent of bug fixes landed in such seams, so test count is a weak measure of quality.
- A single end-to-end pass through the running product, performed as a user in a non-default market, observes seams that component-level tests cannot.
- When the same defect recurs, fix the whole class behind it. Add a build check that fails on any repeat, so the same defect cannot ship again.

### THE SYSTEM AND ITS TESTS
The system is a rental-search assistant. It collects listings from several portals. It screens each listing against a user’s criteria with a large language model. A second model drafts an outreach message. The results appear on a dashboard of server-rendered HTML with small client-side libraries on top. The system serves two markets. The first is the original market, with one European city, one currency, and one language. The second was added later, with a different country, currency, and language.
Figure 2 shows how the suite grew. It reached 1,364 test functions, which pytest expands to 1,553 test cases, in 43 days. The curve flattens after about three weeks. All defects discussed in this report occurred after that point, while the suite was already large and passing.
Figure 2: Growth of the test suite over 43 days, counted as test functions. The suite reached 1,364 functions, which pytest expands to 1,553 cases. Growth plateaus after about three weeks; every defect in this report shipped in the shaded region that follows, when the suite was already large and passing.

### THE FOUR SEAMS
A seam is a boundary where our code meets something it does not control. We saw four of them, shown in Figure 3.
The runtime seam is where server output meets a browser that runs scripts. Our tests checked the HTML we sent. They did not run the browser that turns that HTML into behavior.
The market seam is where default-market assumptions meet a user in another market. Our tests and our manual checks used our own account, which always lived in the first market.

### A STUDY OF 252 DEFECTS
We classified every bug-fix commit in the project against the four seams.

### Method
The classification followed four steps. i) Sampling. We took one snapshot of the repository: 740 commits across six weeks. From these we selected every commit whose message begins with the conventional-commit prefix “fix.” That gave 252 bug-fix commits against 272 feature commits, nearly one fix per feature. ii) Taxonomy derivation. We defined the four seams from the six initial defects (Table 1), then applied them unchanged to the full census. iii) Classification. A short list of priority-ordered keyword rules assigned each fix to one category. A fix reaches a seam only when its message uses that seam’s vocabulary; everything else falls into a general backend group. The rules are deterministic and contain no project-specific names.<sup>1</sup> We did not hand-edit the output. A deterministic classifier has no inter-rater variance, so the threat here is rule validity, not reliability. We treat the four-seam share as a conservative lower bound, for the reasons in Study Limitations. iv) Guard proxy. We recorded whether each fix also changed a test file, as a proxy for adding a regression guard.

### Results
Figure 4 shows the distribution. About 110 fixes, or 44 percent, fall in the four seams that unit tests cannot see: 35 in the flow seam, 29 in the runtime seam, 23 in the market seam, and 23 in the system seam. Data-source fixes are 17 percent (44 fixes). The largest single group, 39 percent, is ordinary backend logic, where component tests are strong. No single seam dominates. Together the four seams total 110 fixes, more than double the data-source churn that teams already treat as routine work.
Figure 4: All 252 bug-fix commits classified by seam, using the generic published rules and sorted by frequency. The four seam categories (Flow, Runtime, Market, System) sum to 110 fixes, or 44 percent, none observable by a component-level unit test. “Backend” (ordinary server logic) and “Data” (external sites changing) are where component tests are already strong.
Of the 252 fixes, 107 (42.5 percent) also changed a test file. That is an upper bound on real regression guards, since touching a test is not the same as adding the right one. One defect still shipped twice. A quoting error in a client-side component broke a form step. It was visible only in a running browser. The first fix left behind no test that could catch it again. The guard lived in the same browser-blind harness that had missed the defect, so it could not see the repeat. The 42.5 percent figure counts how often a fix shipped with a test. It does not show whether that test sits where the defect can return.

### Four Defects Up Close
One defect from each seam follows.
In the runtime seam, a feature resolved a pasted listing link. It passed every server-side test but failed in the browser. The search box sent its request dynamically, and the handler replied with an ordinary redirect instead of the header the client library expected. The page did not update.
In the market seam, a user in the second market tried to save a search and got an error. A validator still encoded a rule from the first market and rejected a value that was valid in the second. The branch had a passing unit test. No run had exercised it as a user in the second market.

### WHAT WE CHANGED
We did not respond by writing more unit tests. We changed our definition of done and where we spend test effort. We now treat an untested seam as technical debt to track and pay down. [^2]
i) Real-flow verification is now part of done. A change is finished only after we run the real user action in the real runtime, across its states: a dynamic request and a plain one, zero rows and many, each data source and an unsupported one, the success path and each error path. In practice this is a short scripted pass through the running interface in a browser.
ii) We test along the market axis. Every market-aware screen is now exercised end to end as a user in the non-default market. That configuration is the one our routine development left uncovered.

### FACTORS SPECIFIC TO THIS SETTING
Three properties of this class of system intensify the problem. Output from a language model is hard to unit test. It is not deterministic, and its correctness is fuzzy, a version of the test oracle problem. [^3] Developers compensate with many narrow assertions, [^4] [^5] [^6] even as the model keeps changing. [^7] Internationalization multiplies every flow by a market axis that stays hidden unless someone walks it. Browser-driven front-ends move real logic into a runtime the backend test harness never starts. Each property pushes effort toward isolated tests and away from the seams. This project had all three.

### RELATED WORK
The weak link between test coverage and bug finding is established. Inozemtseva and Holmes showed that coverage is not strongly correlated with test-suite effectiveness. [^1] That fits a suite that is large but blind to these boundaries. A related limit is the test oracle problem: deciding whether a given output is correct. [^3] The seam problem studied here is upstream of the oracle. At a seam the test environment never produces the production condition. The input that would expose the defect is never generated, and the oracle is never consulted. Coverage and oracle quality both presuppose that the triggering condition arises; at a seam it does not. The four seams map where that precondition fails in one modern stack.
A second line of work studies the link between a test and the behavior it protects. Traceability methods recover which test exercises which code, [^8] and regression analysis traces which change introduced a bug. [^9] Curated fault datasets such as Defects4J [^10] and BugsInPy [^11] pair each real bug with a triggering test. Assembling those links by hand is costly. Our recurrence showed the same thing in the field: a fix without a guard at the seam protects nothing. An untested seam is a form of technical debt to track and pay down. [^2]
Internationalization testing has been studied mainly at the presentation layer. Empirical work catalogs internationalization layout and string-resource defects in mobile interfaces [^12] and detects layout and configuration failures in web pages, while explicitly setting aside non-presentation locale defects. [^13] We found no prior work that treats locale-dependent validation or business logic as a defect seam. That is the market-seam class this report documents. The escape mechanism also resembles variability bugs: defects that appear only under certain build configurations, which configuration-oblivious analyses miss. [^14] The market seam is a runtime-locale analogue.

### STUDY LIMITATIONS
This is an experience report on a single application, developed and maintained by its two authors. The incidents are self-reported. We count the defects we found, so silent escapes are not measured. The seam classification is automated from commit-message keywords, with no hand-editing. Classification from commit messages is known to mislabel some commits, [^15] so the result is approximate. A fix is placed in a seam only when its message uses that seam’s vocabulary. Fixes worded differently fall into a general backend group, which holds 39 percent of fixes. The four-seam share is therefore a conservative lower bound. Whether the four seams generalize to other systems that combine model output, internationalization, and a browser runtime remains untested.

### CONCLUSION
Counting passing tests says little about product quality. What matters is which seams between the code and the user have been exercised at all. A large share of defects occur at these seams, where component tests cannot see them. A low-cost check that does see them is a single end-to-end pass through the running product. Run it in the configuration least represented during development, such as a non-default market. The spread of defects across seams shows a team where to put its testing effort.

### REFERENCES
![[Uncaptioned image]]()
Muhammad Bilal is an AI and Digitalization Consultant in the German industrial sector. He holds a Master of Science in Management from the Technical University of Munich, Germany, and has previously worked as a Software Engineer, Business Analyst, and Product Owner. His research interests include the impact of technology on business performance, product quality analytics, the automation of industrial pipelines, large language models, and agentic AI systems. He is the corresponding author.
![[Uncaptioned image]]()


## Key insights
- A single end-to-end pass through the running product, performed as a user in a non-default market, observes seams that component-level tests cannot.
- When the same defect recurs, fix the whole class behind it. Add a build check that fails on any repeat, so the same defect cannot ship again.
- It screens each listing against a user’s criteria with a large language model.
- A second model drafts an outreach message.
- The four seams lie just outside it, where the code meets conditions it does not control, and the orange arrows show defects escaping across that boundary.
- It does not show whether that test sits where the defect can return.
- Output from a language model is hard to unit test.
- [^3] Developers compensate with many narrow assertions, [^4] [^5] [^6] even as the model keeps changing.
- Classification from commit messages is known to mislabel some commits, [^15] so the result is approximate.
- Whether the four seams generalize to other systems that combine model output, internationalization, and a browser runtime remains untested.

## Exemplos e evidências
See original source at `Clippings/All Green, Still Broken Real-Flow Verification Lessons from an LLM-Integrated, Multi-Market Web Application.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Python]]
