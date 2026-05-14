---
title: "New Skills: /handoff, /prototype, /review and /writing-*"
type: source
author: Matt Pocock
publisher: AI Hero
created: 2026-05-14
updated: 2026-05-14
tags: [claude-skills, matt-pocock, aihero, handoff, prototype, code-review, writing, context-overflow]
source_type: email/newsletter
---

# New Skills: /handoff, /prototype, /review and /writing-*

**Autor:** [[03-RESOURCES/entities/Matt-Pocock|Matt Pocock]] (AI Hero)  
**Data:** 2026-05-14  
**Canal:** Newsletter/email AI Hero

---

## Resumo Executivo

Matt Pocock lança 4 novos skills para Claude Code, cada um atacando um ponto de fricção específico do workflow de desenvolvimento. `/handoff` resolve overflow de contexto. `/prototype` resolve "unknown unknowns". `/review` verifica código contra spec original. `/writing-*` trata prototipagem como escrita estruturada.

---

## Skills em Detalhe

### /handoff — Solução para Context Overflow

**Problema atacado:** context overflow no meio de uma sessão longa.

**Como funciona:**
1. Entrega a conversa inteira (contexto + "vibe") para um agente fresco
2. O novo agente pode abrir um workspace separado, corrigir o problema, e retornar o que aprendeu
3. Human fica no controle — não é delegação cega

**Distinção chave:** funciona como sub-agente autônomo mas com o humano mantendo oversight. O agente derivado herda todo o contexto acumulado e pode operar independentemente antes de "passar de volta" o resultado.

**Casos de uso:** sessões de debug que cresceram demais; conversas com mais de 10 turnos de raciocínio encadeado; qualquer situação onde context rot já está afetando a qualidade das respostas.

> Relaciona com: [[03-RESOURCES/concepts/context-rot]], [[03-RESOURCES/concepts/multi-agent-orchestration]]

---

### /prototype — Para "Unknown Unknowns"

**Problema atacado:** coisas que você só descobre construindo.

**Dois modos por tipo de problema:**

**Para UI:**
- Gera variações radicalmente diferentes em paralelo
- Humano mistura as melhores partes
- Rationale: AI não consegue ver o que está construindo — humano precisa aplicar seu "taste"

**Para state machines / business logic:**
- Constrói uma aplicação terminal interativa para o usuário explorar o problema
- Transforma exploração de lógica em algo tangível e testável

**Insight de design:** prototipagem como técnica epistêmica — a única forma de saber o que funciona é construir algo que pode ser avaliado. O skill codifica esse loop.

> Relaciona com: [[03-RESOURCES/concepts/multi-agent-orchestration]] (variações em paralelo)

---

### /review — Em Progresso

**Status:** in-progress  
**Problema atacado:** revisão de código que verifica contra dois critérios simultâneos:
1. Os padrões do próprio repositório (convenções, estilo, arquitetura)
2. A spec original (o que foi pedido vs o que foi entregue)

**Distinção do code review comum:** a maioria dos code reviewers verifica apenas o código em si. Este skill compara contra a intenção original — detecta code drift entre spec e implementação.

> Relaciona com: [[03-RESOURCES/concepts/parallel-agent-code-review]]

---

### /writing-* — Em Progresso

**Status:** in-progress  
**Conceito:** três skills encadeados tratando escrita como um processo de prototipagem.

Pipeline:
1. **Fragments** — coleta de ideias, fragmentos, matéria-prima
2. **Beats** — estruturação em batidas narrativas
3. **Shape** — moldagem final do texto

**Insight de design:** o skill reusa o conceito de `/prototype` aplicado à escrita. A ideia de que "prototipar é uma técnica de escrita" e "escrever é uma técnica de prototipagem" torna os dois domínios análogos.

---

## Padrão Comum entre os 4 Skills

Todos os 4 atacam o mesmo problema raiz: **o humano como gargalo de qualidade**. O AI não consegue ver a UI, não consegue saber a spec original, não consegue entregar contexto entre sessões — essas são as lacunas que os skills preenchem com humano no loop.

| Skill | Lacuna resolvida | Humano no loop como |
|-------|-----------------|---------------------|
| /handoff | Context overflow | Recipient do handoff + oversight do sub-agente |
| /prototype | Unknown unknowns | Aplicador de taste (UI) ou explorador (logic) |
| /review | Spec drift | Detentor da intenção original |
| /writing-* | Estrutura de escrita | Curador dos fragments e beats |

---

## Conexões

- [[03-RESOURCES/entities/Matt-Pocock]] — autor; novo conjunto de skills adicionado ao repo AI Hero
- [[03-RESOURCES/concepts/claude-skills]] — estes 4 skills expandem o ecossistema de skills de Matt Pocock
- [[03-RESOURCES/concepts/context-rot]] — /handoff é solução direta para context rot
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — /handoff usa sub-agente com handback
- [[03-RESOURCES/concepts/parallel-agent-code-review]] — /review complementa e estende esse padrão com verificação de spec
- [[03-RESOURCES/concepts/claude-code-workflow]] — /prototype e /handoff encaixam nas fases Explore e Code do EPCC
