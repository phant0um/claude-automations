---
skill: grill-me
version: 1.0
author: Nexus Agent System
source: mattpocock/skills
tags: [pre-implementation, grilling, alignment, challenge, planning]
---

# Skill: Grill Me

## Propósito
Desafiar um plano ou ideia com perguntas duras antes de qualquer implementação. Expõe pressupostos falsos, ambiguidades e riscos ocultos enquanto o custo de mudança ainda é zero.

Adaptado de `/grill-with-docs` (Matt Pocock) para o contexto do vault: funciona com ou sem codebase existente.

---

## Condições de Ativação
Ative esta skill quando:
- `@grill [plano | feature | ideia]` for chamado
- O usuário disser "me questione sobre X", "testa esse plano", "quero ser desafiado"
- `spec` ou `forge` forem acionados sem grilling prévio em feature não-trivial
- A complexidade estimada for >2h de implementação

NÃO ative para: bugs pontuais já bem definidos; tarefas mecânicas sem decisão de design; quando o usuário explicitamente pular ("skip grill").

---

## Modelo por Etapa

| Etapa | Modelo Claude | Justificativa |
|-------|--------------|---------------|
| Leitura de contexto + formulação de perguntas | `claude-sonnet-4-6` | Requer compreensão semântica e julgamento |
| Síntese de respostas + identificação de gaps | `claude-sonnet-4-6` | Raciocínio sobre coerência e completude |
| Atualização de CONTEXT.md (se existir) | `claude-haiku-4-5` | Edição mecânica estruturada |

---

## Protocolo de Execução

### ETAPA 1 — Leitura de Contexto *(Sonnet)*
Antes de grillar, colete:

```
- Qual é o objetivo final? (não a feature — o resultado de negócio)
- Quem usa isso e em qual situação?
- O que já existe que resolve parte disso?
- Há CONTEXT.md, ADRs ou docs relevantes? Leia-os.
```

Se não houver contexto suficiente: faça 1-2 perguntas de bootstrap antes de avançar.

### ETAPA 2 — Formulação de Perguntas Duras *(Sonnet)*
Gere 5-8 perguntas nas categorias abaixo. Priorize as que o usuário provavelmente NÃO pensou.

**Categorias obrigatórias:**

| Categoria | Exemplo de pergunta |
|-----------|-------------------|
| Pressupostos | "Você assumiu X — o que acontece se X for falso?" |
| Casos extremos | "Como se comporta quando Y = zero / vazio / máximo?" |
| Conflito com existente | "Isso contradiz [decisão anterior Z] — é intencional?" |
| Critério de sucesso | "Como você saberá que funcionou? Qual métrica?" |
| Custo oculto | "Quem mantém isso daqui a 6 meses?" |
| Alternativa mais simples | "Por que não [solução mais simples]?" |
| Reversibilidade | "Se der errado, como desfaz?" |

**Tom:** direto, sem suavização. Não é sessão de brainstorm — é teste de pressão.

Output:
```
GRILLING SESSION — [título do plano]

1. [pergunta]
2. [pergunta]
...
```

### ETAPA 3 — Ciclo de Resposta *(iterativo)*
```
- Usuário responde cada pergunta
- Para cada resposta: identifique se resolve o ponto ou expõe novo gap
- Se novo gap: adicione 1-2 perguntas de follow-up
- Repita até: todas as perguntas respondidas satisfatoriamente OU usuário encerrar
```

### ETAPA 4 — Síntese *(Sonnet)*
Após ciclo completo, produza:

```markdown
## Síntese do Grilling — [título]

### Pressupostos confirmados
- [lista]

### Riscos identificados
- [risco]: [mitigação acordada | ABERTO]

### Decisões tomadas
- [decisão]

### Próximo passo recomendado
[spec | forge | pesquisa adicional | descartar]
```

### ETAPA 5 — Atualizar CONTEXT.md *(Haiku, opcional)*
Se existir `CONTEXT.md` no projeto:
- Adicione termos de domínio que emergiram no grilling
- Registre decisões como ADR inline:
  ```
  ## ADR-<n>: [título]
  **Contexto:** [problema]
  **Decisão:** [o que foi decidido]
  **Consequências:** [trade-offs]
  ```

Se não existir `CONTEXT.md` e >3 termos de domínio emergiram: proponha criação.

---

## Regras de Ouro

- **Não suavize perguntas** — "Você considerou que X pode falhar completamente?" não vira "Talvez valha pensar em X?"
- **Não aceite "vai funcionar"** — exija raciocínio específico
- **Máximo 8 perguntas por rodada** — qualidade > quantidade
- **Se o plano não sobreviver ao grilling**: é um sucesso, não falha — encontrou o problema barato

---

## Artefatos de Saída
- Síntese estruturada com riscos e decisões
- CONTEXT.md atualizado (se existente)
- Recomendação de próximo passo
