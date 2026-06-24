---
title: "1,500+ PRs Later: Spotify's Journey with Background Coding Agents (Honk, Part 1)"
type: source
source: "Clippings/1,500+ PRs Later Spotify's Journey with Our Background Coding Agent (Honk, Part 1).md"
url: "https://engineering.atspotify.com/2025/11/spotifys-background-coding-agents-part-1"
authors:
  - Max Charas (Senior Staff Engineer)
  - Marc Bruggmann (Principal Engineer)
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, coding-agents, spotify, honk, production, fleet-management, background-agents]
score: 9
category: ai-agents
---

## Tese central

Spotify evoluiu seu sistema Fleet Management para incluir agentes de codificação em background (codinome: Honk), gerando mais de 1.500 PRs mergeados em produção — com saving de 60–90% de tempo em comparação à escrita manual de código — demonstrando que agentes autônomos de codificação são viáveis em escala enterprise real.

## Argumentos principais

1. **Fleet Management como base:** O sistema pré-existente já automatizava metade dos PRs do Spotify usando transformações determinísticas de código (AST/regex). O limite era a complexidade: migrations sofisticadas exigiam especialistas e scripts de até 20.000 linhas.

2. **Agente substitui o script de transformação:** Em vez de reescrever a lógica determinística, Spotify substituiu apenas a etapa de geração de código por um agente LLM orientado por prompt. Toda a infraestrutura ao redor (targeting, PR opening, review, merge) permanece inalterada.

3. **CLI interna plugável:** Construíram uma CLI própria que delega execução ao agente, roda formatação/linting via MCP local, avalia diffs com LLM-as-judge, faz upload de logs para GCP e captura traces no MLflow. Isso permite trocar o agente/LLM subjacente sem impactar usuários.

4. **Multi-agent architecture para ad hoc:** Além de migrations, expuseram o agente via MCP para Slack e GitHub Enterprise. Um agente interativo coleta informações sobre a tarefa → gera prompt → passa para o agente de codificação → abre PR automaticamente.

5. **Desafios identificados:** Performance (agentes são lentos e imprevisíveis), necessidade de guardrails e sandboxing, custo computacional de LLMs em escala.

## Key insights

- **50% dos PRs do Spotify já eram automatizados** antes do Honk — Fleet Management como fundação é o que tornou Honk viável.
- **Plugabilidade é crítica em GenAI:** a flexibilidade de trocar modelos/agentes já foi exercida múltiplas vezes desde o lançamento.
- **LLM-as-judge no pipeline:** avaliar diffs com LLM antes de abrir o PR é parte do loop de qualidade.
- **60–90% de saving de tempo** em migrations com breaking changes (Java records, Scio upgrade, Backstage frontend system, YAML config).
- **MCP como protocolo de integração:** linting, formatação e exposição do agente via Slack/GitHub todos usam MCP.
- **Simbiose migration×ad hoc:** melhorias no agente base beneficiam ambos os casos de uso automaticamente.
- Série completa: Part 1 (esta) → [[03-RESOURCES/sources/background-coding-agents-context-engineering-honk-part2]] → Part 3 → Part 4.

## Exemplos e evidências

| Tipo de migration | Tecnologia |
|---|---|
| Language modernization | Java value types → Records (JEP 395) |
| Upgrade com breaking changes | Scio (data pipeline) nova versão |
| UI component migration | Backstage new frontend system |
| Config changes | YAML/JSON com schema e formatting |

Gráfico: ~metade dos PRs mergeados do Spotify vêm do Fleet Management/Honk desde meados de 2024.

## Implicações para o vault

- Evidência de produção para o conceito [[03-RESOURCES/concepts/coding-agents]]: agentes de codificação em background são viáveis em escala (1.500+ PRs reais).
- Padrão de integração: **substituir apenas a etapa de transformação** enquanto mantém infraestrutura ao redor — aplicável ao vault (substituir scripts de ingest por agentes LLM mantendo o pipeline).
- Harness-first: a CLI plugável do Honk é um exemplo claro de [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — o harness precede o modelo.
- LLM-as-judge como gate de qualidade antes de PR → conecta com [[03-RESOURCES/concepts/agent-systems/agent-observability]].

## Links

- [[03-RESOURCES/concepts/coding-agents]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
- [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]]
