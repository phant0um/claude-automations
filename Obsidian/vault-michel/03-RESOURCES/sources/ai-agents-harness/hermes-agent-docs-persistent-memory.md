---
title: "Hermes Agent Docs: Persistent Memory"
type: source
source: "Hermes Agent official docs — Persistent Memory"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

# Hermes Agent Docs: Persistent Memory

## Tese central

Hermes tem memória limitada e curada que persiste entre sessões — preferências, projetos, ambiente, lições aprendidas. O design central é o **frozen snapshot pattern**: a memória é injetada no system prompt uma vez no início da sessão e nunca muda durante ela, preservando o prefix cache do LLM, enquanto mudanças feitas em runtime são persistidas em disco imediatamente mas só aparecem no prompt na sessão seguinte.

## Argumentos principais

### Dois arquivos centrais

| Arquivo | Propósito | Limite |
| --- | --- | --- |
| **MEMORY.md** | Notas pessoais do agente — fatos do ambiente, convenções, lições aprendidas | 2.200 chars (~800 tokens) |
| **USER.md** | Perfil do usuário — preferências, estilo de comunicação | 1.375 chars (~500 tokens) |

Ambos ficam em `~/.hermes/memories/` e são injetados no system prompt como snapshot congelado no início da sessão. O agente gerencia a própria memória via tool `memory` (actions: `add`, `replace`, `remove` — sem `read`, pois o conteúdo já está no contexto).

### Substring matching para replace/remove

`old_text` só precisa ser uma substring única que identifique uma entrada — não o texto completo. Se a substring casar múltiplas entradas, retorna erro pedindo match mais específico.

### O que salvar vs pular

Salva proativamente: preferências do usuário, fatos de ambiente (OS, stack), correções ("não usar sudo para Docker"), convenções de projeto, trabalho concluído, pedidos explícitos de "lembre disso".

Pula: info trivial/óbvia, fatos facilmente re-descobríveis (web search), dumps de dados crus, ephemera de sessão, info já presente em context files (SOUL.md, AGENTS.md).

### Capacity management

Quando uma entrada excederia o limite, a tool `memory` retorna erro estruturado com `current_entries` e `usage` (ex: "2,100/2,200"), instruindo o agente a consolidar (merge via `replace`) ou remover entradas obsoletas antes de tentar `add` novamente — tudo no mesmo turno. Best practice: consolidar acima de 80% de uso.

**Duplicate prevention**: entradas exatamente duplicadas são rejeitadas silenciosamente (retorna sucesso com "no duplicate added").

**Security scanning**: entradas são escaneadas contra padrões de prompt injection e exfiltração de credenciais antes de aceitas, já que vão para o system prompt.

### Session Search (além de MEMORY/USER)

Tool `session_search` busca em todas as sessões (CLI + messaging) armazenadas em SQLite (`~/.hermes/state.db`) com FTS5 full-text search — sem sumarização por LLM, sem truncamento.

| Feature | Persistent Memory | Session Search |
| --- | --- | --- |
| Capacidade | ~1.300 tokens total | Ilimitada (todas as sessões) |
| Velocidade | Instantânea (no system prompt) | ~20ms FTS5 query |
| Custo | Token cost em todo prompt | Sob demanda, sem custo fixo |
| Uso | Fatos críticos sempre disponíveis | "Discutimos X semana passada?" |
| Gestão | Curada manualmente pelo agente | Automática — todas as sessões |

### write_approval — gate de aprovação

`write_approval: true` faz com que escritas em foreground prompt inline (entradas pequenas o suficiente para chat bubble), e escritas do background self-improvement review sejam **staged** em vez de aplicadas direto (thread de background não pode bloquear em prompt). Mesmo gate existe para skills (`skills.write_approval`), mas a UX difere: skill writes sempre fazem stage quando o gate está ligado, mostrando um gist de uma linha + diff completo via `/skills diff <id>` (arquivo staged em `~/.hermes/pending/skills/<id>.json`).

### External memory providers

8 plugins de memória externa rodam **ao lado** da memória built-in (nunca substituindo): Honcho, OpenViking, Mem0, Hindsight, Holographic, RetainDB, ByteRover, Supermemory — adicionam knowledge graphs, busca semântica, extração automática de fatos, modelagem cross-session do usuário.

## Key insights

- Frozen snapshot + live tool state preserva prefix cache do LLM sem sacrificar a consistência: tool responses sempre mostram o estado live mesmo que o prompt esteja congelado.
- Duplicate prevention automática evita poluição da memória sem precisar de disciplina manual do agente.
- Limites de caracteres explícitos (2.200/1.375) forçam curadoria contínua em vez de acumulação indefinida.

## Exemplos e evidências

```bash
hermes sessions list    # Browse past sessions
```

```yaml
# ~/.hermes/config.yaml
memory:
  memory_enabled: true
  user_profile_enabled: true
  memory_char_limit: 2200   # ~800 tokens
  user_char_limit: 1375     # ~500 tokens
  write_approval: false     # false = grava livre (default) | true = exige aprovação
```

```markdown
/memory pending             # lista staged writes (auto ones tagged [auto])
/memory approve <id>        # aplica um (ou 'all')
/memory reject <id>         # descarta um (ou 'all')
/memory approval on         # liga/desliga o gate
```

```bash
hermes memory setup      # escolhe e configura um provider
hermes memory status     # checa o que está ativo
```

## Implicações para o vault

O paralelo direto é com a memória persistente do Claude Code em `~/.claude/projects/.../memory/MEMORY.md` (ver `MEMORY.md` deste vault, referenciado no `CLAUDE.md` global do usuário). Diferenças notáveis:

- Claude Code memory não tem limite de caracteres explícito documentado nem gate de `write_approval` — é mais "freeform markdown index" (ver `Memory Index` com links para sub-arquivos por tópico) vs o esquema rígido MEMORY.md/USER.md de 2.200/1.375 chars do Hermes.
- Hermes formaliza "frozen snapshot + live tool state" e "duplicate prevention automática" — padrões que poderiam ser adotados explicitamente na convenção de memória do Claude Code (hoje dependem de disciplina manual do agente ao editar `MEMORY.md`).
- Session Search via SQLite FTS5 não tem equivalente direto documentado no setup atual do Claude Code — aproxima-se do uso de `grep`/`rg` sobre `~/.claude/projects/` mas sem indexação dedicada.

Existe já em `03-RESOURCES/concepts/agent-systems/` material sobre arquitetura de memória de agente (`agent-memory-architecture.md`, `agent-memory-four-layers.md`, `agent-memory-layers.md`) — vale interlinkar este source com esses concepts e com a seção "memory-os — 7-Layer Memory Architecture" de [[03-RESOURCES/entities/hermes]].

## Links

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
