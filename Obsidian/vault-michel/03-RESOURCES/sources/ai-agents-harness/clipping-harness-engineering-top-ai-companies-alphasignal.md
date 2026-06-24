---
title: "A Closer Look at Harness Engineering from Top AI Companies"
type: source-summary
source_type: social-media-thread
author: "@AlphaSignalAI"
source_url: "https://x.com/AlphaSignalAI/status/2046952554421002393"
published: 2026-04-13
created: 2026-05-01
tags: [harness-engineering, agents, openai, anthropic, thoughtworks, langchain]
triagem_score: 9
---

# Harness Engineering from Top AI Companies

**Author:** @AlphaSignalAI
**Signal:** Comparative analysis of OpenAI, Anthropic, ThoughtWorks harness approaches + Opus 4.7 implications.

## Core Definition

> "If you're not the model, you're the harness." — Vivek Trivedy, LangChain

Everything around the model = the harness: system prompts, tools, middleware, file system, documentation, verification loops.

## The Benchmark Evidence

- LangChain: same model (GPT-5.2-Codex), different harness → Terminal Bench 2.0: **52.8% → 66.5%** (rank 30+ → rank 5)
- Vercel: **deleted 80% of agent's tools** → performance went up
- "Maxing reasoning at every stage = worst score (53.9%)"
- **Reasoning sandwich:** high planning → reduced building → high verifying = **66.5%**

## Three Approaches

### OpenAI (Ryan Lopopolo / Codex)
- 1M lines, 5 months, zero human-written
- Four engineers, Sora Android: 28 days → #1 Play Store, 99.9% crash-free
- Codex handled 70% of PRs weekly
- Method: **encode rules as code, not prose**
  - Dependency layers: Types → Config → Repo → Service → Runtime → UI
  - Structural tests that fail if layer imports wrong direction
  - AGENTS.md files per module (distributed docs)
  - Linters written by Codex itself
- Principle: "design the environment thoroughly, then let the agent work inside it"

### Anthropic (GAN-inspired)
- Problem: agents can't honestly evaluate their own work
- Solution: Planner → Generator → Evaluator (Playwright)
- **Claude Managed Agents** (April 9, 2026) = "meta-harness"
  - Decoupled: brain (Claude) / hands (sandbox) / session (durable event log)
  - Crash brain → recovers from log; lose sandbox → tool error, not system failure
  - +10 points on structured file generation vs standard prompting
- Cost: solo agent broken demo = $9; full managed harness = $200 (**22x cost**)

### ThoughtWorks (Birgitta Böckeler)
- Not a system — a vocabulary/classification framework
- **Two axes:** Guide (before) vs Sensor (after); Computational vs Inferential
- Common failure: teams have 3 computational sensors (tests/linters/CI) + zero computational guides
- **Harnessability:** strongly-typed languages + clear module boundaries = more reliable agent work
- Weakness: current tools check maintainability but not whether agent did what was asked

## Opus 4.7 Disruption

Opus 4.7 ships self-verification: "devises ways to verify its own outputs before reporting back."
- Evaluator agent may carry less weight now
- LangChain prediction: "harness components are a bet on what the model can't do yet... some will be absorbed into the model"

## Contradictions / Tensions
> [!contradiction]
> ThoughtWorks argues you need both computational guides AND sensors. But Vercel's result (delete 80% of tools → better performance) suggests minimal harness outperforms maximal harness for certain task types. Resolution: harness size should match task complexity + model capability.

## Connections
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]] — core concept page
- [[03-RESOURCES/entities/Claude-Opus-47]] — Opus 4.7 self-verification
- [[03-RESOURCES/sources/clipping-ahe-paper-fudan-nexau]] — academic counterpart (AHE paper)
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — Anthropic Planner/Generator/Evaluator

---

## Análise Comparativa das Três Abordagens

### O que une OpenAI, Anthropic e ThoughtWorks

Apesar de abordagens diferentes, as três convergem em um princípio: o ambiente em que o agente opera é tão importante quanto o modelo. A frase de Vivek Trivedy resume bem — se você não é o modelo, você é o harness. Isso significa que toda decisão de arquitetura (quais ferramentas dar ao agente, como estruturar o código, como verificar o trabalho) é uma decisão de harness.

### Por Que a Abordagem OpenAI é Mais Escalável

O método OpenAI (encode rules as code, not prose) resolve um problema fundamental: CLAUDE.md tem ~80% de compliance. Linters têm 100%. Se você quer que o agente nunca faça um import na direção errada na arquitetura em camadas, escrever isso no CLAUDE.md significa 1 em 5 vezes ele vai ignorar. Escrever um teste que falha quando o import está errado garante que o CI/CD detecta a violação antes do merge.

A ideia de "linters escritos pelo próprio Codex" fecha o loop: o agente que vai ser constrangido por essas regras também as escreve, garantindo que as regras são tecnicamente corretas e cobrem os casos reais que o agente enfrenta.

### Por Que o Padrão GAN da Anthropic Não é Óbvio

A escolha de modelar o harness em GAN (Generative Adversarial Network) em vez de, por exemplo, um reviewer agent simples, está na natureza do problema de avaliação. Um reviewer agent com acesso ao mesmo modelo e similar capacidade tende a ser leniente — os mesmos vieses que levam o gerador a considerar seu trabalho bom levam o reviewer a concordar.

O truco da Anthropic é treinar o evaluator para ser explicitamente cético, usando few-shot examples de outputs ruins recebendo scores altos (casos onde a leniência é claramente errada). Isso calibra o evaluator contra seu viés natural de concordância.

### O Insight Contraintuitivo do Vercel

Deletar 80% das ferramentas do agente e obter melhor performance parece paradoxal. A explicação está em como os modelos selecionam ferramentas: com muitas opções disponíveis, o modelo gasta tokens avaliando qual ferramenta usar para cada sub-tarefa. Com poucas opções, a decisão é trivial e os tokens são aplicados ao trabalho real.

Há também um efeito de qualidade: ferramentas demais criam o problema de "quando tudo é uma ferramenta, nada é uma ferramenta". O agente começa a usar ferramentas subótimas para tarefas onde a solução óbvia seria mais simples.

O corolário para design de harness: não adicione uma ferramenta sem evidência de que o agente precisa dela. O default deve ser nenhuma ferramenta, não todas as ferramentas disponíveis.

### ThoughtWorks: O Framework Mais Generalizável

A distinção Guide vs Sensor × Computational vs Inferential é o framework mais abstrato e portável das três abordagens. Qualquer harness pode ser auditado com essa lente:

| Quadrante | Exemplo | Pergunta |
|-----------|---------|----------|
| Computational Guide (before) | AGENTS.md com regras de arquitetura | "O que o agente deve seguir antes de começar?" |
| Computational Sensor (after) | Testes unitários, linters | "O que detecta erros objetivos depois?" |
| Inferential Guide (before) | System prompt com exemplos de qualidade | "Que julgamento queremos que o agente faça?" |
| Inferential Sensor (after) | LLM-as-judge, evaluator agent | "Como verificamos julgamento subjetivo?" |

O diagnóstico de times com 3 sensores computacionais e zero guias computacionais explica por que tantos setups de CI/CD detectam problemas mas não previnem categorias inteiras de erros.

### Implicação da Auto-Verificação do Opus 4.7

Se o modelo passa a verificar seu próprio output de forma confiável, o evaluator agent (um dos componentes mais caros do harness) se torna redundante para casos não-fronteiriços. O harness encolhe, não expande. Isso confirma o princípio de Anthropic: "quando um modelo novo aterrar, re-examine o harness e remova componentes que o modelo agora suporta nativamente."

O espaço de combinações interessantes de harness não desaparece — mas migra. Capacidades que requeriam infraestrutura externa passam a ser intrínsecas ao modelo; novas capacidades do modelo abrem possibilidades de harness que antes não eram viáveis.
