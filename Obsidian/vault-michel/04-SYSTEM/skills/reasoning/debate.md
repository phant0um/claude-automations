---
skill: debate
version: 1.0
trigger: "@debate [questão]" | "/debate [questão]"
model: claude-sonnet-4-6
tags: [reasoning, deliberation, architecture, decisions, two-perspective]
---

# Skill: Debate

## Propósito

Deliberação formal entre duas perspectivas opostas para decisões arquiteturais ou de design onde a resposta certa não é óbvia. Produz confronto estruturado + arbitragem — não síntese suave.

**Diferença de heavy-think:**
- `heavy-think` = múltiplas trajetórias paralelas sobre *como* resolver um problema bem definido
- `debate` = duas posições opostas sobre *qual* escolha tomar quando há trade-off real

Usar `debate` quando a questão for "A vs B?" — usar `heavy-think` quando for "como resolver X?".

---

## Condições de Ativação

Ative quando:
- Decisão arquitetural do vault com trade-off real (não preferência óbvia)
- Usuário indeciso entre dois designs/abordagens
- Agente propõe mudança significativa e você quer confronto antes de aceitar
- `@debate [questão com vs / ou]`

NÃO ative para: questões factuais verificáveis; tarefas de implementação; decisões já tomadas e irreversíveis; preferências estéticas sem impacto arquitetural.

---

## Modelo por Etapa

| Etapa | Modelo | Razão |
|-------|--------|-------|
| Extração da questão e contexto | Haiku | Parsing estruturado |
| Perspectiva A | Sonnet | Argumentação com evidência |
| Perspectiva B | Sonnet | Argumentação com evidência |
| Arbitragem | Opus | Julgamento integrado de trade-offs |

---

## Protocolo

### 1. Extrair Questão *(Haiku)*

Da input do usuário, extrair:
- **Questão central:** "A vs B?" em uma frase
- **Contexto:** o que motivou essa decisão agora
- **Restrições ativas:** princípios do vault, recursos, prazo
- **Critério de sucesso:** o que "melhor escolha" significa aqui

Se a questão for ambígua: reformular como "Perspectiva A: [posição] / Perspectiva B: [posição oposta]" e confirmar com usuário antes de continuar.

### 2. Perspectiva A *(Sonnet — sem ver Perspectiva B)*

Instrução:
```
Você defende a Perspectiva A: [posição].
Contexto: [contexto extraído]
Restrições: [restrições ativas]

Sua tarefa:
1. Argumento principal (1 parágrafo — por que A é superior a B nesse contexto)
2. Evidência concreta (exemplos, dados, precedentes no próprio vault)
3. Fraqueza reconhecida de A (1 frase — onde B tem vantagem real)
4. Por que essa fraqueza não é decisiva (1 frase)

NÃO seja suave. NÃO conceda além do mínimo. Ganhe o argumento.
```

### 3. Perspectiva B *(Sonnet — sem ver Perspectiva A)*

Mesma estrutura, posição oposta. Executar em paralelo com Perspectiva A.

### 4. Arbitragem *(Opus)*

Instrução:
```
Você recebe dois argumentos opostos sobre a mesma decisão.
Contexto: [contexto]
Restrições: [restrições]

Perspectiva A: [output do Passo 2]
Perspectiva B: [output do Passo 3]

Sua tarefa:
1. Identifique o argumento mais forte de cada perspectiva
2. Identifique o ponto cego de cada perspectiva
3. Verifique: há premissas falsas em alguma das perspectivas?
4. Emita veredicto: qual perspectiva vence neste contexto específico?
5. Condição de revisão: em que circunstância o veredicto mudaria?

PROIBIDO: veredicto "depende" sem especificar o que depende.
PROIBIDO: recomendar "um meio-termo" sem justificar que é superior a ambas.
```

### 5. Output

Formato final para o usuário:

```
DEBATE: [Questão]

─── PERSPECTIVA A: [posição] ───
[argumento, evidência, fraqueza reconhecida]

─── PERSPECTIVA B: [posição] ───
[argumento, evidência, fraqueza reconhecida]

─── ÁRBITRO ───
Argumento mais forte de A: [...]
Argumento mais forte de B: [...]
Ponto cego de A: [...]
Ponto cego de B: [...]

VEREDICTO: [A/B] — porque [razão específica ao contexto]
Condição de revisão: [quando mudar de ideia]
```

---

## Restrições

- NUNCA executar Perspectivas A e B em sequência — paralelo obrigatório (sequencial contamina)
- NUNCA deixar o árbitro emitir "depende" sem especificar a condição
- NUNCA recomendar meio-termo como saída padrão — debate tem vencedor
- Se ambas as perspectivas concordarem no fundo: não há debate real — reportar e usar heavy-think

---

## Relacionado

- [[04-SYSTEM/skills/reasoning/heavy-think]] — multi-trajetória para resolver um problema (não escolher entre opções)
- [[04-SYSTEM/skills/reasoning/pre-mortem]] — analisa riscos de falha de um plano já escolhido
- [[04-SYSTEM/agents/core/guard]] — usa adversarial mode similar (attacker + defender + auditor)
