---
name: tooling-eval
description: "Gera nota padronizada de ferramenta-candidata: encaixe no vault, overlap c/ existente, check de segurança (fork/supply-chain), checklist de adoção humana. Use ao avaliar adotar tool/MCP/skill externa."
skill: tooling-eval
version: 1.0
trigger: "@tooling-eval [tool] · 'avaliar ferramenta' · 'vale adotar X?'"
model: claude-haiku-4-5
tags: [tooling, eval, scout, security, adoption]
attach: scout
---

# Skill: tooling-eval

## Propósito
Molde único p/ avaliar ferramenta candidata. Evita notas ad-hoc divergentes.

## Saída (nota em 04-SYSTEM/wiki/tooling-<nome>.md)
```yaml
title, type: tooling-eval, status: candidata, source, created
```
Seções fixas:
1. **O quê** — 1 linha do que é.
2. **Encaixe** — qual dor do vault resolve, qual agente/rotina consome.
3. **Overlap** — o que já existe que cobre parte disso (honesto).
4. **Check de segurança** — fonte oficial confirmada? supply-chain/fork malicioso?
   permissões pedidas? roda local ou manda dados fora?
5. **Antes de adotar (decisão humana)** — checklist `[ ]`.

## Regra
NUNCA instalar/adotar autonomamente. Skill só PRODUZ a nota. Adoção = humano.