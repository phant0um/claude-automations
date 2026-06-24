---
title: "I Tested Agentic Loops on Real Code — One Use Case Works"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://x.com/DamiDefi/status/2069318077095817257"
author: "@DamiDefi"
published: 2026-06-23
grade: B
tags: [ai-agents, agent-loop, code-review, production, source]
---

# I Tested Agentic Loops on Real Code

**Tese central**: Agentic loops sem feedback binário automático são slot machines — gastam dinheiro enquanto o agent gruda seu próprio homework. Loops funcionam apenas quando algo pode automaticamente reject bad output sem judgment humano.

## O custo real

- Medium coding task: ~30k input tokens/iteration, $0.09/iteration (Sonnet 4.6)
- Context cresce: iteration 5 → 80k tokens
- 10 tasks/session = $10-20 antes do amanhecer
- $20 subscription = mês inteiro. $100 = uma semana.

## Por que loops falham para building apps

- Spec document nunca captura assumptions que vivem na sua cabeça
- Agent faz assumptions erradas mais rápido e em scale, on your API bill
- /goal, /loop = mesmo mecanismo. Se não está em plan $200/mês, não pense neles.

## O único caso que funciona — Code review loop

Greptile review → score 1-5 → regra: nada em prod sem 4+
1. Cursor lê Greptile review no GitHub
2. Cursor faz changes
3. Push
4. Greptile roda novo review
5. Loop até score ≥4 ou 5 tentativas

**Funciona porque feedback é binário**: score ≥4 ou não. Sem judgment call.

## Quando loops fazem sentido (4 critérios)

1. Task repete pelo menos semanalmente
2. Algo pode automaticamente reject bad output sem seu judgment
3. Agent faz o trabalho end-to-end
4. Done é objetivo, não questão de gosto

## Onde mais funciona

- **Experimentation low-stakes**: rough shape, não liga para details
- **Scale tasks with binary outputs**: 300 SEO pages, template check script

## CLAUDE.md em loops

"Em loop sem human, CLAUDE.md é o único contexto sobre quem você é, seus standards, o que não fazer. Loop sem CLAUDE.md roda em default assumptions do training."

## Por que importa para o vault

- **Pipeline-semanal é um loop**: tem feedback binário (PIPELINE OK/FAIL) mas o veredito vem do report-agent (mesmo modelo). Conecta com [[03-RESOURCES/sources/ai-agents/missing-piece-every-agent-loop]] — mesmo problema.
- **4 critérios aplicados ao pipeline**: repete semanalmente ✅, reject automático ⚠️ (manifest check é bash, mas veredito é AI), agent end-to-end ✅, done é objetivo ✅
- **CLAUDE.md em loops**: o pipeline-semanal lê CLAUDE.md e AGENTS.md — confirmado como essential
- **Greptile pattern**: equivalente vault seria um check estrutural bash-only (file count, manifest diff, wikilink resolution) como gate

## Links

- [[03-RESOURCES/sources/ai-agents/missing-piece-every-agent-loop]]
- [[03-RESOURCES/sources/ai-agents/how-to-build-claude-agent-trust-production-full-course]]
- [[03-RESOURCES/concepts/ai-agents/agent-loop-pattern]]
- [[03-RESOURCES/concepts/ai-agents/beautiful-nonsense]]