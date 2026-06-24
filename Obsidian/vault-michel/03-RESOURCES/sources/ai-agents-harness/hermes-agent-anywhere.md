---
title: "How to Access Your Hermes Agent Anywhere"
type: source
source: "Clippings/How to Access Your Hermes Agent Anywhere.md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, hermes, infrastructure, remote-access]
---

## Tese central

Agent local "autônomo" que só funciona em um computador não é realmente autônomo. Stack Tailscale + Termius + tmux resolve persistência e acesso remoto sem expor portas à internet pública.

## Argumentos principais

- **Problema**: agente local preso em uma máquina — connections SSH morrem ao mudar de rede, tasks longas interrompidas ao fechar laptop, sem acesso via celular
- **Tailscale**: cria rede mesh privada — acessa Mac Mini do MacBook, iPhone, onde estiver, sem port forwarding público
- **tmux**: persistência de sessão — agente continua rodando mesmo após desconexão SSH; reconecta e continua de onde parou
- **Termius**: cliente SSH mobile — acessa terminal do iPhone/iPad com boa UX
- **Hermes**: o agente que roda nessa infraestrutura

## Key insights

- Separação clara: Hermes = o agente; Tailscale + tmux + Termius = infraestrutura de acesso ao agente
- "Autonomous agent" requer infraestrutura de continuidade, não só modelo + skills
- tmux como mecanismo de persistência é simples e já amplamente disponível

## Implicações para o vault

- Vault roda em Mac local — mesma necessidade se precisar de acesso remoto
- tmux + Tailscale = solução imediata se acesso remoto ao vault for necessário

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
