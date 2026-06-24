---
title: "I Spent a Week Inside AI Loops. Prompting Is Dead. Here Is What Replaced It."
type: source
source: Clippings/I Spent a Week Inside AI Loops. Prompting Is Dead. Here Is What Replaced It..md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Um prompt é uma instrução única que sempre passa pelo humano; um loop é um objetivo que a IA persegue sozinha — descobre o trabalho, planeja, executa, verifica e itera até atingir a meta ou bater num limite. A citação de Peter Steinberger ("you shouldn't be prompting coding agents anymore, you should be designing loops that prompt your agents") resume a virada: o engenheiro deixa de ser o motor do ciclo e passa a ser o designer da máquina que roda o ciclo.

## Argumentos principais
- **Anatomia do loop em 5 passos**: Discover (descobrir o que precisa ser feito) → Plan (decidir como) → Execute (fazer) → Verify (checar contra o objetivo) → Iterate (realimentar e repetir). Verify e State/Memory são os dois passos onde loops realmente quebram.
- **Verify é o coração do loop**: sem um check real, não existe loop — existe um agente concordando consigo mesmo em repetição. O check precisa ser teste duro, condição mensurável ou rubrica — nunca a opinião do próprio agente que fez o trabalho, porque ele é generoso demais consigo.
- **State é o que faz o loop aprender**: cada passada precisa lembrar o que já foi tentado, ou repete o mesmo erro para sempre. Um registro simples em disco (não na memória do modelo) permite que a execução de amanhã retome em vez de reiniciar do zero — e é também onde o custo começa a escalar.
- **Stop condition é o que mantém o loop sensato**: toda loop séria tem duas formas de parar — sucesso, e um limite rígido (ex.: "depois de 8 tentativas, parar e reportar"). Sem isso, a máquina roda a noite toda sem nada de útil.
- **Teste dos 4 critérios para saber se vale construir um loop**: (1) a tarefa se repete pelo menos semanalmente; (2) algo pode rejeitar automaticamente um output ruim; (3) o agente consegue fazer o trabalho ponta a ponta; (4) "pronto" é objetivo, não julgamento de gosto. Faltando um, manter como prompt manual.
- **Os 5 blocos que montam um loop real**: automação (heartbeat/cadência — `/loop`, `/goal`, hooks, cron); skill (instruções reutilizáveis salvas em arquivo); subagents (separar quem faz de quem verifica — o mesmo modelo que escreveu é juiz generoso demais de si); connectors (permitem o loop agir no ambiente real, não só sugerir); verifier (o gate que decide se o loop ajuda ou só gasta dinheiro).

## Key insights
- A frase mais afiada do artigo: "you are the engine. The AI is the tool in your hand. A tool does nothing on its own" — descreve o modo prompt; o modo loop inverte essa relação.
- O custo de um loop não é linear por passo — ele composta, porque memória/state crescente é exatamente onde o gasto sobe mais rápido (mencionado mas não detalhado neste trecho).
- Times grandes já correm "fleets" de dezenas/centenas de agentes loopando a mesma tarefa simultaneamente — um engenheiro reescreveu uma codebase inteira de uma linguagem para outra em ~6 dias usando essa estrutura.

## Exemplos e evidências
- Loop spec de exemplo (código): `GOAL: every test in /tests/auth passes, lint is clean, no type errors` com 4 passos de iteração, VERIFY explícito e STOP WHEN (verify passa OU 8 iterações).
- Caso citado: reescrita completa de codebase entre linguagens em ~6 dias via fleet de agentes, versus quase um ano manualmente.
- Distinção prática Claude Code: `/loop` reexecuta um prompt em intervalo; `/goal` mantém sessão até condição escrita ficar verdadeira; hooks disparam em pontos do ciclo de vida do agente.

## Implicações para o vault
Reforça e expande o conceito já existente `loop-engineering-patterns` com a formulação dos "4 critérios de quando vale a pena" — um filtro prático ainda não documentado explicitamente no concept. Confirma a ênfase em verificação independente já presente em `generator-verifier-loop`.

## Links
- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
