---
skill: diagnose
version: 1.0
author: Nexus Agent System
source: mattpocock/skills
tags: [debugging, diagnosis, root-cause, loop, coding]
---

# Skill: Diagnose

## Propósito
Executar loop de debugging disciplinado para falhas que resistiram a 1+ tentativas diretas. Proibido pular etapas ou fixar sem hipótese confirmada.

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
| Reproduce + Minimise | `claude-haiku-4-5` | Leitura mecânica, coleta de evidências |
| Hypothesise | `claude-sonnet-4-6` | Raciocínio causal, múltiplas hipóteses |
| Instrument + Fix | `claude-sonnet-4-6` | Implementação dirigida por hipótese |
| Regression Test | `claude-haiku-4-5` | Verificação estruturada |

---

## Protocolo de Execução

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
