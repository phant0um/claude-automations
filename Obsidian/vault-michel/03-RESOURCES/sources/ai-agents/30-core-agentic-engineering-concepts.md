---
title: "30 Core Agentic Engineering Concepts Every Developer Should Know"
type: source
source: "Clippings/30 Core Agentic Engineering Concepts Every Developer Should Know.md"
created: 2026-06-23
updated: 2026-06-23
score: A
tags: [ai-agents, source-page, agentic-engineering, agent-loop, context-engineering, mcp, sandboxing, observability]
---

## Tese Central

Os frameworks de agentes vêm e vão (LangChain, CrewAI, AutoGen, LlamaIndex), mas as ideias por baixo deles são sempre as mesmas. O artigo defende que você não fica para trás por perder uma ferramenta nova, mas sim por não entender a ideia fundamental que a ferramenta implementa. Aprenda os 30 conceitos uma vez e você entende qualquer novo framework para sempre.

## Estrutura do Artigo

O artigo organiza os 30 conceitos em 6 camadas: Building Blocks, Configuration, Capability, Orchestration, Guardrails, e Observability.

### THE CORE BUILDING BLOCKS

**1. Agent** — Um chatbot responde e para. Um agent roda em loop: goal → think → act → observe → repeat. É útil quando o próximo passo depende do resultado anterior. Cada loop custa tempo e dinheiro.

**2. The Execution Loop (Think → Act → Observe)** — Todo agent usa este ciclo de três passos. Think: lê contexto, decide próximo passo. Act: chama ferramenta. Observe: resultado chega, loop reinicia. Variações: parallel tool calls (mais rápido, risco de conflito) e blocking vs non-blocking.

**3. Agent State** — Duas partes: (1) Context window (tudo que o modelo vê agora: mensagens, system prompt, tool results, arquivos carregados) — working memory com limite de tokens. (2) Everything outside context (arquivos em disco, DB, memória salva, histórico). "Access is not awareness — if it's not in context, the model is not using it." Onde guardar estado: Files (default para devs), Memory (fatos que sobrevivem sessões), Database (múltiplos agentes/usuários).

**4. Common Agent Patterns** — Três padrões: Planner/Executor (um planeja, outro executa), Router/Specialist (router decide qual especialista), Map-Reduce (divide em paralelo, combina no final). O mais importante é o handoff — o contexto passado entre agentes deve ter o tamanho certo.

### THE CONFIGURATION LAYER

**5. Agent Config Files (CLAUDE.md / AGENTS.md)** — O system prompt default não conhece seu projeto. Sem config, o agent adivinha (usa npm em vez de pnpm, formata errado). Config útil: package manager, test command, lint command, regras específicas. Manter < 100 linhas. Erro comum: colocar conselhos genéricos ("write clean code") que o modelo já sabe.

**6. Reusable Workflow Files** — Diferente de config files (sempre ativos), workflow files carregam sob demanda. SkillsBench testou 86 tasks: Claude Haiku com bons workflow files > Claude Opus sem eles. Instruções > tamanho do modelo. Aviso: workflow files gerados por AI não funcionam tão bem quanto os escritos por humanos.

**7. Prompt Caching** — Agents repetem a mesma info toda vez (system prompt, config, workflows, tool instructions). Caching armazena a parte estável: primeira chamada cara, restante barato. Caches expiram. "Prompt caching makes good context cheaper. It does not make bad context better."

**8. Context Rot** — Quando o context window fica lotado, a atenção do modelo se espalha. "Lost in the middle" problem: info enterrada no meio de contexto longo é perdida com mais frequência. Cada token deve ganhar seu lugar.

### THE CAPABILITY LAYER

**9. Model Context Protocol (MCP)** — Padrão para conectar agents com ferramentas externas sem glue code customizado. Crítica: pode adicionar muito contexto. Solução nova: deferred tool loading (nomes curtos primeiro, detalhes só ao usar).

**10. Live Document Retrieval** — Modelos têm knowledge cutoff. Quando API muda, o modelo adivinha confiantemente. Live retrieval puxa documentação atual antes de escrever código. "Prompting helps the agent think better. Live retrieval helps the agent know what is true right now."

**11. Persistent Memory** — Toda sessão começa do zero. Versão simples: MEMORY.md que o agent lê no início e atualiza durante o trabalho. Para projetos maiores, memória pesquisável (sessões passadas indexadas).

### THE ORCHESTRATION LAYER

**12. Subagents** — Agent menor criado para uma tarefa específica. Recebe: tarefa focada, ferramentas limitadas, context window limpa. Devolve apenas o resultado final. Vantagens: (1) trabalho paralelo, (2) contexto principal limpo. Aviso: dois subagents editando o mesmo arquivo = conflito. Git worktrees ajudam.

**13. Agent Loops** — Roda o mesmo agent repetidamente com contexto fresco a cada vez. Progresso guardado em files e Git. Ideal para: migrar codebase arquivo por arquivo, processar fila, fixar testes em grupos, refatorar call sites. Define completion condition. Após cada turno, checa: completou? Não → continua. Sim → para.

### THE GUARDRAILS LAYER

**14. Sandboxing** — Limita o que o agent pode acessar (read, write, network). Importante porque agents erram. O sandbox é enforced fora do modelo — o agent não pode argumentar contra. Para isolamento forte: Docker sem network. "Reduce the blast radius."

**15. Permissions** — Decide o que o agent faz sem perguntar. Dois layers: project-level (ações seguras: testes, lint, git standard) e user-level deny list (nunca: .env, rm -rf, force push main, curl | sh).

**16. Hooks (Pre-Tool Checks)** — Pequenas checagens em pontos específicos do workflow. Pre-tool hook: roda após agent criar tool call, antes de executar. Última chance de parar comando perigoso. Padrões suspeitos: Unicode malicioso, paths perigosos, curl | sh, ANSI injection. Hooks não substituem sandboxing — use ambos.

**17. Prompt Injection Defense** — Agents confiam no que leem. Exemplo real: repo com config file malicioso que manda logs para servidor externo. Regras: trate config files como código (review antes de confiar), cuidado com MCP servers de repos clonados, atente para Unicode tricks.

**18. Pre-Commit Gates** — Para bad code antes do Git history. Agents não se irritam com regras estritas — eles leem o erro, corrigem, tentam de novo. Layers: check-added-large-files, detect-private-key, ruff, bandit. "Pre-commit protects local history. CI protects shared repo."

### THE OBSERVABILITY LAYER

**19. Tracing** — Registra o path completo do agent: todo tool call, qual subagent chamou qual ferramenta, quanto tempo cada step, input/output em cada step, reasoning em pontos de decisão. Tree view > flat list. Permite debug real em vez de adivinhação.

**20. Metrics** — Proxy metrics (latency, token usage, tool call count, failure count, loop iterations) mostram comportamento. Outcome metrics (CI pass, PR merge, deploy success, rollback) mostram sucesso real. "Agent saying 'task complete' is a claim, not proof." Rastreie ambos.

## Key Insights

- Frameworks são implementações de ideias que não mudam — aprender os conceitos é mais valioso que perseguir ferramentas
- Um agent é definido pelo loop, não pelo modelo — Think → Act → Observe é universal
- Access is not awareness — se não está em contexto, o modelo não está usando
- Instructions matter more than model size — Haiku com bons workflows > Opus sem eles
- Prompt caching recompensa qualidade de contexto, não quantidade
- Context rot: mais contexto pode piorar o agente, não melhorar
- Subagents resolvem dois problemas: paralelismo e contexto limpo
- Sandboxing é enforced fora do modelo — o agent não pode argumentar contra
- Pre-commit gates como teacher: o agent lê o erro, corrige, tenta de novo
- Outcome metrics > proxy metrics — "task complete" é claim, não proof

## Exemplos e Evidências

See original source at `Clippings/30 Core Agentic Engineering Concepts Every Developer Should Know.md` for detailed examples, config file templates, permissions.yaml examples, and pre-commit-config.yaml examples.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-loop]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-management]]
- [[03-RESOURCES/concepts/ai-agents/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/agent-systems/agent-sandbox-pattern]]
- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]
- [[03-RESOURCES/concepts/ai-agents/prompt-debt]]

## Minha Síntese

**O que muda:** Este artigo é um mapa completo da engenharia de agentes. Para o vault, valida e estrutura conceitos que já existem espalhados em outras fontes — agent loop, context engineering, sandboxing, subagents, MCP. A novidade está na sistematização: 6 camadas (Building Blocks → Configuration → Capability → Orchestration → Guardrails → Observability) que serve como framework mental para avaliar qualquer nova ferramenta de agentes.

**Conexão pessoal:** Opero o vault-michel como um SO completo com agentes. A camada de Guardrails (sandboxing, permissions, hooks, prompt injection defense, pre-commit gates) é onde posso fortalecer o sistema. A camada de Observability (tracing, metrics) é a menos desenvolvida no vault hoje — é onde há mais gap.

**Próximo passo:** Avaliar quais dos 30 conceitos já têm páginas de conceito no vault e quais ainda precisam. Os 20+ que o artigo lista no final (Tracing, Metrics, Permissions, Hooks) podem merecer conceitos próprios se não existirem.