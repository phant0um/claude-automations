---
title: "Hermes Agent Just Changed Local AI Forever: Here's How to Run It Yourself"
type: source
source: "Clippings/Hermes Agent Just Changed Local AI Forever Here's How to Run It Yourself.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

A convergência de três fatores — Hermes Agent (Nous Research, open-source, self-writing skills), Qwen 3.6 (35B outperforma 120B, cabe em 20GB), e DGX Spark (128GB unified memory, $0/mês após hardware) — cria o primeiro agente local credível que se auto-melhora continuamente, funciona 24/7, acumula conhecimento específico do usuário e nunca envia dados para nenhuma empresa.

## Argumentos principais

- Hermes é estruturalmente diferente de outros "agentes": ele escreve suas próprias skills em disco e as melhora via DSPy + GEPA (Genetic-Pareto Prompt Evolution) — mutations são avaliadas, as melhores são promovidas, melhorias são mensuráveis
- Qwen 3.6 quebrou o tradeoff local: 35B supera modelos de 120B de geração anterior a 1/3 do memory footprint; modelo inteligente o suficiente para planear, decompor e se auto-corrigir agora cabe em GPU consumer
- Arquitetura de memória em três camadas: persistent notes (preferências, convenções de projeto), searchable session history (tudo indexado para retrieval), procedural skills (workflows aprendidos)
- Para enterprises e regulados: a história de data-sovereignty ficou radicalmente mais forte — "você não pode usar IA porque envia dados para OpenAI" deixa de ser uma restrição

## Key insights

- Skills acumuladas: agentes com 20+ self-created skills completam tarefas futuras similares ~40% mais rápido que instâncias novas (benchmarks independentes)
- Arquitetura: Hermes é o orchestration layer (planner, tool runner, skill writer); modelo é separado, conectado via API OpenAI-compatible em localhost; tudo persiste em `~/.hermes/` como markdown legível
- Gotcha mais comum no setup: context window muito pequena (Hermes precisa de pelo menos 64K tokens — Ollama default é 4K); erro: `ollama run qwen3.6 -c 65536`
- Gateways (Telegram, Discord, Slack, WhatsApp, Signal, email) são a transformação de "CLI no laptop" para "meu AI pessoal que posso textar de qualquer lugar"
- Hardware honesto: MacBook Pro M3/M4 com 32GB+ roda Qwen 3.6 27B smoothly; desktop com RTX 3090/4090 é o sweet spot; 8GB RAM + integrated graphics → use cloud API instead

## Exemplos e evidências

- 140.000 GitHub stars em 3 meses; agente mais usado no mundo segundo OpenRouter (maio 2026)
- NVIDIA DGX Spark: 128GB unified memory, 1 petaflop AI performance, purpose-built para agentes contínuos
- Qwen 3.6 27B: match acurácia de modelos antigos de 400B parâmetros
- Após 1 mês de uso: `~/.hermes/skills/` contém 20-50 skills, cada uma capturando como Hermes aprendeu a fazer um tipo específico de tarefa para você
- 5 issues mais comuns de setup documentados com soluções exatas
- Preocupações honestas: self-improving loop pode criar drift silencioso dos objetivos reais; security é superfície real de ataque (skill poisoning, prompt injection via conteúdo fetchado, tools maliciosos)

## Implicações para o vault

Contexto de por que Hermes importa como framework de agentes locais. A arquitetura de três camadas de memória (persistent notes + session history + procedural skills) é referência para o design de memória deste vault. O modelo mental de "skills que se auto-melhoram via feedback de sucesso/falha" é aplicável ao sistema de skills do vault. A preocupação sobre skill poisoning e drift são relevantes para o guardrail `guard` deste vault.

## Links

- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/entities/Nous Research]]
- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-security]]
