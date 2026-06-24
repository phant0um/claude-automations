---
title: "Padrões de Seleção de Ferramentas"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, claude-code-tooling]
status: developing
---

# Padrões de Seleção de Ferramentas

Escolher a ferramenta errada para uma tarefa desperdiça tokens, aumenta latência e reduz confiabilidade — existe uma hierarquia clara.

## O que é

Um conjunto de heurísticas para selecionar a ferramenta mais apropriada para cada operação, priorizando ferramentas dedicadas sobre utilitários genéricos e APIs diretas sobre automação de interface.

## Como funciona

**Hierarquia por superfície de ferramenta** (confiabilidade decresce):

1. **API / CLI dedicada** — mais confiável, output estruturado, mínimo de tokens
2. **Arquivo local / MCP filesystem** — leitura/escrita direta, sem parsing
3. **Browser (WebFetch/WebSearch)** — não-determinístico, depende de DOM
4. **Automação de tela (Computer Use)** — frágil, alto custo, último recurso

**Regras práticas para file ops:**
- `Read` > `cat` / `head` / `tail`
- `Edit` > `sed` / `awk`
- `Write` > `echo >` / `cat <<EOF`
- `Bash` apenas quando nenhuma ferramenta dedicada resolve

**Over-tooling:** usar Bash para tudo que uma ferramenta dedicada faria melhor é o erro mais comum. Ferramentas dedicadas retornam output estruturado com menos tokens de ruído.

**MCP-backed > Browser > Computer Use:** para qualquer tarefa que possa ser feita via MCP (filesystem, vault, search), nunca escalar para browser automation.

## Por que importa

No vault-michel, a regra `Tools: MCP-backed > Browser > Computer Use` no CLAUDE.md reflete exatamente essa hierarquia. Aplicá-la consistentemente reduz tokens gastos e aumenta a taxa de sucesso das operações automatizadas.

## Related
- [[03-RESOURCES/concepts/claude-ecosystem]]
- [[03-RESOURCES/concepts/token-efficiency]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
