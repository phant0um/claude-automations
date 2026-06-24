---
title: Auto Mode
type: concept
status: developing
updated: 2026-04-25
tags: [claude, claude-code, automation, workflow, opus-47]
---

# Auto Mode

Modo de execução automática no [[03-RESOURCES/entities/Claude-Cowork|Claude Code]] que permite ao modelo executar tarefas sem parar para check-ins frequentes do usuário.

## O que é

Mode que elimina a necessidade de aprovação manual entre steps, permitindo **execução contínua** até conclusão.

## Disponibilidade

- **Status:** Research preview
- **Requisito:** Claude Code **Max** subscription
- **Ativação:** `Shift+Tab` em Claude Code

## Quando usar

### Ideal para:
1. **Tarefas bem-definidas** com contexto completo fornecido de início
2. **Agentic runs longas** onde você confia na execução do modelo
3. **Workflows não-sensíveis a interrupção** (não precisa fazer perguntas)
4. **Iterações múltiplas** de um mesmo padrão

### Exemplo bom
```
Migre este repositório do Jest para Vitest:
- Reescrita de testes em /tests/
- Atualização de config (jest.config.js → vitest.config.js)
- Update de CI/CD pipeline
[Auto mode ativa - Claude roda até terminar]
```

### Exemplo ruim
```
Ajude-me a refatorar meu site
[Você quer feedback entre cada step]
→ Use modo interativo normal
```

## Segurança e controle

- **Não executa operações destrutivas** sem aprovação (git push, delete, etc)
- Continua respeitando [[03-RESOURCES/concepts/claude-code-tooling/effort-levels-opus47|effort levels]] e [[03-RESOURCES/concepts/learning-cognition/adaptive-thinking|Adaptive Thinking]]
- Você pode sempre parar manualmente

## Diferença vs agentic pattern

| Aspecto | Auto Mode | Agentic Pattern |
|---|---|---|
| Interface | Claude Code UI | Qualquer interface |
| Quando ativa | Você clica Shift+Tab | Você envia prompt inicial |
| Parada | Manual ou quando concluir | Quando concluir ou erro |
| Melhor para | UI-driven workflows | API/headless workflows |

## Tips

1. **Forneça contexto completo upfront**
   - Listas de arquivos, localização de configs, constraints
   - Auto mode não pede esclarecimentos

2. **Use com tarefas exploratórias** menores se não tiver certeza
   - Teste em modo normal antes de ativar auto mode em tarefa grande

3. **Combine com `xhigh` effort**
   - Auto mode + xhigh = bom balance de autonomia e token usage

## Fonte

- [[03-RESOURCES/sources/guides-courses-howtos/best-practices-claude-opus-47-claude-code]]
- [[03-RESOURCES/entities/Claude-Opus-47]]
