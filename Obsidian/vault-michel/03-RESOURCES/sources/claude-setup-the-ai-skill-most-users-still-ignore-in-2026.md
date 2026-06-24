---
title: "Claude Setup: The AI Skill Most Users Still Ignore in 2026"
type: source
source: Clippings/CLAUDE SETUP The AI Skill Most Users Still Ignore in 2026.md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, claude-code-tooling]
---

## Tese central
A maioria dos usuários do Claude nunca configura nada além do prompt — reconstroem o mesmo contexto/instrução em cada chat. O artigo descreve camadas de setup progressivas (preferências de resposta, styles, Projects, Project Instructions) que transformam Claude de modelo genérico em sistema de especialistas configurados.

## Argumentos principais
- **Layer 1 — Preferências de resposta padrão**: tom, comprimento, formatação, idioma, nível de detalhe, o que evitar/sempre incluir. Regra prática: "se você digita a mesma instrução em todo chat, ela não pertence ao prompt — pertence ao setup."
- **Layer 2 — Styles**: não são apenas vozes de escrita, são modos operacionais (um style para posts no X, outro para emails de cliente, outro para resumos de pesquisa). Salvar o modo uma vez e trocar de style em vez de reconstruir a voz do zero é o que faz um modelo parecer múltiplos especialistas.
- **Layer 3 — Projects**: chat normal serve para perguntas aleatórias; Project serve para qualquer trabalho com contexto persistente (cliente, produto, codebase, newsletter). Contexto limpo (sem mistura de domínios) gera respostas mais afiadas.
- **Layer 4 — Project Instructions**: um Project sem instruções é só uma pasta — as instruções são o "modo operacional" que transforma armazenamento passivo em comportamento ativo configurado.

## Key insights
- O padrão geral é: qualquer instrução repetida em múltiplas sessões é sinal de configuração ausente, não de prompt mal escrito.
- A progressão setup → styles → projects → instructions é uma hierarquia de persistência crescente: do efêmero (1 mensagem) ao permanente (1 domínio inteiro).

## Exemplos e evidências
- Lista enumerada de casos de uso de Projects (cliente, produto, codebase, newsletter, curso, pesquisa, sistema de conteúdo, workflow pessoal, ideia de negócio).

## Implicações para o vault
O vault já implementa essencialmente Layer 3+4 via CLAUDE.md por projeto e skills/agents especializados — esta fonte é validação externa do design, mais do que novidade. Útil como checklist de auditoria: confirmar se preferências de resposta (Layer 1) estão de fato centralizadas e não repetidas em cada prompt.

## Links
- [[03-RESOURCES/concepts/agent-systems/claude-code-agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- [[03-RESOURCES/entities/Claude Code]]
