---
title: "Skill: grill-with-docs"
type: source
source_type: clipping
source_path: clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741 6.md
created: 2026-05-09
ingested: 2026-05-09
tags: [ai-agents, clipping]
triagem_score: 7
---

## Resumo

| name | grill-with-docs |
| --- | --- |
| description | Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates documentation (CONTEXT.md, ADRs) inline as decisions crystallise. Use when user wants to stress-test a plan against their project's language and documented decisions. |

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the question

## O que é "Grilling" no contexto de Design

"Grilling" é uma técnica de entrevista de design onde o entrevistador (neste caso, Claude) desafia sistematicamente cada aspecto de um plano com perguntas difíceis — não para invalidar o plano, mas para encontrar assunções não testadas, inconsistências com o modelo de domínio, e decisões que parecem óbvias mas têm alternativas melhores.

A diferença de uma revisão de código ou revisão de design comum:
- **Revisão comum**: "isso parece certo?" → críticas pontuais
- **Grilling**: "por que isso em vez de X? o que acontece quando Y? como isso interage com Z?" → desafio sistemático de cada ramo da árvore de decisões

## Protocolo Completo da Skill

### Fase 1: Leitura de Contexto (antes de começar)

```
1. Ler CONTEXT.md → glossário do domínio
2. Ler docs/adr/*.md → decisões já tomadas
3. Identificar termos que o usuário usa vs. termos do domínio oficial
```

O grilling começa pela terminologia — usar termos inconsistentes com o CONTEXT.md é o primeiro sinal de que o plano não está ancorado no modelo de domínio real.

### Fase 2: Mapeamento da Árvore de Decisões

Antes de perguntar, Claude mapeia mentalmente a árvore de decisões implícita no plano:

```
Plano: "adicionar sistema de notificações"
├── Notificação de quê? (eventos de domínio)
├── Para quem? (targeting)
├── Por qual canal? (email, push, in-app)
│   ├── Se email: qual provider? qual formato?
│   ├── Se push: qual serviço? iOS/Android?
│   └── Se in-app: real-time ou polling?
├── Quando? (triggers, scheduling)
├── Preferências do usuário? (opt-in/out, frequência)
└── Como medir sucesso? (open rate, conversion)
```

Cada nó da árvore é uma decisão potencial a grillar.

### Fase 3: Grilling Sequencial (resolução bottom-up)

Claude desce a árvore resolvendo dependências antes de avançar:

> "Antes de discutir o provider de email, preciso entender: quem são os usuários que receberão notificações? São clientes externos ou apenas usuários internos? Isso determina se precisamos de localização, compliance (GDPR) e templates personalizados."

Para cada pergunta, Claude fornece **sua recomendação fundamentada** — não apenas a pergunta, mas a resposta que ele mesmo daria com base no CONTEXT.md e ADRs existentes.

### Fase 4: Cristalização em Documentação

Conforme as decisões emergem, Claude atualiza inline:

```markdown
# CONTEXT.md update
## Notificações
- Terminologia: "Alert" para ações urgentes, "Digest" para resumos periódicos
- Usuários-alvo: apenas clientes externos (B2B); internos usam Slack

# ADR draft: 007-notification-channels
Status: Proposed
Context: Precisamos notificar clientes sobre eventos críticos
Decision: Email como canal primário; push mobile como secundário
Consequences: Requer provider GDPR-compliant; sem SMS (custo vs. valor)
```

A documentação acontece durante o grilling, não depois — quando a decisão está fresca.

## Por que "Relentlessly"

A palavra "relentlessly" no prompt da skill é intencional. Grilling parcial — onde Claude pergunta 3 questões e aceita as respostas — não encontra os problemas reais. Os problemas reais estão nos ramos que parecem óbvios mas não foram testados.

Um plano que resiste a 15-20 perguntas difíceis tem confiança muito maior do que um plano "que parece bom" após uma revisão superficial.

## Quando Usar vs. Quando Não Usar

**Usar quando:**
- Antes de começar uma feature significativa (>3 dias de trabalho)
- Quando há incerteza sobre como o plano se encaixa no domínio existente
- Quando o usuário quer validar uma decisão arquitetural antes de codificar
- Quando a terminologia do plano difere do CONTEXT.md

**Não usar quando:**
- Para tasks de 1-2 horas com requirements claros — overhead não vale
- Quando o plano já foi grillado e aprovado — não re-grillar o mesmo plano
- Para bugs e diagnóstico — usar `diagnose` skill

## Integração com o Fluxo de Desenvolvimento

```
Ideia inicial
    ↓
grill-with-docs → plano validado + CONTEXT.md atualizado + ADR draft
    ↓
improve-codebase-architecture → análise de onde implementar
    ↓
design-an-interface → múltiplas opções de interface
    ↓
Implementação
    ↓
diagnose → se bugs aparecerem
```

## Exemplo de Sessão

```
Usuário: "Quero adicionar autenticação OAuth2 ao sistema"

Claude: "Antes de avaliar a implementação, vou grilllar o plano contra
o CONTEXT.md. Primeira questão: o CONTEXT.md define 'usuário' como 
alguém com conta própria no sistema. OAuth2 introduz o conceito de 
'identidade externa' — como resolvemos o conflito entre um usuário 
que criou conta local E tem conta Google? Minha recomendação: 
account linking obrigatório na primeira autenticação OAuth."

[Usuário responde]

Claude: "Aceito. Próxima: o ADR-003 diz que emails são identificadores 
únicos. OAuth2 não garante email único entre providers — Google e GitHub
podem ter o mesmo email não-verificado. Como tratamos colisão de email?
Recomendação: exigir verificação de email antes de linking..."
```

## Limitações

- Sessões de grilling longas (>30 perguntas) perdem foco — o usuário começa a responder apressadamente
- Não substitui research de domínio — se o CONTEXT.md está incompleto, o grilling será igualmente limitado
- Claude pode não ter acesso a constraints de negócio não documentados (budget, prazo, decisões políticas)

## Origem

- Path: `clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741 6.md`
- Categoria: ai-agents
- Ingerido: 2026-05-09

## Cross-links

- [[03-RESOURCES/sources/claude-code-skills/skill-diagnose]]
- [[03-RESOURCES/sources/claude-code-skills/skill-improve-codebase-architecture]]
- [[03-RESOURCES/sources/claude-code-skills/skill-design-an-interface]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
