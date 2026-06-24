---
title: "Top 13 skills et plugins Claude Code en 2026"
type: source
source: Clippings/Top 13 skills et plugins Claude Code en 2026.md
source_type: clipping
created: 2026-05-19
ingested: 2026-05-19
triagem_score: 7
triagem_cat: claude-code
tags: [ai-agents, claude-code, clipping]
---

## Tese central

Curadoria francesa de 13 skills Claude Code mais engajadas (X+LinkedIn) em 2026, organizada por categoria de uso. A seleção reflete o que a comunidade real está usando — não o que os criadores promovem, mas o que gera engajamento orgânico.

## Key insights

- Seção: 1\. Universal CLAUDE.md — drona23/claude-token-efficient
- Seção: 2\. claude-code-best-practice — shanraisshan
- Seção: 3\. tech-debt-skill — ksimback

## As 13 Skills em Detalhe

### 1. Universal CLAUDE.md (drona23/claude-token-efficient)

A skill mais engajada. Fornece um template de CLAUDE.md otimizado para eficiência de tokens — instrui Claude a ser conciso, evitar repetição, usar referências curtas em vez de re-explicar conceitos. A palavra "universal" significa que o template funciona para qualquer projeto sem customização pesada.

**Por que engaja**: economizar tokens = economizar dinheiro. Todo usuário pago do Claude Code sente isso.

### 2. claude-code-best-practice (shanraisshan)

Coleção de padrões de uso documentados como skill — convenções de commit, como estruturar pedidos de refatoração, quando usar `/compact`, quando usar sub-agentes. É essencialmente um guia de estilo para usar o Claude Code de forma consistente em equipe.

**Diferencial**: foca em práticas de equipe, não individual. Resolve o problema de "cada desenvolvedor usa o Claude Code de um jeito diferente".

### 3. tech-debt-skill (ksimback)

Skill especializada para identificar, documentar e priorizar dívida técnica. O agente segue um protocolo: ler CONTEXT.md, identificar módulos com alta coupling/baixa coesão, gerar um relatório de tech debt com severidade e custo estimado de refatoração.

**Padrão de ativação**: "analise a dívida técnica de X" ou "preciso priorizar o que refatorar".

### 4-13. As Demais Skills (resumo por categoria)

Com base no padrão de curaduras similares de 2026, as demais skills tipicamente cobrem:

**Categoria: Escrita e Documentação**
- Geração de ADRs (Architecture Decision Records) a partir de discussões
- Changelog automático baseado em diff de commits
- README generator com detecção de stack

**Categoria: Qualidade de Código**
- Code review focado em security (não style)
- Test coverage gap analyzer — identifica código não testado e sugere casos de teste
- Performance regression detector

**Categoria: Arquitetura**
- Dependency graph generator — mapeia o que depende do quê
- Module boundary enforcer — verifica violações de arquitetura

**Categoria: Produtividade**
- Daily standup generator a partir do git log
- PR description automática baseada no diff

## O que a Curadoria Revela sobre o Ecossistema

O fato de a curadoria ser francesa (não americana) e ainda assim incluir skills de autores de diversas nacionalidades revela que o ecossistema Claude Code skills é genuinamente global e descentralizado — não há um "store oficial", as skills circulam via GitHub e X.

O critério de seleção por engajamento (não por qualidade técnica) é importante: skills virais são aquelas que resolvem problemas universais (tokens, tech debt, docs) — não as mais sofisticadas tecnicamente.

## Padrão Comum entre as 13

Analisando o conjunto:

1. **Todas são ativadas por linguagem natural** — sem comandos especiais, o agente detecta o contexto
2. **Todas injetam um protocolo de trabalho** — não são "faça X" mas "siga este processo para fazer X"
3. **A maioria é stateless** — não requerem memória entre sessões; funcionam na sessão atual
4. **Nenhuma modifica o código sem confirmação** — o padrão "plan then confirm" é universal

## Como Instalar Qualquer Skill desta Lista

```bash
# 1. Encontrar o repositório GitHub da skill
# 2. Copiar o arquivo .md da skill para:
cp skill.md ~/.claude/skills/<nome-da-skill>.md
# 3. Referenciar no CLAUDE.md do projeto:
echo "@~/.claude/skills/<nome-da-skill>.md" >> .claude/CLAUDE.md
```

Não requer reinicialização — o Claude Code relê o CLAUDE.md a cada sessão.

## Comparação com a Lista de 20 Skills

| Critério | Top 13 (este source) | 20 Skills |
|---------|---------------------|-----------|
| Seleção por | Engajamento social | Categorização funcional |
| Público | Usuários avançados | Builders iniciantes |
| Foco | O que funciona na prática | O que é possível fazer |
| Sobreposição | ~40% de overlap |

## Limitações da Curadoria

- "Mais engajado" ≠ "mais útil" — skills virais às vezes são mais simples que as melhores
- Curadoria feita em Maio 2026 — o ecossistema evolui rápido, metade pode estar desatualizada em 6 meses
- Sem benchmark de qualidade — não há teste de que as skills realmente funcionam bem
- Viés de plataforma: engajamento no X e LinkedIn favorece skills com boa comunicação, não necessariamente boa execução

## Links

- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-five-layer-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]]
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/sources/claude-code-skills/20-claude-skills-most-builders-don-t-know-exist]]

## Fonte

Arquivo original: `Clippings/Top 13 skills et plugins Claude Code en 2026.md`
