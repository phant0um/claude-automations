---
title: "The Debug Loop: How Claude Code Finds the Bug in 6 Steps Instead of 60"
type: source
source: "Clippings/The Debug Loop How Claude Code Finds the Bug in 6 Steps Instead of 60.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
"Colar erro, pedir fix" não é debug, é aposta — gera o ciclo de 40-60 mensagens onde cada fix é um chute e o bug original nunca sai do lugar. Debug real é um processo de 6 passos (reproduzir, isolar, traçar causa raiz, corrigir a causa, verificar, proteger contra retorno) — Claude Code já é capaz de rodar todos eles, só não pode pular direto pro passo 4.

## Argumentos principais
- **Passo 1 — Reproduzir de forma confiável**: bug que não reproduz sob comando é bug que não se consegui corrigir — todo "fix" fica infalsificável (não dá pra saber se funcionou ou se foi sorte). Comando: pedir teste falhando ou script mínimo que dispara o bug toda vez, sem propor fix ainda.
- **Passo 2 — Isolar a área de busca em plan mode**: sem limite, o agente lê o repo inteiro por 20min procurando o bug. Plan mode deixa o Claude formar hipótese de onde o bug provavelmente vive e listar 2-3 arquivos suspeitos com raciocínio, antes de tocar em qualquer coisa.
- **Passo 3 — Traçar causa raiz com subagentes de investigação (read-only)**: em vez de 1 agente lendo tudo no contexto principal, dispara subagentes — um seguindo o fluxo de dado até a função que falha, um checando mudanças recentes nos arquivos suspeitos, um inspecionando o edge case que o teste expõe. Cada um reporta achado; agente líder monta conclusão de causa raiz única com evidência. Razão pra usar subagentes: investigação gera muita leitura — no contexto principal isso degrada a sessão e o Claude perde o fio; subagentes mantêm cada linha de investigação isolada e retornam só a conclusão.
- **Passo 4 — Corrigir a causa, não o sintoma**: com causa raiz confirmada, fix é cirúrgico em vez de especulativo. É onde a abordagem de 60 mensagens falha silenciosamente — corrige o sintoma (ex.: o NaN), a causa real (ex.: falta guarda de carrinho vazio) reaparece de outra forma na semana seguinte. Instrução explícita: corrigir a causa identificada, e sinalizar se o "fix" só tampa o sintoma.
- **Passo 5 — Verificar com hook**: gap de "confia-depois-verifica" é real (agente diz "corrigido", você aceita, depois descobre teste vermelho). Hook `Stop` que roda o comando de teste automaticamente antes de poder finalizar — "corrigido" passa a exigir teste verde, não afirmação.
- **Passo 6 — Proteger contra retorno**: o teste de reprodução do passo 1 se torna teste de regressão permanente, nomeado claramente com comentário de uma linha explicando a causa raiz que guarda — diferença entre corrigir um bug e de fato fechá-lo.

## Key insights
- A causa raiz do "ciclo de 60 mensagens" é pular direto pra correção antes de achar o que está de fato quebrado — cada "fix" nesse modo é um chute, e chute tampa sintoma.
- Subagentes read-only de investigação resolvem um problema de gerenciamento de contexto, não só de paralelismo: a sessão principal "perde o fio" quando acumula leitura exploratória, então isolar essa leitura em subagentes mantém a sessão principal enxuta.
- O hook de verificação (`Stop` → roda teste) transforma "corrigido" de claim em propriedade verificável automaticamente — fecha exatamente o gap que normalmente é responsabilidade do humano notar.

## Exemplos e evidências
- Comandos prontos pra cada passo (prompts copy-paste) e exemplo de hook `.claude/settings.json` com `Stop` → `npm run test`.
- Cenário concreto usado como contraste: bug de NaN tampado sem corrigir a causa raiz (falta de guarda de carrinho vazio) — reaparece em nova forma.

## Implicações para o vault
Receita praticamente idêntica ao padrão "comando + hook PostToolUse/Stop + protocolo CLAUDE.md" já identificado no batch anterior ([[03-RESOURCES/sources/how-to-build-a-claude-code-agent-that-fixes-its-own-bugs-in-a-loop]]) — confirma terceira fonte independente convergindo no mesmo design (reprodução → isolamento → causa raiz → fix → hook de verificação → regressão). Subagentes read-only pra investigação sem poluir contexto principal é um padrão que vale generalizar para o próprio pipeline de triagem/ingest deste vault quando precisar investigar inconsistência (ex.: dedup-gap do manifest).

## Links
- [[03-RESOURCES/sources/how-to-build-a-claude-code-agent-that-fixes-its-own-bugs-in-a-loop]]
- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/concepts/agent-systems/agent-orchestration]]
