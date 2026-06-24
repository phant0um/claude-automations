---
title: "How I Built Obsidian + Claude Into a True Second Brain"
type: source
source: "[@cryptowluha](https://x.com/cryptowluha/status/2065069357399433272)"
created: 2026-06-13
ingested: 2026-06-13
tags: [ai-agents]
---

## Tese central

Stack de 10 plugins + 20 workflows + 4 práticas de setup avançado —
Obsidian como "memory layer", Claude como "reasoning layer".

## Argumentos principais

Complementa [[03-RESOURCES/sources/claude-code-cowork/cowork-obsidian-second-brain-rubenhassid]]
(que usa MCP + perspectiva não-dev); este artigo usa **Smart Connections +
Copilot + Templater + Dataview + Tasks + Periodic Notes + Calendar + Kanban +
Obsidian Git + Obsidian CLI**.

### 10 plugins core

| Plugin | Papel |
|---|---|
| Smart Connections | AI descobre info relevante em todo o vault, não só a nota atual |
| Copilot | AI embutida no Obsidian — menos context-switching |
| Templater | templates para daily/weekly/meeting/research/project/content |
| Dataview | vault → "banco de dados": tabelas, dashboards, trackers, índices |
| Tasks | conecta action items ao conhecimento (não separa thinking de execution) |
| Periodic Notes | daily/weekly/monthly/quarterly — timeline para Claude entender progresso/padrões |
| Calendar | navegação temporal |
| Kanban | pipelines de conteúdo/research/produto visuais |
| Obsidian Git | versionamento — recuperar versões anteriores |
| Obsidian CLI | acesso programático — agentes buscam/editam/organizam autonomamente |

### 20 workflows de alto leverage (resumo agrupado)

- **Rotina diária**: Morning Brief (prioridades/deadlines/overdue do dia),
  Nightly Processing (limpa inbox, tags, links, summaries enquanto você
  dorme)
- **Captura/síntese**: Meeting Processing (notas brutas → executive
  summary/decisões/action items/owners/deadlines), Research Intake
  (artigos/PDFs/vídeos/podcasts → insights/quotes/evidência/contradições/
  follow-ups/links sugeridos)
- **Revisão periódica**: Weekly Review (completed/missed/bottlenecks/
  insights/next-week priorities), Vault Cleanup mensal (orphans,
  duplicates, tags inconsistentes, metadata faltante)
- **Estrutura de projeto/decisão**: Project Kickoff (overview/objectives/
  constraints/milestones/dependencies/open questions), Decision Journal
  (contexto/opções/assunções/riscos/outcomes — Claude compara expectativa
  vs realidade meses depois)
- **Conhecimento conectado**: Idea Connector (conexões inesperadas entre
  tópicos), Book Knowledge System (1 nota central por livro, conectada a
  projetos/ideias/frameworks), Graph Review (Claude identifica notas
  centrais, isoladas, clusters, conexões fracas/faltantes), Zettelkasten +
  AI (1 nota = 1 ideia atômica — Claude navega cadeias em vez de raciocinar
  sobre documentos gigantes)
- **Escrita**: Argument Builder (busca evidência/exemplos/contra-argumentos
  no vault para posts/artigos/propostas)
- **Setup avançado**: Claude Code + Vault Memory (vault = memória de longo
  prazo — Claude entende estrutura de pastas/naming/metadata/linking antes
  de cada task), MCP Server Integration (busca/recupera contexto sem
  copy-paste), Reusable Skills (workflows repetíveis em vez de prompts do
  zero), AI-Friendly Vault Rules (títulos claros, tags consistentes,
  summaries curtos, links úteis, metadata simples), Separate Vaults
  (pessoal/business/learning/content/client — Claude só acessa contexto da
  task atual), Vault-Powered Projects (áreas do vault alimentam projetos
  específicos), Continuous Feedback Loop (todo output útil do Claude volta
  para o vault)

## Exemplos e evidências

### Roteiro "from zero"

Hora 1: Obsidian + estrutura PARA (Inbox/Projects/Areas/Resources/Archive) +
Templater. Hora 2: Smart Connections + 5-10 notas + perguntar ao Claude
sobre o vault. Hora 3: MCP/acesso programático. Dia 2: 10-20 notas com
título/tags/link/contexto. Dia 3: primeiro workflow (Morning Brief —
"fastest return on effort"). Semana 1: Dataview + Periodic Notes + daily/
weekly reviews. Semana 2: research workflows, cleanup, project kickoffs,
content pipelines — "only build what you will actually use."

## Implicações para o vault

vault-michel já implementa boa parte (estrutura PARA-like em
`01-PROJECTS/02-AREAS/03-RESOURCES/08-ARCHIVE`, MCP filesystem, hot.md como
"memory layer", pipeline-diario como Research Intake + Vault Cleanup
combinados). Workflows ainda não cobertos explicitamente:
**Decision Journal** (notas de decisão com outcome tracking — útil para
decisões arquiteturais do SO, ex: ADR-003) e **Graph Review** periódico
(detecção de notas isoladas/clusters — função que `wiki-lint` já cobre
parcialmente). Ver também [[03-RESOURCES/sources/claude-code-cowork/cowork-obsidian-second-brain-rubenhassid]]
— mesmo tema (Obsidian+Claude como second brain) de fonte independente, usa
MCP + perspectiva não-dev em vez do stack de 10 plugins deste artigo.
