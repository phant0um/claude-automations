# Golden Examples — Source Pages Score A

> Exemplos canônicos de source pages de alta qualidade para few-shot do ingest-agent.
> Cada exemplo mostra a estrutura esperada: frontmatter → tese central → argumentos → key insights → exemplos/evidências → implicações para o vault → links.

## Seleção

3 source pages Score A do batch 2026-06-22, validadas no spot-check F2.8 do relatório semanal:

1. **atommem** — exemplo de paper acadêmico (tese técnica densa, benchmark, arquitetura)
2. **evals-strategic-ip** — exemplo de article (tese executiva, convergência, sem benchmark)
3. **how-to-build-a-solo-company** — exemplo de practical guide (sistemas concretos, código, implicações diretas)

## Estrutura Canônica (todo Score A deve ter)

```
frontmatter (title, type:source, source, created, ingested, tags)
## Tese central        — 1-2 parágrafos, não-condensados, capturam o argumento único da source
## Argumentos principais — bullets estruturados, cada um com claim + evidência
## Key insights         — 3-5 bullets, o que não é óbvio lendo o título
## Exemplos e evidências — dados concretos, números, quotes, configs
## Implicações para o vault — como conecta com concepts/agents/sistemas existentes
## Links                — wikilinks para concepts absorvidos
```

## Critérios de Qualidade Score A

| Critério | O que verificar |
|----------|-----------------|
| Tese central presente | Primeira seção responde "o que esta source argumenta?" em 1-2 parágrafos |
| Não-condensado | Tese não é summary genérico — captura o argumento único, específico desta source |
| Argumentos estruturados | Cada bullet é claim + evidência, não claim isolado |
| Key insights não-óbvios | Insights que não aparecem no título/abstract — exigem leitura real |
| Evidências concretas | Números, quotes, configs, benchmarks — não impressões |
| Implicações para o vault | Conexão explícita com concepts/agents/sistemas existentes (não genérica) |
| Wikilinks resolvem | Links apontam para paths que existem no vault |
| Tags apropriadas | Mínimo 1 tag temática |
| Sem artefatos de conversão | Sem "Índice", "Sumário", headers de PDF, page numbers |

## Example 1: Paper Acadêmico

**Source:** [[03-RESOURCES/sources/atommem-building-simple-and-effective-memory-system-for-llm-agents-via-atomic-facts]]
**Tipo:** Paper (arxiv-style)
**Tamanho:** ~7.3KB

### Por que é Score A

- Tese central densa e específica: define o dilema fundamental (raw vs condensado), posiciona a solução (fatos atômicos), e cita o benchmark (LoCoMo SOTA) — tudo em 1 parágrafo
- Argumentos estruturados por componente do sistema (não por seção do paper): cada bullet explica O QUE o componente faz e POR QUE difere do estado da arte
- Evidências concretas: F1 scores, BLEU, Jaccard, custo em tokens comparado com baselines
- Key insights não-óbvios: RWR sobre grafo heterogêneo, AtomMem-Flat já é competitivo (722K vs 21.3M tokens), fact verification com merge/update apenas em conflito
- Implicações: atualiza 3 concepts existentes (llm-memory-systems, agent-memory-architecture, agent-memory-four-layers), posiciona como contraponto a Mem0 e MemGPT

### Padrão a replicar

Papers acadêmicos devem capturar a **arquitetura** (não o abstract), o **benchmark** (números reais), e o **insight estrutural** (o que não é óbvio). A implicações devem conectar com concepts existentes e posicionar a source no landscape.

## Example 2: Article (Tese Executiva)

**Source:** [[03-RESOURCES/sources/evals-the-strategic-ip-that-will-define-the-next-era-of-ai]]
**Tipo:** Article (non-academic)
**Tamanho:** ~3.8KB

### Por que é Score A

- Tese central concisa e provocativa: evals = IP estratégica, não checagem pré-launch
- Argumentos estruturados nos 5 pilares do artigo, cada um com o "por quê"
- Key insights não-óbvios: "you get what you pay for" como contraponto a routing-para-economizar, convergência Nadella + Handshake + AlphaEval
- Evidências: citação de Satya Nadella, posição de Handshake como provedor
- Implicações: reforça concept existente (agent-evaluation-production) com tese executiva complementar à técnica

### Padrão a replicar

Articles sem benchmark devem compensar com **tese clara e provocativa**, **convergência de fontes** (quem mais diz isso?), e **conexão com o vault** (como complementa ou contradiz o que já temos).

## Example 3: Practical Guide

**Source:** [[03-RESOURCES/sources/how-to-build-a-solo-company-with-claude-code-9-systems-that-run-it]]
**Tipo:** Practical guide / tutorial
**Tamanho:** ~5.5KB

### Por que é Score A

- Tese central: leverage vem de sistemas autônomos, não de headcount
- Argumentos estruturados por sistema (9 sistemas em 3 tiers), cada um com o que faz + onde o humano permanece
- Key insights não-óbvios: "agente que avalia próprio trabalho é sistema confiante, não confiável", "modelo top-tier para tudo é P&L sangrando silenciosamente"
- Evidências concretas: snippets de CLAUDE.md, reviewer subagent config, CI headless, permissões JSON, STATE.md
- Implicações: conecta com 4 concepts existentes (solo-saas-stack-2026, generator-verifier-loop, company-brain, subagent-spawning)

### Padrão a replicar

Guides práticos devem capturar a **estrutura dos sistemas** (não o passo-a-passo), o **código/config real** (não paráfrase), e as **fronteiras humano-agente** (onde o humano permanece intencionalmente).

## Anti-padrões (o que NÃO fazer)

| Anti-padrão | Exemplo | Correção |
|-------------|---------|----------|
| Tese genérica | "Este artigo fala sobre IA" | Tese deve capturar o argumento único |
| Summary sem insight | Repete o abstract do paper | Key insights devem ser o que não está no título |
| Sem implicações para o vault | "Relevante para agentes" | Conectar com concepts/agents específicos |
| Links quebrados | `[[concepts/foo]]` que não resolve | Verificar path antes de linkar |
| Condensação artificial | "O artigo discute vários aspectos" | Preservar a informação real |
| Artefatos de PDF | "Índice", "Sumário", page numbers | Limpar na ingestão |