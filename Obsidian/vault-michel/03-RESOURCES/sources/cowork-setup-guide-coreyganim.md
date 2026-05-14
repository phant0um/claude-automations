---
title: "How to QUICKLY set up Claude Cowork (the right way)"
type: source
source_file: ".raw/articles/How to QUICKLY set up Claude Cowork (the right way).md"
author: Corey Ganim (@coreyganim)
ingested: 2026-04-17
tags: [claude-cowork, setup, onboarding, context-files, global-instructions, scheduled-tasks]
---

# How to QUICKLY set up Claude Cowork (the right way)

**Autor:** [[03-RESOURCES/entities/Corey-Ganim]] (@coreyganim)

## Resumo

Guia de onboarding de 30 minutos para o [[03-RESOURCES/entities/Claude-Cowork]]. Detalha 6 passos: conectar ferramentas, criar 3 arquivos de contexto, configurar global instructions, instalar skills, criar primeira tarefa agendada e calibrar na primeira semana.

> [!tip] Insight chave
> A configuração de 30 minutos mais 5 minutos/dia de calibração na primeira semana é o que separa quem usa Claude como chatbot genérico de quem opera como se tivesse um time de 10 pessoas.

## Os 6 passos

### 1. Conectar ferramentas primeiro (5 min)
Conectar **antes** de criar arquivos de contexto — assim Claude pode varrer documentos existentes do Drive em vez de você digitar tudo do zero. Conectores mínimos:
- Google Workspace (Drive, Gmail, Calendar) — "não negociável"
- Slack ou Teams
- Notion / Asana / Linear
- Zoom (novo em abril 2026 — puxa contexto de reuniões e gravações)

**Teste rápido:** peça para Claude encontrar um documento recente no Drive.

### 2. Três arquivos de contexto (10 min)

| Arquivo | Conteúdo |
|---------|----------|
| `about-me.md` | O que faz, projetos atuais, clientes, ferramentas, pessoas-chave |
| `voice.md` | Estilo de comunicação, palavras odiadas, exemplos de escrita real |
| `preferences.md` | Perguntas vs execução direta, formato de output, regras rígidas |

**Atalho:** Claude pode varrer o Drive e rascunhar 80% do `about-me.md` automaticamente.

### 3. Global Instructions (~800 palavras)
Condensa os 3 arquivos em um brief permanente. Estrutura:
- Quem sou (2-3 frases)
- Como trabalho (preferências)
- Output defaults (emails → bullets; conteúdo → parágrafos; pesquisa → tabelas)
- Voz (3-4 características)
- Contexto de negócio atual
- Regras (sempre X, nunca Y)

**Onde ativar:** Claude Desktop → Settings → Cowork → Global Instructions

### 4. Instalar 3-5 skills (5 min)
Olhar a última semana: o que foi repetitivo? Começar com isso. Instalar plugins por keyword no buscador do Cowork.

### 5. Primeira tarefa agendada (5 min)
Exemplos iniciais:
- **Morning briefing** (dias úteis, 8h): inbox urgente + agenda + top 3 prioridades
- **Weekly recap** (sexta, 16h): completadas + atrasadas + wins da semana
- **Meeting prep** (30 min antes de calls): contexto do interlocutor + 3 talking points

Regra: quanto mais específico o prompt da tarefa, melhor o output. "Summarize my inbox" → genérico. Especificar critérios → utilizável.

### 6. Calibração na primeira semana
Tratar semana 1 como calibração, não produção. Cada erro = feedback explícito para ajustar. Ao fim da semana: 2-3 edits nos context files, global instructions mais enxutas, tarefas agendadas refinadas.

## Conceitos relacionados
- [[03-RESOURCES/concepts/claude-cowork-plugins]] — plugins que estendem este setup
- [[03-RESOURCES/entities/Claude-Cowork]] — o produto configurado
- [[03-RESOURCES/concepts/mcp-model-context-protocol]] — conectores MCPs subjacentes

## Referências cruzadas
- Artigo complementar: [[03-RESOURCES/sources/cowork-plugin-guide-coreyganim]] — plugins e slash commands
