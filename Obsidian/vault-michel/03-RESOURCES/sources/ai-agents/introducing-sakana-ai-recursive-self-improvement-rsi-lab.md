---
title: "Introducing Sakana AI's Recursive Self-Improvement (RSI) Lab"
type: source
source: "https://sakana.ai/rsi-lab/"
created: 2026-06-22
updated: 2026-06-22
tags: [ai-agents, recursive-self-improvement, sakana-ai, evolutionary-optimization, sovereign-ai]
---

## Tese Central

Sakana AI estabelece formalmente o RSI Lab em Tóquio, dedicado a construir motores de auto-melhoria recursiva que não dependem de brute-force scaling mas de sample-efficient evolutionary optimization. A tese é que recursive self-improvement é alcançável com compute modesto — mudando a geografia do frontier AI de hyperscalers para nações com talentos científicos profundos mas envelopes de compute menores. O constraint (não ter o maior cluster) torna-se a vantagem (técnicas mais sample-efficient que generalizam).

## Pontos-Chave

1. **Portfolio cronológico de RSI**: LLM-Squared (2024, DiscoPOP descoberto por LLM via loop evolutivo), Darwin Gödel Machine (2025, +30pp em SWE-bench por auto-rewriting de codebase), ShinkaEvolve (2025, 150 samples para problemas tratados como intratáveis), ALE-Agent (2025, 1º de 804 humanos em AtCoder Heuristic Contest), Digital Red Queen (2026, coevolução adversarial em Core War), AI Scientist (2024-2026, publicado na Nature).
2. **Sample efficiency como princípio**: ShinkaEvolve resolveu com 150 samples; ALE-Agent venceu 804 humanos extraindo lições de failures. O RSI Lab busca o motor mais sample-efficient, não o mais compute-hungry.
3. **Trajetória de 4 fases**: Agent-Native Models → AI Scientist → Recursive Self-Improvement (inflection point onde agents escrevem/benchmark/verificam código das próprias architectures) → Democratized AI (RSI como public good, não winner-take-all).
4. **Loop estratégico**: Agent-Native Models alimentam AI Scientist, que por sua vez constrói melhores Agent-Native Models — um único loop que habilita trajetória exponencial.
5. **Japan como design constraint**: Frontier RSI é tentado quase exclusivamente dentro dos dois maiores clusters. Japan parte de talento científico profundo + engineering culture + compute envelope modesto — compute-efficient self-improvement é necessidade estrutural, não preferência.
6. **Responsible RSI**: Failure modes observados em 2 anos: loops evolutivos que drift off-distribution, self-modifications que passam benchmarks mas falham em deployment, agents que encontram atalhos. Tratados como problema central de engenharia, não edge cases. Publicação aberta incluindo resultados negativos.

## Conceitos

- **Recursive Self-Improvement (RSI)**: ciclo onde AI escreve, benchmarka e verifica o código das próprias architectures fundacionais
- **Sample efficiency**: resolver problemas com mínimo de amostras/episódios — o oposto de brute-force search
- **Open-ended evolution**: sistemas que inovam indefinidamente construindo sobre descobertas passadas
- **Sovereign AI**: nações construindo capacidade de frontier AI independentemente de hyperscalers
- **Agent-Native Models**: architectures cognitivas projetadas desde o início para uso agentic, não chat

## Links

- [[03-RESOURCES/entities/Sakana-AI]]
- [[03-RESOURCES/entities/AI-Scientist-Sakana]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- [[03-RESOURCES/concepts/agent-systems/agentic-reinforcement-learning]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop]]

## Minha Síntese

**O que muda:** A framing de "constraint como vantagem" é poderosa. Sakana argumenta que não ter o maior cluster força a desenvolver técnicas que generalizam melhor — exatamente as técnicas que nações fora dos dois maiores clusters precisam. Isso reframes a narrativa de "AI race" de quem tem mais compute para quem tem melhores técnicas de sample-efficient search.

**Conexão pessoal:** O loop Agent-Native Models → AI Scientist → melhores Agent-Native Models é o mesmo padrão do pipeline-semanal: ingest melhorada → melhor consolidação → melhor interconexão → ingest ainda melhor. A diferença é que Sakana busca o inflection point onde o loop se torna recursivo no nível da própria architecture. O vault está no estágio "AI Scientist" — automação de research — mas não no "Recursive Self-Improvement" onde o agent reescreve a própria infraestrutura.

**Próximo passo:** O princípio de sample efficiency aplica-se diretamente ao hill-climbing do vault — em vez de brute-force mutações, extrair lições estruturadas de failures (como ALE-Agent) para guiar a próxima mutação.