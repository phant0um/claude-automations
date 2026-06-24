---
title: Interactive vs Agentic Patterns
type: concept
status: developing
updated: 2026-04-25
tags: [claude, opus-47, patterns, workflow, agentic, interactive]
---

# Interactive vs Agentic Patterns

Dois padrões distintos de uso do [[03-RESOURCES/entities/Claude-Opus-47|Claude Opus 4.7]] que demandam abordagens diferentes para otimizar eficiência de tokens e qualidade.

## Padrão Agentic (Assíncrono)

**Definição:** Único turn do usuário → Claude executa autonomamente até conclusão

### Características
- Um prompt inicial bem-especificado com contexto completo
- Modelo executa sem interrupções
- Adequado para tarefas longas, bem-definidas
- Uso de [[03-RESOURCES/concepts/agent-systems/auto-mode|Auto Mode]] (Shift+Tab em Claude Code Max)

### Otimizações
1. **Especificar tudo no primeiro turn:**
   - Intent (por que fazer isso?)
   - Constraints (limitações, restrições)
   - Acceptance criteria (quando terminar?)
   - Localização dos arquivos relevantes

2. **Evitar interações de usuário progressivas**
   - Cada turn do usuário adiciona overhead de raciocínio
   - Consolidar todas as questões antecipadamente

3. **Usar Auto Mode quando apropriado**
   - Corta tempo de ciclo
   - Bom fit para tasks longas com contexto completo
   - Research preview para Claude Code Max

### Recomendação de esforço
- **`xhigh`** (default) — ideal para maioria dos casos agênticos
- `max` — apenas para problemas genuinamente difíceis (diminishing returns)

---

## Padrão Interativo (Síncrono)

**Definição:** Múltiplos turns — usuário e Claude alternando com feedback/direcionamento

### Características
- Prompt inicial menos detalhado
- Feedback progressivo do usuário
- Iteração contínua (pair programming, exploração)
- Mais conversacional

### Comportamento em Opus 4.7
- **Opus 4.7 raciocina MAIS** em padrão interativo após cada user turn
- Melhora coerência, instrução-following e qualidade de código ao longo do tempo
- **Mas:** Consome mais tokens por turn (overhead de raciocínio)

### Otimizações
1. **Batch suas perguntas** — consolidar múltiplas questões em um turn
2. **Fornecer contexto suficiente** em cada turn para continuar
3. **Evitar redirecionamentos ambíguos** — cada mudança causa novo overhead de raciocínio

### Recomendação de esforço
- **`xhigh`** ou **`high`** — dependendo de parallelismo vs qualidade
- Se rodando múltiplas sessões paralelas: considerar `high` para economizar

---

## Regra Prática

> **Trate Claude como um engenheiro capaz para o qual você está delegando tarefas, não como um pair programmer que você está guiando linha por linha.**

## Exemplos por padrão

### Agentic (bom)
```
Migre este código legado para padrão moderno:
- Intent: modernizar, melhorar testabilidade
- Constraints: manter API pública inalterada
- Acceptance: todos os testes passam, sem breaking changes
- Arquivos: /src/legacy/ (veja lista em MANIFEST.md)
[Deixe rodar em auto mode — Claude completará]
```

### Interativo (bom)
```
Ajude-me a refatorar o LoginComponent.
[Usuario vê resultado]
"Agora, extrai a validação em um hook customizado"
[Usuario vê resultado]
"Add TypeScript types para form state"
[etc]
```

## Fonte

- [[03-RESOURCES/sources/guides-courses-howtos/best-practices-claude-opus-47-claude-code]]
