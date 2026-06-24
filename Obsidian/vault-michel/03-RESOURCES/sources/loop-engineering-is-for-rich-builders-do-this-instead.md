---
title: "Loop engineering is for rich builders. Do this instead."
type: source
source: "Clippings/Loop engineering is for rich builders. Do this instead..md"
created: 2026-06-18
ingested: 2026-06-21
tags: [articles, loop-engineering]
---

## Tese central
Contraponto direto ao hype de "loop engineering": Peter Steinberger (que populariza a frase "você deveria desenhar loops, não prompts") gastou $1.3M em tokens OpenAI em 30 dias rodando ~100 agentes — porque a OpenAI paga a conta dele. Para quem não tem tokens ilimitados, um loop sem controle de custo é uma máquina de queimar dinheiro; o artigo propõe 5 "plays" mais baratos que capturam a maior parte do ganho de um loop sem o risco de gasto descontrolado.

## Argumentos principais
- Tokens de entrada (não o código produzido) dirigem o custo — o agente reenviza todo o contexto + todo resultado de ferramenta de cada turno anterior; no turno 10 você já paga para processar 10 cópias do contexto inicial mais todo ruído acumulado.
- Loop sem condição de parada não tem teto de gasto: o dashboard mostra "retries saudáveis" enquanto a fatura mostra outra coisa — um run de 50 iterações num codebase real pode passar de $50-100 só naquela tarefa.
- **Play 1 — gastar o raciocínio antes dos tokens**: escrever a spec primeiro (fluxo de auth, expiração de token, estados de erro, definição de pronto) elimina as 30 rodadas de "adivinha e corrige" que custam mais que 1 hora de spec.
- **Play 2 — planejar barato, executar caro**: usar modelo pequeno (Haiku $1/$5 por milhão tokens) para leitura/planejamento/sumarização, reservando modelo caro (Opus $5/$25) só para a parte genuinamente difícil — evita pagar 5x markup em trabalho que não precisa de modelo frontier.
- **Play 3 — caching**: cache_control reduz releitura de contexto estável a 10% do preço padrão; exemplo citado: prompt de sistema de 50k tokens em 500 requests/dia cai de $75/dia para ~$7.69/dia.

## Key insights
- Esta fonte está em tensão direta com `loop-engineering-build-an-ai-that-codes-while-you-sleep` e `loop-engineering-teaching-ai-agents-to-learn-from-their-own-mistakes` (mesma leva) — ambas descrevem loop engineering como prática a adotar; esta argumenta que o conselho popular ("designe loops, não prompts") é dado por quem não paga a própria conta, e que builders com orçamento real deveriam preferir spec-first + roteamento de modelo + caching antes de adotar loops completos. **Candidato a entrada no Contradiction Register (F3.4)**: não é contradição factual, é uma divergência de prescrição (quando vale a pena usar loop completo vs técnicas mais baratas) que vale registrar.
- O argumento "tokens de entrada dominam o custo, não o output" é um princípio de FinOps de LLM diretamente aplicável a qualquer agente deste vault que reenvia contexto extenso por turno (relevante para `04-SYSTEM/agents/nexus-agent-system/` se algum agente rodar em loop multi-turno).

## Exemplos e evidências
- Dado real verificável: $1.3M/mês em tokens OpenAI por Steinberger (depois clarificado para ~$300k sem Codex Fast Mode); breakdown de custo de caching (50k tokens, 500 req/dia: $75→$7.69).

## Implicações para o vault
Reforça que qualquer automação de loop futura no vault (ex.: pipeline semanal já existente) deve ter: spec explícita antes de rodar, roteamento de modelo barato/caro (já parcialmente coberto por `model-router` em memória), e cache de contexto estável — os 3 primeiros plays já são parcialmente seguidos pela arquitetura do Nexus (specs por fase, model-router por agente).

## Links
- [[03-RESOURCES/concepts/agent-systems/claude-code-agent]]
- [[04-SYSTEM/agents/nexus-agent-system/ingest-agent]]

**Nota de contradição**: ver F3.4 — esta fonte discorda em prescrição (não em fato) das duas outras fontes "loop engineering" desta mesma leva sobre quando adotar loops completos.
