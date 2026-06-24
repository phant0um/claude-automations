---
title: "Skill: improve-codebase-architecture — Reference Sections"
type: source
source_type: consolidated
created: 2026-05-09
consolidated_from: 7 fragments (CONTEXT.md, ADR, Deepening, Interface Design, Language, Logic Prototype, UI Prototype)
tags: [ai-agents, skills, improve-codebase-architecture]
triagem_score: 7
---

Consolidated reference sections extracted from improve-codebase-architecture skill definition (mattpocock/skills repo).

## Included Sections

1. **CONTEXT.md Format** — Shared context template
2. **ADR Format** — Architecture Decision Record structure
3. **Deepening** — How to deepen shallow modules safely
4. **Interface Design** — Design It Twice pattern (Ousterhout)
5. **Language** — Shared vocabulary for suggestions
6. **Logic Prototype** — Interactive state model exploration
7. **UI Prototype** — Radically different UI variations

See [[skill-improve-codebase-architecture]] for main skill definition.

---

## Seções de Referência em Detalhe

### 1. CONTEXT.md Format

O CONTEXT.md é o artefato de contexto compartilhado de um projeto — o único documento que um agente precisa ler para ter uma visão completa do domínio. Estrutura canônica:

```markdown
# Projeto: [nome]

## Domínio e Propósito
[O que o sistema faz em linguagem de negócio]

## Glossário
[Termos do domínio com definições precisas]

## Módulos Principais
[Lista de módulos com responsabilidades]

## Invariantes
[O que nunca pode mudar: contratos de interface, regras de negócio críticas]

## Decisões de Arquitetura
[Link para ADRs relevantes]
```

A regra de ouro: qualquer desenvolvedor (humano ou agente) deve conseguir entender o sistema lendo apenas o CONTEXT.md. Se precisar abrir código para entender a estrutura básica, o CONTEXT.md está incompleto.

### 2. ADR Format — Architecture Decision Record

ADRs documentam o porquê das decisões, não apenas o quê. Estrutura mínima:

```markdown
# ADR-NNN: [Título da Decisão]

**Status:** Accepted / Proposed / Deprecated
**Data:** YYYY-MM-DD

## Contexto
[Problema que motivou a decisão]

## Decisão
[O que foi decidido]

## Consequências
[O que fica mais fácil e o que fica mais difícil com esta decisão]

## Alternativas Consideradas
[O que foi rejeitado e por quê]
```

ADRs são especialmente valiosos para agentes: evitam que o agente "re-decida" algo que já foi resolvido com razão. Sem ADR, o agente pode sugerir exatamente a alternativa que foi rejeitada três meses atrás, por uma razão que não está no código.

### 3. Deepening — Aprofundar Módulos Rasos

Um módulo "raso" tem interface complexa e implementação simples. O oposto de um módulo "profundo" (John Ousterhout, A Philosophy of Software Design): interface simples, implementação complexa que absorve a complexidade do caller.

O processo de deepening:
1. Identificar módulos com alta coupling (muitos callers dependendo de detalhes internos)
2. Propor nova interface que encapsula os detalhes
3. Migrar callers para a nova interface
4. Remover a interface antiga

A skill `improve-codebase-architecture` usa análise estática para detectar padrões de acoplamento e sugerir onde deepening produziria maior impacto.

### 4. Interface Design — Design It Twice

O princípio "Design It Twice" de Ousterhout: sua primeira ideia de interface raramente é a melhor. Gere pelo menos duas alternativas radicalmente diferentes antes de escolher.

Dimensões para variar:
- **Granularidade:** uma função genérica vs várias especializadas
- **Estado:** stateful vs stateless
- **Ownership:** quem é responsável por cada parte da lógica
- **Nível de abstração:** baixo nível (controle total) vs alto nível (menos boilerplate)

A skill `design-an-interface` formaliza este processo usando sub-agentes paralelos, cada um desenvolvendo uma variante diferente, seguido de comparação estruturada.

### 5. Language — Vocabulário Compartilhado

Módulos e funções devem usar a terminologia do domínio, não termos genéricos de programação. Exemplo:

| Ruim (genérico) | Bom (domínio) |
|---|---|
| `processItem()` | `approveOrder()` |
| `DataManager` | `InventoryRepository` |
| `flag` | `isEligibleForDiscount` |

Vocabulário consistente torna o código navegável por agentes que usam busca semântica — e elimina ambiguidade entre desenvolvedores humanos.

### 6. Logic Prototype — Exploração de Estado

Antes de implementar, prototipar o modelo de estado interativo: quais estados existem, quais transições são válidas, o que é invariante. Em código, isso tipicamente é uma state machine simples ou um arquivo de tipos sem implementação.

```typescript
type OrderStatus = 'pending' | 'approved' | 'shipped' | 'delivered' | 'cancelled'

type Transition = {
  from: OrderStatus
  to: OrderStatus
  condition: string
}
```

Este prototype serve como referência para implementação e testes. A skill usa um agente para explorar o espaço de estados e identificar transições inválidas ou missing antes de escrever a lógica real.

### 7. UI Prototype — Variações Radicais

Para interfaces de usuário, o mesmo princípio Design It Twice se aplica: gere variações que diferem não apenas em estética mas em modelo mental.

Exemplo para um dashboard de monitoramento:
- Variante A: grid de cards com métricas numéricas (modelo mental: scoreboard)
- Variante B: linha do tempo de eventos (modelo mental: log)
- Variante C: grafo de dependências com status em nós (modelo mental: mapa)

Cada variante implica diferentes user journeys e, portanto, diferentes backends de dados. Escolher a variante antes de construir o backend evita re-trabalho.

---

## Aplicação no Vault-Michel

Os padrões desta skill são diretamente aplicáveis ao vault como sistema de software:
- `04-SYSTEM/AGENTS.md` = CONTEXT.md do sistema de agentes
- ADRs poderiam documentar decisões como "por que kebab-case?" ou "por que `04-SYSTEM/` como raiz do SO?"
- Deepening se aplica a skills que têm muita lógica exposta no prompt em vez de encapsulada

A abordagem de glossário (`Language` section) já está implementada no vault via `03-RESOURCES/concepts/` — cada conceito tem uma página autoritativa que define a terminologia.

---

## Limitações

- A skill assume que existe um CONTEXT.md e ADRs — para projetos sem isso, o primeiro passo é criá-los, não melhorar a arquitetura
- Deepening automático requer que o agente entenda a semântica do código, não apenas a sintaxe — falha em domínios muito especializados sem documentação de contexto
- "Design it twice" é mais efetivo quando o agente tem informação suficiente sobre o contexto de uso; sem isso, as variantes tendem a ser similares
