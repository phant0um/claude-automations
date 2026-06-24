---
title: "Evaluator-Optimizer Workflow"
type: concept
created: 2026-06-09
updated: 2026-06-09
tags: [agent-systems, workflow, quality, iteration, multi-agent]
status: developing
---

# Evaluator-Optimizer Workflow

Padrão de workflow agentico com dois sistemas de IA em ciclos iterativos: um **generator** produz conteúdo, um **evaluator** fornece feedback estruturado, e o ciclo repete até atingir critérios de qualidade ou budget de iterações.

## Mecânica

```
Generator → output v1
Evaluator → criteria check + actionable feedback
Generator → output v2 (incorpora feedback)
... (2–4 ciclos típicos)
Evaluator → PASS → output final
```

Análogo à colaboração escritor-editor: sugestões específicas são incorporadas em rascunhos revisados.

## Quando usar

- Critérios de avaliação claros e definíveis
- Refinamento iterativo entrega valor demonstrável (não basta primeira tentativa)
- Tarefas com nuance: tradução literária, geração de código com requisitos de segurança, comunicações profissionais onde tom importa, research com validação multi-step

## Quando evitar

- Primeira tentativa já atende os requisitos (overhead sem ganho)
- Critérios subjetivos ou indefinidos
- Aplicações real-time (latência proibitiva)
- Tarefas rotineiras simples (classificação básica)
- Token budget apertado — cada ciclo adiciona custo substancial
- Solução determinística existe (não precisa de refinamento)
- Evaluator não tem expertise de domínio suficiente para feedback significativo

## Exemplo: API Documentation Creator

1. Dev team submete codebase ao sistema
2. **Generator agent**: analisa codebase, cria documentação inicial (endpoints, parâmetros, exemplos, autenticação)
3. **Technical evaluator agent**: valida precisão técnica vs código real (tipos de parâmetros, cobertura de endpoints, correção de exemplos)
4. **Refinement cycle**: generator incorpora feedback, itera até todos critérios satisfeitos (tipicamente 2–4 ciclos)
5. **Output**: documentação publicada automaticamente no developer portal

## Diferença vs Generator-Verifier Loop

| Aspecto | Evaluator-Optimizer | Generator-Verifier |
|---------|--------------------|--------------------|
| Foco | Qualidade de conteúdo | Corretude/conformidade |
| Feedback | Nuanced, actionable guidance | Pass/fail + reason |
| Típico uso | Escrita, tradução, análise | Code, schemas, testes |
| Evaluator type | LLM especializado | Pode ser determinístico |

Ver [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]] para o padrão base.

## Custo

Cada ciclo adiciona tokens do generator + evaluator. Para tarefas high-value (documentação técnica, análise jurídica, campanhas de marketing) o custo se justifica. Para alta escala ou tarefas simples, evitar.

## Links

- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]] — padrão base mais geral
- [[03-RESOURCES/concepts/agent-systems/agentic-patterns]] — onde este workflow se encaixa na taxonomia
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — contexto de arquitetura
- [[03-RESOURCES/sources/building-effective-ai-agents-anthropic]]

## Evidências
- **[2026-06-19]** Gate out-of-sample em pesquisa quant é uma instância do padrão evaluator-optimizer: candidato só sobrevive se ICIR se mantém em dados nunca vistos, barra sobe conforme tentativas aumentam — [[how-quants-use-loop-engineering-to-build-alpha-full-framework]]
