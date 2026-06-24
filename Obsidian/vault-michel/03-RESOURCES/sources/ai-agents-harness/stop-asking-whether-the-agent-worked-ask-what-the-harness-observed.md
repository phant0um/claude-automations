---
title: "Stop Asking Whether the Agent Worked. Ask What the Harness Observed."
type: source
source: "Clippings/Stop Asking Whether the Agent Worked. Ask What the Harness Observed.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

O output final de um agente é uma compressão que deleta exatamente o que você precisa quando algo quebra. A avaliação correta de agentes não é "o agente funcionou?" mas "o que o harness observou?" — trace, telemetria de execução e um scorecard pós-run. Para tarefas longas e difíceis, o harness move a performance mais do que a escolha do modelo.

## Argumentos principais

- **Output-only evaluation mente**: dois agentes fecham o mesmo ticket, mesmo diff, mesmo check verde. Um fez em 4 passos, rodou testes completos, pediu permissão antes de tocar produção. O outro loopou 11 vezes, pulou o test suite, bateu numa permission wall que nunca mencionou. A avaliação de output não vê diferença.
- **Quatro problemas escondidos por um "pass"**:
  1. Coding agent ship patch que passa o único teste que rodou, nunca toca o suite maior. Check verde, bug latente.
  2. Research agent cita a fonte perfeita, mas chegou lá via entry de memória stale que por acaso ainda está correta. No próximo mês, não vai estar.
  3. Support agent resolve ticket depois de tentar silenciosamente um caminho de refund que era proibido e receber negativa. Ninguém upstream sabe da tentativa.
  4. Long-running agent termina multi-day job após três rodadas de context compaction — ninguém pode dizer quais premissas iniciais sobreviveram o último handoff.
- **Harness-Bench**: benchmark diagnóstico que rodou 5,194 trajetórias de agentes em 106 tarefas sandboxed, cruzando 8 backends de modelo com 6 harnesses. Cada run loga: artefato final, trace completo de execução, usage stats, resultado dos validators. Conclui que a mesma tarefa e modelo podem aterrissar de formas muito diferentes dependendo do harness.
- **"Stop Comparing LLM Agents Without Disclosing the Harness"**: a Binding Constraint Thesis — uma vez que modelos atingem parity de frontier class, o harness explica mais do performance gap do que o modelo. Qualquer leaderboard que esconde o harness está creditando o modelo pelo trabalho do scaffolding.
- **Anthropic sobre avaliação de agentes**: grade trajetória e outcome como duas coisas separadas. O transcript de tool calls, token counts, turns, latência e verificações de estado é uma superfície de grading própria, não uma nota de rodapé sob a resposta final.
- **A stack de telemetria do harness** (8 layers, cada uma capturando a falha que só ela explica):
  - Context: prompts, arquivos, docs recuperados, memórias, skills, tool schemas, compaction events → "o agente nunca viu o fato que precisava, ou viu contexto stale"
  - Tool: nome, args, result, error, latency, output size, repeated calls → "tool falhou, retornou evidência fraca, ou entrou em loop"
  - Permission: approval request, decision, policy rule, denial, escalation path → "agente cruzou um limite, ou não conseguiu se recuperar de uma negativa"
  - Execution: sandbox mode, workspace diff, network policy, estado do ambiente, side effects → "run dependeu de estado de ambiente oculto ou mudanças de arquivo não rastreadas"
  - Test: commands, validators, static checks, pass/fail, outcome graders → "resposta parecia correta mas nunca foi checada de fora"
  - Memory: reads, writes, source, timestamp, confidence, expiry → "memória stale ou insegura guiou silenciosamente o run"
  - Cost and latency: model calls, token usage, wall time, retry count, wait states → "agente teve sucesso queimando budget ou loopando cegamente"
  - Human: clarifications, approvals, corrections, interrupts, handoffs → "performance autônoma não pode ser separada do resgate humano"
- **Failure map dos 11 layers do harness**: Control, Context, Runtime loop, Tools, Execution, Governance, Memory, Skills, Planning, Verification, Interface — lidos como "onde apontar quando a resposta saiu errada" em vez de "o que um harness contém."
- **Coding vs Personal agents**: Codex/Claude Code concentram engenharia em governance, execution, verification (falhas atingem arquivos, terminais, repos, CI). Hermes/OpenClaw concentram em memory, identity, channels, continuity (falhas se manifestam ao longo do tempo). Ambos precisam de traces, mas em layers diferentes.
- **O caso difícil — personal agent rodando coding agent como backend**: o trace precisa cruzar a costura entre dois harnesses. O agente externo sabe o que pediu; o runtime interno possui as tool calls reais, diffs, testes, decisões de permissão. Se o trace para no handoff, o diagnóstico para também.

## Key insights

- **"O agente passou" é a informação errada para grade**: um run que passou mas dispara 4 dos sinais de bad no scorecard não é um sucesso — é um sucesso que você se safou, e "se safar" não sobrevive ao contato com produção.
- **A pergunta certa mudou**: não é "funcionou?" mas "o harness viu o suficiente para explicar o run no dia em que não funcionar?"
- **Trace não é wishlist de dashboard — é um contrato de debugging**: quando uma layer está faltando no trace, a falha que vive naquela layer não pode ser atribuída. Você volta a reexecutar o agente e torcer.
- **Codex e Claude Code já emitem partes da stack via OpenTelemetry**: model e tool calls, sessions, token e cost metrics, structured logs. Traces no Codex já estão rodando; no Claude Code ainda em beta. A plumbing existe; o raro é tratar o trace, não a resposta, como o que você revisa.
- **"The model can tell you what it answered. The trace tells you what actually happened."**: distinção fundamental entre o que o modelo produz e o que realmente aconteceu no sistema.
- **Performance autônoma não pode ser separada do resgate humano**: uma das layers do trace é justamente capturar clarifications, approvals, corrections, interrupts, handoffs — sem isso, métricas de autonomia são infladas.

## Exemplos e evidências

- **Harness-Bench**: 5,194 trajetórias, 106 tarefas sandboxed, 8 backends × 6 harnesses. Achado: mesmo task + modelo → resultados muito diferentes por harness.
- **Três tabelas completas incluídas** (em markdown no appendix):
  - Trace layer → what to capture → failure it explains (8 layers)
  - Harness layer → question to ask when run fails (11 layers)
  - Reliability scorecard: dimension → question → bad signal (10 dimensões)
- **Scorecard de confiabilidade pós-run** inclui: outcome reliability, trajectory quality, tool effectiveness, context discipline, permission safety, recovery behavior, verification strength, cost and latency, memory correctness, trace completeness.

## Implicações para o vault

- O vault-michel usa agentes extensivamente (40+ agentes) sem um sistema formal de trace/telemetria — este source sugere que "passes" de agentes podem estar escondendo falhas latentes.
- A distinção entre grading de trajetória e de outcome é diretamente aplicável ao pipeline de ingestão: o importante não é só "a ingestão completou" mas "o harness observou o que era esperado em cada step?"
- O scorecard de confiabilidade pós-run pode ser adaptado como checklist para o pipeline de ingestão do vault.
- A Binding Constraint Thesis (harness > modelo para performance em tarefas longas/difíceis) reforça o investimento do vault-michel em arquitetura de agentes sobre a escolha de modelos.
- Candidato a criar [[03-RESOURCES/concepts/ai-agents/agent-evaluation]] ou expandir um conceito existente de observabilidade.

## Links

- [[03-RESOURCES/concepts/ai-agents/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/ai-agents/agent-memory]]
- [[03-RESOURCES/sources/state-of-memory-in-agent-harness]]
- [[03-RESOURCES/sources/how-to-build-a-custom-agent-harness]]
- [[04-SYSTEM/agents/core/verify]]
