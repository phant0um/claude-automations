---
title: "Creating a Second Brain with Claude Code"
type: source
source_file: ".raw/articles/Creating a Second Brain with Claude Code.md"
author: Ryan Wiggins (@rywiggs)
ingested: 2026-04-17
tags: [second-brain, claude-code, qmd, vector-search, hooks, knowledge-base, produtividade]
---

# Creating a Second Brain with Claude Code

**Autor:** [[03-RESOURCES/entities/Ryan-Wiggins]] (@rywiggs) — VP of Product @ Mercury

## Resumo

Implementação prática de um "Second Brain" usando Claude Code com 15k documentos (3,5 milhões de palavras) de 5 anos de histórico de trabalho. Sistema baseado em QMD (vector search local), hooks de contexto automático e loop de aprendizado tripartite.

> [!tip] Insight chave
> O sistema dobrou a produtividade do VP de Product ao injetar automaticamente contexto relevante em **cada** prompt via hook, sem necessidade de busca manual. Cross-tool synthesis ("tem algo que esqueci hoje?") é a feature emergente mais poderosa.

## Arquitetura do sistema (5 fases)

### Fase 1: Prep (~1-2h)
- Baixar todos os documentos de trabalho → pasta `raw data`
- Indexar com **QMD** (`bun install -g qmd`)
- Testar com perguntas aleatórias de memória — vector search é dramaticamente superior a text search

### Fase 2: Treinar o cérebro (~2h)
- `me.md` — quem sou, metas, reviews de performance dos últimos 5 anos, prioridades pessoais
- Agente-swarm distila a base de conhecimento em `context.md` folder com temas, históricos, lições
- Conectar ferramentas: Google Docs, Linear, Notion, Metabase (via MCPs/CLIs ou skills com API calls diretas)

### Fase 3: Conectar hooks (<1h)
**UserPromptSubmit hook** — injeta contexto relevante em cada prompt automaticamente:
- Extrai termos e nomes do prompt
- Roda buscas paralelas (vsearch + BM25) contra coleção QMD
- Injeta resultados em bloco `<context>` — Claude vê, não atrapalha o chat

**Duas técnicas de busca QMD:**
| Técnica | Tipo | Melhor para |
|---------|------|-------------|
| `vsearch` | Semântica/vetorial | Significado — "como está o funil?" encontra docs de conversão |
| `BM25` | Keyword exata | Nomes próprios, siglas, métricas específicas |

### Fase 4: Loop de aprendizado
Três horizontes temporais:
1. **Por sessão:** skill `/learn` — revisa conversa, atualiza CLAUDE.md com gotchas de MCPs, preferências novas
2. **Por dia/semana:** cron job de morning brief — agenda + contexto da base de conhecimento → atualiza memória
3. **Por mês:** skill `/retro` — entrevista estruturada sobre o mês; atualiza summaries/

### Fase 5: Explorer Mode proativo
- Sistema pede pesquisa autônoma sobre problemas do usuário
- Integra: Scheduled jobs, Agent Teams/Swarm, AutoResearch do Karpathy, arquivos de Lenny San
- Flui para daily briefs e memória por seção

## Benefícios em prática
- **Recall em segundos** — agulha no palheiro de memória
- **Zero meeting prep** — morning brief já injeta contexto de 1:1s e projetos
- **Never miss action item** — "tem algo que esqueci hoje?"
- **Feedback em tempo real** — performance reviews identificam padrões recorrentes de feedback

## Prompt completo incluído (5 fases)
Artigo inclui prompt copy-paste de 5 fases para construir o sistema do zero, com instruções para entrevistar o usuário, construir KB, distilação por agentes, hook de injeção de contexto, e skills de aprendizado.

## Segurança e privacidade
- Política de IA aprovada pela empresa
- Remoção de documentos com dados sensíveis
- LLMs locais para anonimizar a base de conhecimento
- Hook de segurança que remove PII antes de enviar ao Claude Code
- Apenas dados agregados para análises

## Entidades mencionadas
- [[03-RESOURCES/entities/Ryan-Wiggins]] — autor, VP Product @ Mercury
- [[03-RESOURCES/entities/QMD]] — ferramenta de vector search local (tobi/qmd)
- [[03-RESOURCES/entities/GasTown-OpenClaw]] — agentes com memória persistente em .md
- [[03-RESOURCES/entities/Andrej Karpathy]] — AutoResearch capabilities citado

## Conceitos relacionados
- [[03-RESOURCES/concepts/second-brain]] — implementação prática do conceito
- [[03-RESOURCES/concepts/vector-search]] — QMD; vsearch vs BM25
- [[03-RESOURCES/concepts/claude-hooks]] — mecanismo de injeção automática de contexto
- [[03-RESOURCES/concepts/knowledge-compounding]] — cada sessão enriquece a base
