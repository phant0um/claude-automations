---
title: "PreAct: Computer-Using Agents that Get Faster on Repeated Tasks"
type: source
source: Clippings/PreAct Computer-Using Agents that Get Faster on Repeated Tasks.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Agentes que operam software via tela (computer-using agents) resolvem cada tarefa do zero, mesmo quando já a fizeram antes — re-lendo a tela e re-raciocinando a cada passo, pagando o custo cheio repetidamente. PreAct (Bojie Li, Pine AI) resolve isso compilando a primeira execução bem-sucedida num programa de máquina de estados pequeno (estados checam a tela, transições agem) que é reexecutado diretamente nas próximas vezes — sem chamadas de LLM por passo — entregando 8.5–13× de velocidade, mas sem ficar "cego": a cada passo confere se a tela bate com o esperado antes de agir, devolvendo controle ao agente assim que algo diverge.

## Argumentos principais
- **O problema da amnésia repetida**: um agente pedido para "adicionar contato Emilia Gonzalez" hoje gasta meia dúzia de rodadas de inferência visão-linguagem; pedido de novo amanhã, recomeça do zero — a tela não mudou, os taps não mudaram, mas nada foi guardado de forma reexecutável.
- **Analogia humana de fluência**: alguém abrindo Photoshop por primeira vez é lento, lendo cada menu; depois de repetições, fica quase automático — mas a fluência não é cega: a pessoa ainda olha a tela e só age quando bate com o esperado, voltando a pensar devagar se algo trava ou aparece um diálogo inesperado. PreAct busca essa mesma "fluência preditiva, não cega".
- **Eficiência como métrica de primeira classe**: a maioria dos benchmarks mede apenas se a tarefa foi concluída, não quanto custou repeti-la — um agente que rederiva tudo do zero parece tão bom quanto um que aprendeu a pular a deliberação. PreAct mede repeated-task efficiency diretamente.
- **Diferença frente a trabalho prévio**: skill libraries (ex.: SAGE) salvam comportamentos parametrizados mas ainda dependem de um LLM em runtime para executá-los — a maior parte do custo por passo permanece. Sistemas de compilação visam lógica de negócio estreita ou constroem o programa rastreando a aplicação, não a partir de uma execução real bem-sucedida. Sistemas de record-and-replay cacheiam a sequência de ações e replicam, mas não conseguem dizer se cada passo realmente "pegou", não têm ramificação, e não melhoram a si mesmos.
- **A posição de PreAct**: o que o agente guarda é exatamente o que ele depois executa. Na primeira execução bem-sucedida, compila num pequeno autômato — cada estado carrega um check sobre a tela (ex.: "o formulário de contato está aberto"), cada transição carrega uma ação (ex.: tocar em "Create contact"). Disciplina "observar-antes-de-agir" é o que torna o replay direto confiável, em contraste com uma macro gravada que dispara passos cegamente.
- **Verify-before-Store Gate**: o mesmo tipo de check roda de novo no momento de decidir o que lembrar. Um programa compilado pode reproduzir até o último passo e ainda deixar a tarefa inacabada (ex.: aperta Save mas um campo obsoleto significa que o nome nunca foi digitado). Um avaliador independente confirma, a partir de estado limpo, que a tarefa foi de fato resolvida antes do programa entrar no repositório — sem isso, um agente que confia num programa assim falha do mesmo jeito toda vez que o reusa, e piora com o uso.

## Key insights
- O ganho de eficiência não vem de um modelo melhor, vem de **não chamar o modelo** nos replays bem-sucedidos — o custo cai para quase zero por execução repetida.
- A arquitetura é um harness fixo + corpus que cresce: o código do harness (Program Selector → Replayer → fallback para CUA completo → compilação em novo programa) é fixo; o que acumula é a biblioteca de programas.
- O artigo reporta explicitamente o que **não** importou nos experimentos: redação do prompt, guardrails de runtime, e se um LLM ou um simples embedding retriever seleciona qual programa reusar — um resultado negativo informativo sobre onde investir esforço de engenharia.

## Exemplos e evidências
- Resultados quantitativos: 8.5–13× mais rápido em wall-clock nos replays bem-sucedidos, sem chamadas de LLM por passo.
- Verify-before-Store vale 1.75–2.6 tarefas por benchmark (mesma direção nos três: mobile, desktop, web) — separa execuções repetidas que melhoram das que degradam conforme programas defeituosos acumulam.
- Fallback que explora do zero quando nenhum programa compatível existe deixa PreAct no nível de uma baseline forte de record-and-replay.
- Testado em três benchmarks (mobile/AndroidWorld, desktop, web).
- Código aberto: github.com/19PINE-AI/PreAct.

## Implicações para o vault
Conecta diretamente com `browser-agent-amnesia` (mesmo diagnóstico: agentes re-descobrem do zero a cada execução) oferecendo uma solução concreta e mensurada — compilação verificada de trajetória bem-sucedida em programa reexecutável. Também se relaciona com `agent-skill-graduation` (converter execução bem-sucedida em artefato durável), mas PreAct vai além ao formalizar o artefato como máquina de estados com checks observacionais, não apenas como skill em texto.

## Links
- [[03-RESOURCES/concepts/agent-systems/browser-agent-amnesia]]
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]]
