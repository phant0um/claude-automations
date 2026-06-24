---
title: "Lessons from Building Claude Code: Seeing like an Agent"
type: source
source: "Clippings/Lessons from Building Claude Code Seeing like an Agent.md"
author: "@trq212 (Tariq, Anthropic)"
origin: "https://x.com/trq212/status/2027463795355095314"
created: 2026-02-27
ingested: 2026-05-28
tags: [ai-agents, source, claude-code, tool-design, action-space, elicitation, anthropic-internal, progressive-disclosure]
---

## Tese central

A parte mais difícil de construir um harness é construir o action space do agente. Projetar boas tools exige "ver como um agente" — entender as capacidades do modelo e dar ferramentas que se encaixam nelas. Não existe conjunto de regras rígidas: é arte + ciência, experimental, dependente do modelo e do objetivo.

## Argumentos principais

**Framework "ver como um agente":** para projetar tools, coloque-se na mente do modelo. Dado um problema matemático difícil, que tools você quer? Depende das suas capacidades. Papel = mínimo mas limitado. Calculadora = melhor mas requer saber operar. Computador = o mais poderoso mas requer saber programar. Dar tools que se encaixam nas capacidades reais do modelo.

**Como saber as capacidades:** pagar atenção, ler outputs, experimentar. Ver como um agente.

**3 cases studies de design de tools no Claude Code:**

### 1. AskUserQuestion Tool (elicitation)
- **Tentativa 1 (parâmetro em ExitPlanTool):** confundia Claude — simultaneamente pedindo plano e perguntas sobre o plano. Se respostas conflitassem com o plano?
- **Tentativa 2 (formato markdown especial):** Claude adicionava frases extras, omitia opções, usava formato diferente — não garantido.
- **Solução final:** tool separada que Claude pode chamar em qualquer ponto, especialmente durante plan mode. Mostra modal, bloqueia agent loop até usuário responder. Claude "gostou" de chamá-la — outputs funcionaram bem. Mesmo o melhor design de tool não funciona se Claude não entende como chamá-la.

### 2. Tasks & Todos (evolução com capacidades do modelo)
- **Primeiro:** TodoWrite tool. Claude esquecia o que fazer → system reminders a cada 5 turns.
- **Com Opus 4.5:** reminders fazem Claude pensar que não pode modificar a lista. Subagents precisam coordenar em Todo compartilhado. Solução: substituir TodoWrite pela **Task Tool** — Tasks têm dependências, compartilham updates entre subagents, podem ser alteradas/deletadas.
- **Lição:** conforme modelo melhora, tools que antes ajudavam passam a limitar. Revisitar suposições sobre tools necessárias. Manter conjunto pequeno de modelos com perfil de capacidades similares.

### 3. Search Interface (context building)
- **Primeiro:** RAG vector database. Rápido e poderoso, mas requer indexing, frágil em diferentes ambientes. Claude recebia contexto em vez de construí-lo.
- **Com Grep tool:** Claude encontra contexto ele mesmo. À medida que Claude fica mais inteligente, fica melhor em construir seu próprio contexto se tiver as tools certas.
- **Agent Skills + progressive disclosure:** Claude lê skill files, que referenciam outros arquivos, recursivamente. Skills frequentemente adicionam capacidades de search (instruções para usar API, query database).
- **Claude Code Guide subagent:** para perguntas sobre o próprio Claude Code, um subagent com instruções extensas sobre como buscar docs. Adiciona funcionalidade ao action space sem adicionar tool.

## Key insights

1. **"See like an agent"** é o meta-skill de design de tools. Observar outputs, experimentar, adaptar ao modelo específico.

2. **Progressive disclosure como princípio de design:** em vez de colocar tudo no system prompt (context rot) ou adicionar nova tool (mais opções para o modelo), usar links para arquivos que Claude pode navegar recursivamente. Adicionar funcionalidade sem adicionar tools.

3. **Ferramentas evoluem com as capacidades:** o que funciona para um modelo pode limitar o próximo. TodoWrite → Task Tool é o exemplo canônico. Não assume que tools são permanentes.

4. **Claude "gosta" de algumas tools:** qualidade do output depende parcialmente de se Claude entende e "quer" chamar a tool. Design de tool inclui modelar o comportamento esperado do modelo ao usá-la.

5. **Subagent como tool:** Claude Code Guide é um subagent que Claude chama como tool. Pattern poderoso para adicionar capacidades especializadas sem expandir toolset geral.

6. **Elicitation (perguntas estruturadas):** AskUserQuestion com opções múltiplas reduz fricção de resposta. Aumenta bandwidth de comunicação humano-agente. Skill pode referenciar AskUserQuestion; Agent SDK pode chamá-la programaticamente.

## Exemplos e evidências

- **~20 tools no Claude Code** — bar alto para adicionar nova tool. Cada tool é mais uma opção que o modelo processa.
- **TodoWrite → Tasks:** evolução documentada com Opus 4.5. Subagents coordenam em Tasks compartilhadas.
- **RAG → Grep → Progressive Disclosure:** trajetória de 1 ano de Claude "quase não conseguindo construir próprio contexto" → "busca aninhada em vários layers de arquivos para encontrar contexto exato".
- **defer_loading:** mencionado em caching post — tool stubs permitem dezenas de MCPs sem pagar por todas.

## Implicações para o vault

- Skills do vault devem ser auditadas para "ver como o agente" as usaria: description triggers, complexidade das instruções, oportunidades de progressive disclosure.
- **Task Tool vs TodoWrite:** vault usa `todo.md` — considerar estrutura de Tasks para sessões multi-agente.
- **Subagents especializados** (como Claude Code Guide) são padrão válido para adicionar conhecimento sem expandir toolset.
- Qualquer loop de edição (auto-melhoria de skills, CLAUDE.md, etc.) deve ter gate de validação antes de aceitar mudança.

## Links

- [[03-RESOURCES/entities/trq212-tariq]] — autor (Anthropic)
- [[03-RESOURCES/sources/claude-code-skills/anthropic-prompt-caching-is-everything]] — post anterior (caching + ExitPlanTool)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — progressive disclosure como princípio
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — skill design patterns
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — action space como componente do harness
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]] — subagent como tool pattern

## Relações
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]] — skills como parâmetros treináveis; convergência com SkillOpt
