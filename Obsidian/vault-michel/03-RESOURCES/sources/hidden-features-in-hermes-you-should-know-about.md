---
title: "Hidden features in Hermes you should know about"
type: source
source: "Clippings/Hidden features in Hermes you should know about.md"
created: 2026-06-19
ingested: 2026-06-21
tags: [articles, hermes-agent]
---

## Tese central
Coletânea crowdsourced de features pouco conhecidas do Hermes Agent (Nous Research): handoff cross-plataforma de sessão, resume de sessão CLI, mecânica interna de compressão de contexto, conexão a browser local via CDP, e API REST própria do dashboard.

## Argumentos principais
- `/handoff <plataforma>` transfere uma sessão viva (mesmo session id, transcript completo, tool calls) entre CLI/Telegram/Discord/Slack sem reiniciar a thread — é a mesma conversa continuando em outra superfície, não um novo contexto.
- Compressão de contexto dispara em ~50% do limite por padrão: mantém os 3 primeiros turnos + ~20 últimos, sumariza o meio — detalhes do meio de sessões longas podem se perder, causando retrabalho do agente. Três alavancas de mitigação em `config.yaml` hot-reloadable: `protect_last_n`, `auxiliary.compression.model` (modelo barato para o sumarizador), `model.context_length`.
- `/browser connect` anexa as ferramentas de browser do Hermes ao Chrome/Brave/Chromium/Edge já em execução do usuário via Chrome DevTools Protocol — usa cookies/sessões já logadas, evita custo de cloud-browser, e é observável em tempo real.
- O dashboard web expõe uma REST API própria que o frontend consome — pode ser chamada diretamente para automação (histórico de sessão, busca full-text, etc).

## Key insights
- A mecânica "mantém início+fim, sumariza meio" da compressão de contexto é um padrão de janela deslizante assimétrica — útil como referência de design caso o vault ou Nexus precise implementar gestão de contexto longo em sessões multi-turno próprias.
- Handoff de sessão "mesmo id, surfaces diferentes" é um padrão de continuidade que poderia inspirar como o Nexus trata sessões do usuário entre CLI e outras interfaces futuras.

## Exemplos e evidências
- Lista crowdsourced de 5+ features com links de documentação oficial Hermes para cada uma.

## Implicações para o vault
Aprofunda conhecimento operacional sobre Hermes Agent já presente em `[[03-RESOURCES/entities/Hermes-Agent]]` — útil referência técnica caso o vault avalie usar Hermes como camada de automação cross-plataforma.

## Links
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
