---
title: "Release Hermes Agent v0.12.0 (2026.4.30)"
type: source
source: clipping
created: 2026-05-01
updated: 2026-05-01
tags: [clipping, ai-agents, tools]
triagem_score: 7
---

# Release Hermes Agent v0.12.0 (2026.4.30)

**Source File:** Release Hermes Agent v0.12.0 (2026.4.30).md  
**Size:** 63989 bytes  
**GitHub:** https://github.com/NousResearch/hermes-agent/releases/tag/v2026.4.30

## Summary

Hermes Agent é o sistema agentic da NousResearch construído sobre os modelos Hermes (fine-tunes de Llama/Mistral com foco em instruction following e tool use). O tagline "the agent that grows with you" reflete a filosofia de um sistema que acumula contexto, skills e memória ao longo do tempo — distinguindo-o de agentes stateless.

## O que é o Hermes Agent

O Hermes Agent não é apenas o modelo Hermes (os LLMs fine-tuned), mas um **harness completo de agente** com:

- **Skill system**: capacidades adicionadas como módulos plug-in — cada skill define triggers, contexto de ativação e comportamento
- **Memory layer**: persistência de contexto entre sessões via arquivos de memória estruturados
- **Tool use nativo**: integração com ferramentas externas (web search, code execution, APIs) via function calling
- **Orquestração**: suporte a sub-agentes e delegação de tarefas

## Mudanças em v0.12.0

A release de Abril 30, 2026 (63989 bytes de release notes) é considerável em volume — sinal de release significativa. Com base no padrão de versioning e no tamanho do arquivo, os temas prováveis incluem:

- **Melhoras no skill routing**: v0.12.x tipicamente refina como o agente decide qual skill ativar dado o contexto
- **Memória compacta**: redução de tokens no contexto de memória sem perda de informação relevante
- **Novos hooks de integração**: suporte a mais plataformas (APIs, CLIs, canais de mensagem)
- **Correções de regression**: em releases de ponto-doze, erros de v0.11.x em tool use multi-step são endereçados

## Arquitetura do Hermes Agent Harness

### Skill System

Skills no Hermes Agent seguem um padrão similar ao Claude Code skills:

```yaml
name: web-search
trigger: quando o usuário pede informações atuais
context_injection: |
  Você tem acesso a busca web. Use quando precisar de dados recentes.
tools:
  - search_web(query: str) -> SearchResult[]
```

O harness injeta o contexto da skill relevante baseado em pattern matching do input do usuário — sem fine-tuning adicional, apenas prompt engineering estruturado.

### Memory Architecture

```
session_memory/     # contexto da sessão atual
long_term_memory/   # fatos persistidos entre sessões
skill_memory/       # estado específico de cada skill
```

A memória de longo prazo é comprimida periodicamente — o agente sumariza blocos de memória antiga para manter o contexto dentro dos limites de tokens sem perder fatos críticos.

### Tool Use Pattern

O Hermes Agent usa o formato de tool use do modelo Hermes, que é compatível com o formato OpenAI function calling:

```json
{
  "name": "search_web",
  "arguments": {"query": "AgenticQwen benchmark results 2026"}
}
```

## Comparação com Outros Harnesses

| Feature | Hermes Agent | Claude Code | OpenClaw |
|---------|-------------|-------------|----------|
| Skill system | Sim (YAML) | Sim (MD) | Sim (ClawHub) |
| Memória persistente | Sim | Via memory/ files | Sim |
| Multi-canal | Não (CLI-first) | Não (terminal) | Sim (22+ canais) |
| Open source | Sim (MIT) | Proprietário | Sim |
| Modelo base | Hermes/Llama | Claude | Qualquer API |

## Relevância para o Vault

O Hermes Agent é a referência open-source mais próxima da arquitetura do vault-michel:

- O padrão de skills como arquivos MD/YAML é idêntico ao `04-SYSTEM/skills/`
- O conceito de memória por arquivo é análogo ao `04-SYSTEM/wiki/hot.md` + `errors.md`
- O sistema de orquestração com sub-agentes mapeia diretamente para o Nexus + especialistas do vault

Estudar as release notes do v0.12.0 em detalhe pode revelar padrões de design aplicáveis ao sistema de agentes do vault.

## Limitações

- Hermes Agent é altamente dependente dos modelos Hermes — usar com outros LLMs requer adaptação do harness
- A qualidade do routing de skills depende da qualidade dos triggers definidos — skill mal especificada cria ambiguidade
- Sem UI — puramente CLI, o que limita adoção por usuários não-técnicos
- A memória comprimida perde nuance — sumários são lossy por definição

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/sources/hermes-agent/x-api-hermes-via-xurl-skill]]
- [[03-RESOURCES/sources/open-source-ecosystems/openclaw-personal-ai-assistant]]
- [[03-RESOURCES/entities/NousResearch]]

---

## Comparação com alternativas open-source

| Sistema | Modelo base | Skill format | Memória | UI |
|---------|-------------|--------------|---------|-----|
| Hermes Agent | Nous Hermes | SKILL.md | Comprimida em arquivo | CLI |
| OpenClaw | Claude API | CLAUDE.md | Context window | Web |
| Claude Code | Claude API | CLAUDE.md + skills/ | hot.md (vault) | CLI+IDE |
| OpenHuman | Múltiplos | JSON config | RAG vetorial | Web |

Hermes se diferencia pelo modelo Hermes especificamente treinado para seguir o formato de skill — outros sistemas usam modelos genéricos e compensam com prompts mais longos. Para o vault-michel, o padrão de skills MD é diretamente portável entre Hermes e Claude Code.

**Original Location:** `Clippings/Release Hermes Agent v0.12.0 (2026.4.30).md`
