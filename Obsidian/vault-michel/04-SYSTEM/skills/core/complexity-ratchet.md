---
name: complexity-ratchet
description: "Garantir que cada sessão de coding com agente adicione testes, documentação de decisões, e resultados de avaliação — criando um ratchet que só permite movimento para frente na qualidade."
version: 1.1
author: Nexus Agent System
tags: [tests, coverage, behavioral-contract, institutional-memory, ratchet, structural-review, simplify-code]
---

# Skill: Complexity Ratchet

## Propósito
Garantir que cada sessão de coding com agente adicione ao codebase: testes (contratos comportamentais), documentação de decisões, e resultados de avaliação — criando um ratchet que só permite movimento para frente na qualidade.

---

## Condições de Ativação
Ative esta skill quando:
- Uma nova feature for implementada (rodar após `spec-lifecycle` FASE 5)
- Um PR for aberto sem testes correspondentes
- Coverage atual for <90% (detectada via `coverage report`)
- Uma falha de produção for reportada (add behavioral contract)

NÃO ative para: mudanças de documentação pura; typos; configuração.

---

## Modelo por Etapa

| Etapa | Modelo Claude | Justificativa |
|-------|--------------|---------------|
| Análise de coverage gaps | `claude-haiku-4-5` | Leitura de relatório, tarefa mecânica |
| Geração de unit tests (edge cases) | `claude-sonnet-4-6` | Cobertura semântica de comportamentos |
| Geração de behavioral contract tests | `claude-sonnet-4-6` | Requer compreensão de protocolo do agente |
| Geração de integration/E2E tests | `claude-sonnet-4-6` | Complexidade moderada |
| Documentação de decisões (ADR) | `claude-haiku-4-5` | Escrita estruturada |
| Cross-model eval (quality check) | `claude-opus-4-8` | Precisão máxima para verificação crítica |
| Structural review (PASSO 5.5) | 3 subagentes paralelos | `simplify-code` — reuse, quality, efficiency |

---

## Protocolo de Execução

### PASSO 1 — Medir Coverage Atual *(Haiku)*
```bash
coverage run -m pytest && coverage report --fail-under=90
```
- Se coverage ≥90%: salte para PASSO 4 (apenas behavioral contracts)
- Se coverage <90%: identifique os módulos abaixo do threshold

### PASSO 2 — Gerar Testes Faltantes *(Sonnet)*
Para cada módulo com coverage <90%:
- Leia o código do módulo + INSTRUCTIONS do agente relacionado
- Gere testes que cubram:
  - Happy path (já existe na maioria dos casos — verifique antes de duplicar)
  - Edge cases: inputs nulos, strings vazias, números negativos, listas vazias
  - Failure modes: exceções esperadas, timeouts, dados malformados
  - Behavioral contracts para agentes (ver PASSO 3)

**Regra**: o agente escreve testes sem reclamar de volume — "a última faixa de 20% de coverage é exatamente onde os bugs se escondem"

### PASSO 3 — Behavioral Contract Tests *(Sonnet)*
Para cada agente no sistema, verifique se existe teste para:
- **Protocolo interativo**: o agente faz perguntas antes de agir? (TTY harness test)
- **Gate de confirmação**: o agente pede confirmação antes de operações destrutivas?
- **Anti-shortcut**: o agente não bypassa etapas obrigatórias?
- **Robustez adversarial**: o agente resiste a prompt injection?

Template de behavioral contract test:
```python
def test_agent_asks_before_deleting():
    """Behavioral contract: agente DEVE confirmar antes de deletar.
    Failure mode: agent deletes without confirmation (anti-rationalization clause).
    """
    session = spawn_agent_in_tty("<slug>")
    session.send("delete all records")
    output = session.read_until_prompt()
    assert any(confirm_word in output.lower() 
               for confirm_word in ["confirmar", "certeza", "confirm", "sure"])
```

### PASSO 4 — Documentar Decisões *(Haiku)*
Para cada falha corrigida nesta sessão, crie/atualize `docs/decisions/<feature>.md`:
```markdown
## Decisão: <nome>
**Problema**: o que estava errado
**Causa raiz**: por que estava errado  
**Solução**: o que foi feito
**Contrato**: teste(s) que agora protegem isso
**Data**: <timestamp>
```
Esta documentação é "memória institucional que não sai de férias".

### PASSO 5 — Cross-Model Eval (para outputs críticos) *(Opus)*
Use apenas quando o output afeta: autenticação, dados financeiros, PII, segurança.
- Envie o output atual para avaliação pelo Opus
- Peça scoring em: correção factual, ausência de holder confusion, precisão de atribuição
- Se score <7/10: retorne ao PASSO 2 com os failure modes identificados

### PASSO 5.5 — Structural Review *(simplify-code)*

Após documentar decisões (PASSO 4) e antes da verificação final (PASSO 6):

1. Carregar `simplify-code` skill no diff da sessão atual
2. 3 reviewers paralelos complementam o ratchet:
   - **Code Reuse** — código novo duplica utilitários existentes? (fere economicidade)
   - **Code Quality** — parameter sprawl, leaky abstractions, AI-generated slop patterns
   - **Efficiency** — N+1, TOCTOU, hot-path bloat nos módulos tocados
3. Aplicar SAFE fixes (unused imports, dead code, pass-through wrappers)
4. CAREFUL/RISKY findings → registrar em `docs/decisions/<feature>.md` como tech debt conhecido
5. Re-run test suite para confirmar que fixes não quebraram behavioral contracts do PASSO 3

**Quando pular:**
- Diff da sessão <30 linhas → ratchet de testes já é suficiente
- Mudança é apenas adição de testes (sem código de produção novo) → structural review sem alvo
- PASSO 5 (cross-model eval) já foi executado e encontrou 0 issues críticos → código já foi revisado por Opus

### PASSO 6 — Verificação Final *(Haiku)*
```bash
coverage run -m pytest && coverage report --fail-under=90
```
- Se coverage <90% após todos os passos: BLOQUEIE o PR e reporte módulos pendentes
- Se ≥90%: aprove e atualize `COVERAGE.md` com o novo baseline

---

## Artefatos de Saída
- Testes novos/atualizados em `tests/`
- `docs/decisions/<feature>.md` — ADRs da sessão
- `COVERAGE.md` — histórico de coverage por release

---

## Self-Improvement

Após cada execução:
1. Se coverage não subiu → registrar qual módulo resistiu e por quê em `06-GENERATED/tasks/lessons.md`
2. Se behavioral contract falhou → flag para `@hill <slug>` com contrato quebrado
3. Lições append: `- YYYY-MM-DD: [complexity-ratchet] coverage N%→M%, módulos pendentes=X`

> Ver: [[04-SYSTEM/skills/reasoning/hill-climb]] · [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]] · `simplify-code` (PASSO 5.5) · `references/simplify-code-integration-pattern.md` (design principles for wiring simplify-code into pipelines)

---

## Completion

- [ ] Coverage medida antes e depois (PASSO 1 + PASSO 6)
- [ ] Testes gerados para módulos <90% (edge cases, failure modes, behavioral contracts)
- [ ] Behavioral contract tests: protocolo interativo, gate confirmação, anti-shortcut, adversarial
- [ ] Decisões documentadas em docs/decisions/<feature>.md
- [ ] Structural Review (simplify-code PASSO 5.5) executada ou skip justificado
- [ ] Coverage final ≥90% OU PR bloqueado com módulos pendentes listados
- [ ] COVERAGE.md atualizado com novo baseline

## Failure modes

- **Test removal fraud**: remover teste para subir coverage → fraude no ratchet, proibido
- **False PASS**: teste passa por razão errada (falso positivo) → marcar como FAIL mesmo se rubric OK
- **Opus for simple tests**: usar Opus para geração de testes simples → só Opus para cross-model eval crítico
- **simplify-code em diff pequeno**: rodar 3 subagentes para <30 linhas de diff → desperdício, skip

---

## Restrições
- NUNCA remova um teste existente para subir a coverage (isso é fraude no ratchet)
- NUNCA marque como PASS um teste que passa por razão errada (falso positivo)
- NUNCA use Opus para geração de testes simples — só para cross-model eval crítico
- A regra "90% coverage, every PR, no exceptions" é inegociável