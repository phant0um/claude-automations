---
title: "Model Compression"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# Model Compression

Reduzir tamanho e custo de compute de modelos treinados sem perda significativa de qualidade — viabilizando deployment em edge e redução de custo em produção.

## O que é

Model compression é o conjunto de técnicas que tornam modelos grandes práticos para deployment. Um modelo de 70B parâmetros em FP32 ocupa ~280GB; comprimido para INT4, cabe em ~35GB. As técnicas podem ser combinadas para multiplicar o ganho.

## Como funciona

**Quantização** — reduzir precisão dos pesos:
- FP16/BF16: padrão de treino; 2× menor que FP32.
- INT8: ~4× menor, perda mínima. Suportado por TensorRT, bitsandbytes.
- INT4/GGUF: ~8× menor; viabiliza LLMs em laptops (llama.cpp, Ollama).
- GPTQ/AWQ: quantização pós-treinamento calibrada com dados reais; melhor qualidade que quantização ingênua.

**Pruning** — remover pesos desnecessários:
- Não-estruturado: zera pesos individuais; ganho de memória requer hardware especializado (sparsity).
- Estruturado: remove cabeças de atenção, camadas, ou neurônios inteiros; ganho direto em qualquer hardware.

**Knowledge Distillation** — comprimir comportamento de um modelo grande (teacher) em um menor (student):
- Student treina para imitar logits ou ativações do teacher.
- DistilBERT, Phi-3-mini (destilado de GPT-4), e TinyLLaMA são exemplos.

**LoRA/QLoRA como fine-tuning comprimido**: não comprime o modelo base, mas permite especialização sem carregar parâmetros extras em produção (merge ou adapter-only serving).

## Por que importa

Sem compressão, LLMs ficam restritos a clusters de GPU de alto custo. Com INT4 + GGUF, Llama 3 8B roda em MacBook Air M2 com 8GB de RAM. Para Michel: entender compressão explica por que modelos locais existem, como escolher o formato certo (GGUF Q4_K_M vs Q8_0), e quando aceitar o tradeoff qualidade-tamanho.

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/llm-ml-foundations/fine-tuning]]
- [[03-RESOURCES/concepts/model-routing]]
- [[03-RESOURCES/sources/smaller-models-structurally-excluded]] — reduzir capacidade abaixo de um limiar pode eliminar (não só degradar) a habilidade do modelo em tarefas de cauda longa
