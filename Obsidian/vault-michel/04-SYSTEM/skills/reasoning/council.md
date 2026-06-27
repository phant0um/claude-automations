---
skill: council
version: 1.0
trigger: "council this" | "@council [questão]" | "/council [questão]"
model: claude-sonnet-4-6
tags: [reasoning, decision-making, multi-perspective, peer-review, deliberation]
source: "[[03-RESOURCES/sources/skills-prompting-mcp/claude-council-skill-5-advisors]]"
---

# Skill: Council

## Propósito

5 advisors com perspectivas hard-wired debatem uma questão, revisam uns aos outros de forma cega, e entregam veredicto estruturado. Substitui coordenação de múltiplos modelos por prompt engineering sofisticado em um único contexto.

**Diferença de `/debate`:** debate = 2 posições opostas (A vs B), árbitro decide. Council = 5 lentes distintas cobrindo sistematicamente risco + problema real + upside oculto + praticidade + ação concreta — sem posições predefinidas.

**Diferença de `heavy-think`:** heavy-think = múltiplas trajetórias de raciocínio para resolver *como*. Council = 5 perspectivas humanas para decidir *o quê/se*.

---

## Condições de Ativação

Ative quando:
- Decisão estratégica com múltiplas dimensões (não apenas A vs B)
- Usuário diz "council this" antes de qualquer questão
- Spec arquitetural complexa antes de escalar para Opus
- Decisão de produto/vault onde blind spots são esperados

NÃO ative para: implementações concretas (→ spec/extend); questões técnicas verificáveis (→ heavy-think); segurança (→ guard); A vs B claro (→ debate).

---

## Modelo por Etapa

| Etapa | Modelo | Razão |
|-------|--------|-------|
| Extração de contexto | Haiku | Parsing estruturado |
| 5 advisors (em paralelo) | Sonnet × 5 | Perspectiva + evidência por advisor |
| Blind peer review | Sonnet | Revisão cruzada sem viés de posição |
| Veredicto final | Opus | Síntese de alta complexidade |

---

## Protocolo

### Fase 1 — Contexto *(Haiku)*

Extrair da input:
- **Questão central** (1 frase)
- **Contexto relevante** (o que motivou, restrições ativas, histórico)
- **O que "boa decisão" significa** (critério de sucesso)

### Fase 2 — 5 Advisors em paralelo *(Sonnet × 5 simultâneos)*

Cada advisor responde com sua perspectiva exclusiva. **Executar em paralelo — sequencial contamina.**

| Advisor | Lente | Pergunta guia |
|---------|-------|--------------|
| **A — Risk** | O que pode falhar? | Quais os 3 modos de falha mais prováveis? O que não estamos vendo? |
| **B — Problem** | Qual o problema real? | Estamos resolvendo o problema certo? Qual problema subjacente estamos ignorando? |
| **C — Upside** | Qual upside estamos perdendo? | Qual oportunidade não óbvia está aqui? O que a decisão conservadora sacrifica? |
| **D — Pragmatics** | O que faz sentido segunda de manhã? | Que constrangimentos reais (tempo, energia, complexidade) este plano ignora? |
| **E — Action** | O que você realmente faria? | Se fosse sua decisão pessoal, com suas consequências: o que faria agora? |

Instrução para cada advisor:
```
Você é o Advisor [X] do Council.
Questão: [questão]
Contexto: [contexto]

Responda exclusivamente da sua perspectiva ([lente]).
Formato:
1. Resposta principal (2-4 parágrafos)
2. Blind spot mais importante da questão (1 parágrafo)
3. Recomendação concreta (1 frase de ação)

NÃO seja diplomático. Diga o que você vê.
```

### Fase 3 — Blind Peer Review *(Sonnet)*

1. Coletar todas as 5 respostas
2. **Anonimizar + shuffle** (chamar de "Advisor Alpha/Beta/Gamma/Delta/Epsilon" em ordem aleatória)
3. Cada advisor recebe as 5 respostas anonimizadas e responde:
   - "Qual resposta é mais forte e por quê?"
   - "Qual tem o maior blind spot?"
   - "O que todos os 5 perderam?"

Executar os 5 peer reviews em paralelo.

### Fase 4 — Veredicto Final *(Opus)*

Instrução:
```
Você recebe 5 perspectivas sobre uma questão + 5 peer reviews cruzados.
Questão: [questão]
Critério de sucesso: [critério]

SUA TAREFA:
1. Melhor recomendação — qual ação tomar e por quê
2. Maior blind spot coletivo — o que todos os 5 perderam
3. Tensão central — qual é o trade-off irresolvível nessa decisão
4. Próximo passo concreto — 1 ação específica para amanhã
5. Condição de revisão — quando reconsiderar este veredicto

PROIBIDO: veredicto vago. Cada item deve ser específico ao contexto dado.
```

### Fase 5 — Output

```
COUNCIL: [Questão]

━━━ ADVISORS ━━━
Risk:      [resumo 1 linha]
Problem:   [resumo 1 linha]
Upside:    [resumo 1 linha]
Pragmatics:[resumo 1 linha]
Action:    [resumo 1 linha]

━━━ PEER REVIEW ━━━
Resposta mais forte: [qual e por quê — 1 linha]
Maior blind spot individual: [qual e por quê — 1 linha]
O que todos perderam: [1-2 linhas]

━━━ VEREDICTO ━━━
Recomendação: [ação concreta]
Blind spot coletivo: [o que ninguém viu]
Tensão central: [trade-off irresolvível]
Próximo passo: [1 ação específica]
Condição de revisão: [quando mudar de ideia]
```

---

## Completion

- [ ] 5 advisors executados em paralelo (não sequência)
- [ ] Shuffle + anonimização aplicados no peer review
- [ ] Veredito sintetizado com contribuição de cada lente
- [ ] Se questão tem resposta técnica verificável: não usado (usar heavy-think)

## Failure modes

- **Sequential advisors**: rodar 5 advisors em sequência → paralelo obrigatório, sequencial contamina
- **Skip anonymization**: pular shuffle + anonimização → viés de posição invalida peer review
- **Haiku for advisors**: usar Haiku para perspectivas → perspectivas requerem raciocínio real (Sonnet+)
- **Verifiable answer**: usar council para questão com resposta técnica → usar heavy-think

---

## Restrições## Restrições

- NUNCA executar advisors em sequência — paralelo obrigatório (sequencial contamina perspectivas)
- NUNCA pular o shuffle + anonimização no peer review — viés de posição invalida a revisão cruzada
- NUNCA usar Haiku para advisors — perspectivas requerem raciocínio real
- Se a questão tiver resposta técnica verificável: não usar council, usar heavy-think

---

## Relacionado

- [[04-SYSTEM/skills/reasoning/debate]] — 2 perspectivas opostas; council = 5 lentes não-opostas
- [[04-SYSTEM/skills/reasoning/heavy-think]] — múltiplas trajetórias de solução; council = perspectivas humanas de decisão
- [[04-SYSTEM/skills/reasoning/pre-mortem]] — analisa riscos de plano já escolhido; council escolhe qual plano adotar
