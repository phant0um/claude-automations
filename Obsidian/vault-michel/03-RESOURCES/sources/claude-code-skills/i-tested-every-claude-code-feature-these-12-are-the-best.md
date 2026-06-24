---
title: "I Tested Every Claude Code Feature, These 12 Are the Best"
type: source
source: "Clippings/I Tested Every Claude Code Feature, These 12 Are the Best.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Depois de 500 horas em Claude para rodar negócios e canal YouTube (knowledge work + automação, não engenharia de software), a feature #1 por larga margem são Skills — porque transformam reprompting repetitivo em uma receita reutilizável. O tier list revela quais features têm impacto real no dia-a-dia versus quais são impressionantes em demo.

## Argumentos principais

- Skills são o número 1 porque substituem reprompting pelo mesmo padrão: Claude abre a receita e segue os passos — como pegar a receita de lasanha em vez de cozinhar de memória.
- Status line (barra de contexto no terminal) é "the most slept on feature" — mostra modelo, esforço e % de contexto consumido em tempo real; razão principal para migrar de VS Code extension para terminal.
- Agent teams diferem de subagents de forma fundamental: teams debatem entre si (personas distintas), subagents só falam com a sessão que os invocou.
- Routines = agendamento de um agente real, não um script Python determinístico; visualizadas e gerenciadas no desktop app.

## Key insights

- Top 12 em ordem: Skills (#1), Status line (#2), Routines (#3), Remote control (#4), /loop (#5), Sub agents (#6), /rewind (#7), Agent teams (#8), Auto memory (#9), /insights (#10), Ultraplan (#11), /goal (#12).
- /goal: definição objetiva de "done" permite largar e voltar confiante — exemplo: otimizar globe no website até aparecer instantaneamente → 1h30 de tentativas → problema resolvido.
- Ultraplan: offload de planejamento para nuvem com múltiplos agentes de planejamento — clona o repo, faz compute na nuvem, devolve o plano para o terminal local.
- /insights: relatório dos últimos 30 dias no Claude Code — o que faz muito, o que faz mal, features a usar mais, skills a construir. Exemplo: 1.500+ mensagens em 153 sessões com table of contents para quick wins.
- Auto memory: Claude melhora sua própria memória em background sem prompting — "it basically dreams and gets smarter". Verificar com /memory se está ativo.
- /rewind: roll back de código E conversa para um checkpoint anterior — melhor que argumentar "no, do it this way instead" quando algo foi cacheado.
- Remote control: controla Claude Code local pelo celular ou web — o que você digita no celular aparece no computador, sessão totalmente sincronizada.
- /btw: faz uma pergunta sem interromper o que o terminal principal está fazendo.
- Recap: ao ficar idle, Claude Code mostra o que a sessão estava fazendo — com múltiplas abas abertas, o recap no inferior de cada terminal diz exatamente o que cada uma estava processando.
- Cowork vs Claude Code: tudo que Cowork faz, Code também faz; diferença é UI visual vs terminal.

## Exemplos e evidências

- Autor usa Claude Code como executive assistant e AI operating system, não para desenvolvimento de software.
- Status line mostra: "Opus 4.8, effort level, and exactly how much context is gone. 27%, 274,000 of a million tokens."
- Agent teams: uma persona como total beginner, outra como CEO, debatem até convergir — perspectivas que colidem são genuinamente úteis.
- Cowork é C tier porque "you can do pretty much anything in Cowork in Code" — mas é ponto de entrada válido para não-técnicos.

## Implicações para o vault

- Skills como #1 feature valida a arquitetura de 04-SYSTEM/skills/ como o investimento mais alto-alavancagem no vault.
- /insights como feature de desenvolvimento pessoal é interessante — gera relatório de uso que pode informar melhorias nos workflows do vault.
- A distinção Agent teams (debatem) vs Sub agents (reportam) confirma a taxonomia usada em outros sources desta ingestão e clarifica quando usar cada primitivo.
- /rewind como alternativa a "argumentar com Claude" é um padrão de error recovery a documentar.

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-skills]]
- [[03-RESOURCES/concepts/ai-agents/claude-code]]
- [[03-RESOURCES/concepts/ai-agents/claude-routines]]
- [[03-RESOURCES/concepts/ai-agents/multi-agent-systems]]
- [[03-RESOURCES/concepts/ai-agents/context-window-management]]
