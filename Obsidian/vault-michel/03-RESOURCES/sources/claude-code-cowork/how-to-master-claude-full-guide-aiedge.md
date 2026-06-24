---
title: "How to Master Claude (FULL GUIDE)"
type: source
source: "[@aiedge_](https://x.com/aiedge_/status/2065427117522002375)"
created: 2026-06-13
ingested: 2026-06-13
tags: [ai-agents]
---

## Tese central

3 níveis de uso de Claude, do mais simples ao mais autônomo — a pergunta-
chave a cada task é "como posso usar Cowork/Claude Code para automatizar
isto?".

## Argumentos principais

- **3 níveis de Claude**: Level 1 = Chat (prompt-based, a maioria fica
  aqui); Level 2 = Cowork (completa tarefas — Scheduled Tasks + Dispatch);
  Level 3 = Claude Code (constrói coisas — apps/dashboards/scripts a partir
  de pastas de contexto).
- **Cowork**: Scheduled Tasks (acesso recorrente a pastas/browser/
  conectores — "scan Gmail toda manhã + report 9h"); Dispatch (mobile,
  equivalente a OpenClaw sem o setup/manutenção/risco de segurança)
- **Folder setup de 3 arquivos** (portável entre LLMs):
  - `Instructions.md` — como o modelo deve agir, incluindo a linha-chave
    "Update Memory.md with my preferences over time"
  - `Memory.md` — "cérebro" continuamente atualizado: seções Preferences /
    Corrections / Patterns / Decisions
  - `Context.md` — tema geral/contexto específico do projeto
- **Loop de automação**: tasks diárias no Cowork → reconhecimento de
  padrão → build do sistema no Claude Code → task automatizada melhor/mais
  rápido no Cowork (ciclo de melhoria contínua)

## Implicações para o vault

O folder setup de 3 arquivos (Instructions/Memory/Context) é
estruturalmente idêntico ao `CLAUDE.md` (instructions) + auto-memory
(`MEMORY.md` + arquivos individuais) + frontmatter por nota (context) —
mais uma confirmação de convergência com práticas já adotadas, vindo de
fonte independente.

Ver também [[03-RESOURCES/sources/claude-code-cowork/how-to-actually-prompt-claude-fable-5]]
e [[03-RESOURCES/sources/claude-code-cowork/get-most-out-of-fable-5-before-its-gone]]
— os três artigos descrevem (de fontes independentes) padrões já
implementados no vault-michel (CLAUDE.md como boundary/verification layer,
auto-memory como memory file). Tratar como validação institucional, não
como nova feature.
