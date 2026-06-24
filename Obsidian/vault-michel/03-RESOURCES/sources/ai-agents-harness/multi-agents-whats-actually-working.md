---
title: "Multi-Agents: What's Actually Working"
type: source
author: Walden Yan (Cognition / Devin)
source_url: https://cognition.ai/blog/multi-agents-whats-actually-working
created: 2026-04-24
updated: 2026-04-24
tags: [multi-agent, context-engineering, generator-verifier, smart-friend, cognition, devin]
triagem_score: 9
---

# Multi-Agents: What's Actually Working

**Autor:** [[03-RESOURCES/entities/Walden-Yan]] — Cognition AI (criador do [[03-RESOURCES/entities/Devin]])
**Contexto:** Seguimento ao post "Don't Build Multi-Agents" (10 meses antes). A tese original foi parcialmente revisada.

## Tese Central

> Multi-agent systems work best today when **writes stay single-threaded** and additional agents contribute intelligence rather than actions.

A observação original sobre swarms de escritores paralelos ainda se mantém — a maioria ainda falha. O que funciona é um subconjunto mais estreito: agentes que contribuem *inteligência* enquanto as *escritas* ficam em thread única.

## O Que Mudou nos Últimos 10 Meses

- Modelos tornaram-se naturalmente mais "agentic" — entendem tool use, limites de contexto, e como destilar contexto para colaboradores
- Uso de agentes Devin cresceu ~8x nos últimos 6 meses mesmo nos maiores clientes enterprise (historicamente conservadores)
- Explosão de custos levou à demanda por "frontier capabilities at lower cost" via multi-agent
- Demos sensoracionalistas: browser (200k LOC), compilador C (100k LOC), LLM training script (10k+ iterações) — mas todos com critério de sucesso simples e verificável

## Experimento 1: Code-Review-Loop

**Mecanismo:** Devin (coder) → Devin Review (reviewer) → iterate

**Resultados:** Devin Review captura em média **2 bugs por PR**, dos quais **~58% são severos** (erros de lógica, edge cases, vulnerabilidades de segurança).

**Insight contraintuitivo:** O sistema funciona melhor quando os agentes *não compartilham contexto* previamente.

**Por quê funciona sem contexto compartilhado:**
1. O agente de review raciocina de trás para frente a partir da implementação, sem o spec — pode questionar coisas que o coder ignorou
2. **[[03-RESOURCES/concepts/llm-ml-foundations/context-rot]]** — modelos ficam menos inteligentes com contextos longos (atenção diluída). O review agent começa com contexto limpo, apenas o diff, e re-descobre contexto necessário lendo o código do zero
3. Modelos não têm egos — o bias compartilhado vem do treinamento (alta qualidade hoje), não de perspectiva pessoal

**Ponte de comunicação:** O coder deve filtrar bugs do reviewer usando seu contexto mais amplo (instruções do usuário, decisões tomadas) para evitar loops e trabalho fora de escopo.

**Takeaway:** Clean context → melhoria notável em capabilities no [[03-RESOURCES/concepts/llm-ml-foundations/generator-verifier-loop]]. Mas síntese clara com contexto global é essencial para experiência coesa.

## Experimento 2: Smart Friend (Modelo Grande como Consultor)

**Arquitetura:** Modelo menor (primário, barato) + modelo maior (smart friend, caro) como tool call opcional.

**Lançamento:** SWE-1.5 (950 tok/sec, sub-frontier) pareado com Sonnet 4.5 para planning.

**Desafios de engenharia:**

### 1. O modelo primário precisa saber quando escalar
- Problema: "como um modelo mais fraco sabe que está no limite?"
- Solução parcial: sempre fazer ao menos uma call ao smart friend para avaliar dificuldade
- Solução alternativa: prompt-tuning ou treino para calibração; guidance prescritiva por domínio (ex: sempre invocar para merge conflicts)
- Contexto a compartilhar: fork completo do contexto do primário (solução 80/20)
- Perguntas amplas ("o que devo fazer?") funcionam melhor que perguntas estreitas

### 2. O smart friend precisa saber responder ao modelo primário
- Se o smart friend não tem acesso a `important_file.py`, deve instruir o primário a investigar e perguntar novamente — não inventar
- "Over-scoped smart friend": sugerir guidance além da pergunta feita, baseado na trajetória do agente

**O que aconteceu na prática:**
- SWE-1.5 era fraco demais como primário — gap muito amplo exatamente nas áreas críticas (saber escalar, saber o que perguntar)
- SWE-1.6 (Opus-4.5 level no SWE-bench) fecha parcialmente o gap — padrão começa a valer a pena
- Funciona bem hoje entre **modelos frontier** (Claude + GPT em produção por stretch significativo)
- Descoberta: entre frontiers, a lógica muda de "dificuldade" para **capability router** — modelos diferentes são melhores em sub-tarefas diferentes (debug, visual reasoning, escrever testes)

**Takeaway:** Smart friend funciona hoje quando ambos os modelos são fortes. Fazer funcionar com primário assimetricamente mais fraco (o caso com maior upside) é problema em aberto — provavelmente de treinamento.

## Experimento 3: Higher-Level Delegation (Manager Devin)

**Arquitetura:** Manager Devin → quebra tarefa → spawna child Devins → coordena via MCP interno

**Desafios encontrados:**
- Managers treinados em delegação de pequeno escopo tornam-se over-prescritivos — backfire quando o manager não tem contexto profundo do codebase
- Agentes assumem que compartilham estado com filhos quando não compartilham
- Cross-agent communication (subagente escreve para manager repassar a siblings) não acontece por default — modelos não foram treinados em ambientes onde isso era necessário

**Sobre unstructured swarms:** Cognition acredita que é "mostly a distraction". A forma prática é **map-reduce-and-manage**: manager divide, filhos executam, manager sintetiza.

## Princípios Destilados

| Pattern | Descrição |
|---------|-----------|
| **Single-threaded writes** | Só um agente escreve; outros contribuem inteligência |
| **Clean context reviewer** | Review agent sem contexto do coding agent detecta mais bugs |
| **Generator-verifier loop** | Geração → verificação → iteração; verifier tem fresh context |
| **Smart friend / capability router** | Modelo menor consulta modelo maior (ou mais especializado) quando necessário |
| **Map-reduce-and-manage** | Manager divide → filhos executam → manager sintetiza |

## Problemas em Aberto

Todos os problemas abertos são **problemas de comunicação**:
- Como modelo mais fraco aprende a escalar para o mais forte?
- Como agente filho surfacia descoberta que deve mudar o trabalho de siblings?
- Como transferir contexto entre agentes sem afogar o receptor?

Cognition acredita que a próxima geração de modelos (incluindo os que treinam internamente) começará a fechar esses gaps.

## Referências e Links

- Post anterior: [Don't Build Multi-Agents](https://cognition.ai/blog/dont-build-multi-agents)
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] — fenômeno documentado pela Chroma
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — padrões de coordenação
- [[03-RESOURCES/concepts/llm-ml-foundations/generator-verifier-loop]] — conceito criado nesta ingestão
- [[03-RESOURCES/entities/Devin]] — produto Cognition AI
- [[03-RESOURCES/entities/Cognition-AI]] — empresa por trás de Devin e Windsurf
- Anthropic [Advisor Strategy](https://claude.com/blog/the-advisor-strategy) — experimento similar de smart friend
