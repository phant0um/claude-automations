---
title: "agmsg — Comunicação direta entre agentes CLI (Claude Code ↔ Codex)"
type: source
source: "Clippings/Claude Code と Codex の往復コピペをやめたくて、agmsg を作った.md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, claude-code-cowork, multi-agent, agmsg, codex, sqlite, oss]
---

## Tese central

O desenvolvedor @fujibee percebeu que usava Claude Code e Codex em paralelo — Codex para revisão e casos difíceis, Claude Code para implementação diária — mas passava o dia copiando e colando mensagens entre os dois. Criou o **agmsg**, uma OSS que permite que agentes CLI se comuniquem diretamente via SQLite compartilhado, eliminando o "problema do pombo-correio humano".

## Argumentos principais

- **Divisão orgânica de papéis:** Claude Code (Opus 4.6) como driver diário de implementação; Codex (GPT-5.3) como consultor de revisão e casos complexos — não hierarquia, apenas personalidades diferentes.
- **Problema real:** copiar/colar mensagens entre dois agentes dezenas de vezes por dia quebra o flow, consome atenção e causa erros de colagem.
- **Solução mínima:** agmsg usa apenas `bash` + `sqlite3` — sem daemon, sem servidor, sem Python, sem rede. Roda em qualquer ambiente do dia 1.
- **SQLite WAL mode:** substitui arquivos de texto simples (usados inicialmente) por SQLite com Write-Ahead Logging, suportando múltiplos leitores + 1 escritor simultâneos sem race conditions.
- **Três modos de recepção:**
  1. **Manual** — usuário invoca `/agmsg` explicitamente
  2. **Hook (turn)** — verifica inbox a cada fim de turno via Stop hook (padrão Codex, que não tem Monitor)
  3. **Monitor** — subscrição contínua ao SQLite via Monitor do Claude Code; agente recebe mensagens em tempo real
- **monitor é o diferencial:** com ele, dois Claude Codes no mesmo "team" conversam autonomamente sem intervenção humana (demo: dois agentes jogando jogo da velha).
- **Agent Skills como base:** agmsg é implementado como habilidade via [agentskills.io](https://agentskills.io/), sem modificar o agente-host.
- **Dificuldade central de implementação:** Claude Code e Codex têm sistemas de hooks e configuração totalmente diferentes — a maior dificuldade foi criar uma abstração que funcionasse nas duas plataformas.

## Key insights

- A "camada mais idiota" entre dois agentes inteligentes estava sendo executada por um humano — isso é um padrão a eliminar sistematicamente.
- Claude Code tem Monitor + SessionStart hooks ricos; Codex não tem Monitor → necessidade de modo `both` (monitor principal + hook como seguro).
- Dois agentes com `monitor` no mesmo team operam autonomamente sem input humano — isto abre portas para orquestração assíncrona sem orquestrador central.
- Dependências mínimas (`bash` + `sqlite3`) = instalação one-liner, funciona em qualquer máquina sem configuração prévia.
- A escolha de SQLite WAL foi motivada por concorrência persistente — problema que texto simples não resolve quando há múltiplos agentes escrevendo simultaneamente.
- A experiência de ver 2 agentes jogarem jogo da velha sem intervenção humana revela o potencial de loops autônomos de multi-agente.

## Exemplos e evidências

- **Demo em vídeo:** dois Claude Codes jogando jogo da velha via agmsg sem input humano, ~5x acelerado.
- **Instalação:** `bash <(curl -fsSL https://raw.githubusercontent.com/fujibee/agmsg/main/setup.sh)`
- **Comandos:** `/agmsg` no Claude Code, `$agmsg` no Codex
- **Repositório:** [github.com/fujibee/agmsg](https://github.com/fujibee/agmsg)
- Autor voltou a escrever código de produção diariamente pela primeira vez em anos, graças à combinação Claude Code + Codex.

## Implicações para o vault

- Complementa [[03-RESOURCES/sources/ai-agents-harness/agent-neurological-conditions-openclaw-hermes]] — mais um caso de orquestração multi-agente via message-passing.
- Padrão "SQLite como bus de mensagens local" é reutilizável no próprio vault (processos paralelos que precisam coordenar).
- Reforça a ideia de separar agentes por personalidade/estilo em vez de capacidade bruta.
- Aponta necessidade de documentar diferenças de hooks entre Claude Code e Codex em [[03-RESOURCES/entities/Claude Code]].
- Conceito de "modo monitor vs. modo hook" é relevante para design dos agentes do vault.

## Links
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/concepts/multi-agent]]
