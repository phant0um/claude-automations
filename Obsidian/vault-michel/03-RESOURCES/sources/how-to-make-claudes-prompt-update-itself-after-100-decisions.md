---
title: "How to Make Claude's Prompt Update Itself After Every 100 User Decisions"
type: source
source: "Clippings/How to Make Claude's Prompt Update Itself After Every 100 User Decisions.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Sistema apresentado por Nick Mayhew (Anthropic) trata o prompt como "apprentice" que observa decisões humanas e se reescreve sozinho a cada lote de ~100 decisões — não como config fixa. Caso de uso: recrutamento, mas o padrão generaliza a qualquer domínio onde humano faz julgamento e modelo ajuda (triagem de suporte, moderação, code review, deal scoring).

## Argumentos principais
- **Prompt como apprentice, não config**: no sistema mostrado, o "apprentice" é um markdown plano (perfil de candidato ideal) em inglês corrido — sem pesos, regras ou flowcharts. Cada aprovação/rejeição do recrutador, e cada comentário ("não tem Python suficiente"), é logado como sinal de treino.
- **Por que 100 decisões, não 1**: uma única decisão é ruído — pode ser usuário cansado, input estranho, clique errado, caso óbvio, ou teste deliberado. Reescrever o prompt a cada ação é "perseguir fantasmas". Padrão emerge a cada 100-200 decisões, segundo Mayhew no palco — aí sim é preferência, não humor.
- **Duas camadas, não um agente gigante**: camada inferior = evaluator barato/rápido rodando em todo input (Haiku pontuando cada CV contra o perfil atual, milhares/dia, julgamento estruturado estreito). Camada superior = apprentice lento/caro rodando raramente, só nos lotes de decisão humana, perguntando "o prompt ainda bate com o que o usuário está escolhendo de fato?" — se não, reescreve.
- A maioria dos times pula esse split e coloca modelo frontier no caminho quente de toda request — conta explode, sistema é abandonado. Separar avaliação de aprendizado é o que mantém o sistema vivo em produção.
- **Prosa, não regras numéricas**: instinto comum é escrever config com pesos (30% experiência, 20% tier da empresa, 10% educação) — parece rigoroso mas não há nada que o modelo possa de fato atualizar além de números, que não capturam "por quê" o recrutador disse não. Formato que funciona: markdown em prosa ("queremos alguém que lançou produto do zero, idealmente em startup com menos de 50 pessoas", "cultura de engenharia forte importa mais que stack específico") — frases que o apprentice pode adicionar/remover/ajustar; uma rubrica numérica não permite esse tipo de edit.
- Ciclo completo: usuário decide → evaluator pontua contra prompt atual → a cada 100 decisões, apprentice lê o lote e reescreve o prompt → próximo lote é avaliado contra a versão nova. Usuário nunca pensa no prompt; ele se atualiza por baixo.

## Key insights
- O erro central de muitos sistemas "self-improving" é confundir rigor com numerificação — uma rubrica ponderada parece mais "engenheirada" que prosa solta, mas é exatamente o formato que impede edição incremental por um segundo modelo.
- Separar "avaliador barato em todo request" de "aprendiz caro em lote" é o mesmo princípio de cost-control de qualquer sistema de duas velocidades (cache hot/cold, fast/slow path) — aplicado aqui a aprendizado de preferência, não a infraestrutura.
- O batch de N=100 não é um número mágico fixo — é o ponto onde sinal supera ruído de decisão individual; o valor certo depende do volume e da variância das decisões do domínio.

## Exemplos e evidências
- Caso real citado: cliente Anthropic recebeu 2.740 aplicações para uma vaga em 24h — prompt escrito à mão já estava errado antes de processar o segundo lote de 100.
- Sistema mostrado por Nick Mayhew em palco da Anthropic: perfil de candidato ideal como markdown, log de aprovação/rejeição/comentário/edição manual como sinal de treino do apprentice.

## Implicações para o vault
Padrão de "evaluator barato + apprentice caro em lote, prompt como prosa editável" é diretamente aplicável ao próprio pipeline deste vault: a heurística bash de triagem (score 0-10) já funciona como evaluator barato roteando pra Haiku (borderline) ou aprovação/rejeição direta; o equivalente a "apprentice que reescreve o prompt a cada 100 decisões" seria revisar periodicamente os pesos/regras de `04-SYSTEM/skills/core/triagem-scoring.md` com base em overrides manuais acumulados (já documentados informalmente no changelog dessa skill) — hoje esse ajuste é manual e ad-hoc, não um loop fechado.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- [[04-SYSTEM/skills/core/triagem-scoring]]
