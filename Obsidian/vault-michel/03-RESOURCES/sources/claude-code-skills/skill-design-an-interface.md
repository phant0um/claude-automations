---
title: "Skill: design-an-interface"
type: source
source_type: clipping
source_path: clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741 16.md
created: 2026-05-09
ingested: 2026-05-09
tags: [ai-agents, clipping]
triagem_score: 7
---

## Resumo

| name | design-an-interface |
| --- | --- |
| description | Generate multiple radically different interface designs for a module using parallel sub-agents. Use when user wants to design an API, explore interface options, compare module shapes, or mentions "design it twice". |

## Design an Interface

Based on "Design It Twice" from "A Philosophy of Software Design": your first idea is unlikely to be the best. Generate multiple radically different designs, then compare.

## A Filosofia por Trás da Skill

O princípio "Design It Twice" vem do livro "A Philosophy of Software Design" de John Ousterhout (Stanford). A ideia central: o primeiro design de uma interface quase sempre reflete a implementação subjacente — ele "vaza" detalhes internos porque o designer está pensando em como construir, não em como usar.

Ao gerar designs radicalmente diferentes, o processo força o designer a considerar múltiplos modelos mentais para o mesmo problema. O design final não é a melhor das opções — é tipicamente uma síntese que pega os melhores aspectos de cada uma.

## Workflow Completo

### 1. Gather Requirements

Before designing, understand:

- **What problem does this module solve?** (em termos de domínio, não de implementação)
- **Who are the callers?** (outros módulos? usuários finais? sistemas externos?)
- **What data flows in and out?** (inputs, outputs, side effects)
- **What are the invariants?** (o que nunca deve acontecer? o que sempre deve ser verdade?)
- **What are the failure modes?** (como o caller sabe que algo deu errado?)

### 2. Generate 3 Radically Different Designs

A skill usa sub-agentes paralelos para gerar simultaneamente 3 designs com filosofias distintas:

**Design A — Imperativo/Procedural**
Expõe o "quê" e o "como" — o caller controla o fluxo:
```python
# Caller controla cada passo
conn = database.connect(config)
stmt = conn.prepare("SELECT * FROM users WHERE id = ?")
result = stmt.execute([user_id])
users = result.fetch_all()
conn.close()
```

**Design B — Declarativo/Fluent**
O caller descreve o que quer; o módulo decide como:
```python
# Caller descreve intenção
users = database.query(User).where(id=user_id).all()
```

**Design C — Callback/Event-Driven**
O módulo notifica o caller quando resultados estão prontos:
```python
# Caller reage a eventos
database.query("SELECT * FROM users WHERE id = ?", [user_id],
    on_success=lambda users: process(users),
    on_error=lambda err: handle(err))
```

### 3. Compare Designs

Para cada design, avaliar contra as mesmas dimensões:

| Dimensão | Design A | Design B | Design C |
|----------|----------|----------|----------|
| Facilidade de uso comum | Média | Alta | Baixa |
| Flexibilidade para casos raros | Alta | Baixa | Alta |
| Testabilidade (mocking) | Difícil | Fácil | Média |
| Extensibilidade futura | Alta | Média | Alta |
| Curva de aprendizado | Baixa | Baixa | Alta |
| Overhead de abstração | Baixo | Médio | Médio |

### 4. Synthesise Best Interface

O output final é um design sintetizado que:
- Toma a abstração mais limpa de cada opção
- Explica explicitamente quais trade-offs foram aceitos
- Identifica os edge cases que os designs alternativos cobrem melhor

### 5. Document Decision

O output inclui um ADR draft:

```markdown
# ADR: Interface Design for [Module]

## Decision
Adotar Design B (declarativo) como interface primária.

## Reasoning
- Callers mais comuns precisam de casos simples (Design B ideal)
- Casos complexos podem usar escape hatch: `.raw_query(sql)`
- Testabilidade melhor que Design A sem perder flexibilidade

## Rejected Alternatives
- Design A: imperativo, expõe detalhes de conexão ao caller
- Design C: overhead de callback para casos síncronos simples
```

## Por que Sub-Agentes Paralelos

A skill especifica o uso de sub-agentes paralelos para gerar os designs — não Claude pensando sequencialmente em opções A, B, C. A razão:

**Design sequencial**: Claude gera A, depois B. A influencia B. Designs ficam correlacionados — as opções não são realmente "radicalmente diferentes".

**Design paralelo**: sub-agentes independentes, cada um com instrução "gere um design que maximize [princípio X]". Sem contaminação entre opções — cada agente vai ao extremo do seu princípio.

O resultado são designs genuinamente diferentes que forçam uma comparação real, não variações do mesmo design.

## Aplicação Prática: API REST vs. SDK

Um caso de uso comum é escolher entre API REST pura vs. SDK client-side:

**REST (Design A):**
```
POST /api/payments
{"amount": 99.99, "currency": "USD", "userId": 12345}
→ 200 {"paymentId": "pay_abc123", "status": "pending"}
```

**SDK Fluent (Design B):**
```python
result = payments.create(
    amount=Money(99.99, "USD"),
    user=current_user
)
# payment_id = result.id
```

**Event-Driven (Design C):**
```python
payments.on("payment.created", handler)
payments.submit(PaymentRequest(amount, currency, user_id))
```

A comparação revela: REST é melhor para integração multi-linguagem; SDK é melhor para equipe homogênea Python; Event-driven é melhor para flows assíncronos com retry.

## Quando Usar esta Skill

**Usar quando:**
- Projetando uma nova API, SDK ou módulo de biblioteca
- Quando o primeiro design "parece certo mas não tenho certeza"
- Quando há discordância na equipe sobre qual abordagem adotar
- Antes de commitar uma interface pública (difícil de mudar depois)

**Não usar quando:**
- Interface já existe e está em uso — custo de mudança supera o benefício
- Módulo interno simples onde a implementação IS a interface
- Pressa extrema — gerar 3 designs leva tempo

## Integração com Outras Skills

- **`grill-with-docs`** antes: garantir que os requisitos estão corretos antes de gerar designs
- **`improve-codebase-architecture`** depois: verificar se o design escolhido se encaixa na arquitetura existente
- **ADR** sempre: documentar a decisão e as alternativas rejeitadas

## Limitações

- Sub-agentes paralelos têm custo — 3 designs gerados em paralelo = 3x o custo de um design
- "Radicalmente diferente" é relativo ao domínio — designs A e B podem ser menos diferentes do que parecem
- O processo não garante que o design sintetizado seja realmente melhor — pode ser um compromisso mediocre

## Origem

- Path: `clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741 16.md`
- Categoria: ai-agents
- Ingerido: 2026-05-09

## Cross-links

- [[03-RESOURCES/sources/claude-code-skills/skill-improve-codebase-architecture]]
- [[03-RESOURCES/sources/claude-code-skills/skill-grill-with-docs]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
