---
title: "Model Routing"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# Model Routing

Direcionar cada request para o modelo mais adequado conforme complexidade e custo, em vez de usar o mesmo modelo para tudo.

## O que é

Model routing é a camada de decisão que seleciona dinamicamente qual modelo executa cada request. O princípio: tarefas simples não precisam de Opus; tarefas complexas não deveriam ir para Haiku. Roteamento inteligente maximiza qualidade/custo no portfólio de modelos disponíveis.

## Como funciona

**Abordagens de roteamento:**

1. **Classificador de roteamento**: modelo leve (BERT-tiny, regras, heurísticas) analisa o request e classifica como simples/médio/complexo → direciona ao modelo correspondente.
2. **Cascata**: começa no modelo mais barato; se a resposta não passa em um verificador de qualidade, re-processa no modelo mais caro.
3. **Roteamento por feature**: domínio (código → Codex/Sonnet), língua, comprimento esperado, histórico do usuário.
4. **Mixture of Experts (MoE) interno**: roteamento dentro do modelo — cada token ativa um subset dos "experts" (sub-redes). GPT-4 e Mixtral usam essa arquitetura; não é configurável pelo usuário, mas explica eficiência.

**Tradeoff custo-qualidade:**
| Modelo | Custo relativo | Uso ideal |
|---|---|---|
| Haiku 3.5 | ~1× | Classificação, extração, sumarização curta |
| Sonnet 4 | ~5× | Raciocínio médio, código, análise |
| Opus 4 | ~15× | Raciocínio profundo, auditoria, decisões críticas |

## Por que importa

Em produção com volume, roteamento reduz custos em 60–80% sem perda de qualidade percebida. Para sistemas de agentes, roteamento é a diferença entre uma pipeline sustentável e um orçamento de API exaurido em dias.

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/model-selection-patterns]]
- [[03-RESOURCES/concepts/model-compression]]
- [[03-RESOURCES/sources/smaller-models-structurally-excluded]] — modelos pequenos podem ser estruturalmente incapazes (não só piores) em tarefas raras

## Evidências
- **[2026-06-19]** Agente torna escolha de modelo uma decisão operacional, não cosmética: modelo barato bom-o-suficiente muda a frequência com que humanos deixam o sistema rodar; debate de custo (DeepSeek vs. GPT-5.5 vs. Claude) domina a comunidade Hermes — [[hermes-users-are-turning-agents-into-chores-side-businesses-and-security-debates]]
