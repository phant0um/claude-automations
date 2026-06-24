---
title: "Your LLM Is Burning Through Tokens - Karpathy Found a Way to Save 90%"
type: source
source: "Clippings/Your LLM Is Burning Through Tokens - Karpathy Found a Way to Save 90%.md"
original_url: "https://x.com/bonsaixbt/status/2059266993950277656"
author: "@bonsaixbt"
published: 2026-05-26
created: 2026-05-29
ingested: 2026-05-29
tags: [ai-agents, karpathy, wiki-layer, token-efficiency, knowledge-base, obsidian]
---

## Tese central

O maior desperdício de tokens em LLMs não é geração — é reler os mesmos documentos brutos repetidamente. A solução de Karpathy (Wiki Layer) resolve isso processando fontes *uma vez* para uma wiki estruturada e interligada, depois operando exclusivamente sobre a wiki. Resultado: 70-90% de savings em queries repetidas e qualidade melhor.

## Argumentos principais

- Problema central: LLMs desperdiçam tokens re-lendo documentos brutos a cada sessão, perdem contexto entre arquivos, perdem relações importantes, e produzem respostas menos acuradas por isso
- Solução: processar uma vez para wiki limpa → parar de trabalhar com raw files; modelo opera sobre representação estruturada e interligada
- O sistema tem três componentes: `raw/` (imutável, source of truth), `wiki/` (markdown limpo gerado pelo LLM), e arquivos de instrução/templates
- O agente de estruturação faz: limpeza de lixo técnico/ads, conversão para markdown, aplicação de templates, criação de wikilinks `[[Page_Name]]`, adição de metadata e relações entre documentos
- Obsidian como frontend: ao abrir a pasta no Obsidian, você ganha grafo visual de conhecimento, busca full-text e navegação entre notas conectadas
- Workflow final: "Work with my Wiki database inside the wiki/ folder" — em vez de subir dezenas de arquivos toda vez
- O sistema é *auto-evoluível* — cada exploração que retorna à wiki melhora a base
- Privacy: tudo local, nada vai para cloud

## Key insights

- **Token efficiency como resultado de arquitetura, não de prompting:** A poupança vem de *não reler* raw files, não de prompts menores. É uma decisão de design de sistema.
- **Escalabilidade:** A base pode crescer para centenas ou milhares de documentos sem degradar — o modelo sempre interage com representação limpa e pré-processada
- **Wiki Layer + Obsidian = segundo cérebro funcional:** Combinar a pipeline com Obsidian transforma um conjunto de arquivos caóticos em um knowledge graph navegável com visual + busca
- **Saving de 70-90%:** Em queries repetidas sobre o mesmo corpus, o modelo não reprocessa nada — acessa diretamente a wiki
- **Templates e metadata padronizados:** Definir templates por tipo de documento (data, author, tags, summary) é o que torna a wiki interoperável com diferentes LLMs e queries
- **Quando usar:** 10-20+ documentos sobre o mesmo tópico, dados que mudam frequentemente, produção regular de conteúdo/pesquisa, informações confidenciais (permanece local)

## Exemplos e evidências

- Saving declarado: "up to 70-90% on repeated queries" — sem benchmark controlado, mas mecanismo é sólido
- Casos de uso mencionados: marketing, software development, learning, health, business analytics
- Atribuído a Andrej Karpathy como originador da ideia
- Abordagem se alinha com [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]] já documentado no vault

## Implicações para o vault

- Confirma e reforça [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]] — esta é mais uma fonte que descreve a mesma ideia de Karpathy, com foco em token savings em vez de knowledge management
- O vault *já implementa* este padrão (raw/ + wiki/ + Obsidian + agente de ingestão) — esta fonte é validação do design existente
- A versão "@bonsaixbt" é mais voltada para builders que ainda não usam este approach — pode ser útil como referência de onboarding
- Conecta com [[03-RESOURCES/concepts/agent-systems/token-economy]] — token savings de 70-90% são relevantes para custo de operação de agentes

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- [[03-RESOURCES/concepts/agent-systems/token-economy]]
- [[03-RESOURCES/entities/Andrej Karpathy]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/karpathy-llm-knowledge-bases]]
