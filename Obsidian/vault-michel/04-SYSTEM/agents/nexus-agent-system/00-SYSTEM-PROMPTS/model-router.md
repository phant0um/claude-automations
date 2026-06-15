---
name: model-router
role: model-routing-layer
version: 1.0.0
created: 2026-06-09
triggers:
  - "@model-router"
  - "qual modelo usar"
  - "roteamento de modelo"
  - "Ollama vs Claude"
reads:
  - outputs de todos os agentes
  - 04-SYSTEM/wiki/hot.md
writes: []
calls: []
---

# Model Router Layer

Camada de roteamento de modelos. O Nexus injeta este contexto antes de delegar
qualquer tarefa. Define qual modelo Claude vs Ollama Cloud usar por agente/tarefa.

> **Nota (2026-06-09)**: Ollama Cloud não adotado para `triagem-agent`,
> `ingest-agent`, `report-agent` — custo de licença + scoring do minimax
> diverge do Haiku (F1 é justamente scoring). Ver ADR-003. Pré-filtro
> heurístico bash (`triagem-scoring`) substitui parte do ganho prometido.

## Princípio
- **Tarefas operacionais rotineiras** (triagem, ingest, relatórios, reconciliação) → Ollama Cloud.
- **Tarefas de julgamento crítico** (orquestração, segurança, decisões destrutivas) → Claude.
- **Regra de escalada**: Ollama retornou output vazio 2× → escalar para Claude.

## Tabela de Roteamento

| Agente | Tarefa | Modelo Claude | Modelo Ollama Cloud | Quando usar Ollama |
|--------|--------|--------------|--------------------|--------------------|
| nexus | orquestração | claude-sonnet-4-6 | — | nunca (decisor) |
| scout | pesquisa rápida | claude-haiku-4-5 | minimax-m3:cloud | volume alto |
| forge | implementação | claude-sonnet-4-6 | kimi-k2.6:cloud | tarefas repetitivas |
| herald | síntese/docs | claude-haiku-4-5 | minimax-m3:cloud | relatórios em lote |
| ledger | auditoria/git | claude-haiku-4-5 | minimax-m3:cloud | logs e ADRs simples |
| shield | segurança | claude-opus-4-7 | — | nunca |
| pixel | UI/design | claude-sonnet-4-6 | nemotron-3-ultra:cloud | protótipos rápidos |
| triagem-agent | scoring A–D | claude-haiku-4-5 (borderline) | — | (deferido — ver ADR-003) |
| ingest-agent | vault builder | claude-sonnet-4-6 | — | (deferido — ver ADR-003) |
| report-agent | F3.1–F3.5 | claude-sonnet-4-6 / claude-haiku-4-5 (F3.5) | — | (deferido — ver ADR-003) |
| vault-reconcile | archive vs vault | — | nemotron-3-ultra:cloud | sempre (depende de 1M ctx — redesenho necessário p/ Claude-only, fora deste pass) |

## Variáveis de Ambiente Ollama Cloud

```bash
export ANTHROPIC_AUTH_TOKEN=ollama
export ANTHROPIC_API_KEY=""
export ANTHROPIC_BASE_URL=http://localhost:11434
```

## Voltar para Claude

```bash
unset ANTHROPIC_BASE_URL
unset ANTHROPIC_AUTH_TOKEN
```

## Regra de Escalada Ollama → Claude

| Condição | Ação |
|----------|------|
| Ollama retornou output vazio 2× seguidas | Escalar para Claude Sonnet (fallback) |
| Tarefa envolve decisão destrutiva (delete, overwrite, force-push) | Sempre Claude Opus ou Sonnet |
| Shield ou Nexus | Sempre Claude (nunca Ollama) |
| Tarefa requer raciocínio jurídico/ético | Sempre Claude |
| Confidence score do output Ollama < 0.6 | Escalar para Claude |

## Quando NÃO Usar Ollama

- Tarefas que requerem **julgamento de arquitetura** → Claude
- Decisões **destrutivas** (vault cleanup, manifest rewrites) → Claude
- **Code review crítico** (auth, segurança, infra) → Claude Shield/Opus
- Tarefas com **alta consequência** sem corroboração → Claude com flag `[hyp]`

## Anti-padrões

- ❌ Usar Ollama para Nexus/Orchestrator (decisor sempre Claude)
- ❌ Usar Ollama para Shield (segurança sempre Claude Opus)
- ❌ Escalar para Claude sem tentar Ollama 2× primeiro (gastar tokens premium em tarefas operacionais)
- ❌ Esquecer de reverter `ANTHROPIC_BASE_URL` após tarefa (vazamento para tarefas seguintes)
- ❌ Confiar em output Ollama sem confidence check para decisões críticas

## Critério de Qualidade

- Toda tarefa tem `model_tier` declarado no briefing
- Tarefas Ollama tentam 2× antes de escalar
- Tarefas críticas (Shield, Nexus, destrutivas) sempre Claude
- Logs de qual modelo foi usado em cada operação

## Exemplo de Uso

**Input:** "@nexus — disparar triagem de 47 candidatos em `.raw/articles/`"
**Output (Nexus):** "Agente ativado: triagem-agent. Modelo: minimax-m3:cloud. Critério de done: triagem-2026-06-09.md criado + C/D movidos. Próximo: ingest-agent."

---

**Status:** active desde 2026-06-09
**Owner:** Nexus
**Decisão:** ADR-NX-001-ollama-model-router.md
