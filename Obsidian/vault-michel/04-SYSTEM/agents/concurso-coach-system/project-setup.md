# Concurso Coach System — Claude Project Setup

## Estratégia de Projects

| Project | System prompt | Uso |
|---------|--------------|-----|
| **Tutor-Mor** | `tutor-mor.md` | Sessões multi-disciplina, planejamento de ciclo |
| **Coach [disciplina]** | `coach-X.md` direto | Sessão focada em 1 disciplina |
| **Simulador** | `simulador.md` | Simulados cronometrados |
| **Corretor** | `corretor-redacao.md` | Correção de redação |

> Para prep intensiva em 1 disciplina: coach direto (sem tutor-mor) = menos tokens de orquestração.

## System prompt principal

`00-SYSTEM-PROMPTS/tutor-mor.md` — sessões gerais.

15 coaches disponíveis:
`coach-portugues`, `coach-logica`, `coach-tributario`, `coach-contabilidade`, `coach-auditoria`, `coach-administracao`, `coach-direito`, `coach-economia-financas-publicas`, `coach-previdenciario`, `coach-aduaneiro`, `coach-legislacao-estadual-municipal`, `coach-estatistica`, `coach-informatica-dados`, `coach-ingles`, `coach-redacao`

## Documentos para upload

### Referência fixa (obrigatório)
- `skills/banca-patterns.md` — padrões CESPE/FGV/FCC
- `skills/ciclo-estudos.md` — revisão espaçada, distribuição de carga

### Estado de estudo (atualizar após sessões longas)
- `docs/progress.md` — tópicos estudados, simulados, pontos fracos
- `docs/standards.md` — padrões pedagógicos do sistema

## Invocação

```
@tutor-mor — plano 6 meses Auditor Receita Federal
@coach-tributario — aula CESPE: lançamento de crédito tributário
@simulador — 20 questões FGV, contabilidade pública
@corretor-redacao — banca CESPE, tema: [X], texto: [colar]
```

## Regras críticas

1. **Banca obrigatória** — toda aula/simulado: `CESPE | FGV | FCC`
2. **Base legal** — coaches jurídicos/contábeis fundamentam sempre em lei + artigo
3. **Contexto Michel baked-in** — nunca reperguntar perfil (ADS/FIAP, fiscal, TI)
4. **Cross-call permitido** — coach pode acionar simulador/corretor diretamente
5. `docs/progress.md` atualizado ao fim de sessão longa (>30 min)

## Convivência com Edu System

- Concurso geral TI/admin → `@banca` (Edu System)
- Prep fiscal específica → `@tutor-mor` (este sistema)
