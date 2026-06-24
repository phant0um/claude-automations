---
title: How to Build Multi Agent Workflows (Full Guide)
type: source
source: Clippings/How to Build Multi Agent Workflows  (Full Guide).md
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Sistemas multi-agente em 2026 têm uma pergunta definidora: como coordenar agentes que não podem compartilhar contexto sem se contaminar? O guia constrói o modelo mental desde os primitivos do Claude Code (subagents, agent teams, dynamic workflows) até os padrões de orquestração, modos de falha e a camada de governança necessária para produção.

## Argumentos principais

- O fracasso de sistemas multi-agente é quase sempre uma falha de runtime (coordenação, propagação de contexto, limites de permissão), não uma falha do agente individual.
- Agentes não devem se comunicar diretamente — devem escrever em uma camada de memória compartilhada (substrate) e ler dela.
- O orchestrator deve apenas decompor e rotear; raciocínio de domínio pertence a agentes especialistas.
- Dynamic Workflows (JavaScript) são a camada preferida para orquestrações repetíveis que devem sobreviver a limites de contexto.

## Key insights

- Três primitivos do Claude Code: Subagents (isolados, reportam ao orchestrator), Agent Teams (sessões paralelas com mailbox), Dynamic Workflows (script JS, até 1.000 agentes, 16 simultâneos, estado em variáveis de script fora de qualquer contexto).
- Seis topologias: Sequential Pipeline, Coordinator-Worker (Hub & Spoke), Parallel Fan-Out with Merge, Generator-Verifier, Shared-State, Debate (Adversarial Multi-Agent).
- Cinco modos de falha: Context Poisoning, Cascading Failure (taxa 41-86.7% sem orquestração própria), Scope Creep, Silent Substitution, Coordination Deadlock.
- Output contracts (JSON schema explícito) são obrigatórios para toda escrita no shared store.
- Regra 3-7 agentes por fase de workflow — acima disso, criar hierarquias com team leads.
- O maior erro arquitetural: roteiar resultados de agentes de volta pelo contexto do orchestrator — reconstrói o bottleneck de agente único com saltos de rede extras.

## Exemplos e evidências

- Parallel Fan-Out reduz tempo de processamento 60-80% para tarefas sem dependências de passo.
- Dynamic Workflows cortam custo de tokens 60-90% versus chaining sequencial porque resultados intermediários ficam em variáveis de script.
- Sistemas sem orquestração própria documentados com taxa de falha 41-86.7%.
- Exemplo de output contract para agente de security audit com campos: finding_id, file_path, severity, confirmed, suggested_fix.

## Implicações para o vault

- Referência completa para desenhar qualquer sistema multi-agente no vault — inclui checklist de pré-voo com 8 itens.
- A distinção substrate-mediated vs direct agent communication é um princípio arquitetural a adotar nos agentes internos do vault.
- A governança em 3 camadas (orchestrator / specialist agents / governance layer) mapeia diretamente para a arquitetura de agentes em 04-SYSTEM/agents/.

## Links

- [[03-RESOURCES/concepts/ai-agents/multi-agent-systems]]
- [[03-RESOURCES/concepts/ai-agents/dynamic-workflows]]
- [[03-RESOURCES/concepts/ai-agents/agent-orchestration]]
- [[03-RESOURCES/concepts/ai-agents/context-window-management]]
