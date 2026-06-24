---
title: "Agentic Coding and Persistent Returns to Expertise (Anthropic)"
type: source
source: Clippings/Agentic coding and persistent returns to expertise.md
created: 2026-06-17
ingested: 2026-06-21
tags: [ai-agents, claude-code, expertise, labor-market, source, score-A]
---

## Tese central

Análise de ~400K sessões Claude Code (Out 2025–Abr 2026): domain expertise (não coding proficiency) amplifica uso efetivo. Pessoas fazem ~70% das planning decisions, Claude faz ~80% das execution decisions. Success depende de quão bem a pessoa entende o problema, não se é treinada em coding. Share of debugging caiu quase pela metade em 7 meses; value per task subiu ~25%.

## Argumentos principais

- **Division of labor**: pessoas decidem what to build (70% planning), Claude decide how to build (80% execution). Em sessões onde Claude toma planning control, faz ~16 actions por turno vs ~8 quando user mantém execution control.
- **Domain expertise > coding proficiency**: experts succeed more often, recover from errors easier. Gap entre intermediate e expert é modest — domain understanding é suficiente.
- **Work modes**: 56% sessions = writing (25%) + fixing (26%) + testing/orchestrating (5%). 17% operating, 14% planning/exploring, 13% analysis/prose.
- **7-month trend**: debugging share caiu ~50%, shift para end-to-end agentic use (deploying, data analysis, non-code docs)
- **Task value**: rose ~25% em quase todo tipo de trabalho — agentes absorvem implementation-heavy work mas rewarding domain understanding

## Key insights

- "Coding agents are not substituting for domain expertise — the more understanding a worker brings, the more quality work the agent can do"
- ~4 turns per session, ~10 actions per turn (às vezes 100+), 2400 words output average
- Domain experts em non-coding occupations succeed at nearly same rate as software engineers
- O que acontece no Claude Code é preview de where knowledge work is headed

## Exemplos e evidências

- ~400K sessions, ~235K people, Oct 2025–Apr 2026
- Privacy-preserving analysis via Clio
- Decision attribution classifier: planning vs execution, attributed to user or Claude
- Comparison to freelance job postings for task value estimation

## Implicações para o vault

- "Domain expertise amplifies agent output" valida a abordagem do vault — quanto mais contexto o agente tem (hot.md, AGENTS.md, conventions), melhor executa
- Planning vs execution split conecta com [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]] — humanos fazem planning, agentes fazem execution
- 7-month shift para end-to-end agentic use é tendência que o vault já segue (cron jobs autônomos)
- Para [[03-RESOURCES/concepts/ai-strategy-org/talent-density-as-strategy]]: expertise de domínio > skill técnico

## Minha Síntese

**O que muda:** A confirmação empírica de que domain expertise > coding proficiency para agent success muda como penso sobre prep para agentic coding. Não preciso ser melhor coder — preciso ser melhor at framing problems e understanding domain.

**Conexão pessoal:** O vault-michel é um exercise em domain expertise amplification — o sistema layer (AGENTS.md, conventions, hot.md) é exatamente o "domain understanding" que faz o agente produzir quality work. O pipeline-semanal é o "planning" e o agente é o "execution".

**Próximo passo:** O dado de que debugging caiu 50% em 7 meses sugere que agents estão melhorando rápido. Monitorar se o pipeline-semanal também mostra tendência de menos correções ao longo do tempo.

## Links

- [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]]
- [[03-RESOURCES/concepts/ai-strategy-org/talent-density-as-strategy]]
- [[03-RESOURCES/concepts/agent-systems/agentic-sdlc]]
- [[03-RESOURCES/entities/Claude]]