---
title: "Weekly Knowledge Routine"
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-09
tags: [concept, knowledge-management, produtividade, rotinas, pkm]
---

# Weekly Knowledge Routine

Framework de gestão de conhecimento baseado em rotinas semanais fixas, onde cada domínio de interesse tem um slot de calendário, um prompt recorrente e um destino de armazenamento definido.

## Estrutura

```
Domínio → Slot (dia/hora) → Prompt fixo → Saída → Destino
```

**Destinos possíveis:**
- Consumir e descartar (notícias, cultura)
- Salvar em nota semanal (tech, finanças)
- Acumular em NotebookLM como fonte cumulativa (jurisprudência, editais, carteira, AI agents)

## Benefícios

- Elimina "não sei por onde começar" — o calendário decide
- Saída padronizada permite comparação semana a semana
- Separação consumível vs acumulável evita noise em bases de conhecimento de longo prazo
- Tempo de leitura controlado (cada prompt produz 8–12 min de conteúdo)

## Implementação com Perplexity

A implementação mais desenvolvida usa o [[03-RESOURCES/entities/Perplexity-AI]] como motor de busca + síntese. Ver [[03-RESOURCES/concepts/pkm-obsidian/perplexity-routine]] e [[03-RESOURCES/sources/guides-courses-howtos/prompts-perplexity-rotinas-semanais-otimizadas]] para a coleção completa de 14 prompts.

## Conexões

- [[03-RESOURCES/concepts/pkm-obsidian/hot-cache]] — o briefing diário (#1) alimenta o hot cache do vault
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] — rotinas semanais são o mecanismo de ingestão regular do second brain
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] — conteúdo acumulável gera retorno crescente sobre o investimento de tempo semanal

## Evidências
- **[2026-06-19]** Loop noturno de docs sweep / changelog é padrão direto aplicável a ingest-report semanal deste vault — [[03-RESOURCES/sources/loop-library-repeatable-ai-agent-workflows]]
