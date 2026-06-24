---
title: "Bun: lifetime-classify.workflow.js — Classificação de Ownership Zig→Rust via Multi-Agent"
type: source
source: "Clippings/bun.claudeworkflowslifetime-classify.workflow.js at 23427dbc12fdcff30c23a96a3d6a66d62fdc091d.md"
url: "https://github.com/oven-sh/bun/blob/23427dbc12fdcff30c23a96a3d6a66d62fdc091d/.claude/workflows/lifetime-classify.workflow.js"
published: 2026-05-22
ingested: 2026-05-28
tags: [claude-code, workflows, bun, zig, rust, multi-agent, ownership]
triagem_score: 8
---

## Contexto

Arquivo interno do repositório Bun (`oven-sh/bun`) — um workflow Claude Code que classifica campos de ponteiros em structs Zig para tipos de ownership Rust, como parte da migração Zig→Rust do Bun.

Este é um exemplo real de workflow multi-agente de análise estática usada em produção por um projeto OSS de grande escala.

## O que o workflow faz

**3 fases**:

1. **Classify** — Um agente por arquivo: lê struct+init+deinit, classifica cada campo ponteiro em uma taxonomia de ownership Rust
2. **Verify** — 3-vote adversarial nos UNKNOWN/low-confidence + 12% sample aleatório dos high-confidence
3. **Synthesize** — Emite LIFETIMES.tsv com stats por categoria

## Taxonomia de ownership (11 classes)

| Classe | Rust Type | Critério |
|--------|-----------|---------|
| `OWNED` | `Box<T>` / `Option<Box<T>>` | struct cria AND deinit destrói |
| `SHARED` | `Rc<T>` / `Arc<T>` | ref-counted, múltiplos donos |
| `BORROW_PARAM` | `&'a T` | atribuído de param do constructor; outlives self |
| `BORROW_FIELD` | `&'a T` (sibling) | aponta para alocação de outro campo da struct |
| `STATIC` | `&'static T` | global/singleton |
| `JSC_BORROW` | `&JSGlobalObject` etc. | tipos JSC bem conhecidos, sempre borrowed |
| `BACKREF` | `*const Parent` (raw) | aponta de volta para o dono; precisaria de `Weak<>` |
| `INTRUSIVE` | `*mut T` (raw) | next/prev em lista intrusiva |
| `FFI` | `*mut T` / `*const T` | vem de ou vai para C |
| `ARENA` | `StoreRef<T>` | em arena/Store, liberado por `arena.reset()` |
| `UNKNOWN` | `Option<NonNull<T>>` + TODO | indeterminável do arquivo |

## Padrão de verificação multi-agente

```
// 3 agentes adversariais por campo questionável
const votes = await parallel(
  Array.from({length: 3}, (_, j) => () => agent(
    `Adversarially verify... Default refuted=true if uncertain`,
    {schema: VERDICT}
  ))
);
// Consenso: 2 de 3 refutam → overturned
const consensus = refutes >= 2 ? votes.find(v => v.refuted)?.correct_class : f.class;
```

## Insights de design do workflow

- **Parallelismo com cap de segurança**: `if (FILES.length + toVerify.length * 3 > 980) toVerify = toVerify.slice(...)` — evita explodir o limite de subagentes
- **Adversarial default**: verificadores têm instrução "default refuted=true if uncertain" — viés conservador
- **Evidence citation**: todo campo classificado precisa citar `file:line` do init/deinit que prova a classe
- **JSON schema estruturado**: output de cada agente validado contra schema explícito

## Relevância para o vault

Demonstra como Claude Code workflows são usados para **análise estática agentic em escala** — não só em toy examples, mas na codebase real do Bun (projeto com 70k+ stars). Modelo replicável para qualquer migração de linguagem ou auditoria de código.

## Ligações vault

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/parallel-agent-code-review]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/agent-systems/workflow-compilation]]
