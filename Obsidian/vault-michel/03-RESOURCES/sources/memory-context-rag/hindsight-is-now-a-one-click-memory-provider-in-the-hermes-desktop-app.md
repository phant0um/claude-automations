---
title: "Hindsight — One-Click Memory Provider in Hermes Desktop App"
type: source
source: Clippings/Hindsight Is Now a One-Click Memory Provider in the Hermes Desktop App.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, hermes, memory, hindsight, ux]
---

## Tese central

Hermes desktop app agora tem configuração in-app de Hindsight como memory provider — sem editar config.json ou .env. Select mode, paste API key, save. Hindsight é o único memory provider no Hermes com full settings panel.

## Argumentos principais

1. **Antes**: Hindsight era native memory provider mas exigia editar config.json ou .env — barreira para quem não vive no terminal
2. **Agora**: Settings → Memory & Context → Hindsight → form completo: Mode, API key, API URL, Bank ID, Recall budget
3. **Secrets handling**: API key vai para secret store (write-only, nunca lido de volta); resto vai para profile config
4. **Cloud mode fast path**: sign up free em ui.hindsight.vectorize.io, paste key, Hermes lembra across every session
5. **Único provider com panel**: outros memory providers renderizam nothing no dropdown

## Key insights

- "Supported" vs "two clicks away" — diferença entre existir e ser acessível
- Secrets como write-only no form é padrão de UX correto
- Memory provider pluggable é arquitetura — in-app config é UX layer que remove atrito
- Hindsight = vectorize cloud, modo self-hosted também disponível

## Implicações para o vault

- **Core obsession**: Hermes Agent é o runtime deste operador. Memory providers são centrais para a camada de memória do vault.
- **Complementa**: [[03-RESOURCES/concepts/memory-context-rag]]
- **Aplicável**: Michel pode ativar Hindsight no Hermes desktop para memória cross-session do próprio Nexus

## Links

- [[03-RESOURCES/concepts/memory-context-rag]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[04-SYSTEM/agents/nexus-agent-system/nexus]]