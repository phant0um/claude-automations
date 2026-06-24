---
title: "Your Agent Harness Should Repair Itself"
type: source
source: "Clippings/Your Agent Harness Should Repair Itself.md"
url: "https://x.com/akshay_pachaar/status/2064051835636498924"
author: "Akshay Pachaar (@akshay_pachaar)"
published: 2026-06-08
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents, harness-engineering, observability, self-repair, opik, agent-evaluation]
---

# Your Agent Harness Should Repair Itself

**Autor:** Akshay Pachaar (@akshay_pachaar)
**Publicado:** 2026-06-08
**Ferramenta destacada:** Opik (open-source, Comet ML)

## Tese central

Observabilidade de agentes hoje entrega um **trace** (o que aconteceu) e para por aí — diagnóstico ("por que falhou"), correção ("o que mudar") e prevenção ("não vai quebrar de novo") ficam **manuais**. Esse loop manual é o verdadeiro gargalo, não a observabilidade em si. A proposta (via Opik) é fechar esse loop automaticamente: **trace → diagnóstico → fix proposto → aplicação verificada → travamento como teste de regressão → volta ao trace**.

## Argumentos principais

1. **Observabilidade tradicional para no "what happened"**. Você recebe span tree, latência, custo em tokens, dashboard — mas "why it happened", "here's the fix" e "this won't break again" ficam manuais. Isso era razoável em 2023; é a abstração errada para times rodando agentes em produção hoje.

2. **O problema composto pelo tempo**: cada upgrade de modelo introduz novos modos de falha; cada nova ferramenta adiciona novos edge cases. A complexidade do harness cresce mais rápido do que qualquer time consegue rastrear/reparar manualmente.

3. **Stack de 4 camadas conectadas em loop único** (Opik):
   - **Layer 1 — Tracing**: instrumentação automática de toda chamada LLM, tool invocation, e retrieval step via decorator único (`@opik.track`); compatível com LangGraph, CrewAI, e 50+ frameworks. Cada trace registra a configuração de agente ativa para reprodutibilidade total ao re-rodar um input que falhou.
   - **Layer 2 — Ollie (coding agent embutido)**: vai do trace para código corrigido. Sem acesso a código: lê span trees, identifica modos de falha, explica a cadeia causal entre chamadas LLM (ex: "why did the final answer ignore the retrieved context?"). Com `opik connect`: lê arquivos-fonte, identifica linhas exatas responsáveis, propõe um diff (nada muda sem aprovação explícita). Após aprovação: re-roda o agente contra os inputs exatos do trace original que falhou, faz streaming do novo trace para comparação lado-a-lado, e **trava a falha original como caso de regressão** no test suite.
   - **Layer 3 — Test Suites com asserções em linguagem natural**: ao invés do workflow tradicional de eval (dataset rotulado + métrica numérica + comparação de floats — modelo que funciona para pesquisadores mas não bate com como engenheiros pensam sobre qualidade), Opik usa **asserções em plain-English** (ex: "The response must include specific deal details, not just a count", "must never reveal unauthorized information"), convertidas internamente em checks LLM-as-a-judge com pass/fail limpo por caso. **Toda trace que falha vira automaticamente um novo test case** — a suíte cresce a partir de falhas reais de produção, não cenários sintéticos pré-escritos.
   - **Layer 4 — Agent Sandbox**: diferente de "prompt playgrounds" (que mudam um system prompt e re-rodam uma única chamada LLM — pergunta errada), o sandbox roda o **agent graph completo** instrumentado end-to-end na UI. Mudar um prompt, trocar um modelo, adicionar uma ferramenta → observa como o sistema inteiro responde através de toda a spanning tree. Cada run do sandbox produz um trace Opik completo. Permite que stakeholders não-devs (PMs, domain experts, QA) testem configurações com segurança, sem tocar git.

4. **O flywheel completo**: instrumentar com `@opik.track` → declarar `opik.Config` → algo falha em produção → Ollie lê trace + source, propõe fix → aprovação humana → Ollie re-roda no Sandbox contra o input original que falhou → fix passa → salvo como novo "Blueprint" → ponteiro de ambiente promove para staging → falha original travada como teste de regressão. **A próxima falha entra no mesmo loop.** "Every cycle, the harness gets harder to break."

5. **O único passo manual no loop é a aprovação humana do diff** — todo o resto (diagnóstico, re-execução, comparação, travamento de regressão) é automatizado.

## Key insights

- A distinção crítica é entre **"CI failure after the agent is finished" (gate)** vs. **"failure the agent sees while working" (backpressure)** — conceito que ecoa diretamente o Backpressure Loop Pattern (já no vault), mas aplicado à camada de *desenvolvimento do harness* em vez de só ao loop de codificação do agente.
- **Plain-English assertions como ponte entre avaliação de pesquisa e prática de engenharia**: floats/métricas numéricas não correspondem a como engenheiros raciocinam sobre qualidade; LLM-as-judge sobre asserções legíveis fecha essa lacuna sem sacrificar automação.
- **Reprodutibilidade total via configuração registrada por trace** é o que torna possível "re-rodar exatamente o caso que falhou" — pré-condição para qualquer ciclo de self-repair confiável.
- Métrica de tração mencionada: projeto open-source Opik (github.com/comet-ml/opik) com 19.3K+ stars.

## Exemplos e evidências

```python
import opik

@opik.track
def my_agent(query: str):
    # your agent logic here
    ...
```

```python
suite = opik.TestSuite("crm-agent-v2")
suite.add_assertion("The response must include specific deal details, not just a count")
suite.add_assertion("The response must never reveal unauthorized information")
suite.run_tests()
```

Self-host: `git clone https://github.com/comet-ml/opik && cd opik && ./opik.sh`

## Implicações para o vault

1. **Self-repair loop (trace → diagnóstico → fix → regressão) é uma instância concreta do que `[[04-SYSTEM/wiki/errors]]` + skill updates já tentam fazer manualmente** — o vault registra correções em `errors.md` mas não tem o passo "travar como teste de regressão automático". Pode inspirar uma extensão de `04-SYSTEM/agents/hill` ou `verify`.
2. **Plain-English assertions / LLM-as-judge** é um padrão direto para `[[04-SYSTEM/agents/core/verify]]` (quality gate) — escrever critérios de aceitação de tarefas do vault como asserções em PT-BR avaliáveis por LLM, em vez de checklists rígidos.
3. Conecta com `[[03-RESOURCES/concepts/agent-systems/agent-observability]]` e `[[03-RESOURCES/concepts/agent-systems/halo-harness-self-optimization]]` — Opik é uma implementação production-grade do conceito HALO (harness self-optimization) com tooling completo.
4. O conceito "backpressure" (gate vs. in-loop feedback) liga diretamente a `[[03-RESOURCES/sources/backpressure-loop-coding-agents]]` (já no vault) — mesma família de ideias, aplicadas a granularidades diferentes (loop de codificação vs. ciclo de manutenção do harness).

## Links

- [[03-RESOURCES/sources/backpressure-loop-coding-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
- [[03-RESOURCES/concepts/agent-systems/halo-harness-self-optimization]]
- [[04-SYSTEM/agents/core/verify]]
- [[04-SYSTEM/agents/memory/hill-memory]]
- [[03-RESOURCES/concepts/verification-driven-development]]
