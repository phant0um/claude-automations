---
title: "Generative UI Is the New Frontend"
type: source
source: "Clippings/Generative UI Is the New Frontend.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, generative-ui, frontend, ag-ui, a2ui, copilotkit, mcp]
---

## Tese central

Generative UI — interfaces geradas em tempo real pelo agente a partir do que o usuário pediu — é o novo frontend, e existem três padrões arquiteturais distintos (Controlled, Declarative/A2UI, Open-ended) que a maioria dos times adota sem saber que escolheu, com consequências arquiteturais sérias a escala.

## Argumentos principais

- O protocolo stack: MCP conecta agentes a ferramentas, A2A conecta agentes entre si, AG-UI conecta agentes a usuários (streaming layer via SSE, estado bidirecional).
- Três padrões: Controlled (frontend pré-constrói componentes, agente escolhe qual renderizar), Declarative/A2UI (agente emite schema JSON, frontend mapeia para componentes via catálogo), Open-ended (agente escreve HTML raw, app renderiza em sandbox).
- A escolha errada tem custos reais: Controlled escala linearmente com casos de uso (25 componentes = 10K tokens por turn); Open-ended tem inconsistência de marca inaceitável para produção.

## Key insights

- Token math de Controlled: ~400 tokens por tool description com schema JSON; 25 componentes = 10.000 tokens em todo turn antes de qualquer input do usuário.
- A2UI (Declarative): 50 ou 500 tipos de card — o agente sempre vê apenas uma função; tokens por turn ficam flat conforme a biblioteca cresce.
- "O LLM é dono do layout" em Declarative — output varia run-to-run dentro do catálogo. Para legal disclosures ou pixel-perfect placement, não usar.
- Open-ended: brand inconsistency é o killer — "Neo-brutalist on Tuesday, iOS 4 clone on Wednesday." Útil apenas para one-shot queries descartáveis.
- Shared state entre agente e frontend (via Python tool que escreve em session state) elimina segundo LLM call para atualizar UI.
- Decisão: Designer tem mockups pixel-perfect? → Controlled. Dezenas de card types? → Declarative. One-shot visualization? → Open-ended. Default: Declarative.
- "A maioria dos times defaulta para Controlled porque o framework defaulta para Controlled. Batem na parede em 25 componentes e vão para Open-ended porque parece impressionante em demos. Nenhuma foi uma decisão."

## Exemplos e evidências

- AI Financial Coach Agent: renderiza cards de budget, savings plans e debt payoff usando Controlled pattern.
- AI Dashboard Canvas Agent: pin de métrica no chat redesenha painel sem segundo model call — via shared state.
- AI Deep Research Agent: plan, searches e file writes streamam como live cards.
- MCP Apps: Excalidraw controlado pelo agente para diagramas; booking de voos e hotéis dentro do chat window.
- AI MCP App Builder: agente escreve app em sandbox E2B e renderiza live.

## Implicações para o vault

- O protocolo AG-UI é relevante para qualquer integração de agentes do vault com interfaces web.
- O framework de decisão Controlled/Declarative/Open-ended é útil para design de outputs de agentes (quando gerar texto vs schema vs HTML).
- CopilotKit como biblioteca que suporta todos os três padrões no mesmo runtime é referência para projetos futuros.
- O conceito de "catalog as contract" (typos viram build errors) é bom padrão para interfaces typed entre agentes.

## Links

- [[03-RESOURCES/concepts/ai-agents/generative-ui]]
- [[03-RESOURCES/concepts/ai-agents/agent-protocols]]
- [[03-RESOURCES/concepts/ai-agents/mcp-model-context-protocol]]
