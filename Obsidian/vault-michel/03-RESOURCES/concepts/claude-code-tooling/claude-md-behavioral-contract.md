---
title: "CLAUDE.md como Contrato Comportamental"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, claude-code-tooling]
status: developing
---

# CLAUDE.md como Contrato Comportamental

CLAUDE.md é o principal mecanismo para comportamento persistente de IA — um contrato legível por humano e máquina que define como o agente deve operar em um projeto.

## O que é

Um arquivo Markdown carregado automaticamente pelo Claude Code em cada sessão, definindo contexto, princípios, convenções e workflow. Funciona como o "firmware" do projeto: sem ele, o agente opera com comportamentos padrão genéricos.

**Dois níveis:**
- `~/.claude/CLAUDE.md` — global, aplica-se a todos os projetos
- `<projeto>/CLAUDE.md` — projeto, sobrescreve o global em conflito

## Como funciona

**Estrutura recomendada:**
1. **Contexto do projeto** — o que é, estrutura de pastas
2. **Princípios** — regras de comportamento (ex: Karpathy 4P)
3. **Convenções** — naming, links, frontmatter
4. **Workflow** — fluxo de ingestão, orquestração de subagentes

**Limite 200 linhas:** compliance cai significativamente com arquivos maiores. Regras > exemplos — exemplos ocupam espaço sem aumentar compliance proporcionalmente.

**14 regras máximo:** o modelo honra consistentemente até ~14 regras explícitas; além disso, degradação observada.

**Seções invariantes:** marcar com `<!-- [INVARIANT] -->` protege seções críticas de modificação por agentes autônomos (hill, extend). Mudanças requerem confirmação explícita do usuário.

**@import:** usar `@arquivo.md` para modularizar detalhes sem inchar o CLAUDE.md principal.

## Por que importa

É o único mecanismo que persiste comportamento entre sessões sem depender de memória do modelo. Todo o vault-michel SO — princípios Karpathy, convenções de naming, workflow de ingestão — vive no CLAUDE.md do projeto.

## Evidências
- **[2026-06-19]** CLAUDE.md descrito como "a constituição do vault": regras de leitura/escrita/segurança com meta de menos de 200 linhas, citação obrigatória de caminho de nota como mecanismo de honestidade — [[03-RESOURCES/sources/ai-second-brain-obsidian-guide]]

## Related
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/claude-code-plugin-system]]
- [[03-RESOURCES/concepts/self-rewrite-hooks]]
