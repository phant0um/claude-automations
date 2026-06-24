---
title: Agent Abstraction Layers
type: concept
area: agent-systems
created: 2026-05-31
updated: 2026-05-31
score: 7
tags: [concept, agent-systems, abstraction, skills, metacommands, orchestration, superclaude, framework]
---

# Agent Abstraction Layers

## Tese central

Sistemas agenticos operam em múltiplas camadas de abstração. "Skills" e "slash commands" (ex: SuperClaude) não são substitutos nem concorrentes — são camadas distintas na mesma hierarquia. Confundir camadas gera tensões falsas (ex: "SuperClaude usa comandos, não skills") e design incoerente.

## A hierarquia

```
Nível 4 — Framework Layer
  Framework de meta-programação: SuperClaude, sistema de skills do vault
  Orquestra componentes do nível 3; injeta comportamento estrutural
  Ex: superclaude install instala 30 /sc:* commands + 8 MCPs + personas

Nível 3 — Metacommand Layer  
  Slash commands de alto nível: /sc:build, /sc:review, /sc:design
  Cada comando orquestra múltiplos skills + persona + MCP
  Ex: /sc:review → activa persona Analyzer + tools Read/Grep + quality protocols

Nível 2 — Skill Layer
  SKILL.md: comportamento encapsulado e reutilizável
  Unidade de conhecimento procedural: "como fazer X"
  Ex: wiki-ingest, pipeline-diario, code-review skill

Nível 1 — Tool Layer
  Tool calls primitivas: Read, Write, Bash, WebSearch, MCP tools
  Sem estado, sem contexto, sem lógica de orquestração
  Ex: mcp__filesystem-vault__read_file, Bash("grep ...")
```

## Por que a confusão existe

SuperClaude descreve a si mesmo como "framework de meta-programação que transforma Claude Code via behavioral instruction injection." O conceito `agentic-skills` descreve skills como "comportamentos encapsulados e reutilizáveis."

Aparente contradição: SuperClaude "não usa SKILL.md", usa `/sc:*` commands.

**Resolução**: SuperClaude opera no Nível 3-4 e _invoca_ skills do Nível 2. Dentro de cada persona do SuperClaude há conhecimento procedural equivalente a skills — só que codificado em instructions, não em arquivos separados. O formato é diferente; a abstração é a mesma.

## Padrão de composição

```
Framework (N4)
  └── Metacommand /sc:review (N3)
        ├── Ativa persona "Analyzer"
        ├── Define quality-first protocol
        └── Invoca em sequência:
              skill: code-review (N2)
                └── tool: Read, Grep, Bash (N1)
              skill: security-review (N2)
                └── tool: Read, Bash (N1)
```

## Implicações de design

1. **Não conflate níveis**: um framework (N4) não é uma alternativa a uma skill (N2) — pode conter muitas
2. **Skill ≠ command**: skill é conhecimento procedural; command é ponto de entrada com orquestração
3. **Portabilidade por nível**: skills (N2) são portáveis entre runtimes; frameworks (N4) são runtime-specific
4. **Custo de contexto por nível**: framework injection (N4) consome mais budget fixo que skill standalone (N2)
5. **SkillOpt aplica ao Nível 2**: otimização de skill é Nível 2; não aplica diretamente a commands (N3) ou frameworks (N4)

## Casos concretos no vault

| Artefato | Nível |
|----------|-------|
| `claude-obsidian:wiki-ingest` | Skill (N2) invocada por Agent Tool |
| `/sc:build` (SuperClaude) | Metacommand (N3) |
| SuperClaude framework (30 commands + 8 MCPs) | Framework (N4) |
| `mcp__filesystem-vault__read_file` | Tool (N1) |
| `04-SYSTEM/agents/Nexus Agent System/` | Framework (N4) — Nexus orquestra skills/agents |

## Framework de Decisão: Quando Usar Cada Nível

Hierarquia para escolher o artefato certo por complexidade (validado em produção com 35 agentes paralelos):

| Situação | Ferramenta | Motivo |
|----------|-----------|--------|
| Task rápida, não repetitiva | Ask Claude diretamente | Overhead zero |
| Workflow repetitivo | Skill (N2) | Encapsula, reutiliza |
| Trabalho paralelo ao contexto principal | Subagent | Janela própria, não contamina main |
| N agentes coordenados, resultado merged | Workflow (script externo) | Scale + reutilizável como botão |

**Regra**: workflow é melhor para audits/análises paralelas em lote. Não usar quando tasks dependem umas das outras (aí subagent ou skill sequencial).

Fonte: [[03-RESOURCES/sources/35-agents-claude-code-without-burning-plan]]

## Evidências
- **[2026-06-22]** Agent-Native (BuilderIO) define a "action" como unidade atômica que serve UI, agente, HTTP, MCP, A2A e CLI simultaneamente — abstração de negócio compartilhada entre camadas, distinta de skill/comando. — [[03-RESOURCES/sources/builderioagent-native-a-framework-for-building-agent-native-applications]]

## Relacionado

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — definição de skills (Nível 2)
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]] — SkillOpt opera no Nível 2
- [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]] — tool layer (Nível 1)
- [[03-RESOURCES/sources/claude-code-cowork/superclaude-framework]] — framework (Nível 3-4)
- [[03-RESOURCES/sources/claude-code-skills/anthropic-how-we-use-skills]] — skill design patterns
- [[03-RESOURCES/sources/claude-code-skills/anthropic-seeing-like-an-agent]] — progressive disclosure (bridge N1→N2)
