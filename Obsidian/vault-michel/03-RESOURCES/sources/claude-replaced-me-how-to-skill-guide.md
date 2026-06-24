---
title: "Claude replaced me."
type: source
source: "Clippings/Claude replaced me..md"
created: 2026-06-19
ingested: 2026-06-19
tags: [articles]
---

## Tese central
O autor (newsletter "how-to" de AI, 700k leitores) construiu uma skill chamada `/how-to` que substitui o serviço de ensinar "como fazer X com Claude": o usuário abre um chat, ativa a skill, e Claude faz as perguntas certas, monta um plano e guia passo a passo até o objetivo — mesmo sem o usuário saber por onde começar. O autor argumenta, no entanto, que isso só substitui "a metade fácil" do seu trabalho (o how-to); a metade difícil — debugar o botão que não clica, o momento que quebra sem explicação, testar por dois dias algo que não funcionou — continua sendo o valor real da newsletter.

## Argumentos principais
- Definição de skill dada ao público leigo: "um Claude 'skill' é um prompt pré-feito que ensina Claude a fazer coisas sem você ter que se repetir."
- Fluxo de uso: (1) baixar a skill (arquivo via Dropbox), (2) fazer upload em Claude → Customize → Skills → "+" → Create skill → Upload a skill, (3) testar com `/how-to` + a tarefa desejada, Claude faz perguntas e devolve um plano passo a passo, (4) opcionalmente usar setup avançado — Claude Cowork, modelo "Opus 4.8" + effort "High" (ou Fable-5 em "Low" effort, se disponível).
- Conclusão honesta do próprio autor: o "how-to" é a parte fácil do trabalho dele; a parte difícil (debugar, testar repetidamente, lidar com o que quebra sem motivo aparente) é o que Claude "não consegue baixar" — "the skill is me. The newsletter is me."

## Key insights
- Posicionamento de produto: enterprise adoption de Claude e construção de skills/tools customizados é como o autor "realmente ganha a maior parte do seu dinheiro" — a newsletter gratuita serve como funil de demonstração de capacidade.
- ELI5 (Explain Like I'm 5) é citado como prompt-pattern recomendado quando o usuário trava num passo: "if you can't make a step, say you can't and add ELI5."
- Métrica de prova social: 86.000+ pessoas decidiram que IA é importante o suficiente para não deixar de lado, conforme o autor; crescimento é orgânico, por indicação ("you are the sum of the 5 people around them").

## Exemplos e evidências
- Skill distribuída via link Dropbox com senha-piada "I-dont-need-Ruben-anymore".
- Setup avançado citado: Claude Cowork + skill + modelo Opus 4.8 + effort High (alternativa: Fable-5 em Low effort, indisponível no momento da publicação por bloqueio do governo americano).

## Implicações para o vault
Conteúdo majoritariamente promocional/tutorial de baixa densidade técnica comparado aos demais artigos do batch — confirma de forma anedótica (não pesquisa) o padrão já documentado em `claude-code-skills` de que skills servem para encapsular "como fazer X" e evitar repetição de instrução, mas sem adicionar mecanismo novo além do já coberto por fontes mais densas do batch (ex: "7 skills for any serious Hermes agent", "7-Day Guide"). Score B é consistente com a baixa densidade de insight.

## Links
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/entities/Claude]]
