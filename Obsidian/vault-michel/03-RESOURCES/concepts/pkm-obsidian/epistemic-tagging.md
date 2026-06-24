---
title: Epistemic Tagging
type: concept
status: developing
created: 2026-05-24
updated: 2026-05-24
tags: [pkm, epistemology, second-brain, pm-brain-os, anti-landfill]
---

# Epistemic Tagging

Marcar claims com seu grau de certeza epistêmica. Previne conflação entre observação direta, interpretação e hipótese especulativa.

Origem: [[03-RESOURCES/sources/pkm-obsidian-second-brain/clipping-pm-brain-os]] (PM Brain OS pattern).

---

## Tags

| Tag | Significa | Uso |
|-----|-----------|-----|
| `[obs]` | Observação direta, dado verificável | Fatos, métricas, comportamentos documentados |
| `[interp]` | Interpretação — raciocínio sobre obs | Análise, padrões inferidos, explicações causais |
| `[hyp]` | Hipótese especulativa | Predições, conjecturas, teorias sem teste |

---

## Por Que Importa

Segundo cérebros acumulam lixo epistêmico: hipóteses tratadas como fatos, interpretações sem base observacional. Resultado: decisões baseadas em confiança falsa.

PM Brain OS identifica 5 modos de falha de sistemas de memória:
1. Armazenar tudo sem triagem → landfill
2. Sem diferenciação obs/interp/hyp → confiança falsa
3. Sem expiração → claims obsoletos persistem
4. Sem contradição explícita → versões conflitantes coexistem silenciosamente
5. Sem fronteira entre fonte e síntese → autoria perdida

---

## Aplicação no Vault

**Em concept pages:** Claims com consequência alta recebem tag.

```markdown
- Harness determina 80%+ do output quality. [obs] — Cameron Wolfe benchmark series
- Agents com RL se auto-melhoram em tasks estruturadas. [interp] — Fireworks + Karpathy
- Vault pode rodar sem vector DB em escala de 10K notas. [hyp] — testado até 1.2K
```

**Em sources:** `[obs]` = o que o autor afirma; `[interp]` = minha leitura; `[hyp]` = extrapolação minha.

**Em agent memory:** Nexus e agentes marcam decisões com `[obs]`/`[interp]`/`[hyp]` para que revisões futuras saibam o grau de certeza.

---

## Anti-Padrões

- ❌ "Context engineering é a habilidade mais importante de 2026." — sem tag, parece fato
- ✅ "Context engineering é a habilidade mais importante de 2026. [interp] — minha leitura de Karpathy + TheAhmadOsman"
- ❌ Usar `[obs]` em interpretações (falsa precisão)
- ❌ Não usar nenhuma tag em concept pages (tudo parece certo)

---

## Relação com Outros Sistemas

- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] — base
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — agentes também precisam
- [[04-SYSTEM/vault-identity]] — anti-padrão: hedging desnecessário ≠ tag epistêmica (tag é informação, hedge é ruído)
