---
title: "Loops explained: Claude, GPT, Mira and what actually works"
type: source
source: "Clippings/Loops explained Claude, GPT, Mira and what actually works.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, loop-engineering]
---

## Tese central
Um prompt dá uma resposta e espera você decidir o próximo passo; um loop roda o ciclo completo sozinho (Discover → Plan → Execute → Verify → Iterate) até atingir um objetivo definido uma vez. Das 5 etapas, Verify, State e regra de parada são onde a maioria erra a implementação.

## Argumentos principais
- **Verify é o coração do loop**: sem checagem real do resultado, não há loop — há o agente concordando consigo mesmo repetidamente. A checagem pode ser teste duro (passa/não passa), condição mensurável, ou rubrica avaliada pelo modelo — mas sem gate algum, o agente que fez o trabalho avalia o próprio trabalho, e é um avaliador generoso demais.
- **State é o que faz o loop aprender**: a cada passagem, o agente precisa lembrar o que já tentou, ou repete o mesmo erro para sempre — exige um registro pequeno e externo (o que está feito, o que falhou, o que vem a seguir); é também onde o custo começa a escalar.
- **Stop condition é o que mantém o loop sensato**: loop sem saída roda até ter sucesso, quebrar, ou drenar a conta — toda implementação seria de ter 2 formas de parar: sucesso e um limite rígido (ex.: "depois de 8 tentativas, parar e reportar").

## Key insights
- A formulação "prompt dá uma resposta; loop dá um objetivo + forma de saber quando está feito + regra de quando desistir" é o resumo mais compacto encontrado nesta leva inteira sobre loop engineering — útil como definição canônica caso o vault precise explicar o conceito de forma curta em algum lugar.
- O ponto "Verify avaliado pelo próprio agente que fez o trabalho é avaliador generoso demais" converge exatamente com o argumento de `/goal` em Claude Code (modelo separado e mais barato avalia) visto na fonte "Loop Engineering: Build an AI That Codes While You Sleep" desta mesma leva — **convergência de meta-padrão (F3.6)**: pelo menos 3 fontes desta leva concordam que avaliação deve ser separada de execução em qualquer loop agêntico.

## Exemplos e evidências
- Diagrama ASCII do ciclo Discover→Plan→Execute→Verify→Iterate.

## Implicações para o vault
Reforça candidatura a meta-padrão "separação execução/avaliação" já identificada em outras fontes desta leva (AutoForge, Loop Engineering...Sleep) — se o vault formalizar um meta-padrão no relatório F3, esta é a 3ª fonte independente confirmando o mesmo princípio.

## Links
- [[03-RESOURCES/concepts/agent-systems/claude-code-agent]]
- [[03-RESOURCES/concepts/agent-systems/agentic-reinforcement-learning]]
