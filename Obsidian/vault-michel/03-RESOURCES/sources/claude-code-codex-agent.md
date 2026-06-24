---
title: "你的 Claude Code / Codex 每次都从零开始？给 Agent 加一层长期记忆"
type: source
source: "Clippings/你的 Claude Code - Codex 每次都从零开始？给 Agent 加一层长期记忆.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, claude-code-tooling]
---

## Tese central
EverOS propõe uma camada de memória persistente, pesquisável e que evolui ao longo do tempo para agentes/LLM apps — distingue 2 tipos de memória (memória de usuário: preferências/fatos sobre a pessoa; memória de agente: o que o agente aprendeu em tarefas passadas, ex.: comando de teste de um projeto, como um bug foi corrigido) e propõe Markdown como source of truth (não banco vetorial opaco), com SQLite para estado e LanceDB para indexação.

## Argumentos principais
- 3 problemas de simplesmente colocar todo histórico de mensagens no prompt: custo/janela descontrolam conforme a conversa cresce; histórico bruto não é memória (o que importa é preferência/decisão-chave/solução validada/armadilha a evitar, não cada saudação); memória precisa ser mantível — auditável, editável, versionável, não só confiável como caixa-preta vetorial.
- Fluxo mínimo: Add (escreve conversa) → Flush (sistema extrai memória pesquisável) → Search (busca memória relevante antes de gerar resposta) — loop completo: Search→Generate→Add, com Flush síncrono em teste ou assíncrono em produção.
- Escolha de método de busca por padrão: hybrid (keyword+vetor) + top_k=5 é ponto de partida seguro para a maioria dos casos; aumentar top_k para tarefas de pesquisa/análise; usar filtros (user_id/project_id/app_id) sempre, senão memórias de diferentes usuários/projetos se misturam e tornam o agente menos confiável, não mais.
- Versão open-source usa Markdown como fonte de verdade para memória — arquivos legíveis, editáveis, "grep-áveis", compatíveis com fluxo Obsidian/Git.

## Key insights
- "Memória de agente em Markdown como source of truth, não banco vetorial opaco" é validação direta e externa da arquitetura central deste vault (`04-SYSTEM/wiki/hot.md`, `errors.md`, manifest em texto plano versionado em git) — confirma que o padrão adotado aqui já está alinhado com a prática emergente do mercado de "agent memory layers".
- A distinção memória-de-usuário vs memória-de-agente é útil para qualquer expansão futura do sistema de memória deste vault: hot.md/errors.md já são essencialmente "memória de agente" (o que o sistema aprendeu sobre rotinas do vault); ainda não há um equivalente formal de "memória de usuário" (preferências do Michel) fora do CLAUDE.md.
- Exigência de filtro obrigatório por dimensão (user/project/app) na busca de memória é lembrete direto: qualquer busca futura sobre hot.md/errors.md por múltiplos contextos (ex.: FIAP vs concurso vs sistema) deveria já prever esse tipo de escopo, evitando memória de um domínio "contaminar" outro.

## Exemplos e evidências
- Exemplo de código Python completo (Add→Flush→Search) com SDK `everos-cloud`; exercício prático sugerido (ensinar agente preferência de horário de trabalho do usuário e recuperá-la depois).

## Implicações para o vault
Confirma a arquitetura de memória já adotada (Markdown versionado como fonte de verdade) sem necessidade de mudança — referência conceitual caso o vault formalize uma camada de "memória de usuário" distinta da atual memória de sistema/agente.

## Links
- [[04-SYSTEM/wiki/hot]]
- [[03-RESOURCES/entities/Claude Code]]
