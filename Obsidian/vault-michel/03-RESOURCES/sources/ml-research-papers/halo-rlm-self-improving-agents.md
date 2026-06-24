---
title: HALO: Using RLMs to Build Self-Improving Agents
type: source
source: Clippings/HALO Using RLMs to build self-improving agents.md
created: 2026-05-15
ingested: 2026-05-15
tags: [ai-agents]
triagem_score: 9
---

## Tese central
HALO = Hierarchical Agent Loop Optimizer: um agente que otimiza outros agentes analisando traces de execução em massa e sugerindo mudanças no HARNESS, não no modelo.

## Key insights
- Mismanaged Genius Hypothesis: modelos já têm inteligência superior; o gargalo é o harness mal projetado pelos humanos.
- +10% em AppWorld, TerminalBench, Finance Bench; harness vira optimizable service layer mensurável.
- Loop: collect traces → HALO analisa → reporta failure modes → coding agent aplica → re-run → repete.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]

- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]

---

## A Mismanaged Genius Hypothesis

A premissa central do HALO é que os modelos de linguagem modernos (GPT-4, Claude 3+) já têm capacidade cognitiva suficiente para realizar a maioria das tasks de software engineering autonomamente. O problema não é inteligência — é gestão. O harness (conjunto de ferramentas, prompts, memória, estratégias de planning) foi projetado por humanos com premissas incorretas sobre como os modelos falham.

Analogia: um gênio com ferramentas erradas, sem acesso aos arquivos corretos, sendo interrompido por perguntas desnecessárias. Não é problema de inteligência — é problema de gestão de recursos e ambiente.

**Implicação:** Em vez de esperar modelos melhores, otimize o harness dos modelos atuais. HALO automatiza essa otimização.

---

## Como HALO Funciona

### Fase 1: Coleta de Traces
O agente alvo (qualquer coding agent — Claude Code, Codex CLI, Devin) executa centenas de tasks em benchmark. Cada execução gera um trace completo: sequência de tool calls, raciocínio intermediário, resultado final (sucesso/falha).

HALO coleta esses traces sem intervenção. As execuções são em batch, em ambientes isolados, com tasks variadas do benchmark.

### Fase 2: Análise de Failure Modes
HALO analisa os traces e categoriza falhas em padrões:

- **Tool selection failures:** O agente usou a ferramenta errada para a tarefa (ex: usou grep quando devia usar ast-parser, ou vice-versa).
- **Context management failures:** O agente perdeu informação crítica em steps anteriores por não ter guardado corretamente.
- **Planning failures:** O agente iniciou execução sem plano suficiente e ficou preso em estado inconsistente.
- **Self-verification failures:** O agente não verificou o próprio trabalho e entregou resultado incorreto.
- **Loop failures:** O agente entrou em loop repetindo a mesma tool call sem progresso.

Cada categoria de falha mapeia para uma mudança específica no harness.

### Fase 3: Geração de Mudanças no Harness
Para cada failure mode identificado, HALO sugere mudanças concretas:

- Tool selection failures → adicionar instrução no CLAUDE.md sobre quando usar qual ferramenta
- Context management failures → adicionar hook PostToolUse para salvar resultados críticos
- Planning failures → adicionar skill que força o agente a escrever plano antes de agir
- Self-verification failures → adicionar step de verificação obrigatório no workflow

As mudanças são formuladas como diffs aplicáveis: novos blocos em CLAUDE.md, novos hooks, novas skills, novos prompts de sistema.

### Fase 4: Aplicação e Re-execução
Um coding agent (o próprio Claude Code) aplica as mudanças sugeridas. O benchmark é re-executado com o harness modificado. HALO compara performance antes/depois.

Se a mudança melhorou: é mantida e integrada no harness.
Se a mudança piorou ou foi neutra: é revertida, com análise de por que não funcionou.

O ciclo repete até convergência ou até atingir o budget de otimização.

---

## Resultados nos Benchmarks

| Benchmark | Domínio | Baseline | Com HALO | Delta |
|---|---|---|---|---|
| AppWorld | App automation | 62% | 72% | +10% |
| TerminalBench | Terminal tasks | 58% | 68% | +10% |
| FinanceBench | Financial analysis | 71% | 81% | +10% |

O ganho de +10% é consistente entre domínios — evidência de que o método generaliza, não apenas overfita para um benchmark específico.

---

## O Harness como Service Layer Mensurável

Antes de HALO, o harness era tratado como configuração artesanal — cada desenvolvedor construía seu CLAUDE.md/skills/hooks com base em intuição. HALO transforma o harness em **service layer otimizável com métricas**:

- **Harness quality score:** Performance no benchmark antes/depois de mudanças.
- **ROI por mudança:** Qual mudança específica contribuiu quanto para a melhoria.
- **Failure mode distribution:** Quais categorias de falha dominam (para priorizar otimizações).

Isso permite engenharia de harness baseada em dados em vez de intuição.

---

## Limitações e Críticas

- **Benchmark overfitting:** Otimizar para benchmarks específicos pode degradar performance em tasks out-of-distribution.
- **Ciclo lento:** Coletar traces de centenas de execuções, analisar, aplicar mudanças, re-executar — pode levar horas ou dias.
- **Custo computacional:** Cada execução de benchmark tem custo de API. Para organizações com orçamento limitado, iterações são lentas.
- **Mudanças de harness podem ser ininterpretáveis:** HALO pode sugerir mudanças no CLAUDE.md que melhoram a performance mas são difíceis de explicar — "black box optimization" em nível de prompt.

---

## Aplicação no Vault-Michel

O princípio de HALO é aplicável ao vault: coletar traces das sessões de agente (`04-SYSTEM/wiki/errors.md`), identificar failure modes recorrentes, e atualizar CLAUDE.md/skills para preveni-los. O `errors.md` com limite de 30 entradas e consolidação de similares é uma implementação manual deste loop.

---

## Conexões

- [[03-RESOURCES/sources/ai-agents-harness/how-claude-code-works-in-large-codebases]] — harness matters as much as the model
- [[03-RESOURCES/sources/memory-context-rag/grep-vs-embeddings-coding-agents]] — harness design determina performance mais que retrieval mechanism
- [[03-RESOURCES/sources/guides-courses-howtos/clipping-how-to-make-a-coding-agent-smarter-without-touching-the-mode]] — abordagem similar de otimização automática de harness
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
