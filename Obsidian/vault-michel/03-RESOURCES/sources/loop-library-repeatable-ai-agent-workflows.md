---
title: "Loop Library: Repeatable AI Agent Workflows"
type: source
source: "Clippings/Loop Library Repeatable AI Agent Workflows.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Uma biblioteca de 15 "loops" prontos para copiar, cobrindo engenharia, pesquisa, conteúdo editorial, avaliação e operações — cada um com trigger, ação, prova/verificação e condição de parada claras, formalizando o que faz um loop ser "útil" em vez de vago.

## Argumentos principais
- Definição operacional final do artigo: "um loop útil especifica: trigger, ação, prova, memória, e uma condição de parada" — cinco elementos obrigatórios, não quatro como costuma ser citado informalmente.
- Cada um dos 15 loops segue o mesmo formato: nome descritivo, ação detalhada, critério de verificação/parada explícito, atribuição ao autor original (majoritariamente Matthew Berman, alguns de Peter Steinberger).
- Loops cobrem times distintos: engenharia (docs sweep noturno, satisfação de arquitetura, otimização de page-load <50ms, sweep de erros de produção, cobertura de testes 100%, cobertura de logging, velocidade de suíte de testes, limpeza de repositório), conteúdo/SEO (loop de visibilidade SEO/GEO), qualidade (quality streak loop com N sucessos consecutivos, full product evaluation loop), operações (release loop stale-safe, limpeza de dados de produção, baseline pós-release).
- Cada loop tem critério de parada mensurável e reprodutível — não "melhore X" genericamente, mas "todas as páginas carregam em menos de 50ms, usando o mesmo benchmark, sem regressão" ou "toda a suíte passa com 100% de cobertura".
- O "quality streak loop" é notável por reiniciar a contagem a cada falha: ao falhar, documenta, adiciona cobertura de regressão e benchmark, corrige, e reinicia a streak — só para depois de N sucessos consecutivos.

## Key insights
- A coleção funciona como catálogo de referência prática complementar ao debate teórico sobre "o que é um loop" (presente em outras fontes deste mesmo batch, como "The Agent Loop Architecture" e "How to Set Up Claude Loops") — aqui o foco é em exemplos prontos, não em arquitetura.
- O loop de cleanup de repositório (012) e o de release stale-safe (013) tratam explicitamente o problema de "trabalho obsoleto" — branches, PRs e commits abandonados — como tarefa recorrente merecedora de automação, não só higiene manual ocasional.
- Cada loop especifica não só a verificação de sucesso, mas também a forma de comunicar o resultado (PR revisável, mensagem no Slack, registro de baseline) — reforça que "prova" inclui output legível por humano, não apenas o estado interno do sistema.

## Exemplos e evidências
- Tabela completa com os 15 loops, cada um com nome, ação, critério de verificação/parada e atribuição de autoria.
- Fonte é signals.forwardfuture.ai/loop-library — curadoria de terceiros agregando contribuições da comunidade (majoritariamente Matthew Berman).

## Implicações para o vault
Biblioteca diretamente aplicável ao pipeline de manutenção deste vault: vários loops mapeiam 1:1 para tarefas já existentes ou desejadas (loop de docs sweep noturno ≈ `hot.md` update; quality streak loop ≈ wiki-lint contínuo; repository cleanup loop ≈ revisão de Clippings/Archive). Candidato a inspiração direta para formalizar critérios de parada explícitos nos loops/skills `hill`, `review` e `verify` do sistema Nexus.

## Links
- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/concepts/pkm-obsidian/weekly-knowledge-routine]]
- [[03-RESOURCES/concepts/pkm-obsidian/wiki-linting]]
