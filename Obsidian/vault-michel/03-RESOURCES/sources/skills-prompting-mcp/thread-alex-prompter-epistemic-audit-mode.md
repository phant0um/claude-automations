---
title: "Thread @alex_prompter: Epistemic Audit Mode — 7 Prompts"
type: source
category: prompting
author: "@alex_prompter"
source: "https://threadreaderapp.com/thread/2056378313426509908.html"
published: 2026-05-18
ingested: 2026-05-18
hash: 8875ddcbdaed8f91eb3ed51ad9eb8755
tags:
  - prompting
  - epistemic
  - decision-making
  - reasoning
  - claude
triagem_score: 7
---

# Thread @alex_prompter: Epistemic Audit Mode — 7 Prompts

## Tese central

"Epistemic Audit Mode" é um nome marketeiro para uma sequência de 7 prompts encadeados que força o modelo a auditar a qualidade do raciocínio do usuário — decompondo afirmações, avaliando evidências, escavando suposições, mapeando incertezas, identificando pontos cegos e construindo um contra-argumento steel-man — antes de gerar um Executive Brief de confiança epistêmica.

## Key insights

1. **Claim Decomposer** — quebra o argumento em afirmações individuais (empírica / lógica / suposição / julgamento de valor) sem avaliar ainda.
2. **Source Confidence Rater** — para cada afirmação empírica: fonte, recência, escopo, risco de cherry-picking. Rating: STRONG / MODERATE / WEAK / UNSUPPORTED.
3. **Assumption Excavator** — foca nas suposições; pergunta o que mudaria se cada uma fosse falsa; identifica "load-bearing assumptions".
4. **Uncertainty Mapper** — tabela com confidence score (0–100%) para cada afirmação; destaca as 3 mais fracas (vulnerabilidades do raciocínio).
5. **Blind Spot Scanner** — lista o que o usuário *não* está considerando: perguntas, dados, partes interessadas, consequências de segunda ordem, precedentes históricos.
6. **Steel Man Stress Test** — constrói o melhor argumento contrário usando as fraquezas detectadas; pontua o dano (1–10) ao argumento original.
7. **Epistemic Summary Brief** — consolida tudo: confiança geral (%), 3 afirmações fortes, 3 fracas, suposições críticas, pontos cegos, próximos passos de pesquisa.

## Observação de uso

A sequência é deliberadamente multi-turn: cada prompt usa o output do anterior. Funciona como [[03-RESOURCES/concepts/prompt-chaining]] aplicado à meta-cognição.

## Links

- Conceitos relacionados: [[03-RESOURCES/concepts/llm-ml-foundations/bayesian-reasoning]], [[03-RESOURCES/concepts/claude-code-tooling/anatomy-claude-prompt]], [[03-RESOURCES/concepts/learning-cognition/adaptive-thinking]]
- Entidade: [[03-RESOURCES/entities/Claude Code]]

---

## Por que "Epistemic Audit Mode" é necessário

A maioria das pessoas usa LLMs para **construir** argumentos — pede ao modelo que encontre evidências, elabore um raciocínio, produza um texto persuasivo. Isso é o uso do modelo como máquina de retórica: eficaz para comunicação, perigoso para decisão.

O Epistemic Audit Mode inverte o uso: o modelo é usado para **desconstruir** o argumento do próprio usuário. Isso combate o principal problema de usar IA para raciocinar: confirmation bias amplificado. Um modelo treinado por RLHF tende a concordar com o usuário — "Epistemic Audit Mode" força comportamento contrário explicitamente.

## Template de cada prompt da sequência

### Prompt 1 — Claim Decomposer

```
Aja como um filósofo analítico. Decomponha este argumento em afirmações individuais.
Para cada afirmação, classifique: [empírica | lógica | suposição | julgamento de valor].
NÃO avalie a validade agora — apenas mapeie a estrutura.

Argumento: [argumento do usuário]
```

**Por que funciona**: separar tipos de afirmação revela onde o argumento é mais vulnerável. Suposições e julgamentos de valor são os pontos fracos — o usuário frequentemente os trata como fatos.

### Prompt 2 — Source Confidence Rater

```
Para cada afirmação EMPÍRICA do output anterior:
- Qual seria a fonte ideal?
- Essa fonte existe? É recente? Tem escopo adequado?
- Há risco de cherry-picking?
Rating: STRONG / MODERATE / WEAK / UNSUPPORTED
```

**Por que funciona**: afirmações empíricas sem fonte verificável são vulnerabilidades reais. Expor isso antes de tomar decisão baseada nelas é crucial.

### Prompt 3 — Assumption Excavator

```
Foque nas SUPOSIÇÕES do output do Prompt 1.
Para cada suposição: o que muda se ela for falsa?
Identifique "load-bearing assumptions" — suposições cuja falsidade colapsaria o argumento inteiro.
```

**Por que funciona**: argumentos frequentemente dependem de 1-2 suposições que nunca foram questionadas. Identificar as "load-bearing" permite ao usuário decidir onde investigar primeiro.

### Prompt 4 — Uncertainty Mapper

```
Construa uma tabela com:
| Afirmação | Confidence Score (0-100%) | Justificativa |

Destaque as 3 afirmações com menor confidence — são as vulnerabilidades do raciocínio.
```

**Por que funciona**: forçar scores numéricos de confiança evita a ilusão de que o argumento é mais sólido do que é. "Tenho certeza que X" e "X: 65% de confiança" têm implicações de decisão muito diferentes.

### Prompt 5 — Blind Spot Scanner

```
O que NÃO está sendo considerado? Liste:
- Perguntas que deveriam ter sido feitas mas não foram
- Dados ausentes que seriam relevantes
- Stakeholders ignorados
- Consequências de segunda ordem
- Precedentes históricos relevantes
```

**Por que funciona**: raciocínio humano é limitado pelo que está saliente. Um modelo com acesso a mais padrões de conhecimento pode identificar blind spots que o usuário genuinamente não considerou.

### Prompt 6 — Steel Man Stress Test

```
Use as fraquezas identificadas nos prompts anteriores para construir o MELHOR argumento contrário possível.
NÃO um straw man — o argumento mais forte que um adversário inteligente e bem-informado poderia fazer.
Pontue: o argumento contrário danifica o original em (1-10)? Por quê?
```

**Por que funciona**: o steel man força o usuário a confrontar a melhor versão do argumento contrário, não a mais fácil de refutar. Se o score de dano for alto, o argumento original precisa ser revisado.

### Prompt 7 — Epistemic Summary Brief

```
Consolide tudo em um Executive Brief com:
- Confiança geral: X%
- 3 afirmações mais sólidas (com justificativa)
- 3 afirmações mais fracas (com justificativa)
- Suposições críticas (load-bearing)
- Principais blind spots
- Próximos 3 passos de pesquisa para fortalecer o argumento
```

**Por que funciona**: o brief é o entregável — o produto final da auditoria epistêmica. Fornece um mapa de onde investir esforço antes de tomar a decisão ou comunicar o argumento.

## Casos de uso práticos

- **Decisão de negócio**: antes de apresentar um business case a stakeholders
- **Tese de investimento**: antes de alocar capital com base em um raciocínio
- **Argumento de pesquisa**: antes de submeter um paper ou relatório técnico
- **Estratégia de produto**: antes de commitar recursos para uma direção
- **Debate interno**: preparar-se para apresentar uma posição contro stakeholders céticos

## Limitações

- A sequência é **lenta**: 7 prompts encadeados levam 20-40 minutos para completar
- O modelo pode não ter acesso a dados atuais para avaliar fontes empíricas com precisão
- **Gamificável**: se o usuário sabe que quer manter uma decisão, pode inconscientemente formular prompts que produzem respostas favoráveis
- Não substitui revisão por pares de domínio especializado — é uma triagem, não uma validação definitiva

## Aplicação no vault

Para decisões de arquitetura do vault (por exemplo: reestruturar `03-RESOURCES/`, migrar para novo sistema de agentes, mudar CLAUDE.md), rodar o Epistemic Audit Mode antes de implementar:

1. **Claim Decomposer**: decompor a razão para a mudança
2. **Assumption Excavator**: identificar suposições sobre o benefício esperado
3. **Steel Man**: construir o argumento para manter o sistema atual
4. Só então implementar se o score de dano do steel man for <6

## Referências adicionais

- [[03-RESOURCES/concepts/llm-ml-foundations/bayesian-reasoning]] — fundamento probabilístico dos confidence scores
- [[03-RESOURCES/concepts/prompt-chaining]] — técnica de prompts encadeados
- [[03-RESOURCES/sources/claude-code-skills/skill-grill-me]] — skill relacionada: entrevista socrática de planos
