---
title: "Contextual Agentic Memory is a MEMO"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# Contextual Agentic Memory is a MEMO

Memória de agente pode ser sintetizada como MEMO: quatro tipos de memória que mapeiam o que o agente sabe, viveu, aprendeu, e observou.

## O que é

O framework **MEMO** é uma taxonomia de memória agêntica derivada de pesquisa sobre como sistemas de IA deveriam estruturar e recuperar informação contextual. Cada letra representa um tipo:

- **M — Memory (Semântica/Declarativa)**: fatos gerais, conhecimento do domínio, preferências do usuário. "Michel usa PT-BR, estuda ADS na FIAP."
- **E — Episodic**: histórico de interações passadas, eventos contextualizados no tempo. "Na sessão de quinta, ingerei 17 fontes sobre Java."
- **M — Model (Procedimental)**: como fazer coisas — skills, workflows, planos reutilizáveis. O arquivo `04-SYSTEM/skills/` do vault.
- **O — Observation**: percepções do ambiente atual, estado do mundo em tempo real. Git status, arquivos modificados, erros detectados.

## Como funciona

O agente **popula** cada camada separadamente: memória semântica via ingest de fontes; episódica via logs de sessão; model via skills salvas; observation via ferramentas (ls, git, grep). Em cada chamada, o agente **seleciona** o subconjunto relevante de cada camada para inserir no contexto — em vez de jogar tudo.

**hot.md como MEMO estruturado**: o arquivo `04-SYSTEM/wiki/hot.md` implementa o padrão MEMO operacionalmente: contém memória semântica (estrutura do vault), model (convenções e skills), e serve como prefixo estável de cache quente.

**Conexão com working memory humana**: MEMO é análogo à memória de trabalho humana — não é armazenamento permanente, mas o que está "ativo" e acessível durante uma tarefa. A diferença: memória de trabalho humana é ~7 itens; MEMO em LLMs é limitado pelo context window.

## Por que importa

Sistemas de agente sem taxonomia explícita de memória tendem a jogar tudo no contexto ou perder informação entre sessões. MEMO fornece um vocabulário de design: qual tipo de memória essa informação é? Como recuperar? Quando expirar? É o mapa que transforma um vault de notas em uma memória agêntica funcional.

## Related
- [[03-RESOURCES/concepts/memory-context-rag/_index]]
- [[03-RESOURCES/concepts/agentic-memory-taxonomy]]
- [[03-RESOURCES/concepts/externalized-memory]]
