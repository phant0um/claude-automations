---
title: GEO — Generative Engine Optimization
type: concept
status: developing
created: 2026-05-18
updated: 2026-05-19
tags: [geo, seo, ai-search, llms-txt, mcp, agent-readiness, perplexity, chatgpt]
---

# GEO — Generative Engine Optimization

Versão do SEO para a era de AI search. SEO otimiza para blue links no Google. GEO otimiza para ser citado nas respostas geradas por LLMs — ChatGPT, Perplexity, Google AI Overviews, Claude.

## SEO vs GEO

| Dimensão | SEO | GEO |
|----------|-----|-----|
| Target | Crawler de busca | LLM inference |
| Output | Ranking em SERP | Citação em resposta gerada |
| Sinal | Backlinks, keywords, CTR | Clareza estrutural, autoridade semântica, exposição de schema |
| Prazo | Semanas/meses | Variável por modelo |

## Três Pilares de Agent Readiness

Para ser consumível por agentes AI (não apenas usuários humanos):

**1. MCP Exposure**
Expor ferramentas via Model Context Protocol permite que agentes interajam com o produto programaticamente. Um agente pode comprar, consultar, ou usar o serviço sem UI.

**2. `llms.txt`**
Arquivo padrão (análogo ao `robots.txt`) que descreve o produto para LLMs: o que o serviço faz, quais endpoints existem, como usar. Permite que LLMs incluam descrições precisas sem hallucination.

**3. OAuth para Agentes**
Autenticação que permite agentes autorizados agir em nome do usuário. Sem OAuth, o agente pode descrever mas não executar.

## Por Que Importa

À medida que AI search substitui busca tradicional, empresas que não otimizam para GEO ficam invisíveis nas respostas de LLMs — mesmo que rankem bem no Google.

Padrão emergente: produtos que expõem MCP + llms.txt + OAuth aparecem em respostas de agentes como opções executáveis, não apenas mencionadas.

## Relacionados

- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — protocolo central para agent readiness
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — como LLMs processam informação de fontes externas
- [[03-RESOURCES/sources/fseixas-super-geo-agent-readiness]] — skill de referência (Claude Skill)
- [[03-RESOURCES/entities/Perplexity-AI]] — search engine que mais avança GEO como padrão

## Evidências
- **[2026-06-24]** Andreas Chouliaras 1 Luke Connolly 2 and Dimitris Chatzopoulos 1 \*This work is supported by EU Hori — [[themis-an-explainable-ai-enabled-framework-for-reinforcement-learning-with-human-feedback]]
- **[2026-06-24]** According to Gartner, the average Global Fortune 500 enterprise will have over 150,000 AI agents in  — [[aws-genaiic-partner-agent-factory-new-ai-agents-now-in-aws-marketplace]]
- **[2026-06-24]** Formal verification produces machine-checkable certificates that attest to the satisfaction or viola — [[cycle-consistent-neural-explanation-of-formal-verification-certificates]]
- **[2026-06-24]** - Early testing shows that the first-generation accelerator will deliver performance per watt substa — [[openai-and-broadcom-unveil-llm-optimized-inference-chip]]
- **[2026-06-24]** Tianbao Ma    Chang Xi    Yichuan Zou    Chengen Li    Linxun Chen    Zilong Lu    Yanan Niu    Zhao — [[scaletot-generalizing-structured-llm-reasoning-for-billion-scale-low-activity-user-modeling]]
- **[2026-06-24]** Quanyan Zhu Department of Electrical and Computer Engineering, New York University Tandon School of  — [[ai-tokenomics-the-economics-of-tokens-computation-and-pricing-in-foundation-models]]
- **[2026-06-24]** Bingnan Xiao, Chenhao Yang, Wei Ni,, Xin Wang,, and Tony Q. — [[agentic-ai-for-bilevel-long-term-optimization-of-policy-driven-physical-layer-systems]]
- **[2026-06-24]** Today we are releasing prime-rl version 0. — [[rl-at-1t-scale-prime-rl-performance-deep-dive]]
- **[2026-06-24]** Tuning AI systems by hand doesn't scale. — [[cocoevolve-evolutionary-optimization-for-ai-systems]]
- **[2026-06-24]** Loka transformed customer voice interactions by building a conversational AI agent with Amazon Nova  — [[how-loka-built-a-natural-low-latency-voice-agent-with-amazon-nova-2-sonic]]
