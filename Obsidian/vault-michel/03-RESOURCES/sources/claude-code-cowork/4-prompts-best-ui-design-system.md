---
title: "4 prompts that make Claude Code build your best UI (full setup inside)"
type: source
source: "[@Mnilax](https://x.com/Mnilax/status/2065161044587426265)"
created: 2026-06-13
ingested: 2026-06-13
tags: [ai-agents]
---

## Tese central

Cada tela gerada por Claude Code "esquece" decisões de design das telas
anteriores — nova cor, novo radius de card, nova ideia de espaçamento a cada
prompt. Resultado: 10 telas parecem feitas por 10 pessoas diferentes. A peça
que faltava nunca foi skill, foi uma **fonte de verdade**: sem design
system, o modelo gera no nível de pixel porque não tem nada contra o que
referenciar.

## Argumentos principais

- **Solução**: construir um design system (via ferramenta Moonchild —
  tokens + components + guidelines, exportável) e anexá-lo como input antes
  de gerar qualquer tela.
- **Pipeline de 4 prompts**:
  1. Construir o sistema a partir de um brief **específico** (cores, fonte,
     densidade, componentes exatos, guidelines drawer-vs-modal,
     empty/loading states) — não "a dashboard for AI" (genérico = sistema
     genérico = modelo continua adivinhando, um nível acima)
  2. Gerar N telas com o sistema anexado, mantendo nav/cards/charts
     consistentes
  3. Em Claude Code/Cursor: "use only the tokens, components, and spacing
     [do sistema]. do not introduce new colors, radii, or font sizes. if
     something isn't covered, **stop and ask** instead of inventing it."
  4. Regra permanente em nível de projeto: antes de qualquer cor/spacing/
     type novo, checar se o sistema já define — sem isso, uma tela ainda
     dá "drift"

## Key insights

### Resultados medidos (mesmo dashboard, 10 telas, construído 2x)

| Métrica | Sem sistema | Com sistema como input |
|---|---|---|
| Telas on-brand na 1ª geração | 2/10 | 9/10 |
| Tempo de restyle | ~6h | ~40min |
| Cores hex inventadas | 19 | 0 |
| Brand drift | constante | nenhum |

### 3 erros que desperdiçaram a primeira tarde

1. Importar via PNG (perde estrutura — SVG/HTML preservam tokens e
   hierarquia)
2. Brief genérico (move o "adivinhar" um nível para cima, não remove)
3. Pular o sistema numa task isolada (drift volta imediatamente — a regra
   "check before write" é o que torna o sistema *load-bearing*)

### Limites honestos

Output ainda precisa de review (é um forte rascunho, não produto final); o
sistema só é tão bom quanto o brief; disciplina não se autoimpõe — code
review ainda precisa checar uso de tokens vs valores hardcoded.

## Implicações para o vault

A clause **"stop and ask instead of inventing it"** é a mesma lógica do
boundary block de Fable 5 (ver [[03-RESOURCES/sources/claude-code-cowork/how-to-actually-prompt-claude-fable-5]])
e do princípio Karpathy "se ambíguo: state assumption + ask" do CLAUDE.md —
converter o instinto do modelo de "preencher gaps" em "sinalizar gaps".
Para FIAP/MVC (frontend), um design system mínimo (paleta + componentes +
regra "stop and ask") resolveria o mesmo problema de inconsistência entre
telas. Este artigo é o exemplo concreto que abre o cluster geral de 9 fontes
sobre uso avançado de Claude em 2026-06 (design systems, skills, prompting
Fable 5, workflows, model routing, /teach).
