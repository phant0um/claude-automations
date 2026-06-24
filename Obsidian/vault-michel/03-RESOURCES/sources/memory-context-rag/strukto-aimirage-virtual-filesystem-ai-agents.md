---
title: "strukto-ai/mirage: A Unified Virtual Filesystem For AI Agents"
type: source
slug: strukto-aimirage-virtual-filesystem-ai-agents
source: "https://github.com/strukto-ai/mirage"
author: strukto-ai (org)
created: 2026-05-09
updated: 2026-05-09
tags: [ai-agents, virtual-filesystem, vfs, tool-abstraction, bash, agent-infrastructure, strukto]
triagem_score: 8
---

# strukto-ai/mirage — A Unified Virtual Filesystem For AI Agents

**Mirage** is an open-source library by [[03-RESOURCES/entities/Strukto-AI]] that exposes every backend (S3, Google Drive, Slack, Gmail, Redis, GitHub, MongoDB, SSH, …) as a single Unix-style directory tree. AI agents navigate all services using a handful of bash-like commands instead of N SDKs.

## What AImirage Does

- **Single mount tree.** Every resource (`RAMResource`, `S3Resource`, `SlackResource`, `GDocsResource`, etc.) is mounted under `/path` in a `Workspace`. The agent issues `cat`, `cp`, `grep`, `find`, `ls` — all cross-resource.
- **Zero new vocabulary for LLMs.** Any model already trained on bash can use Mirage immediately; no new tool names or argument formats to learn.
- **Custom commands.** `ws.command('summarize', ...)` registers a new command available across all mounts. Commands can be scoped per resource + filetype (e.g., `cat` on a Parquet file renders rows as JSON).
- **Portable workspaces.** `ws.snapshot("demo.tar")` + `workspace load` let you clone, version, and transfer agent environments across machines with no reconfiguration.
- **Embedded SDKs.** Python (`mirage-ai`) and TypeScript (`@struktoai/mirage-node`, `@struktoai/mirage-browser`, `@struktoai/mirage-core`) let you embed a VFS inside FastAPI, Express, or any async runtime — no separate process.

## VFS Architecture

```
AI Agent / Application
        ↓
  Mirage Bash + VFS   ← single abstraction layer
        ↓
  Dispatcher & Cache  ← two-layer cache (Index + File; RAM or Redis backends)
        ↓
  Infrastructure & Remote  (S3, Slack, GDrive, GitHub, MongoDB, SSH …)
```

**Two-layer cache:**
- *Index cache* — directory listings/metadata; TTL-based (default 10 min). First `ls` hits the API; subsequent ones are free.
- *File cache* — object bytes; 512 MB RAM default or Redis for multi-process/serverless. First `cat` streams from origin; repeats are free.

Both layers are pluggable: swap `RAMFileCacheStore` for `RedisFileCacheStore`.

## Agent Framework Integration

Mirage drops into major agent frameworks without changing the mount surface:

| Framework | Integration point |
|---|---|
| OpenAI Agents SDK (Python) | `MirageSandboxClient` as sandbox |
| Vercel AI SDK (TypeScript) | `mirageTools(ws)` typed tool set |
| LangChain | adapter |
| Pydantic AI | adapter |
| CAMEL | adapter |
| OpenHands | adapter |
| Claude Code / Codex | lightweight CLI + daemon |

## Supported Resources (partial list)

RAM, Disk, Redis, S3/R2/OCI/Supabase/GCS, Gmail/GDrive/GDocs/GSheets/GSlides, GitHub/Linear/Notion/Trello, Slack/Discord/Telegram/Email, MongoDB, SSH.

## Installation

```bash
uv add mirage-ai           # Python ≥ 3.12
npm install @struktoai/mirage-node   # Node.js ≥ 20
curl -fsSL https://strukto.ai/mirage/install.sh | sh  # CLI
```

## Key Insight

The core thesis: LLMs are most fluent in bash/Unix semantics — that's the dominant corpus they trained on. Mirage turns that fluency into universal backend access. Instead of wiring N SDKs or M MCPs, the agent gets one surface it already knows. [[03-RESOURCES/concepts/agent-systems/agent-vfs-pattern]] captures the design pattern; [[03-RESOURCES/concepts/pkm-obsidian/virtual-filesystem-llm]] covers the theoretical framing.

## Related

- [[03-RESOURCES/entities/Strukto-AI]] — org behind Mirage
- [[03-RESOURCES/concepts/agent-systems/agent-vfs-pattern]] — pattern: mount heterogeneous backends as one FS
- [[03-RESOURCES/concepts/pkm-obsidian/virtual-filesystem-llm]] — why Unix semantics are LLM-native
- [[03-RESOURCES/concepts/dev-foundations/ai-legible-backend]] — complementary: design backends for AI legibility
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — alternative integration layer Mirage replaces/reduces
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — Mirage functions as the tool/environment layer of a harness

---

## Por que Unix é a linguagem nativa de LLMs

O argumento central do Mirage tem base empírica: os corpora de pré-treinamento dos LLMs contêm ordens de magnitude mais texto sobre Unix/bash do que sobre qualquer SDK específico (boto3, google-cloud-storage, etc.). Um LLM viu bilhões de exemplos de `ls -la`, `cat config.json`, `find . -name "*.py"` — e viu esses comandos funcionando, com seus outputs, em contextos reais de resolução de problemas.

Isso tem duas consequências práticas:

**Interpretação robusta de erros:** quando `cat /path/to/file` retorna "Permission denied", o modelo sabe o que fazer — não porque foi treinado nesse caso específico, mas porque viu esse padrão em mil contextos diferentes. Equivalentes em SDKs proprietários (`s3.get_object()` retornando `AccessDeniedException`) são menos robustos porque aparecem com muito menor frequência no corpus.

**Composição natural:** `grep "pattern" $(find . -name "*.json")` é uma composição de ferramentas que o modelo constrói fluentemente. Composição equivalente entre SDKs requer imports, exceções heterogêneas e convenções inconsistentes — cada junta é um ponto de falha que o modelo precisa raciocinar explicitamente.

---

## O cache de dois níveis em detalhe

O Mirage não é apenas uma camada de abstração — ele é também uma camada de cache com semântica específica:

**Index cache (metadata/listings):**
- TTL padrão: 10 minutos
- Scope: por workspace, não global
- Invalidação: automática por TTL ou manual via `ws.invalidate(path)`
- Benefício: `ls /gmail/inbox/` em 10 chamadas de agente só faz 1 chamada real à API do Gmail

**File cache (conteúdo de objetos):**
- Tamanho padrão: 512 MB em RAM
- Backend swap: `RAMFileCacheStore` → `RedisFileCacheStore` para multi-process ou serverless
- Invalidação: por TTL ou write (writes invalidam o cache do arquivo modificado automaticamente)
- Benefício: `cat /s3/bucket/large-document.pdf` na segunda chamada é read-from-RAM

Para agentes com múltiplos turnos acessando os mesmos recursos (um documento em análise, uma thread de Slack em revisão), o file cache elimina o custo de egress da API a cada turn. Em workflows de 20+ turnos, isso pode ser a diferença entre $0.02 e $2.00 em custos de API.

---

## Comparação com MCPs: quando usar cada um

Mirage e MCPs não são concorrentes diretos — são camadas diferentes do stack:

| Dimensão | MCP | Mirage |
|---|---|---|
| Abstração | Tool calls com schema JSON | Unix commands sobre VFS |
| Vocabulário | Por servidor (diferente para cada) | Bash padrão (ls, cat, cp, grep, find) |
| Caching | Não nativo | Nativo (dois níveis) |
| Cross-resource ops | Requer múltiplos servidores | Nativo (`cp /s3/file /gdrive/folder`) |
| Portabilidade | Depende do MCP client | Qualquer framework com adapter |
| Customização | Por servidor | Via `ws.command()` |

**Quando MCP é melhor:** quando a operação tem semântica rica específica do serviço (criar uma PR no GitHub com assignees e labels) que não tem equivalente Unix limpo. MCPs expõem a API nativa do serviço com tipagem.

**Quando Mirage é melhor:** quando o agente precisa operar sobre múltiplos serviços usando os mesmos padrões, ou quando você quer que o modelo use composição Unix (pipe, grep, find) para processar recursos de diferentes origens.

---

## Portable Workspaces e reprodutibilidade de ambiente

O comando `ws.snapshot("demo.tar")` serializa o estado completo do workspace — mounts, cache atual, comandos customizados — em um tarball. Isso resolve um problema real em desenvolvimento de agentes: o ambiente do agente é normalmente implícito (variáveis de ambiente, credenciais, configurações de SDK) e difícil de reproduzir.

Com snapshots:
- **Debugging**: reproduzir exatamente o estado do ambiente no momento de uma falha
- **Collaboration**: compartilhar o workspace de desenvolvimento com um colega sem documentar configuração
- **Testing**: fixtures de ambiente para testes de integração do agente

Para o vault-michel, um snapshot do workspace Mirage seria o equivalente a um backup do estado do ambiente de integração — restaurável em qualquer máquina onde o vault esteja montado.

---

## Limitações conhecidas

- **Consistência de cache vs. dados em tempo real:** o index cache de 10 minutos pode entregar listings desatualizados para recursos que mudam rapidamente (inbox de email, canal de Slack ativo). Para esses casos, TTL precisa ser reduzido ou invalidação manual explicitada.
- **Permissões heterogêneas:** cada backend tem seu modelo de permissões (IAM para S3, OAuth para Google Drive). Mirage não abstrai permissões — erros de acesso aparecem como erros de filesystem Unix, mas o diagnóstico ainda requer conhecer o backend.
- **Operações não-POSIX:** alguns backends têm operações sem equivalente Unix (criar uma planilha Google com schema específico, fazer um commit atômico no GitHub). Para essas operações, `ws.command()` é necessário — mas o comando customizado precisa ser documentado no prompt do agente.
- **Maturidade da biblioteca:** em 2026-05, o projeto ainda é relativamente novo. Os adapters para LangChain, Pydantic AI, CAMEL e OpenHands são listados mas podem ter coverage desigual de features.
