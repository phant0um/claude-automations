---
title: "Code Reviews — Introducing REVIEWS.md and Memory"
type: source
source: Clippings/Code Reviews Introducing REVIEWS.md and Memory.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, code-review, memory, kilo-code, standards]
---

## Tese central

Code review agents que aplicam rubrica genérica a todo repo erram o que você realmente se importa. Kilo Code introduz REVIEWS.md (standards repo-específico em Markdown) + Code Review Memory (aprende com feedback para propor atualizações ao REVIEWS.md). Padrão aberto, versionado, visível ao time.

## Argumentos principais

1. **REVIEWS.md = AGENT.md para reviews**: arquivo Markdown aberto na raiz do repo. Convenções, preferências de estilo, decisões de arquitetura em plain text. Review agent lê e aplica em todo automated review.
2. **Repo-specific, não shared config**: frontend repo enforceia regras diferentes do infrastructure repo — cada um tem seu REVIEWS.md
3. **Code Review Memory**: captura replies e feedback em reviews/PRs no GitHub/GitLab. IA analisa padrões — se time dismissa nitpicks de line length mas age em error handling, agent propõe ajustar foco.
4. **Proposal → PR → merge**: análise gera proposal detalhado de mudanças ao REVIEWS.md. Kilo gera o PR. Time review/merge como qualquer mudança — standards ficam version-controlled e visíveis.
5. **Template example**: Kilo fornece example REVIEWS.md com content tips nas settings.

## Key insights

- "Most preferences already exist in how you respond to reviews" — memory extrai do comportamento, não de questionário
- Standards version-controlled = audit trail, não dark knowledge em cabeça de senior
- REVIEWS.md é open standard — funciona como README para máquinas
- Pattern: escrever standards → agent aplica → feedback → agent aprende → propõe update → time merge → ciclo

## Exemplos e evidências

- REVIEWS.md na raiz do repo, lido pelo Code Review agent
- Analysis de feedback: "dismisses nitpicks about line length but consistently acts on comments about error handling"
- Proposal → PR workflow: Kilo gera PR com mudanças sugeridas ao REVIEWS.md

## Implicações para o vault

- **Padrão aplicável**: o vault tem CLAUDE.md (instruções para Claude Code) — REVIEWS.md é o equivalente para review agents. Poderia adicionar REVIEWS.md ao vault com standards de review (kebab-case, frontmatter, wikilink conventions).
- **Memory pattern**: Code Review Memory é instância do pattern "agent aprende com feedback" — mesmo princípio do Hermes Dreaming (self-improvement plugin)
- **Complementa**: [[03-RESOURCES/concepts/claude-code-tooling]]

## Minha Síntese

**O que muda:** O vault já tem CLAUDE.md como "README para máquinas", mas não tem REVIEWS.md específico para review de quality gate. O pattern de "agent aprende com feedback → propõe update → merge" é diretamente aplicável ao hill-climbing do vault.

**Conexão pessoal:** Hermes Dreaming já implementa self-improvement com receipts — Code Review Memory é o mesmo pattern em domínio diferente (code review vs. skill mutation).

**Próximo passo:** Avaliar se vale criar REVIEWS.md para o vault com conventions de frontmatter, wikilinks, naming. Hill agent poderia usar como quality gate.

## Links

- [[03-RESOURCES/concepts/claude-code-tooling]]
- [[03-RESOURCES/concepts/agent-systems]]
- [[04-SYSTEM/agents/core/hill]]
- [[04-SYSTEM/agents/core/verify]]