---
title: "Loop Engineering: The Anatomy of an Autonomous Loop"
type: source
source: Clippings/Loop Engineering The Anatomy of an Autonomous Loop.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Um loop autônomo converge na verdade ou degenera em um random walk caro — e isso são dois problemas de engenharia distintos. O artigo detalha a anatomia de um loop (5 partes), a centralidade da verificação, um script bash funcional de 20 linhas, e — o ponto mais original — os 4 "freios" (step cap, budget ceiling, blast radius, circuit breaker, liveness check) que separam um loop que produz valor de um que gera uma conta de dezenas de milhares de dólares.

## Argumentos principais
- **Prompt vs. loop**: prompt é uma instrução; loop é um objetivo que o agente persegue até chegar lá. A diferença não é escala, é quem vira as engrenagens — no prompt, você; no loop, o sistema. Isso move o humano da posição de executor para a de designer da máquina.
- **As 5 partes de um loop funcional**: Finding work (descobrir o que precisa ser feito sem receber a tarefa na mão), Plan, Action, Verification (o coração — tratado em seção própria), Memory (lembra o que foi feito/falhou para a próxima passada não recomeçar do zero). Das 5, só Verification e Memory exigem pensamento real; Discover/Plan/Act são quase triviais com modelos modernos.
- **Verificação não pode vir do próprio agente**: o modelo que escreveu o código é juiz ruim de si mesmo — sempre se aprova. O check precisa entregar veredicto baseado em fato (teste, linter, type check, build), não opinião do agente. É por isso que loops decolaram primeiro em programação: código é o mais verificável do mundo.
- **Loop mínimo funcional em 20 linhas de bash** ("técnica Ralph", batizada por um personagem teimoso): um `while` que roda teste, se vermelho chama `claude -p` para corrigir a menor mudança possível, com `MAX_ITER` como fusível principal. Propriedade-chave: cada iteração começa com contexto fresco — progresso fica no disco/git, não na memória do modelo.
- **Os 4 freios que faltam na versão naive**: (1) Step cap — teto rígido de iterações; (2) Budget ceiling — limite de dinheiro por fase; (3) Blast radius — um worktree, uma branch, read-only fora da pasta de trabalho; (4) Circuit breaker — mesma ferramenta/argumentos 3x seguidas = agente travado, não trabalhando, halt; (5) Liveness check — heartbeat escrito a cada rodada; silêncio = loop morreu.
- **Regra de escopo**: escopar um loop pelo que ele pode destruir, não pelo que você quer que ele faça — blast radius primeiro, tarefa depois.
- **/loop vs /goal**: `/loop` reexecuta em intervalo (polling, o próprio agente avalia seu trabalho); `/goal` roda até uma condição escrita ser provadamente verdadeira, avaliada por um modelo separado e menor que lê a transcrição — o modelo que escreveu não se autoavalia.

## Key insights
- "Scope a loop by what it can destroy, not by what you want it to do" é o princípio de segurança mais denso do artigo.
- Mesma tecnologia, dois resultados radicalmente diferentes pelo mesmo fator: freios. Um loop sem freios gerou conta de dezenas de milhares de dólares; um loop com freios entregou contrato de $50K gastando menos de $300 em API.
- **4 mortes de um loop** com sintoma/causa/cura: Runaway (conta e iterações sobem, progresso não — dois agentes se alimentando infinitamente; cura: step cap + budget ceiling); Silent death (loop reporta trabalho mas parou de fato — contexto cheio, finge estar viva; cura: heartbeat + contexto fresco por fase); Random walk (loop gira mas se afasta do objetivo — sem stop condition verificável; cura: check de fixpoint tipo "testes verdes"); Comprehension debt (repo cresce mais rápido do que o humano entende — vira aprovador de diffs cego; cura: gate de leitura humana obrigatório, sem flag que resolva).
- **Ordem que funciona**: primeiro fazer uma execução manual passar de forma confiável; depois dobrar as instruções num arquivo skill; depois embrulhar a skill num loop com check e stop condition; só então agendar. Pular etapas (automatizar algo que ainda não é confiável manualmente) é como loops explodem dormindo.
- Frota de 100 agentes custa mais de $1M/mês e só se paga com orçamento de big lab — para o resto, o loop que compensa é pequeno, com teto, apontado para um único trabalho monótono.

## Exemplos e evidências
- Citação de Boris Cherny (criador do Claude Code): não abriu editor de código por um mês, shipou 259 PRs todos escritos por seus loops — "his job is no longer to write code. His job is to write the thing that writes the code."
- Citação de Peter Steinberger: "you should not be prompting agents anymore, you should be designing loops that prompt your agents for you."
- Caso citado: loop sem freios rodou 11 dias sem supervisão e queimou dezenas de milhares de dólares antes de alguém notar.
- Caso contraste: engenheiro entregou contrato de $50K via loop autônomo, custo de API menor que $300.
- Script bash completo com `MAX_BUDGET_USD`, heartbeat (`.loop_heartbeat`), detector de repetição (`repeat_count`), e circuit breaker explícito.

## Implicações para o vault
Complementa diretamente `loop-engineering-patterns` com os mecanismos de segurança (freios) que ainda não estavam mapeados em detalhe — útil para qualquer rotina autônoma do próprio sistema vault (ex.: `ralph-loop` skill em `04-SYSTEM/skills/orchestration/`). A taxonomia das "4 mortes de um loop" é um framework de diagnóstico aplicável a qualquer agente do vault que rode em ciclo (hill, extend).

## Links
- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop]]
- [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]]
