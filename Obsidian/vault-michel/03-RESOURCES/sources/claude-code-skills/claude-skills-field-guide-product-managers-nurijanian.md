---
title: "How to Create Claude Skills That Work: A Field Guide for Product Managers"
type: source
source: "Clippings/How to Create Claude Skills That Work A Field Guide for Product Managers.md"
source_url: "https://x.com/nurijanian/status/2060672098050490380"
author: "@nurijanian"
published: 2026-05-25
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, claude-code-skills, skill-design, skill-testing, progressive-disclosure, skill-security]
---

## Tese central

Criar uma Claude skill é trivial — o trabalho real é fazê-la **disparar** na tarefa certa e **se comportar** corretamente quando dispara. A maioria das skills "prontas" falha em produção por description fraca ou ausência de testes; um loop create-test-refine com avaliadores separados resolve ambos.

## Argumentos principais

- Estrutura mínima: SKILL.md com YAML frontmatter (name + description) + corpo markdown; pastas opcionais scripts/, references/, assets/
- Progressive disclosure em 3 camadas: (1) startup — apenas name+description (~100 tokens cada); (2) trigger — SKILL.md completo no contexto; (3) on-demand — reference files ou scripts abertos só quando necessário; scripts rodam sem o código entrar na conversa
- Description como componente crítico: é o único que Claude vê ao decidir se usa a skill — vaga → skill ignorada ou dispara em momento errado; deve ser terceira pessoa, nomear o que faz E os triggers
- "Processes Excel files and generates reports" > "Helps with documents" — especificidade é tudo
- Body curto (<500 linhas, <5K tokens): contexto é real estate compartilhado — cada sentença compete com a conversa; só adicionar o que Claude não pode ter por si mesmo
- Prescrição proporcional à fragilidade: tarefas abertas (code review) → direção geral; tarefas frágeis (database migration) → comando exato + não desviar
- References máximo 1 nível de profundidade: SKILL.md → forms.md OK; forms.md → details.md → third-file = Claude skim ao invés de ler
- Scripts devem "solve, not punt": tratar próprios erros, documentar configs, usar plan-validate-execute para operações destrutivas
- Teste antes de escrever: coletar 3-5 casos representativos, definir o que "bom" parece, medir baseline sem skill, depois escrever o mínimo para passar — iteração mensurável não opinião
- skill-creator atualizado (março 2026): Executor roda skill contra test prompts, Grader pontua contra critérios, Comparator faz blind A/B sem saber qual versão é qual
- Formato open standard (dezembro 2025): skill escrita hoje roda em Codex, Cursor, GitHub, VS Code — portabilidade total

## Key insights

- "A skill that works perfectly but never fires is worthless" — framing que centra o problema certo
- Anthropic framing mais útil: "a skill is an onboarding guide for a new hire" — Claude já pensa; skill transmite procedural knowledge e house rules que ele não pode adivinhar
- "On demand loading" é o que permite Claude usar skills autonomamente ao invés do usuário ter que lembrá-las pelo nome
- Benchmark mode do skill-creator: rastreia pass rate, tempo e custo de tokens através de runs — quando novo modelo lança, re-verificar que skill ainda funciona
- Também roda em Cowork (desktop agent da Anthropic para não-devs) — PM pode rodar loop create-test-refine entre reuniões sem engenheiro
- Segurança como preocupação real: SKILL.md é texto plano que Claude trata como instruções → superfície de ataque para injection; skill pode instruir Claude a vazar API key em URL; usar claudelint e skill-lint antes de instalar skill de terceiros

## Exemplos e evidências

- PRD reviewer como caso concreto: testar contra 3 PRDs já revisados à mão, anotar issues que boa review deveria pegar, rodar skill — se perder 2 dos seus flags, sabe o que corrigir antes de chegar na equipe
- Gotchas recorrentes: backslashes Windows em file paths (quebra em outros OS), instruções time-sensitive no body ("before August, use old API") que apodrecem, skills "data" que tentam fazer 5 coisas e disparam imprevisívelmente
- Peter Steinberger (@steipete, criador do OpenClaw) tem skill para auditar skills por token efficiency
- skill-creator em github.com/anthropics/skills; obra/superpowers writing-skills; compound-engineering write-a-skill

## Implicações para o vault

- Confirmação direta e aprofundamento das práticas de skill design já documentadas no vault
- A seção de segurança (injection via SKILL.md) é nova e importante — adicionar à [[03-RESOURCES/concepts/agent-systems/]] como threat model
- O skill-creator com Executor/Grader/Comparator é um workflow de eval que pode ser adotado para as skills do próprio vault
- O formato open standard confirma que skills do vault (/.claude/skills/) funcionam em Codex/Cursor quando necessário

> [!contradiction]
> Este artigo afirma que o body limit é <500 linhas / <5K tokens. Outros artigos no vault (e.g., [[03-RESOURCES/sources/claude-code-skills/complete-guide-building-skills-claude]]) podem usar limites diferentes. Verificar consistência.

## Links
- [[03-RESOURCES/concepts/agent-systems/]]
- [[03-RESOURCES/sources/claude-code-skills/complete-guide-building-skills-claude]]
- [[03-RESOURCES/sources/claude-code-skills/anthropic-how-we-use-skills]]
- [[03-RESOURCES/sources/claude-code-skills/skill-design-an-interface]]
