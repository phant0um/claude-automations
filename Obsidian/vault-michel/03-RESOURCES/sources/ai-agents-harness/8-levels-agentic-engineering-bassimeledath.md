---
title: "The 8 Levels of Agentic Engineering"
type: source
source: "Clippings/The 8 Levels of Agentic Engineering.md"
url: "https://www.bassimeledath.com/blog/levels-of-agentic-engineering"
author: ["Bassim Eledath"]
created: 2026-05-26
ingested: 2026-05-28
tags: [ai-agents, source, harness-engineering, background-agents, compounding-engineering]
---

## Tese central

Existe uma progressão de 8 níveis de prática de engenharia agêntica — de tab complete a times autônomos de agentes. O gap entre capacidade de modelos e prática de engenharia é onde vive o valor, e esse gap fecha em níveis. Cada nível é uma alavanca de produtividade multiplicada por melhoria de modelos.

## Argumentos principais

1. **Level 1–2: Tab Complete & Agent IDE.** Copilot e autocomplete. Cursor com edições multi-arquivo. Teto: contexto. Introdução ao plan mode.

2. **Level 3: Context Engineering.** Buzz de 2025. "Cada token precisa lutar pelo seu lugar no prompt." Abrange system prompt, `CLAUDE.md`, tool descriptions, histórico de conversa, seleção de tools por turno. Evolui: de filtrar contexto ruim para garantir contexto certo no momento certo.

3. **Level 4: Compounding Engineering.** Criado por Kieran Klaassen. Loop: **Plan → Delegate → Assess → Codify**. O passo Codify é o que faz compounding: atualizar `CLAUDE.md` (ou equivalente) com lições aprendidas para que cada sessão futura seja melhor. LLMs são stateless — sem codify, o mesmo erro volta amanhã.

4. **Level 5: MCP e Skills.** Solve capability, não context. MCP dá ao LLM acesso a banco de dados, APIs, CI, design system, browser. Skills compartilhadas em equipe com PR review, version history. Trend: CLIs em vez de MCPs por eficiência de tokens (schemas MCP injetados a cada turno; CLI injeta só o output relevante).

5. **Level 6: Harness Engineering & Automated Feedback Loops.** "Este é onde o foguete realmente começa a decolar." Harness = ambiente, tooling e loops de feedback que permitem ao agente fazer trabalho confiável sem intervenção humana. Elementos: Chrome DevTools wired into runtime, observability, `converse` CLI para testes turn-by-turn. Conceito central: **backpressure** (type systems, tests, linters, pre-commit hooks que permitem ao agente detectar e corrigir erros sem humano). Security boundaries como backpressure. **Constraints > instructions** (definir fronteiras funciona melhor que checklists step-by-step).

6. **Level 7: Background Agents.** Hot take: plan mode está morrendo. Com modelos melhores e harness limpo, o agente planeja de forma autônoma. Ralph loop + Dispatch. Múltiplos workers em paralelo → você vira middle manager → precisa de orchestrator. **Separar implementer de reviewer** (mesmo modelo não avalia seu próprio trabalho — bias inevitável). **Diferentes modelos para diferentes jobs**: Opus para implementação, Gemini para pesquisa exploratória, Codex para review. Background agents + CI = automação de docs, security review, dependency upgrades.

7. **Level 8: Autonomous Agent Teams.** Nível não dominado ainda. Hub-and-spoke → coordenação direta entre agentes sem orchestrator central. Claude Code Agent Teams (16 agentes paralelos → compilador C). Cursor: centenas de agentes para migrar codebase. Problema atual: sem hierarquia, agentes ficam risk-averse e churnam; sem CI, agentes quebram funcionalidades existentes. Conclusão: Level 7 é onde está a alavanca hoje.

## Key insights

- **Multiplayer effect**: sua produtividade em Level 7 é limitada pelo nível mais baixo do time. É do seu interesse puxar o time para cima.
- **Compounding loop > CLAUDE.md dump**: tentar codificar tudo no rules file gera "too many instructions = none". Melhor: manter `docs/` atualizado para que o LLM descubra contexto relevante por conta própria.
- **Separar reviewer de implementer**: se o mesmo modelo instance implementa e avalia, ele vai reportar "tasks complete" quando não estão. Não é má-fé — é o mesmo motivo de não corrigir a própria prova.
- **Backpressure** como conceito de segurança: constraints do que o agente *pode* fazer, não apenas do que *deve* fazer — análogo a security boundaries em sistemas distribuídos.

## Exemplos e evidências

- **Dispatch** (bassimeledath/dispatch): skill de Claude Code que mantém sessão principal limpa enquanto workers operam em contextos isolados. Dispatcher planeja, delega, rastreia; quando worker trava, surfaça pergunta de clarificação.
- **Ramp Inspect**: sessões de agente em VMs cloud sandboxed. PM vê bug no Slack → Inspect pega e executa enquanto laptop está fechado.
- **OpenAI Codex harness**: Chrome DevTools + observability + navegação de browser wired no runtime. Agente reproduz bug, grava vídeo, implementa fix, valida via browser, abre PR, responde review, faz merge.

## Implicações para o vault

- Mapa de progressão diretamente aplicável: Michel está praticando Levels 4–6 (compounding com `CLAUDE.md`, MCP/skills, harness no vault). Level 7 = background agents para ingest/audit automático.
- Enriquece [[03-RESOURCES/concepts/agent-systems/harness-engineering]] com o nível 6 e backpressure.
- O conceito de **compounding engineering** (plan→delegate→assess→codify) é precursor do workflow do vault.
- Enriquece [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] com o argumento de Level 7 vs Level 8 e separação implementer/reviewer.
- **Novo conceito proposto**: `agentic-engineering-levels` como framework de progressão.

## Links

- URL: https://www.bassimeledath.com/blog/levels-of-agentic-engineering
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- Conceito novo: [[03-RESOURCES/concepts/agent-systems/agentic-engineering-levels]]
