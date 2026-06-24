---
title: "The Ultimate Guide to Master Claude Tools (FULL COURSE)"
type: source
source_file: ".raw/articles/The Ultimate Guide to Master Claude Tools (FULL COURSE).md"
author: AI Edge (@aiedge_)
ingested: 2026-04-17
tags: [claude, tools, productivity, cowork, claude-code, skills, connectors]
triagem_score: 7
---

# The Ultimate Guide to Master Claude Tools (FULL COURSE)

**Autor:** AI Edge — [@aiedge_](https://x.com/aiedge_)

Guia completo sobre todas as ferramentas do Claude organizadas em 4 tiers de complexidade. O insight central: o maior ganho de produtividade não vem de prompt avançado, mas de usar ferramentas que 99% dos usuários ignoram mesmo pagando por elas.

## Tier 1 — Core Interface Tools

| Ferramenta | Função central |
|---|---|
| **Projects** | Contexto persistente por área — sem re-explicar a cada sessão |
| **Skills** | Arquivos `.md` com workflows pré-carregados; chamados via `/comando` |
| **Memory** | Settings → Memory → revisar o que Claude retém; exportável de ChatGPT |
| **Connectors** | Acesso a Google Drive, Gmail, Slack, Notion, Calendar, Excalidraw e 50+ |

## Tier 2 — Research & Thinking Tools

- **Deep Research / Research Mode** — quebra a query em dezenas de fontes, cross-referencia e gera relatório citado. Pode levar de 5 a 45 minutos. Habilitado via botão "+" no chatbox.
- **Extended Thinking** — força raciocínio mais profundo antes de responder. Ativa via linguagem ("think deeply before responding") ou toggle de interface. Combinar com Opus 4.6 para raciocínio complexo.
- **Artifacts** — arquivos de código (HTML, React, docs, diagramas, planilhas) visualizáveis, editáveis e baixáveis. Padrão habilitado. Dizer "create this as an Artifact".

## Tier 3 — Agentic Tools

### Claude Cowork
Disponível apenas no desktop app. Três features diárias:
1. **Scheduled Tasks** — execução automática em cadência fixa (pesquisa diária, scan de Gmail/Calendar)
2. **File Access** — Claude acessa pasta local; edita e trabalha em workspaces locais
3. **Plug-Ins** — bundle de múltiplas Skills em um único role (Skills = automação single; Plug-Ins = role completo)

### Cowork Dispatch
- Permite rodar Cowork via celular enquanto o laptop fica aberto
- Configurado via "Dispatch" dentro do Cowork

### Claude in Chrome
- Conector que permite ao desktop app iniciar uma tarefa e executar trabalho no browser sem trocar janelas
- Disponível na Chrome Web Store (publisher: Anthropic)

## Tier 4 — Building & Coding

### Claude Code
Capacidades: debugging, deploy de sites/apps, testes, auditorias de segurança, planejamento, vibe coding.

### Slash Commands
Sistema de comandos built-in que acelera operações. Também é possível criar slash commands customizados.

### CLAUDE.md
Arquivo criado na raiz do projeto, lido automaticamente antes de cada sessão do Claude Code. Contém: padrões de código, decisões arquiteturais, estrutura de arquivos, proibições.

```
CLAUDE.MD EXEMPLO:
This is a Next.js project using TypeScript and Tailwind.
Always use functional components. Never use class components.
Run npm run lint before committing any changes.
All API calls go through the /lib/api folder.
Do not modify the /config folder without asking first.
```

### Multi-Agent / Subagents
Claude Code spawna subagentes em paralelo para diferentes partes do projeto. Ativados com prompts de alto nível, orientados a outcome (não step-by-step).

### Memory (/memory)
Sistema de memória próprio do Claude Code, separado do web memory. Armazena preferências, padrões e contexto de projeto em arquivo de memória persistente.

> [!key-insight] Stack de qualidade no Claude Code
> CLAUDE.md + /memory + slash commands + subagents = entendimento compounding do projeto ao longo do tempo.

## Por que a maioria dos usuários nunca sobe de Tier 1

O artigo identifica que 99% dos usuários pagam pelo Tier 3 e 4 mas usam apenas Tier 1 (Projects, Skills, Memory, Connectors). O motivo não é falta de interesse — é falta de descoberta. As ferramentas mais poderosas não estão na interface principal.

**Cowork** requer o app desktop. Quem usa Claude pelo browser nunca o descobre. **Claude Code** requer instalação via terminal. Quem nunca abriu um terminal nunca o tenta. **Subagents** requerem entender que existe um modo de prompt de alto nível orientado a outcome.

A progressão de valor é exponencial entre tiers, mas a descoberta é linear. Cada tier tem uma barreira de entrada que filtra a maioria dos usuários.

## Skills como infraestrutura de processo — não apenas conveniência

O artigo posiciona Skills como "arquivos .md com workflows pré-carregados, chamados via /comando". Isso é tecnicamente correto mas subestima o que Skills representam em termos de design de sistema.

Uma Skill é um **protocolo de trabalho codificado**. Quando você tem uma skill para `brand-voice`, você não só economiza tempo de re-prompting — você garante que toda vez que Claude escreve com a voz da marca, ele segue as mesmas regras. A consistência não é acidental; é arquitetural.

Para equipes (Claude Teams/Enterprise), Skills compartilhadas significam que todos os membros têm acesso ao mesmo protocolo. Um novo membro invoca `/quarterly-report` e segue o mesmo processo que um membro com 2 anos de experiência. Skills são conhecimento institucional codificado.

## Extended Thinking — quando usar e quando não usar

O guia menciona Extended Thinking como "força raciocínio mais profundo". A distinção prática entre quando usar e quando não usar:

**Use Extended Thinking quando:**
- A resposta errada tem custo alto (decisões irreversíveis, código que vai para produção)
- O problema tem múltiplas dimensões que interagem de forma não-óbvia
- Você quer entender o raciocínio, não só a resposta

**Não use Extended Thinking quando:**
- A tarefa é de execução simples (formatar texto, converter formato, resumir)
- Você precisa de resposta rápida e a qualidade marginal não justifica latência
- A tarefa requer criatividade/fluência, não análise

O custo de Extended Thinking é duplo: tokens adicionais (thinking tokens) e latência. Para sessões longas de Claude Code, usar Extended Thinking em cada passo é economicamente inviável.

## Memory do Claude Code — separado do web memory

O guia nota que `/memory` no Claude Code é separado do "Memory" do Settings na interface web. Essa distinção tem implicações práticas:

**Web Memory** (Settings → Memory): armazena preferências pessoais que o Claude recupera em conversas futuras no Claude.ai. É uma base de fatos sobre o usuário.

**Claude Code /memory**: sistema de memória do agente de código — armazena padrões do projeto, preferências de código, decisões arquiteturais. É um arquivo de texto em `~/.claude/projects/[hash]/memory/` que o agente pode ler e escrever.

Para este vault, o `/memory` do Claude Code contém `MEMORY.md` com referências a arquivos como `user_profile.md`, `project_vault.md`, etc. — exatamente o "working memory" descrito no artigo.

## O stack de qualidade completo

O key-insight do artigo — `CLAUDE.md + /memory + slash commands + subagents = entendimento compounding` — merece explicação da palavra "compounding":

- **CLAUDE.md**: contexto inicial de cada sessão (estático, você mantém)
- **/memory**: aprendizado acumulado do agente ao longo de sessões (dinâmico, cresce)
- **slash commands**: workflows codificados que evoluem com uso (você refina)
- **subagents**: paralelização que multiplica output sem multiplicar contexto

O "compounding" acontece porque cada componente alimenta os outros. Subagents bem-sucedidos revelam padrões que vão para /memory. /memory informa CLAUDE.md. CLAUDE.md melhora os slash commands. O sistema fica mais capaz sem você precisar fazer nada diferente.

## Conexões no vault

- [[03-RESOURCES/entities/Claude-Cowork]] — Tier 3 expandido
- [[03-RESOURCES/entities/Claude Code]] — Tier 4; base técnica
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — Skills como core do Tier 1
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — subagents em contexto arquitetural
- [[03-RESOURCES/entities/AI-Edge]] — autor
