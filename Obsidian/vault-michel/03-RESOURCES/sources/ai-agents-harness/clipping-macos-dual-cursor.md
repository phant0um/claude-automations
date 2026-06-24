---
title: "macOS Dual Cursor — Computer Use 2.0"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, computer-use, macos, dual-agent, background-automation, accessibility-api, cgevent]
score: 6
author: "@bridge_surf"
source_url: "https://x.com/bridge_surf/status/2057416247319618039"
domain: ai-agents-harness
---

# macOS Dual Cursor — Computer Use 2.0

**@bridge_surf**: análise técnica do computer use com dois cursors simultâneos — um do usuário, um do AI agent. Implementado em Bridge.

## O Fenômeno

OpenAI Codex computer use (Apr 16): dois cursors na tela ao mesmo tempo. Um controlado pelo usuário, outro pelo AI agent. Agent clica em janelas e digita em background sem interromper o usuário.

> "The floating cursor is visual theater — technically no need to render a second cursor at all. What matters is how background clicks work."

## Mecanismos (profundidade técnica)

**Layer 1: Accessibility API (AX)**
- Lê: enumerate windows, traverse AX tree, properties (role, title, frame, value)
- Age: AXPress (buttons), setValue (text fields), AXIncrement/AXDecrement (scrollbars)
- Funciona *sem* window precisar estar em foreground
- **Limitação**: Chrome/Electron — AX tree incompleto, AXPress não confiável

**Layer 2: CGEvent (background click)**
- Simula mouse input em janelas em background
- Contorna limitação do AX para apps web/Electron
- Requer "trick" para fazer macOS permitir background window entrar em estado ativado

**Layer 3: Keyboard (postToPid)**
- Character-by-character keyboard input para qualquer processo

## Trade-offs

- Depende de comportamentos low-level do macOS window system
- Pode depender de bugs
- Funciona bem para native apps, menos para Chrome/Electron

## Open Source

Implementação: `kwwk-computer-use-core` (GitHub EYHN) — full logic para background window reading, clicking, keyboard input.

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-9-agentic-patterns]]
