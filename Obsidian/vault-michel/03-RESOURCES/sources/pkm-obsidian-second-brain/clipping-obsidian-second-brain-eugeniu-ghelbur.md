---
title: "Claude Code Skill for Obsidian Second Brain"
type: source
source_type: article
author: "Eugeniu Ghelbur"
created: 2026-05-06
tags: [obsidian, claude-code, second-brain, skill]
triagem_score: 8
---

Claude Code skill for Obsidian vault management. 31 commands for vault-first research, scheduled agents, wiki management. Turn Obsidian vault into a living AI-first second brain.

## Source

Ingested from: `clippings/eugeniughelburobsidian-second-brain Claude Code skill for Obsidian. Turn your vault into a living AI-first second brain. 31 commands, vault-first research, scheduled agents..md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Contexto: Por Que Este Projeto Existe

Eugeniu Ghelbur trabalha como AI Automation Engineer na Single Grain e criou o `obsidian-second-brain` como extensão prática do padrão LLM Wiki de Andrej Karpathy. A diferença crítica: Karpathy's pattern é append-only — novas informações se acumulam sem resolver contradições ou sintetizar padrões emergentes. O projeto de Ghelbur resolve isso com reescrita ativa e agentes agendados.

O vault-michel adota diretamente este projeto como base do seu sistema de ingestão e manutenção (ver [[03-RESOURCES/sources/pkm-obsidian-second-brain/clipping-obsidian-second-brain-eugeniughelbur]] para versão expandida com Key Takeaways completos).

---

## Os 31 Comandos — Categorias Principais

### Pesquisa e Ingestão (Research Toolkit)
- `/research [query]` — pesquisa web e sintetiza em nota Obsidian
- `/research-deep [query]` — pesquisa multi-fonte com reconciliação de contradições
- `/x-read [url]` — lê thread do X e converte em nota estruturada
- `/x-pulse [tópico]` — pulso do X sobre tópico: top posts das últimas 24h
- `/youtube [url]` — transcreve e sintetiza vídeo do YouTube

### Manutenção e Qualidade (Vault Health)
- `/obsidian-reconcile` — varre vault por contradições e as reconcilia automaticamente
- `/obsidian-synthesize` — identifica padrões sem nome entre notas e cria novas páginas de conceito
- `/obsidian-health` — verifica orphan pages, dead links, frontmatter inválido
- `/obsidian-lint` — corrige formatação, wikilinks quebrados, frontmatter incompleto

### Agentes Agendados (Scheduled Agents)
4 agentes que rodam sem prompting manual:
1. **Nightly close** — consolida notas do dia, atualiza índices
2. **Weekly review** — revisão semanal, identifica tendências emergentes
3. **Contradiction sweep** — varre todo vault por afirmações conflitantes
4. **Vault health** — métricas de saúde: orphans, dead links, notas não conectadas

### Formato AI-First
Notas seguem formato com `## For future Claude` como preamble — instrução explícita para o próximo agente sobre como usar a nota. Frontmatter inclui campos para retrieval de LLM: `relevance`, `last_verified`, `confidence`.

---

## Diferenças em Relação ao Pattern Original de Karpathy

| Dimensão | Karpathy LLM Wiki | obsidian-second-brain |
|---|---|---|
| Escrita | Append-only | Reescrita ativa |
| Contradições | Acumulam | Reconciliadas automaticamente |
| Padrões | Manuais | Sintetizados por `/obsidian-synthesize` |
| Manutenção | Manual | 4 agentes agendados |
| Pesquisa | Manual | 5 comandos de pesquisa integrados |
| Formato | Livre | AI-first com preamble padronizado |

---

## Limitações Conhecidas

- Depende fortemente da qualidade do MCP filesystem — sem MCP, comandos degradam para operações manuais.
- Agentes agendados requerem Claude Code rodando com hooks — não funciona com Claude.ai web.
- `/obsidian-reconcile` pode resolver contradições incorretamente em domínios onde ambiguidade é intencional (ex: notas de diferentes perspectivas teóricas).
- 31 comandos criam cognitive overhead — nem todos são necessários para um vault pequeno.

---

## Aplicação no Vault-Michel

Este vault implementa versão adaptada: `wiki-ingest` skill cobre ingestão, `wiki-lint` cobre health, skills de pesquisa cobrem research. Os 4 agentes agendados são implementados via Claude Code hooks (`claude --scheduled`). O formato `## For future Claude` é usado em conceitos críticos do vault.

---

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/entities/Obsidian]]
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/Andrej Karpathy]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/clipping-obsidian-second-brain-eugeniughelbur]]

---

## Análise Técnica dos Comandos de Pesquisa

### Por que `/research-deep` é Diferente de `/research`

A distinção entre os dois comandos de pesquisa é mais do que profundidade. `/research` faz busca, sintetiza em nota, encerra. `/research-deep` adiciona uma etapa de reconciliação: ao sintetizar múltiplas fontes, identifica afirmações contraditórias entre elas e as resolve explicitamente na nota final — com raciocínio sobre qual fonte é mais confiável, mais recente, ou mais específica ao contexto.

Em prática, isso significa que uma nota gerada por `/research-deep` sobre um tópico controverso conterá não apenas o consenso das fontes mas também a análise de onde elas divergem e por quê. Valor alto para tópicos em evolução onde o estado da arte é disputado.

### O Toolkit de Fontes Sociais

`/x-read`, `/x-pulse` e `/youtube` cobrem onde conhecimento técnico atual realmente vive: não em papers e blogs, mas em threads do X e vídeos do YouTube. Para áreas como AI agents, onde o ciclo de inovação é de semanas, não anos, esses comandos são mais valiosos do que `/research` em muitas situações.

`/x-pulse` é particularmente útil para calibrar o zeitgeist técnico: quais tópicos estão sendo discutidos intensamente hoje? Qual técnica saiu do nada para consensus nas últimas 24h? Essa informação não existe em nenhuma documentação — só no stream de posts de praticantes.

## Análise dos Agentes Agendados

### O Design Correto de Frequência

A escolha de frequências dos 4 agentes não é arbitrária:

- **Nightly close** — diário porque o inbox acumula rapidamente; deixar para semanal cria backlog de consolidação
- **Weekly review** — semanal porque tendências emergentes não são visíveis em horizonte diário; precisam de pelo menos uma semana de dados
- **Contradiction sweep** — semanal porque novas fontes são ingeridas diariamente mas contradições emergem ao longo do tempo, não instantaneamente
- **Vault health** — diário porque dead links e orphan pages se acumulam a cada ingestão; detectar e corrigir diariamente é mais barato que consertar backlog semanal

Um erro comum em implementações similares é rodar todos os agentes com a mesma frequência — ou muito frequente (custo alto, pouco sinal) ou muito raro (problemas acumulam).

## Implementação Técnica via Claude Code Hooks

Os agentes agendados requerem a capacidade de Claude Code de rodar tarefas programadas. A implementação usa hooks configurados no `settings.json`:

```json
{
  "scheduled": {
    "nightly_close": {
      "cron": "0 23 * * *",
      "command": "claude --skill obsidian-nightly-close"
    },
    "weekly_review": {
      "cron": "0 10 * * 0",
      "command": "claude --skill obsidian-weekly-review"
    }
  }
}
```

Isso requer que Claude Code esteja em execução (ou um daemon que o invoca). Em sistemas onde Claude Code não está permanentemente ativo, a alternativa é um cron job do sistema operacional que dispara o Claude Code com o skill apropriado.

## Comparação com Alternativas de Vault Automatizado

| Sistema | Reescrita | Agentes agendados | Pesquisa integrada | Formato AI-first |
|---------|-----------|-------------------|-------------------|-----------------|
| obsidian-second-brain | Sim | 4 agentes | 5 comandos | Sim (For future Claude) |
| Karpathy LLM Wiki (original) | Não (append) | Não | Manual | Não padronizado |
| vault-michel (este vault) | Parcial (via wiki-ingest) | Manual | Via wiki-ingest | Parcial |
| Roam AI integrations | Não | Não | Via plugins | Não |

O gap mais significativo do vault-michel em relação ao obsidian-second-brain é a ausência de agentes completamente automatizados — o scheduled task no Claude Code existe mas não está configurado para todos os 4 tipos. A evolução natural seria configurar o nightly close e o vault health como cron jobs permanentes.

## O Preamble `## For future Claude` como Convenção de Comunicação Inter-agente

Este é o elemento mais transferível do projeto para qualquer sistema de agentes, independente de ser Obsidian ou não. A convenção resolve um problema real: quando um agente lê uma nota criada por um agente anterior (ou por si mesmo em sessão anterior), não tem contexto sobre o propósito da nota.

O preamble funciona como metadados operacionais: "se você está lendo esta nota, aqui está o que você precisa saber para usá-la efetivamente." Difere do frontmatter YAML (que é para retrieval e filtragem) e do corpo da nota (que é o conteúdo em si).

Em sistemas de agentes mais complexos, essa convenção pode ser estendida para incluir informações sobre quando a nota está desatualizada, quais claims precisam de verificação, e quais links foram confirmados como válidos vs. inferidos.
