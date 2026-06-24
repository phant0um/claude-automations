---
title: "Back on Track: Aligning Rewards and States for Reasoning in Diffusion Large Language Models"
type: source
source: Clippings/Back on Track Aligning Rewards and States for Reasoning in Diffusion Large Language Models.md
created: 2026-06-22
ingested: 2026-06-22
tags: [articles]
---

## Tese central
RL aplicado a diffusion LLMs (dLLMs) sofre de dois desalinhamentos fundamentais: reward esparso/terminal aplicado indiscriminadamente a todos os passos intermediários (process-reward misalignment), e updates de política em estados artificiais fora da trajetória real (state-trajectory misalignment). O paper propõe PAPO (Process Aligned Policy Optimization) para resolver ambos.

## Argumentos principais
- **Step-Aware Process Rewards (SPR)**: converte reward esparso terminal em reward denso por passo, usando uma predição de "one-step denoising" em cada estado intermediário da trajetória de geração.
- **Entropy-Guided Historical Re-enactment (EHR)**: em vez de treinar em estados artificiais (mascaramento aleatório do prompt/completion), reusa a trajetória autêntica de geração e prioriza re-treinar nos passos de maior entropia (maior incerteza do modelo) — onde o gradiente é mais informativo.
- **Resultados**: ganhos de até 4.5% (GSM8K), 4.8% (MATH500), 42.2% (Countdown) e 16.1% (Sudoku) sobre baselines (diffu-GRPO, UniGRPO, SAPO), sem precisar de SFT prévio.
- **Trade-off fidelidade vs eficiência**: lookahead de 1-step no SPR já captura quase todo o ganho; ir a 16-step custa +44% GPU hours por só +1.6% acurácia.

## Key insights
- dLLMs geram via denoising paralelo iterativo (não token-a-token como autoregressive) — isso quebra o cálculo direto de log-likelihood que RL tradicional (GRPO) depende, forçando aproximações (mean-field) que o paper expõe como fonte do desalinhamento.
- O framing geral — "credit assignment denso + reuso de trajetória autêntica em vez de estados sintéticos" — é um padrão reutilizável em qualquer RL multi-step não apenas para dLLMs: a lição central é que estados artificiais de treino frequentemente divergem da distribuição real de inferência (train-inference mismatch).
- Ganhos desproporcionalmente maiores em planning tasks (Countdown +42%, Sudoku +16%) vs math reasoning (+4-5%) sugerem que process-reward denso importa mais quanto mais longo/estruturado é o raciocínio necessário.

## Exemplos e evidências
- Tabelas comparativas em 4 benchmarks (GSM8K, MATH500, Countdown, Sudoku) com múltiplos seq lengths (128/256/512).
- Ablation study isolando contribuição de SPR vs EHR — full PAPO > HR+SPR > HR > baseline.
- Generalização testada cross-backbone (LLaDA-1.5) e cross-domain (HumanEval/MBPP, código).

## Implicações para o vault
- [[03-RESOURCES/concepts/llm-ml-foundations/diffusion-language-models]] cobre o mecanismo forward/reverse de dLLMs mas não a mecânica de RL sobre eles — este paper adiciona a camada de credit assignment (SPR) e reuso de trajetória autêntica (EHR) que falta no concept.
- Relevante como contraste arquitetural: paradigma autoregressive (Claude, GPT) vs paradigma diffusion (LLaDA, Dream) para quem acompanha avanços em LLM architecture.

## Links
- [[03-RESOURCES/concepts/agentic-reinforcement-learning]]
- [[03-RESOURCES/concepts/llm-ml-foundations/diffusion-language-models]]
