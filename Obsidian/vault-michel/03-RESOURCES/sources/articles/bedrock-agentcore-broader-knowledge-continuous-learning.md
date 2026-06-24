---
title: "New in Amazon Bedrock AgentCore: Build agents with broader knowledge and continuous learning"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://aws.amazon.com/pt/blogs/machine-learning/new-in-amazon-bedrock-agentcore-build-agents-with-broader-knowledge-and-continuous-learning/"
author: "Madhu Parthasarathy"
published: 2026-06-17
grade: B
tags: [articles, aws, bedrock, agentcore, knowledge, continuous-learning, guardrails, harness, optimization, source]
---

# New in Amazon Bedrock AgentCore: Build agents with broader knowledge and continuous learning

**Tese central**: Novas capacidades no Bedrock AgentCore para construir agents mais capazes: conectar agents a conhecimento organizacional/web/pago, encontrar e fixar o que está errado em produção (silent failures), e enforcear controls que escalam com a capability do agent. Juntos, ajudam a buildar agents mais capazes mais rápido, governá-los com controls que escalam, e melhorá-los continuamente.

## O gap não é intelligence — é access to context e feedback

Models powering today's agents são remarkably capable — reason across complex problems, plan multi-step workflows, generate nuanced responses. Mas a maioria dos agents opera abaixo do potencial. O gap não é intelligence. É access ao right context e feedback.

- Customer service agent não pode ajudar se não reacha o documento em SharePoint onde a refund policy vive
- Research agent entrega picture incompleta se não accessa current information além de training data
- Financial advisor agent retorna second-best recommendation se real-time market data está atrás de paywall
- E across all, a maioria dos teams não tem systematic way de saber se agents estão getting better ou worse uma vez deployed

A capable model é só o starting point. O que faz um agent performar em production é access a tudo que precisa: right knowledge, resources to act, e feedback loops para keep improving.

## Agents that know more and reach more — 3 knowledge layers

### Organizational knowledge: Amazon Bedrock Managed Knowledge Base

Informação mais valiosa está scattered across SharePoint, Google Drive, Confluence, S3, wikis. Tradicionalmente requeria building custom ingestion pipelines, tuning retrieval, maintaining data freshness — meses de engineering antes do agent responder uma básica pergunta sobre o próprio business.

**Bedrock Managed Knowledge Base**, now available on AgentCore, substitui esse work. Connect unstructured data sources, AgentCore handles o rest: manage vector store, embeddings e re-ranking models, scalability (rate limits). Foco em building agents ao invés de operating pipelines.

Core é um **agentic retriever** que vai bem além de traditional RAG. Ao invés de matchear query a closest chunks, ele:
- Plans queries across knowledge bases
- Connects related concepts across documents
- Evaluates intermediate results
- Re-ranks before answering

Para complex, multi-part queries que span several topics, agentic retrieval surfaced broader e more complete coverage que basic retrieval. Agent vai de "I don't have access to that" para synthesized answer drawn from actual business knowledge — sem pipeline to build, sem retrieval to tune.

### World knowledge: Web Search on AgentCore

Internal knowledge has gaps. Regulations change, markets shift, competitors launch products. Agents precisam entender o que happening no mundo outside — research, fact-checking, customer service, market intelligence.

**Web Search**, novo tool para developers building AI agents. Informação do web mantendo data dentro do secured AWS environment. Built na mesma search infrastructure da Amazon que powers Alexa+, Amazon Quick Suite, e Kiro. Optimized para agentic retrieval — high-value excerpts que deliver high intelligence per token. Multi-source grounding: combina public web information com Amazon's proprietary knowledge graph (structured entity data, verified facts, real-time info como stock prices e sports scores).

Web Search mantém queries dentro do AWS security e compliance boundary — no extra vendor, none of orchestration/auth/billing workflows. Agents podem reason over live web como query internal knowledge.

> Sony quote (Masahiro Oba): enterprise AI agent platform em AgentCore, knowledge distribuído across SharePoint, Confluence, S3. Bedrock Managed Knowledge Base + Web Search equipam agents com advanced retrieval e live web grounding com consistent governance, sem build from scratch.

### Paid knowledge: AgentCore payments + WAF AI traffic monetization

Best information isn't always free. Financial market feeds, licensed research, proprietary datasets, premium APIs. Se agent não accessa paid resources, retorna suboptimal answer e user nunca sabe o que missed.

Accessing paid content takes two parts: agents need a way to pay, providers need a way to get paid.
- **AgentCore payments** (preview): agent side — discover paid services/content, access them, pay within execution loop
- **WAF AI traffic monetization** (GA): provider side — content owners controlam agent access: block, allow, ou get paid

Both rodam na mesma platform — providers usando WAF automaticamente recognize agents verified on AgentCore. Result: trusted channel, lower friction para verified agents, compensation para providers. Infrastructure para both sides do agent economy.

## Agents that learn from every interaction

Dar agents better knowledge access é só parte. Também precisa saber se o agent está meeting its goal, e catchar quando não está.

O perigo: failures mais dangerous não são os que throw errors. São os que look fine on dashboards:
- Agent confirma order modification que nunca executed
- Fabrica product availability quando API times out
- Skipa approval step enquanto dashboards show 99% success rate

Esses failures produzem no error signals. Surface through customer complaints weeks later, after thousands of sessions affected. E mesmo quando team sabe que algo está off, fixing é guesswork: tweak prompt, change tool description, adjust orchestration, hope it helps — no structured way de saber se change improved ou quietly broke something else.

### Optimization loop: understand → fix → validate → prove

**Understand what your agents are doing** (preview today): rich failure, intent, e trajectory insights across hundreds of sessions, surfacing patterns no dashboard ou one-at-a-time trace review revelaria.
- **Failure insights**: discover recurring failure patterns incluindo silent behavioral failures (no error signal), explain root cause em detail, rank por how widespread — fix os que hurtam mais users primeiro
- **Intent insights**: cluster requests por what users were actually trying to do — real shape de como agent é usado
- **Trajectory insights**: group paths agents take through a task — spot common patterns e outliers
- Continuous monitoring com daily/weekly reports, ou targeted investigation pós-deployment/spike, results em minutes

**Fix it with confidence** (recommendations + A/B testing, GA today):
- **Recommendations**: analisam traces e evaluation outputs para sugerir specific improvements a system prompts e tool descriptions, grounded em como agent actually behaves
- **Batch evaluation**: testa recommendations contra test dataset, reports aggregate scores — catch regressions antes de production
- **A/B testing**: controlled comparison entre agent versions splitting live production traffic — real evidence que change works under production conditions antes de commit
- Works regardless of onde agents rodam: AgentCore runtime, AWS Lambda, Amazon EKS, ou non-AWS environments

> FUJISOFT quote (Kazumi Matsuda): Character Capsule framework packages agent roles/skills/procedures como reusable capsules em Copilot, Kiro, ou multi-agent orchestration em AgentCore. Optimization capabilities mudaram silent failures: analisam production traces, surface failure patterns, explain why, rank by impact, recommendations para prompts/tools, A/B test em live traffic. Agent improvement é continuous loop grounded em data, não trial and error.

## Stronger control as agents grow more capable — new policy enhancements

Agents mais capazes = mais surface area. Agents introduzem security challenge que traditional software nunca teve: são **probabilistic**. Agents fazem judgements, e judgements podem ser influenced por context. O novo point of exposure não é network; é agent's context, onde prompt injection e memory poisoning não requerem breaking in mas simply convincing o agent a make bad judgment.

Securing something probabilistic com something deterministic: não como brain, mas como guardrails around it. Policy capabilities no AgentCore já providenciam real-time, deterministic controls que definem o que agent pode e não pode fazer com tools e data no gateway.

**Bedrock Guardrails integration** (GA): avalia every agent action para prompt injection attempts, harmful content, sensitive data exposure. Checks rodam no gateway layer, outside agent's code — agent não pode vê-los no context, não pode reason around, não pode convince itself que não aplicam.

Guardrails é first de many detection signals que policy engine pode act on. Coming soon: feed detection signals de leading security providers (Check Point, Zscaler, Rubrik, Netskope, SentinelOne) nas mesmas policies. Princípio: detection pode ser probabilistic, mas policy enforcement é sempre deterministic — final allow-or-deny baseado em established thresholds.

Todo tool e context source no AgentCore routes through gateway — novas capabilities ganhas pelo agent são automaticamente governed pela mesma security layer. More capable agents, stronger controls, scaling together.

## AgentCore harness — generally available

Agent é mais que model. Se model é brain, **harness** é body: tudo que brain precisa para get work done. Runs orchestration loop, executes tools, manages context window, persists state across turns, recovers from failures, isolates each session. Harness shapes performance tanto quanto model. Building durable one é onde a maioria dos teams spend time.

**AgentCore harness (GA)**: managed capability. Ao invés de coding loop, define agent em configuration: model, tools, skills, instructions. AgentCore assembles e runs loop. Working agent em minutes, em isolated environment com filesystem, shell, memory across sessions, skills (incluindo AWS-curated catalog), e web browsing. Configuration inicial = what you operate at scale. Quando precisa custom orchestration, export harness to code, stay on same platform sem rebuild.

**Choice**: harness options hoje cada uma te deixa tied a something. Open-source: host/operate yourself. Managed services: lock ao environment. Model labs: optimized para seus models only. AgentCore decouplou harness do model — choose any model, switch mid-session sem tocar agent logic. As frontier moves e best model muda, agent foundation stays put.

Because harness é uma piece de single platform (não hosting layer wrapped around framework), reacha tools through same gateway que enforcea security policies e connects a organizational knowledge, web search, paid services. Identity, memory, observability da mesma platform — todo action governed e traced from first call sem additional wiring.

> Twilio quote (Omar Paul): AgentCore harness + Twilio Conversations → developers go from idea to live agent sem rewiring infrastructure.

## Availability

GA today: managed harness, Bedrock Managed Knowledge Base, Web Search, Guardrail Integration, recommendations e A/B testing. Preview: insights e payments.

## Por que importa para o vault

- **Continuous learning** é o mesmo princípio do hill-climbing no vault ([[04-SYSTEM/agents/core/hill]]) — understand → fix → validate → prove loop
- **Broader knowledge** = wikilinks + concepts + entities no vault — 3 layers (organizational, web, paid) espelham fontes do vault
- **Production debugging de silent failures**: failures que não throw errors mas look fine on dashboards — equivalente a drift no vault que só aparece weeks later
- **Agentic retriever vs basic RAG**: plan queries, connect concepts, evaluate intermediate results, re-rank — evolution do RAG que o vault poderia adoptar para search
- **Scalable controls**: deterministic guardrails around probabilistic agents — modelo para guard do vault (guardrails do pipeline-semanal: retry cap, token budget, confidence threshold)
- **AgentCore harness**: decoupled do model, configuration-based, export to code quando precisa — exatamente o pattern do Hermes agent system (skills + config, export to code)
- **Bedrock Guardrails no gateway layer**: checks rodam outside agent's code, agent não pode reason around — princípio de enforcement fora do contexto do agent
- **Multi-vendor detection signals**: Check Point, Zscaler, Rubrik, Netskope, SentinelOne — pattern de integrate signals de múltiplos providers numa policy engine

## Links

- [[04-SYSTEM/agents/core/hill]]
- [[03-RESOURCES/sources/articles/aws-transform-continuous-modernization]]
- [[03-RESOURCES/sources/ai-agents/how-frontier-teams-are-reinventing-ai-native-development]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]