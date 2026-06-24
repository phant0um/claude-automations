---
title: "How to Master Context Engineering & Build AI Systems That Actually Understand You (Full Course)"
type: source
source_file: Clippings/How to Master Context Engineering & Build AI Systems That Actually Understand You (Full Course).md
origin: post no X (@eng_khairallah1)
author: "@eng_khairallah1"
published: 2026-05-10
ingested: 2026-05-14
tags: [context-engineering, ai-systems, memory, mcp, tools, full-course]
triagem_score: 8
---

# Context Engineering — Full Course (6 Semanas)

Curso completo de context engineering por @eng_khairallah1. Argumento central: **prompt engineering é a sintaxe; context engineering é a infraestrutura — e infraestrutura bate sintaxe sempre.**

## As 3 Camadas de Contexto

| Camada | O que é | Quem usa |
|--------|---------|---------|
| **Imediato** | O prompt em si | 99% das pessoas |
| **Sessão** | Arquivos carregados, histórico, system prompt | A maioria, parcialmente |
| **Persistente** | Memória entre sessões, knowledge bases, preferências | Quase ninguém — e é aqui que está a maior alavancagem |

> "Prompt engineering gives the model eyes. Context architecture gives it a brain."

## Semana 1: Por que Prompts Sozinhos Não Bastam

Um prompt perfeito dentro de um contexto mal desenhado produz resultados mediocres. O modelo sem contexto trabalha "às cegas" e defaulta para o mais genérico, mais seguro possível.

## Semana 2: Os 4 Arquivos de Contexto

1. **Identity file**: quem você é, expertise, background, estilo de comunicação
2. **Audience file**: para quem você cria, psychographics, pain points, linguagem
3. **Standards file**: o que é "bom", quality criteria, anti-patterns, exemplos
4. **Project file**: o que está acontecendo agora, goals ativos, decisões recentes, deadlines

Cada arquivo < 2.000 palavras. Carregar os 4 no início = modelo passa de assistente genérico para colaborador contextualizado.

## Semana 3: Dynamic Context Loading

Não carregar tudo sempre — dilui a atenção do modelo.

Regras de carregamento por tipo de tarefa:
- **Writing**: identity + audience + standards + exemplos do melhor conteúdo naquele formato
- **Analysis**: identity + project + dados brutos + análises anteriores
- **Research**: project + metodologia + pesquisa existente
- **Strategy**: todos os 4 + competitive landscape + dados da indústria

## Semana 4: Memory Systems

3 abordagens em escala crescente:
1. **Manual memory documents**: doc running de key decisions, preferências, histórico de projeto → colar no início de cada sessão
2. **Structured knowledge bases**: pasta organizada de markdown (Obsidian ideal). Claude Code pode ler diretamente do filesystem.
3. **Vector databases + RAG**: para >20 documentos de contexto ou centenas de documentos

## Semana 5: MCP — Contexto + Tools

> "Context without tools is knowledge without hands."

MCP permite ao modelo com contexto rico **agir** sobre o que sabe. Combinar deep context + MCP tool access = modelo passa de advisor para operator.

## Semana 6: Produção

- Automação de context loading
- Monitoramento de qualidade de output
- Iteração dos arquivos de contexto com base em onde outputs ainda erram
- Escalabilidade: de uso individual para team workflows

## Princípio-Chave

> "A basic prompt inside a perfectly designed context will produce exceptional results every time."

## Conexões

- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — conceito base (update com 3 camadas)
- [[03-RESOURCES/entities/Khairallah-AL-Awady]] — autor
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — MCP como ferramenta
- [[03-RESOURCES/sources/memory-context-rag/contextmaxxing-vs-tokenmaxxing]] — perspectiva complementar de Ashwin Gopinath

---

## Por que infraestrutura bate sintaxe

O argumento central do curso — que context engineering é infraestrutura e infraestrutura bate sintaxe sempre — tem uma base técnica concreta:

**Limite de atenção:** transformers têm atenção que dilui à medida que o contexto cresce. Um prompt perfeito enterrado em 50 arquivos irrelevantes recebe menos atenção efetiva do que um prompt mediano num contexto limpo de 3 arquivos. A sintaxe do prompt otimiza como o modelo processa o que está no contexto — a arquitetura de contexto controla o que está lá.

**Custo de descoberta:** quando o modelo não encontra o que precisa no contexto imediato, ele faz tool calls para descobrir — consultando arquivos, fazendo buscas, pedindo clarificação. Cada chamada extra é latência + tokens + risco de erro. Um contexto bem projetado antecipa as perguntas do modelo antes que ele precise fazê-las.

**Consistência de sessão:** prompts otimizados produzem bons resultados na primeira mensagem. Contexto arquitetado produz resultados consistentes ao longo de 50 turnos de uma sessão de trabalho longa — porque o modelo tem referências estáveis para navegar em vez de depender apenas de memória de curto prazo na context window.

---

## Os 4 arquivos de contexto: detalhamento

### Identity file
Mais do que "quem você é" — é o que habilita personalização real. Um identity file efetivo inclui:
- Background técnico específico (não "sou desenvolvedor" mas "trabalho com TypeScript e Rust, domínio de finanças, 8 anos de experiência")
- Preferências de output (listas vs prosa, brevidade vs completude, nível de detalhe em explicações)
- O que você quer que o modelo assuma como dado vs o que quer que explique sempre

### Audience file
Informa o modelo sobre para quem os outputs serão apresentados. Sem isso, o modelo default para uma audiência genérica e produz outputs que são tecnicamente corretos mas erram na linguagem, profundidade e formato para o contexto real.

### Standards file
Define o que "bom" significa para você especificamente — não em abstrato. Inclui exemplos positivos e negativos (anti-patterns) que ancorem o julgamento do modelo às suas expectativas reais. Um standards file sem exemplos é aspiração sem tração.

### Project file
O mais dinâmico dos quatro. Deve ser atualizado a cada mudança significativa de direção, decisão tomada, ou aprendizado novo. É a memória de curto prazo da colaboração — o que o modelo precisa saber sobre o que está acontecendo agora para não operar com pressupostos desatualizados.

---

## Dynamic Context Loading: a regra prática

O princípio é simples: não carregar tudo sempre. A execução exige disciplina:

**Para writing tasks:** identity + audience + standards + 3 exemplos do melhor output naquele formato. Os exemplos são o elemento mais impactante — o modelo calibra seu output na faixa de qualidade que o exemplar demonstra.

**Para analysis tasks:** project + dados brutos + análises anteriores (se existirem). Omitir identity e audience — a análise é para você, o modelo sabe quem você é pelo project file.

**Para research tasks:** project + metodologia + pesquisa existente. Sem standards — research não precisa de critérios de "bom output" além da precisão factual.

**Para strategy tasks:** todos os quatro + landscape competitivo + dados de mercado. Aqui o modelo precisa de máximo contexto porque vai fazer conexões entre domínios.

---

## MCP como bridge entre contexto e ação

A distinção que o Semana 5 do curso captura é arquiteturalmente importante:

- **Contexto rico sem tools:** o modelo sabe muito mas só pode responder. Útil para análise, escrita, planejamento.
- **Tools sem contexto rico:** o modelo pode agir mas não sabe o que importa. Útil para tarefas mecânicas bem especificadas.
- **Contexto rico + MCP tools:** o modelo sabe o que importa e pode agir diretamente sobre os sistemas que contêm esse contexto.

O exemplo da Semana 5 — "advisor vs operator" — mapeia para a distinção entre agente de resposta e agente de execução. O vault-michel já opera com MCP filesystem, o que move Claude Code de advisor (sugere edições) para operator (aplica edições diretamente).

---

## Aplicação no vault-michel

O vault já implementa a maioria das 6 semanas do curso implicitamente:

| Semana | Conceito | Implementação no vault |
|--------|---------|------------------------|
| 1 | Contexto > prompts | CLAUDE.md como constitution; hot.md como contexto dinâmico |
| 2 | 4 arquivos de contexto | CLAUDE.md (identity + standards), hot.md (project), agents/ (audience por tarefa) |
| 3 | Dynamic context loading | Skills carregadas por tipo de task; subagents com contexto isolado |
| 4 | Memory systems | hot.md (manual), .manifest.json (structured), futuro: RAG para vault grande |
| 5 | MCP + tools | MCP filesystem + vault MCP server |
| 6 | Produção | Automação via N8N + workflows autônomos |

A lacuna principal: **standards file** explícito — critérios formalizados de "o que é uma boa nota no vault" com exemplos positivos e negativos. Atualmente esses critérios existem apenas como intuição implícita no CLAUDE.md.
