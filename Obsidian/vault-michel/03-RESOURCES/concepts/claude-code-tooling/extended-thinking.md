---
title: "Extended Thinking"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, claude-code-tooling]
status: developing
---

# Extended Thinking

Modo de raciocínio visível do Claude onde o modelo "pensa em voz alta" antes de responder — thinking tokens que aumentam qualidade em tarefas complexas ao custo de latência.

## O que é

Extended thinking expõe o processo de raciocínio interno do Claude como um bloco separado na resposta (`thinking` block). O modelo usa esses tokens para explorar o problema, considerar alternativas e revisar seu raciocínio antes de emitir a resposta final.

Disponível via API com parâmetro `thinking: { type: "enabled", budget_tokens: N }`.

## Como funciona

**Thinking budget:** controla o máximo de tokens que o modelo pode usar para raciocínio interno. Valores típicos: 1.000–16.000 tokens. Budget maior = análise mais profunda, custo e latência maiores.

**Streaming:** o bloco `thinking` é streamado separadamente da resposta final. Interfaces podem exibi-lo colapsado ou oculto para o usuário final.

**Quando usar:**
- Matemática e lógica complexa
- Raciocínio multi-etapa com muitas dependências
- Tarefas ambíguas onde explorar hipóteses ajuda
- Código com edge cases sutis

**Quando NÃO usar:**
- Tarefas simples (resposta direta, formatação, lookup)
- Cenários onde latência é crítica
- Quando o custo de thinking tokens supera o ganho de qualidade

**vs modo padrão:** sem extended thinking, o modelo ainda raciocina internamente, mas não externaliza esse processo. Extended thinking torna o raciocínio auditável e tende a melhorar precisão em benchmarks de raciocínio.

## Por que importa

No vault-michel, o skill `heavy-think` usa extended thinking para tarefas de raciocínio pesado (hill climbing, análise de contradições). Saber quando ativar vs quando economizar tokens é parte da token efficiency do vault.

## Related
- [[03-RESOURCES/concepts/token-efficiency]]
- [[03-RESOURCES/concepts/claude-code-tooling/_index]]
- [[03-RESOURCES/concepts/claude-ecosystem]]
