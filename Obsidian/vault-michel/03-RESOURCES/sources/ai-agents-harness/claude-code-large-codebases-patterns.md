---
title: "How to Adapt Claude Code to Large Codebases"
type: source
created: 2026-05-28
ingested: 2026-05-28
tags: [claude-code, monorepo, large-codebase, context-cascade, repo-map, claude-md, subagent, mcp]
source_url: "https://x.com/bibryam/status/2059359166188208142"
author: "@bibryam"
published: 2026-05-26
---

# How to Adapt Claude Code to Large Codebases

## Tese Central

Claude Code em repositórios grandes falha não por limitação do modelo, mas por ausência de estruturas ao redor do repositório: mapas, filtros de ruído, guidance local, workflows scoped, acesso a knowledge organizacional. A adaptação acontece *ao redor* do codebase tanto quanto dentro dele.

## Key Insights

8 padrões de 13 documentados por Anthropic para monorepos/enterprise codebases:

1. **Context Cascade Pattern:** CLAUDE.md em múltiplos níveis — root (regras globais) + subdiretórios (convenções locais). Claude carrega guidance pelo path da pasta de trabalho até a raiz. *Iniciar Claude no diretório do serviço, não na raiz.*
2. **Repo Map Pattern:** Markdown simples na raiz descrevendo top-level folders (nome + owner + propósito + entry points). Sem arquitetura essays — vão ficar obsoletos.
3. **Noise Filter Pattern:** `.claude/settings.json` com exclusões padrão para arquivos gerados, build artifacts, vendor deps, snapshots — herdado por todos os developers.
4. **Symbol Lookup Pattern:** Exposição de Language Server Protocol (LSP) ao Claude — resolve símbolos em vez de text search. Crítico em repos TypeScript, Java, C#, C++.
5. **Just-in-Time Skill Pattern:** Workflows como skills que carregam apenas quando relevantes. Base context pequeno; skills específicos disponíveis sob demanda.
6. **Scoped Skill Pattern:** Skills vinculados a paths específicos — workflow de payments não aparece ao editar inventory service.
7. **Scout Subagent Pattern:** Subagente read-only para exploração; escreve findings em arquivo; agente principal lê summary e começa implementação com contexto limpo.
8. **Search-as-a-Tool Pattern:** Conecta Claude ao sistema de busca organizacional via MCP (Elasticsearch, Glean, knowledge graph interno). Docs, runbooks, postmortems, ADRs acessíveis dentro da sessão de coding.

- **Objetivo:** Não fazer Claude ler todo o repositório. Fazer Claude entrar na parte certa, carregar os hints certos, ignorar arquivos errados, fazer mudanças com contexto local e organizacional suficiente.

## Implicações para o Vault

- Context Cascade (múltiplos CLAUDE.md) já usado no vault-michel — válida pattern documentada.
- Scout Subagent Pattern aplicável a ingests complexos: subagente de descoberta produz report, agente principal executa.
- Noise Filter Pattern = analogia ao `.gitignore` do vault (Clippings brutos nunca lidos por Claude diretamente).

## Links

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — patterns são extensões do harness para codebases grandes
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — Just-in-Time e Scoped Skills
- [[03-RESOURCES/sources/ai-agents-harness/how-claude-code-works-in-large-codebases]] — fonte anterior sobre o mesmo tema
