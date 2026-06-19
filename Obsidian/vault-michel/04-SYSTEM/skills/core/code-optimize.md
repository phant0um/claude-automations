---
skill: code-optimize
version: 1.0
author: Forge / Vault SO
tags: [code-quality, refactoring, 5E, clean-code, review, SOLID]
---

# Skill: Code Optimize

## Propósito

Revisar e otimizar código contra o **rubrica 5E** (Fluência, Eficiência, Eficácia, Economicidade, Efetividade), produzindo score 0–100 com findings acionáveis por dimensão. Pode ser chamada standalone ou pelo agente Forge no Fullstack Agent System.

---

## Condições de Ativação

Ative esta skill quando:
- `@forge` for chamado com código para revisar
- `/code-review` for acionado em qualquer projeto
- Score de qualidade for exigido antes de merge
- Refactoring proativo for solicitado

NÃO ative para: arquivos de configuração pura (YAML, JSON de infra); migrações de banco (→ Stratum); arquivos gerados automaticamente.

---

## Modelo por Etapa

| Etapa | Modelo Claude | Justificativa |
|-------|--------------|---------------|
| Análise Fluência + Economicidade | `claude-sonnet-4-6` | Análise sintática e semântica de médio esforço |
| Análise Eficiência + Eficácia | `claude-sonnet-4-6` | Requer raciocínio sobre complexidade e contratos |
| Análise Efetividade (SOLID) | `claude-sonnet-4-6` | Design review — complexidade moderada |
| Síntese de score + refactor | `claude-sonnet-4-6` | Integração de todas as dimensões |
| Refactor crítico (score <60) | `claude-opus-4-7` | Redesign estrutural requer raciocínio profundo |

---

## Protocolo de Execução

### PASSO 1 — Receber artefato

Obtenha o código a ser revisado. Se não fornecido inline:
- Leia o(s) arquivo(s) de `workspace/` ou path fornecido
- Identifique a linguagem, framework, contexto de uso

### PASSO 2 — Análise paralela por dimensão *(Sonnet — 5 lentes simultâneas)*

Execute as 5 dimensões como lentes independentes:

**Fluência (0–20)**
- Nomes descrevem intenção sem comentário?
- Funções ≤20 linhas e fazem uma coisa?
- Sem duplas negativas, sem magic numbers, max 3 níveis de aninhamento
- Convenções consistentes no arquivo

**Eficiência (0–20)**
- Complexidade O(n²) onde O(n log n) ou O(n) existe?
- Queries dentro de loops (N+1)?
- Travessias redundantes que poderiam ser fundidas?
- Alocações desnecessárias em hot paths?

**Eficácia (0–20)**
- Implementação bate com a spec/contrato declarado?
- Edge cases cobertos: null, vazio, boundary, negativo?
- Erros explícitos — sem exceções silenciadas?
- Tipos validados nos boundaries do sistema?

**Economicidade (0–20)**
- Lógica duplicada que deveria ser extraída (DRY)?
- Código morto: branches inalcançáveis, imports não usados?
- Abstração prematura para um único uso (YAGNI)?
- Dependências pesadas para utilidade trivial (use stdlib)?

**Efetividade (0–20)**
- SRP: cada módulo tem uma razão para mudar?
- OCP: extensível sem modificar código existente?
- DIP: depende de abstrações, não de concretions?
- Acoplamento baixo entre módulos, coesão alta dentro?

### PASSO 3 — Calcular Forge Score

```
Forge Score = Σ(5 dimensões) / 100
```

Thresholds:
- 90–100: APPROVE — production-ready
- 75–89: APPROVE WITH NOTES — endereçar antes de merge
- 60–74: REFACTOR RECOMMENDED
- <60: REFACTOR REQUIRED + entregar versão refatorada

### PASSO 4 — Refactoring *(Sonnet se score ≥60; Opus se score <60)*

Para cada finding:
1. Cite linha exata
2. Explique o problema em uma frase
3. Mostre before/after inline

Se score <60 ou refactor explicitamente solicitado: entregue arquivo completo refatorado.

### PASSO 5 — Evidência e log

```markdown
## Forge Score: XX/100
[tabela por dimensão]
## Findings
[por dimensão, com linha e before/after]
## Verdict: APPROVE | APPROVE WITH NOTES | REFACTOR REQUIRED
```

Escreva resultado em `docs/logs/quality.md` (append, não overwrite).

---

## Regras Invariantes

- NUNCA cite findings sem número de linha
- NUNCA bloquear merge por style quando score ≥75
- NUNCA penalizar trade-offs documentados/aprovados (ex: denormalização intencional)
- NUNCA entregar refactor parcial — se entrega, entrega o arquivo completo
- NUNCA usar Opus para score <60 sem antes tentar Sonnet

---

## Artefatos de Saída

- `docs/logs/quality.md` — histórico de scores por arquivo
- Arquivo refatorado em `workspace/` (quando score <60 ou solicitado)
- Score report inline na resposta

---

## Relacionado

- [[04-SYSTEM/agents/fullstack-agent-system/00-SYSTEM-PROMPTS/forge]]
- [[04-SYSTEM/skills/core/complexity-ratchet]]
- [[03-RESOURCES/concepts/agent-systems/parallel-agent-code-review]]
- `engineering:code-review` skill (Claude Code built-in)
