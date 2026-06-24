---
title: CLAUDE.md Cost Optimization
type: concept
status: developing
tags: [claude-md, token-efficiency, cost-optimization, claude-code, hooks, subagents]
created: 2026-05-14
updated: 2026-05-23
---

# CLAUDE.md Cost Optimization

Técnicas de configuração do CLAUDE.md que reduzem o custo de tokens em 30-60% sem degradar a qualidade das respostas.

## O Problema Estrutural

Cada chamada de API reenvia o histórico completo da conversa:
- Turno 1: ~500 tokens
- 20 mensagens: ~200.000 tokens — todos pagos a cada chamada

O modelo padrão sem configuração opera no modo "eu vou descobrir": itera 8.000 tokens tentando resolver o que poderia ser respondido em 2 linhas de conversa.

## Regras de Alto Impacto

### 1. Stop-and-Ask Rule (−30% de custo)
```
quando incerto, pare e pergunte. nunca gaste tokens adivinhando.
```
Fonte: @dunik_7 — uma linha que reduziu sua conta em 30%.

### 2. Histórico Controlado
5 linhas no CLAUDE.md que documentam o contexto ativo eliminam re-explicações repetidas (−60% reportado por @0x_kaize).

### 3. Minimal-Change Preference
```
prefira mudanças mínimas suficientes em vez de reescritas amplas
```
Evita que o modelo reescreva todo o código quando apenas um ajuste cirúrgico é necessário.

## Princípio Central

> "O token mais barato é aquele que o Claude não escreveu porque perguntou primeiro."

## CLAUDE.md vs Hooks — Probabilístico vs Determinístico

**Diferença crítica:** regras no CLAUDE.md dependem de o modelo lembrar e interpretar corretamente em cada turno. Hooks não.

| Mecanismo | Natureza | Quando falha |
|-----------|----------|-------------|
| CLAUDE.md rule | Probabilístico — instrução ao modelo | Contexto longo, ambiguidade, modelo ignora |
| Hook (`PreToolUse`) | Determinístico — script no harness | Nunca — roda antes, fora do modelo |

**Uso correto:** CLAUDE.md para comportamento preferido; hooks para comportamento **obrigatório**.

Exemplo: `prefira não deletar arquivos` → CLAUDE.md. `NUNCA escreva em /generated/` → hook `PreToolUse` com `exit 2`.

## Subagentes como Mecanismo de Controle de Contexto

Subagentes isolam contexto do processo principal. Benefício além de paralelismo:

- Exploração de codebase por subagente → logs intermediários, tentativas e erros **não contaminam** o contexto principal
- Principal recebe apenas resultado comprimido
- Sessões longas sem subagentes degradam qualidade porque contexto contaminado é a maior causa de erros tardios

**Heurística:** delegue qualquer exploração que geraria >2k tokens de "trabalho descartável" para um subagente.

## CLAUDE.md — Custo Base por Inchamento

CLAUDE.md carregado em cada sessão antes de qualquer prompt. Regra escrita uma vez → aplicada permanentemente sem custo por sessão. **Risco inverso:** CLAUDE.md com >2.000 tokens eleva custo base de **toda** sessão.

Disciplina: manter somente regras que previnem erros já ocorridos. Nada prescritivo por antecipação.

## Trade-off

Mais paradas para perguntas = sessões mais lentas mas muito mais baratas. Para tarefas de alto custo ou longa duração, o trade-off é altamente favorável.

## Relacionado

- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]] — abordagem mais ampla
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — hooks como enforcement determinístico
- [[03-RESOURCES/concepts/claude-code-tooling/claudemd-self-improvement-loop]] — como regras viram memória persistente
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — onde CLAUDE.md se encaixa na estrutura

## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/12-recursos-claude-code]]
- [[03-RESOURCES/sources/post-0x_kaize-claudemd-token-savings]]
- [[03-RESOURCES/sources/post-dunik_7-claudemd-stop-ask]]
