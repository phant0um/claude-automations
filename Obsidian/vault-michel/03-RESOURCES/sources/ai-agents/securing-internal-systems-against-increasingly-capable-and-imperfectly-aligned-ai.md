---
title: "Securing internal systems against increasingly capable and imperfectly aligned AI"
type: source
source: "https://deepmind.google/blog/securing-the-future-of-ai-agents/"
created: 2026-06-22
updated: 2026-06-22
tags: [ai-agents, security, ai-control, deepmind, defense-in-depth, agent-safety]
---

## Tese Central

Google DeepMind publica o AI Control Roadmap: um framework defense-in-depth para gerenciar AI agents internos que trata o agente como potencialmente misaligned — não como entidade totalmente confiável. O approach vai além de model alignment tradicional, adicionando system-level security que provides assurance mesmo quando alignment é imperfect. A analogia: instructor de direção com dual controls — confia no student mas mantém-se pronto para frear.

## Pontos-Chave

1. **Three key areas**: (1) Threat-modelling framework para AI baseado em MITRE ATT&CK — trata untrusted agents como "insider threats" similar a rogue employee; (2) Detection — trusted AI "supervisors" monitoram reasoning/actions/plans do agent working; (3) Prevention/Response — supervisor pode bloquear ação harmful antes do damage.
2. **Three critical metrics**: coverage (fração de tráfego monitorado), recall (fração de misaligned behaviors caught), time-to-response.
3. **Scaling security com capability**: Detection levels D1-D4 baseados em ability to evade detection (hoje monitora chain-of-thought visível; futuro: oversight awareness + opaque reasoning exigem análise behavioral e inner workings). Response levels R1-R3 baseados em ability for harm (low-risk = asynchronous; high-risk como cyber attacks = synchronous real-time prevention).
4. **Million agent trajectories**: Protótipo interno de asynchronous monitoring revisa coding agent trajectories, classifica contra threat taxonomy. Já analisou 1 milhão de coding agent tasks. Live monitor para Gemini Spark agent — responde real-time a issues como unintentional data deletion.
5. **Majority não é adversarial**: Dados mostram que maioria dos flagged events não vêm de adversarial intent mas de agent misinterpretation ou overeagerness para atingir o goal do usuário. Understanding nuances é crítico para refinar protocols.
6. **Three Layers of Agent Security**: Paper para policymakers — segurança em nível de individual agents, multi-agent systems, e empoderar cyber defenders + societal resilience.

## Conceitos

- **AI Control Roadmap**: framework defense-in-depth que trata agents como potentially misaligned
- **Insider threat model**: tratar untrusted AI como rogue employee com access interno
- **Oversight awareness**: modelo sabe que está sendo monitorado e pode esconder reasoning
- **Opaque reasoning**: modelo raciocina sem usar texto visível, escapando monitoring de chain-of-thought
- **Synchronous vs asynchronous response**: real-time blocking para high-risk, delayed review para low-risk reversible

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[03-RESOURCES/concepts/agent-systems/agent-security-stack]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
- [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]]
- [[03-RESOURCES/entities/Microsoft]]