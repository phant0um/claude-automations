---
title: "Release mattpocock-skills@1.0.0"
type: source
source: "Clippings/Release mattpocock-skills@1.0.0.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
O changelog da versão 1.0.0 do repositório público de Skills de Matt Pocock formaliza uma taxonomia de skills (user-invoked vs model-invoked), introduz skills compartilhadas de design de código/domínio, e consolida várias skills duplicadas ou não utilizadas — um caso real de maturação de uma biblioteca de Skills do Claude Code.

## Argumentos principais
- Nova skill `ask-matt`: um router user-invoked que aponta para a skill ou flow certo conforme a situação — breaking change porque depende das outras skills user-invoked estarem instaladas.
- Nova skill compartilhada `codebase-design`: formaliza vocabulário de "deep module" (módulo, interface, depth, seam, adapter) — conteúdo que antes vivia solto em `improve-codebase-architecture/LANGUAGE.md` agora foi generalizado para reuso entre skills.
- Nova skill `domain-modeling`: constrói e afia ativamente o modelo de domínio de um projeto, testando termos contra um glossário e mantendo `CONTEXT.md` e ADRs atualizados.
- Skills existentes foram "rewired" para depender das novas skills compartilhadas: `improve-codebase-architecture` agora puxa vocabulário de `/codebase-design`; `tdd` removeu suas notas inline (`deep-modules.md`, `interface-design.md`) em favor da skill compartilhada; `grill-with-docs` constrói o modelo de domínio via `/domain-modeling` em vez de lógica própria.
- Remoção de skills: `caveman` (duplicata de outra skill em teste, nunca deveria ter sido pública) e `zoom-out` (sem uso prático) foram descontinuadas.
- Rename: `diagnose` → `diagnosing-bugs` (breaking, comando antigo não existe mais).
- Substituição: `write-a-skill` foi removida e substituída por `writing-great-skills` (mais o `GLOSSARY.md` correspondente) — referência para escrever/editar skills bem, "caçando no-ops até o nível da frase". `grilling` foi exposta como skill model-invoked separada — o loop de entrevista reutilizável que está por trás de `grill-me` e `grill-with-docs`.
- Nova taxonomia formal: renomeação de "Commands / Skills" para "User-invoked / Model-invoked" em toda a documentação, com `docs/invocation.md` definindo a distinção — skill user-invoked só é alcançável quando digitada explicitamente e existe para orquestrar; skill model-invoked também pode ser alcançada automaticamente quando a tarefa encaixa. Regra de composição: uma skill user-invoked pode invocar skills model-invoked, mas nunca outra user-invoked.
- Nova skill minor: `resolving-merge-conflicts` — loop standalone (sem dependências) para resolver conflito de merge/rebase em andamento.
- Patch: skill `review` foi apertada — fail-fast no ref check, regras single-sourced, cortes de no-op.

## Key insights
- A distinção user-invoked/model-invoked formaliza uma confusão comum no ecossistema de Claude Code Skills (a própria terminologia "Commands vs Skills" era ambígua) — útil como referência de nomenclatura para qualquer biblioteca de skills, incluindo a deste vault.
- A extração de vocabulário compartilhado (`codebase-design`, `domain-modeling`) de skills individuais para skills base reutilizáveis é o mesmo princípio de DRY aplicado a prompts/skills, não só a código.
- A regra "user-invoked nunca invoca outra user-invoked" evita loops de orquestração confusos onde múltiplos routers se chamam mutuamente.

## Exemplos e evidências
- Changelog completo do GitHub Releases (mattpocock/skills, tag mattpocock-skills@1.0.0), com link para o commit único (`47bde84`) que introduziu a maior parte das mudanças breaking.

## Implicações para o vault
Relevante diretamente para a organização de `~/.claude/skills/` do usuário e para os skills deste vault (`wiki-ingest`, `wiki-lint`, etc.) — a taxonomia user-invoked/model-invoked pode esclarecer qual dos skills do vault deveria ser document como "trigger automático" vs "comando explícito" no índice de skills global (`skills/index.md`).

## Links
- [[03-RESOURCES/concepts/agent-systems/skill-authoring]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/entities/Matt-Pocock]]
