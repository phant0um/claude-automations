---
title: "Do AGENTS.md Files Actually Help Coding Agents?"
type: source
source: "Clippings/Do AGENTS.md Files Actually Help Coding Agents?.md"
author: "[[03-RESOURCES/entities/rasbt]]"
published: 2026-06-07
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, agents-md, claude-md, coding-agents, research, harness-engineering]
paper: "https://arxiv.org/abs/2602.11988"
---

# Do AGENTS.md Files Actually Help Coding Agents?

Thread do [@rasbt](https://x.com/rasbt/status/2063649136323252397) resumindo o paper *"Evaluating AGENTS.md: Are Repository-Level Context Files Helpful for Coding Agents?"* (arXiv 2602.11988).

---

## Tese central

Arquivos de instrução em nível de repositório — AGENTS.md, CLAUDE.md — **não aumentam consistentemente** o sucesso de agentes de código. LLM-generated context files reduzem ligeiramente a taxa de sucesso ou não fazem diferença significativa. Developer-written files são melhores, mas ainda carregam custo de eficiência.

---

## Argumentos principais

1. **LLM-generated context files ≤ no context file** — o agente já reconstrói o contexto necessário on-the-fly; o arquivo apenas adiciona redundância.
2. **Developer-written > LLM-generated** — domain expertise conta; os arquivos escritos por humanos trazem conhecimento não derivável só do código.
3. **No context file = mais eficiente** — surpreendentemente, ausência de arquivo de contexto resulta em menor consumo de tokens/ferramentas nos benchmarks.
4. **Agentes seguem as instruções** — trace analysis confirmou que os agentes leem e executam os arquivos; o problema não é ignorância, é que as instruções adicionam passos que não convertem em sucesso.

---

## Key insights

- Context files fazem agentes **rodar mais testes, buscar mais arquivos, usar mais ferramentas** — thoroughness ≠ success.
- A hipótese inicial ("talvez ignorem o arquivo") foi refutada pela análise de trace.
- Recomendação do @rasbt: context files devem ser **curtos, específicos e preferencialmente hierárquicos** (e.g., "se fizer X, consulte y.md; caso contrário, ignore").
- Caveat: modelos e harnesses do paper são datados — resultados podem mudar com harnesses modernos.

---

## Exemplos e evidências

**Benchmarks utilizados:**
- **SWE-bench Lite** — context files gerados por LLM (repositórios originais sem arquivos nativos).
- **AGENTBENCH** — novo benchmark, 138 tarefas Python de 12 repositórios com arquivos escritos por desenvolvedores. Três condições: sem arquivo / LLM-gerado / developer-written.

**Resultados (Figure 1):**
- LLM-generated: redução leve ou neutra vs. no-file.
- Developer-written: melhor que LLM-generated, mas ainda com custo de eficiência (Figure 2).

---

## Implicações para o vault

- **CLAUDE.md do vault:** o fato de developer-written > LLM-generated valida a manutenção ativa do CLAUDE.md pelo próprio Michel — não delegar geração automática.
- **Tamanho e hierarquia:** a recomendação de context files curtos e hierárquicos é consistente com o limite de 200 linhas do CLAUDE.md atual e com o design de skills modulares do vault.
- **Harness-bound vs. model-bound:** resultado "no-file = mais eficiente" reforça [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]] — o harness reconstruindo contexto é overhead desnecessário se o model já o infere.
- **Harness engineering:** adicionar ao [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — arquivos de contexto são uma variável de design do harness, não um free lunch.

---

## Links

- Paper: [arXiv 2602.11988](https://arxiv.org/abs/2602.11988)
- Autor: [[03-RESOURCES/entities/rasbt]]
- Benchmark relacionado: [[03-RESOURCES/entities/SWE-Bench-Verified]]
- Conceitos relacionados: [[03-RESOURCES/concepts/agent-systems/harness-engineering]] · [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]] · [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
