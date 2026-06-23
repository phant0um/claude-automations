---
title: "Finance System"
description: "Sistema de análise financeira: fundamentalista, renda passiva, macro, quant, cripto, adversarial e IRPF"
version: "2.0.0"
updated: 2026-05-28
status: active
tags: [agents, finanças, investimentos, claude]
---

# Finance System

8 analistas especializados + orchestrator orquestrados pelo **Nexo** para análise financeira completa — de empresa a ciclo macro, de ETF a on-chain, com adversarial checking, IRPF integrado e análise de faturas de cartão.

## Arquitetura

```
Nexo (orchestrator + estado de sessão)
├── [Layer 0] Macro  → classifica regime econômico (governa análises downstream)
├── Valor       → análise fundamentalista: ações BR + EUA (DCF, múltiplos, moat)
├── Fluxo       → renda passiva: ETFs, FIIs, BDRs, dividendos
├── Quant       → quantitativo: fatores, otimização de portfólio, Sharpe, backtesting
├── Cripto      → criptoativos: on-chain, tokenomics, DeFi, tributação crypto BR
├── Contador    → IRPF, ganho de capital, DARF, tributação cross-asset
├── Fatura      → análise de faturas: Santander, Porto Seguro, Revolut
└── Desafiante  → adversarial checker: ataca premissas de qualquer análise
```

## Agentes

| Agente | Papel | Trigger | Modelo |
|--------|-------|---------|--------|
| Nexo | Orchestrator + estado de sessão | `@nexo`, investimento, carteira | Sonnet 4.6 |
| Valor | Fundamentalista | `@valor`, análise empresa, DCF, múltiplos | Opus 4.8 (DCF) / Sonnet 4.6 |
| Fluxo | Renda passiva | `@fluxo`, ETF, FII, dividendos, BDR | Sonnet 4.6 |
| Macro | Macroeconomia + regime [Layer 0] | `@macro`, Selic, câmbio, Fed, ciclo | Sonnet 4.6 |
| Quant | Quantitativo | `@quant`, Sharpe, fator, backtesting | Opus 4.8 (otimiz.) / Sonnet 4.6 |
| Cripto | Criptoativos | `@cripto`, Bitcoin, DeFi, on-chain | Sonnet 4.6 |
| Contador | IRPF e tributação | `@irpf`, ganho de capital, DARF, IR | Sonnet 4.6 |
| Fatura | Faturas de cartão | `@fatura`, fatura cartão, análise gastos | Sonnet 4.6 |
| Desafiante | Adversarial challenger | `@desafiante`, revise análise | Opus 4.8 |

## Quando usar qual

| Situação | Agente |
|----------|--------|
| Analisar empresa específica (PETR4, AAPL) | Valor |
| Escolher ETF, FII ou montar carteira passiva | Fluxo |
| Entender cenário de juros/câmbio/inflação | Macro |
| Otimizar carteira, calcular Sharpe, analisar fator | Quant |
| Analisar Bitcoin, altcoin, DeFi, tributação crypto | Cripto |
| IRPF, ganho de capital, DARF, IR sobre ativos | Contador |
| Analisar fatura de cartão, gastos, economia | Fatura |
| Questionar premissas de uma análise já feita | Desafiante |
| Análise de carteira multi-ativo completa | Nexo → Macro → especialistas → Desafiante |
| Não sei qual | Nexo |

## Skills compartilhadas

| Skill | Função | Usada por |
|-------|--------|-----------|
| `disclaimer.md` | Aviso regulatório (1× por sessão) | Todos |
| `tax-rules-br.md` | IR por classe de ativo | Valor, Fluxo, Cripto, Contador |
| `regime-classifier.md` | Template padronizado de regime econômico | Macro, Nexo, Desafiante |
| `portfolio-state.md` | Estado visível de sessão + compactação | Nexo |
| `fatura-parser.md` | Formatos de PDF por banco + categorias | Fatura |

## Como invocar

```
@nexo — [descreva o que quer analisar]
@valor — analise [ticker]
@valor — compare [ticker A] com [ticker B]
@fluxo — qual ETF para [objetivo]
@fluxo — analise FII [ticker]
@macro — cenário BR agora
@macro — classifique o regime econômico atual
@quant — otimize minha carteira: [lista de ativos e %]
@quant — fator momentum funciona no Brasil?
@cripto — on-chain Bitcoin
@cripto — tokenomics [projeto]
@irpf — calcule IR sobre venda de [ativo]
@fatura — analise .raw/faturas/2026-05-santander.pdf
@fatura — analise fatura do mês [banco]
@desafiante — revise análise de [ticker/portfólio]
@desafiante — questione premissas: [análise]
```

## Disclaimer
Análises são educacionais e informativas. Não constituem recomendação de investimento personalizada. Consulte CFP, CFA ou AAI antes de decisões financeiras.
