---
title: How to Build a Claude Code Agent That Optimizes Code in a Loop (Exact Setup Inside)
type: source
source: "Clippings/How to Build a Claude Code Agent That Optimizes Code in a Loop (Exact Setup Inside).md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Pedir a Claude "torne isso mais rápido" faz com que ele reescreva metade do arquivo por palpite, sem prova de que ajudou — às vezes entrega código mais lento. Um agente de otimização mede, muda uma coisa, mede de novo, e só mantém se o número realmente se moveu: você entrega "2x mais rápido, benchmarked", não "deveria estar mais rápido, provavelmente".

## Argumentos principais
- Por que "optimize this" falha normalmente: Claude faz pattern-matching com coisas que *parecem* rápidas (caching, memoization, algoritmo mais sofisticado); às vezes ajuda, às vezes adiciona complexidade que torna o código mais lento e mais difícil de ler — e ninguém mede para descobrir qual dos dois aconteceu.
- Um loop de otimização substitui opinião por medição: toda mudança precisa se provar contra um benchmark antes de ficar. Sem número, sem manter. Esse loop roda em um sinal diferente do loop de correção de bugs: testes são pass/fail; aqui o sinal é um número que sobe ou desce, o que muda o funcionamento do loop inteiro.
- **Arquivo 1 — comando `/optimize`** (`.claude/commands/optimize.md`): loop explícito — rodar o benchmark primeiro e registrar baseline; formar uma hipótese (nomear o bottleneck e a mudança); fazer essa única mudança, nada mais; rodar o benchmark de novo; se mais rápido, manter e tornar novo baseline, voltar ao passo 2; se mais lento ou igual, revert e logar por que falhou, tentar outra hipótese; parar após 5 mudanças ou quando o ganho cair abaixo de 5%. Regras: uma mudança por ciclo (duas ao mesmo tempo e você não sabe qual ajudou); nunca manter mudança sem número que a comprove; corretude primeiro — re-rodar os testes após cada mudança mantida, porque "uma resposta errada mais rápida não é uma otimização".
- **Arquivo 2 — harness de benchmark** (`bench/run.mjs`): exemplo concreto em JavaScript usando `performance.now()`, com input realista em escala (10.000 itens, não 10), warm-up de 5 rodadas antes de medir (para capturar estado estável, não ruído de cold-start), 50 execuções, ordenadas, reportando a **mediana** — não a média, porque uma execução lenta distorce a média e esconde a verdade.
- **Arquivo 3 — regras de otimização** (em `CLAUDE.md`): medir em input realista (10 itens não prova nada); profile antes de adivinhar (achar o bottleneck real, não assumir — "a linha lenta raramente é a que você suspeita"); uma mudança por vez; manter legibilidade em mente (um ganho de 3% que torna o código ilegível geralmente é má troca — anotar e deixar o humano decidir); nunca trocar corretude por velocidade.

## Key insights
- A regra "profile before guessing" é apontada como a mais importante: a maior parte do esforço de otimização desperdiçado vai para a linha errada, porque a parte lenta raramente é onde "parece que deveria ser".
- O exemplo de execução mostra o loop revertendo deliberadamente uma mudança (paralelização da formatação de linhas) que mediu mais lenta — "o overhead venceu o ganho nesse tamanho" — demonstrando o ponto central: o loop mantém só o que os números provam, e descarta silenciosamente o que não prova.
- Frase de encerramento (espelha o artigo irmão sobre bugs): "o agente não ficou mais inteligente, ele só parou de confiar no instinto e começou a confiar nos números."

## Exemplos e evidências
- Exemplo de execução real mostrado: baseline 840ms (mediana, 10k linhas) → mudança 1 (memoização do lookup de categoria, 790ms, mantida, -6%) → mudança 2 (loop aninhado trocado por Map, 410ms, mantida, -48%) → mudança 3 (paralelização da formatação de linha, 470ms, MAIS LENTA, revertida) → mudança 4 (streaming em vez de array completo, 380ms, mantida, -7%) → resultado final: 840ms → 380ms, 2.2x mais rápido, testes ainda verdes.
- Setup cronometrado em 10 minutos: 3 min para `optimize.md`, 3 min para escrever benchmark real com warmup e mediana, 2 min para regras em `CLAUDE.md`, 2 min para rodar `/optimize` numa função lenta.
- Código JS completo e literal do harness de benchmark, com comentários explicando warm-up e por que reportar mediana.

## Implicações para o vault
Par direto de "How to Build a Claude Code Agent That Fixes Its Own Bugs in a Loop" (mesmo batch) — mesma estrutura de receita (3 arquivos: comando, harness/hook, regras em CLAUDE.md), mas aplicada a otimização de performance medida em vez de correção de bugs via testes. Reforça `[[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]` com um segundo domínio de aplicação prático e copiável. O princípio "mediana sobre média para sobreviver outliers" e "uma mudança por vez para isolar causalidade" são detalhes metodológicos finos que valem nota dentro desse concept, paralelos ao gate out-of-sample das sources de quant research do mesmo batch — em ambos os casos, o ponto central é que medição honesta (não confiança na "sensação" do modelo) é o que torna o loop confiável.

## Links
- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/agent-systems/evaluator-optimizer-workflow]]
- [[03-RESOURCES/entities/Claude Code]]
