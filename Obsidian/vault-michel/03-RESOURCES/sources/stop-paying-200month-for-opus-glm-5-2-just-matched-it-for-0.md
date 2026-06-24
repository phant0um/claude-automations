---
title: "Stop paying $200/month for Opus. GLM-5.2 just matched it for $0."
type: source
source: "Clippings/Stop paying $200-month for Opus. GLM-5.2 just matched it for $0..md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, model-benchmarks]
---

## Tese central
GLM-5.2 (Z.ai) é o primeiro modelo open-source a trocar golpes reais com Claude Opus em benchmarks de coding (não em slides de marketing) — salto geracional grande sobre GLM-5.1 (Terminal-Bench 2.1: 81.0 vs 62.0; SWE-bench Pro: 62.1 vs 58.4), disponível gratuitamente por tempo limitado via Zenmux + extensão Cline no VS Code.

## Argumentos principais
- Headline técnico: janela de contexto de 1M tokens com performance estável em tarefas de longo horizonte — exatamente onde a maioria dos agentes degrada conforme a tarefa se prolonga.
- Setup gratuito em 5 passos: conta Zenmux → API key Pay-As-You-Go → extensão Cline no VS Code (4.3M downloads) → provider "OpenAI Compatible" com Base URL `zenmux.ai/api/v1` e Model ID `z-ai/glm-5.2-free` → sem dados de pagamento exigidos.
- Limites do tier grátis: 10-15 requisições/minuto, tokens renovando a cada 5h, limite semanal em janela rolante de 7 dias — adequado para aprendizado/prototipagem/projetos pequenos, insuficiente para produção em escala.
- Recomendação pragmática do autor: quem já paga Opus em produção não deve trocar ainda (gap está fechando rápido, mas não fechado); quem está aprendendo/prototipando, o setup de 5 minutos vale a pena hoje.

## Key insights
- É a 2ª confirmação nesta leva (junto com a fonte GLM-5.2 já ingerida anteriormente) de que modelos abertos estão fechando o gap para frontier proprietário especificamente em coding/agentic benchmarks — reforça que `model-router` deste vault deveria revisitar periodicamente se algum tier cloud pode migrar para alternativa aberta sem perda de qualidade perceptível.
- "Gap fechando rápido mas não fechado" é orientação prática direta contra trocar produção por modelo aberto prematuramente apenas por economia — vale como critério de decisão se o vault algum dia avaliar trocar de provedor para tarefas críticas.

## Exemplos e evidências
- Benchmarks numéricos (Terminal-Bench 2.1, SWE-bench Pro) comparando GLM-5.1→5.2 e indiretamente a Opus; passo a passo completo de configuração no VS Code via Cline.

## Implicações para o vault
Nenhuma ação imediata — dado de mercado relevante para revisão periódica (não nesta sessão) de custo/benefício de tiers cloud do `model-router`.

## Links
- [[04-SYSTEM/agents/nexus-agent-system/model-router]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
