---
title: Claude 101 — Curso Oficial Anthropic
type: source
source_type: official-course
author: Anthropic
created: 2026-04-19
updated: 2026-04-19
tags: [claude, anthropic, curso-oficial, prompting, projects, skills, artifacts, connectors]
triagem_score: 7
---

# Claude 101 — Curso Oficial Anthropic

Curso introdutório oficial da Anthropic sobre uso de Claude. Cobre toda a stack de produtos e features: desde o primeiro prompt até Research mode, Enterprise Search e ferramentas especializadas.

> [!key-insight] Posição desta fonte
> É o guia canônico de uso do Claude para usuários de negócios (Claude.ai, Pro, Team, Enterprise). Não é sobre Claude Code/desenvolvimento — é sobre colaboração com IA no dia a dia de trabalho.

## Estrutura do curso

1. **What is Claude** — Constitutional AI, capabilities, planos
2. **First conversation** — framework de prompts: Stage + Task + Rules
3. **Getting better results** — iteração, desafios comuns, 4D Framework para AI Fluency
4. **Desktop app: Chat, Cowork, Code** — três modos distintos
5. **Projects** — workspaces persistentes com knowledge base e instructions
6. **Artifacts** — outputs interativos standalone (docs, código, HTML, SVG, Mermaid, React)
7. **Skills** — pacotes de instrução para workflows repetíveis
8. **Connectors** — integração com ferramentas via MCP
9. **Enterprise Search** — busca organizacional cross-tool
10. **Research mode** — investigação agentica multi-fonte
11. **Use cases por role** — Sales, Marketing, Finance, HR, Legal, Research
12. **Outros produtos** — Claude Code, Slack, Excel, Chrome

## Framework de prompts (3 elementos)

```
1. Setting the stage → Papel, contexto, objetivo
2. Defining the task  → Ação específica (write, analyze, build)
3. Specifying rules   → Formato, tom, exemplos
```

## 4D Framework para AI Fluency

Ver [[03-RESOURCES/concepts/learning-cognition/4d-framework-ai-fluency]] — framework acadêmico (Dakan + Feller) com 4 competências.

## Distinção Projects vs Skills

| | Projects | Skills |
|---|---|---|
| Purpose | Armazenam conhecimento que Claude referencia | Definem processos que Claude executa |
| Best for | Contexto de longo prazo, materiais de referência, colaboração | Workflows repetíveis, multi-step, metodologia consistente |
| Exemplo | Hub de cliente, base de pesquisa | Brand guidelines, criação de PDF, análise de dados |
| Persistência | Disponível em todos os chats do projeto | Instruções aplicadas quando a skill é invocada |

Ver [[03-RESOURCES/concepts/claude-code-tooling/claude-projects]] e [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]].

## Cowork — features-chave

- **Folder access** — aponta Claude a uma pasta local
- **Scheduled tasks** — tarefas recorrentes automáticas
- **Subagents** — workers paralelos para partes do task
- **Dispatch** — continua tasks no mobile (app + desktop aberto)
- **Browser use** — Claude navega Chrome diretamente
- **Computer use** — controle total do computador (preview)
- **Protected environment** — sandbox nas pastas autorizadas

## Modelos de interação do Code tab

| Modo | O que faz |
|---|---|
| Ask | Propõe toda mudança, espera aprovação |
| Code | Aplica mudanças mas confirma antes de rodar comandos |
| Plan | Detalha abordagem completa antes de tocar qualquer coisa |

## Research mode — como funciona

1. Extended Thinking ativado automaticamente
2. Claude planeja abordagem
3. Múltiplas buscas em cadeia (cada uma alimenta a próxima)
4. Síntese cross-source
5. Output com citações verificáveis

Duração: 5–45 minutos dependendo de complexidade.

## Artifacts — o que são e como funcionam

Artifacts são outputs standalone gerados pelo Claude que vivem fora da conversa. A diferença fundamental em relação a texto copiado-colado:

- **Persistence**: ficam acessíveis como painéis laterais, não somem no scroll da conversa
- **Editabilidade**: Claude pode editar versões específicas sem reescrever tudo
- **Interatividade**: React artifacts rodam no browser — são aplicativos funcionais, não só código
- **Download**: qualquer Artifact pode ser baixado diretamente

Tipos suportados: documentos Markdown, HTML interativo, React components, SVG, Mermaid (diagramas), planilhas. Para ativar: "create this as an Artifact" ou "save this as a document".

## Connectors vs MCPs — distinção importante

O curso apresenta Connectors como a camada de integração do Claude.ai (interface web/desktop). Eles são diferentes de MCPs no Claude Code:

| | Connectors (Claude.ai) | MCPs (Claude Code) |
|---|---|---|
| Interface | Web + Desktop app | Terminal / IDE |
| Setup | Poucos cliques, autenticação OAuth | Configuração JSON + API keys |
| Quem usa | Usuários de negócio | Desenvolvedores |
| Escopo | Ferramentas de produtividade (Drive, Slack, Notion) | Qualquer servidor, incluindo custom |

Na prática, um knowledge worker sem habilidades técnicas usa Connectors. Um desenvolvedor usa MCPs diretamente. Para este vault, a abordagem é via MCP (claude-obsidian plugin).

## Comparativo: Research Mode vs Extended Thinking

Frequentemente confundidos, mas servem a propósitos distintos:

**Extended Thinking** é *interno* — antes de responder, o modelo realiza um raciocínio mais profundo usando um bloco de "thinking" que consome tokens mas produz resposta mais cuidadosa. Escala de segundos a minutos. Não sai da sessão.

**Research Mode** é *externo* — o modelo planeja buscas, executa dezenas de queries em fontes externas (web, Google Scholar, etc.), cross-referencia resultados, e produz relatório citado. Escala de 5 a 45 minutos. Gera um documento navegável com citações verificáveis.

Para questões que exigem síntese cross-source (literatura acadêmica, mercado, comparativos), Research Mode é mais adequado. Para raciocínio complexo com dados já no contexto, Extended Thinking basta.

## Skills vs Projects — aplicação prática para o vault

A distinção do curso tem implicação direta para este vault:

**Projects** = o vault-michel em si. É o repositório persistente de todo o conhecimento: conceitos, entidades, fontes, histórico de sessões. O claude-obsidian plugin é o mecanismo de acesso.

**Skills** = os arquivos em `04-SYSTEM/skills/`. Cada skill é um procedimento que o Claude executa quando acionado — `wiki-ingest`, `wiki-lint`, `batch-ingest`, `premortem`, etc. São o "como fazer" das tarefas recorrentes.

A separação é importante: adicionar mais conhecimento ao vault não substitui skills bem escritas, e criar mais skills não elimina a necessidade de um vault organizado. Os dois componentes se multiplicam.

## Relevância para usuários não-dev (perspectiva do curso)

O Claude 101 é explicitamente direcionado para knowledge workers sem background técnico. Os módulos de use case por role (Sales, Marketing, Finance, HR, Legal, Research) mostram como as mesmas ferramentas (Projects, Skills, Research Mode) se traduzem em diferentes workflows profissionais.

Para o contexto deste vault, o curso vale como referência canônica da Anthropic sobre *intenção de produto* — o que cada feature foi projetada para fazer, não interpretação de terceiros.

## Fontes e links

- [[03-RESOURCES/concepts/learning-cognition/4d-framework-ai-fluency]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-projects]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-artifacts]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-connectors]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-research-mode]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/entities/Rick-Dakan]]
- [[03-RESOURCES/entities/Joseph-Feller]]
