---
title: "Autoloops > Agent Loops: guia para loops de agentes auto-aprimoráveis (Spark Domain Chips)"
type: source
source: "Clippings/Autoloops > Agent Loops guide for self-improving agent loops.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
Um loop que apenas repete uma tarefa (do → check → retry) não é o mesmo que um loop que melhora. A diferença crítica é ter uma forma de o agente comparar uma tentativa com outra e saber qual é melhor — sem isso, o agente apenas "gira" (churning); com isso, cada passada pode deixá-lo mais afiado. O autor propõe "Spark Domain Chips": especialistas pequenos de domínio único compostos por workflow + benchmark + autoloop, que se auto-aprimoram durante a noite.

## Argumentos principais
- **Crítica ao hype de "agent loops"**: "Loops are having a moment" — todo mundo conecta seu agente (Claude, Cursor, stack próprio) a um loop do tipo task → check → retry, e isso parece progresso, mas "girar um processo ruim mil vezes produz um processo ruim mil vezes, mais rápido."
- **Domain chip**: aposta oposta a "um modelo tentando ser bom em tudo" (que acaba ótimo em nada). É um especialista pequeno bom em UMA coisa — três componentes envolvidos em um único domínio: workflow, as tools que aquele domínio precisa, e um benchmark que define "o que é bom". Exemplos citados: chip de QA, de questionários de segurança, de consultoria a startups, de trading cripto, de conteúdo, de pesquisa.
- **As três partes que tornam um chip auto-aprimorável**:
  1. **Workflow padronizado** — Spark constrói o workflow e as tools no mesmo formato sempre; o loop precisa de algo estável para "agarrar".
  2. **Eval contra o qual se autoavaliar** — Spark constrói um benchmark pack para o domínio, para que o chip seja medido em vez de apenas "soar bem". Esta é a parte que quase todo mundo pula — e é o segredo inteiro.
  3. **Autoloop** — Spark tenta uma mudança, pontua contra o benchmark, mantém se vencer e reverte se perder. Roda dentro de guardrails: limites de mutação (não pode "vagar"), condições de parada, e "evidence gates" (mudança só fica se os números confirmam).
- **"O eval é o produto, não o pré-requisito chato"**: sem benchmark, um loop apenas muda coisas; mudança ≠ melhoria. Um agente sem forma de se avaliar está "adivinhando" — pode parecer ocupado por horas e terminar mais burro do que começou. Com um benchmark, o loop pode segurar duas versões lado a lado e perguntar "qual pontuou mais alto na coisa que eu de fato me importo?" — essa pergunta é a "catraca" (ratchet) que permite subir em vez de vagar.

## Key insights
- **Operação noturna**: uma vez com workflow + benchmark, o autoloop é simples — mutar a abordagem um pouco, pontuar contra o eval, manter o ganho ou reverter a perda, repetir. A política (quanto pode mutar, quando parar, quanto de evidência conta) é definida uma vez; depois "você vai dormir" e acorda com um agente mensuravelmente melhor, com um "rastro de papel" de pequenas vitórias provadas.
- **Cinco passos para construir o próprio chip**:
  1. Escolher um domínio (qualquer tarefa repetitiva que você adoraria delegar)
  2. Definir workflow e tools (passos, apps, arquivos, MCP tools necessários)
  3. Construir o benchmark pack — "a parte que as pessoas pulam"; escrever o que é "bom" para que o chip possa ser pontuado, não apenas soar convincente
  4. Definir a política do autoloop — limites de mutação, condições de parada, notas de rollback, evidence gates ("a coleira que mantém o auto-aprimoramento honesto")
  5. Deixar rodar — empacota a evidência e solta; melhora contra o benchmark sozinho, registrando o que mudou
- **"Playbook em uma tela"** (10 pontos) — resume tudo: a diferença entre loop que repete e loop que melhora é a capacidade de auto-pontuação; eval é o segredo; autoloop roda com guardrails (limites de mutação, stop conditions, rollback notes, evidence gates); melhora contra benchmark próprio mesmo dormindo; primeiro passo é escrever como você avaliaria sua pior tarefa semanal — essa frase é seu primeiro eval.
- **Honestidade do sistema**: "evidence gates" existem para que o loop não se engane mantendo uma mudança que não ajudou de fato; "rollback notes" existem para que uma mutação ruim não "gruda" silenciosamente; "evidência local permanece evidência local" — um resultado empacotado para revisão, não uma lei a se reivindicar.

## Exemplos e evidencias
- Repositório de referência: github.com/vibeforge1111/spark-domain-chip-labs ("Spark Domain Chip Labs") — descrito como "labs e camada de padrões", não um "cérebro hospedado mágico que roda sua vida"; é onde Spark aprende a construir especialistas corretamente.
- Recomendação: usar com um agente Spark, obtido via agent.sparkswarm.ai.
- Domínios de exemplo dados: QA, segurança, consultoria a startups, trading cripto, conteúdo, pesquisa, "back office".

## Implicacoes para o vault
- Operacionaliza diretamente o conceito já catalogado em `[[03-RESOURCES/concepts/agent-systems/agent-loop-design]]` e `[[03-RESOURCES/concepts/agent-systems/agent-loop]]` — adiciona a peça "eval como produto" como requisito central de qualquer loop que pretenda ser self-improving, reforçando `[[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]`.
- Relaciona-se fortemente com `[[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]` e `[[03-RESOURCES/concepts/agent-systems/halo-harness-self-optimization]]` — o "autoloop" descrito é essencialmente um generator-verifier-loop com guardrails de mutação explícitos.
- Conceito "domain chip" (especialista de domínio único + benchmark + autoloop) é um framing aplicável aos agentes do vault em `04-SYSTEM/agents/` — cada agente especializado (hill, guard, verify etc.) já é, em essência, um "chip"; falta formalizar o "benchmark pack" para cada um, ideia a considerar para `[[04-SYSTEM/AGENTS.md]]`.
- Confirma a importância de "evidence gates" e "rollback" já presentes em discussões de `[[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]`.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/halo-harness-self-optimization]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
