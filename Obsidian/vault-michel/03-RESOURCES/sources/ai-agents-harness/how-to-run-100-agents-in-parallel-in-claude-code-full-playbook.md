---
title: "How to Run 100 Agents in Parallel in Claude Code (Full Playbook)"
type: source
source: "Clippings/How to Run 100 Agents in Parallel in Claude Code (Full Playbook).md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

O Claude Code lançou "dynamic workflows" — uma feature que permite ao próprio Claude escrever scripts de orquestração, quebrar uma tarefa em subtarefas e disparar dezenas a centenas de subagentes paralelos a partir de um único prompt. O usuário descreve o problema; o Claude projeta o fan-out. Isso representa um terceiro nível de paralelismo além de subagentes e agent teams, com o caso-prova sendo a reescrita de Bun (750,000 linhas de Zig para Rust em 11 dias).

## Argumentos principais

- **Três modos de multi-agent distintos** — é crítico não confundir:
  - **Subagents**: rodam dentro de uma sessão, tarefa única bem definida, reportam ao parent, não conversam entre si. Custo previsível e baixo.
  - **Agent teams**: múltiplas sessões Claude completas que coordenam, trocam mensagens entre si e dividem trabalho. Cada mensagem entre agentes é uma round trip cobrada.
  - **Dynamic workflows** (novo): Claude escreve a própria orquestração, quebra a tarefa, dispara dezenas a centenas de subagentes paralelos em uma sessão. O usuário não projeta a orquestração — o Claude faz.
- **Dynamic workflows como "gap-filler"**: senta entre um único subagente e um agent team construído à mão. Útil quando a tarefa é massiva, paralela e exige verificação dupla.
- **Prova empírica — Bun rewrite**: Jarred Sumner portou Bun de Zig para Rust com dynamic workflows: workflow 1 mapeou lifetimes Rust para cada struct field em todo o codebase Zig; workflow 2 escreveu cada arquivo .rs como port behavior-identical do .zig correspondente (centenas de agentes paralelos, dois reviewers por arquivo); fix loop até build e testes passarem; workflow overnight caçou cópias desnecessárias de dados e abriu PR separado para cada uma.
- **Model tiering é obrigatório para não falir**: por padrão todos os agentes do workflow usam o modelo da sessão atual. Se for Opus, são centenas de agentes Opus. A solução é tiering explícito por tarefa: Haiku para classificação/extração/formatação, Sonnet para sumarização/geração de código/análise moderada, Opus para o orquestrador e raciocínio complexo.
- **Cache hits custam 10% do preço de input standard**: estruturar workflows para maximizar prompt caching — prefixos compartilhados entre subagentes — paga off depois de um cache read dentro do TTL de 5 minutos.
- **ultracode**: configuração nova no Claude Code via menu `/effort`. Define esforço em xhigh e deixa o Claude decidir automaticamente quando uma tarefa é grande o suficiente para um workflow. Com auto permission mode, pula a confirmação inicial. Aviso: consumo de tokens vai vertical.
- **Verificação adversarial como padrão**: o design dos prompts de dynamic workflows inclui explicitamente "spawn a verification agent that confirms it's a real issue by tracing the code path" — agentes tentando refutar os achados dos primeiros.
- **Regra de match**: subagents para tarefas repetíveis e bem definidas (custo baixo); agent teams para tarefas dependentes sequenciadas (custo médio); dynamic workflows para tarefas massivas paralelas onde o custo de uma resposta errada justifica tentativas independentes com verificação adversarial (custo muito alto).

## Key insights

- **O gargalo da IA em coding migrou de capability para orchestration**: "can the model write good code" está majoritariamente resolvido. O novo gargalo é "can you describe a problem so it fans out across 100 agents, pick the right mode, tier your models, scope tightly enough."
- **A pergunta mudou**: não é mais "quanto tempo isso vai levar?" mas "como descrevo isso para o Claude paralelizar?"
- **Escopo específico é não-negociável**: "improve the codebase" é um buraco de dinheiro. "find unused exports in /src/services and verify each one" é um workflow.
- **Não começar com o maior problema**: Anthropic recomenda explicitamente começar com uma tarefa contida ("audit this one module") para entender uso e custo antes de escalar.
- **Economia do tiering**: taxas API atuais — Haiku 4.5: $1/$5 por milhão de tokens (input/output), Sonnet 4.6: $3/$15, Opus: $5/$25. Output tokens custam 5x os input tokens em todos os modelos. Split 70/20/10 Haiku/Sonnet/Opus em vez de tudo-Opus pode reduzir o custo total em mais da metade.
- **Progresso é salvo durante a execução**: run interrompido retoma de onde parou, não paga duas vezes.
- **O plano do workflow aparece antes de executar**: o Claude mostra o que está prestes a rodar e pede confirmação. Ler o plano antes de aprovar é parte crítica do processo — se está planejando escanear 50 diretórios quando você queria 5, corrigir antes de gastar tokens.
- **Klarna usou dynamic workflows** para descoberta de dead code e oportunidades de cleanup que static analysis convencional perdeu completamente.

## Exemplos e evidências

- **Bun rewrite**: 750,000 linhas de Rust, 99.8% dos testes passando, 11 dias. Port de linguagem normalmente de quarter para uma equipe inteira.
- **CyberAgent engineer** descreveu dynamic workflows como "gap-filler" entre single subagent e hand-built agent team.
- **Klarna** usou para descoberta de dead code — validação de uso em produção real por empresa grande.
- **Prompts copy-paste funcionais** para: codebase-wide bug hunt, security audit, large migration/framework swap, profiler-guided optimization.
- **Preços API documentados**: Haiku 4.5 ($1/$5), Sonnet 4.6 ($3/$15), Opus ($5/$25) por milhão de tokens input/output.
- **Disponibilidade**: Max e Team (on por padrão), API (on por padrão), Enterprise (off por padrão, admin habilita).
- **Superpowers (170k+ stars)**: framework complementar com brainstorm → spec → plan → review que se encaixa bem com dynamic workflows.

## Implicações para o vault

- Introduz "dynamic workflows" como conceito central de orquestração avançada — candidato a novo conceito em [[03-RESOURCES/concepts/ai-agents/]].
- O modelo de tiering Haiku/Sonnet/Opus por complexidade de subtarefa é uma prática de engenharia de custo que o vault-michel deve documentar como padrão nos pipelines.
- A distinção de três modos (subagents/agent teams/dynamic workflows) formaliza uma taxonomia que os outros sources desta ingestão assumem implicitamente.
- O conceito de "verificação adversarial" (agentes tentando refutar achados de outros) é uma técnica de qualidade relevante para qualquer pipeline de análise multi-agent.
- Expande e potencialmente contradiz sources anteriores sobre custo de multi-agent — os números de economia de 60-80% por tiering são mais agressivos do que estimativas anteriores.

## Links

- [[03-RESOURCES/concepts/ai-agents/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/ai-agents/context-engineering]]
- [[03-RESOURCES/sources/how-to-make-agentic-workflows-100x-cheaper-full-guide]]
- [[03-RESOURCES/sources/stop-asking-whether-the-agent-worked-ask-what-the-harness-observed]]
- [[03-RESOURCES/sources/how-to-master-context-engineering-in-claude-code-5-patterns-and-13-steps-anthropic-engineers-use]]
