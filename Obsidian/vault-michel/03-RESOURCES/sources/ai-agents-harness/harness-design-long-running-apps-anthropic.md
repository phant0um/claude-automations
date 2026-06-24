---
title: "Harness Design for Long-Running Application Development"
type: source
source_type: clipping
source_file: "Clippings/Harness design for long-running application development.md"
source_url: "https://www.anthropic.com/engineering/harness-design-long-running-apps"
author: "Prithvi Rajasekaran (Anthropic Labs)"
created: 2026-05-14
tags: [harness, multi-agent, gan-pattern, planner-generator-evaluator, long-running, opus-4-6, context-anxiety, sprint-contract, anthropic]
triagem_score: 10
---

# Harness Design for Long-Running Application Development

**Author:** Prithvi Rajasekaran — Anthropic Labs  
**Source:** Official Anthropic Engineering blog

## Core Thesis

Two failure modes plague long-running agentic coding:
1. **Context anxiety** — models wrap up work prematurely as they approach perceived context limits
2. **Self-evaluation bias** — agents praise their own mediocre work; evaluators trained on LLM outputs are systematically lenient

The solution is a **GAN-inspired three-agent architecture** (planner + generator + evaluator) where the evaluator is tuned to be skeptical rather than trying to make the generator self-critical.

## Architecture

### Three Agents

**Planner:**
- Takes 1–4 sentence user prompt, expands to full product spec
- Deliberately ambitious scope; emphasizes deliverables over implementation details
- Has access to `frontend-design` skill

**Generator:**
- Works sprint-by-sprint (or continuous on Opus 4.6+)
- Self-evaluates before handing to QA; uses git for version control

**Evaluator (QA):**
- Uses Playwright MCP to interact with live running application
- Grades against hardened criteria (design quality, originality, craft, functionality / product depth, visual design, code quality)
- Negotiates **sprint contract** with generator before each sprint: agreeing on "done" criteria before any code is written
- Files granular bug reports (27 criteria per sprint in one example)

### Key Design Insights

| Problem | Solution |
|---|---|
| Context anxiety (Sonnet 4.5) | Context resets — full clean slate + structured handoff artifact |
| Poor self-evaluation | Separate generator and evaluator agents; tune evaluator to be skeptical |
| Over-specified technical plans | Planner constrained to deliverables only; agents figure out implementation path |
| Evaluator leniency | Few-shot calibration examples with detailed score breakdowns |

## Frontend Design Criteria

Four grading criteria (weighted toward design quality + originality):
- **Design quality** — coherent whole; colors, typography, layout create distinct mood
- **Originality** — evidence of custom decisions vs. template defaults + AI slop (purple gradients over white cards = fail)
- **Craft** — technical execution: typography hierarchy, spacing, contrast
- **Functionality** — usability independent of aesthetics

## Opus 4.5 vs Opus 4.6 Harness Evolution

| Aspect | Opus 4.5 | Opus 4.6 |
|---|---|---|
| Context anxiety | Strong — context resets required | Largely resolved — compaction sufficient |
| Sprint structure | Required for coherence | Removable; Opus 4.6 runs 2+ hours coherently |
| Evaluator value | Load-bearing at every sprint | Only valuable for tasks at capability edge |

**Cost/Duration (DAW example with Opus 4.6 harness):**
- Planner: 4.7 min / $0.46
- Build Round 1: 2h 7min / $71
- QA Round 1: 8.8 min / $3.24
- Total: ~4 hours / $124.70

## Key Principles

> "Every component in a harness encodes an assumption about what the model can't do on its own, and those assumptions are worth stress testing."

> "Find the simplest solution possible, and only increase complexity when needed."

- When a new model lands: re-examine the harness, strip non-load-bearing components, add new pieces for greater capability
- The space of interesting harness combinations doesn't shrink as models improve — it *moves*

## Connections

- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — extended: GAN-pattern as production harness design
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — parent architecture concept
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — three-agent planner/generator/evaluator pattern
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — context anxiety and context resets vs compaction
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] — context anxiety is the acute form durante long tasks
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]] — related engineering concept
- [[03-RESOURCES/entities/Claude-Opus-47]] — Opus 4.6 in harness; context anxiety resolved
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — frontend-design skill used by planner

---

## Análise Aprofundada dos Padrões do Paper

### Context Anxiety: Por Que Modelos Param Cedo

Context anxiety é um comportamento emergente, não programado: modelos de linguagem não têm acesso direto ao número de tokens no contexto, mas desenvolvem durante o training um sentido aproximado de "quão cheio" o contexto está com base em sinais internos. Quando esse senso indica "estou perto do limite", o modelo começa a "wrap up" — produz conclusões precipitadas, pula passos de raciocínio, e reporta trabalho como mais completo do que está.

O problema é que esse comportamento emerge durante pretraining em documentos de comprimento natural (artigos, livros, posts) onde a convenção é que texto perto do fim = conclusão. Em sessões longas de agentic coding, o modelo aplica essa heurística equivocadamente.

**Por que context resets funcionam:** Ao dar ao agente um context window limpo (com apenas um handoff artifact estruturado descrevendo o estado atual), o senso de "estou perto do limite" é zerado. O agente recomeça como se estivesse no início de uma tarefa, mas com toda informação relevante do progresso anterior no handoff artifact.

**Por que compaction funciona no Opus 4.6:** Versões mais recentes parecem ter treinamento específico para manter coerência em contextos longos, ou foram fine-tuned em sessões longas que os ensinaram que "muito texto no contexto" não implica "tarefa quase terminada".

### O Sprint Contract como Protocolo de Verificação

A inovação do sprint contract é mais sutil do que parece: negociar critérios de "done" *antes* de escrever código elimina a ambiguidade de avaliação post-hoc. Sem o sprint contract, o evaluator avalia o output do generator contra seus próprios critérios internos, que podem diferir dos critérios do generator.

Com o sprint contract, ambos concordaram explicitamente sobre o que constitui sucesso antes de começar. O evaluator não está impondo padrões surpresa — está verificando conformidade com um contrato que o generator assinou. Isso reduz rejeições injustas e aumenta a qualidade das rejeições que ocorrem (são mais específicas e acionáveis).

### Por Que Playwright MCP para Avaliação

A escolha do Playwright MCP (automação de browser) para o evaluator é significativa: o evaluator não lê o código para avaliar — *usa o produto*. Para avaliação de frontend especificamente, isso é a única forma de detectar problemas que não aparecem no código mas aparecem no browser: timing de renderização, comportamento de hover states, layout em diferentes viewports, FOUC (Flash of Unstyled Content).

Um evaluator que lê código pode perder que um componente tem z-index incorreto que só se manifesta em interação; um evaluator que usa o produto via Playwright detecta isso imediatamente.

### Os Critérios de Design: Por Que Design Quality e Originality Pesam Mais

Os 4 critérios de avaliação (design quality, originality, craft, functionality) com peso maior nos dois primeiros parecem subjetivos, mas refletem uma observação empírica: Claude e modelos similares têm alta tendência a produzir "AI slop" — designs que funcionam mas são genéricos (purple gradients over white cards, Geist font para tudo, espaçamento idêntico ao Tailwind default).

Penalizar pesadamente a falta de originalidade força o generator a tomar decisões de design ativamente em vez de defaultar para o template que domina o training data. Os critérios de design quality e originality são os que mais frequentemente diferenciam output de alta qualidade de output medíocre em frontend.

### A Progressão do Custo e o Que Ela Implica

O exemplo do DAW (Digital Audio Workstation) com custo de $124.70 em 4 horas é significativo:

- **Planner ($0.46/4.7min):** Expansão de spec é barata e rápida — justifica sempre ter um planner
- **Generator ($71/2h7min):** A maior parte do custo está aqui — onde o trabalho real acontece
- **Evaluator ($3.24/8.8min):** Verificação é relativamente barata — 4.6% do custo total

Se o evaluator custa 4.6% do total mas detecta problemas que requerem re-trabalho pelo generator, o ROI de incluí-lo é muito alto. Um ciclo de re-trabalho sem evaluator que custa $71 adicionais seria detectado por um evaluator de $3. Isso justifica o padrão mesmo com Opus 4.6 (onde context anxiety não requer resets).

### Princípio de Evolução do Harness

A frase mais importante do paper é: "when a new model lands, re-examine the harness, strip non-load-bearing components, add new pieces for greater capability." Isso define uma epistemologia de harness design:

Cada componente do harness é uma hipótese sobre o que o modelo não consegue fazer sozinho. Quando o modelo evolui, as hipóteses devem ser re-testadas. Componentes baseados em hipóteses falsificadas devem ser removidos — não porque são "ruins", mas porque o modelo que eles compensavam mudou.

Isso explica por que context resets (necessários para Sonnet 4.5) se tornaram desnecessários com Opus 4.6: a hipótese "o modelo tem context anxiety severa em sessões longas" foi verdadeira para Sonnet 4.5 e falsa para Opus 4.6. O harness evoluiu corretamente ao remover o mecanismo de reset.
