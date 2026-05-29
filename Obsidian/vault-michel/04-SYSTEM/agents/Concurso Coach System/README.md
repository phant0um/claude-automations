---
title: "Concurso Coach System"
description: "Sistema de 18 agentes especializados para preparação fiscal (Receita Federal/Estadual/Municipal) — bancas CESPE, FGV, FCC"
version: "1.0.0"
updated: 2026-05-24
status: active
tags: [agents, concurso, fiscal, auditor, cespe, fgv, fcc]
---

# Concurso Coach System

Sistema de 18 agentes — 15 coaches de disciplina + 3 orquestradores — para preparação a concursos fiscais e de auditoria (Receita Federal, SEFAZ estaduais, ISS municipais, TCU/TCEs, CGU).

## Bancas alvo

| Banca | Característica | Pegadinha-mãe |
|-------|----------------|---------------|
| **CESPE/CEBRASPE** | C/E, modificadores absolutos, recortes doutrinários | "somente", "sempre", "exclusivamente", "em regra" |
| **FGV** | Interpretação sistemática, casos práticos, múltipla escolha densa | Alternativa "tecnicamente correta mas não é a melhor" |
| **FCC** | Letra de lei pura, lacunas, decoreba normativa | Trocar palavra-chave em citação literal |

## Arquitetura

```
tutor-mor (orquestrador)
├── Linguagem & raciocínio
│   ├── coach-portugues
│   ├── coach-ingles
│   ├── coach-logica           (RLM + matemática)
│   ├── coach-estatistica
│   └── coach-redacao
├── Direito
│   ├── coach-direito          (constitucional + administrativo)
│   ├── coach-tributario       (CTN + tributos federais)
│   ├── coach-legislacao-estadual-municipal  (ICMS/ISS/IPVA/ITBI/IPTU)
│   ├── coach-previdenciario
│   └── coach-aduaneiro
├── Contábil-financeiro
│   ├── coach-contabilidade    (geral + pública)
│   ├── coach-auditoria
│   └── coach-economia-financas-publicas
├── Gestão & tech
│   ├── coach-administracao    (geral + pública)
│   └── coach-informatica-dados  (HW/redes/seg + SQL/BI/fluência)
└── Função cross-cutting
    ├── simulador              (gera questões + corrige + tracking)
    └── corretor-redacao       (espelho banca + nota + diagnóstico)
```

## Agentes

| Slug | Função | Modelo |
|------|--------|--------|
| `tutor-mor` | Orquestrador — roteia, monta plano de ciclo, agenda revisão | claude-sonnet-4-6 |
| `simulador` | Gera simulados, aplica timer, devolve diagnóstico | claude-sonnet-4-6 |
| `corretor-redacao` | Corrige redação no padrão da banca informada | claude-sonnet-4-6 |
| `coach-portugues` | Gramática, interpretação, ortografia, sintaxe | claude-sonnet-4-6 |
| `coach-ingles` | Tradução, compreensão, vocabulário técnico fiscal | claude-haiku-4-5 |
| `coach-logica` | RLM, matemática financeira, proposicional, conjuntos | claude-sonnet-4-6 |
| `coach-estatistica` | Descritiva, inferencial, probabilidade, amostragem | claude-sonnet-4-6 |
| `coach-redacao` | Dissertativa, estrutura, argumentação, repertório | claude-sonnet-4-6 |
| `coach-direito` | Constitucional + Administrativo | claude-sonnet-4-6 |
| `coach-tributario` | CTN, tributos federais, processo tributário | claude-sonnet-4-6 |
| `coach-legislacao-estadual-municipal` | ICMS/ISS/IPVA/ITBI/IPTU + LCs | claude-sonnet-4-6 |
| `coach-previdenciario` | RGPS, RPPS, benefícios, custeio | claude-sonnet-4-6 |
| `coach-aduaneiro` | Regulamento Aduaneiro, regimes, classificação fiscal | claude-sonnet-4-6 |
| `coach-contabilidade` | Geral (CPC) + pública (MCASP, Lei 4.320, LRF) | claude-sonnet-4-6 |
| `coach-auditoria` | NBC TA, COSO, controles internos, governamental | claude-sonnet-4-6 |
| `coach-economia-financas-publicas` | Micro/macro, finanças públicas, orçamento | claude-sonnet-4-6 |
| `coach-administracao` | Geral (planejamento/estratégia) + pública | claude-sonnet-4-6 |
| `coach-informatica-dados` | HW/SO/redes/segurança + SQL/BI/Python análise | claude-sonnet-4-6 |

## Como invocar

```
@tutor-mor — plano de 6 meses para Auditor Receita Federal
@coach-tributario — aula CESPE sobre lançamento de crédito tributário
@coach-portugues — analisar questão: [colar enunciado]
@simulador — 20 questões FGV de contabilidade pública
@corretor-redacao — banca CESPE, tema: [tema], texto: [colar]
```

## Contexto fixo (baked-in em todos)

Michel Csasznik — ADS @ FIAP, prep concurso fiscal (Receita Federal/SEFAZ/ISS). Bancas alvo: CESPE, FGV, FCC. Familiaridade com TI — usar como vantagem em questões de info/dados.

## Docs

| Arquivo | Propósito |
|---------|-----------|
| `docs/progress.md` | Tópicos em estudo, simulados aplicados, pontos fracos |
| `docs/standards.md` | Padrões pedagógicos, formato de aula, base legal obrigatória |
| `skills/banca-patterns.md` | Padrões de cobrança CESPE/FGV/FCC detalhados |
| `skills/ciclo-estudos.md` | Ciclo de revisão espaçada, distribuição de carga |

## Regras do Sistema

1. **Tutor-mor obrigatório** quando contexto cruza disciplinas (ex: prova interdisciplinar)
2. **Banca explícita** — todo modo aula/simulado exige banca informada (CESPE | FGV | FCC)
3. **Base legal obrigatória** — coaches jurídicos/contábeis fundamentam sempre em lei + artigo
4. **Contexto Michel baked-in** — nunca repergutar perfil
5. **Progress.md atualizado** ao fim de sessão longa (>30 min)
6. **Cross-call permitido** — coach pode acionar simulador ou corretor diretamente

## Convivência com Edu System

Edu System tem `Banca` — agente generalista de concurso. Concurso Coach System é o aprofundamento por disciplina para o nicho fiscal. Para concurso geral TI/admin, use `@banca`. Para preparação fiscal específica, use `@tutor-mor`.
