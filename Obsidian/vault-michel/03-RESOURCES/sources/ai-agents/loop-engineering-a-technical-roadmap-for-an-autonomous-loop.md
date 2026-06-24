---
title: "Loop Engineering — A Technical Roadmap for an Autonomous Loop"
type: source
source: Clippings/Loop Engineering A Technical Roadmap for an Autonomous Loop.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, loop-engineering, autonomous-loops, reliability]
---

## Tese central

A skill que define o teto de um sistema agentic não é escrever prompts, é construir loops que convergem para verdade em vez de random walks caros. Um loop não é um prompt — um prompt você gira, um loop se gira. O roadmap é estrito: pular um passo é onde o loop explode depois.

## Argumentos principais

1. **Step 0 — Task permite machine check**: loop só faz sentido se existe check que entrega verdict independente do agent. O modelo que gerou a solução e também a avalia está em conflito de interesse — seu próprio output é alta probabilidade de continuação, então superavalia corretude. Check deve ser oracle determinístico externo: test, type-check, linter, build.
2. **Idempotência é obrigatória**: flaky test (green then red no mesmo código) é pior que nenhum test — quebra o stop condition. Rodar check 10x em um state; se resultado não é estável, fixar check antes do loop.
3. **Step 1 — Uma run manual confiável com medição**: não automatizar o que não funciona à mão. Medir: quantas model calls, tokens, tipo de erro mais frequente. Isto é baseline — quando loop queimar 3x mais, saber que algo quebrou.
4. **Step 2 — Loop minimal stateless**: while loop feedando agent até check green. Stateless porque estado acumulado entre iterações causa drift — cada iteração deve poder rodar do zero.
5. **Defesa contra reward hacking**: o loop vai encontrar atalhos que passam no check sem resolver o problema. Check deve ser robusto a isto.
6. **Observabilidade**: sem logs estruturados, loop é black box. Cada iteração loga: input, output, check result, tokens, tempo.
7. **Isolamento**: loop roda em ambiente isolado (container/sandbox) para que mudanças não contaminem estado global.

## Key insights

- Self-assessment do modelo não é check, é eco — consequência direta de amostrar de distribuição onde própria resposta já tem probabilidade elevada
- Flaky test é pior que no test: loop vai "fixar" o que não está quebrado ou parar no que está
- Stateless > stateful: estado entre iterações é fonte de drift invisível
- Medição antes de automação: sem baseline, impossível detectar degradação
- Loop converge para verdade só se o check é determinístico e idempotente — caso contrário é random walk
- Ordem dos steps é estrita: pular Step 0 (check filter) é onde loops explodem

## Exemplos e evidências

- Loop minimal: `while [ $i -lt $MAX_ITER ]; do if npm test --silent; then exit 0; fi; claude -p ...; done`
- Conflito de interesse estatístico: modelo superavalia próprio output porque é high-probability continuation
- Defense contra reward hacking: check robusto a atalhos

## Implicações para o vault

- **Core obsession**: loop engineering é central para o vault — pipeline-semanal é um loop, Hermes dreaming é loop, hill-climbing é loop
- **Valida**: pipeline-semanal tem checks determinísticos (file created, wikilinks valid, manifest updated) que funcionam como oracle
- **Gap**: pipeline-semanal não é stateless entre runs — acumula estado em hot.md, manifest, triagem. Stateful é intencional aqui (acumulativo), mas a observabilidade precisa melhorar
- **Complementa**: [[03-RESOURCES/concepts/agent-systems]]

## Minha Síntese

**O que muda:** O insight de que self-assessment é eco (não check) valida por que F2.8 Nexus spot-check e F3.5 final review existem — mas também mostra que eles são segunda camada, não oracle determinístico. O check real do pipeline é: file created? wikilinks resolvem? manifest atualizado?

**Conexão pessoal:** Hermes Dreaming (self-improvement plugin) é exatamente um loop que precisa de oracle externo — as mutações precisam de check determinístico, não auto-avaliação.

**Próximo passo:** Documentar qual é o "check determinístico idempotente" de cada loop do vault (pipeline-semanal, hill-climbing, dreaming). Se algum não tem, isto é dívida técnica.

## Links

- [[03-RESOURCES/concepts/agent-systems]]
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
- [[04-SYSTEM/agents/core/hill]]
- [[07-QUEUE/rotinas/pipeline-semanal]]