---
title: "Autobrowse: The Mythos Moment for Browser Agents is Here"
type: source
source_file: "clippings/Autobrowse The Mythos moment for Browser Agents is here.md"
source_url: "https://x.com/kylejeong/status/2052103973377867913"
author: "@kylejeong (Kyle Jeong, Browserbase)"
ingested: 2026-05-09
tags: [browser-agents, autobrowse, web-automation, agentic, mythos-moment, browserbase, skill-graduation]
triagem_score: 8
---

# Autobrowse: The Mythos Moment for Browser Agents is Here

**Thesis:** Browser agents suffer from an amnesia problem — they re-discover every site from scratch on every run, paying the full "discovery tax" indefinitely. [[03-RESOURCES/entities/Autobrowse]] fixes this by running an agent iteratively until it converges on a reliable approach, then graduating that approach into a durable, reusable **skill** (a markdown file + deterministic helpers). That skill is persistent memory any future agent, teammate, or customer can pick up and execute without re-learning.

Author: Kyle Jeong (@kylejeong) with credit to @_shubhankar (creator of Autobrowse internally at [[03-RESOURCES/entities/Browserbase]]).
Published: 2026-04-22.

---

## 1. The Amnesia Problem

Real production browser agents re-discover every site from scratch every run. The cost graph is a straight line going up. The reasoning that solved Monday's problem evaporates with the session.

> "The real bottleneck for browser agents in production is memory, in a form humans and agents can both read and trust. Reasoning has stopped being the constraint."

---

## 2. What Autobrowse Is

A workflow where AI improves AI. The agent:
1. Runs a real task end-to-end on a real site.
2. Studies its own trace (where did it stall, guess, over-spend tokens?).
3. Maintains a `strategy.md` scratchpad of observations after each iteration — improvements compound instead of resetting.
4. Iterates until consecutive runs stop yielding meaningful cost/turn improvements.
5. **Graduates** the winning approach into a `SKILL.md` + helper files in the public skills repo.

Capped at ~3-5 iterations; short-circuits aggressively. Inspired by [[03-RESOURCES/entities/Andrej Karpathy]]'s autoresearch harness but optimized for browser skill acquisition.

---

## 3. The Artifact — SKILL.md

The output is a small, readable markdown file: no transcript, no embeddings, no screenshot reel. Just structured markdown with frontmatter (name, website, category, recommended method, gotchas) plus deterministic helpers (CLI calls, fetches, selectors, Python scripts).

The hand-written skills inside `browse` and Autobrowse-graduated skills are the same artifact format — the agent loading/running them doesn't care if a human or another agent wrote them.

---

## 4. Concrete Benchmark: Craigslist

| Approach | Cost | Time |
|----------|------|------|
| Traditional Claude Code loop | ~$0.22 | ~71s |
| Graduated Autobrowse skill | ~$0.12 | ~27s |

Early form-fill experiment: cost dropped from $1.40/run to $0.24/run in four iterations. The skill encodes the shortest reliable path, changing unit economics of every subsequent run.

---

## 5. Where Autobrowse Breaks

Not the right tool for **deterministic parsing** of static HTML. Tested on a 167-row static HTML catalog: four iterations + ~$24 later, still failing — the model's per-turn output cap kept truncating reasoning. The correct solution was ~200 lines of deterministic Python + BeautifulSoup. Sub-second, zero inference cost.

The discipline of **not** using Autobrowse is part of using it well. Autobrowse sits at the high-agency end of the spectrum; reach for it only once cheaper, deterministic options have given up.

---

## 6. Why This Changes Workflows

A graduated skill is **legible** — human-auditable, debuggable, ownable, committable. Non-engineers (PM, grants manager) can read it and understand what the agent is doing without touching code. This moves browser agents from "trust the agent's output" to "read the agent's playbook" — the thing that makes them robust enough to live *inside* serious enterprise workflows rather than awkwardly next to them.

A growing public directory of skills = a factory for browser-agent capabilities. Each new site yields one more durable skill; the discovery tax compounds into an asset.

---

## 7. What's Next

- **Smarter stopping:** agent reasons about its own convergence by comparing trace structure, not just cost/turn count.
- **Better priors:** reach for `fetch`/`search` primitives before spawning a full browser session; inspect CDP logs to discover internal APIs via network traffic.
- **Recursive Autobrowse:** Autobrowse improving its own harness — better prompts, better convergence heuristics, better skill templates.

---

## O conceito de "discovery tax" como lens analítica

A metáfora do "discovery tax" é mais útil do que parece. Toda vez que um agente acessa um site pela primeira vez, ele paga esse tax: explorar a estrutura de navegação, descobrir onde está o campo de busca, entender como o checkout funciona, aprender os gotchas específicos (captchas, modais inesperados, timeouts). Em sessões únicas, esse tax é justificável. Em workflows onde o mesmo site é acessado diariamente, o tax se acumula indefinidamente — e é completamente evitável.

A skill graduada elimina o tax das sessões futuras ao encodar o caminho já descoberto. O custo de Craigslist caindo de $0.22 para $0.12 e o tempo de 71s para 27s não é apenas uma otimização — é a diferença entre um workflow economicamente viável e um que custa mais do que o valor que entrega.

## Autobrowse vs abordagem acadêmica (WebXSkill)

O WebXSkill (paper da Microsoft/UNC) e o Autobrowse resolvem o mesmo problema — skill learning para web agents — mas com abordagens opostas. WebXSkill parte de corpus de trajetórias sintéticas e extrai skills em batch; Autobrowse aprende incrementalmente por experiência real com um site específico.

As vantagens de cada abordagem refletem o contexto:
- **WebXSkill** cobre muitos sites de uma vez, com validação sistemática, mas as skills são genéricas e podem não refletir as idiossincrasias da instância específica do site que o agente vai encontrar.
- **Autobrowse** produz skills ultra-específicas para o ambiente real de produção (incluindo versão exata do site, layout atual, gotchas observados), mas requer execuções reais com custo real para convergir.

Para um vault-michel com workflows de pesquisa recorrentes em sites específicos, a abordagem Autobrowse é mais acionável: executar o workflow algumas vezes com observação, graduar em SKILL.md, reutilizar.

## O critério de parada como problema de pesquisa aberto

O artigo menciona que o critério de parada atual é baseado em custo/turn — o agente para quando runs consecutivos não melhoram o custo. Mas isso não captura convergência de qualidade: um agente pode estabilizar em um caminho subótimo que tem custo consistente mas não encontra a solução mais robusta.

A proposta de "smarter stopping" — comparar estrutura de trace, não apenas custo — é uma direção mais promissora. Se o agente descobre o mesmo caminho em runs consecutivos (mesmo sequência de ações, não apenas mesmo custo), isso é evidência mais forte de convergência real.

## Conexoes

- [[03-RESOURCES/entities/Autobrowse]] — produto descrito
- [[03-RESOURCES/entities/Browserbase]] — empresa criadora
- [[03-RESOURCES/entities/Kyle-Jeong]] — autor
- [[03-RESOURCES/concepts/agent-systems/browser-agent-amnesia]] — problema central documentado aqui
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] — mecanismo de saida do Autobrowse
- [[03-RESOURCES/concepts/agent-systems/web-agent-skill-learning]] — campo academico relacionado
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — skills como artefato reutilizavel
- [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]] — inspiracao (Karpathy harness)
- [[03-RESOURCES/entities/Andrej Karpathy]] — autoresearch harness inspirador
