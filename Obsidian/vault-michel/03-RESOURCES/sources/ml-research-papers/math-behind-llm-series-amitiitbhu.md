---
title: "Math Behind Large Language Model — Series"
type: source
source_url: "https://x.com/amitiitbhu/status/2058086754025136494"
author: "@amitiitbhu (OutcomeSchool)"
published: 2026-05-23
ingested: 2026-05-28
tags: [llm, math, attention, transformer, backpropagation, gradient-descent, rope, rmsnorm]
---

# Math Behind Large Language Model — Series

## Tese central

Todo LLM é construído sobre um conjunto pequeno de ideias matemáticas: attention, scaling, gradientes, loss, position encoding e normalização. Compreender a matemática por trás de cada uma transforma "mágica" em passos claros e replicáveis.

## Key insights

1. **Attention (Q, K, V):** cada palavra compara o que procura (Query) com o que as outras oferecem (Key) e coleta informação (Value) das mais relevantes. Operação central de todo LLM.
2. **√dₖ scaling:** dividir o dot product por √dₖ antes do softmax previne que dimensões grandes colapsom os gradientes — sem isso, o Transformer não aprende eficientemente.
3. **Backpropagation:** algoritmo que calcula quanto cada peso contribuiu para o erro, possibilitando ajuste eficiente. Pré-requisito para treinar qualquer rede.
4. **Gradient Descent:** algoritmo de otimização que "desce" a curva de erro passo a passo. Mais fundamental de todos — base do ML moderno.
5. **Cross-Entropy Loss:** mede o quão erradas são as probabilidades preditas. Função de loss de quase todo modelo moderno (GPT, BERT, classificadores de imagem).
6. **RoPE (Rotary Position Embedding):** rotaciona vetores Q e K por posição; o dot product resultante reflete distância relativa automaticamente — escalável e elegante.
7. **RMSNorm:** alternativa mais rápida ao LayerNorm que só escala (sem centering) usando root mean square. Usado em Llama, Mistral, Gemma, Qwen, PaLM, DeepSeek.

## Implicações para o vault

- Referência direta para [[03-RESOURCES/concepts/llm-ml-foundations/]] — cobre fundamentos de attention, normalização e otimização.
- Série completa em https://outcomeschool.com/blog/ — candidata a leitura para módulo de fundamentos de ML.
- RoPE e RMSNorm são as escolhas de facto em modelos pós-2023; útil para contextualizar decisões arquiteturais em [[03-RESOURCES/concepts/llm-ml-foundations/world-model-l1-l2-l3]].

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
