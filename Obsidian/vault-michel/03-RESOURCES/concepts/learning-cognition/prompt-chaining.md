---
title: "Prompt Chaining"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# Prompt Chaining

Decompor uma tarefa complexa em chamadas LLM sequenciais, onde o output de cada etapa alimenta o input da próxima — aumenta qualidade e controle ao custo de múltiplas chamadas.

## O que é

Prompt chaining é o padrão de composição mais fundamental em sistemas agênticos: em vez de um prompt longo e complexo, a tarefa é dividida em subtarefas, cada uma processada por uma chamada dedicada, com o resultado sendo passado adiante.

## Como funciona

**Fluxo básico:**
```
Input → [Prompt 1] → Output A → [Prompt 2] → Output B → [Prompt 3] → Resultado Final
```

**Quando encadear:**
- Tarefas com fases logicamente distintas (rascunho → revisão → formatação)
- Quando cada etapa exige instrução diferente ou persona diferente
- Para manter cada chamada dentro de limites de contexto
- Quando se quer checkpoint e validação entre etapas

**Quando paralelizar em vez de encadear:**
- Subtarefas independentes (sem dependência de dados entre si)
- Análise de múltiplos documentos simultâneos
- Geração de variantes para seleção posterior

**Passagem de estado:** o output pode ser passado como texto bruto, JSON estruturado, ou resumo condensado. JSON estruturado é preferível — reduz ambiguidade e facilita parsing.

**Contraste com prompt único longo:** um prompt monolítico perde raciocínio em tarefas longas; o chaining força estrutura explícita e permite inspeção de cada etapa.

## Por que importa

Chaining é a base de workflows agênticos complexos (pipelines de ingestão, geração de conteúdo em múltiplos passos, análise de documentos). Dominar quando encadear vs paralelizar vs usar single-shot é a habilidade central no design de sistemas com LLMs.

## Evidências
- **[2026-06-19]** Método STORM (Stanford) replicado em 4 prompts encadeados no Claude (multi-perspective scan → contradiction map → synthesis → peer review) comprime pesquisa de 40-60h para 5 minutos — [[03-RESOURCES/sources/stanford-storm-method-claude-research]]

## Related
- [[03-RESOURCES/concepts/agent-orchestration]]
- [[03-RESOURCES/concepts/multi-step-planning]]
