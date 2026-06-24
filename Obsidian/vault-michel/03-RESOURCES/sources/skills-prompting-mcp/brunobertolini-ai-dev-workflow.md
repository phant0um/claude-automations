---
title: "Post by @brunobertolini on X — AI Dev Workflow 2026"
type: source
source: "Clippings/Post by @brunobertolini on X.md"
original_url: "https://x.com/brunobertolini/status/2060143330592182733"
author: "@brunobertolini"
published: 2026-05-28
created: 2026-05-29
ingested: 2026-05-29
tags: [articles, ai-dev-workflow, claude, github-projects, worktree, agents, epic, pm-automation]
---

## Tese central

O workflow de desenvolvimento com AI de brunobertolini em 2026 é um pipeline full-stack totalmente integrado: da ideia ao PR com 6 agentes de review, orquestrado por slash commands personalizados (`/pm`, `/epic`, `/code`, `/distill`) que conectam Claude Chat, GitHub Discussions, GitHub Projects, Claude Design, git worktrees e o second brain no Obsidian — tudo sem intervenção manual nos pontos de transição.

## Argumentos principais

- **Pipeline end-to-end sem fricção manual:** cada fase tem um comando dedicado que automatiza a transição para a próxima. O desenvolvedor decide o que fazer, não como fazer a transição.
- **Second brain integrado ao fluxo de code:** `/distill` empurra informação cross-project do chat do Claude para o Obsidian automaticamente. O knowledge management não é etapa separada — acontece como side-effect do desenvolvimento.
- **GitHub como sistema nervoso central:** Discussions (research + decisões) → Issues (épicos executáveis) → Projects board (priorização) → PR (output). Toda a memória do projeto vive no GitHub.
- **Priorização por dados, não por intuição:** `/pm prioritize` usa análise dos dados do próprio projeto (não opinião do desenvolvedor) para priorizar épicos.
- **Claude Design no loop:** antes de codificar, o épico passa pelo Claude Design para desenhar as telas — o design é input do plano técnico.
- **`/pm plan` lê o codebase:** ao destrinchar um épico em issues executáveis, o agente lê tudo que é relevante no codebase para deixar as issues prontas para execução, incluindo o handoff do design.
- **Worktrees para paralelismo:** `git worktrees` permite executar `/epic NUMBER` (múltiplos `/code` em paralelo ou serial) sem conflitos de branch. Épicos grandes executados em paralelo.
- **PR com 6 agentes de review:** ao final, PR aberto automaticamente com revisão por 6 agentes especializados — equivalente ao sistema de code review que brunobertolini já publicou anteriormente.
- **`/code` já inclui segurança, performance, tracking e reviews:** não é só execução de código — cada issue executada passa por checklist de qualidade embutido.

## Key insights

- **Slash commands como interface do workflow:** `/pm`, `/epic`, `/code`, `/distill` são a camada de abstração que torna o pipeline reproduzível. Cada comando encapsula um agente especializado ou sequência de ações.
- **`/distill` como ponte PKM↔dev:** se tem informação importante cross-project, roda `/distill` para jogar no Obsidian. O second brain é alimentado como subproduto do trabalho de desenvolvimento, não como tarefa separada.
- **Research → Discussion → Epic → Issues → Code → PR:** pipeline linear mas com feedback loops. A conversa no Claude Chat não morre — vira Discussion no GitHub, que vira épico, que vira issues executáveis.
- **`/epic` vs `/code`:** `/epic` executa tudo em paralelo/serial para épicos grandes; `/code` executa uma issue por vez para épicos pequenos. Mesma qualidade, diferente escala.
- **Validação humana permanece:** "rodo bun dev, vejo como ficou, valido o fluxo se faz sentido" — o loop de validação humana é preservado antes do PR. Automação não elimina julgamento, elimina transições manuais.

## Exemplos e evidências

- Workflow completo descrito em 8 passos concretos em um único post no X (2026-05-28).
- PS explícito: `/code já tem tudo que precisa de segurança, performance, tracking e roda reviews tmb` — indica que qualidade não é opcional mas embutida no comando básico.
- Sistema de PR review com 6 agentes: consistente com o sistema de code review autônomo publicado anteriormente por brunobertolini (fonte: [[03-RESOURCES/sources/skills-prompting-mcp/post-brunobertolini-sistema-revisao-codigo]]).

## Implicações para o vault

- **Confirma e estende o perfil de brunobertolini:** o sistema de revisão autônomo publicado anteriormente é apenas um componente de um workflow muito mais amplo. A entidade deve ser atualizada para refletir a visão completa.
- **`/distill` como padrão de integração PKM↔dev:** o vault-michel não tem um equivalente formal de `/distill`. O fluxo de ingestão manual de Clippings é o análogo mais próximo, mas sem trigger automático do chat.
- **GitHub Projects como board de épicos:** se o vault rastreia projetos, há um modelo aqui para usar GitHub Projects como backend de priorização com análise de dados do próprio projeto.
- **Git worktrees para agentes paralelos:** `[[03-RESOURCES/concepts/dev-foundations/git-worktrees-agent-parallelism]]` já documenta esse padrão — este post é evidência empírica de uso em produção por um desenvolvedor experiente.
- **Claude Design como etapa formal:** o vault não tem documentação sobre Claude Design. É um produto/feature do Claude que merece página própria em conceitos.

## Links

- [[03-RESOURCES/entities/brunobertolini]]
- [[03-RESOURCES/concepts/dev-foundations/git-worktrees-agent-parallelism]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- [[03-RESOURCES/sources/skills-prompting-mcp/post-brunobertolini-sistema-revisao-codigo]]
