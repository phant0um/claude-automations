---
title: "Building workflows for agents with Skills + Interpreters"
type: source
source: Clippings/Building workflows for agents with Skills + Interpreters.md
author: "@huntlovell"
published: 2026-05-29
created: 2026-05-29
ingested: 2026-05-29
tags: [ai-agents, skills, interpreters, deep-agents, langchain, workflows, determinism]
---

## Tese central

Interpreter skills são uma extensão do padrão de skills que une duas capacidades complementares: as instruções de quando usar um comportamento (SKILL.md) e o código TypeScript executável que define como esse comportamento funciona (index.ts). Isso resolve o problema central de agentes modernos — como garantir que procedimentos determinísticos sejam seguidos com fidelidade — sem sacrificar a flexibilidade do modelo para decidir quando aplicá-los.

## Argumentos principais

- **O problema raiz**: quando um agente com intérprete recebe a mesma tarefa múltiplas vezes, pode chegar a várias abordagens válidas em código. Para muitas tarefas, o desejável não é "encontrar uma boa abordagem" mas "usar a abordagem que sabemos que funciona".
- **Skills como unidade de distribuição**: skills são o padrão de facto para empacotar comportamento de agente — com progressive disclosure, versionamento, compartilhamento e avaliação independente sem engordar o prompt global.
- **Progressive disclosure**: o agente não precisa de todas as skills em contexto o tempo todo; vê uma lista curta de descriptions, decide quais são relevantes, e só então lê o SKILL.md completo.
- **Interpreter skills vs. skills normais**: uma skill normal diz "aqui estão instruções de como fazer esta tarefa" (o agente ainda precisa interpretá-las). Uma interpreter skill diz "aqui estão instruções de quando usar este comportamento, e aqui está o caminho de código a executar quando aplicar".
- **O modelo ainda decide**: o modelo decide quando a skill se aplica, quais inputs passar, como usar o output, e o que fazer a seguir. O módulo define como os procedimentos devem ser executados.
- **Scripts vs. módulos de intérprete**: scripts comunicam via argumentos de linha de comando, arquivos, stdout/stderr — úteis para helpers externos. Módulos de intérprete participam do loop do harness (spawnam subagentes, fazem scheduling de task graphs, lidam com falhas parciais, decidem quando a rotina está "done" antes de retornar controle ao modelo).
- **Tools vs. operações locais**: tools são melhores para cruzar fronteiras externas (fetch data, read/write files, criar tickets). Para operações locais (parse, join, filter, validate), transformar cada helper em tool engorga a action surface desnecessariamente. O runtime TypeScript (já proeminente nos pesos do modelo) representa isso melhor.
- **Estado persistente de intérprete**: valores TypeScript persistem entre turns (arrays ficam arrays, objetos ficam objetos, funções helper ficam definidas). O agente não precisa converter cada valor intermediário em stdout, arquivo, ou mensagem de volta ao modelo.
- **Controle de acesso por design**: diferente de sandboxes, código de intérprete não tem acesso irrestrito ao ambiente host por padrão. Filesystem, rede, tools e subagentes precisam ser expostos deliberadamente — dá ao harness um lugar para allowlist, metering e inspeção.

## Key insights

**Forma básica de uma interpreter skill:**
- `SKILL.md` — nome, descrição, instruções de uso, import path, constraints (como o agente descobre e usa o comportamento)
- `index.ts` — exporta helpers ou workflows que definem o comportamento em código

**Exemplo: github repo triage**
```typescript
const { triage } = await import("@/skills/github-triage");
const result = await triage("langchain-ai/deepagents", { issues: true, prs: true });
```
Quando chamado, a rotina: (1) busca todos os items abertos do GitHub; (2) spawna um subagente por item para criar descrição condensada; (3) coloca respostas numa queue; (4) consome a queue onde um subagente determina clustering. Na prática, fan-out para centenas de subagentes — exatamente o tipo de rotina onde se quer procedimento fixo mesmo com inputs dinâmicos.

**Context anxiety**: modelos em harnesses típicos perdem coerência em tarefas longas — 300 items de repo = 300 pedaços de estado que o modelo precisa raciocinar enquanto reconcilia decisões passadas. Com interpreter skill, o modelo invoca a rotina uma vez e o código instrumenta o workflow. O modelo não é mais responsável por carregar cada passo parcial em seu contexto de trabalho.

**Resultado estruturado como API**: `result.clusters`, `result.unassigned`, `result.toMarkdown()`. O agente pode continuar trabalhando com dados estruturados, inspecionar um cluster mais profundamente, ou spawnar subagentes de follow-up.

**O que skills como workflows resolvem**: procedure following prompt-only é frágil — agente pode pular passos, reordenar, satisfazer instrução errada, ou produzir output "good enough" sem seguir o processo. Com interpreter skills:
- Prompt-only: "o agente seguiu geralmente as instruções? parece que ficou no caminho?"
- Com interpreter skill: "o agente chamou a função esperada? passou os inputs esperados? a função retornou o shape de output esperado?"

**Skills como gerenciamento de estado**: interpreter skills ensinam o agente como interagir com estado. Exemplo skill para CSVs: `parseCsv`, `joinTables`, `filterRows`, `validateRows`, `groupBy`, `summarize`, `toCsv`. O agente controla quais valores passar e o que fazer com o resultado; o author da skill controla o que "join", "validate", e "summarize" significam. Isso é diferente de pedir ao agente para escrever o helper — modelos são bons em escrever código, mas não garantem escrever o mesmo código duas vezes.

**Por que empacotar como skill?** Skills são o mecanismo de distribuição padrão — discovery, progressive disclosure, usage instructions, exemplos, arquivos de suporte. Interpreter skills preservam esse shape e estendem com runtime code. Se uma org tem centenas ou milhares de skills, seria inviável conectar todos os módulos requeridos diretamente ao harness.

**Geração anterior vs. atual de agentes**: geração anterior = workflow-style (desenvolvedor define sequência de passos explicitamente; confiabilidade vem de pré-definir o caminho). Agentes modernos = context + model discretion (modelo decide o próximo passo baseado no contexto atual). Interpreter skills são "o melhor dos dois mundos": determinismo na parte determinística, modelo no controle de quando aplicar.

## Exemplos e evidências

- **Trace público**: https://smith.langchain.com/public/c869be73-f311-48cd-ac10-6834e65b0f42/r — mostra como o agente trabalha através da rotina de triage
- **Report público**: https://gist.github.com/hntrl/3008504cf4cb69cc7f36fda93dc2be35 — output do triage de langchain-ai/deepagents
- **Fan-out**: centenas de subagentes distintos para triage de um único repositório
- **Deep Agents**: disponível em Python (https://github.com/langchain-ai/deepagents) e TypeScript (https://github.com/langchain-ai/deepagentsjs)
- **Exemplo de skill com módulo**: `skills/github-triage/SKILL.md` + `skills/github-triage/index.ts`
- **Context anxiety**: fenômeno documentado em https://www.anthropic.com/engineering/harness-design-long-running-apps

## Implicações para o vault

Complementa e aprofunda [[03-RESOURCES/concepts/agent-systems/agentic-skills]] com um novo conceito: interpreter skills como síntese entre skills declarativas e workflows de código. O conceito resolve a tensão documentada em [[03-RESOURCES/concepts/agent-systems/workflow-compilation]] entre flexibilidade do agente e determinismo do workflow.

Confirma a arquitetura de progressive disclosure já documentada em [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — interpreter skills usam o mesmo mecanismo.

O conceito de "context anxiety" (mencionado no artigo, referenciado do post Anthropic sobre harness design para apps de longa duração) é relevante para [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]].

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/agent-systems/workflow-compilation]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-give-agents-interpreter]]
