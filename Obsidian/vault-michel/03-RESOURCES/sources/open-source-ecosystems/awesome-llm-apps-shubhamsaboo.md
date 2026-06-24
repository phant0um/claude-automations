---
title: "awesome-llm-apps: 100+ AI Agent & RAG apps you can actually run"
type: source
source: "Clippings/Shubhamsabooawesome-llm-apps 100+ AI Agent & RAG apps you can actually run — clone, customize, ship..md"
original_url: "https://github.com/Shubhamsaboo/awesome-llm-apps"
author: "Shubham Saboo"
published: 2026-05-30
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, open-source, rag, multi-agent, mcp, templates, curated-list]
---

## Tese central

Você não deveria reconstruir o mesmo pipeline RAG, loop de agente ou integração MCP do zero toda vez — `awesome-llm-apps` é um cookbook de 100+ templates prontos para rodar (3 comandos), multi-provider, Apache-2.0, cobrindo o stack moderno de AI.

## Argumentos principais

1. **Hand-built, não curado**: cada template é trabalho original testado end-to-end antes de ser publicado. Não é lista de links externos.

2. **13 categorias cobrindo o stack completo**:
   - Starter AI Agents (12 apps single-file)
   - Advanced AI Agents (22 apps — single + multi-agent)
   - Autonomous Game-Playing Agents (3)
   - Multi-agent Teams (14 apps colaborativos)
   - Voice AI Agents (5)
   - MCP AI Agents (5 — Browser, GitHub, Notion, Travel, Multi-MCP Router)
   - RAG — 20 variantes (agentic RAG, corrective RAG, knowledge graph RAG, hybrid search, vision RAG)
   - Awesome Agent Skills (19 skills prontas)
   - LLM Apps with Memory (6)
   - Chat with X (6 — GitHub, Gmail, PDF, ArXiv, Substack, YouTube)
   - LLM Optimization Tools (2 — Toonify 30-60%, Headroom 50-90% token reduction)
   - LLM Fine-tuning Tutorials (Gemma 3, Llama 3.2)
   - AI Agent Framework Crash Course (Google ADK, OpenAI Agents SDK)

3. **Provider-agnostic**: Claude, Gemini, GPT, Llama, Qwen, xAI — troca com mudança de config.

4. **19 Agent Skills prontas** (markdown files plugáveis em qualquer agente LLM): Academic Researcher, Code Reviewer, Content Creator, Data Analyst, Debugger, Decision Helper, Deep Research, Editor, Email Drafter, Fact Checker, Fullstack Developer, Meeting Notes, Project Planner, Python Expert, Sprint Planner, Strategy Advisor, Technical Writer, UX Designer, Visualization Expert.

5. **Self-Improving Agent Skills**: template específico para otimizar skills automaticamente usando Gemini e ADK.

6. **LLM Optimization Tools**: Toonify (formato TOON, -30-60% custo API) e Headroom (-50-90% custo API).

7. **Apache-2.0**: fork, ship, sell — sem paywall, sem signup, sem telemetria.

## Key insights

- O repositório é um ponto de partida, não um framework — clonar e customizar é a jornada esperada.
- A categoria RAG tem 20 variantes cobrindo os principais padrões: agentic, corrective (CRAG), knowledge graph, hybrid search, vision, local, multimodal.
- MCP Agents cobrem 5 integrações key: Browser, GitHub, Notion, Travel Planner, Multi-MCP Router.
- O Multi-MCP Agent Router é relevante para arquiteturas multi-ferramenta.
- Trust-Gated Multi-Agent Research Team introduz tiers de confiança entre agentes.

## Exemplos e evidências

**Quick start:**
```bash
git clone https://github.com/Shubhamsaboo/awesome-llm-apps.git
cd awesome-llm-apps/starter_ai_agents/ai_travel_agent
pip install -r requirements.txt
streamlit run travel_agent.py
```

**Featured this month** (mai 2026):
- Earnings Call Analyst Agent (ADK + Gemini — YouTube earnings calls → analyst cards)
- Insurance Claim Live Agent Team (Voice + ADK — real-time voice claim intake)
- Home Renovation Agent (Vision + Multi-agent — photo → AI redesign)
- Self-Improving Agent Skills (Agent Skills + ADK — otimização automática)

**19 skills prontas** incluem: Academic Researcher, Code Reviewer, Data Analyst, Debugger, Deep Research, Fullstack Developer, Python Expert, Technical Writer.

## Implicações para o vault

- As 19 skills são candidatas diretas para importação ao vault — especialmente Academic Researcher, Deep Research, Code Reviewer e Python Expert.
- Os templates RAG são referências de implementação para o conceito [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]].
- Toonify e Headroom (30-60% e 50-90% redução de tokens) são relevantes para o princípio de token economy do vault.
- O Multi-MCP Agent Router é padrão arquitetural relevante para o ecossistema MCP do vault.
- Self-Improving Agent Skills conecta com [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]].

## Links

- [[03-RESOURCES/entities/awesome-llm-apps]] — entidade do repositório
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] — skills self-improving
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — multi-agent teams
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — RAG patterns
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — MCP agents

> [!note] Nota de ingestão
> O arquivo de clipping "MemPalacemempalace..." tinha conteúdo idêntico a este (mesmo hash md5). O conteúdo real é do repositório Shubhamsaboo/awesome-llm-apps — o título do clipping era incorreto.
