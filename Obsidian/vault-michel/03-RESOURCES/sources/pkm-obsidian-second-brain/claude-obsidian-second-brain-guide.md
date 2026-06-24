---
title: "Claude + Obsidian | How to use your second brain"
type: source
formato: article
author: "@defileo"
source_url: https://x.com/defileo/status/2042241063612502162
fetched: 2026-04-14
tags: [obsidian, claude, pkm, second-brain, setup-guide]
triagem_score: 9
---

# Claude + Obsidian | How to use your second brain

Guia completo de setup do [[03-RESOURCES/entities/claude-obsidian|claude-obsidian]] — plugin para Claude Code que transforma um vault Obsidian em uma wiki persistente e composta automaticamente.

## Tese central

A maioria das ferramentas Obsidian + IA apenas fazem "chat sobre o vault" — você ainda escreve as notas, faz os links, faz a manutenção. O claude-obsidian segue o [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern|LLM Wiki Pattern]] de Karpathy: você joga uma fonte, o Claude constrói e mantém a wiki.

## Pré-requisitos

- [[03-RESOURCES/entities/Obsidian|Obsidian]] (gratuito)
- Node.js v18+ 
- [[03-RESOURCES/entities/Claude Code|Claude Code]] (CLI)

## Instalação

```bash
claude plugin marketplace add AgriciDaniel/claude-obsidian
claude plugin install claude-obsidian@claude-obsidian-marketplace
```

## Os 3 comandos principais

| Comando | O que faz |
|---------|-----------|
| `/save` | Arquiva a conversa atual como páginas wiki |
| `/autoresearch [tópico]` | 3–5 rodadas de pesquisa web → páginas wiki |
| `/canvas [descrição]` | Cria canvas visual com os nós relevantes do vault |

## Loop diário de ingestão

1. Jogar fonte em `.raw/`
2. `ingest [arquivo]`
3. Claude cria 8–15 páginas interligadas com média de 12 wikilinks

## Como mantém o custo baixo

Ver [[03-RESOURCES/concepts/pkm-obsidian/hot-cache|Hot Cache]]: três arquivos carregados em ordem — `hot.md` (~500 tokens), `index.md` (uma linha por página), páginas relevantes apenas.

## O que diferencia o LLM Wiki Pattern de "chat sobre notas"

A distinção crucial é quem escreve. Na maioria dos setups Obsidian + IA, o usuário escreve as notas e a IA responde perguntas sobre elas. No LLM Wiki Pattern (cunhado por Karpathy), o LLM constrói e mantém a wiki. O usuário fornece fontes brutas — artigos, clippings, conversas — e o Claude extrai entidades, cria páginas, adiciona wikilinks, e mantém consistência entre páginas existentes.

O resultado é knowledge compounding: cada ingestão não apenas adiciona uma nova página, mas potencialmente enriquece 5–15 páginas existentes com novos wikilinks e contexto cruzado. Com o tempo, o grafo de conhecimento se torna mais denso e útil exponencialmente — não linearmente.

## Como o Hot Cache mantém o custo controlado

Sem o hot cache, cada sessão começaria carregando todas as páginas relevantes do vault — potencialmente centenas de KB de contexto. O hot cache inverte isso: Claude carrega apenas 3 arquivos em ordem:

1. `hot.md` (~500 tokens) — resumo das páginas mais acessadas recentemente + índice de navegação
2. `index.md` — uma linha por página do vault (título + tipo + tags)
3. Apenas as páginas explicitamente referenciadas na tarefa atual

Para a maioria das sessões, isso significa que Claude nunca lê mais de 20–30 páginas completas, mesmo em vaults com centenas de notas. O custo permanece proporcional à complexidade da tarefa, não ao tamanho do vault.

## Os 3 comandos em detalhe

### `/save` — Arquivar a conversa

Converte uma conversa em páginas wiki estruturadas. Claude analisa o que foi discutido, identifica entidades e conceitos novos ou referenciados, cria ou atualiza páginas para cada um, e adiciona wikilinks cruzados. Uma conversa de 30 minutos sobre um tópico pode resultar em 5–8 páginas novas e 10–20 atualizações em páginas existentes.

### `/autoresearch [tópico]` — Pesquisa autônoma

Lança 3–5 rodadas de pesquisa web sobre o tópico, sintetizando os resultados em páginas wiki. Cada rodada refina o que foi encontrado na anterior — o agente identifica o que ainda está faltando no vault e direciona a próxima rodada para preencher as lacunas. O resultado é um conjunto de páginas interligadas que cobre o tópico de forma mais completa do que qualquer fonte única.

### `/canvas [descrição]` — Visualização

Cria um canvas Obsidian com os nós relevantes do vault e suas relações. Útil para entender como conceitos se conectam, identificar clusters temáticos, e descobrir conexões não óbvias entre ideias que estavam em silos.

## Loop diário: por que 8–15 páginas por fonte

O número parece alto — uma fonte gerando 8–15 páginas — mas reflete a granularidade do LLM Wiki Pattern. Em vez de uma página única para "o artigo sobre X", o Claude cria:
- 1 página para a fonte em si (com resumo e key insights)
- 1–3 páginas de conceito para ideias novas introduzidas
- 1–5 atualizações em páginas de entidades já existentes
- 1–3 páginas de entidade para pessoas/produtos/organizações mencionados

Isso é diferente de fazer um resumo. É extrair a estrutura de conhecimento implícita na fonte e torná-la explícita no grafo do vault.

## Comparação com setups alternativos

| Setup | Quem escreve | Manutenção | Densidade do grafo |
|---|---|---|---|
| Obsidian puro | Usuário | Manual | Depende da disciplina |
| Obsidian + chat IA | Usuário + IA responde | Manual | Depende da disciplina |
| claude-obsidian (LLM Wiki) | IA constrói, usuário direciona | Automática | Alta e crescente |

## Limitações

- Requer Node.js v18+ e Claude Code CLI — barreira de setup mais alta que plugins Obsidian convencionais
- Qualidade do vault depende da qualidade das fontes ingeridas — garbage in, garbage out
- Pages geradas automaticamente podem ter inconsistências que precisam de revisão humana ocasional
- Sem backup automático: Claude Code pode sobrescrever notas existentes se os wikilinks não forem verificados antes

## Conceitos extraídos

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern|LLM Wiki Pattern]]
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding|Knowledge Compounding]]
- [[03-RESOURCES/concepts/pkm-obsidian/hot-cache|Hot Cache]]
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain|Second Brain]]
