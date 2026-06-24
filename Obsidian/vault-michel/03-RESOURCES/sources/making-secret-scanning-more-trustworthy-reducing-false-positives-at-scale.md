---
title: "Making secret scanning more trustworthy: Reducing false positives at scale"
type: source
source: "Clippings/Making secret scanning more trustworthy Reducing false positives at scale.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Making secret scanning more trustworthy: Reducing false positives at scale"
source: "
author:
  - "[[Mariko Wakabayashi]]"
published: 2026-06-11
created: 2026-06-23
description: "Alerts are more trustworthy and actionable when noise is reduced. See how we improved the verification step with context-aware LLM reasoning."
tags:
  - "clippings"
---
Secret scanning plays a critical role in protecting developers and organizations. It helps catch exposed credentials early and prevents smal

## Argumentos principais
### Secret scanning at GitHub today
GitHub secret scanning combines pattern-based detection with AI-based detection to identify potential secrets. Pattern-based detection catches known secret formats, such as partner patterns for tokens and API keys. AI-powered generic secret detection expands coverage to unstructured secrets like passwords that don’t match a known provider pattern.
GitHub already has industry-leading precision for provider-pattern secret detection at massive scale, processing billions of pushes and protecting tens of millions of developers across millions of repositories.
As GitHub expanded into AI-powered secret detection, the next challenge was bringing the precision of AI-detected secrets closer to the same high standard as provider-pattern detections. This collaboration focused on combining GitHub’s large-scale detection pipeline with LLM-based contextual verification to improve alert quality and developer trust.

### Our approach: Make secret scanning alerts trustworthy
Secret scanning is most useful when you can quickly tell which alerts need action.
GitHub already has safeguards to reduce noise, but some secret-like values need more context to determine whether they represent a real exposure. To make those alerts easier to trust, we added more reasoning to the verification step.
By looking at how a detected value appears in code, the system can better separate real exposures from values that only look sensitive. This helps you spend less time investigating low-value alerts and more time fixing the issues that matter.

### Where this fits in the pipeline
This approach builds directly on the existing system. Detection continues to generate candidates, and the verification step evaluates them. More context-awareness makes this system better at distinguishing real secrets from noise.
The result is higher precision without changing upstream detection logic or reducing coverage.

### How it works
A key challenge in verification is deciding what context to provide.
A small snippet of code is often not enough to determine whether something is a real secret. At the same time, passing entire files or repositories introduces too much noise and increases cost and latency.
Instead of giving more context, we’re giving better context.

### Focused context, not more data
It’s natural to assume that improving accuracy requires analyzing more of the codebase. But the opposite is true.
Most false positives can be resolved with focused, file-level context. What matters is not how much code the model sees, but whether it has the right signals.
In many cases, you can determine whether a value is a real secret by looking at how it is used within a single file. Values that resemble placeholders, test data, or unused configuration can often be filtered out without deeper analysis.

### Results: reducing false positives in practice
We evaluated this approach on hundreds of customer-confirmed false positive alerts.
Our target was a 65% reduction. The result was 75.76%, exceeding that goal while maintaining strong detection performance.
In practice, this means significantly less noise and a higher proportion of alerts that require action.

### What’s next
We’re continuing to evaluate this approach on larger datasets and live traffic, while improving how context is extracted and used for verification.
Reducing false positives has been a consistent need at scale. This work focuses on improving signal quality where it matters most, making alerts easier to trust and act on.


## Key insights
- "[[Mariko Wakabayashi]]"
- See how we improved the verification step with context-aware LLM reasoning."
tags:
  - "clippings"
---
Secret scanning plays a critical role in protecting developers and organizations.
- This collaboration focused on combining GitHub’s large-scale detection pipeline with LLM-based contextual verification to improve alert quality and developer trust.
- Flow chart showing GitHub's existing verification step is enhanced with context-aware reasoning to improve precision changing detection.
- The flow is AI based detection > Candidate Secrets > Verification LLM reasoning > High-confidence alerts.
- The result is higher precision without changing upstream detection logic or reducing coverage.
- The surrounding usage context helps the model distinguish real exposures from false alarms, such as random UUIDs or opaque strings, without reviewing the full file or repository.
- What matters is not how much code the model sees, but whether it has the right signals.
- The result was 75.76%, exceeding that goal while maintaining strong detection performance.

## Exemplos e evidências
See original source at `Clippings/Making secret scanning more trustworthy Reducing false positives at scale.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Microsoft]]
- [[03-RESOURCES/entities/Rust]]
