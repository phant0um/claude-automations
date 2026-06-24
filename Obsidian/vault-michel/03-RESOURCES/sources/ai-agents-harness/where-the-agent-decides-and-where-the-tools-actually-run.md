---
title: "Where the agent decides, and where the tools actually run"
type: source
source: "https://commandline.microsoft.com/langgraph-squad-azure-container-apps-brain-hands-graph-state-architecture/"
created: 2026-06-22
updated: 2026-06-22
tags: [ai-agents, langgraph, squad, azure-container-apps, architecture, brain-hands]
---

## Tese Central

Arquitetura de três camadas para agents que fazem coisas: um brain (LangGraph) que decide deterministicamente, dois pairs de hands (Azure Container Apps Dynamic Sessions para one-shot stateless, ACA Sandbox para stateful work), e graph state que carrega evidence entre steps. A regra arquitetural fundamental: judgment é a única coisa que brain delega a model. Tudo mais é code. Um dos pairs de hands pode segurar um brain próprio dentro do sandbox.

## Pontos-Chave

1. **Three problems agents create com hands**: (1) Non-determinism — model decide ordem de operations que são product decisions; (2) Dangerous code — probabilistic process com deterministic side effects; (3) State across steps — workspace precisa sobreviver entre calls.
2. **Brain = LangGraph deterministic graph**: StateGraph com typed annotation, addNode/addEdge. Nove nodes em linha reta. Apenas um node (squadTechDesign) permite judgment. Outros são plain TypeScript ou single bounded SDK call. State é uma typed shape, cada node retorna partial update.
3. **Judgment via Squad custom agent**: Copilot SDK session registra custom agent "squad", agent usa repo-local team context como working memory, retorna typed DispatchRecord. Squad's internal members nunca aparecem no LangGraph state — brain vê um public custom agent e um structured result.
4. **Hands 1: ACA Dynamic Sessions**: Pool de pre-warmed containers. POST com bearer token + opaque identifier. Container tear-down ao finish. Stateless, one-shot, deterministic. Egress disabled no pool level. Roda deterministic function — no shell, no model.
5. **Hands 2: ACA Sandbox workspace**: Para work stateful — checkout repo, toolchain, files, analysis. Resultado de step 1 é input de step 3.
6. **Regra**: "Judgment is the only thing the brain delegates to a model. Everything else is code." Deterministic substitution (MySQL→Azure SQL) é switch statement, não agent.
7. **Disposable agents, memory in Git**: Agents são descartáveis; memory sobrevive em Git, não em agent session.

## Conceitos

- **Brain-hands architecture**: brain (deterministic graph) decide, hands (sandboxes) executam
- **Judgment node**: único node no graph que delega a model — resto é code
- **Disposable agents, memory in Git**: agents descartáveis, estado persiste em Git
- **ACA Dynamic Sessions**: pool stateless one-shot com egress disabled
- **DispatchRecord**: typed contract que Squad preenche mas não pode widen

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-platform-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[03-RESOURCES/entities/Microsoft]]