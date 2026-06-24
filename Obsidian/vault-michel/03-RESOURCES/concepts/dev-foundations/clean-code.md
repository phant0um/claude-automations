---
title: "Clean Code"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# Clean Code

Code that a stranger can understand, change, and trust — without asking the author.

## O que é / What it is

Clean Code (Robert C. Martin, 2008) is the canonical collection of low-level software craft principles. The core claim: code is read 10× more than it is written, so optimizing for readability is economically correct. The book targets Java but the principles are language-agnostic.

## Como funciona

**Core principles:**

**Meaningful names**
- Variables, functions, and classes say *what* they represent, not *how* they work
- `calculateMonthlyInterest()` > `calc()` > `doIt()`
- Avoid single-letter names except loop indices; avoid abbreviations unless universal (`URL`, `id`)

**Small functions, single responsibility**
- A function should do one thing, do it well, do it only
- If you need to write a comment to explain what a block does → extract it into a named function
- Java guideline: ≤20 lines per method; ≤1 level of abstraction per function

**DRY — Don't Repeat Yourself**
- Every piece of knowledge has a single, authoritative representation in the system
- Duplication means two places to change when the rule changes; one will be forgotten

**YAGNI — You Aren't Gonna Need It**
- Don't write code for hypothetical future requirements
- The cost of unused code is real: it must be read, understood, tested, and maintained

**Comments: WHY only**
- Good code is self-documenting: *what* and *how* are in the names and structure
- Comments explain *why* — business rules, non-obvious constraints, decisions made
- Outdated comments are worse than no comments (they lie)

**Java example — before/after:**
```java
// BAD
public double calc(double x, int n) {
    double r = 0;
    for(int i = 0; i < n; i++) r += x * 0.005;
    return r;
}

// GOOD
public double calculateTotalInterest(double principal, int months) {
    double monthlyRate = 0.005;
    double totalInterest = 0;
    for (int month = 0; month < months; month++) {
        totalInterest += principal * monthlyRate;
    }
    return totalInterest;
}
```

## Por que importa

Relevant for FIAP projects (Java, MVC, Fintech) and concurso questions on software quality. Clean code reduces bug density, speeds onboarding, and makes refactoring safe. The principles are also the foundation of good LLM-generated code review — when reviewing AI output, apply the same clean code checklist.

## Evidências
- **[2026-06-19]** Contraponto explícito (com discordância registrada na própria thread): pode valer manter 50% mais código por 5% de ganho de performance, porque abstrações corretas importam menos quando refatorações grandes ficam menos tediosas com agentes, e um modelo mais inteligente provavelmente manterá o código no futuro — [[03-RESOURCES/sources/fable-class-models-as-code-interpreters]]

## Related
- [[03-RESOURCES/concepts/dev-foundations/first-principles-design]]
- [[03-RESOURCES/concepts/dev-foundations/system-design]]
- [[03-RESOURCES/concepts/development/legacy-systems]]
- [[03-RESOURCES/concepts/dev-foundations/_index]]
