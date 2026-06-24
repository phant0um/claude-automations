---
title: Diffusion Language Models
type: concept
created: 2026-06-22
updated: 2026-06-22
tags: [concept, llm-ml-foundations]
---

# Diffusion Language Models

Modelos de linguagem que geram texto refinando iterativamente uma versão "ruidosa" (mascarada) da frase inteira em paralelo, em vez de gerar token a token da esquerda para a direita (autorregressivo).

## Definição

Um DLM aprende a fazer o caminho inverso de um processo de mascaramento progressivo: parte de uma sequência totalmente mascarada (`[?] [?] [?] ...`) e, a cada rodada, adivinha todas as posições simultaneamente, mantém as previsões mais confiantes e remascara as incertas, repetindo até não restar nenhuma máscara.

## Mecanismo

- **Forward phase (treino apenas)**: mascarar palavras de uma frase limpa progressivamente até ficar 100% mascarada — processo trivial, não exige inteligência.
- **Reverse phase (o que o modelo aprende)**: prever as palavras mascaradas a partir do contexto parcial, repetidamente, até a frase ficar completa.
- **Geração**: começa de ruído puro (tudo mascarado) → adivinha tudo em paralelo numa passada → mantém confiantes, remascara incertas → repete com mais contexto disponível → para quando não há mais máscaras.

## Por que importa

- **Paralelismo estrutural**: corrige múltiplas posições por rodada, ao contrário do autorregressivo que é estritamente sequencial (token N+1 depende de token N já emitido) — ganho potencial de velocidade não-incremental.
- A ideia é transposta de diffusion de imagem (ruído de pixel → ruído de máscara de palavra) — a adaptação central é redefinir "ruído" para um domínio discreto (texto não tem "meio token").

## Evidências

- **[2026-06-22]** Mecanismo forward/reverse e exemplo de geração passo a passo (mantém confiantes, remascara incertas) explicado em detalhe didático — [[03-RESOURCES/sources/how-do-diffusion-language-models-dlms-work]]
- **[2026-06-22]** RL sobre dLLMs sofre 2 desalinhamentos: reward esparso terminal aplicado a todos os passos intermediários, e updates em estados sintéticos fora da trajetória real — PAPO resolve com Step-Aware Process Rewards (reward denso via one-step denoising) + Entropy-Guided Historical Re-enactment (reusa trajetória autêntica, prioriza passos de maior entropia) — [[03-RESOURCES/sources/back-on-track-aligning-rewards-and-states-for-reasoning-in-diffusion-large-language-models]]
- **[2026-06-22]** DiffusionGemma (Google) gera em blocos de 256 tokens com atenção bidirecional (autocorreção intra-bloco real) mas, ao commitar um bloco no KV cache pra abrir o próximo, não pode mais revisá-lo — "não revisa bloco commitado", não "não se autocorrige"; trade-off lossy vs Gemma 4 autorregressivo, vantagem de velocidade só em batch baixo (~1-8) — [[03-RESOURCES/sources/google-built-a-faster-ai-by-making-it-worse-when-is-that-a-good-trade]]

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/speculative-decoding]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-pretraining]]
- [[03-RESOURCES/sources/how-do-diffusion-language-models-dlms-work]]
