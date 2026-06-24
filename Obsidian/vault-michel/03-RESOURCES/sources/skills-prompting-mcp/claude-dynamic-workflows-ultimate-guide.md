---
title: "Claude Dynamic Workflows ULTIMATE GUIDE"
type: source
source: "Clippings/Claude Dynamic Workflows ULTIMATE GUIDE.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Dynamic Workflows são o recurso mais poderoso do Claude Code lançado recentemente: scripts JavaScript que orquestram dezenas a centenas de sub-agentes em paralelo, com verificação adversarial entre agentes, salvamento para reutilização, e resumibilidade em tarefas longas — transformando Claude num coordenador de workforce, não apenas um assistente.

## Argumentos principais

- Dynamic Workflows fazem três coisas únicas: fan-out paralelo de agentes, verificação adversarial cruzada entre agentes, e orquestração salva e reutilizável como slash command
- Diferença dos outros primitivos: Skills ensinam "como fazer", Plugins dão "acesso a ferramentas", Dynamic Workflows coordenam "um workforce inteiro"
- Para criar: basta usar a palavra "workflow" no prompt — Claude entra em modo de orquestração, escreve o script, mostra as fases, pede aprovação e executa
- UltraCode combina `xhigh` reasoning effort com orquestração automática de workflow — Claude planeja workflow para cada tarefa substantiva sem precisar pedir
- Workflows funcionam tanto no CLI quanto no desktop app

## Key insights

- O trigger mais simples do mundo: escrever "workflow" no prompt ativa o modo de orquestração
- `Alt + W` desativa o trigger para um prompt específico; `/config` permite desabilitar permanentemente
- `/deep-research` é o workflow bundled oficial para pesquisa multi-fonte — disponível imediatamente
- `/workflows` abre progress view em tempo real com controles: `p` (pause/resume), `x` (stop), `r` (restart agente), `s` (salvar como comando), `Enter` (drill-in)
- Custo: cada agente usa o modelo ativo na sessão — 100 agentes em Opus 4.8 custa muito mais que em Sonnet
- Combinar MCPs antes de workflows de pesquisa amplifica dramaticamente a qualidade

## Exemplos e evidências

- Exemplo real de uso: pipeline de conteúdo AI Edge (5 fases: angle → distribution → polish → visuals → export)
- `/deep-research` example: `What changed in the Node.js permission model between v20 and v22?`
- Prompt de pesquisa de mercado crypto: fan-out em dezenas de fontes simultâneas com cross-check
- Para ativar UltraCode: `/effort ultracode` no Claude Code CLI

## Implicações para o vault

Dynamic Workflows são o próximo layer acima de skills e subagents — aplicável ao pipeline de ingestão deste vault. O padrão de salvar workflows como slash commands é análogo ao sistema de skills do vault. Referência direta para [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]].

## Links

- [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/agent-systems/parallel-agent-code-review]]
