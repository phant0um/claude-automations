---
title: "Nessie — context layer para histórico de conversas de IA (Claude, ChatGPT, Obsidian)"
type: source
source: "Clippings/Nessie.md, Clippings/Nessie - Obsidian.md"
created: 2026-06-14
tags: [source, ai-agents-harness, agent-memory, context-management, pkm-obsidian-second-brain, nessie]
---

Entity: [[03-RESOURCES/entities/Nessie]]

## Tese central

Nessie (nessielabs.com) é um produto que se posiciona como "context layer
para trabalho AI-native": ingere histórico de conversas de múltiplas
ferramentas de IA (Claude, ChatGPT, Gemini, Perplexity, Cursor, Codex,
Claude Code, Claude Cowork, OpenClaw) e vaults Obsidian, indexa tudo numa
"Library" pesquisável, e expõe via CLI/MCP para que agentes consultem
contexto histórico ("o que decidimos sobre pricing?") em vez de
re-explicar do zero em cada sessão nova.

---

## 1. Make your thinking legible to every AI you use (landing page)

Source: [nessielabs.com](https://nessielabs.com/)

### Argumentos principais

- **Problema de fragmentação**: estratégia acontece no Claude, pesquisa no
  ChatGPT, build no Claude Code — cada sessão nova exige re-explicar
  contexto, e insights de colegas/agentes se perdem entre runs.
- **Agentes consultam histórico via CLI/MCP**: comando `/nessie` dentro do
  Claude Code (ou qualquer agente MCP-compatible) busca em transcripts e
  conversas passadas e retorna "contexts" sintetizados — ex.: pergunta
  "what did we decide about the pricing model?" retorna resumo sintetizado
  de 11 conversas cruzando Claude/ChatGPT/Gemini, com fonte rastreável
  (1 context, 11 threads, 3 tools).
- **Integração via MCP server**: conecta a Claude, ChatGPT ou qualquer
  cliente MCP-compatible — contexto/transcripts/profile disponíveis
  inline na conversa, sem app-switching ou copy-paste.
- **Sync contínuo e retroativo**: conecta uma integração uma vez, Nessie
  faz backfill de todo histórico disponível daquela fonte, depois
  mantém sync incremental automático. Fontes: ChatGPT, Claude, Gemini,
  Perplexity, OpenClaw, Codex, Cursor, Claude Cowork, Claude Code,
  Obsidian.
- **"Contexts" compostos**: artefato central é o "context" — documento
  sintetizado a partir de múltiplas fontes/conversas (ex.: "April investor
  brief — synthesized from 14 sources across 6 tools and workspaces", com
  seções "What shifted this month" e "Open questions").
- **Local-first e privacidade**: histórico fica no Mac do usuário por
  padrão; Cloud Sync é opcional (necessário para MCP remoto, teams,
  múltiplos dispositivos). Credenciais nunca saem da máquina.

### Posicionamento explícito

"No. You keep using ChatGPT, Claude, Codex, Claude Code, Cursor [...].
Nessie sits above them as the shared memory and context layer." — não é
mais um chat app, é uma camada de memória/contexto que fica acima das
ferramentas existentes.

---

## 2. Obsidian Integration (docs)

Source: [nessielabs.com/docs/obsidian](https://nessielabs.com/docs/obsidian)

### Argumentos principais

- **Setup**: Settings → Integrations → Add integration → Obsidian →
  selecionar pasta do vault que já contenha `.obsidian` → Connect.
- **Como o sync funciona**: integração local — Nessie lê todos os
  markdown files do path selecionado e importa para a Library, tornando-os
  pesquisáveis/citáveis/usáveis como fontes (sources).
- **Preserva hierarquia do vault**: o vault aparece como source root
  próprio; pastas continuam navegáveis; arquivos markdown se tornam notas
  pesquisáveis; arquivos deletados/movidos são limpos no próximo sync.
- **Agentes navegam a estrutura**: agentes podem explorar a árvore de
  pastas do vault antes de buscar, depois restringir a busca a um vault
  ou pasta específica para contexto mais estreito.
- **Múltiplos vaults**: suporta conectar mais de um vault Obsidian, cada
  um como source root separado em Library/MCP/CLI discovery.
- **Storage**: notas do Obsidian ficam locais por padrão; com Cloud Sync
  habilitado, podem ser armazenadas na Nessie Cloud (disponível para MCP,
  Teams, múltiplos devices). Vault local permanece intacto, desconectável
  a qualquer momento.

---

## Implicações para o vault

Nessie é conceitualmente próximo de
[[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]] (camada de
memória cross-session/cross-tool) e do padrão "Obsidian como
segundo cérebro consultável por agentes" já discutido em
`pkm-obsidian-second-brain/`. Diferencial específico: Nessie sintetiza
**contexts** a partir de múltiplas conversas/ferramentas (não só indexa
arquivos), e expõe isso via MCP — relevante se o usuário considerar
ferramentas externas de "context layer" para complementar a memória nativa
do Claude Code (`.claude/`, STATE.md, hot.md) descrita nos ensaios de
[[03-RESOURCES/sources/ai-agents-harness/fable5-self-improving-system-14-steps|STATE.md de 5 seções]]
e [[03-RESOURCES/sources/ai-agents-harness/log-is-the-agent|log-is-the-agent]]
(splitted de agent-design-essays-2026-06 em 2026-06-19).
Trade-off a notar: introduz uma camada externa (SaaS, possível Cloud Sync)
sobre dados hoje 100% locais no vault — avaliar antes de adotar.

## Links

- [Nessie — landing page](https://nessielabs.com/)
- [Nessie — Obsidian integration docs](https://nessielabs.com/docs/obsidian)
