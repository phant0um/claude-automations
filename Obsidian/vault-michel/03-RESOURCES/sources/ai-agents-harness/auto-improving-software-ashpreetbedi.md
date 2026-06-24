---
title: "Auto-Improving Software"
type: source
source_file: Clippings/Auto-Improving Software.md
origin: thread X
author: "@ashpreetbedi"
ingested: 2026-05-14
tags: [auto-improvement, agent-platform, agno, claude-code, evals, devops]
triagem_score: 8
---

# Auto-Improving Software

> [!key-insight] Insight principal
> Agent platforms são a primeira categoria de software onde ações, dados e ferramenta de iteração ficam próximos o suficiente para um coding agent testar end-to-end, fazer mudanças, e testar novamente — o que torna o loop Improve→Hill Climb recursivamente poderoso.

## Content summary

### Por que auto-improvement só funciona com stack controlada

A maioria dos softwares não pode auto-melhorar porque inputs/outputs estão espalhados em ferramentas com auth separado e formatos diferentes. Três coisas tornam possível:

1. **Toda ação exposta como API** — running agent, reading session, running eval — tudo via cURL ou bash
2. **Dados colocalizados** — sessões e traces no mesmo Postgres; agent testa e lê resultado sem sair do ambiente
3. **Logs sobre tudo** — plataforma roda local no Docker; agente lê logs ao vivo; loop test→review = ~5s

### O loop Improve → Hill Climb

| Loop | Função |
|------|--------|
| **Improve** | Captura falhas out-of-distribution (probes adversariais, edge cases) |
| **Hill Climb** | Garante que casos in-distribution continuem passando (regressão) |

Os dois trabalham muito bem juntos. Capped em 5 rounds; para antes se tudo passar.

### Eval suite (duas arquivos)

```python
# evals/cases.py
# Cada case: input + rubric (como resposta correta parece) + expected tool call (opcional)
# Built on Agno's AgentAsJudgeEval e ReliabilityEval
```

### Casos de uso que antes eram impossíveis

Sem a plataforma, nenhum desses surpreenderia um multi-day project:
- Agent que sumariza mensagens do Slack overnight
- Agent que faz rascunho do weekly update
- Agent que destaca issues importantes no repo

Todos cabem numa pausa de café.

### Link para codebase

[agent-platform-railway](https://github.com/agno-agi/agent-platform-railway) — Docker local ou Railway.

## Por que só funciona com stack controlada — detalhes

### O problema de distribuição de responsabilidade

A maioria dos softwares existe em um ecossistema fragmentado: inputs chegam via Slack (auth separado), dados ficam em Postgres (outro sistema), outputs vão para email (outro sistema ainda). Para um agente testar end-to-end, ele precisaria de acesso a todos esses sistemas com auth separado, formatos diferentes, e latências variadas.

A plataforma de agentes resolve isso por design: ela **é** o sistema. O agente não precisa integrar com sistemas externos para testar — ele testa dentro do ambiente que controla.

### Os três enablers concretos

**1. Toda ação como API:** `curl http://localhost:7777/v1/runs -d '{"agent_id": "my_agent", "message": "..."}'` — o agente pode acionar outros agentes programaticamente, sem interface gráfica. Isso é o que permite que o loop de test→review rode em ~5 segundos: não há humano clicando, não há UI carregando.

**2. Dados colocalizados:** sessões e traces no mesmo Postgres que o agente pode consultar com SQL. O agente roda um eval, depois faz `SELECT * FROM sessions WHERE agent_id='my_agent' ORDER BY created_at DESC LIMIT 1` para ler o trace do eval que acabou de rodar. Zero latência de integração.

**3. Logs em tempo real:** plataforma no Docker local, o agente lê `docker logs agno-platform --follow`. Durante o loop de improve, o agente pode ver o que está acontecendo no sistema enquanto testa.

## O loop Improve → Hill Climb em detalhe

### Improve: encontrar falhas out-of-distribution

O Improve loop envia probes adversariais — inputs que o agente provavelmente não viu durante desenvolvimento:
- Inputs com caracteres especiais (edge case de encoding)
- Inputs muito longos (edge case de context)
- Inputs ambíguos (edge case de interpretação)
- Inputs que combinam múltiplos domínios (edge case de escopo)

O objetivo é encontrar casos onde o agente falha de formas que não foram antecipadas. Quando encontra, o agente propõe uma mudança (no prompt, nas tools, nas regras do agente) e testa se a mudança resolve o caso sem quebrar outros.

### Hill Climb: garantir que casos in-distribution passam

O Hill Climb loop verifica os casos conhecidos que devem funcionar — os exemplos de sucesso que definem o comportamento esperado do agente. Cada mudança proposta pelo Improve loop precisa passar no Hill Climb antes de ser aceita.

A combinação é o que torna o loop robusto: Improve expande as fronteiras do comportamento correto; Hill Climb garante que expandir as fronteiras não quebrou o núcleo.

### O cap de 5 rounds

"Capped em 5 rounds; para antes se tudo passar" é uma proteção contra over-optimization: um agente que continua melhorando indefinidamente pode começar a otimizar para o harness de eval em vez de para o comportamento geral. 5 rounds é suficiente para capturar os problemas óbvios sem entrar em territory de overfitting ao eval.

## Os evals em detalhe

```python
# evals/cases.py — estrutura de um eval case
{
    "input": "Summarize the Slack messages from the engineering channel last week",
    "rubric": "Summary should: mention all major incidents, list action items with owners, be under 200 words",
    "expected_tool_call": "slack_get_messages(channel='engineering', days=7)",  # opcional
}
```

**AgentAsJudgeEval:** usa um LLM como juiz para avaliar se o output satisfaz o rubric. Flexível, mas com variância no julgamento.

**ReliabilityEval:** verifica se o agente chama as ferramentas certas na ordem correta. Mais determinístico — útil quando o processo importa tanto quanto o resultado.

Os dois tipos de eval atacam dimensões diferentes: o AgentAsJudgeEval avalia qualidade do output; o ReliabilityEval avalia correção do processo.

## Casos de uso: por que eram impossíveis antes

Os exemplos (Slack overnight, weekly update, issues no repo) eram "impossíveis" no sentido de que exigiam configuração diária e manutenção ativa. Sem uma plataforma de agente controlada:
- O script de Slack precisaria de auth renovado periodicamente
- O cron job não saberia se o agente falhou ou teve um comportamento inesperado
- Mudanças no formato do Slack quebrariam o script silenciosamente

Com a plataforma: o agente monitora seus próprios traces, detecta quando o comportamento muda, e aciona o loop de improve automaticamente.

## Limitações

- Requer que toda a stack rode localmente no Docker — não é uma solução cloud-first
- A plataforma Agno específica tem suas próprias dependências e curva de aprendizado
- O loop de auto-improve ainda precisa de eval cases bem escritos — se os evals forem ruins, o agente vai otimizar para os evals ruins
- 5 rounds pode não ser suficiente para problemas muito complexos; é um parâmetro que precisa de tuning por domínio

## Conexões

- [[03-RESOURCES/sources/ai-agents-harness/agent-platform-builds-itself-ashpreetbedi]] — artigo companion com guia de setup completo
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — Improve→Hill Climb como implementação prática
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — papéis especializados (Create/Improve/Extend/Review)
- [[03-RESOURCES/entities/Agno]]
