---
title: Context Window — Gerenciamento de Contexto em Agentes
type: concept
status: developing
tags: [context-window, context-management, compaction, claude-code, memory]
created: 2026-04-20
updated: 2026-04-20
---

# Context Window — Gerenciamento de Contexto em Agentes

## O que é

A quantidade de informação que um LLM pode manter ativa em sua "memória de trabalho". Cada prompt, leitura de arquivo, tool call e resultado consome espaço nessa janela.

**Analogia:** RAM do modelo. Finita e crítica para performance.

O que ocupa o context window:
- Histórico da conversa (todos os turns)
- Conteúdo de arquivos lidos
- Outputs de comandos executados
- Tool call results
- Tool definitions de MCP servers (mesmo sem uso ativo)
- Conteúdo do CLAUDE.md

---

## Compaction Automática

Quando o limite se aproxima, o Claude Code **compacta automaticamente**:
- Resume detalhes importantes
- Remove tool call results desnecessários
- Libera espaço para continuar

> Risco: compaction pode perder detalhes relevantes.

> [!note] Compactação como produto vs. feature de API
> O comportamento de `/compact` no Claude Code (acima) é distinto da **compactação server-side da Messages API** (`compact_20260112`, beta `compact-2026-01-12`) documentada em [[03-RESOURCES/sources/compaction]]: esta é uma feature explícita e configurável (trigger threshold, instruções de sumarização customizadas, `pause_after_compaction`, blocos `compaction` retornados na resposta), elegível para Zero Data Retention, com modelos suportados restritos (Opus 4.6+, Sonnet 4.6+). Para controle ainda mais fino (limpar só tool results ou só thinking blocks, sem sumarizar), ver [[03-RESOURCES/sources/context-editing]]. Os três mecanismos compartilham o objetivo de manter o contexto focado, mas operam em camadas diferentes: produto (Claude Code) vs. API server-side vs. SDK client-side.

---

## Comandos de Gerenciamento

| Comando | Comportamento | Quando usar |
|---------|--------------|-------------|
| `/compact` | Compacta sessão atual, mantém memória do que foi feito | Dentro de uma feature, atingiu limite mas precisa continuar |
| `/clear` | Remove tudo — zero memória | Iniciando feature nova (evitar bias da sessão anterior) |
| `/context` | Exibe tamanho atual, categorias que consomem mais, gráfico visual | Diagnosticar o que está inflando o contexto |

---

## Estratégias para Economizar Contexto

### 1. Seja específico no prompt
Prompt vago → Claude explora mais → mais context consumido.
Prompt detalhado → Claude vai direto ao ponto → menos exploração, menos context.

### 2. Gerencie MCP Servers
Cada MCP server carrega suas tool definitions no contexto, mesmo quando não está sendo usado ativamente.
- Rode `/mcp` para ver o que está conectado
- Desative servidores não relacionados ao projeto atual

**Threshold crítico:** se MCP tools > 10% do context window, Claude Code muda para **tool search mode** (busca tools on demand; menos confiável).

**Alternativas mais eficientes:**
- CLI equivalente (ex: `gh` para GitHub, `aws` para AWS) — não adiciona tool definitions persistentes
- **Skills** — nome e descrição carregados; conteúdo completo só quando necessário

### 3. Use Subagents para Tarefas de Pesquisa
Subagents têm contexto isolado. Quando você só precisa do resultado:
- "Onde estão os authentication endpoints?" → subagent explora, retorna summary
- Sua janela de contexto fica limpa

### 4. Capitalize CLAUDE.md
Coloque no CLAUDE.md tudo que Claude precisaria redescobrir. Isso elimina o overhead de re-exploração a cada sessão.

---

## Context Rot — Degradação com Sessões Longas

Em sessões muito longas, a qualidade das respostas degrada progressivamente:
- Respostas mais genéricas
- Claude "esquece" restrições estabelecidas no início
- Aumento de alucinações

Ver [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] para o fenômeno completo e estratégias de mitigação.

---

## Relação com Outras Funcionalidades

### Plan Mode e Context
Plan Mode é eficiente em contexto: usa somente read-only tools (sem execução, sem outputs de comandos) para montar o plano. Economiza contexto para a fase de Code.

### Subagents e Context
Cada subagent tem seu próprio context window independente. O agente pai recebe apenas o summary final. Ideal para:
- Pesquisa e exploração do codebase
- Tarefas onde você só precisa do resultado, não do processo

---

## Onde Aparece no Vault

- [[03-RESOURCES/sources/guides-courses-howtos/claude-code-101]] — fundamentos e comandos de context management
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] — degradação de contexto em sessões longas
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — contexto focado como substituto de iteração; Sully.ai (37s→7.5s)
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]] — context window como componente do agente
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — MCP e context costs
- [[03-RESOURCES/entities/Claude Code]] — `[[03-RESOURCES/entities/Claude Code]]` entidade principal; session management
- [[03-RESOURCES/sources/ai-agents-harness/claude-code-linkedin-playbook]] — LinkedIn GTM: 30–40% context consumed before first prompt on loaded project; MCP→skill conversion saves 50–100x; /compact within task types, /clear between them

## Evidências
- **[2026-06-23]** Most developers begin with the same rush of excitement: the agent writes code, fixes bugs, explains unfamiliar systems, generates tests, and turns vag — [[the-agent-coding-maturity-curve-9-stages-to-trusted-automation]]
- **[2026-06-23]** Summarization-based prompt compression creates a TOCTOU security gap where front-end filters inspect pre-compression input but the backend agent acts on compressed context — [[safe-to-check-unsafe-to-use-relinking-at-the-compression-boundary-of-llm-agents]]
- **[2026-06-23]** Agentic workflows burn tokens faster than flat per-seat budgets; context window management via model routing can reduce same-work cost by routing routine steps to cheaper models — [[we-predicted-the-100kyr-per-dev-ai-bill-now-the-winners-are-routing-around-it]]
- **[2026-06-23]** VisualSkill uses MCP-based load_topic tool to deliver figures inline with text, avoiding the context inflation that plain Read causes when each figure incurs a separate call — [[visualskill-multimodal-skills-for-computer-use-agents]]
- **[2026-06-23]** Most skills suffer from token overload: stuffed with documentation the model already knows, pushing out workspace files and conversation history from the finite context window — [[stop-overloading-your-skills]]
