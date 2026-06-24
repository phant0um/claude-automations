---
title: "The NASA ABORT Method — How to Make Claude Kill Your Bad Ideas Before You Launch Them"
type: source
source: Clippings/The NASA ABORT Method How to Make Claude Kill Your Bad Ideas Before You Launch Them.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, claude, adversarial-thinking, decision-making, premortem]
---

## Tese central

NASA não deixa foguete sair da plataforma com otimismo — roda Failure Review Board + Go/No-Go poll antes de todo lançamento. O mesmo método (premortem de Gary Klein, 2007) pode ser executado dentro de Claude com 4 prompts. A chave é shift gramatical: não "o que poderia dar errado" mas "o que deu errado" — passado, já aconteceu.

## Argumentos principais

1. **ABORT = Failure Review Board + Go/No-Go poll**: toda estação dá resposta binária, em voz alta, no registro. Sem hedging, sem "deve estar fine".
2. **Premortem (Gary Klein, 2007)**: diga à equipe que o projeto já falhou, 1 ano no futuro, peça que expliquem por quê. Shift de "pode dar errado" → "deu errado" é o truque inteiro.
3. **Evidência empírica**: estudo de 1989 (Wharton, U. Colorado, Cornell) mostra que imaginar evento futuro como já ocorrido aumenta identificação correta de causas reais em ~30% vs. risk assessment padrão. Klein confirmou em 2010. Achado mais replicado em decision science.
4. **"What's wrong with this?" sempre falha**: Claude dá hedge — "could go either way", "just make sure you". Não é análise, é otimismo educado.
5. **4 prompts copy-paste**: sequência de forcing functions que executam o premortem dentro de Claude.

## Key insights

- Shift gramatical (futuro hipotético → passado confirmado) é o mecanismo cognitivo que ativa identificação de falhas reais
- 30% melhoria em identificação de causas reais — não é intuição, é achado replicado
- Hedging do Claude não é bug, é feature de RLHF — modelos são treinados para não ofender
- Go/No-Go poll: binário, em voz alta, no registro — sem "should be fine"
- 4 prompts são forcing functions, não software — pode rodar em qualquer LLM

## Exemplos e evidências

- Gary Klein, Harvard Business Review, 2007 — premortem method
- Wharton/U.Colorado/Cornell 1989: +30% accuracy em causal identification
- Klein 2010: replicação confirmada
- NASA: Failure Review Board + Go/No-Go poll antes de todo lançamento

## Implicações para o vault

- **Core obsession**: adversarial thinking é central — o vault tem `guard` (Opus, OWASP) e `desafiante` (Opus, adversarial checker). ABORT method é complementar: não técnica, mas processo.
- **Complementa**: [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]] — "think before acting" é princípio 1, ABORT é método concreto
- **Aplicável**: spec-driven development (`spec` agent) deveria incluir ABORT pass antes de aprovar spec

## Minha Síntese

**O que muda:** O vault tem agentes adversariais (guard, desafiante) mas não tem processo estruturado de premortem. ABORT é o processo que faltava — 4 prompts que transformam "should be fine" em "aqui é onde morre".

**Conexão pessoal:** Todo spec novo (`@spec [feature]`) deveria rodar ABORT antes de ir para implementation. Hoje vai direto de PRD → tasks sem premortem.

**Próximo passo:** Criar skill `premortem-abort` em `04-SYSTEM/skills/` com os 4 prompts estruturados. Integrar como passo opcional no `spec` agent.

## Links

- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
- [[03-RESOURCES/entities/Claude]]
- [[04-SYSTEM/agents/core/guard]]
- [[04-SYSTEM/agents/core/spec]]
- [[04-SYSTEM/agents/finance-system/desafiante]]