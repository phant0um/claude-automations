---
title: Token Economy
type: concept
created: 2026-05-24
updated: 2026-06-22
tags: [agent-systems, token-economy, prompt-caching, cost-optimization]
status: active
---

# Token Economy

Conjunto de técnicas e métricas para **reduzir custo e latência** de sistemas LLM sem sacrificar qualidade. KPI central: **cache hit rate**. Otimização de harness > otimização de modelo para custo.

## Pilares

### 1. Prompt Caching (maior ROI)

| Layer | Claude Code (subscription) | API default |
|-------|---------------------------|-------------|
| System prompt | 1 hora TTL | 5 min TTL |
| Project context | 1 hora TTL | 5 min TTL |
| Conversation | 1 hora TTL | 5 min TTL |

- Cache hit = **10% do custo** de token de input normal
- 91M tokens cached → cobrado como 9M → 90% de economia
- **Quebradores de cache**: switch de modelo mid-session, editar system prompt, reordenar mensagens
- Sub-agents: sempre TTL 5 min (não herdam TTL da subscription)

### 2. Context Engineering

- Ordem importa: conteúdo estável no topo (system prompt), dinâmico no fim
- CLAUDE.md estável durante sessão — não editar mid-session
- hot.md = memória de trabalho densa → evita re-expansão de contexto

### 3. Compressão e RTK

- RTK (Rust Token Killer): filtra tokens redundantes em shell output
- Agentes especializados em vez de contexto monolítico: sub-agent = compressão (8k → 200 tokens para o pai)
- Skill = procedimento comprimido nos pesos vs. instrução no prompt

### 4. Workflow Compilation

- Fine-tune workflow em modelo pequeno → 128–462× mais barato
- Elimina orquestrador frontier por conversa

## Métricas operacionais (Anthropic interno)

- "Declaramos SEV se hit rate de cache fica baixo" — Thariq (Anthropic)
- Cache create: pago uma vez, amortizado em N leituras
- Cache read: 10× mais barato que input normal

## Errros comuns

- Usar "opus plan" mode durante sessão longa → mata cache
- Sub-agents que demoram >5 min → cache miss no próximo call
- Mudança de sistema de tool definitions mid-session → invalidação

## Vault aplicado

- RTK ativo: hook reescreve todos os shell cmds
- CLAUDE.md: não editar mid-session
- Sub-agents: projetados para completar em <5 min
- hot.md: memória densa > re-ler múltiplos arquivos

### Tier por complexidade de rotina

Rotinas do vault (`07-QUEUE/rotinas/`) têm custo de token muito diferente conforme complexidade. Aplicar a mesma rubric de economia para todas é erro — rotina leve não justifica overhead de otimização.

| Tier | Critério | Economia esperada | Otimizações recomendadas |
|------|----------|-------------------|--------------------------|
| **Leve** (L1) | 1-3 steps, bash-only ou 1 chamada AI, sem subagentes | Mínima — não otimizar | Nenhuma. Custo já é baixo. Foco em correteness. |
| **Média** (L2) | 4-10 steps, 2-5 chamadas AI, 0-1 subagente | Moderada | Cache de system prompt, hot.md denso, modelo por fase |
| **Pesada** (L3) | 10+ steps, 5+ chamadas AI, múltiplos subagentes em paralelo | Alta — vale otimizar agressivamente | Tudo de L2 + RTK ativo, compressão de tool-output, model routing por sub-tarefa, cap de retry estrito, dispatch sequencial quando paralelo não economiza |

**Regra de aplicação:**
- Classificar rotina no frontmatter como `complexity: L1|L2|L3`
- L1: não gastar tempo otimizando — custo < $0.50/run
- L2: aplicar cache + model routing — custo $0.50-$5/run
- L3: aplicar rubric completa + budget tracking — custo > $5/run

**Rotinas atuais classificadas:**

| Rotina | Tier | Justificativa |
|--------|------|---------------|
| daily-scan | L1 | Bash-only, zero AI |
| srs-sources | L1 | Bash-only, zero AI |
| pipeline-diario | L2 | 3-5 chamadas AI, sem paralelismo |
| pipeline-semanal | L3 | 6+ batches paralelos, 50+ sources, múltiplos subagentes |
| meta-coaching-semanal | L2 | 2-3 chamadas AI, análise qualitativa |
| x-thread-weekly | L2 | 2-3 chamadas AI, geração + revisão |

## Links

- [[03-RESOURCES/sources/token-economy-cost/how-anthropic-engineers-save-tokens]]
- [[03-RESOURCES/sources/token-economy-cost/cut-token-bill-87-percent-7-days]]
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]]
- [[03-RESOURCES/concepts/agent-systems/workflow-compilation]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[04-SYSTEM/wiki/hot]]

## Evidências
- **[2026-06-19]** 100 landing pages: ~US$94 de economia usando Kimi K2.7 Code vs Claude Fable 5; gap de qualidade pequeno segundo rubrica de juiz LLM — [[03-RESOURCES/sources/kimi-k27-code-vs-claude-fable-5-landing-pages]]
- **[2026-06-19]** Kimi K2.6 com pricing US$0,95/M in, US$4/M out, US$0,16 em cache hit permite "jogar fora a primeira tentativa e rodar de novo" — volume barato só compensa quando há verificação confiável checando o trabalho — [[03-RESOURCES/sources/self-improving-loop-300-agent-swarm-kimi]]
- **[2026-06-19]** Compressão de tool-output: lib `headroom` net-negativa em agente de código real (CCR recupera o que comprimiu, dobrando tokens); densificação lossless nativa de `search_files` (path-grouping JSON) entrega 57,8% de redução com zero dependências — detalhe completo em [[03-RESOURCES/concepts/llm-ml-foundations/token-compression]] — [[03-RESOURCES/sources/hermes-search-files-densification-pr]]
- **[2026-06-19]** Caso RTK em produção real (Ramp/Inspect, 150k sessões, 5 semanas): ~US$1M de economia teórica de token (335B tokens) virou economia líquida questionável porque o modelo perde visibilidade do comando original reescrito — retrabalho (retry/bypass do wrapper) compensa o ganho. Lição: "economia só vale se preserva o entendimento do modelo sobre o ambiente" — relevante porque este vault usa RTK ativamente — [[03-RESOURCES/sources/inspect-at-scale-ramp-coding-agent]]
- **[2026-06-21]** A maioria das automações cron com agentes desperdiça tokens disparando um turno completo do modelo a cada tick, mesmo sem nada para decidir. O fix é manter o modelo fora do loop até ser realmente necessário e encolher seu trabalho quando... — [[3-easy-ways-to-build-cheap-or-free-automation-pipelines-with-hermes-agent]]
- **[2026-06-22]** Guia independente (CN) confirma as mesmas práticas centrais (system prompt estável fora de sessão, delimitação de conteúdo por tags, escolha de modelo por complexidade) e adiciona "native language mode" — instruir no idioma do usuário, processar a fonte no idioma original, responder só no idioma alvo, sem etapa de pré-tradução — [[03-RESOURCES/sources/token-ai]]
- **[2026-06-23]** Token economy: guia técnico de otimização — token-theft prevention, context handling, model routing como alavancas de custo — [[token-economy-technical-guide]]
- **[2026-06-23]** Improving token efficiency in GitHub agentic workflows — team of street sweepers que limpam little messes — [[improving-token-efficiency-in-github-agentic-workflows]]
- **[2026-06-23]** Getting more from each token: how Copilot improves context handling and model routing — [[getting-more-from-each-token-how-copilot-improves-context-handling-and-model-rou]]
- **[2026-06-23]** Agentic AI systems should be designed as marginal token allocators — [[agentic-ai-systems-should-be-designed-as-marginal-token-allocators]]

## Perspectivas
- **[2026-06-22]** Abrir reasoning mode máximo para tarefa trivial é desperdício estrutural equivalente a usar modelo caro para tarefa simples — "modo de pensamento" é um lever de custo paralelo à escolha de modelo, não um botão neutro de qualidade — [[03-RESOURCES/sources/token-ai]]
- **[2026-06-22]** HMM/filtro de Kalman como metáfora para scoring de triagem: modelar "qualidade real" de uma source como estado oculto que evolve no tempo, com observations = scores atribuídos por múltiplos passes do triagem-agent — ideia exploratória, não acionável ainda (prioridade baixa, esforço dias, sem implementação imediata) — [[03-RESOURCES/sources/how-quants-use-hidden-markov-models-to-build-regime-adaptive-trading-strategies-]]
