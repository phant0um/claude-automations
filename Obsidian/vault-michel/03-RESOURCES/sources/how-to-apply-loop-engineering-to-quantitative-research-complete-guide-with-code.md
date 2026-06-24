---
title: How To Apply Loop Engineering To Quantitative Research (Complete Guide with Code)
type: source
source: "Clippings/How To Apply Loop Engineering To Quantitative Research (Complete Guide with Code).md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Single-shot prompting está morto para trabalho quant sério: você pede um fator de alpha a um LLM, ele devolve momentum ou RSI, você backtesta, falha, e nada se conecta entre tentativas. Loop engineering — termo cunhado por praticantes em meados de 2025 e formalizado por Addy Osmani (engenheiro do Google) em junho de 2026 — é a disciplina de desenhar sistemas de IA que não respondem uma vez só: agem, observam o resultado, decidem o próximo passo, e repetem até a meta ser realmente atingida.

## Argumentos principais
- A citação central de Peter Steinberger é usada como tese-guia: "Você não deveria mais estar dando prompts a agentes de coding. Você deveria estar desenhando loops que dão prompts aos seus agentes."
- Para quants, isso reformula o trabalho inteiro: você para de ser a pessoa que escreve código de fator e passa a ser a pessoa que desenha o sistema que escreve, testa e itera sobre código de fator. O leverage migra da qualidade de um prompt único para a arquitetura do loop de feedback.
- O ciclo de quatro estágios (Perceive→Reason→Act→Observe→loopback) traça origem no padrão ReAct (Yao et al., 2023) — raciocínio e ação entrelaçados para que o agente possa pensar sobre por que uma ação falhou antes de tentar de novo. Analogia do artigo: "um prompt único é como disparar uma flecha de olhos fechados; um loop é como ajustar a mira depois de cada tiro baseado em onde o último caiu."
- Mapeamento dos quatro estágios para pesquisa quant: PERCEIVE = ingerir dados de mercado, biblioteca de fatores, resultados de backtest prévios; REASON = gerar hipótese, decidir tipo de fator a explorar; ACT = escrever código do fator, rodar backtest, computar IC/ICIR; OBSERVE = avaliar métricas, extrair modo de falha, atualizar memória. O loop continua até ICIR > 0.5, meia-vida > 30 dias e IC estável.
- Arquitetura de três loops aninhados, cada um com timescale diferente: **OUTER LOOP** (nível de estratégia, roda até atingir N fatores aprovados, gerencia rotação de domínio e consolidação de memória, escala de horas a dias); **INNER LOOP** (nível de fator, roda até um fator ser aprovado ou esgotar tentativas de debug, escala de minutos); **MICRO LOOP** (nível de código, roda até o código executar sem erro, máximo 3 tentativas, escala de segundos). Cada loop tem sua própria condição de término e sinal de feedback — esse aninhamento é o insight arquitetural central.
- O **Stop Hook**: a parte mais crítica de loop engineering que a maioria das implementações ignora. Um LLM para quando *acha* que a tarefa está feita — não quando ela de fato está feita. O Stop Hook intercepta condições de saída e as valida contra critérios rígidos antes de permitir o término; o agente não pode se auto-terminar — toda saída precisa passar pelo Stop Hook, e se os critérios não são atendidos, o prompt da tarefa é reinjetado e o loop continua. Critérios concretos do exemplo: contagem mínima de fatores aprovados, todos os fatores aprovados atendendo ICIR/meia-vida mínimos, e correlação par-a-par entre fatores abaixo de um teto (diversidade de fatores).
- Falhas comuns documentadas: **Confidence Hallucination** (o LLM afirma ICIR de 0.08 na especificação da hipótese; o ICIR medido real é 0.014 — nunca confiar na auto-avaliação do estágio Reason, sempre medir no Observe); **Context Overflow** (loops externos longos enchem o histórico de conversa; por volta da iteração 30 o agente repete falhas antigas — solução: aparar o histórico de hipóteses para as últimas 10 mensagens, deixando o LoopState carregar memória de longo prazo); **Memory Poisoning** (um resultado de backtest ruim por erro de dados, não falha real de sinal, entra em failure_patterns e o agente evita permanentemente uma classe de fator inteira — validar toda razão de rejeição antes de escrever na memória); **Tight Micro Loop Infinite Loops** (agente que nunca produz código limpo para uma hipótese cicla o micro loop para sempre — cap rígido de 3 tentativas de debug); **Missing Termination Semantics** ("encontre 10 fatores" não é suficiente; "encontre 10 fatores com ICIR > 0.5, meia-vida > 30 dias, correlação par-a-par < 0.6" é um critério de Stop Hook real).

## Key insights
- Linha do tempo de onde está o leverage, segundo o autor: em 2022 estava em escrever o fator de alpha perfeito; em 2025 migrou para escrever o prompt perfeito; em 2026 vive em desenhar o loop que escreve e valida os fatores por você. "O loop é a nova unidade de pesquisa quant."
- O Stop Hook força a substituição de fatores limítrofes (ICIR 0.51, meia-vida de 31 dias) por fatores genuinamente fortes — sem ele, o loop sai cedo demais com fatores marginais; com ele, o piso de qualidade sobe.
- O trabalho do quant não desaparece — ele se redefine: o quant define os critérios de qualidade (limiares de ICIR, requisitos de meia-vida, limites de correlação, restrições de domínio); o trabalho do loop é explorar o espaço de fatores até esses critérios serem satisfeitos.

## Exemplos e evidências
- Tabela comparativa de resultados (atribuída a "AlphaQuant, Yuksel 2025" e "QuantaAlpha 2026"): Single-shot prompt (12% hit rate, ICIR médio 0.28, meia-vida 14 dias, 50 fatores/dia) → Chain A→B→C (28%, 0.38, 21d, 120/dia) → Inner loop only (41%, 0.44, 28d, 180/dia) → Full 3-tier loop (61%, 0.57, 45+d, 200+/dia) → Full loop + Stop Hook (61%, 0.61, 52d, 200+/dia). O Stop Hook não aumenta hit rate mas eleva ICIR médio e meia-vida — evidência direta de que ele filtra qualidade, não quantidade.
- Implementação completa em Python fornecida: classe `LoopState` (estado explícito compartilhado entre iterações — fatores tentados/aprovados/falhos, padrões de falha/sucesso, controle de iteração), classe `QuantLoopEngine` com métodos `perceive()`, `reason()`, `act()`, `observe()`, `_execute_factor()` (sandbox de execução), `_compute_ic()` (IC diário via correlação de Spearman), `_compute_halflife()`; métodos `run_micro_loop()`, `run_inner_loop()`, `run_outer_loop()`, `_update_memory()`; classe `QuantLoopStopHook` com método `check()` validando os três critérios de término.
- Uso real de API: `client.messages.create(model="claude-sonnet-4-6", ...)` para os estágios Reason e Act, com histórico de conversa mantido em `hypothesis_history` e `factor_history` separados por escopo de loop.

## Implicações para o vault
Par direto da source "How Quants Use Loop Engineering to Build Alpha" (mesmo batch) — esta é a versão com implementação de código completa, aquela é a versão conceitual/de produto. Juntas formam o par mais profundo do batch sobre `[[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]`. O conceito de **Stop Hook** (agente não pode se auto-terminar; toda saída passa por validação externa rígida) é uma adição importante e específica que vale destacar dentro desse concept — não estava claramente nomeado antes. Também conecta com `[[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]` (LoopState como memória explícita de curto prazo) e `[[03-RESOURCES/concepts/agent-systems/agent-loop-design]]`.

## Links
- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/evaluator-optimizer-workflow]]
- [[03-RESOURCES/entities/Claude]]
