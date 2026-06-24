---
title: "10 Token Waste Patterns — @DeRonin_"
type: source
source_file: Clippings/Post by @DeRonin_ on X.md
origin: post no X
author: "@DeRonin_"
published: 2026-05-12
ingested: 2026-05-14
tags: [token-economics, cost-optimization, model-routing, kimi, prompt-caching, context-discipline]
triagem_score: 8
---

# 10 Token Waste Patterns — @DeRonin_

> [!key-insight] Core insight
> Cita Karpathy: "90% da sua conta de AI coding é pagar pelo contexto que você não precisava enviar." O fix real é context discipline + routing multi-modelo — não economizar no modelo certo, mas parar de usar o modelo errado para a tarefa errada.

## Sections

### 10 Desperdícios Identificados

| # | Problema | Custo | Fix |
|---|----------|-------|-----|
| 1 | Auto-load de 50 arquivos para fix de 30 linhas | $1.20/turno | Grep first, turn off auto-context |
| 2 | Opus em lint/format/rename | $0.60 vs $0.02 com Haiku | Routing por task type |
| 3 | Tool call loops que re-enviam repo completo | 5x custo por fluxo | Batch tool calls; fix iteração |
| 4 | Sonnet como padrão em 2026 | Paga 6x vs Kimi 2.6 para mesma qualidade | Switch default para Kimi 2.6 |
| 5 | Streaming em workflows com prefixo estável | Mata prompt cache; 10x custo | Batch para agentes de background |
| 6 | Inclusões "por via das dúvidas" | 80k tokens vs 3k necessários | Zero incluíssões desnecessárias |
| 7 | Reconstrução de ambiente por sessão | $4 vs $0.30 com SKILL.md | Escrever SKILL.md uma vez |
| 8 | Modelo único para todas as tarefas | Premium em toda task | Routing: Opus 10%, Kimi 90%, Haiku limpeza |
| 9 | 10 perguntas pequenas separadas | 10x cobrança de prefixo | Batch em 1 chamada |
| 10 | 3 assinaturas premium (Claude + ChatGPT + Cursor) | Paga por hábito, não utilidade | Escolher 1 real |

### O Que Realmente Acumula Valor

- **Context discipline**: grep antes de buscar, sempre
- **Prompt caching** em todo prefixo estável
- **Routing multi-modelo**: Kimi 2.6 padrão; Opus para os 10% que precisam
- **SKILL.md graduados**: eliminar fase de discovery a cada execução
- **Profiling de tool calls** antes de otimizar prompts
- **Mentalidade de routing**: modelo certo para tarefa certa

### Insight de Longo Prazo

> "Em 12 meses, a diferença entre devs que gastam $200/mês e $4.000/mês não será habilidade — será o quão bem eles roteiam."

## Conexões

- [[03-RESOURCES/entities/DeRonin]] — autor; @DeRonin_ no X
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — técnica #1 de saving
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — SKILL.md elimina reconstrução de ambiente
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — context discipline é o lever principal
- [[03-RESOURCES/concepts/model-routing]] — routing multi-modelo como skill core
- [[03-RESOURCES/entities/Kimi-K2.6]] — modelo workhorse recomendado como default
- [[03-RESOURCES/sources/token-economy-cost/cut-ai-coding-bill-80-deron]] — guia completo anterior do mesmo autor

## Análise dos 10 Desperdícios — Por Que Cada Um Acontece

### #1: Auto-load de contexto excessivo

A causa raiz: ferramentas com auto-context (Cursor, Claude Code com configuração padrão) tentam ser úteis carregando o máximo de arquivos possivelmente relevantes antes de cada interação. Para um fix de 30 linhas, "possivelmente relevante" pode incluir 50 arquivos de importações transitivas.

O problema não é a ferramenta — é a ausência de uma instrução explícita de escopo. Com `grep first, turn off auto-context`, o usuário especifica exatamente quais arquivos são necessários antes que a ferramenta decida por ele. O custo cai de $1.20 para $0.03 por turno porque 47 dos 50 arquivos eram irrelevantes.

**Fix operacional:** antes de iniciar qualquer task, rodar `grep -rn "symbol_or_function" .` para identificar os 2-3 arquivos realmente relevantes. Mencionar esses arquivos explicitamente no prompt. Desligar auto-context ou restringir a pasta.

### #2: Modelo premium para tarefas triviais

O mismatch entre complexidade da tarefa e capacidade do modelo é sistemático porque a maioria dos workflows usa o mesmo modelo para todas as tasks em uma sessão. Nenhuma pessoa consciente escolheria Opus para renomear uma variável — mas em uma sessão de coding, o agente usa o modelo padrão da sessão, independente da task.

**A diferença de custo:** Haiku vs. Opus para uma operação de rename simples:
- Haiku: ~$0.001 para um rename trivial
- Opus: ~$0.06 para o mesmo rename
- Razão: 60×

Em uma sessão típica com 20 renames, imports, e formatações: economizar $1.18 × 20 = $23.60 apenas roteando essas tasks para Haiku.

### #5: Streaming vs. Batch para Cache

O streaming destrói o prompt cache porque cada request de streaming inicia com um timestamp diferente ou com estado de sessão diferente, invalidando o prefix match necessário para um cache hit.

Para tasks de background (processamento de documentos, análise de datasets, geração de reports), o streaming oferece zero benefício ao usuário final — não há UI esperando por tokens. Trocar para batch nesses contextos habilita prompt caching e reduz custo em até 10× para tasks com prefixo estável.

**Regra simples:** use streaming quando há uma interface humana esperando por tokens em tempo real. Use batch quando o output é processado por código ou entregue de uma vez.

### #7: Reconstrução de ambiente por sessão

O custo de $4 vs. $0.30 revela quanto contexto um agente precisa para entender o ambiente de trabalho antes de começar. Sem SKILL.md: o agente gasta tokens descobrindo quais frameworks estão instalados, quais convenções o projeto usa, quais arquivos não devem ser tocados, e qual é o processo de build/test.

Com SKILL.md: o agente recebe esse contexto como fato estabelecido no início da sessão — zero discovery necessária. O ganho de $3.70 por sessão se acumula: em 100 sessões/mês, são $370/mês economizados de um único arquivo de texto.

## O Caso Para Kimi 2.6 Como Default

A recomendação de substituir Sonnet (ou Opus) como modelo padrão por Kimi 2.6 para a maioria das tasks em 2026 é específica ao contexto de custo/performance. O argumento:

Em 2026, Kimi 2.6 oferece performance equivalente ao Sonnet de 2025 em coding tasks (benchmarks de código, raciocínio técnico) a uma fração do custo. A "mesma qualidade" não é uma afirmação absoluta — é uma afirmação específica para o cluster de tasks de desenvolvimento: refactoring, debugging, explicações de código, geração de testes.

**Quando Opus ainda justifica o custo:**
- Reasoning complexo sobre arquitetura de sistema
- Tarefas que requerem síntese de conhecimento de múltiplos domínios simultaneamente
- Outputs que serão consumidos por humanos em contextos de alta stakes (documentos legais, arquitetura de segurança)

**Quando Kimi 2.6 é adequado:**
- 90% das tasks diárias de coding e debugging
- Geração de código boilerplate com instruções claras
- Análise de logs e identificação de erros
- Escrita de testes unitários para funções bem-definidas

## Batching Multi-Chamadas — Economia de Overhead

O desperdício #9 (10 perguntas pequenas separadas = 10× cobrança de prefixo) refere-se ao overhead fixo de cada request: autenticação, context loading, system prompt. Para requests pequenas, este overhead fixo é uma porção substancial do custo total.

Para 10 perguntas de 50 tokens cada:
- **Separadas:** 10 × (overhead + 50 tokens) = 10 × 350 = 3.500 tokens
- **Batch (1 request com 10 perguntas):** 1 × (overhead + 500 tokens) = 1 × 800 = 800 tokens
- **Economia:** 77%

O limite prático do batching: perguntas que requerem a resposta de uma pergunta anterior não podem ser batched (dependência sequencial). Perguntas independentes sobre o mesmo tópico são sempre melhores em batch.

## A Previsão de 12 Meses — Implicações

A afirmação de que "em 12 meses, a diferença entre devs que gastam $200/mês e $4.000/mês não será habilidade — será o quão bem eles roteiam" posiciona model routing como uma competência de desenvolvimento de software, não uma otimização de custo opcional.

O argumento subjacente: modelos vão continuar melhorando, mas os preços em termos absolutos permanecem similares ou aumentam. A fronteira de custo não se move com a fronteira de capacidade — quem for inteligente no routing captura as economias; quem usar o modelo mais capaz para tudo paga o preço de 2026 indefinidamente.

Para vault-michel: a meta de token economy já implementada (RTK, hooks, context discipline) é o equivalente ao routing discipline descrito neste artigo. A próxima iteração seria model routing explícito por tipo de task: tasks de triagem e classificação de sources → modelo menor; síntese e geração de novos conceitos → Opus.
