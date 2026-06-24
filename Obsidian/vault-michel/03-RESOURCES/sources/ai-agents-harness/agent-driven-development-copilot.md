---
title: Agent-driven development in Copilot Applied Science
type: source
source: Clippings/Agent-driven development in Copilot Applied Science.md
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
Tratar agentes de codificação (Copilot CLI, Claude Opus 4.6) como engenheiros juniores recém-chegados — dar contexto rico, criar guardrails, e construir o repositório como "agent-first" — desbloqueia ganhos de velocidade e colaboração que parecem desproporcionais (5 pessoas criaram 11 agentes, 4 skills e um conceito novo de workflow em menos de 3 dias, +28.858/-2.884 linhas em 345 arquivos).

## Argumentos principais
- **Origem do projeto**: o autor (AI researcher na Copilot Applied Science) automatizava análise de trajetórias de agentes (arquivos `.json` com centenas de linhas, multiplicados por dezenas de tasks e múltiplos benchmark runs = centenas de milhares de linhas/dia). Usava Copilot repetidamente para surfar padrões → decidiu automatizar esse próprio loop, criando `eval-agents`.
- **Três metas de design**:
  1. Tornar agentes fáceis de compartilhar e usar
  2. Tornar fácil autorar novos agentes
  3. Tornar agentes de codificação o veículo primário de contribuições — esta foi a que mais moldou o projeto.
- **Setup do autor**: Copilot CLI + Claude Opus 4.6 + VSCode. Usou Copilot SDK (que roda sobre o Copilot CLI) para acelerar criação de agentes — acesso a tools/MCP existentes, registro de novas tools/skills, etc.
- **Três princípios centrais**:
  1. **Estratégias de prompting**: agentes funcionam melhor quando você é conversacional, verboso, e usa modos de planejamento (`/plan`) antes de modos de execução. Stream-of-consciousness sobre o problema funciona melhor que statements terse.
  2. **Estratégias arquiteturais**: refatorar, atualizar docs, limpar código com frequência — esse trabalho de manutenção (antes deprioritizado) torna-se o trabalho mais importante quando se quer entregar features rapidamente com agentes. Pergunta-chave: "Sabendo o que sei agora, como eu desenharia isso diferente?" — e então rearquitetar com ajuda do agente.
  3. **Estratégias de iteração**: mudança de mindset de "trust but verify" para "blame process, not agents" — cultura blameless. Implementa-se processos/guardrails para prevenir erros; quando um erro acontece, adicionam-se mais guardrails/testes para que não se repita. CI/CD rigoroso é mandatório (typing estrito, linters robustos, testes de integração/e2e/contrato).

## Key insights
- **"Reserved test space"**: exemplo de prompt de planejamento que gerou guardrails tipo "contract testing" que só humanos podem alterar — resposta a Copilot "atualizar testes felizmente para caber em novos paradigmas" mesmo quando não deveria.
- **Loop de desenvolvimento completo proposto**:
  1. Planejar feature com Copilot via `/plan` (iterar plano, garantir que testes e atualização de docs estejam incluídos e feitos *antes* da implementação).
  2. Copilot implementa via `/autopilot`.
  3. Loop de revisão: solicitar Copilot Code Review, esperar revisão, endereçar comentários relevantes, re-solicitar revisão — repetir até não haver mais comentários relevantes.
  4. Revisão humana — onde o autor aplica os padrões discutidos.
- **Prompts recorrentes fora do loop de feature** (rodados semanalmente, às vezes mais):
  - `/plan Review the code for any missing tests, any tests that may be broken, and dead code`
  - `/plan Review the code for any duplication or opportunities for abstraction`
  - `/plan Review the documentation and code to identify any documentation gaps. Be sure to update the copilot-instructions.md to reflect any relevant changes`
- **Analogia central**: agente de codificação = engenheiro júnior. Onboard bem, dê contexto claro, construa guardrails para que erros não virem desastres, confie para crescer. Se algo dá errado, culpe o processo, não o agente.
- Quando Copilot tem essas ferramentas (typing, linters, testes) disponíveis no loop de desenvolvimento, ele pode **checar o próprio trabalho** — setup para sucesso similar ao de um engenheiro júnior.

## Exemplos e evidencias
- Resultado quantitativo: 5 pessoas, 11 novos agentes, 4 novas skills, conceito de "eval-agent workflows" (streams de raciocínio tipo cientista) em menos de 3 dias → +28.858/-2.884 linhas em 345 arquivos.
- `eval-agents` reduziu o trabalho de leitura de "centenas de milhares de linhas" para "algumas centenas" por meio de detecção de padrões via Copilot + investigação humana.
- Referências externas: TerminalBench2, SWEBench-Pro como benchmarks de avaliação de agentes de codificação.
- Receita prática final: baixar Copilot CLI, ativar no repo (`cd <repo_path> && copilot`), rodar `/plan Read <link> and help me plan how I could best improve this repo for agent-first development`.

## Implicacoes para o vault
- Confirma e reforça práticas já documentadas em `[[03-RESOURCES/concepts/agent-systems/agentic-sdlc]]` e `[[03-RESOURCES/concepts/agent-systems/spec-driven-development]]`: planejamento explícito antes de execução, documentação como guardrail vivo.
- O padrão "blame process, not agents" é um adendo prático ao princípio de verification-driven development — relevante para `[[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]` (item "verify before done").
- O loop plan → implement → review-loop → human-review é um exemplo concreto de `[[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]` aplicado a CI/CD agent-driven.
- Reforça o valor de manter CLAUDE.md / copilot-instructions.md atualizados continuamente como parte do loop (já refletido na convenção do vault de revisão de CLAUDE.md).

## Links
- [[03-RESOURCES/concepts/agent-systems/agentic-sdlc]]
- [[03-RESOURCES/concepts/agent-systems/spec-driven-development]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
- [[03-RESOURCES/entities/Claude-Opus-46]]
