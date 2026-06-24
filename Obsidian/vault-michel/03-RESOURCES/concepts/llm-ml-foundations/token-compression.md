---
title: token-compression
type: concept
created: 2026-06-06
updated: 2026-06-19
tags: [token-economy, compression, context-engineering, llm, rtk]
status: developing
---

# Token Compression

Arte de reduzir o volume de tokens que chega ao LLM sem perder informação útil. Camada ortogonal ao context engineering — não trata do *que* entra, mas do *tamanho* do que entra.

## Stack de Compressão (vault-michel)

Duas ferramentas complementares, atuam em camadas diferentes:

| Ferramenta | Camada | Mecanismo | Saving |
|-----------|--------|-----------|--------|
| **RTK** (Rust Token Killer) | Shell outputs | Reescreve comandos shell via hook; filtra outputs antes de chegar ao harness | ~30–60% |
| **Headroom** (`chopratejasheadroom`) | Tool outputs / logs / RAG chunks | Compressão semântica reversível via hash-keyed cache; library + proxy + MCP | 60–95% (logs/RAG) · **net-negativo p/ code agents** |

**Relação explicitada pela source:** "RTK reescreve shell output (hook level); Headroom comprime everything downstream." Stacks são não-sobrepostos. Usar os dois = compressão máxima **em logs/RAG**.

> ⚠️ **Caveat code agents (2026-06-19, Hermes):** o mecanismo CCR (remove+retrieve) do Headroom é **net-negativo** quando o agente recupera o que foi removido — só 2.5% gated em uso real. Para tool outputs de código, a densificação lossless nativa (abaixo) supera o Headroom. Headroom vale onde o conteúdo é descartável após resumo (logs de build, chunks de RAG), não onde o agente re-consulta.

## Por que Comprimir?

1. **Custo**: tokens no input custam; KV cache só ajuda em prefix estático
2. **Lost-in-middle**: performance cai >30% com contextos longos não priorizados
3. **Latência**: menos tokens = first token mais rápido
4. **Confiabilidade**: agente com contexto focado faz menos erros de integração

## Técnicas

### Compressão Semântica (Headroom)
- Hash-keyed cache: compressão reversível via ID + dicionário local
- Não degrada informação — decomprime exatamente o original
- Funciona como proxy transparente entre tool e LLM
- Ideal para: logs de build, output de APIs, chunks de RAG

### Filtragem de Shell Output (RTK)
- Hook reescreve todos os comandos shell antes de execução
- Remove ANSI codes, trunca output excessivo, filtra ruído
- Transparente para o agente — não altera comportamento, só tamanho

### Densificação Lossless Nativa (no tool)
- Comprimir a saída **dentro da própria ferramenta**, antes de chegar ao agente — não via proxy externo
- Path-grouping de JSON repetitivo: agrupar chaves comuns em vez de repetir estrutura por item
- **Lossless** — zero perda de informação, agente não precisa re-consultar (evita o net-negativo do CCR)
- Zero dependências externas; venceu Headroom em code agent real (57.8% vs 2.5%) — ver Evidências
- Regra: preferir densificar na fonte > comprimir downstream quando o agente re-lê o conteúdo

### Compressão Estrutural (manual)
- Substituir listas de K items por `K items: [top 3, ...N remaining]`
- Colapsar blocos repetitivos em templates com placeholders
- Usar índices com wikilinks em vez de conteúdo inline

### hot.md como Contexto Pré-Comprimido
- Hot cache = compressão humana de estado do vault em <200 linhas
- Layer 2 de memória (Knowledge) já em formato comprimido para o agente
- Modelo de compressão por importância, não por tamanho

## Métricas de Referência

- Headroom: 60–95% redução de tokens em tool outputs/RAG, mesmas respostas
- RTK: ~30% saving em sessões de desenvolvimento intenso (histórico vault-michel)
- Backend AI-legível: 10.4M → 3.7M tokens (2.8x) sem mudar modelo ou prompt — ver [[ai-legible-backend]]
- Prompt caching: prefix estático com 90% desconto — complementar (reduce cost, não volume)

## Quando NÃO comprimir

- Documentos FIAP / estudo: preservar completude > eficiência de tokens
- Source pages do vault: "Preservar informação > condensar" (pipeline-diario princípio)
- Evidências para auditing: logs de segurança devem ser integrais

## Fontes

- [[03-RESOURCES/sources/chopratejasheadroom-compress-tool-outputs-logs-files-and-rag-chunks-before-they-reach-the-llm-60-95-fewer-tokens-same-answers-library-proxy-mcp-server]]
- [[03-RESOURCES/sources/how-to-make-agentic-workflows-100x-cheaper-full-guide]]

## Evidências
- **[2026-06-19]** Avaliação do headroom em agente de código real (Hermes): mecanismo CCR (remove+retrieve) é net-negativo porque o agente recupera o que precisa de volta; densificação lossless nativa de `search_files` (path-grouping de JSON repetitivo) entrega 57,8% de redução com zero dependências, superando o próprio headroom (2,5% gated) — [[03-RESOURCES/sources/hermes-search-files-densification-pr]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/agent-systems/token-economy]]
- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]]
