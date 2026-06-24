---
title: "Karpathy's 4 CLAUDE.md rules → 12 rules (41% → 3% mistake rate)"
type: source
source_type: clipping
platform: X/Twitter
author: "@Mnilax"
url: "https://x.com/Mnilax/status/2053116311132155938"
published: 2026-05-09
created: 2026-05-09
updated: 2026-05-09
tags: [karpathy, claude-md, behavioral-rules, agent-engineering, token-budget]
triagem_score: 9
---

# Karpathy's 4 → 12 CLAUDE.md Rules

Extensão prática do template Karpathy (Forrest Chang, 120K stars) com 8 regras adicionais testadas em 30 codebases por 6 semanas.

## Resultado

| Config | Mistake Rate | Compliance |
|--------|-------------|------------|
| Sem CLAUDE.md | 41% | — |
| Karpathy 4 regras | 11% | 78% |
| 12 regras completas | 3% | 76% |

## As 12 Regras

**Originais (Karpathy/Forrest Chang):**
1. Think Before Coding — state assumptions, ask before guessing
2. Simplicity First — minimum code, nothing speculative
3. Surgical Changes — touch only what you must
4. Goal-Driven Execution — define success criteria, loop until verified

**Adicionais (@Mnilax):**
5. Use model only for judgment calls — routing/retries/deterministic = code, not LLM
6. Token budgets are not advisory — 4K/task, 30K/session, surface breaches
7. Surface conflicts, don't average them — pick one pattern, flag other for cleanup
8. Read before you write — read exports, callers, utilities before adding code
9. Tests verify intent, not just behavior — test WHY, not just WHAT
10. Checkpoint after every significant step — summarize done/verified/remaining
11. Match codebase conventions — conformance > taste inside codebase
12. Fail loud — "completed" wrong if anything skipped silently

## Onde Karpathy Quebra (4 gaps)

1. **Long-running agent tasks** — sem budget, sem checkpoint, sem fail-loud
2. **Multi-codebase consistency** — "match existing style" assume 1 style
3. **Test quality** — "tests pass" ≠ tests meaningful
4. **Production vs prototype** — Simplicity First overfires em early-stage code

## O que NÃO funcionou

- Mais de 14 regras → compliance cai para 52%
- 200 linhas = teto real do CLAUDE.md
- Exemplos > regras em custo de contexto (3 examples ≈ 10 rules)
- Identity prompts ("be senior") → 0 efeito
- "Be careful" / "think hard" → compliance ~30%

## Mental Model

> CLAUDE.md is not a wishlist. It's a behavioral contract that closes specific failure modes you've observed. Every rule should answer: what mistake does this prevent?

## Relações

- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]] — regras 1-4 originais
- [[03-RESOURCES/concepts/claude-md-behavioral-contract]] — CLAUDE.md como contrato comportamental
- [[03-RESOURCES/entities/Forrest-Chang]] — autor do template original (5,828 stars dia 1)
- [[03-RESOURCES/entities/Andrej Karpathy]] — thread original (Janeiro 2026)

## Por Que Cada Regra Existe — Failure Mode Correspondente

As 8 regras adicionais de @Mnilax não são sugestões de boas práticas — cada uma fecha um failure mode específico observado em 30 codebases ao longo de 6 semanas.

**Regra 5 (Use model only for judgment calls):** agentes usam LLM para fazer roteamento, retries com backoff exponencial, e transformações determinísticas. Isso multiplica o custo e introduz variabilidade onde determinismo era possível. Routing e retries são código, não reasoning.

**Regra 6 (Token budgets are not advisory):** sem budget explícito, agentes em long-running tasks acumulam contexto indefinidamente. Uma tarefa de "refatorar o módulo inteiro" pode explodir para 200k tokens sem nenhum aviso. Surfacing breaches no checkpoint permite intervenção antes do custo explodir.

**Regra 7 (Surface conflicts, don't average them):** quando dois padrões conflitantes existem no codebase, o agente tende a criar um meio-termo que não corresponde a nenhum dos dois. Este meio-termo é um terceiro padrão — pior que qualquer um dos originais. O comportamento correto: identificar qual padrão é canônico, aplicá-lo consistentemente, e sinalizar as instâncias do padrão errado para cleanup posterior.

**Regra 8 (Read before you write):** agentes adicionam funções sem verificar se uma utility equivalente já existe. O resultado é duplicação de código com implementações ligeiramente diferentes — duas funções fazendo a mesma coisa de formas distintas, ambas bugadas de formas distintas.

**Regra 9 (Tests verify intent, not just behavior):** um teste que verifica "a função retorna 42 dado input X" não documenta por que 42 é o valor correto. Se o requirement muda, o teste não ajuda a entender o que precisa mudar. Testes que documentam WHY informam refatorações futuras.

**Regra 10 (Checkpoint after every significant step):** sem checkpoints, um agente que completa 90% de uma tarefa antes de travar deixa o codebase em estado indeterminado. O checkpoint formaliza o conceito de "estado conhecido bom" — o ponto de partida seguro para retomar ou reverter.

**Regra 11 (Match codebase conventions):** preferências pessoais de estilo não pertencem ao codebase de outra pessoa. Um agente que aplica suas preferências (ou as do CLAUDE.md global) em vez das convenções existentes cria inconsistência que será limpa manualmente depois.

**Regra 12 (Fail loud):** o modo de falha silenciosa é o mais perigoso — o agente conclui com "completed" quando na verdade pulou uma verificação, simplificou um requisito, ou assumiu que uma condição era verdadeira sem checar. Falhas silenciosas chegam em produção. Falhas ruidosas chegam em code review.

## Por Que o Teto de 14 Regras é Real

A descoberta de que compliance cai de 76% para 52% ao ultrapassar 14 regras não é óbvia. A expectativa intuitiva seria que mais regras = mais compliance. O mecanismo real é de atenção:

O CLAUDE.md é injetado no contexto de cada turno. Com 14 regras, o modelo mantém todas na "atenção ativa" durante o raciocínio. Com 20+ regras, as regras mais recentes no documento tendem a ser sobre-representadas na atenção (recency bias), enquanto as regras do meio ficam sub-representadas.

Solução: se o projeto tem mais de 14 comportamentos a codificar, agrupe comportamentos relacionados em skills separadas com carregamento condicional. O CLAUDE.md permanece curto; as skills fornecem contexto adicional quando relevante.

## O Que "Behavioral Contract" Realmente Significa

A metáfora de "contrato comportamental" é técnica, não retórica. Um contrato tem três partes:

1. **Partes:** o modelo que vai executar + o desenvolvedor que vai auditar
2. **Cláusulas:** as regras no CLAUDE.md
3. **Consequências de violação:** o desenvolvedor pode detectar uma violação, então a próxima sessão precisa corrigir o comportamento

A implicação: toda regra deve ser auditável. Se você não pode escrever um teste ou verificação manual que detecta quando a regra foi violada, a regra não é uma cláusula do contrato — é uma aspiração.

O teste prático: leia cada regra do seu CLAUDE.md e pergunte "como eu saberia se o agente violou isso no último PR?". Se a resposta é "não saberia", a regra não está no formato certo.

## Aplicação para vault-michel

O CLAUDE.md do vault-michel segue as 4 regras Karpathy originais como princípios, mas a maioria das regras específicas do vault são operacionais (ingest flow, naming conventions, file structure). Mapear essas regras para os 4 gaps identificados por @Mnilax:

- **Long-running tasks:** o vault tem tarefas de ingestão em batch que rodam por horas. Budget discipline (Regra 6) e checkpoints (Regra 10) são underspecified atualmente.
- **Multi-source consistency:** o vault tem múltiplos agentes escrevendo em espaços sobrepostos. Surface conflicts (Regra 7) deveria ser explícito no AGENTS.md.
- **Test quality:** o vault não tem testes formais — verificações são manuais. Fail loud (Regra 12) é a regra mais relevante aqui.
- **Production vs prototype:** vault-michel é ambos simultaneamente — algumas áreas são production (AGENTS.md, hot.md), outras são exploratórias.
