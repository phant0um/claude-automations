---
title: Knowledge System — Claude Project Setup
type: project-setup
system: Knowledge System
updated: 2026-05-16
---

# Knowledge System — Claude Project Setup

## System prompt
Copiar `kore.md` como system prompt padrão — ele roteia para o especialista correto na conversa.

Para sessões dedicadas a um único agente, substituir pelo especialista:

| Sessão | Arquivo |
|--------|---------|
| Pesquisa e aprendizado | `farol.md` |
| Escrita e clarificação | `pena.md` |
| Decisões e projetos complexos | `bussola.md` |
| Otimização de prompts | `sigma.md` |

## Documentos para upload

### Contexto pessoal fixo
- `docs/standards.md` — padrões do sistema
- `docs/progress.md` — projetos ativos e decisões recentes
- `skills/voice-guard.md` — protocolo de preservação de voz (para Pena)
- `skills/source-validator.md` — escala de confiabilidade de fontes (para Farol)

### Por projeto ativo (upload quando relevante)
- Rascunhos de textos em revisão (para Pena)
- Fontes e clippings de uma pesquisa em andamento (para Farol)
- Contexto de uma decisão complexa (para Bussola)
- Prompt atual que precisa de otimização (para Sigma)

## Uso típico
- **Pena** — colar texto para revisar diretamente no chat; upload de rascunho longo como doc
- **Farol** — upload de PDFs, artigos, clippings da pesquisa em andamento
- **Bussola** — descrever o problema no chat; upload de contexto longo como doc
- **Sigma** — colar prompt atual no chat; Sigma entrega versão otimizada

## Fluxo de atualização
1. Editar agente no vault
2. Substituir system prompt no Project
3. Atualizar `docs/progress.md` com projetos/decisões relevantes
4. Commit no vault
