---
title: Generator-Verifier Loop
type: concept
status: developing
created: 2026-04-24
updated: 2026-05-14
tags: [multi-agent, verification, context-engineering, clean-context, gan-pattern, evaluator, long-running]
---

# Generator-Verifier Loop

Padrão de multi-agent onde um agente **gera** (escreve código, texto, plano) e outro agente **verifica** (revisa, testa, critica) — idealmente com **contexto limpo** (sem acesso ao processo de geração).

## Mecanismo

```
Generator Agent → [artifact] → Verifier Agent (clean context)
                                      ↓
                              [bugs, issues, critique]
                                      ↓
                         Communication Bridge (filtro + síntese)
                                      ↓
                              Generator Agent (itera)
```

## Por Que Contexto Limpo Funciona

O insight contraintuitivo de Walden Yan (Cognition): verifiers funcionam **melhor sem contexto compartilhado** com o generator.

1. **[[03-RESOURCES/concepts/llm-ml-foundations/context-rot]]** — modelos degradam em decisões à medida que o contexto cresce. Um verifier com contexto limpo é objetivamente mais inteligente que o generator após horas de trabalho
2. **Raciocínio reverso** — o verifier raciocina a partir da implementação sem o spec, podendo questionar premissas que o generator aceitou sem questionar
3. **Sem ego** — modelos não têm viés pessoal; o bias compartilhado vem do treinamento (geralmente alta qualidade), não de perspectiva subjetiva

## Evidências Empíricas

Da experiência de Cognition com Devin + Devin Review:
- Média de **2 bugs detectados por PR**
- **~58% são severos** (lógica, edge cases, segurança)
- Sistema itera múltiplos ciclos review, encontrando novos bugs a cada rodada

- **[2026-06-22]** Aplicação do padrão a sinais de trading quantitativo: agente gerador de sinal é o pior juiz de se é alpha real ou ruído — [[03-RESOURCES/sources/how-to-use-loop-engineering-to-build-a-self-improving-quant-trading-system]]

## Communication Bridge — O Componente Crítico

O verifier com contexto limpo pode gerar falsos positivos (bugs que o generator ignorou intencionalmente por instrução do usuário). A ponte de comunicação é onde o generator usa seu contexto mais amplo para **filtrar** o que o verifier reportou:

- Bugs fora do escopo → ignorar
- Bugs conflitando com instrução explícita do usuário → ignorar com nota
- Bugs válidos → corrigir

Sem essa ponte, o sistema pode entrar em **loop infinito** ou **desrespeitar instruções do usuário**.

## Generalização

O padrão se generaliza além de code review:

| Domínio | Generator | Verifier |
|---------|-----------|----------|
| Código | Coding agent | Review agent |
| Pesquisa | Research agent | Critic agent |
| Escrita | Writer agent | Editor agent |
| Plano | Planner | Challenger |

## GAN-Inspired Three-Agent Pattern (Anthropic, 2026)

Prithvi Rajasekaran (Anthropic Labs) extended this pattern into a production harness for long-running autonomous coding:

**Planner → Generator → Evaluator (QA)**

Key additions vs. basic generator-verifier:
- **Planner** expands 1-sentence user prompt into a full product spec — agents figure out implementation path, not the planner
- **Sprint contract** — generator and evaluator *negotiate* what "done" means before any code is written, bridging the gap between user story and testable implementation
- **Evaluator tuning** — few-shot calibration with detailed score breakdowns; tuning for skepticism is far easier than tuning a generator to be self-critical
- **Playwright MCP** — evaluator navigates live running app, not static screenshots; files granular bug reports (e.g., 27 criteria per sprint)

The self-evaluation problem: "When asked to evaluate work they've produced, agents confidently praise the work — even when quality is obviously mediocre." The separation into a skeptical evaluator is the fix.

**Opus 4.5:** Context anxiety required context resets between sessions.  
**Opus 4.6:** Context anxiety largely resolved; sprint structure can be removed; evaluator remains valuable at the capability edge.

Source: [[03-RESOURCES/sources/ai-agents-harness/harness-design-long-running-apps-anthropic]]

## Blocking Gates — Variante mais Forte

[[03-RESOURCES/concepts/pkm-obsidian/academic-pipeline-integrity-gates]] é uma variante que vai além do verifier loop: quando a gate detecta falha, ela **bloqueia estruturalmente** o pipeline — o próximo stage é inalcançável sem intervenção humana.

Diferença chave:

| Propriedade | Verifier Loop | Integrity Gate |
|-------------|--------------|----------------|
| Resposta a falha | Log + report | Bloqueia pipeline |
| Humano necessário? | Opcional | Sim, em caso de falha |
| Pipeline avança com falha? | Sim (verifier é advisory) | Não (gate é estrutural) |

Primeiro caso em produção em escala: Imbad0202/academic-research-skills (Stage 2.5 e Stage 4.5), resposta ao audit Zhao et al. de 146,932 citações alucinadas em 2025 (arXiv:2605.07723).

## Verificador como Objeto de Dados (Primer 2026)

Peking University/Tsinghua tratam o verificador como **objeto de dados com failure surfaces próprias** — não apenas componente de pipeline. Famílias de verificador: checadores formais, PRMs, reward models aprendidos, juízes de rubrica, seletores de closed-loop. Cada família tem caso de uso, modos de falha e campos de auditoria distintos.

**Co-evolving generators+verifiers** (CoVerRL, DeepSeekMath-V2) aumenta a necessidade de versionamento — não a remove. Master-key attacks, perturbações GSMSymbolic e testes de verifier-gaming mostram que signals de reward podem ser amplos mas frágeis.

Para dados de agentes: episódios devem ser reproduzíveis (com estados, ações, falhas, retentativas, predicados terminais) — transcrições de sucesso limpas apagam exatamente os branches onde atribuição de crédito é visível.

Ver [[03-RESOURCES/sources/primer-post-training-reasoning-data]].

## Relação com Outros Conceitos

- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] — a razão fundamental por que clean context funciona
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — padrão mais amplo de coordenação
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]] — framework probabilístico de verificação (complementar)
- [[03-RESOURCES/concepts/llm-ml-foundations/test-time-scaling]] — Best-of-N é uma forma de generator-verifier sem iteração
- [[03-RESOURCES/concepts/pkm-obsidian/academic-pipeline-integrity-gates]] — variante blocking: gates que param o pipeline vs verifiers que apenas reportam
- [[03-RESOURCES/sources/ai-agents-harness/multi-agents-whats-actually-working]] — fonte primária (Walden Yan, Cognition)
- [[03-RESOURCES/sources/ml-research-papers/academic-research-skills-integrity-gates-146k-citations]] — caso de produção de blocking gates em pipeline acadêmico
- **[2026-06-22]** Google TF→JAX: verificação dual — quantitative (gradient ascent para max error entre TF/JAX layers) + qualitative (blind-audit LLM Judge com architectural checklist). Verifier é separado do generator (Coder agent) — [[03-RESOURCES/sources/ai-agents/6x-faster-migration-tensorflow-to-jax]]
- **[2026-06-24]** SNS não cresce por falta de sistema, não de talento. Claude Code + 3 materiais (口調/型/ネタ) = pipeline de conteúdo... — [[claude-code-sns-auto-operation]]
- **[2026-06-24]** Agent loops (/loop, /goal) sem external validator geram 'Beautiful Nonsense' — output que passa toda validação interna... — [[the-missing-piece-in-every-agent-loop]]
- **[2026-06-24]** Deep Research fracassa porque gera, não verifica. Próxima etapa = Discoverative Intelligence: agent team com roles... — [[from-generate-to-verify-ai]]
- **[2026-06-24]** Agent Loops = reason→act→observe→repeat com goal+action+stop. 7 cenários mais utilizáveis: research→artifact, creative... — [[agent-loops-most-usable-scenarios]]
