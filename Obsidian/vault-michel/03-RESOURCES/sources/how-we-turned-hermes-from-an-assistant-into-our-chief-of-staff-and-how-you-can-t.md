---
title: "How we turned Hermes from an assistant into our chief of staff (and how you can too)"
type: source
source: "Clippings/How we turned Hermes from an assistant into our chief of staff (and how you can too).md"
created: 2026-06-20
ingested: 2026-06-21
tags: [articles, hermes-agent]
---

## Tese central
Hermes deixa de ser um chat para se tornar um "worker que você roda" (não uma janela que você abre) quando ganha memória persistente, playbooks ensinados, jobs agendados e a capacidade de gerenciar outros agentes abaixo dele — o artigo descreve 4 dos 12 "jobs" dados ao Hermes numa operação real de negócio.

## Argumentos principais
- **Artefatos de marca on-demand**: agente aponta para um design spec file (`design.md`) e gera qualquer material visual (carrossel, one-pager, case study, ad concept) já no padrão de marca — usado, por exemplo, para comunicar nova política de blockers de forma que "cola" mais que texto solto no Slack.
- **Rodar dentro do Slack** (não WhatsApp/Telegram para trabalho de time): threads organizadas permitem acompanhar múltiplos workstreams em paralelo sem virar um scroll único confuso — conhecimento se propaga mais rápido quando o agente conversa nos canais onde o time já vive.
- **Múltiplas threads paralelas = múltiplos workstreams progredindo sozinhos**: o trabalho da pessoa "encolhe para aprovar, não fazer" — cada thread é um fluxo de trabalho fechado (closed-loop) avançando independentemente.
- **Integração com Linear**: agente sem registro do que está fazendo estagna; conectar a uma ferramenta de projeto com API simples dá ao trabalho uma "espinha dorsal" — Hermes abre tickets conforme o trabalho acontece e roteia de volta para revisão humana.

## Key insights
- O padrão "múltiplas threads = múltiplos workstreams paralelos, humano só aprova" é a mesma lógica de escala que justifica o uso de subagentes em paralelo neste vault (batch ingest, F2 parallel) — confirma que o ganho de produtividade de agentes não vem de um agente "mais inteligente", mas de rodar várias instâncias/threads concorrentes com baixa fricção de aprovação.
- "Agente sem registro do que está fazendo estagna" reforça a importância do `.raw/.manifest.json` e do `ledger.md` deste vault como espinha dorsal de rastreabilidade — sem eles, o pipeline também estagnaria.

## Exemplos e evidências
- Caso real: comunicação de nova política de blockers via one-pager gerado pelo agente em vez de reunião all-hands.
- Caso real: atualização de media kit a partir de versão antiga, dados atuais extraídos de múltiplas plataformas, aprovação única.

## Implicações para o vault
Reforça (não introduz) os padrões já documentados em `[[03-RESOURCES/entities/Hermes-Agent]]` e `[[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]` — caso útil de "agente como operador" com integração de ferramenta de projeto (Linear) para rastreabilidade, análogo ao papel do ledger.md no Nexus.

## Links
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[04-SYSTEM/agents/nexus-agent-system/ledger]]
