---
title: "How to Actually Prompt Claude Fable 5"
type: source
source: "[@AlphaSignalAI](https://x.com/AlphaSignalAI/status/2065089798545543384) — compressão do guia oficial Anthropic \"Prompting Claude Fable 5\""
created: 2026-06-13
ingested: 2026-06-13
tags: [ai-agents]
---

## Tese central

Modelo mais capaz = menos instruções. Prompts/skills escritos para modelos
anteriores são "**often too prescriptive for Claude Fable 5 and can degrade
output quality**." Substituição: goal + razão + boundaries explícitos +
verificação própria.

## Argumentos principais

### As 4 deleções

1. **Listas de passos prescritivas / skills over-tuned** — Fable 5
   atualiza skills mid-task; uma receita congelada de 30 passos briga com
   as próprias correções do modelo
2. **Instruções "mostre seu raciocínio"** — raw chain-of-thought nunca é
   retornado em Fable 5; pedir isso pode disparar refusal
   `reasoning_extraction` (roteado para Opus 4.8). Usar
   `thinking.display: "summarized"` em vez disso
3. **Contadores de tokens restantes** — mostrar um budget counter pode
   fazer o modelo encerrar antecipadamente ou cortar trabalho. Esconder ou
   adicionar "You have ample context remaining."
4. **Listas enumeradas de comportamento** — instruction-following melhorou
   o suficiente para 1 frase substituir 15 edge cases nomeados

### As 5 adições

1. **Effort por task**: `high` default, `xhigh` para trabalho
   capability-sensitive, `medium`/`low` para rotina. Effort baixo em Fable
   5 frequentemente supera `xhigh` em modelos anteriores
2. **Verificação executável**: subagentes verificadores com contexto fresco
   superam self-critique; instrução padrão de auditar claims de progresso
   contra resultados de tool quase eliminou relatórios de status
   fabricados
3. **Boundary block**: separar "assessment" de "action" — quando o usuário
   descreve um problema/pensa em voz alta, o deliverable é a avaliação;
   reportar e parar, não corrigir sem pedido
4. **Memory file**: 1 lição por arquivo markdown — em teste com Slay the
   Spire, memória baseada em arquivo melhorou Fable 5 **3x mais** que
   melhorou Opus 4.8
5. **A razão por trás do pedido**: "I'm working on [larger task] for [who
   it's for]. They need [what the output enables]."

### Os 5 blocos de prompt (verbatim, prontos para CLAUDE.md)

1. **Outcome-first summaries** — primeira frase responde "o que
   aconteceu"/TLDR; detalhe depois; conciso ≠ fragmentado/jargão
2. **Progress audit** — auditar cada claim contra resultado de tool desta
   sessão; reportar falhas com output real, sem hedging quando verificado
3. **Boundaries** — problema/pergunta/pensamento em voz alta → reportar e
   parar; checar evidência antes de comandos que mudam estado do sistema
4. **Autonomous-pipeline reminder** — operando autonomamente, "Want me
   to...?" bloqueia o trabalho; para ações reversíveis decorrentes do
   pedido original, proceder sem perguntar; antes de terminar o turn,
   checar se o último parágrafo é plano/pergunta/promessa — se sim, fazer
   o trabalho agora
5. **Memory system** — 1 lição por arquivo, summary de 1 linha no topo,
   registrar correções E abordagens confirmadas com o porquê, atualizar em
   vez de duplicar, deletar o que está errado

## Key insights

### Contexto/números

Fable 5: GA 9/jun, $10/M input + $50/M output, contexto 1M, output até
128k. Acesso incluído em planos pagos até 22/jun/2026. ~8% das tasks de
benchmark caem para fallback Opus 4.8 (vs Anthropic reportando <5% de
classifier triggers — gap não explicado). Stripe migrou 50M linhas Ruby em
1 dia (estimativa: 2+ meses de equipe). Em 3 repos ML com avaliador privado,
68.8% das contas oferecidas eram negative-value sob a held-out key onde não
havia checagem — reforça a tese de "verificação > confiança".

## Implicações para o vault

**Os 5 blocos de prompt acima são quase verbatim o que já está no
`~/.claude/CLAUDE.md` deste usuário** (Karpathy principles: think before
acting ≈ boundaries/plan-first; goal-driven verify ≈ progress audit;
memory system ≈ auto-memory). Esta fonte é **confirmação institucional
(Anthropic) de um setup já adotado** — não uma nova prática a adicionar,
mas validação de que o setup atual já segue o guia oficial de Fable 5/
Sonnet 4.6.

**Risco de over-prescrição**: as 4 deleções sugerem auditar
`04-SYSTEM/AGENTS.md` e os ~40 agentes especializados por listas de passos
"over-tuned" que podem estar degradando output em vez de ajudar — candidato
a tarefa para [[04-SYSTEM/agents/core/hill]] (melhoria contínua).

Ver também [[03-RESOURCES/sources/claude-code-cowork/4-prompts-best-ui-design-system]]
— a clause "stop and ask instead of inventing it" daquele artigo é a mesma
lógica do boundary block (item 3 das 5 adições) descrito aqui.
