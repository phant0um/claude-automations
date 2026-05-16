---
title: "Finance System"
description: "Sistema de análise financeira: fundamentalista, renda passiva, macro, quant e cripto"
version: "1.0.0"
updated: 2026-05-16
status: active
tags: [agents, finanças, investimentos, claude]
---

# Finance System

5 analistas especializados orquestrados pelo **Nexo** para análise financeira completa — de empresa a ciclo macro, de ETF a on-chain.

## Arquitetura

```
Nexo (orchestrator)
├── Valor  → análise fundamentalista: ações BR + EUA (DCF, múltiplos, moat)
├── Fluxo  → renda passiva: ETFs, FIIs, BDRs, dividendos (seleção passiva)
├── Macro  → macroeconomia: juros, câmbio, ciclos, impacto em classes de ativo
├── Quant  → quantitativo: fatores, otimização de portfólio, Sharpe, backtesting
└── Cripto → criptoativos: on-chain, tokenomics, DeFi, tributação crypto BR
```

## Agentes

| Agente | Papel | Trigger |
|--------|-------|---------|
| Nexo | Orchestrator + intake | `@nexo`, investimento, carteira |
| Valor | Fundamentalista | `@valor`, análise empresa, DCF, múltiplos |
| Fluxo | Renda passiva | `@fluxo`, ETF, FII, dividendos, BDR |
| Macro | Macroeconomia | `@macro`, Selic, câmbio, Fed, ciclo |
| Quant | Quantitativo | `@quant`, Sharpe, fator, backtesting |
| Cripto | Criptoativos | `@cripto`, Bitcoin, DeFi, on-chain |

## Quando usar qual

| Situação | Agente |
|----------|--------|
| Analisar empresa específica (PETR4, AAPL) | Valor |
| Escolher ETF, FII ou montar carteira passiva | Fluxo |
| Entender cenário de juros/câmbio/inflação | Macro |
| Otimizar carteira, calcular Sharpe, analisar fator | Quant |
| Analisar Bitcoin, altcoin, DeFi, tributação crypto | Cripto |
| Não sei qual | Nexo |

## Skills compartilhadas

| Skill | Função | Usada por |
|-------|--------|-----------|
| `disclaimer.md` | Aviso regulatório (1× por sessão) | Todos |
| `tax-rules-br.md` | IR por classe de ativo | Valor, Fluxo, Cripto |

## Como invocar

```
@nexo — [descreva o que quer analisar]
@valor — analise [ticker]
@valor — compare [ticker A] com [ticker B]
@fluxo — qual ETF para [objetivo]
@fluxo — analise FII [ticker]
@macro — cenário BR agora
@macro — impacto da Selic na minha carteira: [composição]
@quant — otimize minha carteira: [lista de ativos e %]
@quant — fator momentum funciona no Brasil?
@cripto — on-chain Bitcoin
@cripto — tokenomics [projeto]
@cripto — IR sobre cripto: vendi R$40k em [exchange]
```

## Disclaimer
Análises são educacionais e informativas. Não constituem recomendação de investimento personalizada. Consulte CFP, CFA ou AAI antes de decisões financeiras.
