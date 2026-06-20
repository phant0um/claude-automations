---
skill: meta-learn
version: 1.0
trigger: "@meta-learn" | "/meta-learn" | "extract principle from [correção]"
model: claude-sonnet-4-6
tags: [learning, principles, feedback, self-improvement, corrections, meta]
source: "[[03-RESOURCES/sources/ai-agents-harness/agents-need-feedback-loops-not-perfect-prompts]]"
---

# Skill: Meta-Learn

## Propósito

Quando um agente sugere X e o humano faz Y (correção), extrair o **princípio** — não a regra. Regras são frágeis ("nunca mencione preço na primeira frase"); princípios são duráveis ("se alguém está expressando frustração, comece com empatia").

**Diferença de `/evolve`:** evolve captura padrões que *funcionaram* na sessão. meta-learn captura o *gap* entre sugestão do agente e ação humana — onde o agente estava errado ou incompleto.

**Diferença de `hill`:** hill melhora agente via eval iterativo. meta-learn extrai o princípio de uma correção específica para que hill tenha material de qualidade para trabalhar.

---

## Condições de Ativação

Ative quando:
- Usuário corrigiu output de agente e a correção revela um padrão (não um erro pontual)
- Agente sugeriu X, humano fez Y de forma diferente e isso aconteceu ≥2× com padrão similar
- Pós-sessão com múltiplas correções — extrair princípios antes de perder contexto
- `/meta-learn` explícito após qualquer sessão intensa de refinamento

NÃO ative para: erros pontuais sem padrão; preferências estéticas sem impacto de qualidade; correções de fato (→ ingest-verify ou guard).

---

## Modelo por Etapa

| Etapa | Modelo | Razão |
|-------|--------|-------|
| Coleta das correções da sessão | Haiku | Scan estruturado do histórico |
| 7-step extraction por correção | Sonnet | Abstração de regra → princípio |
| Decisão de destino | Sonnet | Julgar onde o princípio pertence |

---

## Protocolo — 7 Steps (Petra Donka)

Para cada correção identificada:

### Step 1 — Identificar o que deu errado (ou certo)
```
Sugestão do agente: [exato]
Ação real do humano: [exato]
Diferença: [o que o humano fez de diferente]
```

### Step 2 — Perguntar: por quê?
```
Por que o agente sugeriu X?
  → Qual parte do agent file ou contexto levou a X?
Por que o humano fez Y?
  → Qual contexto/valor/julgamento tornou Y melhor?
```

### Step 3 — Zoom out para o padrão
```
Isso é um caso específico de: [padrão mais geral]
Outros contextos onde esse padrão aparece: [lista]
```

### Step 4 — Verificar contra princípios existentes
```bash
grep -i "[palavra-chave do padrão]" 04-SYSTEM/agents/core/*.md 2>/dev/null | head -10
grep -i "[palavra-chave]" CLAUDE.md | head -5
```

Se princípio já existir: o agente violou um princípio existente → problema de enforcement, não de princípio novo. Encaminhar para `hill`.

### Step 5 — Escrever como princípio (não regra)

Regra (frágil): "Nunca faça X."
Princípio (durável): "Quando [contexto], priorize [valor] porque [razão]."

```
RASCUNHO DO PRINCÍPIO:
"Quando [condição que torna o princípio relevante],
[ação ou prioridade],
porque [mecanismo que explica por que isso funciona]."
```

### Step 6 — Decidir destino

| Destino | Quando |
|---------|--------|
| `04-SYSTEM/agents/core/<slug>.md` seção Restrições | Princípio específico de um agente |
| `CLAUDE.md` — seção Identity ou Preferences | Princípio de comportamento geral do vault |
| `04-SYSTEM/skills/core/<skill>.md` | Princípio de execução de uma skill |
| `04-SYSTEM/wiki/errors.md` | Erro pontual sem princípio generalizável |

### Step 7 — Editar e commitar

```
PROPOSTA DE PRINCÍPIO:
  Arquivo: [destino]
  Seção: [onde inserir]
  Texto: "[princípio formatado]"
  
  Aplicar? [gate para agent files e CLAUDE.md — não aplicar automaticamente]
```

---

## Output

```
META-LEARN REPORT — [data]

Correções analisadas: N
Princípios extraídos: M
Erros pontuais (→ errors.md): K

PRINCÍPIOS:

[1] [título]
  Arquivo: [destino]
  Princípio: "[texto]"
  Origem: [descrição da correção que gerou isso]
  Gate: [PENDENTE APROVAÇÃO / APLICADO AUTONOMAMENTE se skill]

[2] ...

PRÓXIMO PASSO:
  Princípios para agent files: "@extend <slug>" com estes princípios
  Princípios para CLAUDE.md: apresentar ao usuário para confirmação
```

---

## Restrições

- NUNCA aplicar princípios em `04-SYSTEM/agents/` ou `CLAUDE.md` sem confirmação — apenas em skills
- NUNCA escrever regras ("sempre X", "nunca Y" sem contexto) — princípios têm condição + razão
- NUNCA extrair princípio de correção única sem verificar se é padrão (Step 3 obrigatório)
- Se correção revelar violação de princípio existente: encaminhar para hill, não criar princípio duplicado

---

## Relacionado

- [[04-SYSTEM/skills/core/evolve]] — captura padrões bem-sucedidos da sessão; meta-learn captura gaps de correção
- [[04-SYSTEM/agents/core/hill]] — recebe princípios do meta-learn como levers para aplicar
- [[04-SYSTEM/skills/core/codex-retrospective]] — retrospective temporal; meta-learn é imediato (por correção)
- [[04-SYSTEM/wiki/errors]] — erros pontuais sem padrão vão aqui, não viram princípios
