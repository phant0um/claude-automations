---
title: "How to Run Signal-Based Outbound from Claude Code"
type: source
source: "[@nifinet](https://x.com/nifinet/status/2065458759573680326)"
created: 2026-06-13
ingested: 2026-06-13
tags: [ai-agents]
---

## Tese central

Caso de uso vertical (outbound de vendas) usado como veículo para um padrão de pipeline genérico — "sensing → judgment → drafting → restraint → self-improving loop".

## Argumentos principais

1. **Wiring antes da campanha**: instalar a ferramenta de envio como skill do Claude Code (`npx skills add ...`) — qualquer ferramenta com CLI/API encaixa no mesmo slot. Manter em **dry-run** até o último passo (risco: stack que envia emails errados para toda a lista antes de revisão humana).
2. **Sensing**: 4 buckets de "intent signal" (Job, Social, Company, Funding) — agente pesquisa a web pública + sinal first-party (visitantes do site), produz tabela ranqueada com trigger + fonte. Regra: "never infer or invent movement" — sem fonte, descarta.
3. **Judgment (Claude decide quem recebe mensagem)**: score 0-100 (timing+fit), regra explícita "saying no is most of the job" — sistema que descarta 3/4 contas vale mais que um que manda para todas.
4. **Drafting condicionado ao trigger**: abertura deve citar o trigger real ("Saw you reposted the Head of RevOps role..."), nunca "Hi {{firstName}}". Regra de qualidade: "if the opener could have gone out last month, rewrite it".
5. **Restraint como produto**: maioria das contas não recebe nada — essa é a feature, não uma limitação.
6. **Loop diário via cron** (`claude -p "$(cat sweep.md)"`) que reescreve o próprio prompt de copywriting com base em outcomes (replies/meetings) — "an agent that does not learn is a faster script".

## Implicações para o vault

Padrão "sensing → judgment → action → restraint → self-rewrite via outcomes" é um template de pipeline genérico aplicável a qualquer rotina de triagem do vault (ex: pipeline-diario triagem já implementa sensing+judgment; "restraint as the product" e "self-rewrite via outcomes" são os 2 estágios que faltam — candidatos para `hill`). Conecta com [[03-RESOURCES/concepts/agent-systems/observability-driven-evolution]] e [[03-RESOURCES/concepts/agent-systems/self-evolving-systems]].

Este é o **padrão de pipeline transferível** do cluster: "restraint as the product" e "self-rewrite via outcomes" são estágios que o pipeline-diario ainda não tem; candidatos para [[04-SYSTEM/agents/core/hill]].

## Links

- [[03-RESOURCES/concepts/agent-systems/observability-driven-evolution]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-systems]]
- [[04-SYSTEM/agents/core/hill]]
