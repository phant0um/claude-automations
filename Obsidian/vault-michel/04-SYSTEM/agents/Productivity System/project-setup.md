# Productivity System — Claude Project Setup

## Estratégia de Projects

| Project | System prompt | Uso |
|---------|--------------|-----|
| **Pulso** | `Pulso.md` (orquestrador) | Não sabe qual agente usar / contexto cruzado |
| **Eixo** | `Eixo.md` | GTD direto: captura, next actions, weekly review |
| **Norte** | `Norte.md` | OKRs: definir, check-in, grade |
| **Eco** | `Eco.md` | Reflexão: diário, semanal, mensal, padrões |

> Padrão: Project único com system prompt `Pulso.md` + todos os 4 agentes como docs. Pulso instrui a agir como o agente certo conforme o contexto.

## System prompt principal

Copiar conteúdo de `00-SYSTEM-PROMPTS/Pulso.md`.

Para sessão focada: usar agente diretamente (Eixo, Norte ou Eco).

## Documentos para upload

```
00-SYSTEM-PROMPTS/Pulso.md
00-SYSTEM-PROMPTS/Eixo.md
00-SYSTEM-PROMPTS/Norte.md
00-SYSTEM-PROMPTS/Eco.md
skills/gtd-horizons.md
skills/okr-format.md
docs/progress.md          ← atualizar após weekly review e check-in OKR
```

## Quando usar qual agente

| Situação | Agente |
|----------|--------|
| Tudo na cabeça, precisa organizar | Eixo (captura) |
| O que fazer agora? | Eixo (next actions) |
| Fechar semana | Eixo (weekly review) |
| Definir metas do trimestre | Norte |
| Checar progresso das metas | Norte (check-in) |
| Refletir sobre dia/semana/mês | Eco |
| Padrão que se repete / travamento | Eco (análise de padrões) |
| Não sei por onde começar | Pulso |

## Ciclos

| Ciclo | Agente | Frequência |
|-------|--------|-----------|
| Captura / next actions | Eixo | Diário |
| Weekly review | Eixo | Semanal |
| Reflexão semanal | Eco | Semanal |
| Check-in OKR | Norte | Mensal |
| Retrospectiva | Eco | Mensal |
| Grade e novo OKR | Norte | Trimestral |

## Invocação

```
@pulso — [descreva o que precisa]
@eixo — capturar: [lista de tudo na cabeça]
@eixo — weekly review
@norte — definir OKRs Q[N] [ano]
@norte — check-in OKR
@eco — prompt do dia
@eco — retrospectiva do mês
```
