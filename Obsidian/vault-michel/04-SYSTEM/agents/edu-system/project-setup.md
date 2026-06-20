---
title: Edu System — Claude Project Setup
type: project-setup
system: Edu System
updated: 2026-05-31
---

# Edu System — Claude Project Setup

Sistema de 6 agentes para ADS/FIAP, concurso público e carreira tech. Orquestrado pelo **Mestre**.

## System prompt

Usar `Mestre.md` como system prompt padrão. Para sessões focadas:

| Sessão | Arquivo |
|--------|---------|
| Ensino TI/ADS (Python, Cloud, AI) | `Tutor.md` |
| Pipeline ADS/FIAP — Java + Clean Arch | `Stack.md` |
| Prep concurso (CESPE, FCC, FGV) | `Banca.md` |
| Idiomas (EN/ES/JP) | `Babel.md` |
| Resumos, flashcards Anki | `Síntese.md` |
| Carreira TI — currículo, LinkedIn | `Trilha.md` |

## Documentos para upload

- Material FIAP da fase ativa (PDF ou MD consolidado)
- Edital do concurso + cronograma de estudo
- `docs/` se existir — padrões do sistema

## Refs

- Sistema completo: [[04-SYSTEM/agents/edu-system/README]]
- Nexus: [[04-SYSTEM/agents/nexus-agent-system/nexus]]
