---
title: How I turned MiniMax into Fable 5 (97% cheaper)
type: source
source: "Clippings/How I turned MiniMax into Fable 5 (97% cheaper).md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Um modelo open-source mais barato (MiniMax), quando envolto em SKILL.md bem curados e plugins, dentro de um harness estruturado (Vellum), consegue chegar perto da experiência "just works" de um modelo de fronteira (Fable) — com 90%+ de economia de custo — desde que se aceite mais hand-holding e confirmações do modelo mais barato.

## Argumentos principais
- Resumo dos achados da autora: Fable entrega "magia que simplesmente funciona" fora da caixa; com engenharia e SKILL.md bem curados, MiniMax chega "ridiculamente perto".
- Padrões observados sobre MiniMax: (1) é um pouco verboso, mas corrigível via system prompt; (2) pode ficar tão bom quanto Fable em coding com o SKILL.md/plugin certo; (3) precisa de mais hand-holding — pede confirmações em vez de simplesmente agir; (4) é confiável em uso de ferramentas (importante para a maioria das tarefas de knowledge work); (5) não é bom em escrever conteúdo, mas um skill específico de escrita de artigos ajuda bastante.
- Processo de construção testado em três capacidades dentro do ambiente Vellum (onde a assistente "Ava" tem skills/plugins/tools/canais):
  1. Assistente escuta calls (via Fathom), escaneia transcript por menções a si mesma, decide se resolve a tarefa sozinha ou avisa no Slack, cria página de resumo no Notion. MiniMax construiu isso na primeira tentativa usando um skill de engenharia de IA específico.
  2. Assistente como "especialista em ferramentas CLI": autora envolveu a API do ElevenLabs num CLI tool; o próprio agente, ao construir isso, criou um meta-CLI tool que captura o processo para construir mais CLIs no futuro — reduzindo "thinking tokens" ao reusar o processo documentado.
  3. Assistente proativa no Slack via plugin "proactive-slacks": substitui cron job fixo por um sistema de roteamento configurável de quando e como a assistente avisa o humano — Silent (salva, não avisa), FYI (posta, sem pedir ação), Ask (posta porque precisa de resposta), Urgent (posta e pressiona ação).
- Processo recomendado para replicar (7 passos): (1) comece com harness leve (Vellum, OpenClaw, ou Hermes); (2) escolha uma tarefa/processo único; (3) escreva a primeira versão do processo num SKILL.md; (4) use um modelo de coding poderoso (citado: Claude 4.8) para refinar o skill e decidir quando precisa de um plugin em vez de apenas melhor instrução; (5) em conversa separada, troque para MiniMax e teste o mesmo skill/plugin na mesma tarefa; (6) rode algumas vezes, observe falhas, refine até funcionar de forma confiável; (7) repita o processo para a próxima tarefa, expandindo o que a assistente sabe fazer.

## Key insights
- O "segredo" declarado não está no modelo em si, mas nos SKILL.md e plugins — a engenharia de skill é o que realmente fecha a lacuna de performance entre um modelo aberto barato e um modelo de fronteira caro.
- Divisão de trabalho entre modelos no próprio processo de construção: modelo caro e poderoso (Claude) é usado para *escrever e refinar* os skills; modelo barato (MiniMax) é usado para *executar* os skills no dia a dia — um padrão explícito de roteamento de modelo por fase de tarefa (engenharia vs. execução), não por tarefa isolada.

## Exemplos e evidências
- Comparação de preço: 97% mais barato no título; "90%+ cheaper than Fable" no corpo, com captura de tela de benchmark comparando MiniMax, Kimi K2 e Fable.
- A autora testou Kimi K2 também e relata que "não chega nem perto em performance, não importa o que esses benchmarks digam" — desconfiança explícita de benchmarks públicos frente a teste de uso real.
- Skills citados como ferramentas reais usadas: AI-engineering SKILL (`github.com/marinatrajk/ai-hero-engineer-kit`), article-writing skill (`github.com/affaan-m/ECC/.../article-writing/SKILL.md`).
- Repositórios próprios publicados pela autora como evidência: `github.com/AnitaKirkovska/elevenlabs-cli`, `github.com/AnitaKirkovska/Meta-CLI`, `github.com/AnitaKirkovska/proactive-slacks`.
- Caso de uso real demonstrado em vídeo: Ava escutando uma call no Fathom e reagindo a uma menção ao vivo.

## Implicações para o vault
Evidência concreta para `[[03-RESOURCES/concepts/llm-ml-foundations/model-selection-patterns]]` e `[[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]` — particularmente o insight de "modelo caro escreve/refina o skill, modelo barato executa" é um padrão de roteamento de modelo por fase (engenharia vs. execução) que complementa `[[03-RESOURCES/concepts/agent-systems/agent-model-routing]]`, já existente no vault, geralmente descrito como roteamento por tipo de tarefa — aqui aparece roteado por fase do ciclo de vida do skill.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/model-selection-patterns]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[03-RESOURCES/entities/Claude]]
