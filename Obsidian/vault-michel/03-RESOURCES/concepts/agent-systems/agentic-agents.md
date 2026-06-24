---
title: Agentic Agents — AI Agents e o Agentic Loop
type: concept
status: developing
tags: [ai-agents, agentic-loop, tools, llm, autonomous]
created: 2026-04-20
updated: 2026-04-20
---

# Agentic Agents — AI Agents e o Agentic Loop

## O que é um AI Agent

Software que pode interagir com seu ambiente e executar ações para completar um objetivo definido. No núcleo: um LLM operando em um **loop em tempo real**.

Agentes podem ter acesso a:
- **Tools** — ferramentas (busca web, leitura de arquivos, execução de código)
- **External services** — APIs, bancos de dados, apps externos
- **Other AI agents** — subagents, orquestradores

**Diferença fundamental vs LLM comum:** LLMs retornam texto. Agentes retornam texto *e* executam ações no mundo real.

---

## O Agentic Loop

Ciclo central de qualquer agente:

```
Prompt → Gather Context → Tool Call → Action → Verify Results
                ↑___________________________|  (se incompleto, loop)
```

1. **Prompt** — usuário define objetivo
2. **Gather Context** — modelo retorna texto ou tool call
3. **Action** — executa (editar arquivo, rodar comando, buscar web)
4. **Verify** — resultado atingiu o objetivo?
5. **Loop ou finaliza** — se não, tenta novamente com novo contexto

Em qualquer ponto do loop, o usuário pode adicionar contexto, interromper ou redirecionar.

---

## Componentes de um Agente

### Context Window (Memória de Trabalho)
Quantidade de informação que o modelo pode manter ativa. Finita — gerenciamento é crítico.
Ver [[03-RESOURCES/concepts/llm-ml-foundations/context-window]].

### Tools
O backbone de como agentes funcionam. Definem *quando* e *como* executar código para avançar em direção ao objetivo.

Exemplos: leitura de arquivo, busca web, execução de shell, chamadas de API.

### Permissions
Controle sobre o que o agente pode fazer sem aprovação humana. Espectro de hands-on (aprovação em tudo) a hands-off (execução autônoma).

---

## Claude Code como Agente

O [[03-RESOURCES/entities/Claude Code]] é o caso prático central no vault:

- **Agentic loop completo:** lê codebase → decide ações → executa → verifica
- **Tools nativos:** edição de arquivo, terminal, busca web
- **Permissions configuráveis:** Default, Auto-accept, Plan Mode
- **Subagents:** delega tarefas com contexto isolado

### Plan Mode — Agência Controlada
Modo read-only: agente só reúne informação, não age. Permite revisar plano antes de execução. Reduz erros em mudanças complexas.

---

## Subagents — Agentes Dentro de Agentes

Agentes podem criar e coordenar outros agentes. Cada subagent tem seu próprio context window isolado.

**Padrão:** agente principal delega tarefa → subagent executa heavy lifting → retorna apenas summary ao principal.

Resultado: contexto do principal fica limpo; paralelismo real.

Ver [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] para padrões avançados.

---

## Riscos e Limites

- **Erros propagam:** agente pode mal interpretar intenção, introduzir bugs, over-engineer
- **Context window finita:** sessões longas degradam performance — ver [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]]
- **Permissions amplas = risco maior:** auto-execução de comandos sem aprovação pode causar danos difíceis de reverter
- **Tool calls custam contexto:** cada tool call + resultado consome espaço

---

## Onde Aparece no Vault

- [[03-RESOURCES/sources/guides-courses-howtos/claude-code-101]] — fundamentos do Claude Code como agente
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] — workflow EPCC para uso efetivo de agentes
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — padrões de coordenação
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — agentes que modificam seus próprios protocolos
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]] — agents that learn from human feedback via skill-as-code + daily PR
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]] — gerenciamento da memória do agente
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — como agentes conectam a ferramentas externas
