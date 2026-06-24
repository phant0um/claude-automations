---
title: resolver-pattern
type: concept
status: developing
tags: [resolver, routing, agent-governance, context-rot, gbrain]
created: 2026-04-17
updated: 2026-05-19
---

# Resolver Pattern

Um resolver é uma tabela de roteamento para contexto: quando o tipo de tarefa X aparece, carregue o documento Y primeiro.

200 linhas substituem 20.000 linhas de contexto crameado. Invisível quando funciona; catastrófico quando não existe.

## Tipos de Resolver (Fractais)

Resolvers existem em toda camada do sistema:

| Resolver | Localização | Função |
|----------|------------|--------|
| Skill resolver | AGENTS.md | tipo de tarefa → arquivo de skill |
| Filing resolver | RESOLVER.md | tipo de conteúdo → diretório |
| Context resolver | dentro de cada skill | sub-roteamento interno |

## Por que é a Camada de Governança

Sem resolver:
- Skills inventam lógica própria de filing (hardcoded paths)
- Skills existem mas são inalcançáveis (15% das capabilities ficam no escuro)
- O sistema "trabalha" porque o humano sabe qual skill chamar — isso não é um sistema

## Problemas que Resolvers Resolvem

### O Misfiling Silencioso
Artigo arquivado em `sources/` ao invés de `civic/`. Não é falha dramática — é deriva silenciosa. O junk drawer cresce.

**Fix**: `_brain-filing-rules.md` + mandate que toda skill lê `RESOLVER.md` antes de criar uma página.

### Skills Invisíveis
Skill existe mas não tem trigger no resolver. É pior do que não ter a skill: cria ilusão de capacidade.

**Fix**: `check-resolvable` — meta-skill que percorre AGENTS.md → skill file → código e encontra dead links. Roda semanalmente.

### Context Rot

Decaimento temporal do resolver:
- Dia 1: perfeito
- Dia 30: 3 novas skills sem registro
- Dia 60: trigger descriptions obsoletas
- Dia 90: documento histórico

**Fix emergente**: RLM que observa dispatches de tarefas e reescreve triggers baseado em evidências. AutoDream do Claude Code é primitivo equivalente.

## Trigger Evals

Suite de testes: 50 inputs de exemplo com outputs esperados.

```
Input: "check my signatures"
Expected: executive-assistant (signature section)

Input: "save this article to brain"  
Expected: idea-ingest + RESOLVER.md
```

**Dois modos de falha:**
- False negative: skill deveria disparar mas não dispara (trigger errado/ausente)
- False positive: skill errada dispara (triggers com overlap)

Ambos corrigidos editando markdown. Sem mudanças de código.

## Resolvers como Gestão

| Componente | Analogia |
|-----------|----------|
| Skills | Funcionários |
| Resolver | Organograma |
| Filing rules | Processo interno |
| check-resolvable | Auditoria/compliance |
| Trigger evals | Avaliações de desempenho |

## Ver também

- [[context-engineering]]
- [[claude-skills]]
- [[claude-agent-harness-architecture]]
- [[agent-memory-architecture]]

## Fontes

- [[03-RESOURCES/sources/ai-agents-harness/resolvers-routing-table-intelligence]]
- [[03-RESOURCES/sources/ai-agents-harness/ai-agent-stack-2026]]
