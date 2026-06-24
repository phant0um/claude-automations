---
title: Relatório: Arquitetura de Agentes Claude Code 2026 (5 camadas)
type: source
source: Clippings/RELATORIO_ANALISE.md
created: 2026-05-15
ingested: 2026-05-15
tags: [ai-agents]
triagem_score: 8
---

## Tese central
Arquitetura modular emergente de Claude Code 2026 converge em 5 camadas coesivas: CLAUDE.md, Skills, Hooks, Subagents, Plugins.

## Key insights
- Camadas: 1) Memory (CLAUDE.md = constituição), 2) Knowledge (skills auto-invoked), 3) Guardrail (hooks determinísticos), 4) Delegation (subagents paralelos), 5) Distribution (plugins marketplace).
- Padrões: /handoff (context overflow), /prototype (unknown unknowns), /review (vs spec), /writing (progressive 3-part).
- Prompt como contrato: 8 componentes (Task, Context, Reference, Success Brief, Rules, Conversation, Plan, Alignment).

## Links
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-md-cost-optimization]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]

---

## As 5 Camadas em Detalhe

### Camada 1: Memory (CLAUDE.md — A Constituição)

CLAUDE.md é a camada de memória persistente do agente. Age como constituição do projeto: define o que o agente deve saber, como deve agir, quais convenções seguir, e quais ferramentas estão disponíveis.

**Estrutura ótima de CLAUDE.md:**
- Stack e convenções (quais linguagens, frameworks, padrões de código)
- Comandos frequentes (como rodar testes, como fazer build)
- Arquitetura (onde estão os componentes principais)
- Regras críticas (o que nunca fazer — ex: nunca commitar credenciais)
- Referências a skills e hooks disponíveis

**Custo de tokens:** CLAUDE.md fica no início do prompt e é incluído em toda sessão. Por isso, brevidade importa — cada linha ocupa tokens em cada call. O padrão é <200 linhas, com referências a arquivos mais longos via `@include`.

**KV Cache:** Claude.ai cacheia o CLAUDE.md entre calls dentro da mesma sessão (cache TTL ~5min). Posicionar CLAUDE.md antes do conteúdo variável maximiza cache hits.

### Camada 2: Knowledge (Skills — Conhecimento Auto-Invocado)

Skills são arquivos Markdown que ensinam o agente a realizar tarefas específicas. O agente invoca skills quando detecta que a tarefa corresponde ao trigger da skill — sem instrução explícita do usuário.

**Exemplo de skill:** Uma skill `/wiki-ingest` descreve o processo completo de ingestão: ler a fonte, extrair entidades, criar o arquivo, atualizar hot.md, validar wikilinks. O agente lê a skill e a executa como protocolo.

**Hierarquia de skills:** Skills globais (`~/.claude/skills/`), skills de projeto (`.claude/skills/`), skills inline (no próprio CLAUDE.md). Skills de projeto sobrescrevem globais.

### Camada 3: Guardrail (Hooks — Automação Determinística)

Hooks são scripts executados automaticamente em eventos do ciclo de vida do agente: `PreToolUse`, `PostToolUse`, `Stop`, `Notification`. Ao contrário de skills (que guiam o modelo), hooks são determinísticos — executam independente do que o modelo decide.

**Casos de uso:**
- `PreToolUse`: Bloquear operações perigosas antes que aconteçam (ex: impedir rm -rf fora de /tmp).
- `PostToolUse`: Rodar linter automaticamente após qualquer escrita de arquivo.
- `Stop`: Notificar via Slack/SMS quando sessão longa termina.
- `Notification`: RTK token tracking após cada call.

### Camada 4: Delegation (Subagents — Paralelismo)

Subagents permitem delegar subtasks para instâncias independentes de Claude Code, rodando em paralelo. O agente pai não espera o subagent terminar — ele envia o task e continua. Resultados são agregados quando necessário.

**Padrão de uso:** Ingestão em batch — um subagent por fonte, todos rodando em paralelo. O agente pai coordena e agrega resultados. Evita que o contexto do agente pai fique cheio com o trabalho dos subagents.

**Handoff:** Quando o contexto do agente pai está quase cheio (>70%), o padrão `/handoff` serializa o estado atual em documento e passa para um novo agente começar do ponto correto.

### Camada 5: Distribution (Plugins — Marketplace)

Plugins estendem Claude Code com funcionalidades de terceiros via protocolo MCP (Model Context Protocol). O ecossistema de plugins permite adicionar: acesso a bancos de dados, integrações com APIs externas, ferramentas especializadas de domínio.

**Exemplos relevantes:** filesystem-vault (acesso ao vault Obsidian), token-savior (análise de código), context-mode (gerenciamento de contexto).

---

## Os 8 Componentes do Prompt como Contrato

Além das 5 camadas de arquitetura, o relatório descreve 8 componentes que todo prompt de alto desempenho deve incluir:

1. **Task:** O que fazer (imperativo claro).
2. **Context:** Ambiente, stack, estado atual.
3. **Reference:** Arquivos, docs, exemplos relevantes.
4. **Success Brief:** Critérios de sucesso mensuráveis.
5. **Rules:** Restrições e comportamentos mandatórios.
6. **Conversation:** Histórico relevante da sessão.
7. **Plan:** Plano de execução gerado pelo agente antes de agir.
8. **Alignment:** Confirmação que o agente entendeu o task corretamente.

---

## Os 4 Padrões de Workflow

- **/handoff:** Para quando contexto estoura. Serializa estado e passa para novo agente.
- **/prototype:** Para exploração de unknowns. Agente gera protótipo rápido para revelar constraints antes de planejar.
- **/review:** Para validação contra spec. Agente compara implementação com especificação formal e reporta divergências.
- **/writing:** Para geração de documentação em 3 partes progressivas: outline → draft → revision.

---

## Relevância para o Vault-Michel

O vault-michel é implementação direta desta arquitetura: CLAUDE.md como constituição, skills para wiki/ingest/lint, hooks para RTK e sessão startup, subagents para batch ingest, plugins MCP para filesystem e token management.

---

## Conexões

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/sources/claude-code-skills/clipping-claude-code-starter-kit-zodchiii]]
- [[03-RESOURCES/sources/ai-agents-harness/how-claude-code-works-in-large-codebases]]
- [[03-RESOURCES/sources/guides-courses-howtos/goal-mega-prompt-template]]
