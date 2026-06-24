---
title: "Token Efficiency"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, claude-code-tooling]
status: developing
---

# Token Efficiency

Minimizar tokens consumidos sem perder semântica — a diferença entre uma sessão de vault que dura 20 minutos e uma que dura 2 horas.

## O que é

Token efficiency é o conjunto de técnicas para reduzir o consumo de tokens em sessões de Claude Code, tanto no input (contexto enviado) quanto no output (resposta gerada), sem degradar qualidade da resposta.

## Como funciona

**Camadas de otimização do vault-michel:**

| Camada | Técnica | Economia típica |
|---|---|---|
| Shell output | RTK (filtra ruído de CLI) | 60–90% em cmds |
| Resposta | Caveman mode (compressão ~30%) | 20–35% output |
| Contexto | `/compact` (sumariza conversa) | Libera 40–60% |
| Contexto quente | `hot.md` (só o essencial) | Evita reler vault |
| Rotação | Subagents isolados | Contexto limpo |

**hot.md como contexto quente:** manter só as páginas de alta frequência em hot.md significa que o modelo acessa o conhecimento mais relevante sem varrer o vault inteiro.

**Quando tokens custam mais:** latência aumenta com contexto grande; custo por sessão escala linearmente. Em modelos de raciocínio (extended thinking), thinking tokens custam extra — usar só quando necessário.

**Por que /compact importa:** Claude Code acumula histórico de conversa no contexto. Passados 70% da context window, `/compact` sumariza e libera espaço para continuar trabalhando.

## Por que importa

Para um estudante usando Claude Code como ambiente primário, token economy é literalmente economia financeira — além de performance. O vault SO foi projetado com token efficiency como constraint de primeira ordem.

## Related
- [[03-RESOURCES/concepts/rtk]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/claude-code-tooling/extended-thinking]]
