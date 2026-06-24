---
title: "What Actually ARE Loops? (And Do I Need Them?)"
type: source
source: "Clippings/What Actually ARE Loops? (And Do I Need Them?).md"
url: "https://x.com/tonbistudio/status/2063861151524643291"
author: "@tonbistudio"
published: 2026-06-08
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, agent-loops, tutorial, coding-agents, verification, autonomous-agents]
---

## Tese central

Agent loops sao o proximo nivel de abstracao acima de prompts manuais: estruturas recorrentes e auto-verificaveis onde a maquina — nao o humano — e quem prompta o modelo. Boris Cherny (Anthropic/Claude Code) e Peter Steinberger (@steipete, criador de openclaw) chegam a mesma conclusao por caminhos opostos: pare de promptar agentes, comece a projetar loops que promptam seus agentes.

## Argumentos principais

- Um loop e um processo recorrente com cinco partes: trigger, contexto, ferramentas para agir, mecanismo de verificacao do resultado, e condicao de parada que chama um humano.
- A verificacao e a parte que as pessoas pulam — e e a parte que mais importa. Sem ela, nao ha loop; ha um "token bonfire com um convite de calendario".
- Loops so pagam quando o trabalho tem duas propriedades: repete e o agente consegue checar se acertou. Trabalho exploratório, unico, ou difícil de verificar sem olho humano nao e loop-shaped.
- Loops sao uma "frontier skill", nao requisito diario. Boris e Peter vivem em codebases com milhares de agent-hours — a maioria dos devs nao esta la ainda, mas a forma da habilidade vale aprender agora.

## Key insights

### Boris Cherny — loops como proxima interface de programacao

- Trajetoria de abstracoes: punch cards → assembly → Python → IDE → Claude Code → paralelo manual → loops. O loop e o proximo degrau.
- Formula basica: Claude + cron + prompt recorrente + ferramentas + memoria do que ja tentou = loop.
- Auto-verificacao e inegociavel para escalar a centenas de agentes em paralelo — humano vira gargalo caso contrario.
- **Routines** (server-side): mesma ideia do `/loop`, mas roda no servidor em vez do laptop — continua depois de fechar a tela.
- O modelo esta começando a propor loops sozinho: pediu uma query de dados, Claude notou que os dados mudam, ofereceu report a cada 30 minutos e depois fiou o Slack sem ser mandado.
- Loops compostam via memoria: cada falha vira contexto futuro em CLAUDE.md. O loop fica mais inteligente a cada ciclo.
- Optimizacao de custo: loops maduros transformam passos repetidos em scripts e ferramentas em vez de chamar o modelo mil vezes para a mesma operacao.

### Peter Steinberger — remover-se do caminho de feedback

- Seu modelo mental: "Seu trabalho nao e descobrir como voce constrói software mais rapido. E descobrir o que voce pode fazer para ajudar seu agente a construir software mais rapido."
- Gatilho para construir um novo loop: **annoyance**. Aborrecimento significa que voce esta fazendo algo que uma maquina deveria estar fazendo.
- `vision.md` = constituicao do projeto. Sem ela, o loop otimiza para o que os contribuidores aleatorios pedem — que e uma bagunca.
- `agents.md` = invariantes comportamentais. Quando um agente entende mal o projeto, escreve a regra nas instrucoes para sessoes futuras herdarem. Hack elegante: pede ao agente que reescreva as instrucoes para o proximo agente.
- Aviso: agentes vao super-defender contra edge cases imaginarios a menos que voce diga o que realmente importa.

### Robo Bun — exemplo de producao com proof gates

Issue filed → bot reproduce bug → escreve failing test → corrige o codigo → abre PR (com teste que falha na versao antiga e passa no fix) → review bots criticam → fix agent responde → humano decide mergar. Nao e "pede ao Claude para corrigir um bug". Ha **proof gates**.

### Hill climbing como primitivo

Target + metrica + capacidade de mudar + capacidade de medir = loop autonomo de melhoria. Boris descreve isso como o primitivo fundamental: dar ao Claude um alvo e uma forma de medir progresso, e mandar iterar ate chegar la.

### Checklist de Boris para agente autonomo por horas

1. Auto mode para permissoes (para de perguntar)
2. Dynamic workflows para orquestrar varios agentes
3. `/goal` ou `/loop` para manter rodando
4. Cloud Claude Code (fecha o laptop, continua)
5. Forma de verificar o proprio trabalho end-to-end

### goal.md (abordagem do autor @tonbistudio)

- Proposito da tarefa
- Lista de entregaveis esperados (goal objective)
- Regras sobre o que pode e nao pode ser ajustado
- **Escape hatch**: "se ficar bloqueado e nao resolver em 3 tentativas em elemento critico, pare"

## Exemplos e evidencias

| Loop | Quem | O que faz |
|------|------|-----------|
| PR babysitter | Boris | Checa PRs a cada N minutos, corrige CI failures/conflitos, flags o que precisa de humano |
| CI health | Boris | Assiste testes flakey, reproduz, patcha ou quarentena, re-roda CI |
| Feedback clustering | Boris | A cada 30 min puxa Twitter feedback, clusteriza por tema, resume mudancas |
| Idea mining | Boris | Centenas de Claudes lendo Twitter/GitHub/Slack — ~20% de ideias validas |
| Issue & PR reaper | Peter | Le vision.md, decide se o request encaixa, comenta/agrupa/fecha |
| Maintainer report | Peter | Crawla Discord+issues+PRs, correlaciona com trabalho aberto, despacha agentes em paralelo |
| Mantis (video proof) | Peter | PR → spin-up maquinas → grava video do bug → corrige → grava video do fix → agente assiste para verificar |
| Auto Review | Peter | Antes do commit, Codex chama Codex com contexto fresco, roda rounds de review ate limpo |

## Implicações para o vault

- O vault ja implementa a logica de hill climbing em `hill` (agente de melhoria continua) e o conceito em [[03-RESOURCES/concepts/agent-systems/harness-engineering]].
- A estrutura trigger → contexto → tools → verificacao → stop-condition e o mesmo skeleton dos agentes do vault SO (guard, hill, verify, extend).
- `vision.md` de Peter e equivalente ao CLAUDE.md do vault + `principles.md` — um ponto de ancoragem para o que o sistema rejeita e aceita.
- `agents.md` como invariantes que agentes reescrevem para proximas sessoes = mecanismo de auto-evolucao ja discutido em [[03-RESOURCES/concepts/agent-systems/halo-harness-self-optimization]] e skill `/evolve`.
- O **escape hatch** em goal.md e um padrao que pode ser formalizado nas instrucoes de todos os agentes do vault que podem travar em loops infindaveis.
- Robo Bun como proof gate e o mesmo raciocinio de `ingest-verify` e `golden-cases` — verificacao como primeira-classe, nao afterthought.

## Links

- [[03-RESOURCES/entities/Boris-Cherny]]
- [[03-RESOURCES/entities/Peter-Steinberger]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- [[03-RESOURCES/concepts/agent-systems/halo-harness-self-optimization]]
- [[03-RESOURCES/sources/feedback-loops-help-claude-code-complete-ambitious-tasks-with-less-babysitting]]
- [[03-RESOURCES/sources/how-to-run-claude-on-autopilot-in-14-steps-loop-routines-and-the-full-automation-stack]]

## Ver tambem (loop engineering cluster)

- [[03-RESOURCES/sources/wtf-is-a-loop-steinberger-cherny]]
- [[03-RESOURCES/sources/loop-engineering-14-step-roadmap]]
- [[03-RESOURCES/sources/design-loop-prompts-agent]]
- [[03-RESOURCES/sources/designing-loops-with-fable-5]]
- [[03-RESOURCES/sources/most-devs-dont-need-agent-loops-yet]]
