---
title: Integration Testing
type: concept
status: developing
created: 2026-04-19
updated: 2026-04-19
tags: [testing, software-engineering, quality-assurance, distributed-systems]
---

# Integration Testing

Tipo de teste que verifica a interação, comunicação e troca de dados entre componentes de software separados (já unit-testados individualmente).

---

## Definição

Enquanto **unit tests** verificam componentes em isolamento, **integration tests** verificam que múltiplos componentes funcionam corretamente em conjunto — interfaces, contratos de dados, comunicação entre serviços.

Em sistemas distribuídos modernos, falhas de integração emergem de:
- Timing e race conditions entre serviços
- Incompatibilidade de formatos de dados
- Problemas de configuração e ambiente
- Dependências de rede e latência

---

## Hermetic Functional Integration Tests (Google)

Subconjunto específico focado por [[03-RESOURCES/sources/ml-research-papers/llm-automated-diagnosis-integration-tests-google]]:

- **Hermético**: ambiente totalmente isolado, sem dependências externas (sem shared infrastructure)
- **Funcional**: testa lógica de negócio (não performance, segurança, reliability)
- Mais reproduzível e debugável — elimina infra externa como fonte de falha

Estrutura típica:
```
Test Driver → SUT (System Under Test)
              ├── Component A (logs: a.info, a.error)
              ├── Component B (logs: b.info, b.warning, b.error)
              └── Component C (logs: c.info, c.error)
```

---

## Desafios de Diagnóstico

| Desafio | Impacto |
|---|---|
| Volume massivo de logs | Mediana 16 arquivos, 2.801 linhas por falha |
| Heterogeneidade | Cada componente tem formato/convenção própria |
| Baixo signal-to-noise | Erros recuperáveis aparecem em nível ERROR |
| Distribuição | Logs em múltiplos datacenters, processos, threads |
| Causalidade oculta | Root cause em componente diferente do que falhou visivelmente |

---

## Unit Tests vs Integration Tests

| Dimensão | Unit Tests | Integration Tests |
|---|---|---|
| Frequência de falhas | Diária/semanal | Mensal |
| Tempo de diagnóstico | Minutos | Horas a dias |
| Volume de logs | Baixo | Alto |
| Localização de bug | Clara | Difusa |
| Custo de execução | Baixo | Alto |

---

## Automação de Diagnóstico

Ver [[03-RESOURCES/concepts/llm-ml-foundations/llm-test-failure-diagnosis]] — abordagem com LLMs que alcançou 90,14% de accuracy em produção no Google (Auto-Diagnose).

---

## Relacionados

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-test-failure-diagnosis]] — diagnóstico automático com LLM
- [[03-RESOURCES/entities/Google-Critique]] — onde falhas são reportadas no Google
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — logs como contexto para LLMs
