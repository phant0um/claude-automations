---
title: "HERMES AGENT + NOTEBOOKLM + OBSIDIAN: Build a 3-Agent Research Department That Gets Smarter Every Day"
type: source
source: "Clippings/HERMES AGENT + NOTEBOOKLM + OBSIDIANBUILD A 3-AGENT RESEARCH DEPARTMENT THAT GETS SMARTER EVERY DAY.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Um único agente Hermes fazendo pesquisa, análise e briefing ao mesmo tempo produz resultados mediocres porque o contexto fica poluído e as prioridades se confundem. Três perfis isolados — Scout (encontra sinais), Analyst (sintetiza com NotebookLM, escreve no wiki Obsidian) e Briefer (entrega ação) — coordenados via arquivos num vault Obsidian compartilhado, produzem resultados compostos crescentes, por um custo de US$19–27/mês.

## Argumentos principais
- O problema de um agente só: por volta do dia 3, o contexto já está pesado de pesquisa acumulada irrelevante para o brief da manhã; até a semana 2, o agente acumula 40+ skills cobrindo de parsing de arXiv a formatação de Telegram. Tool Search ajuda mas não resolve o problema fundamental: uma identidade tentando ser três trabalhadores diferentes.
- Perfis no Hermes resolvem isso na camada de arquitetura: cada perfil é um agente totalmente isolado — próprio SOUL.md, config.yaml, memória, skills, cron jobs. Não compartilham nada por padrão exceto um diretório: o vault Obsidian onde Scout deposita achados brutos, Analyst escreve notas sintetizadas, Briefer lê toda manhã.
- **Scout** (sinal): verifica fontes em cronograma, salva achados brutos em `~/research/inbox/` sem análise nem opinião. Modelo recomendado: GPT-5.5 (busca de alto volume, baixo raciocínio); para busca nativa em X, trocar para Grok via SuperGrok OAuth (GPT-5.5 não busca X nativamente) ou usar skill `xurl`.
- **Analyst** (síntese): processa achados do inbox, alimenta-os ao NotebookLM para síntese cross-source, extrai insights, escreve notas estruturadas no wiki Obsidian usando o skill "LLM Wiki", tagueia cada entrada com nível de confiança (`[verified]`/`[likely]`/`[unverified]`/`[conflicting]`), flagueia contradições com entradas existentes. Modelo recomendado: Claude Sonnet 4 (raciocínio forte — "é aqui que a qualidade importa").
- **Briefer** (ação): lê entradas recentes do wiki (últimas 24h), cruza com projetos/calendário atuais, entrega brief de 5 bullets priorizados ao Telegram, termina com gasto total de tokens da semana. Modelo recomendado: GPT-5.5 (resumos concisos, baixo volume de tokens).
- Coordenação é por arquivo com `wakeAgent` gates, não Kanban: inbox vazio = zero tokens gastos; arquivos novos = agente desperta e processa. Para um pipeline linear de três estágios, arquivo é mais simples, mais barato (zero overhead de dispatcher) e mais fácil de debugar do que Kanban — Kanban só valeria a pena com mais papéis (Code Reviewer, Content Writer, Outreach Agent).
- Estrutura de vault recomendada: `inbox/` (achados brutos temporários do Scout), `sources/` (páginas de fonte processadas), `synthesis/` (notas estruturadas do Analyst), `briefs/` (briefs arquivados), `entities/` (pessoas/empresas/produtos), `contradictions/` (conflitos flagueados), `.last-pushed` (timestamp de sync).
- O skill "LLM Wiki" embutido no Hermes é baseado no padrão LLM Wiki de Andrej Karpathy: compila conhecimento em arquivos markdown interligados, mantém cross-references e detecta contradições automaticamente.
- Três tiers de setup: Básico (Scout + Briefer, sem Analyst/NotebookLM/Obsidian), Standard (três perfis + wiki Obsidian, sem NotebookLM), Avançado (três perfis + wiki + NotebookLM + análise competitiva).
- NotebookLM não tem API pública para o produto consumer (a partir de junho/2026) — apenas o produto Enterprise tem. O conector `notebooklm-mcp-cli` (de jacob-bd, 35 ferramentas MCP) usa wrapper de automação de browser via Playwright sob o capô; se o Google mudar um endpoint interno, o wrapper pode quebrar. Por isso o SOUL.md do Analyst deve incluir um fallback: se a conexão falhar, sintetizar diretamente via `/goal`.

## Key insights
- Trajetória de maturação do sistema descrita em três marcos: Dia 1 (frio, brief genérico), Semana 2 (50-100 fontes encontradas, 30-40 entradas no wiki, primeiro momento de "isso encontrou algo que eu não teria buscado"), Mês 1 (200+ entradas com cross-references, contradições rastreadas, Scout refinado, Analyst criou 5-10 skills para padrões de síntese recorrentes, "o sistema produz insights que você não pediu — isso é o compounding").
- Custo de referência: um assistente de pesquisa part-time custa US$1.500–3.000/mês; o setup de três perfis custa US$19–27/mês para ~1.3M tokens/mês.
- Limitações explícitas listadas pelo autor: o wrapper do NotebookLM pode quebrar (sem API oficial); Scout não vê conteúdo pago (paywall); Analyst pode classificar mal nível de confiança (Hermes não fact-checka de forma independente); custo de token escala com volume de crons; revisão humana ainda é necessária — "isto é um departamento de pesquisa, não um autopiloto".

## Exemplos e evidências
- Exemplo de brief matinal real formatado: 5 bullets com tags de confiança, cobrindo atualização de pricing de concorrente, paper do arXiv sobre consolidação de memória de agentes, hotfix do Hermes v0.16.1, claim não verificado de redução de custo com DeepSeek, e contradição entre fontes sobre pricing do NotebookLM Enterprise — terminando com "Token spend this week: $4.20".
- Três caminhos de custo detalhados: Nous Portal (assinatura única, 300+ modelos, 10% off em providers cobrados por token), OpenRouter API (pay-per-token, menor custo, requer gerenciar API key), ChatGPT sub + Sonnet API (Scout/Briefer no GPT-5.5 via assinatura ChatGPT de $20, Analyst no Sonnet via API Anthropic separada — maior custo total, gerenciamento mais simples).
- Scripts concretos fornecidos: script Python `check-inbox.py` como wakeAgent gate (retorna `{"wakeAgent": true/false}` baseado em arquivos `.md` no diretório inbox).
- Comandos CLI reais: `hermes profile create scout/analyst/briefer`, `pip install notebooklm-mcp-cli && nlm login`, `nlm notebook create`, `nlm source add`.

## Implicações para o vault
Este artigo é evidência direta e detalhada para `[[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]` (divisão de responsabilidades por isolamento de contexto) e para `[[03-RESOURCES/concepts/pkm-obsidian/llm-wiki-pattern]]` — de fato cita explicitamente o padrão de Karpathy que já está catalogado como concept no vault, mostrando uma implementação real (Hermes) do mesmo padrão usado pelo Nexus Agent System deste vault. Também conecta diretamente com `[[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]` e `[[03-RESOURCES/concepts/pkm-obsidian/notebooklm-integration]]`, ambos já existentes — esta source é a peça mais completa do batch sobre arquitetura de pipeline de pesquisa multi-agente com wakeAgent gates, e vale comparar com `[[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]` (coordenação via arquivo, não orquestrador central), tema recorrente em outra source deste mesmo batch ("How to Build AI Workflows When You're Tired of Optimizing Prompts").

## Links
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/pkm-obsidian/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]
- [[03-RESOURCES/concepts/pkm-obsidian/notebooklm-integration]]
- [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/entities/NotebookLM]]
- [[03-RESOURCES/entities/Obsidian]]

## Minha Síntese

**O que muda:** Confirma que a separação Scout/Analyst/Briefer (isolamento de contexto por perfil + coordenação por arquivo compartilhado) é o mesmo padrão arquitetural usado no Nexus Agent System deste vault (`ingest-agent`, `triagem-agent`, `report-agent`) — a literatura externa valida a escolha de design já feita aqui.

**Conexão pessoal:** O `04-SYSTEM/agents/nexus-agent-system/` já implementa exatamente esse padrão de pipeline (scout→analyst→briefer ≈ ingest→triagem→report) coordenado via `04-SYSTEM/wiki/hot.md` como o "shared inbox/wiki" descrito aqui.

**Próximo passo:** Nenhum próximo passo imediato — o padrão já está implementado; vale revisitar apenas se o vault adotar wakeAgent-style gates (script de custo zero antes de despertar um agente) para reduzir tokens em rotinas automatizadas.
