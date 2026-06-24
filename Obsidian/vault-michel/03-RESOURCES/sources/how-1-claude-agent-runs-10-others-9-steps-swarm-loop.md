---
title: "How 1 Claude Agent Runs 10 Others · 9 STEPS Swarm Loop"
type: source
source: Clippings/How 1 Claude Agent Runs 10 Others · 9 STEPS Swarm Loop.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Spawnar 10 agentes em paralelo (Claude Code Dynamic Workflows) é fácil e quase sempre produz caos — a habilidade real é o loop de 9 passos que transforma "uma multidão" em "um time": decomposição aprovada por humano, isolamento por worktree, gate determinístico por hook, grading automático com revisão forçada, e merge centralizado por um único lead. O loop importa mais que o swarm.

## Argumentos principais
- **Passo 1-3 (antes de spawnar)**: só vale paralelizar tarefa que decompõe em 3+ peças genuinamente independentes; o lead decompõe primeiro (sem spawnar ainda) e mostra o plano; humano aprova — checkpoint único e mais importante, porque dependência errada aqui = merge hell depois.
- **Passo 4-5 (isolamento + fan-out)**: cada subagente roda em `isolation: worktree` próprio (branch isolado, zero colisão de arquivo); sweet spot é 3-5 agentes concorrentes para trabalho do dia a dia — escalar a dezenas/centenas só quando a tarefa genuinamente justifica (benchmark suite, edits em muitos arquivos independentes).
- **Passo 6-7 (gate + grade)**: hook `SubagentStop` checa non-negotiables deterministicamente (testes passam, sem secrets no diff, sem escrita fora do escopo) antes do lead aceitar o resultado de volta; um grader separado (rubric-based) reprova e força revisão automática até passar — sem revisão manual de cada um dos 10 outputs.
- **Passo 8-9 (merge + empacotamento)**: só o lead integra (nunca os próprios workers) — merge em ordem de dependência, suite de teste completa entre cada merge; depois de provado, o loop inteiro vira skill/slash-command reutilizável (`/swarm`).

## Key insights
- "Ten unmanaged agents is just ten ways to create a merge conflict" — a paralelização em si não é o ganho, a estrutura em torno dela é. Eco direto do princípio "verify por regra dura, não vibe" já catalogado neste vault para qualquer pipeline autônomo.
- O hook determinístico (`SubagentStop`) + grader separado em contexto isolado reproduzem exatamente os dois antídotos a self-preferential bias e laziness já descritos em [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]] (avaliador não é o avaliado; loop não cansa).
- "Lead-only merge" é o análogo direto de um tech lead integrando PRs de um time — generalização útil: paralelizar trabalho sem centralizar integração é o erro recorrente que destrói qualquer swarm, humano ou agente.

## Exemplos e evidências
- Exemplo central: 10 branches finalizadas, testadas e revisadas em 20 minutos a partir de uma única instrução.
- Snippets de configuração reais: `isolation: worktree` no frontmatter do subagent; hook `SubagentStop` chamando `npm run test && npm run lint`; SKILL.md de 8 linhas encapsulando o loop completo.

## Implicações para o vault
- Detalha o mecanismo operacional (worktree isolation, SubagentStop hook, grader separado, lead-only merge) que falta em [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]] — esse concept já cobre os 6 padrões e o argumento "orchestrator saiu do modelo e entrou no código", mas não o protocolo passo-a-passo de como rodar um swarm com segurança.
- Diretamente aplicável a qualquer expansão futura do `pipeline-semanal` deste vault que use dispatch paralelo de subagentes de ingest (já em uso) — reforça que o gate determinístico (não revisão humana de cada um) é o que escala.

## Links
- [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]]
