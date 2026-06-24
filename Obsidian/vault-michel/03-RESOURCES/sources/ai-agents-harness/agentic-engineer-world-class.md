---
title: "How To Be A World-Class Agentic Engineer"
type: source
source: "Clippings/How To Be A World-Class Agentic Engineer.md"
author: "@systematicls"
published: 2026-03-03
created: 2026-05-30
ingested: 2026-05-30
tags: [ai-agents, agentic-engineering, claude-code, harness, skills, rules]
grade: A
---

## Tese central

Engenharia agentic de excelência é minimalismo disciplinado: CLAUDE.md como diretório lógico de IF-ELSE, rules para preferências, skills para receitas, sessão nova por contrato. Complexidade de harness e bibliotecas externas é anti-padrão — as frontier companies incorporam o que é genuinamente útil diretamente nos produtos.

## Argumentos principais

- **Menos é mais**: setup barebones supera harnesses complexos com inúmeros pacotes. Entusiastas com CLAUDE.md de 26k linhas performam pior que usuários minimalistas.
- **Signal de utilidade**: se OpenAI e Anthropic implementam nativamente (skills, memory, planning, subagents), é útil. Se não implementam, provavelmente não é. Não precisa "ficar atualizado" — apenas atualiza o CLI periodicamente.
- **Agentes são péssimos em preencher lacunas**: todo desvio de qualidade vem de assunções. Regra crítica no CLAUDE.md: antes de continuar, releia o plano de tarefa e os arquivos relevantes.
- **CLAUDE.md como diretório**: deve conter apenas o IF-ELSE de onde buscar contexto dado cenário + outcome. Não conteúdo inline — ponteiros para arquivos específicos.
- **Contratos de tarefa**: definir `{TASK}_CONTRACT.md` com testes, screenshots e verificações que devem passar antes do agente terminar. Stop-hook impede encerramento sem contrato cumprido.
- **Sessão por contrato, não 24h**: sessões longas causam context bloat de contratos não relacionados. Uma sessão focada por contrato é mais eficaz.
- **Rules vs Skills**: rules = preferências do usuário ("não faça X"); skills = receitas ("quando Y, faça assim"). Podem ser condicionais e aninhadas.
- **Limpeza periódica**: rules/skills acumulam contradições com o tempo → pedir ao agente para consolidar e remover redundâncias ("spa day").

## Key insights

- **Tendência agents → compliance**: gerações antigas ignoravam instruções 50% do tempo; hoje seguem instruções condicionais aninhadas. Cada geração exige repensar o que é ótimo → manter setup flexível e simples.
- **Fim de tarefa é não-natural para agentes**: sabem começar, não sabem parar. Testes determinísticos + screenshots são milestones eficazes. Sem contratos explícitos, o agente entrega stubs.
- **Leitura contextual pós-compaction**: após compaction, o agente precisa recompilar contexto. CLAUDE.md deve instruir releitura de plano e arquivos relevantes como primeira ação.
- **Skills tornam decisão do agente previsível**: em vez de descobrir como o agente resolverá um problema, peça para ele pesquisar a solução e escrever como skill — você valida antes da execução real.
- **Orchestration por contratos**: camada de orquestração que cria contratos automaticamente quando "algo precisa ser feito" e dispara nova sessão para cada um. Automação robusta sem context bloat.

## Exemplos e evidências

- Contratos: `{TASK}_CONTRACT.md` com: lista de testes que devem passar + screenshots a verificar + comportamentos explícitos para certificar conclusão
- CLAUDE.md minimalista: `"Se você está codificando, leia coding-rules.md. Se testes falhando, leia test-failing-rules.md"` — lógica condicional, sem conteúdo inline
- Analogia: contratar assistente executivo — não sabe suas preferências no dia 1, você constrói o relacionamento iterativamente

## Implicações para o vault

- Confirma a filosofia do vault: skills como ponteiros, CLAUDE.md enxuto, sessão por tarefa (pipeline-diario, etc.)
- Reforça: skills devem codificar RECEITAS, não preferências (estas vão em memory/feedback)
- Sugere: criar `_CONTRACT.md` por tarefa complexa no vault; stop-hook pode verificar completude
- Contradiz: longas sessões de agents batch (24h) — preferir granularidade por contrato
- Relaciona: [[04-SYSTEM/wiki/hot]] strategy de harness thin confirmada

## Links

- [[04-SYSTEM/agents/nexus]]
- [[03-RESOURCES/concepts/agent-systems]]
- [[03-RESOURCES/concepts/claude-code-tooling]]
- [[04-SYSTEM/wiki/principles]]
