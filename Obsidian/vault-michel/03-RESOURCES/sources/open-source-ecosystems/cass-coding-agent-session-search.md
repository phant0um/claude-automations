---
title: "cass — Unified TUI/CLI para busca de histórico de sessões de agentes de código"
type: source
source: "Clippings/Dicklesworthstonecoding_agent_session_search Unified TUI and CLI to index and search your local coding agent session history across 11+ providers (Codex, Claude, Gemini, Cursor, Aider, etc.).md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, oss, cli, session-search, multi-provider, tui, rust, sqlite]
---

## Tese central

`cass` (coding-agent-search) é uma ferramenta OSS em Rust que unifica e indexa o histórico de sessões de 20+ agentes de código (Claude Code, Codex, Gemini CLI, Cursor, Aider, Cline, Hermes, Kimi Code, etc.) num índice único e pesquisável via TUI ou CLI, com suporte a busca lexical + semântica híbrida, modo robot para automação por agentes, e sincronização multi-máquina via SSH.

## Argumentos principais

- **Problema:** cada agente armazena dados de forma diferente (JSONL, SQLite, Markdown, JSON proprietário); sem visibilidade cross-agent; soluções obtidas em Cursor são invisíveis ao usar Claude Code; busca por arquivo (grep) não entende linguagem natural.
- **Solução:** normaliza formatos díspares num schema `Conversation → Message → Snippet` unificado, indexa com full-text search (BM25 + edge n-grams) e vetores semânticos locais (ONNX/FastEmbed), sem enviar dados para fora da máquina.
- **Busca híbrida:** lexical (BM25, sub-60ms) como caminho rápido obrigatório + semântica vetorial (MiniLM/Snowflake/Nomic) como enriquecimento opcional em background. Combina via Reciprocal Rank Fusion (RRF). Fail-open: sem modelo, usa apenas lexical.
- **Robot mode (--robot / --json):** API estruturada para consumo por agentes — stdout só dados, stderr só diagnósticos. Inclui `cass triage --json` como ponto de entrada seguro, self-documenting API (`capabilities`, `introspect`, `robot-docs`), e sintaxe forgiving (normaliza typos, case, snake_case, aliases, single-dash flags).
- **Token budget management:** `--fields minimal`, `--max-tokens`, `--limit`, `cass pack` (cited handoff com budget de tokens, freshness policy, privacy metadata).
- **Provenance tracking:** cada conversa rastreia `source_id`, `source_kind` (local/remote), `workspace_original`.
- **Multi-machine:** sync via rsync/SSH, additive-only (sem deletar local), configuração via `sources.toml`.
- **20 providers suportados:** Codex, Claude Code, Gemini CLI, Cline, OpenCode, Amp, Cursor, ChatGPT, Aider, Pi-Agent, GitHub Copilot Chat, Copilot CLI, OpenClaw, Clawdbot, Vibe, Crush, Hermes, Kimi Code, Qwen Code, Factory (Droid).
- **Durabilidade de índice lexical:** atomic swap (renameat2 no Linux) — leitores nunca veem índice parcialmente construído.
- **Schema stability:** contrato JSON pinado por golden-file regression tests.

## Key insights

- O histórico de sessões de agentes de código é um **knowledge base institucional** subutilizado — `cass` o transforma em memória de longo prazo acessível a futuros agentes.
- "Cross-agent knowledge": Claude Code pode buscar soluções encontradas por Codex em sessões passadas — quebra silos entre ferramentas.
- `cass pack` resolve o problema de handoff entre agentes com budget de tokens: gera artifact citado, compacto, com metadata de freshness e privacidade.
- Nunca executar `cass` sem `--robot` ou `--json` em contexto de agente — lança TUI interativo.
- Modelo semântico é opt-in (`cass models install`) — zero download automático, funciona air-gapped.
- Swarm operations (`cass swarm status/work-packet/lint`) para coordenação multi-agente num repo compartilhado.
- Forgiving syntax: 23 camadas de normalização de input cobrem os erros mais comuns de LLMs ao chamar CLIs.

## Exemplos e evidências

- Latência de busca: sub-60ms com edge n-gram indexing.
- Três embedders: `all-minilm-l6-v2` (~90MB, padrão), `snowflake-arctic-s` (~120MB), `nomic-embed` (~270MB).
- Instalação: `curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_session_search/main/install.sh | bash -s -- --easy-mode --verify`
- Homebrew: `brew install dicklesworthstone/tap/cass`
- Exit codes semânticos: 0=sucesso, 1=health check falhou, 3=índice/DB ausente (retryable), 5=corrupção de dados, 15=embedder indisponível.
- Repo: [github.com/Dicklesworthstone/coding_agent_session_search](https://github.com/Dicklesworthstone/coding_agent_session_search)

## Implicações para o vault

- Ferramenta diretamente útil para Michel: indexar histórico de Claude Code local e buscar soluções de sessões passadas antes de resolver problemas do zero.
- Integra com [[03-RESOURCES/entities/hermes]] (suporta Hermes como provider).
- Padrão `cass pack` como cited handoff é relevante para design de outputs dos agentes do vault.
- Conceito de "knowledge base de sessões de agentes" complementa [[03-RESOURCES/concepts/second-brain]].
- Swarm operations e provenance tracking são conceitos a integrar em [[03-RESOURCES/sources/ai-agents-harness/coding-agents-need-trust-layer-bibryam]].

## Links
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/concepts/second-brain]]
