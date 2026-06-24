---
title: "Skill: diagnose"
type: source
source_type: clipping
source_path: clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741 5.md
created: 2026-05-09
ingested: 2026-05-09
tags: [ai-agents, clipping]
triagem_score: 7
---

## Resumo

| name | diagnose |
| --- | --- |
| description | Disciplined diagnosis loop for hard bugs and performance regressions. Reproduce → minimise → hypothesise → instrument → fix → regression-test. Use when user says "diagnose this" / "debug this", reports a bug, says something is broken/throwing/failing, or describes a performance regression. |

## Diagnose

A discipline for hard bugs. Skip phases only when explicitly justified.

When exploring the codebase, use the project's domain glossary to get a clear mental model of the relevant modules, and check ADRs in the area you're touching.

## O Protocolo de 6 Fases

A skill `diagnose` força um processo científico para debugging — a tentação é pular direto para a fase de fix, mas o protocolo existe porque a maioria dos bugs "difíceis" são difíceis exatamente porque alguém pulou as fases iniciais.

### Fase 1: Reproduce

**Objetivo**: ter um caso de falha reproduzível e verificável antes de qualquer hipótese.

Perguntas a responder:
- O bug acontece sempre ou intermitentemente?
- Em qual ambiente? (prod, staging, local — qual diferença?)
- Qual é o input exato que causa a falha?
- O que era esperado vs. o que aconteceu?

**Output desta fase**: um script, comando ou sequência de passos que reproduz o bug de forma confiável. Se não é reproduzível, não é diagnosticável — coletar mais dados (logs, traces) antes de continuar.

```bash
# Exemplo de reproduction script para um bug de API
curl -X POST /api/payments \
  -H "Content-Type: application/json" \
  -d '{"amount": 99.99, "currency": "USD", "userId": 12345}' \
  # Esperado: 200 com payment_id
  # Atual: 500 Internal Server Error
```

### Fase 2: Minimise

**Objetivo**: reduzir o caso de reprodução ao menor possível.

Um bug com 50 passos de reprodução tem 50 lugares para olhar. Um bug com 3 passos tem 3. A minimização:
- Remove dependências externas (mockar chamadas de terceiros)
- Reduz dados de entrada ao mínimo que ainda causa o bug
- Isola o componente falho do resto do sistema

**Antipadrão a evitar**: começar a hipóteses com o caso completo. Minimizar primeiro.

### Fase 3: Hypothesise

**Objetivo**: formular 2-3 hipóteses específicas e falsificáveis sobre a causa raiz.

Uma hipótese boa:
- É específica: "o bug ocorre quando `amount` é float porque a comparação usa `==` em vez de `compareTo`"
- É falsificável: posso testar com `amount = 99.0` (int) vs `amount = 99.99` (float)
- Tem implicação: se verdadeira, explica também por que só acontece com certos valores

Usar o domínio glossary (CONTEXT.md) nesta fase — o bug pode estar em um conceito de domínio mal implementado (ex.: "Payment" e "Transaction" sendo tratados como sinônimos quando têm ciclos de vida diferentes).

### Fase 4: Instrument

**Objetivo**: adicionar observabilidade suficiente para confirmar ou refutar cada hipótese.

**Princípio**: instrument antes de ler código extensivamente. A tentação é ler 500 linhas de código procurando o bug — é mais eficiente adicionar logs estratégicos e observar.

```java
// Adicionando instrumentação temporária (remover após fix):
log.debug("Payment processing: amount={}, type={}, userId={}", 
          amount, amount.getClass().getSimpleName(), userId);
```

**Para performance regressions**: usar profiler antes de ler código:
```bash
# Java: async-profiler
java -agentpath:/path/to/libasyncProfiler.so=start,event=cpu,file=profile.html
# Node: clinic.js
clinic flame -- node server.js
```

### Fase 5: Fix

**Objetivo**: fix mínimo que resolve a causa raiz confirmada — não o conjunto de sintomas.

**Antipadrão**: fix que mascara o bug sem resolver a causa raiz:
```java
// Errado — mascara o problema
try {
    processPayment(amount);
} catch (NullPointerException e) {
    log.error("Ignorando NPE no pagamento", e); // ← bug silenciado
}

// Certo — resolve a causa raiz
BigDecimal safeAmount = Optional.ofNullable(amount)
    .orElseThrow(() -> new IllegalArgumentException("Amount cannot be null"));
```

**Cirurgicalidade**: alterar apenas o que é necessário para o fix. Não aproveitar para refatorações paralelas — elas complicam a análise se o fix introduzir novos bugs.

### Fase 6: Regression Test

**Objetivo**: garantir que o bug não voltará sem aviso.

O teste de regressão deve:
1. Reproduzir o input exato do caso de reprodução da Fase 1
2. Verificar o comportamento esperado (não apenas "não crasha")
3. Ser executado no CI — se não está no CI, não é um teste de regressão

```java
@Test
void payment_with_decimal_amount_should_process_correctly() {
    // Given
    BigDecimal amount = new BigDecimal("99.99"); // ← o input que causava o bug
    
    // When
    PaymentResult result = paymentService.process(amount, "USD", userId);
    
    // Then
    assertThat(result.status()).isEqualTo(PaymentStatus.COMPLETED);
    assertThat(result.amount()).isEqualByComparingTo(amount); // compareTo, não equals
}
```

## Quando Pular Fases

A skill especifica: "skip phases only when explicitly justified." Justificativas válidas:

- Fase 1 (Reproduce): bug é em produção com dados sensíveis que não podem ser replicados localmente → usar prod debugging com cuidado redobrado
- Fase 2 (Minimise): sistema extremamente simples onde o caso completo já é o mínimo
- Fase 4 (Instrument): bug já tem stack trace completo com localização exata

Justificativas **inválidas**: "acho que sei onde está" (sem ter reproduzido), "está com pressa" (bugs não resolvidos por pressa voltam).

## Diagnóstico de Performance Regression

Para regressions de performance, o protocolo tem variações:

```
1. Reproduce: definir baseline (p50/p99 antes da mudança) e atual
2. Minimise: isolar qual request/operação regrediu
3. Hypothesise: mudanças recentes no git, N+1 queries, alocação de memória
4. Instrument: profiler de CPU/memória/I/O
5. Fix: query optimization, cache, pool tuning
6. Regression test: benchmark automatizado no CI
```

## Integração com Outras Skills

- Após `improve-codebase-architecture`: usar `diagnose` para investigar se módulos identificados como problemáticos têm bugs conhecidos
- Antes de `grill-with-docs`: se o design atual tem bugs, diagnosá-los antes de propor mudanças
- Complementar com ADRs: se o fix muda comportamento significativo, documentar em ADR

## Limitações

- O protocolo assume que o bug é reproduzível — bugs Heisenbugs (que somem quando observados) requerem abordagem diferente
- Em sistemas distribuídos, "reproduce" requer infra de staging completa — muitas vezes inviável
- A fase de "instrument" em produção tem custo e risco — needs feature flags ou shadow mode

## Origem

- Path: `clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741 5.md`
- Categoria: ai-agents
- Ingerido: 2026-05-09

## Cross-links

- [[03-RESOURCES/sources/claude-code-skills/skill-improve-codebase-architecture]]
- [[03-RESOURCES/sources/claude-code-skills/skill-grill-with-docs]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
