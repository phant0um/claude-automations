---
title: Vault Curation
type: concept
created: 2026-05-31
updated: 2026-05-31
tags: [pkm-obsidian, vault, curation, knowledge-quality]
---

# Vault Curation

Prática de manter a qualidade do vault removendo ativamente notas de baixa densidade semântica. Counterintuitivo para a cultura de "capture everything" — mas empiricamente demonstrado que remover ruído é equivalente a adicionar sinal: o mesmo AI com o mesmo prompt produz conexões de qualidade muito superior em vault curado vs. vault inflado.

## Por que curation importa para AI-assisted PKM

Com LLMs lendo o vault para encontrar conexões:
- **Vault inflado**: AI conecta notas por overlap lexical (palavras em comum), não por conexão semântica real
- **Vault curado**: AI conecta notas por afinidade conceitual genuína → insights acionáveis

O modelo não muda, o prompt não muda — só a qualidade do material que o AI atravessa.

## Critérios para curar (deletar ou arquivar)

Deletar/arquivar quando a nota é:
- Artigo clippado nunca relido
- Highlight que "soou bem" mas não foi acionado
- Voice note de pensamento semi-formado já agido ou esquecido
- Bookmark salvo por reflexo e nunca revisitado
- Conteúdo que pode ser recriado em 30 segundos se necessário

Manter quando a nota:
- Foi consultada ou referenciada >1×
- Contém argumento/dado específico não recuperável facilmente
- Conecta concretamente com outro conhecimento no vault

## Implementação no vault (triagem A/B/C/D)

O pipeline diário implementa curation preventiva:
- **A/B** → ingest (materializa como source page densa)
- **C** → arquiva sem ingest (informação existente mas sem source page)
- **D** → rejeita completamente

Isso evita acumular para depois ter que fazer curadoria retroativa.

## Evidência empírica

Caso real (Delete 90% paper): deletou 1890/2100 notas (90%) → manhã seguinte, AI conectou tese de adoção institucional de cripto com Federal Reserve working paper esquecido → artigo publicado. Antes: conexão por palavra "yield" entre dois artigos não relacionados.

## Vault

O 08-ARCHIVE/ serve como "cold storage" curado — fora do caminho principal do AI, mas preservado para consulta manual.

## Fontes

- [[03-RESOURCES/sources/delete-90-percent-obsidian-notes]]
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
