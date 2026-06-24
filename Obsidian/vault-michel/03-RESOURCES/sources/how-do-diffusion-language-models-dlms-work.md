---
title: "How do Diffusion Language Models (DLMs) work?"
type: source
source: "Clippings/How do Diffusion Language Models (DLMs) work?.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Diffusion Language Models (DLMs) geram texto de um jeito fundamentalmente diferente dos LLMs autorregressivos atuais: em vez de escrever palavra por palavra da esquerda para a direita, começam de uma frase "toda ruído" (mascarada) e refinam múltiplas posições em paralelo, a cada rodada mantendo as palavras mais confiantes e remascarando as incertas, até não restar nenhum blank. Isso resolve o gargalo de velocidade do autoregressivo (que é estritamente sequencial) ao custo de uma arquitetura de treino e geração mais complexa.

## Argumentos principais
- **Como LLMs de hoje escrevem**: geração autorregressiva — o modelo prevê a próxima palavra com base em todas as anteriores, uma de cada vez, nunca podendo escolher a 3ª palavra antes da 2ª. Funciona bem, mas é estritamente sequencial: uma frase de 100 palavras exige 100 turnos, sem paralelismo.
- **Origem da ideia de diffusion**: nasceu em modelos de imagem — pega-se uma foto clara, adiciona-se ruído repetidamente até virar estática pura, depois treina-se um modelo para fazer o caminho inverso (remover ruído gradualmente). A pergunta natural: dá para fazer o mesmo com texto?
- **O que "ruído" significa para texto**: como não existe "meia palavra", ruído em texto = mascarar/esconder palavras com um placeholder. Mais palavras mascaradas = mais ruído; todas mascaradas = ruído puro (equivalente à estática de imagem).
- **Duas fases do treinamento**:
  - **Forward (só treino)**: parte fácil — mascarar palavras de uma frase limpa progressivamente até tudo ficar mascarado; não exige inteligência, é só deletar de propósito.
  - **Reverse (o que o modelo aprende)**: parte difícil — pegar a frase mascarada e adivinhar as palavras escondidas para limpá-la; repete o processo preenchendo cada vez mais.
- **Geração passo a passo de uma frase nova**: (1) começa com tudo mascarado; (2) adivinha todas as palavras de uma vez, em paralelo, não da esquerda para a direita; (3) mantém as palavras mais confiantes, remascara as incertas; (4) repete usando o contexto já preenchido como pista para as palavras mais difíceis; (5) para quando não há mais máscaras.
- **Diferença-chave vs. autoregressivo**: o DLM corrige várias palavras em paralelo em cada rodada, em vez de uma por vez sequencialmente — isso é o que permite ganhos potenciais de velocidade.

## Key insights
- A vantagem do paralelismo do DLM é estrutural, não incremental: o modelo não está apenas "mais rápido" no mesmo algoritmo — está usando um algoritmo de geração categoricamente diferente (refinamento iterativo global vs. extensão sequencial local).
- O truque central de qualidade — "manter os confiantes, remascarar os incertos" — é o que evita que o modelo trave em palavras erradas logo na primeira rodada: ele usa as palavras fáceis e certas (ex.: "The", "is") como andaime de contexto para acertar as difíceis nas rodadas seguintes.
- A analogia com diffusion de imagem (popularizada por geração de imagem a partir de texto) é o que torna a ideia tratável — o artigo trata a transposição imagem→texto como o salto conceitual central do método.

## Exemplos e evidências
- Exemplo textual passo a passo: "The cat sat on the mat" → "The cat [?] on the mat" → "The [?] [?] on [?] mat" → "[?] [?] [?] [?] [?] [?]" (forward/mascaramento progressivo) e o caminho inverso correspondente (reverse/preenchimento).
- Exemplo de geração end-to-end com 4 rodadas até frase completa: Round 1 todo mascarado → Round 2 preenche "The" e "is" (mais confiantes) → Round 3 preenche mais uma palavra → Round 4 "The food here is good" (sem blanks restantes).

## Implicações para o vault
DLMs ainda não têm concept próprio no vault — `llm-pretraining.md`, `reasoning-models.md` e `speculative-decoding.md` em `llm-ml-foundations/` cobrem técnicas de geração/inferência adjacentes, mas nenhuma aborda arquitetura de difusão para texto. Esta source justifica a criação de um concept novo (`diffusion-language-models`) cobrindo o mecanismo forward/reverse e a vantagem de paralelismo — relevante para o domínio de inferência/otimização (`inference-optimization.md`, `speculative-decoding.md`) já presente no vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/diffusion-language-models]]
- [[03-RESOURCES/concepts/llm-ml-foundations/speculative-decoding]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-pretraining]]
