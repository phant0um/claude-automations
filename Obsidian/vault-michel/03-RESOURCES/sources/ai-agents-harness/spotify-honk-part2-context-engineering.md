---
title: "Background Coding Agents: Context Engineering (Honk, Part 2)"
type: source
source: "Clippings/Background Coding Agents Context Engineering (Honk, Part 2).md"
url: "https://engineering.atspotify.com/2025/11/context-engineering-background-coding-agents-part-2"
authors:
  - "Max Charas (Senior Staff Engineer, Spotify)"
  - "Marc Bruggmann (Principal Engineer, Spotify)"
published: 2025-11-01
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, context-engineering, spotify, honk, coding-agents, claude-code, migration, prompt-engineering]
score: A
---

# Background Coding Agents: Context Engineering (Honk, Part 2)

Parte 2 da série sobre o projeto Honk (Spotify) — background coding agent para manutenção em larga escala de código. Foco em **context engineering**: o que faz um bom migration prompt? Quais ferramentas o agente deve ter? Como produzir PRs confiáveis e mergeáveis em milhares de repos.

> Série: Part 1 → [[03-RESOURCES/sources/spotify-honk-part1-background-coding-agents]] · Part 3 · Part 4

## Tese Central

Context engineering — a engenharia cuidadosa de o que o agente vê no contexto — é o determinante primário de qualidade dos PRs. Mais do que escolha de modelo ou número de ferramentas.

## Argumentos Principais

### Trajetória de Agentes

O time Spotify experimentou três abordagens em ordem de maturidade:

| Abordagem | Problema Central |
|-----------|-----------------|
| Open source (Goose, Aider) | Difícil escalar para migration over thousands of repos; PRs inconsistentes |
| Homegrown agentic loop | Exigia git-grep manual para selecionar arquivos; loop de 10 turnos frequentemente esgotado; contexto esquecido no meio |
| **Claude Code** | Natural task-oriented prompts; built-in Todo lists; subagents; ~50 migrations rodadas; majority of merged PRs |

Claude Code é o top-performing agent de Spotify a partir do momento do artigo. Boris Cherny (Anthropic) cita o projeto como exemplo de "thousands of PRs merged across hundreds of repositories" usando Claude Agent SDK.

### Anti-Padrões de Prompt

Dois padrões ruins observados quando usuários promovem o agente sem treinamento:

1. **Overly generic prompt** — espera que o agente adivinhe intenção e outcome
2. **Overly specific prompt** — tenta cobrir cada caso, colapsa quando encontra algo inesperado

### Princípios de Prompt Engineering (Hard-Won)

1. **Tailor to the agent** — Claude Code responde melhor a prompts que descrevem estado final, não passo-a-passo
2. **State preconditions** — dizer explicitamente *quando não agir* (e.g., se o target não usa a lib alvo)
3. **Use examples** — poucos exemplos concretos de código influenciam pesadamente o outcome
4. **Define desired end state via tests** — objetivo verificável permite iteração confiável
5. **Do one change at a time** — prompts combinados exaurem contexto ou entregam resultado parcial
6. **Ask the agent for prompt feedback** — após a sessão, o agente em si aponta o que faltou no prompt

Exemplo prático: prompt para migrar AutoValue → Java records.

### Tool Design (Menos é Mais)

Spotify mantém o background coding agent **minimal em tools** deliberadamente:

- **Verify tool (MCP)** — roda formatters, linters e testes. Encapsula o build system heterogêneo de milhares de repos. Sumariza logs para digestão pelo agente.
- **Git tool (limitado)** — expõe subcomandos selecionados (nunca `push`, nunca `change origin`). Padroniza committer e formato de commit.
- **Bash tool (allowlist estrito)** — poucos comandos (e.g., ripgrep).

**Notavelmente ausentes:** code search e documentation tools. O contexto relevante é condensado no prompt pelo usuário (ou por workflow agents upstream).

**Raciocínio:** mais ferramentas = mais dimensões de imprevisibilidade. Prompts estáticos maiores são versionáveis, testáveis, avaliáveis.

### Prompt Estático vs. MCP Dinâmico

| Abordagem | Vantagem | Desvantagem |
|-----------|----------|-------------|
| Prompt estático grande | Versionável, testável, previsível | Usuário precisa condensar contexto manualmente |
| MCP dinâmico | Agente busca contexto sob demanda, ambiguidade aceita | Menos testável, comportamento emergente |

Spotify optou por prompts estáticos grandes.

## Key Insights

- **Context engineering > model choice** — a disciplina de design do contexto determina qualidade dos PRs, não a escolha do modelo
- **Previsibilidade > capacidade** — preferem prompt grande e estável a agente altamente capaz porém imprevisível
- **Verificabilidade como destino** — sem testes como critério de sucesso, o agente não tem como iterar
- **Prompts evoluem por trial-and-error** — sem avaliação estruturada ainda; próximos passos: feedback loops (Part 3)
- **Claude Code habilita escala** — Todo lists nativas + subagents permitiram o que o loop homegrown não conseguia

## Exemplos e Evidências

- ~50 migrations executadas com Claude Code
- Majority of background agent PRs merged into production
- Exemplo de prompt: migração AutoValue → Java records (abbreviado no artigo)
- Boris Cherny (Anthropic): "thousands of PRs merged across hundreds of repositories"

## Implicações para o Vault

- Reforça [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] com caso de uso real de produção em escala
- Adiciona evidência para [[03-RESOURCES/concepts/agent-systems/harness-engineering]] (minimal tools deliberadamente)
- Documenta prompts estáticos como primeiro-cidadão vs. MCP dinâmico — trade-off relevante para design de agentes no vault
- Valida o padrão do vault de CLAUDE.md + hot.md como "context engineering em vez de model upgrade"

## Links

- [[03-RESOURCES/sources/spotify-honk-part1-background-coding-agents]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/entities/Claude Code]]
