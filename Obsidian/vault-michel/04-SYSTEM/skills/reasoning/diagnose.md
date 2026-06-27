---
skill: diagnose
version: 2.0
author: Nexus Agent System
source: mattpocock/skills (diagnosing-bugs)
tags: [debugging, diagnosis, root-cause, loop, coding, tight, red-capable]
---

# Skill: Diagnose

## Propósito
Executar loop de debugging disciplinado para falhas que resistiram a 1+ tentativas diretas. Proibido pular etapas ou fixar sem hipótese confirmada.

> **Leading word: tight.** A tight loop é fast, deterministic, e red-capable (vai red no bug). Um loop flaky de 30s é quase inútil; um loop tight de 2s é um superpoder de debugging.

---

## Condições de Ativação
Ative esta skill quando:
- Bug não resolvido após 1 tentativa direta
- Falha com comportamento intermitente ou não-reproduzível
- Erro cuja causa-raiz é desconhecida (não apenas sintoma visível)
- `@diagnose [descrição do bug]` chamado explicitamente

NÃO ative para: erros óbvios de sintaxe; falhas já diagnosticadas aguardando fix; tarefas sem componente de bug.

---

## Modelo por Etapa

| Etapa | Modelo Claude | Justificativa |
|-------|--------------|---------------|
| Build feedback loop | `claude-haiku-4-5` | Coleta criativa de evidências, mecânica |
| Reproduce + Minimise | `claude-haiku-4-5` | Leitura mecânica, coleta de evidências |
| Hypothesise | `claude-sonnet-4-6` | Raciocínio causal, múltiplas hipóteses |
| Instrument + Fix | `claude-sonnet-4-6` | Implementação dirigida por hipótese |
| Regression Test | `claude-haiku-4-5` | Verificação estruturada |

---

## Protocolo de Execução

### ETAPA 0 — Build a Tight Feedback Loop *(Haiku)*

> **Esta é a skill.** Todo o resto é mecânico. Se você tem um loop tight que vai red no bug, você vai encontrar a causa. Se não tem, nenhuma quantidade de leitura de código vai salvar.

Seja agressivo e criativo. Recuse desistir. 10 ways de construir um loop (em ordem de preferência):

1. **Failing test** no seam que alcança o bug (unit, integration, e2e)
2. **Curl / HTTP script** contra dev server rodando
3. **CLI invocation** com fixture input, diffando stdout vs snapshot known-good
4. **Headless browser script** (Playwright/Puppeteer) — drives UI, asserta DOM/console/network
5. **Replay captured trace** — salva request/payload/event log real, replay no code path isolado
6. **Throwaway harness** — subset mínimo do sistema (1 service, mocked deps) que exercita o bug
7. **Property/fuzz loop** — se bug é "sometimes wrong output", 1000 random inputs procurando failure mode
8. **Bisection harness** — automatiza "boot at state X, check, repeat" para `git bisect run`
9. **Differential loop** — mesmo input em old-version vs new-version, diff outputs
10. **HITL bash script** — último recurso. Drive humano com script estruturado

**Tighten o loop** (tratar como produto):
- **Faster?** Cache setup, skip unrelated init, narrow test scope
- **Sharper signal?** Asserta sintoma específico, não "didn't crash"
- **More deterministic?** Pin time, seed RNG, isolate filesystem, freeze network

**Bugs não-determinísticos:** objetivo não é repro limpo, é **higher reproduction rate**. Loop trigger 100×, paraleliza, add stress, narrow timing windows, inject sleeps. Bug 50% flake é debuggable; 1% não — keep raising rate.

**Quando genuinamente não pode construir loop:** parar e dizer explicitamente. Listar o que tentou. Pedir: (a) access ao environment reproduzível, (b) artifact capturado (HAR, log dump, core dump), (c) permissão para instrumentation temporária em produção. **Não prosseguir para hipóteses sem loop.**

Output obrigatório:
```
LOOP: <tipo escolhido (1-10)>
COMMAND: <1 comando que já rodou pelo menos 1× que vai red no bug>
OUTPUT: <output do comando acima>
TIGHT: [fast + deterministic + red-capable | flaky <X%> | não-reproduzível]
```

> **Se você se pegar lendo código para construir teoria antes deste comando existir, STOP.** Hipótese sem loop red-capable é o failure mode exato que esta skill previne.

### ETAPA 1 — Reproduce *(Haiku)*
Objetivo: confirmar que o bug existe e é consistente.

```
- Execute o caminho exato que produz a falha
- Documente: input → comportamento observado → comportamento esperado
- Se não reproduzir em 3 tentativas → PARE, reporte ao usuário (bug pode ser flaky)
```

Output obrigatório:
```
REPRODUCE: [sim | não | flaky]
INPUT: <condições exatas>
OBSERVED: <o que acontece>
EXPECTED: <o que deveria acontecer>
```

### ETAPA 2 — Minimise *(Haiku)*
Objetivo: isolar o menor caso que ainda reproduz o bug.

```
- Remova dependências, dados e contexto irrelevantes um por um
- Teste após cada remoção — se bug sumir, o removido era relevante
- Pare quando remover qualquer coisa fizer o bug desaparecer
```

Output obrigatório:
```
MINIMAL CASE: <menor reprodução encontrada>
REMOVED: <o que foi eliminado sem perder o bug>
```

### ETAPA 3 — Hypothesise *(Sonnet)*
Objetivo: formular hipóteses causais ordenadas por probabilidade.

```
- Liste 3-5 hipóteses para a causa-raiz (não o sintoma)
- Para cada hipótese: o que ela prevê que seria verdade se correta?
- Ordene por: (probabilidade × facilidade de testar)
- Escolha a #1 para testar primeiro
```

Output obrigatório:
```
H1: <hipótese> | Prevê: <observação testável> | P: alta/média/baixa
H2: <hipótese> | Prevê: <observação testável> | P: alta/média/baixa
...
TESTAR PRIMEIRO: H<n>
```

### ETAPA 4 — Instrument *(Sonnet)*
Objetivo: adicionar observabilidade mínima para confirmar ou refutar H1.

```
- Adicione logs/asserts/breakpoints no ponto que distingue H1 das outras
- NÃO fixe ainda — apenas observe
- Execute com instrumentação → colete evidência
- Se evidência refuta H1: volte à ETAPA 3, mova para H2
- Se evidência confirma H1: avance para fix
```

Output obrigatório:
```
INSTRUMENTAÇÃO: <o que foi adicionado e onde>
EVIDÊNCIA: <o que foi observado>
CONCLUSÃO: H<n> [confirmada | refutada]
```

### ETAPA 5 — Fix *(Sonnet)*
Objetivo: correção dirigida pela hipótese confirmada — nada além do necessário.

```
- Fix apenas o que a hipótese confirmada indica
- NÃO refatore código adjacente
- NÃO adicione features ou "melhorias de oportunidade"
- Remova toda instrumentação adicionada na ETAPA 4
```

### ETAPA 6 — Regression Test *(Haiku)*
Objetivo: garantir que o fix não quebra nada e não regride.

```
- Execute o caso mínimo da ETAPA 2 — deve passar
- Execute o suite de testes existente — zero regressões permitidas
- Se não houver testes: escreva 1 teste que teria capturado o bug antes
```

Output obrigatório:
```
CASO MÍNIMO: [passou | falhou]
SUITE: [passou | N falhas]
NOVO TESTE: <path do arquivo criado, se aplicável>
```

---

## Completion

- [ ] ETAPA 1 Reproduce: bug confirmado (sim/não/flaky) com input exato documentado
- [ ] ETAPA 2 Minimise: menor caso de reprodução isolado
- [ ] ETAPA 3 Hypothesise: 3-5 hipóteses listadas, rankeadas, #1 escolhida para testar
- [ ] ETAPA 4 Instrument: evidência coletada confirma ou refuta H1
- [ ] ETAPA 5 Fix: correção dirigida pela hipótese confirmada, instrumentação removida
- [ ] ETAPA 6 Regression: caso mínimo passa + suite existente zero regressões

## Failure modes

- **Fix sem hipótese**: pular ETAPA 3-4 e fixar por gut feeling → proibido, hipótese confirmada é obrigatória
- **Múltiplos fixes simultâneos**: mudar 2+ coisas entre runs → isola variável, um fix por vez
- **Skip do Minimise**: testar no contexto grande → mascara causa-raiz, sempre isolar
- **Hipóteses esgotadas**: ETAPA 3 sem confirmação → chamar `heavy-think` com minimal case, não forçar fix

---

## Regras de Ouro

- **Proibido fixar sem hipótese confirmada** — gut feeling não conta
- **Proibido pular MINIMISE** — testar em contexto grande mascara a causa
- **Proibido múltiplos fixes simultâneos** — isola a variável
- **Se ETAPA 3 esgotar hipóteses sem confirmação**: chame `heavy-think.md` com o minimal case

---

## Artefatos de Saída
- Fix aplicado no código
- Teste de regressão adicionado (se ausente)
- Relatório inline no formato por etapa acima
