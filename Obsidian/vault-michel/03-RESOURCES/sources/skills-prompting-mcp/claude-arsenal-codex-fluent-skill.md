---
title: "claude-arsenal: codex-fluent skill"
type: source
source: "Clippings/claude-arsenalskillscodex-fluent at main.md"
original_url: "https://github.com/majiayu000/claude-arsenal/blob/main/skills/codex-fluent/SKILL.md"
author: "majiayu000"
published: 2026-05-28
created: 2026-05-28
ingested: 2026-05-29
tags: [ai-agents, claude-code, codex, skills, session-hygiene, context-management]
---

## Tese central

`codex-fluent` é uma skill do repositório [claude-arsenal](https://github.com/majiayu000/claude-arsenal) que resolve o problema de degradação de performance do Codex com uso intenso: ao longo de meses de uso diário, sessions acumulam estado, worktrees ficam obsoletos, logs crescem — e o ambiente fica lento. A skill oferece diagnóstico, handoff obrigatório antes de arquivar, e manutenção segura.

## Argumentos principais

- O problema que a skill resolve: Codex ficando lento no startup ou na troca de sessões após uso pesado multi-repo
- A filosofia central: "Fresh small state = speed and low mental load. Old work must be preserved, but moved out of the active path."
- Handoffs são inegociáveis antes de arquivar qualquer trabalho ativo que você possa precisar continuar
- Nunca deletar, sempre arquivar — com paths de restore claros: `~/.codex/archived_sessions/`, `archived_worktrees/`, `archived_logs/`
- A primeira invocação deve sempre ser report-only (diagnóstico sem mudanças)
- Codex deve estar fechado antes de qualquer mudança no filesystem de estado ativo
- Cadência recomendada: heavy multi-repo users → semanal; moderate users → a cada 10-14 dias

## Key insights

- **Diagnóstico antes de tudo:** A skill reporta active vs archived session sizes, maiores sessions e idades, stale worktrees, large logs, thread metadata bloat, dead config entries, heavy background processes (report only)
- **Handoff template como artefato:** O handoff deve permitir que um thread completamente novo (ou Claude via codex skill) retome sem o contexto gigante antigo — é o "ultimate compact representation of a thread"
- **Manutenção normal faz:** backup timestampado, move sessions antigas para archive, move stale worktrees, rotaciona logs oversized, limpa dead project entries do config, normaliza path issues
- **Integração com codex-retrospective:** O flow ideal é: `codex-retrospective` identifica melhorias comportamentais/de conhecimento → `codex-fluent` resolve bloat de estado/contexto. São complementares.
- **Strategic-compact thinking:** Ao criar handoff documents, aplicar "strategic compact" — a representação mais densa possível do thread para reativação futura
- **O que a skill NÃO faz:** não deleta nada, não mata processos, não toca credentials, não arquiva pinned/protected sessions sem confirmação

## Exemplos e evidências

- 74 production-ready Claude Code skills no repositório claude-arsenal
- 7 agentes especializados para engineering, DevOps, product workflows, UI, deployment, AI-agent automation
- Caminhos de archive: `~/.codex/archived_sessions/`, `~/.codex/archived_worktrees/`, `archived_logs/`
- Backup path: `~/Documents/Codex/codex-backups/codex-fluent-YYYYMMDD-HHMM/`

## Implicações para o vault

- Padrão de "session hygiene como skill" é aplicável além do Codex — qualquer agente com estado persistente acumula bloat
- O princípio de "fresh small state" conecta com [[03-RESOURCES/concepts/llm-ml-foundations/context-rot|context-rot]] — o fenômeno de contexto acumulado degradando output
- A arquitetura de handoff antes de archive é um padrão de continuidade que o vault pode adotar para sessões Claude Code longas
- Complemento direto à source [[03-RESOURCES/sources/skills-prompting-mcp/claude-arsenal-codex-retrospective-skill|codex-retrospective skill]]
- claude-arsenal como repositório (~74 skills) é recurso relevante para [[03-RESOURCES/concepts/agent-systems/agentic-skills]]

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/sources/skills-prompting-mcp/claude-arsenal-codex-retrospective-skill]]
- [[03-RESOURCES/entities/Claude Code]]
