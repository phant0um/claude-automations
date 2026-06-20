# Nexus Agent System — Claude Project Setup

## Estratégia de Projects

| Project | System prompt | Uso |
|---------|--------------|-----|
| **Nexus — Dev** | `Nexus.md` (orquestrador) | Tarefas fullstack completas com delegação |
| **Forge** | `Forge.md` | Implementação standalone sem orquestração |
| **Shield** | `Shield.md` | Revisão de segurança / arquitetura crítica |

> Padrão: usar Project Nexus com system prompt `Nexus.md`. Nexus roteia para agente certo durante a conversa.

## System prompt principal

Copiar conteúdo de `Nexus.md`.

Para sessões especializadas sem orquestração:
- Implementação: `Forge.md`
- Validação/segurança: `Shield.md`
- UI/UX: `Pixel.md`
- Pesquisa rápida: `Scout.md`

## Documentos para upload

### Contexto do projeto (atualizar por projeto)
- `docs/progress.md` — estado atual, tarefas, bloqueios
- `docs/standards.md` — critérios de qualidade, anti-padrões
- `docs/adr/` — decisões arquiteturais relevantes

### Referência fixa
- `docs/constitution.md` — princípios e limites do sistema

## Roteamento de modelos

| Agente | Modelo | Custo |
|--------|--------|-------|
| Nexus | claude-sonnet-4-6 | Padrão |
| Scout | claude-haiku-4-5 | Baixo |
| Forge | claude-sonnet-4-6 | Padrão |
| Shield | claude-opus-4-7 | Alto (~10% das tarefas) |
| Pixel | claude-sonnet-4-6 | Padrão |
| Herald | claude-haiku-4-5 | Baixo |
| Ledger | claude-haiku-4-5 | Baixo |

## Invocação

```
@nexus — [tarefa]. Contexto: [arquivo relevante]
```

Nexus lê `progress.md`, decide agente, delega com contexto mínimo.

## Regras críticas

1. Sempre iniciar pelo Nexus — mantém estado em `progress.md`
2. Shield obrigatório antes de deploy ou mudança arquitetural
3. Ledger chamado ao final de todo ciclo
4. ADR criado para toda decisão que afeta arquitetura
