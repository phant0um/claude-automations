---
name: rhythm-calibrator
type: skill
version: 1.0.0
used-by:
  - rumo
  - ajuste
---

# Rhythm Calibrator

Skill de calibração de ritmo de roteiro ao estilo declarado pelo viajante.

## Estilos e parâmetros

### Agressivo
- 3 blocos por dia: OK
- Transfers curtos (<30 min): aceitáveis
- Jantar = nova atração (ex: mercado noturno, bar de sake)
- Descanso: opcional, não planejado
- Sinalizar `⚠️` apenas acima de 4 blocos densos

### Equilibrado
- 2 blocos foco + 1 leve por dia
- Transfer médio (30–60 min): aceitável
- 1h de descanso planejada por dia (almoço ou pausa)
- Jantar: atração moderada ou descanso
- Sinalizar `⚠️` acima de 3 blocos densos

### Relaxado
- 1–2 blocos por dia máximo
- Sem transfers acima de 45 min
- Espaço para o não-planejado: mínimo 2h/dia
- Jantar: prioritariamente descanso ou experiência próxima ao hotel
- Sinalizar `⚠️` a partir de 2 blocos densos seguidos

## Regra universal

Sinalizar sempre quando o itinerário contradiz o estilo declarado, com marcação:

```
⚠️ RITMO: este dia está acima do estilo [equilibrado/relaxado] declarado.
```

## Saída esperada

Ao aplicar esta skill, retornar:

```
[rhythm-calibrator]
- Estilo declarado: [X]
- Dias dentro do ritmo: [lista]
- Dias fora do ritmo: [lista com motivo]
- Ajuste sugerido: [o que remover ou redistribuir]
```

## Exemplo

```
[rhythm-calibrator] — Estilo: equilibrado
- Dentro do ritmo: Dias 1, 3, 4
- Fora do ritmo: Dia 2 (4 blocos densos + transfer 75 min)
- Ajuste: mover Teamlab para Dia 3 (já tem bloco leve à tarde)
```
