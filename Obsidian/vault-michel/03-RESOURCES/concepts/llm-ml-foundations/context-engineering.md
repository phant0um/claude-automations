---
title: context-engineering
type: concept
status: developing
tags: [context-engineering, llm, agents, prompt-design, karpathy]
created: 2026-04-17
updated: 2026-05-19
---

# Context Engineering

> [[Andrej Karpathy]]: "a arte e ciência delicada de preencher a context window com exatamente a informação certa para o próximo passo."

A disciplina de projetar o que um modelo vê em seu contexto, não apenas o que se diz a ele. Controla o que o modelo processa, o que ele acerta.

## Por que Importa

Quando você controla o que o modelo vê, você controla o que ele acerta. É um lever mais poderoso que:
- Escolha de modelo (decomposição pode fechar o gap entre modelos pequenos e grandes)
- Iteração/correção (contexto focado elimina a necessidade do loop)
- Prompt engineering isolado

## Princípios

**Contexto é um recurso finito com retornos marginais decrescentes** (Anthropic, 2025).

Dois trade-offs fundamentais:
- **Largo + iteração**: agente vê tudo → first pass fraco → loop corrige → lento
- **Focado + single pass**: agente vê apenas o necessário → first pass confiável → sem loop → rápido

## Técnicas

### Decomposição de Tarefas
Cada agente especialista recebe:
- **Contexto compartilhado**: transcript completo, regras de segurança, dados de referência
- **Contexto focado**: apenas as instruções de sua seção + schema de 1-3 keys (não 15)

### Prompt Caching
Separar prefix estático (system prompt, tools, documentos de referência) do suffix dinâmico (histórico de conversa). Cache do prefix a 90% de desconto.

Regras do cache:
- Não modificar tools mid-session
- Não trocar modelo mid-session
- Nunca mutar o prefix — apend ao suffix

### Resolvers
Em vez de cramear 20.000 linhas no system prompt, usar um resolver de 200 linhas que aponta para documentos certos no momento certo.

### Dynamic Output Contracts
Schema gerado por request (2 keys vs 15 keys) guia o modelo e garante fan-in determinístico em pipelines paralelos.

## Lost-in-the-Middle Effect

Acurácia cai >30% quando informação relevante está no meio de contextos longos. Mesmo a 100K tokens, ausência de priorização torna o contexto bruto insuficiente.

## Relação com Seleção de Modelos

Decomposição é uma estratégia de seleção de modelos: um modelo 1B fine-tuned matchou GPT-4.1 a 99% de acurácia em tarefa focada, com 18x throughput. Quando você simplifica a tarefa, modelos menores se tornam viáveis.

## Os 5 Layers (framework prático)

Progressão hierárquica — cada layer depende dos anteriores:

| Layer | Nome | O que é | Exemplo no vault-michel |
|-------|------|---------|------------------------|
| 1 | **Identity** | Quem está usando o modelo — role, indústria, estilo, audiência | CLAUDE.md, primeiras linhas |
| 2 | **Knowledge** | Documentos permanentes que Claude precisa conhecer | `03-RESOURCES/`, hot.md |
| 3 | **Memory** | O que Claude aprendeu entre sessões | `~/.claude/memory/` |
| 4 | **Tool** | Ferramentas e integrações disponíveis | MCP servers, skills |
| 5 | **Conversation** | Contexto da sessão atual | `/compact` limpa este layer |

**Trade-off central**: construir layers 1–4 bem → layer 5 (prompt) pode ser mínimo.  
"Write the weekly report" funciona quando layers 1–4 já dizem o que isso significa.

> Fonte: [[03-RESOURCES/sources/skills-prompting-mcp/context-engineering-replacing-prompt-eng]]

## Ver também

- [[multi-agent-orchestration]]
- [[prompt-caching]]
- [[resolver-pattern]]
- [[agent-memory-architecture]]

## Aplicação: AI-Legible Backend

Contexto não é só o que vai no prompt — é também o que o **ambiente expõe ao agente sob demanda**. Um backend "AI-legível" reduz o custo de descoberta do agente antes que ele comece a trabalhar. Experimento documentado: 10.4M → 3.7M tokens (~2.8x) usando o mesmo app, prompt e modelo. Ver [[03-RESOURCES/concepts/dev-foundations/ai-legible-backend]].

## Os 5 Padrões em Claude Code (Anthropic Engineers, jun/2026)

Documentados em "How to Master Context Engineering in Claude Code 5 Patterns and 13 Steps":

1. **CLAUDE.md como Identity Layer** — system prompt permanente define role, estilo, constraints. Nunca muta mid-session.
2. **Resolvers para Knowledge Layer** — em vez de cramear documentos no prompt, resolver de 200 linhas aponta para o documento certo quando necessário.
3. **hot.md como Memory Layer** — estado comprimido do projeto em <200 linhas. Agente lê no início de cada sessão; pipeline appenda ao final.
4. **Skills/MCP como Tool Layer** — receitas codificadas eliminam reinvenção de sequências de tool use. ROI mais alto por layer.
5. **`/compact` para limpar Conversation Layer** — libera token budget sem perder Identity/Knowledge/Memory/Tool.

**Implicação crítica:** Construir layers 1–4 bem = layer 5 (o prompt) pode ser mínimo ("write the weekly report" funciona quando os outros 4 layers já dizem o que isso significa).

## Context Engineering > Model Choice

Evidência de 2026:
- 300 agentes (Opus 4.8) construíram SaaS funcional em uma tarde — escala extrema viável
- MEMANTO: 21% → 95% accuracy em data agent via knowledge base estruturada, <1% de valor de queries históricas brutas
- Backend AI-legível: 10.4M → 3.7M tokens (2.8x) sem mudar modelo ou prompt
- Modelo 1B fine-tuned matchou GPT-4.1 a 99% em tarefa focada, 18x throughput
- **Spotify Honk**: ~50 migrations, majority of PRs merged across hundreds of repos — atribuído à engenharia do prompt/contexto, não ao modelo. Equipe deliberadamente manteve ferramentas mínimas para aumentar previsibilidade.

**Síntese:** Contexto correto supera modelo maior. Harness architecture explica mais variance de performance que escolha de modelo.

## Prompt Estático vs. MCP Dinâmico (Spotify Honk)

Trade-off documentado em produção real:

| | Prompt Estático Grande | MCP Dinâmico |
|-|----------------------|-------------|
| Testabilidade | Alta (versionável, avaliável) | Baixa (comportamento emergente) |
| Previsibilidade | Alta | Baixa (mais tools = mais dimensões de falha) |
| Contexto | Condensado pelo usuário upstream | Buscado pelo agente on-demand |
| Preferência Spotify | ✓ | — |

**Regra prática:** mais ferramentas = mais imprevisibilidade. Spotify preferiu prompts grandes e estáveis sobre agentes mais capazes porém imprevisíveis.

## Fontes

- [[03-RESOURCES/sources/ai-agents-harness/llm-pipeline-slow-agents-do-too-much]]
- [[03-RESOURCES/sources/memory-context-rag/prompt-caching-llms-explained]]
- [[03-RESOURCES/sources/ai-agents-harness/resolvers-routing-table-intelligence]]
- [[03-RESOURCES/sources/token-economy-cost/cut-claude-code-costs-3x-karpathy-context-engineering]] — experimento backend architecture 3x cost reduction
- [[03-RESOURCES/sources/how-to-master-context-engineering-in-claude-code-5-patterns-and-13-steps-anthropic-engineers-use]]
- [[03-RESOURCES/sources/how-to-make-agentic-workflows-100x-cheaper-full-guide]]
- [[03-RESOURCES/sources/every-agentic-engineering-hack-i-know-june-2026]]
- [[03-RESOURCES/sources/ai-agents-harness/spotify-honk-part2-context-engineering]] — caso Spotify: ~50 migrations, prompts estáticos > MCP dinâmico

## Evidências
- **[2026-06-19]** Framework de 4 estratégias (Write/Select/Compress/Isolate) e 4 modos de falha (Poisoning/Distraction/Confusion/Clash); pipeline universal de 5 passos por turno (Collect→Select→Compress→Arrange→Assemble); caso Dex Horthy de 35k linhas em 7h via Frequent Intentional Compaction — [[03-RESOURCES/sources/ai-agents-harness/context-engineering-complete-playbook]]
- **[2026-06-22]** "Less prompting is more" e "tool overlap is poison": caso de produção do Skipper (Cloudflare) onde prompts prescritivos pioraram qualidade e tools duplicadas confundiram o modelo — [[03-RESOURCES/sources/how-we-built-cloudflare-s-data-platform-and-an-ai-agent-on-top-of-it]]
