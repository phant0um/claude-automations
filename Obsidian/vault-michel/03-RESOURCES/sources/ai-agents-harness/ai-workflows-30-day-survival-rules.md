---
title: "90% of AI Workflows Die in 30 Days — 3 Rules That Keep Them Alive"
type: source
category: ai-agents
author: "@sairahul1"
source_url: "https://x.com/sairahul1/status/2055935584158531815"
published: 2026-05-17
ingested: 2026-05-18
tags: [source, ai-agents, workflow-reliability, production, monitoring]
triagem_score: 8
---

# 90% of AI Workflows Die in 30 Days — 3 Rules That Keep Them Alive

## Tese central

90% dos AI workflows morrem no primeiro mês não por falha do modelo, mas porque builders ignoram 3 regras fundamentais: job description precisa, detecção de falha silenciosa, e monitoramento humano ativo.

## Key insights

**O padrão de morte (sempre o mesmo):**
- Day 1: funciona no demo
- Day 9: algo muda silenciosamente (API format shift, source behind login, edge-case interpretado diferente)
- Day 14: output tecnicamente presente, substantivamente inútil
- Day 30: builder desiste e culpa "AI não está pronta"

**Regra 1 — Job Description, não vibe**
Agente sem job description é um desejo, não uma especificação. 5 partes obrigatórias:
1. O que monitora (trigger/schedule específico, não "quando relevante")
2. O que lê (fontes exatas e bounded, não "check the internet")
3. O que produz (formato e limite exatos: "3 seções, under 300 words, neste Google Doc")
4. O que NÃO faz (guardrails explícitos: "nunca envie email externo sem aprovação humana")
5. Como saber se funcionou (success condition: se brief vazio → Slack alert, não brief vazio)

**Regra 2 — Falha silenciosa é a única que mata**
- Falha ruidosa: erro visível, workflow para, você corrige
- Falha silenciosa: output chega, formato correto, conteúdo errado — ninguém checa
- Exemplos: scoring rubric deriva, source muda URL e agente preenche com dados stale sem flag, triage categoriza errado por padrão de nome
- Solução: checksums no conteúdo, alertas de "nenhum resultado encontrado" > brief vazio

**Regra 3 — Human-in-the-loop até você ter dados suficientes**
- Não é falta de confiança no modelo — é coleta de ground truth
- Semana 1-2: aprovar TUDO manualmente, anotar onde o modelo erra
- Só depois automatizar onde o modelo acerta consistentemente

## Por que o padrão de morte é tão consistente

O padrão Day 1 → Day 9 → Day 14 → Day 30 não é coincidência — é estrutural. Ambientes mudam mais rápido do que builders antecipam: APIs mudam formato de response, fontes de dados adicionam login walls, edge cases acumulam que não existiam no demo. Um workflow sem monitoramento explícito não tem como detectar que algo mudou silenciosamente.

A falha silenciosa é mais destrutiva do que a ruidosa porque não dispara nenhum alerta. O output continua chegando no formato correto — o que elimina suspeita imediata. Só análise de conteúdo ao longo do tempo revela a deriva.

## Como escrever uma Job Description que funciona

O framework das 5 partes pode ser aplicado a qualquer agente:

**Exemplo prático — agente de newsletter semanal:**
1. **O que monitora**: RSS feeds de 5 fontes específicas (URLs listadas), executado às 9h toda segunda
2. **O que lê**: Últimos 7 dias de posts, máximo 50 items por fonte
3. **O que produz**: Markdown com 3 seções ("This Week", "Deep Dive", "Worth Bookmarking"), cada item máximo 2 frases, total < 800 palavras, enviado para `newsletter-draft.md` na pasta compartilhada
4. **O que NÃO faz**: Nunca envia email diretamente. Nunca inclui posts de fontes não listadas. Nunca publica sem aprovação humana.
5. **Como saber se funcionou**: Se menos de 3 items foram encontrados → Slack alert "Newsletter draft empty — check sources". Se `newsletter-draft.md` não foi atualizado após 9:30 → PagerDuty alert.

Sem o ponto 5, um draft vazio parece silencioso. Com o ponto 5, a ausência de conteúdo é tão barulhenta quanto um erro de código.

## Detecção de falha silenciosa: mecanismos concretos

**Checksum de conteúdo**: gerar hash do output e comparar com sessões anteriores. Variação zero por 3+ runs consecutivos = provável que a fonte parou de responder e o agente está repetindo cache.

**Alertas de ausência**: `if len(results) == 0: send_alert()` é mais importante do que qualquer outro monitor. O workflow que não encontra nada deve barulhar, não completar silenciosamente.

**Spot-check humano semanal**: mesmo após automação, uma leitura humana por semana durante os primeiros 2 meses captura casos que nenhum monitor automático detectaria — deriva semântica, mudança de tom, erros de interpretação de contexto.

**Logging de source health**: além do output, logar o estado de cada source acessada (status HTTP, número de items retornados, timestamp do último item). Isso permite distinguir "fonte sem conteúdo novo" de "fonte inacessível."

## Human-in-the-loop como coleta de ground truth

A recomendação de aprovar tudo manualmente nas primeiras 2 semanas não é conservadorismo — é estratégia de dados. Cada aprovação ou rejeição manual cria um par (input, julgamento) que documenta o que "bom" significa para aquele workflow específico.

Depois de 50-100 julgamentos manuais, padrões emergem: o agente erra consistentemente em X tipo de input, acerta consistentemente em Y. A automação pode então ser configurada com confiança: automatizar Y completamente, manter revisão humana para X.

Equipes que pulam essa fase automatizam cedo, perdem confiança no agente quando ele erra de formas que não conseguem prever, e eventualmente desligam o workflow.

## Aplicação no vault-michel

O pipeline Clippings → wiki-ingest é um AI workflow sujeito exatamente a esses padrões de falha. A "job description" atual está implícita nas instruções do CLAUDE.md. Torná-la explícita — com success conditions mensuráveis (mínimo de wikilinks criados por ingestão, atualização confirmada do hot.md, entrada no manifest) — tornaria o workflow mais auditável e resistente a drift silencioso.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] — monitoramento de produção
- [[03-RESOURCES/concepts/agent-systems/agent-error-correction]] — error recovery em workflows
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]] — guardrails e job descriptions
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]] — aprendizado iterativo
