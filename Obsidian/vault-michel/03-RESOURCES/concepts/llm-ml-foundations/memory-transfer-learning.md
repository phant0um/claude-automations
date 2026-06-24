---
title: Memory Transfer Learning (MTL)
type: concept
status: developing
created: 2026-04-19
updated: 2026-05-19
tags: [memory, transfer-learning, coding-agents, self-evolving-agents, meta-knowledge, abstraction]
---

# Memory Transfer Learning (MTL)

Paradigma em que agentes aproveitam memórias geradas em **domínios heterogêneos** (cross-domain) para melhorar performance em novos tasks — em vez de restringir memória ao mesmo benchmark/domínio.

Introduzido formalmente por Kim et al. (ICML, KAIST/NYU/DeepAuto.ai) em contexto de coding agents. Resultado: **+3,7% de ganho médio** em 6 benchmarks usando memórias cross-domain.

## Premissa Central

Coding tasks aparentemente diferentes (competitive programming, software engineering, ML research) compartilham **infraestrutura comum**: Linux shell, linguagens de programação, padrões de debugging. Logo, memórias de um domínio carregam meta-conhecimento útil para outros.

## Insight Crítico: Abstração Dita Transferibilidade

```
Insight (alto) > Summary > Workflow > Trajectory (baixo)
```

**Por que?** Memória de alta abstração contém predominantemente **meta-conhecimento** (invariante de domínio), enquanto memórias de baixa abstração retêm detalhes task-specific que agem como ruído em novos contextos.

Formalização:
- `e(m) = z_inv(m) + z_sp(m)` (embedding = invariante + específico)
- Abstração A = ‖z_inv‖² / (‖z_inv‖² + ‖z_sp‖²)
- **Transfer gain aumenta estritamente com A** (Proposição 1, Apêndice C)

## Os 4 Formatos de Memória

| Formato | Abstração | Transferibilidade |
|---------|-----------|-------------------|
| **Trajectory** | Baixa | Baixa — causa negative transfer (brittle anchoring) |
| **Workflow** | Média-baixa | Moderada |
| **Summary** | Média-alta | Boa |
| **Insight** | Alta | Melhor — task-agnostic, generaliza cross-domain |

**Insight format**: título + descrição + conteúdo generalizável, sem mencionar arquivos ou detalhes específicos.

## O Que se Transfere (Meta-Conhecimento)

1. **Iterative Workflow**: inspect → edit → verify → submit (evitar one-shot)
2. **Test-Driven Verification**: criar scripts de reprodução locais
3. **Environmental Adaptation**: constraints de OS/shell/toolchain
4. **Anti-Pattern Avoidance**: evitar blind overwrites, hardcoding
5. **API Compliance**: respeitar function signatures, output schemas
6. _Algorithmic Strategy_: apenas ~5,5% dos ganhos — transferência direta de algoritmos é limitada

## Negative Transfer — 3 Causas

1. **Domain-mismatched anchoring**: memória superficialmente similar distorce raciocínio
2. **False validation confidence**: loops de auto-confirmação com checks superficiais
3. **Misapplied best-practice**: padrões bem-sucedidos aplicados indiscriminadamente

## Escalabilidade

- Mais memórias no pool → melhor performance (relação monotônica)
- Mais domínios como fonte → melhor performance (diversidade aumenta probabilidade de meta-conhecimento relevante)
- **Cross-model transfer funciona**: meta-conhecimento é model-agnostic (GPT-5-mini ↔ Qwen3-Coder ↔ DeepSeek V3.2)

## Retrieval: Simple Wins

Embedding similarity simples supera LLM Reranking e Adaptive Rewriting. Retrieval estático não generaliza para ambientes agentic multi-step. Direção futura: domain routing, step-wise retrieval.

## Comparação com Self-Evolving Approaches

| Método | #Memórias | Avg Pass@3 |
|--------|-----------|------------|
| Zeroshot | — | 0.584 |
| ReasoningBank (in-domain) | 97 | 0.601 |
| AgentKB (cross-domain geral) | 5.899 | 0.613 |
| **MTL (ours)** | **431** | **0.630** |

MTL é mais eficiente: **menos memórias, maior ganho**.

## Relação com Transfer Learning Clássico

Transfer Learning tradicional: adaptação paramétrica (fine-tuning, adapters). MTL é **não-paramétrico**: transfere conhecimento via contexto (in-context memory), sem atualizar pesos do modelo. Similar a In-Context Learning, mas o conhecimento é gerado pelo próprio modelo durante inferência.

## Ver Também

- [[agent-memory-architecture]] — tipos de memória, layers de implementação, Auto Dream
- [[context-engineering]] — o que entra no contexto do agente
- [[multi-agent-orchestration]] — coordenação de agentes com pools de memória compartilhados
- [[knowledge-compounding]] — acumulação de conhecimento reutilizável

## Fontes

- [[03-RESOURCES/sources/memory-context-rag/memory-transfer-learning-coding-agents]] — paper ICML (Kim et al.)
