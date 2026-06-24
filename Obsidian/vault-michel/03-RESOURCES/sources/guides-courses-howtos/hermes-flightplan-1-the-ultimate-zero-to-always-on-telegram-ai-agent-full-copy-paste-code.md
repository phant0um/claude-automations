---
title: "Hermes Flightplan 1 — The Ultimate Zero to Always-On Telegram AI Agent"
type: source
source: Clippings/Hermes Flightplan 1 The Ultimate Zero to Always-On Telegram AI Agent (Full Copy-Paste Code).md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, hermes, telegram, deployment, infrastructure]
---

## Tese central

Guia completo para instalar Hermes Agent como gateway Telegram always-on: roda como usuário normal, sobrevive crash e reboot via managed service, locked à sua conta. Dois paths (VPS Ubuntu ou Mac), mesmo fluxo — só muda install command e durability layer.

## Argumentos principais

1. **Pré-requisitos mínimos**: VPS 4GB RAM (Hetzner CX23 $7.79/mês) ou Mac Apple silicon. SSH key, Telegram account, model com 64k+ context. Nous Portal = OAuth, sem API key em arquivo.
2. **Hardening em uma passada**: `secure-box.sh` faz apt upgrade, 2GB swapfile, non-root sudo user, key-only ssh, root login off, firewall só ssh. Tudo antes de colocar agent na box.
3. **Managed service**: gateway roda como serviço gerenciado — volta após crash ou reboot. No VPS é systemd; no Mac é launchd.
4. **Lock à conta**: Telegram bot locked à sua conta apenas — nenhum outro usuário pode interagir.
5. **Hermes Agent v0.16.0**: roda como gateway, você mensagemia via Telegram, agent processa com model configurado.

## Key insights

- Durability layer é fiddlier no macOS (launchd) vs Linux (systemd) — mas ambos funcionam
- $7.79/mês VPS é o custo de entrada mínimo para agent always-on
- OAuth (Nous Portal) > API key em arquivo — menos superfície de ataque
- Hardening antes do agent, não depois — box limpa antes de expor qualquer serviço
- "It is one route" — VPS e Mac share everything exceto install command e durability layer

## Exemplos e evidências

- Hetzner CX23: 2 vCPU, 4GB RAM, 40GB disk, Ubuntu 24.04.4 LTS, $7.79/mês
- Mac Mini M4, macOS 15 — custo zero além do model
- `secure-box.sh`: hardening em uma passada
- Hermes Agent v0.16.0 em ambos os paths

## Implicações para o vault

- **Core obsession**: Hermes Agent é o runtime deste próprio operador (Nexus). Este guide é a receita de deploy do sistema onde o vault roda.
- **Diretamente aplicável**: Michel pode usar este guide para deploy always-on do Hermes Agent que opera o vault
- **Complementa**: [[03-RESOURCES/entities/Hermes-Agent]] (se existe)

## Links

- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/concepts/agent-systems]]
- [[04-SYSTEM/agents/nexus-agent-system/nexus]]- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]] — Flightplan implements level 4-5 of Hermes Agent taxonomy
