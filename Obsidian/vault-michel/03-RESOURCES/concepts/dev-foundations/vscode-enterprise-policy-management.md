---
title: "VS Code Enterprise Policy Management"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, claude-code-tooling]
status: developing
---

# VS Code Enterprise Policy Management

Gerenciar VS Code em escala corporativa via arquivos de política JSON — controle centralizado de extensões, settings e Copilot sem tocar em cada máquina individualmente.

## O que é

VS Code suporta **machine policies** (arquivos JSON deployados por GPO/MDM) que sobrescrevem ou bloqueiam configurações de usuário. Usado por TI corporativa para padronizar ambientes de desenvolvimento, controlar extensões permitidas e governar o uso de Copilot/AI features.

## Como funciona

**Localização dos arquivos de política:**
- Windows: `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\VSCode`
- macOS/Linux: `/etc/vscode/policy.json` (ou via MDM profile)

**O que é controlável:**
- **Allowlist/blocklist de extensões** — impedir instalação de extensões não aprovadas
- **Settings obrigatórios** — forçar `editor.formatOnSave`, `telemetry.level`, etc.
- **Copilot governance** — habilitar/desabilitar Copilot por grupo, controlar sugestões
- **Settings Sync** — controlar o que sincroniza com conta Microsoft

**vs Claude Code para empresas:** Claude Code não tem um sistema de policy management equivalente ainda — configuração é por projeto (`.claude/settings.json`) ou global (`~/.claude/settings.json`). Para governança corporativa de Claude Code, a abordagem atual é distribuir `settings.json` base via repositório de templates.

## Por que importa

Contexto relevante para Michel como futuro dev em ambiente corporativo: entender que ferramentas de AI (Copilot, Claude Code) têm níveis diferentes de maturidade em enterprise governance. Claude Code está evoluindo nessa direção com o sistema de permissões por projeto.

## Related
- [[03-RESOURCES/entities/vs-code]]
- [[03-RESOURCES/concepts/claude-ecosystem]]
- [[03-RESOURCES/concepts/claude-md-behavioral-contract]]
