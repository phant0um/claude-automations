---
title: "Knowledge System"
description: "Sistema de 4 agentes para pesquisa, escrita, decisões e otimização de prompts"
version: "1.0.0"
updated: 2026-05-15
status: active
---

# Knowledge System

Sistema de 4 agentes orquestrados pelo **Kore** para trabalho de conhecimento: pesquisa, escrita, decisões e prompts.

## Arquitetura

```
Kore (orchestrator)
├── Farol    → pesquisa + síntese de conhecimento
├── Pena     → escrita preservando voz do autor
├── Bússola  → gestão de projetos, decisões e raciocínio adversarial
└── Sigma    → otimização de prompts (Claude, GPT, Perplexity)
```

## Agentes

| Agente | Função principal | Gatilho direto |
|--------|-----------------|----------------|
| Kore | Orquestrador — roteia para agente correto | `@kore` |
| Farol | Pesquisa, síntese, ensino por analogias | `@farol` |
| Pena | Escrita, melhoria de texto, voz do autor | `@pena` |
| Bússola | Projetos, decisões, auditoria adversarial | `@bussola` |
| Sigma | Otimização de prompts para qualquer modelo | `@sigma` |

## Skills de suporte

| Skill | Função |
|-------|--------|
| `source-validator` | Escala de confiança em dados (verificado / ⚠️ / não confirmado) |
| `voice-guard` | Preservação de voz do autor em edições |

## Como invocar

Via orquestrador (recomendado):
> `@kore — quero pesquisar agentes de IA`
> `@kore — preciso organizar meus pensamentos sobre X`
> `@kore — tenho uma decisão difícil para tomar`

Via agente direto (quando você já sabe qual usar):
> `@farol — me ensine redes neurais`
> `@pena — melhorar texto: [cole seu texto]`
> `@bussola — problema: [descrição]`
> `@sigma — otimizar prompt: [cole seu prompt]`

## Padrões do sistema

Ver `docs/standards.md` para regras globais.
Ver `docs/progress.md` para projetos ativos e pendências.
