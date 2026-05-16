---
name: geo-optimizer
type: skill
version: 1.0.0
used-by:
  - rumo
  - ajuste
---

# Geo Optimizer

Skill de otimização de sequência geográfica para roteiros de viagem.

## Princípio central

Agrupe atividades por quadrante geográfico, não por tipo de atividade. Um roteiro geograficamente correto nunca retorna ao mesmo quadrante sem justificativa logística.

## Regras de aplicação

- **Agrupamento por quadrante:** dividir a cidade/região em quadrantes e concentrar atividades por dia dentro do mesmo quadrante.
- **Teste de zigue-zague:** se o roteiro exige voltar ao mesmo quadrante em dias diferentes sem motivo logístico claro, reordenar.
- **Prioridade aeroporto:** atrações no caminho do aeroporto devem ser reservadas para o último dia (aproveitar o trajeto de saída).
- **Buffers mínimos obrigatórios:**
  - Voos domésticos: 3h de antecedência
  - Voos internacionais: 4h de antecedência
  - Transfers urbanos densos (metrô na hora do rush, congestionamento conhecido): +1h

## Saída esperada

Ao aplicar esta skill, retornar:

```
[geo-optimizer]
- Quadrantes identificados: [lista]
- Problemas detectados: [zigue-zague, retorno desnecessário, etc.]
- Reordenação sugerida: [antes → depois, com justificativa]
- Atrações no caminho do aeroporto: [lista para alocação no último dia]
```

## Exemplo

```
[geo-optimizer] — Tokyo
- Quadrantes: Norte (Asakusa, Ueno), Centro (Shinjuku, Shibuya), Sul (Harajuku, Omotesando)
- Problema: Dia 2 vai Norte → Sul → Norte = 2 transfers desnecessários
- Reordenação: Dia 2 = Norte completo | Dia 3 = Sul completo
- Aeroporto Narita: Asakusa está no caminho → alocar para manhã do Dia 5 (último)
```
