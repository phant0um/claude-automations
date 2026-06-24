---
title: How Quants Use Loop Engineering to Build Alpha (Full Framework)
type: source
source: "Clippings/How Quants Use Loop Engineering to Build Alpha (Full Framework).md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Uma estratégia de trading que parece perfeita no backtest e sangra ao vivo morreu porque foi um único palpite sem nada iterando sobre ela. A resposta é um loop fechado — gerar estratégia, testar, pontuar, realimentar o resultado, rodar de novo até uma variante sobreviver out-of-sample — e o passo que separa edge real de overfitting mais rápido é o gate out-of-sample.

## Argumentos principais
- Por que prompting de uma tentativa estagna: um único prompt dá um único palpite; o modelo retorna um fator genérico, falha no backtest, e sem loop nada composto — cada tentativa recomeça do zero.
- Definição de loop engineering: ciclo fechado de gerar hipótese → testar → pontuar contra objetivo claro → ler por que falhou → realimentar na próxima geração. Formato: perceive → reason → act → observe → repeat.
- Métrica que fecha o loop: Information Coefficient (IC) = correlação entre valor do fator hoje e retorno seguinte. Uma única leitura de IC é ruidosa; o que importa é consistência ao longo do tempo — ICIR = média(IC) / desvio-padrão(IC). Um fator com IC modesto mas estável vence um fator vistoso que funciona uma vez e quebra.
- Checagem de decaimento que a maioria pula: todo fator real tem prazo de validade, medível ajustando a persistência do sinal como processo AR(1) e lendo sua meia-vida: t½ = -ln(2)/ln(ρ). Meia-vida de 50 dias é edge lento e negociável; meia-vida de 2 dias significa pagar custos para perseguir ruído. Um bom loop rejeita automaticamente fatores de meia-vida curta.
- O passo que separa edge de overfitting: um loop que otimiza nos mesmos dados em que foi construído não encontra alpha mais rápido — encontra ruído mais bonito, mais rápido. Cada iteração extra é mais uma chance de ajustar ao passado. Só um gate out-of-sample (cada candidato sobrevivente testado em dados que nunca viu, com ICIR tendo que se manter ali) torna o loop um motor de pesquisa real em vez de curve fitting automatizado — e a barra deve subir conforme o número de tentativas cresce.
- Erros comuns listados: (1) loopar em dados in-sample (overfit mais rápido); (2) rodar sem função de pontuação (loop otimiza para nada, deriva); (3) perseguir IC alto ignorando estabilidade (um mês ótimo de IC é "fantasia"); (4) confundir o modelo com o método (modelo melhor acelera geração; o loop + scoring + gate é o que produz alpha de fato).
- Checklist operacional: definir objetivo antes de começar (IC e ICIR numa janela held-out); gerar um punhado de variantes por passada; pontuar cada candidato, ler falhas, realimentar; checar meia-vida; gatear todo sobrevivente em dados out-of-sample, elevando a barra conforme tentativas aumentam; manter só o que se sustenta.

## Key insights
- Frase-chave do artigo: "um modelo pode escrever mil fatores. Só o loop diz qual deles foi real alguma vez."
- O artigo é, em essência, material de marketing para a plataforma Horizon (que promete rodar esse loop completo: gerar variantes em linguagem natural, backtestar, pontuar, gatear out-of-sample, deployar) — mas o framework conceitual (PERCEIVE→REASON→ACT→OBSERVE, IC/ICIR, meia-vida, gate out-of-sample) é genérico e tecnicamente sólido independente da ferramenta.

## Exemplos e evidências
- Fórmulas explícitas: IC = corr(factorₜ, returnₜ₊₁); ICIR = mean(IC)/std(IC); t½ = -ln(2)/ln(ρ).
- A plataforma Horizon é descrita operando o ciclo completo: usuário descreve estratégia em inglês simples, sistema propõe variantes para comparar, backtesta cada uma, pontua em retornos/Sharpe/drawdown, mostra o que se sustentou e o que quebrou, refina, gateia em dados out-of-sample antes de qualquer deploy ao vivo.

## Implicações para o vault
Esta source e "How To Apply Loop Engineering To Quantitative Research" (mesmo batch) cobrem o mesmo território conceitual de loop engineering aplicado a quant research — esta é a versão mais curta/conceitual (sem código), a outra é a implementação completa com Python. Reforçam fortemente `[[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]`, já existente no vault, com um domínio de aplicação concreto (finanças quantitativas) que pode servir de exemplo cruzado ao lado de `[[03-RESOURCES/concepts/financial-trading/algorithmic-trading]]` se esse concept existir, e de `[[03-RESOURCES/concepts/agent-systems/evaluator-optimizer-workflow]]` (o gate out-of-sample é uma instância desse padrão).

## Links
- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/concepts/agent-systems/evaluator-optimizer-workflow]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop]]
