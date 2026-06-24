---
title: "Researchers Just Counted 146,932 Hallucinated Citations. This Repo Is the First Installable Fix"
type: source
source_url: "https://x.com/AlphaSignalAI/status/2054617475484938719"
author: "@AlphaSignalAI"
published: 2026-03-10
ingested: 2026-05-14
tags: [academic-research, citation-hallucination, claude-code-skills, pipeline-integrity, agent-pipeline]
triagem_score: 7
---

# Academic Research Skills — 146,932 Hallucinated Citations

AlphaSignal deep-dive on **Imbad0202/academic-research-skills**, the first installable Claude Code workflow that embeds citation-hallucination fixes directly into the paper pipeline.

## Problem Context

**Zhao et al.** (arXiv:2605.07723, 2026-05) audited 111 million references across 2.5 million papers on arXiv, bioRxiv, SSRN, and PMC. Finding: **146,932 hallucinated citations in 2025 alone**. 85.3% of preprint hallucinations survive into the published record.

## The Repo

- **Author**: Cheng-I Wu (GitHub: Imbad0202), created 2026-02-26
- **Stars**: 6,700+
- **License**: CC BY-NC 4.0 (source-available, not OSI open source)
- **Latest tagged release**: v3.7.0 (shipped 2026-05-05)
- **Intellectual ancestry**: PaperOrchestra (Song, Song, Pfister, Yoon, 2026, Google, arXiv:2604.05018); failure-mode taxonomy from Lu et al. (2026, Nature 651:914-919, "The AI Scientist")

## Technical Architecture

### Four Skills

| Skill | Agents | Modes | Data Access |
|-------|--------|-------|-------------|
| deep-research | 13 | 7 | raw |
| academic-paper | 12 | 10 | redacted |
| academic-paper-reviewer | 7 | 6 | verified_only |
| academic-pipeline | 4 | — | orchestrator |

**Total**: 36 agents, 25 modes (note: plugin.json claims "35+ modes, 32-agent ensemble" — inconsistency with MODE_REGISTRY.md which says 25 modes and direct file count of 36 agents).

### 10-Stage Pipeline (academic-pipeline)

1. Research (deep-research)
2. Write (academic-paper)
3. **Stage 2.5** — Integrity Gate (BLOCKS on failure)
4. Peer Review (academic-paper-reviewer)
5. Revision
6. Re-review (max 2 loops)
7. **Stage 4.5** — Final Integrity Gate (BLOCKS on failure)
8. Format conversion
9. Final output
10. Process summary + AI Self-Reflection Report

### Pipeline Integrity Gates

Stages 2.5 and 4.5 run a **7-mode failure-mode checklist** grounded in Lu et al.'s enumerated failures:
- Implementation bugs
- Hallucinated results
- Shortcut reliance
- Bug-as-insight reframing
- Methodology fabrication
- Frame-lock
- Citation hallucinations

**Critical difference from verifier loops**: these gates **block pipeline progression** on suspected failures. They do not silently flag and continue. See: [[03-RESOURCES/concepts/pkm-obsidian/academic-pipeline-integrity-gates]]

### Material Passport

Handoff schema carrying `literature_corpus[]` between skills as CSL-JSON (authors, year, title, source pointers back to user's knowledge base). Since v3.6.5: corpus-first flow — pre-screen user's corpus, then fill gaps from external databases only. Enables session resumption via `resume_from_passport=<hash>`.

### Three-Layer Citation Emission (v3.7.3, unreleased on main)

Direct response to the Zhao et al. audit. Every visible citation gets a hidden anchor after the `<!--ref:slug-->` tag:

```
<!--anchor:<kind>:<value>-->
```

Where `<kind>` is `quote`, `page`, `section`, `paragraph`, or `none`. Quote anchors capped at 25 words. Emitting `none` triggers a finalizer hard-gate refusal.

### Contamination Signals (v3.7.3)

Advisory annotations (not blocking):
- `preprint_post_llm_inflection` — fires when `year >= 2024` AND venue is in a closed list of 10 preprint servers (arXiv, bioRxiv, medRxiv, SSRN, Research Square, Preprints.org, ChemRxiv, EarthArXiv, OSF Preprints, TechRxiv)
- `semantic_scholar_unmatched` — fires when Semantic Scholar API returns no match

## Installation

Plugin install (v3.7.0+):
```bash
/plugin marketplace add Imbad0202/academic-research-skills
/plugin install academic-research-skills
```

Traditional install (git clone + symlinks) still works for older Claude Code versions.

**Minimum runtime**: Claude Code + `ANTHROPIC_API_KEY`  
**Optional**: `pandoc` + `tectonic` for DOCX and APA 7.0 PDF output

**Codex sibling**: Imbad0202/academic-research-skills-codex

## Cost

From docs/PERFORMANCE.md:
- ~$4–$6 for a 15,000-word paper with 60 references on Opus 4.7
- Cross-model verification (`ARS_CROSS_MODEL`) adds $0.60–$1.10
- Full run: >200K input + >100K output tokens

## Honest Limitations

- Maintainer's own post-publication audit found 21 issues across 68 references survived three rounds of automated integrity checks (documents the failure honestly)
- CC BY-NC 4.0 blocks commercial use
- Claude Code lock-in (Codex sibling exists; Cursor/OpenCode/Gemini not addressed)
- v3.7.3 closes only the locator-channel half of claim faithfulness gap; full L3 audit deferred to v3.8
- Tagged v3.7.0 vs unreleased main drift

## AlphaSignal Verdict

**Worth Watching** (not yet Production Ready). The workflow design is more valuable than the workflow runtime until: permissive license, v3.8 L3 full claim-faithfulness audit, non-Claude Code reference distribution.

## Who Benefits

**Yes**: PhD students, academic researchers on Claude Code (noncommercial), agent-tooling builders studying integrity gate wiring, journals evaluating AI-disclosure schemas.

**No**: Commercial SaaS/consulting (CC BY-NC blocks), Cursor/OpenCode-only stacks, anyone needing byte-reproducible citation guarantees.

## Por que as integrity gates bloqueiam em vez de sinalizar

A distinção BLOCK vs. flag é a decisão de design mais importante do pipeline. Verifier loops que sinalizam e continuam criam um problema de responsabilidade difusa: o output final contém flags que o usuário pode ignorar, o sistema pode não parar, e a cadeia de responsabilidade pelo erro fica ambígua.

Gates que bloqueiam forçam resolução antes de progressão. O custo é tempo (o pipeline para); o benefício é que nenhum output com falhas conhecidas pode chegar ao fim do pipeline sem intervenção ativa.

No contexto de citações acadêmicas, a assimetria de consequências justifica o BLOCK. Uma citação alucinada em um paper publicado pode:
- Ser citada por outros papers, propagando o erro (o paper de Zhao et al. documenta que 85.3% de alucinações de preprints sobrevivem para publicação)
- Ser usada como evidência em decisões clínicas, de políticas públicas, ou legais
- Destruir a credibilidade do autor se descoberta em peer review ou pós-publicação

O overhead de uma parada de pipeline é trivial comparado a esses riscos.

## Material Passport como primitivo de context engineering

O Material Passport — o schema CSL-JSON que viaja entre skills carregando `literature_corpus[]` — é um exemplo de context engineering aplicado a pipelines multi-etapa. O problema que resolve:

Em pipelines ingênuos, cada skill começa do zero. A skill de escrita não sabe quais fontes o pesquisador consultou; o revisor não sabe quais fontes o escritor usou; o formatador não sabe quais citações foram verificadas. Cada skill depende de re-instrução ou de examinar o output anterior para inferir contexto.

O Material Passport resolve isso com um schema de handoff estruturado. Cada citação no corpus tem: autores, ano, título, venue, e **source pointer** (referência de volta à base de conhecimento do usuário — não uma URL externa que pode mudar). Isso permite:

1. A skill de pesquisa construir o corpus
2. A skill de escrita consumir o corpus como vocabulário controlado de citações permitidas
3. O gate de integridade verificar cada citação visível contra o corpus (não contra a internet)
4. A skill de revisão trabalhar com o mesmo corpus auditado

O `resume_from_passport=<hash>` permite retomada de sessão — se o pipeline falha na Stage 6, pode retomar do ponto de checkpoint sem reprocessar as 5 etapas anteriores.

## Análise de custo: $4-6 por paper

Para contextualizar os $4-6 por paper de 15.000 palavras com 60 referências no Opus 4.7:

- **Input:** >200K tokens — principalmente logs, o paper em construção, e o corpus de referências sendo verificado múltiplas vezes
- **Output:** >100K tokens — draft do paper, revisões, relatório de integridade, output de cada gate
- **Custo por token Opus 4.7:** ~$15/MTok input, ~$75/MTok output (estimativa 2026)
- **Cálculo aproximado:** (200K × $0.015) + (100K × $0.075) = $3 + $7.50 = ~$10.50 (valor real variará conforme pricing e volume)

O custo documentado de $4-6 sugere otimizações significativas: prompt caching reduz custo de tokens de sistema repetidos, Flash para etapas de menor complexidade (formatação, conversão), e estratégias de batching.

Para pesquisadores não-comerciais, $4-6 por paper (potencialmente publicável em journals que cobram $2.000+ de APCs) é orçamento trivial.

## Implicações além do contexto acadêmico

O padrão de integrity gates com BLOCK em pipelines LLM tem aplicação em qualquer domínio com alta assimetria de custo de erro:

- **Relatórios financeiros:** gate que bloqueia se números não reconciliam com fontes primárias
- **Documentos legais:** gate que bloqueia se referências a estatutos não resolvem para texto atual
- **Conteúdo médico:** gate que bloqueia se claims clínicos não têm citação verificável de trial ou guideline
- **Pipelines de código:** gate que bloqueia se código gerado não passa em testes de segurança estática

O padrão generaliza: identificar os failure modes específicos do domínio (como Lu et al. fez para AI Science), codificá-los como checklist verificável, e implementar como gate de bloqueio antes de stages críticos.

## Related Pages

- [[03-RESOURCES/concepts/pkm-obsidian/academic-pipeline-integrity-gates]] — deep-dive on the gate architecture
- [[03-RESOURCES/concepts/llm-ml-foundations/generator-verifier-loop]] — gates vs verifier loops: structural difference (BLOCK vs flag)
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — Material Passport is a context-engineering primitive
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — ARS as an advanced 4-skill suite
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — 8-step structured prompt as a replicable pattern
