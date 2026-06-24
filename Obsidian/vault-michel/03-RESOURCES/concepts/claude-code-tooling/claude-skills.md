---
title: Claude Skills
type: concept
status: developing
tags: [claude-code, skills, automação, workflow, anthropic]
updated: 2026-04-16
---

# Claude Skills

Uma **skill** é uma pasta contendo `SKILL.md` que instrui Claude a executar um processo específico de forma consistente. Instalada uma vez, reutilizada para sempre — elimina a necessidade de re-explicar workflows em cada sessão.

> [!key-insight] Definição oficial (Anthropic)
> Skill = pasta com SKILL.md (obrigatório) + scripts/ + references/ + assets/ (opcionais). O YAML frontmatter é carregado **sempre** no system prompt; o corpo é carregado apenas quando Claude decide usar a skill. Isso minimiza tokens via Progressive Disclosure.

## Anatomia completa (guia oficial Anthropic)

```
your-skill-name/
├── SKILL.md          # Obrigatório — instruções + YAML frontmatter
├── scripts/          # Opcional — código executável (Python, Bash)
├── references/       # Opcional — documentação carregada conforme necessário
└── assets/           # Opcional — templates, fontes, ícones
```

### YAML frontmatter

```yaml
---
name: skill-name-kebab-case          # obrigatório; sem espaços/underscore/capitals
description: O que faz. Quando usar. Include trigger phrases específicas.  # obrigatório; <1024 chars
license: MIT                          # opcional
compatibility: Claude.ai, Claude Code # opcional
metadata:                             # opcional
  author: Nome
  version: 1.0.0
  mcp-server: nome-servidor
---
```

### Regras críticas
- `SKILL.md` é **case-sensitive** — `SKILL.MD` ou `skill.md` → upload falha
- Pasta em kebab-case — sem espaços, underscores ou capitals
- Sem `README.md` dentro da pasta da skill
- Sem XML `< >` no frontmatter (segurança)
- Nome não pode conter "claude" ou "anthropic" (reservados)
- SKILL.md: manter abaixo de **5.000 palavras**; docs detalhadas em `references/`

### Progressive Disclosure — 3 níveis

| Nível | Localização | Carregado quando |
|---|---|---|
| 1 — YAML frontmatter | System prompt sempre | Sempre (custo fixo baixo) |
| 2 — SKILL.md body | Contexto da conversa | Claude decide usar a skill |
| 3 — Linked files | Sob demanda | Claude navega quando necessário |

### O campo `description` — o mais crítico

Como Claude decide se deve carregar a skill. Formato: `[O que faz] + [Quando usar] + [Frases de trigger]`

**Bom:** `Analisa designs Figma e gera documentação para handoff de dev. Use quando o usuário subir .fig, pedir "design specs" ou "component documentation".`

**Ruim:** `Helps with projects.` (vago — skill nunca carrega)

## 3 categorias de uso

1. **Document & Asset Creation** — outputs consistentes (docs, apresentações, código)
2. **Workflow Automation** — processos multi-step; coordena MCPs em sequência
3. **MCP Enhancement** — guidance de workflow sobre tool access de MCP server

**Analogia:** MCP = cozinha profissional (ferramentas) / Skill = receita (como usar)

## Skills portáteis (modelo-agnósticas)

Formato alternativo: arquivo `.md` colado diretamente como contexto. Funciona em Claude, ChatGPT e Gemini **sem instalação**. O campo `Constraints` estrutura restrições negativas.

Ver [[03-RESOURCES/sources/claude-code-skills/20-agentic-skills-claude-chatgpt-gemini]] para 22 skills portáteis.

## Instalação

```bash
# Via npx (Claude Code)
npx skills@latest add mattpocock/skills/tdd
npx skills@latest add anthropics/skills/auto-commit
npx skills@latest add mattpocock/skills/git-guardrails-claude-code
```

Ou: Settings > Capabilities > Skills > Upload skill (Claude.ai)

**Organizacional** (desde dez/2025): admins fazem deploy workspace-wide com updates automáticos.

## 5 padrões arquiteturais (da fonte oficial)

| Padrão | Quando usar |
|---|---|
| Sequential workflow orchestration | Multi-step em ordem; rollback em falhas |
| Multi-MCP coordination | Workflow abrange múltiplos serviços (Figma → Drive → Linear → Slack) |
| Iterative refinement | Output melhora com iteração e scripts de validação |
| Context-aware tool selection | Mesmo resultado, ferramenta diferente por contexto |
| Domain-specific intelligence | Skill embute conhecimento especializado além do tool access |

## Repositórios principais

| Repo | Descrição |
|---|---|
| `anthropics/skills` | Skills oficiais da Anthropic (customizáveis) |
| `github.com/mattpocock/skills` | [[03-RESOURCES/entities/Matt-Pocock]] — ~40k★ (trending +2,987/dia em 2026-05-16); catálogo atual: /diagnose, /grill-with-docs, /triage, /improve-codebase-architecture, /tdd, /to-issues, /to-prd, /zoom-out, /prototype, /caveman, /grill-me, /handoff, /write-a-skill, /git-guardrails-claude-code |
| `github.com/obra/superpowers` | Suite de engenharia (TDD, debug, refactor) |
| `skillsmp.com` | Marketplace com 66k+ skills da comunidade |
| `skill-creator` skill | Builtin no Claude.ai; gera skills a partir de descrições naturais |

### Novos Skills AI Hero (2026-05-14)

[[03-RESOURCES/entities/Matt-Pocock|Matt Pocock]] lançou via AI Hero 4 novos skills que atacam lacunas específicas do workflow:
- **/handoff** — passa contexto completo para agente fresco (solução para [[03-RESOURCES/concepts/llm-ml-foundations/context-rot|context rot]])
- **/prototype** — variações de UI em paralelo ou app terminal para explorar business logic
- **/review** (in-progress) — verifica contra padrões do repo AND spec original
- **/writing-*** (in-progress) — fragments → beats → shape

Ver [[03-RESOURCES/sources/claude-code-skills/aihero-new-skills-handoff-prototype-review-writing]] para detalhes.

## Troubleshooting

| Sintoma | Causa | Solução |
|---|---|---|
| Upload falha | SKILL.md com nome errado | Renomear exatamente `SKILL.md` |
| Skill nunca dispara | Description vaga sem triggers | Revisar: WHAT + WHEN + triggers |
| Dispara em tudo | Description ampla demais | Adicionar negative triggers |
| Instructions ignoradas | Verboso ou instruções enterradas | Conciso + critical instructions no topo |
| MCP calls falham | MCP desconectado ou tool names errados | Settings > Extensions > verificar |
| Resposta lenta | SKILL.md grande / muitas skills ativas | `references/`; max 5k palavras; <20-50 skills simultâneas |

## Ordem de adoção recomendada

1. Meta skills (Write a Skill, Skill Creator)
2. Planning (Grill Me, PRD suite)
3. Safety (Git Guardrails, TDD, Pre-Commit)
4. Superpowers como base
5. Skills de negócio/domínio por cima
6. SkillsMP para gaps específicos

## Para o vault de Michel

Skills relevantes para o [[03-RESOURCES/entities/SEI-Automation-Agent]]:
- `/sei-process` — processar documentos do SEI (a criar)
- Padrão: Sequential workflow orchestration + Domain-specific intelligence
- As skills `claude-obsidian` instaladas no vault são exatamente esse mecanismo — ver [[03-RESOURCES/entities/claude-obsidian]]

## Relação com Plugins do Cowork

Skills são o componente fundamental dos [[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]]. Um plugin empacota múltiplas skills + conectores + slash commands + sub-agentes. Instalar um plugin = ter todas as skills relevantes para um domínio (Sales, Legal, Finance etc.) automaticamente ativas.

## Skill-as-Code: Living Codebase Pattern

Skills can be treated as a **living codebase** where an agent proposes changes via PR and a human reviews the diff before merge. This is the mechanism behind [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]] (Warp's Buzz agent): the meta-learning skill opens a daily PR updating skill files based on team feedback — principles added, sharpened, or removed. Version history, rollbacks, and human review gate all production changes.

## CONTEXT.md — Linguagem Ubíqua para Agentes (padrão Pocock)

Técnica embutida em `/grill-with-docs`: criar um `CONTEXT.md` no repo que ensina o jargon do projeto ao agente.

- BEFORE: "There's a problem when a lesson inside a section of a course is made 'real' (i.e. given a spot in the file system)"
- AFTER: "There's a problem with the materialization cascade"

Benefícios: naming de variáveis/funções/arquivos consistente; codebase mais navegável; agente gasta menos tokens em raciocínio. Inspirado em DDD (Eric Evans, Ubiquitous Language). Ver [[03-RESOURCES/sources/claude-code-skills/mattpocock-skills-claude-code]].

## Fontes

- [[03-RESOURCES/sources/claude-code-skills/mattpocock-skills-claude-code]] — **catálogo completo atual** do repositório (2026-05-16, trending)
- [[03-RESOURCES/sources/claude-code-skills/complete-guide-building-skills-claude]] — **guia oficial Anthropic** (mais autoritativo)
- [[03-RESOURCES/sources/claude-code-skills/67-claude-skills-full-dev-team]] — curadoria 67 skills (Matt Pocock e outros)
- [[03-RESOURCES/sources/claude-code-skills/20-agentic-skills-claude-chatgpt-gemini]] — 22 skills portáteis modelo-agnósticas
- [[03-RESOURCES/sources/claude-code-skills/20-agentic-skills-claude-chatgpt-gemini]] — 20 skills com skills visuais e de vídeo adicionais
- [[03-RESOURCES/sources/ai-agents-harness/claude-code-linkedin-playbook]] — 5 core skills para LinkedIn GTM; trigger description como fator crítico de carregamento; MCP→skill conversion para reduzir token overhead

## Evidências
- **[2026-06-19]** SKILL.md bem curado é o que fecha a lacuna de performance entre modelo aberto barato (MiniMax) e modelo de fronteira (Fable) — não o modelo em si — [[how-i-turned-minimax-into-fable-5-97-percent-cheaper]]
- **[2026-06-19]** Skill `/pr-walkthrough` (warpdotdev/common-skills) gera site interativo D3 a partir de link de PR, instalável via `npx skills add` — exemplo de skill empacotável cobrindo migração de output de agente de Markdown para HTML rico — [[generate-interactive-pr-walkthroughs-with-a-single-skill]]
- **[2026-06-24]** Skills são camada operacional (routing + progressive disclosure + curation), não upgrade de modelo — não criam precisão... — [[benchmarking-nvidia-bionemo-agent-toolkit-skills-for-nim-microservices-2]]
- **[2026-06-24]** Instructions são system prompt always-on (identidade permanente), vs skills (on-demand). Eve prepende instructions a... — [[instructions-eve-docs]]
- **[2026-06-24]** Wireframe prompt como skill registrada no Claude: layout+design+writing rules em 1 prompt → zip → save → reusável com 1... — [[wireframe-prompt-claude-skill]]
