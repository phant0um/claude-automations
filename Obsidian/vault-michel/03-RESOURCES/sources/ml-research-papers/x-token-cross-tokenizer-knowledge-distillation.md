---
title: "X-Token: Projection-Guided Cross-Tokenizer Knowledge Distillation"
type: source
category: ml-research-papers
created: 2026-05-29
ingested: 2026-05-29
grade: B
authors:
  - Sharath Turuvekere Sreenivas
  - Adithyakrishna Venkatesh Hanasoge
  - Mingyu Yang
  - Ali Taghibakhshi
  - Saurav Muralidharan
  - Ashwath Aithal
  - Pavlo Molchanov
institution: NVIDIA / Stanford
arxiv: "2605.21699"
tags:
  - ai-agents
  - llm
  - knowledge-distillation
  - research
  - cross-tokenizer
  - distillation-losses
---

## Tese Central

Cross-tokenizer knowledge distillation falha por dois motivos estruturais — gradientes errôneos em tokens críticos não mapeados e matching excessivamente conservador — e ambos podem ser corrigidos com uma única matriz de projeção esparsa W combinada com duas formulações de perda complementares (P-KL e H-KL) que se selecionam via auditoria de cobertura.

## Argumentos Principais

1. **Failure mode 1 — Uncommon-token failure:** Quando tokenizadores fragmentam diferente (ex.: Qwen3 divide numerais multi-dígito, Llama não), tokens críticos caem no subconjunto "uncommon". O GOLD [1] aplica rank-matching cego nesses tokens, produzindo gradientes identidade-agnósticos; além disso, o termo common-KL suprime passivamente todos os logits uncommon via softmax global (Proposição 1 provada formalmente no appendix). Resultado: GSM8k cai de 12,89 para 2,56 — abaixo do baseline sem distilação.

2. **Failure mode 2 — Over-conservative matching:** O GOLD usa string-equality estrita para definir o conjunto common, excluindo pares quase-equivalentes como (`Hundreds`, `Hund`) que W detecta via re-tokenização do teacher.

3. **P-KL resolve o failure mode 1:** Remove a partição completamente; projeta a distribuição do student para o espaço do teacher via W, alinhando diretamente toda a massa de probabilidade — incluindo tokens uncommon como `201` → `{2, 0, 1}`. Melhora +3,82 avg sobre GOLD com Qwen3-4B.

4. **H-KL resolve o failure mode 2:** Mantém a estrutura híbrida (útil quando a partição é sólida), mas relaxa o matching de string-equality para top-1 sob W. Melhora +0,5 avg sobre GOLD com Phi-4-mini.

5. **Seleção P-KL vs H-KL via cobertura:** Uma auditoria simples de categorias de tokens (dígitos, pontuação, ASCII) determina qual loss usar: se tokens críticos (ex.: numerais multi-dígito) caem fora do common set → P-KL; caso contrário → H-KL.

6. **Multi-teacher distillation:** X-Token generaliza naturalmente para múltiplos teachers com diferentes tokenizadores. Complementaridade é a chave — Phi-mini (raciocínio matemático) + Llama-3B (conhecimento geral) = +1,3 sobre single-teacher. Pesos estáticos superam esquemas adaptativos.

## Key Insights

- **A partição é o problema central:** ULD (sem partição, rank-based) já supera GOLD (38,85 > 35,03) no regime Qwen, isolando a partição como causa primária do fracasso — não o matching em si.
- **W é treinável:** Inicializado por regras determinísticas (canonicalização + re-tokenização), W pode ser refinado junto com o student durante P-KL com ganhos modestos mas consistentes (38,85 vs 38,37 avg). H-KL usa W apenas para arg max, sem gradiente.
- **DP span alignment vs TRL surface-substring:** TRL falha quando tokenizadores têm BOS assimétrico (Llama adiciona `<bos>`, Qwen não) — o flush nunca dispara, criando um super-grupo inválido. DP via programação dinâmica detecta o gap com custo unitário e alinha o restante corretamente.
- **Dynamic KD/CE scaling:** Reescala o termo KD a cada step para igualar a escala do CE loss, evitando instabilidade de otimização sem tuning manual de λ.
- **Teacher complementarity > adaptive weighting:** Pesos estáticos Phi-heavy (0,2 Llama / 0,8 Phi) superam CE-adaptive, entropy-adaptive e max-prob-adaptive em ambos os setups testados.

## Exemplos e Evidências

### Benchmark Principal — Llama-3.2-1B student, 3-shot

| Setup | Método | MMLU | GSM8k | MATH | WG | HS | Avg. |
|-------|--------|------|-------|------|----|----|------|
| No distilação | Llama-1B base | 32,05 | 5,69 | 5,48 | 61,48 | 65,08 | 33,96 |
| No distilação | Continued pre-training | 40,50 | 10,25 | 6,90 | 61,60 | 63,90 | 36,63 |
| Same tokenizer | Llama-3B → 1B (KD) | 43,83 | 12,89 | 8,16 | 62,70 | 64,42 | 38,40 |
| Cross-tokenizer | Qwen-4B, GOLD | 42,56 | 2,56 | 4,50 | 62,95 | 62,59 | 35,03 |
| Cross-tokenizer | **Qwen-4B, X-Token (P-KL)** | **44,67** | **15,54** | **7,96** | **63,46** | **62,63** | **38,85** |
| Cross-tokenizer | Phi-mini, GOLD | 43,50 | 16,50 | 7,80 | 62,60 | 62,92 | 38,66 |
| Cross-tokenizer | **Phi-mini, X-Token (H-KL)** | **43,93** | **19,11** | **8,32** | 61,87 | 62,67 | **39,18** |
| Multi-teacher | **Phi-mini + Llama-3B (X-Token)** | **46,32** | **20,39** | **9,02** | 63,30 | 63,38 | **40,48** |

Ganhos chave:
- **+3,82 avg** (X-Token P-KL vs GOLD, Qwen-4B)
- **6× GSM8k** com Qwen (2,56 → 15,54) — superando mesmo KD same-family (12,89)
- **+0,52 avg** (X-Token H-KL vs GOLD, Phi-4-mini)
- **+1,3 avg** (multi-teacher sobre melhor single-teacher cross-tokenizer)

### Cobertura por categoria (Qwen vs Phi)

| Categoria Llama | Qwen common | Phi-4 common |
|----------------|-------------|--------------|
| 1-digit numerals | 13/13 (100%) | 13/13 (100%) |
| 2-digit numerals | **0/100 (0%)** | 100/100 (100%) |
| 3-digit numerals | **0/1000 (0%)** | 1000/1000 (100%) |
| ASCII punctuation | 88/88 (100%) | 88/88 (100%) |

Explica por que P-KL é necessário para Qwen e H-KL é suficiente para Phi.

### P-KL vs H-KL trocam de posição entre teachers

| Teacher | P-KL avg | H-KL avg |
|---------|----------|----------|
| Qwen-4B | **38,85** | 35,30 |
| Phi-mini | 37,50 | **39,18** |

Nenhum modo domina universalmente — a seleção correta é condicionada à estrutura do tokenizador.

## Implicações para o Vault

- Relevante para [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] — X-Token é uma técnica de continued pre-training cross-family.
- Conecta com [[03-RESOURCES/concepts/llm-ml-foundations/weak-to-strong-generalization]] — destilação de modelos maiores para menores com vocabulários distintos.
- Potencial prático: permite usar Qwen3 ou Phi-4 como teachers para estudantes Llama sem restrições de tokenizador.
- A prova formal de gradientes supressivos (Proposição 1) é um resultado teórico limpo que pode enriquecer [[03-RESOURCES/concepts/llm-ml-foundations/rl-training-llms]].
- DP span alignment é uma contribuição de engenharia independente — corrige falha documentada no TRL Gold trainer.

## Links

- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]]
- [[03-RESOURCES/concepts/llm-ml-foundations/weak-to-strong-generalization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/rl-training-llms]]
- [[03-RESOURCES/sources/ml-research-papers/nemotron-3-super-hybrid-mamba-attention-moe]]

**arXiv:** https://arxiv.org/abs/2605.21699
