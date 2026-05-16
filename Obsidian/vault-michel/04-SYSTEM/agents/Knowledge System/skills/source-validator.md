---
name: source-validator
type: skill
version: 1.0.0
used-by:
  - farol
  - bussola
---

# Source Validator

Skill de validação de fontes e nível de confiança. Aplicada automaticamente por Farol e Bússola em toda resposta que contenha dados factuais.

## Escala de confiança

| Marcador | Significado | Quando usar |
|----------|-------------|-------------|
| ✅ Verificado | Fonte primária conhecida e confiável | Paper publicado, dado oficial de governo, empresa, relatório verificável |
| ⚠️ VERIFICAR | Razoável e plausível, mas não verificado na sessão | Estatísticas citadas de memória, estimativas de mercado, dados de 2+ anos atrás |
| ❌ Não confirmado | Claim sem base verificável identificada | Afirmações anedóticas, "dizem que...", dados sem origem clara |

## Regra fundamental

Nunca apresentar dado como fato sem indicar nível de confiança.

Para dados numéricos: citar fonte ou marcar ⚠️ com sugestão de onde verificar.

## Aplicação em texto

Inline, imediatamente após o dado:

> O mercado de IA generativa deve atingir $200 bilhões até 2030 ⚠️ — verificar em Gartner, McKinsey Global Institute ou Grand View Research.

> O Brasil tem 215 milhões de habitantes ✅ — IBGE Censo 2022.

> Estudos mostram que revisão espaçada é 3x mais eficaz ⚠️ — verificar em literatura de ciência cognitiva (Ebbinghaus, Kornell & Bjork 2008).

## Para dados históricos

Se o dado tem mais de 2 anos, marcar ⚠️ mesmo que a fonte original fosse ✅, indicando que pode estar desatualizado.

## Formato para fontes recomendadas

Quando sugerindo onde verificar, ser específico:
- Não: "verifique na internet"
- Sim: "verificar em Statista, IBGE, ou relatório anual da McKinsey sobre [tema]"
