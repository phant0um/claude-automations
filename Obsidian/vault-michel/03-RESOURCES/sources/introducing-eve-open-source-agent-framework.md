---
title: "Introducing eve, an open-source agent framework"
type: source
source: "Clippings/Introducing eve, an open-source agent framework.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
eve é um framework open-source da Vercel para construir, rodar e escalar agentes, onde um agente é literalmente um diretório de arquivos e produção (execução durável, compute sandboxed, aprovações human-in-the-loop, sub-agentes, evals) vem embutida por padrão — disponível em public preview.

## Argumentos principais
- Convenção sobre configuração: a estrutura de um agente eve é um diretório com `agent.ts` (modelo), `instructions.md` (identidade), `tools/` (o que pode fazer), `skills/` (o que sabe), `subagents/` (a quem delega), `channels/` (onde vive, ex: Slack), `schedules/` (quando age por conta própria).
- O agente mínimo funcional é apenas dois arquivos: um modelo e um conjunto de instruções — exemplo dado é `defineAgent({ model: "anthropic/claude-opus-4.8" })`.
- Instructions.md vira o "standing rules" prependado a toda chamada de modelo — identidade e regras persistentes, não reescritas a cada prompt.
- Adicionar tool, skill, channel ou schedule é simplesmente adicionar um arquivo — eve detecta e conecta em build time, sem boilerplate de registro manual.
- Scaffold de novo agente é um único comando (`npx eve@latest init my-agent`) que instala dependências, monta o projeto e inicia um dev server local em menos de um minuto; também pode ser delegado a um coding agent via prompt fornecido.
- Porque um agente eve é um projeto Vercel normal, `vercel deploy` leva para produção exatamente como rodou localmente — sem etapa de configuração de infra separada.
- eve é o framework que a própria Vercel usa para construir e rodar seus agentes internos.

## Key insights
- A escolha de "agente = diretório de arquivos" é o mesmo princípio adotado por outros frameworks recentes (Claude Code skills, .claude/agents) — convergência do setor para representar agentes como configuração declarativa em arquivo, não como código imperativo central.
- Produção (durabilidade, sandboxing, aprovações, sub-agentes, evals) vem de fábrica em vez de ser adicionada depois — inverte a ordem comum onde prototipagem rápida e produção são fases separadas com retrabalho entre elas.

## Exemplos e evidências
- Exemplo de agente "data analyst" com instructions.md completo (prefere números exatos, declara assumptions, usa tools em vez de chutar).
- Links para anúncio oficial (vercel.com/blog/introducing-eve), documentação (docs.eve.dev) e repositório (github.com/vercel/eve).

## Implicações para o vault
Adiciona outro ponto de dados ao padrão "agente = arquivo/diretório declarativo" já bem documentado neste vault via `agentsmd-pattern` e `claude-folder-anatomy`. Útil como referência comparativa caso o vault avalie frameworks de agente alternativos ao ecossistema Claude Code puro.

## Links
- [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]]
- [[03-RESOURCES/concepts/agent-systems/agent-platform-architecture]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/entities/Vercel]]
- [[03-RESOURCES/entities/Eve]]
