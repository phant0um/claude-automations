---
title: "The Anatomy of an LLM — Interactive Visual Guide to How Language Models Work"
type: source
source: "Clippings/The Anatomy of an LLM  Interactive Visual Guide to How Language Models Work.md"
origin_url: "https://www.royvanrijn.com/anatomy-of-an-llm/"
author: "Roy van Rijn"
created: 2026-05-31
ingested: 2026-05-31
tags: [source, llm-internals, transformer, tokenization, attention, kv-cache, quantization, embeddings, backpropagation]
---

## Tese central

Um guia visual e interativo que percorre o pipeline completo de um LLM — da tokenização à geração — mostrando cada transformação com números pequenos e controles inspecionáveis, com o objetivo de tornar a "caixa preta" transparente para desenvolvedores.

## Argumentos principais

1. **Tokenização é a porta de entrada real** — texto é convertido em IDs de tokens (não palavras, não bytes); o tokenizador BPE (`o200k_base`) equilibra vocabulário vs. comprimento de sequência. Uma palavra ≠ um token; modelos diferentes tokenizam o mesmo texto de forma diferente.

2. **Embeddings são pontos de partida, não significados finais** — cada token ID é mapeado para uma linha em uma matriz de embeddings (dimensões reais: 768–4096+). O embedding inicial é livre de contexto; camadas subsequentes reescrevem o vetor à medida que o contexto flui.

3. **Funções de ativação (GELU, SiLU, SwiGLU) quebram a linearidade** — sem elas, empilhar camadas colapsaria para uma única transformação linear. A não-linearidade é onde a rede ganha expressividade.

4. **Redes feed-forward transformam posições individualmente** — attention move informação *entre* posições; FFN transforma informação *dentro* de cada posição. Matematicamente: expansão → ativação → projeção (ex.: 4096→14336→4096 no Llama-8B).

5. **Logits + sampling = não há resposta fixa** — o modelo produz scores sobre vocabulário completo; temperatura, top-k, top-p determinam o quão aventurosa é a escolha. Cada token é gerado autoregressivamente adicionando ao contexto.

6. **Backpropagation via chain rule** — gradientes fluem de trás para frente pelo grafo computacional; calculam sensibilidade da loss a cada parâmetro. Forward pass → gradientes → update do otimizador.

7. **Otimizadores diferem além dos gradients** — SGD (simples, ruidoso), Momentum (acumula direção), Adam (média móvel de gradientes + escala por parâmetro). Mesmo gradientes, caminhos diferentes no espaço de loss.

8. **Attention: Q/K/V routing** — Q pergunta; K anuncia; V carrega conteúdo. `scores = QK^T / sqrt(d_k)` → softmax → mix de valores. Multi-head: múltiplos padrões de roteamento em paralelo. GQA (grouped-query): grupos de heads de query compartilham heads K/V — reduz memória do KV cache.

9. **RoPE injeta posição na atenção** — rotaciona vetores Q e K de acordo com posição do token antes do dot product. Torna a compatibilidade Q·K sensível à posição relativa. Não rotaciona V; afeta compatibilidade, não payload.

10. **Bloco transformer completo (Llama-style):** `Input X → RMSNorm → Causal GQA+RoPE → +Residual → RMSNorm → SwiGLU MLP → +Residual → Y`. Conexões residuais preservam caminho para gradientes em redes profundas.

11. **Fases de treinamento:** pré-treino (next-token prediction, escala massiva de dados) → instruction tuning → preference tuning (RLHF, DPO). Pré-treino ensina capacidade; pós-treino molda comportamento.

12. **KV Cache** — durante geração autoregressive, armazena chaves e valores de tokens anteriores para evitar recomputação. Prefill processa o prompt e constrói o cache; decode gera token a token reusando o cache. Estimativa: `62.8x` menos trabalho de attention com cache em exemplo ilustrativo. Custo: mais memória proporcional ao comprimento do contexto.

13. **Quantização** — armazena pesos com menos bits (INT8, INT4, FP16) para reduzir memória e viabilizar inferência local. Trade-off: menos precisão → menos memória → inferência mais rápida/barata → algum erro de aproximação. FP32 ~32 GB para modelo 8B; INT4 ~4 GB. Existem múltiplos métodos: weight-only, weight+activation, proteção de outliers, KV cache quantizado.

## Key insights

- **Embedding é contexto-livre no início** — o token "bank" começa com o mesmo embedding em "river bank" e "investment bank"; camadas de atenção subsequentes reescrevem isso.
- **GQA é o padrão moderno** — troca capacidade de alguns heads por economia de memória no KV cache, permitindo contextos maiores.
- **RoPE afeta compatibilidade, não payload** — posição modula *quais* pares Q/K combinam bem; não carrega informação posicional diretamente no V.
- **Loss ≠ comportamento** — loss menor geralmente = melhor predição, mas não implica melhor raciocínio, honestidade, ou comportamento de assistente.
- **Post-training molda mais que capability** — alinhamento e safety são produzidos principalmente no pós-treino via múltiplos sinais, avaliações, e restrições de política.
- **Quantização INT4/INT8** — runtime kernels dequantizam de volta para float durante compute; o modelo armazena inteiros compactos mas opera em float aproximado.

## Exemplos e evidências

- Frase `"If the human brain were so simple..."` → 102 chars → 22 tokens com `o200k_base` (média 5 chars/token).
- Embedding de toy (24 dims): `dog = [0.7292, -0.3786, 0.1065, ...]`; tokens em contextos similares (cat/dog/rabbit) convergem no espaço vetorial.
- Token `blue` em "The blue car hit the wall": atenção → `car` captura 56.4% do peso de atenção (adjective→noun routing).
- Llama-8B: ~32 transformer blocks empilhados; MLP 4096→14336→4096.
- KV cache em exemplo ilustrativo: 10,644 compute com cache vs. 668,619 sem cache = 62.8× economia.
- FP32 para modelo 8B: ~32 GB; economia de memória via quantização viabiliza execução em hardware consumer.

## Implicações para o vault

- Reforça e expande `[[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]]` com dados quantitativos (62.8×, memória estimada).
- Complementa `[[03-RESOURCES/concepts/llm-ml-foundations/model-quantization]]` com detalhe sobre INT4/INT8 e dequantização em runtime.
- Referência pedagógica primária para qualquer conceito de LLM internals: tokenização → embedding → atenção → transformer block → treinamento.
- RoPE é novo conteúdo não coberto no vault — candidato para página conceito.

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]]
- [[03-RESOURCES/concepts/llm-ml-foundations/model-quantization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]]
