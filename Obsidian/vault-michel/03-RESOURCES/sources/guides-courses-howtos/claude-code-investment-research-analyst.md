---
title: "How I Set Up Claude Code as My Investment Research Analyst"
type: source
source: "Clippings/How I Set Up Claude Code as My Investment Research Analyst.md"
source_url: "https://x.com/leopardracer/status/2058949350315667829"
author: "@leopardracer"
published: 2026-05-25
created: 2026-05-29
ingested: 2026-05-29
tags: [ai-agents, claude-code, investment-research, finance, obsidian, firecrawl, playwright, workflow]
---

## Tese central

Claude Code não é uma ferramenta de coding — é um operador de workflow. Para finanças, substitui um pesquisador júnior que coleta, modela, redige e monitora portfólios: executa a cadeia inteira (não um passo de cada vez). O setup requer 1 hora. A vantagem: pesquisa para de "vazar" e começa a compor. Após 60 dias, o autor parou de abrir Claude regular para pesquisa.

## Argumentos principais

- **Claude vs Claude Code — a distinção real:** Claude/ChatGPT são chatbots — você pergunta, eles respondem, contexto desaparece. Claude Code é Claude com mãos: abre browser, scrape dados, escreve arquivos, lê arquivos, roda múltiplas tarefas em paralelo, pede input só quando realmente precisa. "Claude Code é o eliminador. A maioria do que chamamos de 'trabalho de pesquisa' é coleta de dados, formatação, copy/paste, troca de abas."
- **O unlock:** Parar de ser usuário de chatbot e se tornar operador de workflow. Você dá o objetivo final e vai fazer outra coisa. Trabalho acontece em background. Você volta para pasta de outputs completos.
- **O sistema tem 4 componentes:**
  1. Claude Code (terminal/Cursor)
  2. Obsidian como memória de longo prazo (raw/, wiki/, output/)
  3. Playwright para automação de browser (páginas que requerem interação)
  4. Firecrawl para web scraping e busca em escala
- **Por que Obsidian como memória:** Claude Code não tem memória entre sessões. Obsidian transforma uma pasta em biblioteca pessoal de pesquisa. Claude Code age como bibliotecário: arquiva o que você coleta, resume o que você lê, linka ideias relacionadas, puxa da biblioteca toda vez que você faz perguntas. Cada resposta do Claude é arquivada de volta na biblioteca — sistema composta.
- **Estrutura de pastas mínima:**
  - `raw/` — inbox para material bruto (artigos, transcritos, screenshots)
  - `wiki/` — domínio do bibliotecário; Claude escreve e mantém tudo aqui
  - `wiki/_master-index.md` — entry point com todos os tópicos
  - `output/` — outputs finalizados (relatórios, respostas de queries)
- **CLAUDE.md como rulebook:** Arquivo no root do vault. Claude Code lê toda vez que abre o projeto. Regras escritas uma vez, seguidas para sempre. Sem CLAUDE.md, Claude Code é assistente inteligente. Com CLAUDE.md, é bibliotecário disciplinado.
  - Seções recomendadas: papel do sistema, regras de wiki, workflow de compilação, formato de artigos, regras de query
  - "When compiling raw material: 1. Read 2. Decide topic 3. Write wiki article with key takeaways + wiki links 4. Update topic _index.md 5. Update _master-index.md"
- **O workflow de 4 verbos:**
  - **Clip:** web clipper Obsidian → 1 clique → arquivo markdown em raw/
  - **Compile:** "Compile everything in raw/ into the wiki" — Claude lê cada artigo, decide tópico, escreve resumo estruturado, arquiva, atualiza índices. Inbox vazia + biblioteca maior.
  - **Query:** pergunta à biblioteca (simples / cross-referencing / synthesis). A query de síntese que arquiva a resposta de volta é "the move that makes the system compound."
  - **Audit:** "Audit the wiki. Look for inconsistencies, broken links, gaps. Don't make changes yet, just give me a report." Uma vez por mês.
- **Playwright (automação de browser):**
  - Instalar via Claude Code ("Walk me through installation...")
  - Serve para: screeners com filtros complexos, IR pages com dropdowns, portais que precisam aceitar disclaimer
  - "Anywhere a regular scraper would fail because the page expects a human, Playwright lets Claude Code be that human."
  - Teste: pedir para abrir browser, navegar para screener.in, reportar o que vê.
- **Firecrawl (web scraping + busca):**
  - Instalar via Claude Code ("Walk me through Firecrawl CLI installation...")
  - Converte qualquer página em markdown limpo que Claude Code pode ler
  - Casos de uso: pull insider trading data do Finviz, scrape annual report de IR page, search "latest news X" e pull top 10 artigos
  - Claude Code reconhece quando precisa e usa automaticamente
- **Exemplo real de uso:** Prompt: "Screening for names to deploy capital. Pull insider trading data from finviz.com for last 2 weeks. Analyze for strong buy signals. Top 10 watchlist with reasoning." Resultado: lista ranqueada com tese, lista de insider purchases (quem comprou, quando, quanto), riscos, scorecard. Tempo: 3 minutos. Manual: 90+ minutos com erros.
- **`--dangerously-skip-permissions`:** Flag que desabilita prompt de permissão para cada ação. Autor usa há 60 dias sem problemas. Risco mitigado pela CLAUDE.md (scope) e pelo fato de Claude Code só ter acesso à pasta do vault (não à máquina inteira). Recomenda: manter permissões ON na primeira semana para entender o que Claude Code faz.
- **NotebookLM como complemento:** Obsidian = biblioteca geral. NotebookLM = workspace focado numa empresa/setor específico. Python wrapper permite queries cruzadas entre Obsidian e NotebookLM a partir do Claude Code.
- **Três surpresas dos 60 dias:**
  1. Terminal parou de parecer ferramenta de coding no final da primeira semana.
  2. A mudança de chatbot-user para workflow-operator muda tudo downstream.
  3. Quanto "research" vazava antes — Notion, Notes, bookmarks, PDFs em 5 pastas, Substack drafts. Obsidian acabou com isso.

## Key insights

- "'Code' in the name is the most misleading part of the product." — Claude Code é para cooking se você quer cooking, para finance se você quer finance.
- "A smart, hardworking person does more by doing more. A wise person does more by eliminating more. Claude Code is the eliminator."
- A query de síntese que arquiva sua própria resposta é o mecanismo que faz o sistema composta genuinamente.
- O sistema inteiro (Obsidian + Claude Code + Playwright + Firecrawl) pode ser configurado em ~1 hora.
- Cursor como IDE: vault aberto como pasta, Claude Code no painel lateral, arquivos visíveis em tempo real — ponto único de trabalho.
- MiniMax M2 como alternativa sem subscription Claude (~7% do custo).

## Exemplos e evidências

- 60 dias de uso real, pesquisa de investimento completa (screening, scraping, modelagem, drafts de relatórios, monitoramento de portfólio).
- Insider trading screen no Finviz: 3 minutos vs. 90+ minutos manuais.
- Query de síntese: "O que aprendi sobre position sizing este trimestre?" → resposta real em menos de 1 minuto, de artigos half-forgotten.
- Série de artigos planejada: workflow de equity research end-to-end, wealth management, accounting audit, portfolio monitoring em servidor virtual.

## Implicações para o vault

- O sistema descrito é arquiteturalmente idêntico ao vault-michel (raw → wiki → output, CLAUDE.md como rulebook, ingest como "compile"). Confirma e valida a arquitetura existente.
- Playwright + Firecrawl são os "hands on the web" que o vault-michel ainda não tem — relevante para pesquisa de concurso (busca de jurisprudência, legistação atualizada) e FIAP (papers recentes).
- A query de síntese que arquiva a própria resposta é exatamente o que `ingest-report` agent deveria fazer ao final de cada sessão de pesquisa.
- `--dangerously-skip-permissions` merece avaliação para o vault-michel em tarefas de ingestão bulk (acelera significativamente).

## Links

- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/NotebookLM]]
- [[03-RESOURCES/entities/Firecrawl]]
- [[03-RESOURCES/entities/Playwright]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/claude-obsidian-zero-cost-moat]]
