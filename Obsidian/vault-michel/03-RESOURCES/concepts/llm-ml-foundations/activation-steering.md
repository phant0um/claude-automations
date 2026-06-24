---
title: "Activation Steering"
type: concept
status: developing
created: 2026-05-05
updated: 2026-05-05
tags: [concept, llm, interpretability, mechanistic-interpretability, safety, activation-space]
---

# Activation Steering

**Definição:** Técnica de controle interpretável de LLMs que adiciona vetores aprendidos ao hidden state durante inferência para amplificar ou suprimir comportamentos específicos:

```
h_ℓ ← h_ℓ + α · v_i
```

Onde `v_i` é um steering vector para o trait/agente `i` e `α` é o coeficiente (positivo = amplifica, negativo = suprime).

## Extração de Steering Vectors

### Contrastive Activation Addition (CAA)

Método mais comum: para cada par contrastivo (contexto com comportamento target vs. contexto sem), extrai a diferença média nas ativações numa camada `ℓ`:

```
v_i = (1/|D|) Σ [h_ℓ(p, c_i) - h_ℓ(p, c_¬i)]
```

- `c_i` = completion do target
- `c_¬i` = completion alternativa (média dos outros agentes/persona)
- Camadas intermediárias (middle layers) são mais efetivas — capturem representações mais semânticas

### Difference-in-Means

Variante: média das ativações na classe positiva menos média na negativa. Captura conceitos linearmente separáveis no espaço de ativação.

## Aplicações

### Controle de Persona / Agentes

Em [[03-RESOURCES/concepts/agent-systems/internalized-multi-agent-debate]], steering vectors são extraídos por agente (Chain-of-Thought, Self-Critique, Program-of-Thought). IMAD cria subspaces mais separáveis que o modelo base, tornando steering mais preciso.

### Supressão de Traits Maliciosos

- **Evil trait**: localized → supressão completa possível (score→0 com α=-3 a -5)
- **Hallucination trait**: distributed → supressão parcial; não colapsa completamente
- IMAD suprime traits com menos degradação em task performance vs. base model

### Interpretabilidade Mecanística

Vetores revelam estrutura latente: se IMAD criou agent subspaces, steering deve evocar respostas alinhadas ao agente target com ROUGE-L superior ao base model. Melhora média observada: 15.41% de ROUGE-L AUC.

## Camadas Efetivas

Camadas intermediárias são mais efetivas para activation steering (achado consistente na literatura):
- LLaMA / Qwen: camada 15
- Mistral Nemo 12B: camada 20

## Limitações

- Traits "distribuídos" (ex: hallucination) são difíceis de suprimir completamente — não há um único subspace localizado
- Steering extremo degrada modelos base (perplexidade explode); modelos treinados com IMAD são mais robustos
- Técnica avaliada principalmente em médias de grupos; circuit-level analysis é direção futura

## Relação com Safety

Activation steering é uma ferramenta de **interpretabilidade acionável**: não apenas entende o modelo, mas permite controle cirúrgico. Contraste com RLHF/SFT que requer re-treinamento.

## Ver também

- [[03-RESOURCES/concepts/agent-systems/internalized-multi-agent-debate]] — caso de uso principal; agent subspaces
- [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]] — steering pode criar ou suprimir reward hacking behaviors
- [[03-RESOURCES/concepts/llm-ml-foundations/weak-to-strong-generalization]] — outra abordagem para safety via supervisão hierárquica
- [[03-RESOURCES/sources/ml-research-papers/clipping-latent-agents-post-training-multi-agent-debate]]
