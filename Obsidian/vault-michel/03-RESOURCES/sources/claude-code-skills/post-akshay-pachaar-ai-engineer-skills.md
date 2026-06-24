---
title: "Post @akshay_pachaar — O que um AI Engineer deve aprender"
type: source
source_file: Clippings/Post by @akshay_pachaar on X.md
origin: post no X (@akshay_pachaar)
ingested: 2026-05-14
tags: [ai-engineering, llm-ops, prompt-caching, observability, fine-tuning]
triagem_score: 8
---

# Post @akshay_pachaar — O que um AI Engineer deve aprender

> [!tip] Insight central
> AI Engineering vai muito além de prompt engineering: requer domínio de caching, observabilidade, roteamento, guardrails e decisões de fine-tuning vs. in-context learning.

## Lista de competências

- Leverage engineering (não só prompt engineering)
- Trade-offs: cache de prompts vs. cache semântico
- Gerenciamento de cache KV em escala
- Decodificação especulativa vs. quantização
- Falhas em saídas estruturadas + cadeias de fallback
- Avaliações: LLM-como-juiz + avaliações humanas
- Atribuição de custos por feature (não só por modelo)
- Guardrails de agentes + orçamentos de loop
- Observabilidade de LLM como disciplina de primeira classe
- Roteamento de modelos + lógica de fallback
- Fine-tuning vs. in-context learning

## Conexões

- [[03-RESOURCES/entities/Akshay-Pachaar]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]]

---

## Análise Detalhada de Cada Competência

### Leverage Engineering (não só prompt engineering)

A distinção central do post: prompt engineering é manipular o que você envia ao modelo. Leverage engineering é amplificar o output do modelo com o mínimo de esforço. Isso inclui caching, batching, routing, e design de harness — não apenas o texto do prompt.

Um AI engineer que só sabe escrever prompts tem 1/10 do leverage de alguém que sabe orquestrar o sistema completo.

### Cache de Prompts vs. Cache Semântico

**Cache de prompts (KV cache):** O servidor do modelo armazena a computação de atenção para porções fixas do prompt. Chamadas subsequentes com o mesmo prefix não recomputam atenção para essa porção. Reduz latência em 40-80% e custo em 80-90% para tokens em cache.

**Cache semântico:** Sistema externo que armazena responses completos por query. Queries semanticamente similares retornam response em cache sem chamar o modelo. Útil para queries repetitivas (FAQ, explicações padrão), mas requer threshold de similaridade calibrado para evitar responses incorretos para queries ligeiramente diferentes.

**Quando usar qual:**
- KV cache: sempre, especialmente com CLAUDE.md/system prompts longos e estáticos
- Cache semântico: quando há alta repetição de queries idênticas ou quase-idênticas

### Gerenciamento de Cache KV em Escala

KV cache tem TTL (time-to-live) — no Anthropic, ~5 minutos. Para manter cache quente em produção de alto volume, é necessário:
- Estruturar prompts para máximo prefix compartilhado entre requests
- Medir taxa de cache hit (disponível via API response headers)
- Entender que mudanças no início do prompt invalidam cache de toda a sequência subsequente

### Decodificação Especulativa vs. Quantização

**Decodificação especulativa:** Modelo menor (draft model) gera tokens rapidamente; modelo maior verifica e aceita/rejeita. Throughput aumenta sem perda de qualidade do modelo maior. Custo intermediário.

**Quantização:** Reduz precisão dos pesos do modelo (float32 → int8 → int4). Reduz custo e latência com pequena perda de qualidade. Aplicável a modelos self-hosted; APIs geralmente já quantizam internamente.

**Para AI engineers:** Quantização é mais relevante para modelos self-hosted (Llama, Mistral). Decodificação especulativa é relevante para quem controla infraestrutura de inferência.

### Falhas em Saídas Estruturadas + Cadeias de Fallback

Saídas estruturadas (JSON, XML, código) falham por 3 razões:
1. Modelo viola o schema (campo faltando, tipo errado)
2. Resposta parcial truncada por max_tokens
3. Resposta válida mas semanticamente incorreta (campo com valor nonsense)

Cadeia de fallback recomendada:
1. Tentar parse da resposta → sucesso: retornar
2. Tentar correção automática (regex, pós-processamento) → sucesso: retornar
3. Retry com prompt corrigido (incluir o erro do parse) → sucesso: retornar
4. Fallback para modelo diferente → sucesso: retornar
5. Retornar erro explícito com contexto (não silenciar)

### LLM-como-Juiz vs. Avaliações Humanas

**LLM-como-juiz:** Outro modelo avalia a output. Rápido, barato, escalável. Porém: o juiz pode ter os mesmos vieses do modelo avaliado; não detecta "convincentemente errado".

**Avaliações humanas:** Ground truth mas caras, lentas, não escaláveis. Necessárias para calibrar o LLM-como-juiz.

**Prática:** Use LLM-como-juiz para monitoramento contínuo em produção; use avaliação humana para calibrar o juiz e para decisões críticas de produto.

### Atribuição de Custos por Feature

Em vez de medir "custo por chamada de API", medir "custo por feature" (ex: custo do autocomplete vs. custo do gerador de relatórios). Permite priorizar otimizações onde o ROI é maior.

Implementação: logging estruturado com feature_id em cada request + análise de custos por feature_id.

### Guardrails de Agentes + Orçamentos de Loop

**Guardrails:** Verificações determinísticas que protegem contra comportamentos problemáticos independente do que o modelo decide. Ex: bloquear tool calls para paths fora do escopo, limitar tamanho de respostas.

**Orçamento de loop:** Todo agente deve ter limite de steps máximos por task. Sem orçamento, loops infinitos são possíveis. Implementação: contador de steps no harness, não no prompt.

### Observabilidade de LLM como Disciplina de Primeira Classe

Tracing de LLM deve capturar: latência por call, tokens in/out, taxa de cache hit, modelo usado, versão do prompt, feature_id, user_id, resultado (sucesso/falha/parcial). Sem isso, debugging de problemas em produção é impossível.

Ferramentas: LangSmith, Langfuse, OpenTelemetry + custom spans.

### Roteamento de Modelos + Lógica de Fallback

Nem toda query precisa de Claude Opus 4. Roteamento inteligente:
- Query simples → modelo pequeno (Claude Haiku, GPT-4o-mini)
- Query complexa → modelo grande (Claude Opus, GPT-4o)
- Query que falhou no modelo pequeno → retry com modelo grande

Roteador pode ser baseado em: tamanho da query, keywords, classificador treinado, ou score de complexidade.

### Fine-tuning vs. In-context Learning

**In-context learning:** Incluir exemplos no prompt. Simples, sem infraestrutura, mas consome tokens em cada call e tem limite de exemplos.

**Fine-tuning:** Treinar o modelo em exemplos. Custo upfront mas exemplos não consomem tokens em produção. Justificado quando: exemplos são muitos (>50), pattern é muito específico, ou latência de contexto longo é inaceitável.

**Regra prática:** Comece com in-context, faça fine-tuning apenas quando tiver evidência empírica de que o gain justifica o custo.

---

## Conexões Adicionais

- [[03-RESOURCES/sources/claude-code-skills/claude-code-5-layer-architecture-2026]] — leverage engineering em prática
- [[03-RESOURCES/sources/ai-agents-harness/how-claude-code-works-in-large-codebases]] — harness matters as much as model
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching-patterns]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
