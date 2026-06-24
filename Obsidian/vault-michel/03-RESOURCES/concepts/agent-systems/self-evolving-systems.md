---
title: Self-Evolving Systems
type: concept
created: 2026-05-24
updated: 2026-05-24
tags: [agent-systems, self-improvement, memory, automl]
status: developing
---

# Self-Evolving Systems

Sistemas que **modificam sua própria arquitetura ou comportamento** com base em resultados observados — sem intervenção humana explícita. Distinguir de auto-tuning (parâmetros fixos) e fine-tuning (humano define objetivo): self-evolving systems descobrem o que otimizar.

## Exemplos no vault

| Sistema | O que evolui | Mecanismo |
|---------|-------------|-----------|
| **EvolveMem** | Configuração de retrieval (scoring functions, fusion strategies) | Diagnóstico LLM lê failure logs → propõe ajustes → guarded meta-analyzer aplica |
| **Hermes** | Próprias skills | Agente escreve novas skills baseado em tarefas que falhou |
| **hill agent** | Melhorias do vault | Monitora outputs, propõe melhorias, registra em errors.md |
| **ECC browse.sh** | Skill library | Compounding pattern — skills melhoram skills |

## Propriedades críticas de produção

1. **Guarded application**: mudanças testadas antes de aplicar → revert automático se performance regride
2. **Explore-on-stagnation**: quando não há melhoria por N ciclos, explorar dimensões não consideradas
3. **Failure log as signal**: não apenas métricas agregadas — análise por caso de falha
4. **Positive transfer**: configurações evoluídas transferem entre domínios (não overfitting)

## EvolveMem — Blueprint de Referência

- Expõe configuração de retrieval como **action space** estruturado
- Diagnóstico LLM: lê failure logs por questão → identifica root cause → propõe ajuste targeted
- Guarded meta-analyzer: aplica com `auto-revert se regride` + `explore-on-stagnation`
- Resultado: +25.7% relativo no LoCoMo benchmark vs baseline mais forte

## Paradoxo Memory Curse (relacionado)

Mais memória ≠ melhor sistema. Em multi-agent systems, recall expandido pode **erodir cooperação** (CMU/Harvard/Michigan). Self-evolving memory deve incluir políticas de **esquecimento intencional**.

## Implicações para vault

- Hill agent atual: executa melhoria mas sem guarded application automático
- Gap: vault não tem feedback loop automático entre output de agentes e melhoria de skills
- Blueprint EvolveMem → roadmap para hill v2: failure logs → diagnóstico → patch → revert-on-regression

## Links

- [[03-RESOURCES/sources/memory-context-rag/evolvemem-self-evolving-memory-architecture]]
- [[03-RESOURCES/sources/hermes-agent/hermes-agent-masterclass]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-layers]]
- [[04-SYSTEM/agents/core/hill]]

## Evidências
- **[2026-06-19]** Warp usa o mesmo padrão de self-improvement loop para gerenciar seu próprio repositório open-source, extraído como framework reusável (oz-for-oss) — [[03-RESOURCES/sources/how-to-build-a-self-improvement-loop-for-skills]]
