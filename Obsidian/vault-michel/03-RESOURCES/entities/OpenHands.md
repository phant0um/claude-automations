---
title: OpenHands
type: entity
tags: [agent-runtime, automated-software-engineer, openhands, multi-agent, open-source]
created: 2026-05-14
updated: 2026-05-19
---

# OpenHands

Runtime open-source para agentes de IA com foco em engenharia de software automatizada. Construído desde 2024 como sistema multi-agente desde a fundação.

## O que é

> "Define agents in code, then run them locally, or scale to thousands of agents in the cloud."

OpenHands fornece:
- SDK Python para definir e rodar agentes
- Multi-agent architecture nativa (orquestrador + subtarefas)
- Loop de ação-observação embutido
- Ferramentas: terminal, file editor, task tracker

## SDK básico

```python
from openhands.sdk import LLM, Agent, Conversation, Tool
from openhands.tools.terminal import TerminalTool
from openhands.tools.file_editor import FileEditorTool
from openhands.tools.task_tracker import TaskTrackerTool

agent = Agent(
    llm=LLM(model="anthropic/claude-sonnet-4-5-20250929"),
    tools=[
        Tool(name=TerminalTool.name),
        Tool(name=FileEditorTool.name),
        Tool(name=TaskTrackerTool.name),
    ],
)

conversation = Conversation(agent=agent, workspace=os.getcwd())
conversation.run()
```

## Loop de ação-observação

Do código do controller:

```python
def should_step(self, event: Event) -> bool:
    """
    The agent should take a step if it receives a message from the user,
    or observes something in the environment after acting.
    """
```

O agente age quando recebe mensagem **ou** quando recebe observação do ambiente. Continua até a task completar ou precisar de input humano.

## Multi-agent nativo

```
OpenHands is a multi-agentic system.
A subtask is a conversation between an agent and the user,
or another agent.
```

O orquestrador delega subtarefas para agentes especializados (backend, frontend, test, security, docs). Cada um trabalha em seu contexto isolado e reporta de volta.

## AGENTS.md

O repositório OpenHands serve como **referência canônica** para o padrão AGENTS.md — documenta para agentes como rodar, testar, o que não tocar, lockfile rules, pre-commit hooks obrigatórios.

## Ver também

- [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]] — padrão introduzido pelo OpenHands
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — arquitetura que OpenHands implementa
- [[03-RESOURCES/sources/ai-agents-harness/from-one-chatbot-to-131-specialists-agentsmd]] — análise do sistema
