---
title: "Prompting is the worst way to use Claude. Do this instead."
type: source
source_file: ".raw/articles/Prompting is the worst way to use Claude. Do this instead.md"
author: Ruben Hassid (@rubenhassid)
ingested: 2026-04-17
tags: [claude, cowork, obsidian, second-brain, skills, workflow, produtividade]
triagem_score: 8
---

# Prompting is the worst way to use Claude. Do this instead.

**Autor:** Ruben Hassid — [@rubenhassid](https://x.com/rubenhassid)

O argumento central: prompts únicos produzem resultados médios porque o modelo não tem contexto suficiente. A solução não é prompts melhores — é substituir prompts por **arquivos persistentes** que o Claude lê automaticamente.

> [!key-insight] Insight central
> "The files are the prompt. Forever." — Arquivos `.md` em uma pasta Cowork são o prompt. Claude lê antes de cada sessão. Prompting direto é o pior jeito de usar o Claude.

## O problema com prompts

- Sem contexto suficiente → outputs genéricos que "soam como IA"
- Projects ajudam mas ainda exigem re-explicar regras por sessão
- Gerenciar arquivos `.md` na TextEdit/VS Code é hostil para não-desenvolvedores

## A solução: Cowork + Obsidian

### Claude Cowork
Produto desktop da Anthropic conectado a uma pasta local. Claude lê os arquivos da pasta antes de cada sessão — os arquivos substituem o prompt.

**Estrutura recomendada de pasta:**
```
Claude Cowork/
├── about-me/
│   ├── about-me.md          # identidade, tom, gosto
│   ├── anti-ai-writing-style.md   # o que você ODEIA em output de IA
│   └── my-company.md        # contexto da empresa/projetos
├── claude-output/           # não tocar — onde Claude entrega
└── templates/               # não tocar — templates salvos
```

**Global Instructions** (Settings > Cowork): instruir a sempre ler `about-me/` antes de qualquer tarefa.

### Obsidian como interface
Obsidian aponta para a **mesma pasta** do Cowork — nunca toca os arquivos de forma que quebre o Cowork. Benefícios:
- Renderiza markdown de forma legível (sem asteriscos e hashtags cruas)
- Busca full-text em todos os arquivos
- Edição in-place com salvamento automático
- Sidebar de navegação entre arquivos

**Workflow diário:**
1. Abrir Obsidian → navegar, buscar, editar arquivos (atualizar o "cérebro")
2. Abrir Cowork → criar trabalho, gerar outputs, construir entregáveis
3. Ambos apontam para a mesma pasta — sempre em sincronia

### Skills no Cowork
Skills = workflows salvos em `.md`, chamados via `/comando`. Uma skill por tarefa recorrente.

Criação de skill:
```
Create a skill called "[nome]". Interview me about the kinds of [contexto].
Build the best skill to help me [objetivo]. Save it as /[comando].
```

Exemplos: `/newsletter`, `/client-brief`, `/sales-email`, `/weekly-report`, `/meeting-notes`

Editar uma skill: abrir no Obsidian, alterar, fazer upload novamente no Claude.

## Por que não outras ferramentas

| Ferramenta | Problema |
|---|---|
| Notion | Cloud-based; `.md` exige import/export constante |
| Google Docs | Não é `.md`; conversão bidirecional quebra o fluxo |
| Apple Notes | Formato fechado; não aponta para pasta |
| VS Code/Cursor | Interface para desenvolvedor |
| GitHub | Requer git, commits, pushes |
| Typora | Um arquivo por vez; sem bird's-eye view |
| MarkEdit | Mac only; mesmo problema do Typora |

**Obsidian vence porque:** lê a pasta existente sem import; gratuito; não injeta metadados ocultos; `.md` permanece `.md`.

> [!note] CEO do Obsidian
> Steph Ango (CEO) não força criação de conta e não tem analytics — filosofia de privacidade alinhada com armazenamento local.

## Cowork pode gerar

- Excel com abas, fórmulas, gráficos
- Word com índice, headers, letterhead
- PowerPoint com layouts e notas
- PDFs: preencher, mesclar, dividir, extrair tabelas
- Sites e dashboards interativos
- Relatórios de pesquisa (seus arquivos + web)
- Qualquer conteúdo escrito na sua voz
- Análise de CSV
- Tarefas agendadas automáticas
- Integração com Slack, Google Drive, Notion, Gmail, 50+ apps

## Conexões no vault

- [[03-RESOURCES/entities/Claude-Cowork]] — produto central deste artigo
- [[03-RESOURCES/entities/Obsidian]] — interface para gerenciar pasta Cowork
- [[03-RESOURCES/entities/Ruben-Hassid]] — autor
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] — o conceito que Cowork + Obsidian implementa
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — Skills como extensão do sistema Cowork

## Por que "os arquivos são o prompt" é o insight correto

A afirmação central do artigo — "The files are the prompt. Forever." — é uma reformulação do problema de contexto. Prompts únicos são contexto descartável: cada sessão começa do zero, com toda a carga cognitiva de re-explicar quem você é, o que importa, como você escreve, e o que você não quer. Arquivos persistentes são contexto acumulado: cada sessão começa com toda essa especificação já carregada, sem custo adicional.

O efeito composto é real. No início, os arquivos are genéricos. Após semanas de refinamento — removendo o que o Claude ignora, adicionando o que está faltando, tornando as regras mais específicas — os arquivos convertem-se em uma especificação densa da voz, preferências e contexto do usuário. Um prompt de 5 minutos nunca alcança essa densidade.

## Obsidian como interface técnica ótima para arquivos persistentes

A escolha de Obsidian não é arbitrária. Obsidian resolve o problema de gerenciar arquivos `.md` sem impor overhead de desenvolvedor (git, terminal, editor de código). A pasta é o produto: Obsidian aponta para ela, Cowork aponta para ela, e os dois nunca conflitam porque são leitores/escritores da mesma fonte de verdade no filesystem.

A comparação com Notion é a mais instrutiva: Notion é cloud-based com formato proprietário, o que significa que editar um arquivo em Notion não é editar um `.md` diretamente — é editar um objeto Notion que pode ser exportado para `.md`. Essa indireção introduce lag, risco de formato e dependência de plataforma. Obsidian elimina todas essas camadas.

## O modelo não melhorou — o contexto melhorou

O argumento mais importante do artigo é frequentemente mal interpretado. "O Claude mudou" não é o que acontece quando o sistema começa a produzir outputs melhores. O modelo é o mesmo. O que mudou é a especificação que o modelo recebe — que ficou mais densa, mais específica, mais alinhada com o que o usuário realmente quer. Atribuir a melhora ao modelo é um erro de atribuição que impede de entender o que realmente está sendo otimizado: a qualidade e especificidade do contexto persistente.
