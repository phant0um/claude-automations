---
title: "Applying Statistics to LLM Evaluations"
type: source
source: Clippings/Applying Statistics to LLM Evaluations.md
source_type: clipping
created: 2026-05-19
ingested: 2026-05-19
triagem_score: 8
triagem_cat: ai-agents/eval
tags: [ai-agents, clipping, ml-research]
---

## Tese central

Avaliação de LLMs sem rigor estatístico produz conclusões falsas. Bootstrap CI, teste de McNemar, e power analysis são ferramentas mínimas para comparar modelos e detectar regressões com confiança real — não intuição.

## Key insights

- **Bootstrap CI (Confidence Interval):** amostrar com reposição do conjunto de eval N vezes, calcular métrica em cada amostra, usar distribuição empírica para CI. Não assume normalidade — robusto para métricas categóricas e binárias comuns em LLM eval
- **Random Variables and Estimators:** cada exemplo de eval é uma variável aleatória de Bernoulli (acertou/errou) ou contínua. Taxa de acerto é estimador não-viesado da performance real, mas tem variância que precisa ser reportada — nunca reportar ponto único sem intervalo
- **Teste de McNemar:** comparar dois modelos no mesmo conjunto de exemplos. Leva em conta que modelos são correlacionados (mesmo dataset) — paired test correto. Alternativa ao teste de proporções que ignora correlação
- **Power analysis:** antes de construir eval suite, calcular quantos exemplos são necessários para detectar diferença de δ% com potência 80% e α=0.05. Eval pequena demais nunca detecta melhorias reais — tempo desperdiçado

## Fundamentos estatísticos aplicados a evals

### Por que estatística importa em LLM eval

"Modelo A acertou 83%, modelo B acertou 81% — A é melhor."

Errado sem contexto. Com n=100 exemplos, diferença de 2% tem CI de ±4pp — diferença não significativa. Com n=1000, mesma diferença tem CI de ±1.3pp — agora significativa. Sem reportar n e CI, comparação é inútil.

### Random Variables em contexto de LLM

Exemplo de eval = observação de variável aleatória. Fonte de variância:
1. **Variância de sampling:** conjunto de eval é amostra do espaço de tarefas possíveis
2. **Variância de modelo:** temperatura > 0 ou variação em batch size gera outputs diferentes para mesmo input
3. **Variância de judge:** LLM-as-judge não é determinístico

Reportar resultado sem decompor fontes de variância confunde mudança real com ruído.

### Bootstrap CI: implementação

```python
import numpy as np

def bootstrap_ci(scores, n_bootstrap=10000, alpha=0.05):
    boot_means = []
    for _ in range(n_bootstrap):
        sample = np.random.choice(scores, size=len(scores), replace=True)
        boot_means.append(np.mean(sample))
    lower = np.percentile(boot_means, 100 * alpha / 2)
    upper = np.percentile(boot_means, 100 * (1 - alpha / 2))
    return lower, upper
```

Usar em qualquer métrica de eval — não só acurácia. ROUGE, BLEU, taxa de tool use correto, etc.

### Teste de McNemar: quando usar

Quando comparar dois modelos no mesmo conjunto de exemplos:

```
             Modelo B correto  Modelo B errado
Modelo A certo       a                b
Modelo A errado      c                d
```

Estatística: χ² = (b - c)² / (b + c). Só b e c importam — casos onde modelos discordam. p-value baixo = diferença real.

### Power analysis prática

Para detectar diferença de 5pp (0.80 → 0.85) com α=0.05, β=0.20:
- Teste de proporção: n ≈ 350 exemplos por condição
- Teste pareado (McNemar): n ≈ 200 exemplos

Implicação: eval suite com menos de 200 exemplos não tem poder para detectar melhorias típicas de prompt tuning.

## Erros comuns em LLM eval

1. Reportar acurácia sem CI — número sem contexto de confiança
2. Comparar médias sem teste de hipótese — "parece melhor" não é evidência
3. Eval em conjunto contaminado — mesmo conjunto para desenvolvimento e avaliação inflaciona performance
4. Multiple testing sem correção — testar 20 prompts e celebrar o melhor — taxa de falso positivo = 64% sem correção de Bonferroni

## Aplicação a vault-michel

Ao avaliar agentes do vault (qualidade de ingestão, precisão de wikilinks), usar bootstrap CI para comparar versões. Manter eval suite com mínimo 200 exemplos antes de declarar melhoria.

## Conceitos complementares

### Effect size além do p-value

p-value diz se diferença é estatisticamente significativa. Effect size (Cohen's d, odds ratio) diz se diferença é praticamente relevante.

Diferença de 0.5% em acurácia pode ter p < 0.001 com n=10000 — estatisticamente significativa mas praticamente irrelevante para maioria dos casos de uso.

Reportar sempre: p-value + effect size + CI. Os três juntos contam a história completa.

### Calibração vs accuracy

Modelo calibrado: quando diz "70% de confiança", está certo ~70% das vezes.
Modelo não calibrado: diz "99% de confiança" mas erra 20% das vezes — perigoso para sistemas de decisão.

Expected Calibration Error (ECE) é métrica complementar a accuracy para sistemas onde confiança do modelo importa.

### Multiple comparisons em escolha de prompts

Ao testar N variações de prompt e escolher a melhor, aplicar correção de Bonferroni: usar α/N em vez de α para cada teste individual. Sem correção, com N=20 variações e α=0.05, probabilidade de "encontrar" diferença por acaso puro = 1-(0.95)²⁰ = 64%.

Implicação prática: prompt que "venceu" em comparação não-corrigida pode ser falso positivo. Validar melhor prompt em conjunto held-out independente.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]

## Fonte

Arquivo original: `Clippings/Applying Statistics to LLM Evaluations.md`
