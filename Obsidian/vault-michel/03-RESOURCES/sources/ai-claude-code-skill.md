---
title: "让 AI 记住你的工作方式，Claude Code Skill 学习与实践白皮书"
type: source
source: "Clippings/让 AI 记住你的工作方式，Claude Code Skill 学习与实践白皮书.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, claude-code-tooling]
---

## Tese central
Whitepaper (chinês) explicando Claude Code Skills do zero: Skill é um "manual de trabalho" escrito uma vez (arquivo `SKILL.md` com frontmatter `name`/`description` + corpo de regras) que Claude descobre e usa automaticamente quando a tarefa corresponde, eliminando a necessidade de re-explicar a mesma instrução repetidamente.

## Argumentos principais
- Critério prático para decidir quando criar um Skill: "se você já pediu a mesma coisa ao Claude 3+ vezes, considere transformar em Skill".
- `description` é o campo mais crítico — funciona como "condição de gatilho": Claude decide quando usar o Skill com base nela. Descrição vaga ("ajuda com trabalho") falha; descrição específica (o que faz + quando usar) funciona.
- Dois locais: Skill pessoal (`~/.claude/skills`, segue o usuário entre projetos) vs Skill de projeto (`.claude/skills`, compartilhado via repositório com o time) — escolha depende se a regra é preferência pessoal ou padrão de equipe/projeto.
- Claude Code escaneia Skills disponíveis ao iniciar, mas não lê todo o conteúdo de imediato — primeiro olha só nome+description (carregamento progressivo/disclosure), só carrega o corpo completo quando decide que o Skill se aplica.

## Key insights
- O critério "3+ vezes repetido = vira Skill" é heurística simples e direta, aplicável a qualquer instrução recorrente que o usuário dê neste vault fora de um skill formal — útil como gatilho de quando propor consolidar uma instrução ad hoc em skill novo.
- "Description mal escrita = Skill nunca disparado" explica por que o índice de skills global do usuário (`~/.claude/skills/index.md`) precisa de descriptions específicas e não genéricas — risco concreto se algum skill deste vault tiver description vaga.

## Exemplos e evidências
- Exemplo completo de SKILL.md (`pr-description`) com frontmatter e corpo de regras; comparação de descriptions boas vs ruins; analogia local ("pedido de chá com configuração fixa = Skill").

## Implicações para o vault
Nenhuma ação direta — confirma boas práticas já seguidas na estrutura de `04-SYSTEM/skills/` deste vault (frontmatter name/description, carregamento progressivo); útil como checklist de qualidade se algum skill futuro tiver baixa taxa de acionamento.

## Links
- [[04-SYSTEM/skills/foundational/spec-lifecycle]]
- [[03-RESOURCES/entities/Claude Code]]
