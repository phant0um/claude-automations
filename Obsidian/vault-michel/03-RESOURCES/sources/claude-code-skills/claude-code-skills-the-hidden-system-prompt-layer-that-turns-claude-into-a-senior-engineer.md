---
title: "Claude Code Skills — The Hidden System Prompt Layer"
type: source
source: Clippings/Claude Code Skills The Hidden System Prompt Layer That Turns Claude Into a Senior Engineer.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, claude-code, skills, prompt-engineering]
---

## Tese central

Claude Code Skills são packages de capacidade reutilizável que transformam prompt engineering temporário em expertise permanente. Sem Skills, você gerencia Claude; com Skills, Claude gerencia a task. O problema de "Claude ignora convenções do projeto" é falta de contexto estruturado, não falta de capacidade.

## Argumentos principais

1. **Skill = system prompt persistente**: transforma "review meu código usando estes padrões" (repetido toda sessão) em um package carregado automaticamente quando relevante
2. **Arquitetura**: `my-skill/SKILL.md` + `examples/` + `templates/` + `references/` + `resources/`. SKILL.md é o coração — contém metadata, purpose, activation criteria, context, standards, workflow, decision framework, quality checklist, examples, output format
3. **Skill bem feita = sistema, não instrução**: beginner Skill tem instruções, expert Skill tem sistemas (decision frameworks, quality gates, workflows)
4. **Activation criteria** é a seção mais subestimada — determina quando Claude carrega a Skill. Clareza na description = melhor activation quality
5. **Transformação**: AI Assistant → Specialized Team Member. Exemplos: Frontend Architect, Code Reviewer, Security Engineer, Technical Writer, Database Expert, DevOps Engineer

## Key insights

- "Prompt Engineering → Temporary Skills → Permanent" é a trajetória de maturidade
- Skill sem activation criteria clara é como uma função que ninguém chama
- O melhor Skills incluem decision framework (quando aplicar X vs Y), não só "como fazer X"
- 10 seções de uma SKILL.md: Metadata, Purpose, Activation Criteria, Context, Standards, Workflow, Decision Framework, Quality Checklist, Examples, Output Format
- Skills são a diferença entre "Claude escreve código diferente toda sessão" e "Claude segue padrões do projeto consistentemente"

## Exemplos e evidências

- Estrutura de diretório: `my-skill/├── SKILL.md ├── examples/ ├── templates/ ├── references/ └── resources/`
- Mapeamento para roles: Frontend Architect, Code Reviewer, Security Engineer, etc. — cada um vira Skill reutilizável

## Implicações para o vault

- **Diretamente aplicável**: o vault já usa Skills em `04-SYSTEM/skills/` (triagem-scoring, pre-ingest-dedup, adversarial-gate). Este artigo valida a arquitetura e fornece template para expandir.
- **Gap identificado**: Skills do vault não têm todas as 10 seções recomendadas — especialmente Decision Framework e Quality Checklist
- **Complementa**: [[03-RESOURCES/concepts/claude-code-tooling]]

## Minha Síntese

**O que muda:** As Skills do vault (triagem-scoring, pre-ingest-dedup) funcionam mas seguem template minimalista. Adicionar Decision Framework e Quality Checklist elevaria a qualidade da ativação.

**Conexão pessoal:** O vault tem 36 skills roteáveis — mapeá-las contra as 10 seções recomendadas revelaria quais precisam de upgrade.

**Próximo passo:** Auditar 3 Skills core (triagem-scoring, pre-ingest-dedup, adversarial-gate) contra o template de 10 seções. Gap-fill as mais críticas.

## Links

- [[03-RESOURCES/concepts/claude-code-tooling]]
- [[03-RESOURCES/entities/Claude]]
- [[04-SYSTEM/skills/core/triagem-scoring]]
- [[04-SYSTEM/skills/foundational/pre-ingest-dedup]]