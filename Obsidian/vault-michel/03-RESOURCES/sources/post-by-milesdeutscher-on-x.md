---
title: "Post by @milesdeutscher on X — How to give Claude perfect memory"
type: source
source: "Clippings/Post by @milesdeutscher on X.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, claude, memory, context-management, obsidian, pkm]
---

## Tese central
O problema de "memória" do Claude é essencialmente um problema de arquitetura de contexto, não de capacidade do modelo — e é resolvível em três camadas progressivas: limpeza básica de memória, sistema de arquivos de contexto estruturado, e segundo cérebro em Obsidian com wiki auto-evolutivo.

## Argumentos principais
- Claude como "black box": alimentado com contexto, esquece 80%, e o 20% que retém não é relevante — problema amplamente reconhecido
- Layer 1 (5 min): limpar Settings → Memory, preencher Project Instructions, usar comandos diretos mid-conversation ("Remember that I never want X", "Update your memory with X") — resolve 90% dos problemas
- Layer 2 (60 min): "Claude Master Folder" com Instructions.MD, Memory.MD, Context.MD e Archive semanal — anexar à sessão resolve perda de contexto entre conversas
- Layer 3 (avançado): Obsidian vault + Claude apontado para a pasta + system prompt do LLM Knowledge Base de Karpathy → wiki auto-evolutivo de tudo que o usuário pensa, escreve e pesquisa

## Key insights
- Memory.MD com instrução embutida "Update Memory.MD with my preferences over time" cria loop de auto-atualização sem depender de memória nativa do Claude
- Comentário de @stas_paradigma: "3 tight documents under 2k tokens each, tag by retrieval priority → 95%+ recall" — context architecture > context volume
- Comentário de @MicrotronX: o que Claude esquece primeiro não é aleatório — são as decisões do início da sessão (compactadas primeiro); contexto recente sobrevive, contexto antigo não
- Comentário de @SCRY: "Memory is storage. Intelligence is knowing what to retrieve" — retrieval architecture é o verdadeiro bottleneck
- @LinhDaoFintech: "true memory isn't a bigger context window — it's a retrieval system that knows what to keep"
- Referência explícita ao sistema de Karpathy no GitHub como fonte do system prompt para o setup Layer 3

## Exemplos e evidências
- @Crypto Update IO: rastreou 200k+ prompts e encontrou que memory decay acelera após 45 minutos a menos que estruturado com RAG ou prompts específicos
- Consenso nos comentários: estrutura de contexto tight (poucos docs, bem organizados) supera volume de contexto desestruturado
- O setup Layer 3 descrito é essencialmente o vault-michel atual — confirma que este vault é a solução "state of the art" para o problema

## Implicações para o vault
Este post valida externamente a arquitetura do vault-michel como implementação de referência da Layer 3 descrita. O conceito de Memory.MD como arquivo auto-evolutivo espelha o uso de `04-SYSTEM/wiki/hot.md` e MEMORY.md no vault. Reforça [[03-RESOURCES/concepts/externalized-memory]] e [[03-RESOURCES/concepts/agentic-memory-taxonomy]] com perspectiva de usuário final e dados de campo.

## Links
- [[03-RESOURCES/concepts/externalized-memory]]
- [[03-RESOURCES/concepts/agentic-memory-taxonomy]]
- [[03-RESOURCES/concepts/action-memory]]
- [[03-RESOURCES/concepts/context-rotation]]
- [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]]
- [[03-RESOURCES/concepts/memory-context-rag]]
