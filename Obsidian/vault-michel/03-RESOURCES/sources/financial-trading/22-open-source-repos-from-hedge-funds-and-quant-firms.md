---
title: "22 Open Source Repos from Hedge Funds and Quant Firms (Two Sigma, Man Group, Jane Street, D.E. Shaw, HRT, Optiver, WorldQuant)"
type: source
source: "[x.com/zostaff](https://x.com/zostaff/status/2056351832088207385)"
created: 2026-06-13
ingested: 2026-06-13
tags: [articles]
---

## Tese central

Que ferramentas open-source os maiores fundos quant do mundo realmente
publicam — e por quê. A divisão "open vs closed" mapeia diretamente em onde
está o moat de cada firma: pessoas (abrem) vs sinais proprietários (fecham).

## Argumentos principais

- **Quem NÃO publica nada**: Renaissance Technologies (~$130B AUM, 66%/ano
  por 3 décadas), Citadel (~$65B), Bridgewater (~$100B), Millennium (~$70B),
  Point72/Cubist (~$35B), AQR (conta formal mas só um fork do pandas).
- **Quem publica e por quê — 3 padrões**:
  1. Two Sigma, D.E. Shaw, Jane Street, HRT → open source como branding de
     recrutamento (edge está nas pessoas, não no código)
  2. Man Group → ArcticDB já tinha sido licenciado pela Bloomberg; resto é
     marketing institucional (empresa de capital aberto)
  3. Renaissance/Citadel/Bridgewater → edge está nos sinais proprietários;
     qualquer código público = dica para concorrentes (NDAs absolutos)
- **Repos por firma** (22 total, quase tudo MIT/Apache2/BSD — exceção
  ArcticDB em BSL):

| Firma | AUM/Receita | Repos-chave |
|-------|-------------|-------------|
| Two Sigma | $70B | `flint` (time-series joins sobre Spark p/ tick data), `beakerx` (Jupyter multi-linguagem: Python/Scala/Groovy/Kotlin/Clojure/Java), `marbles` (testes que explicam falha em linguagem natural), `cook` (scheduler batch sobre Mesos/K8s, usado por Twitter/Apple/Indeed) |
| Man Group / AHL | $228.7B | `ArcticDB` (DB time-series sobre S3, licenciado pela Bloomberg, pandas in/out, BSL), `dtale` (Excel sobre DataFrames no browser, mais popular do Man Group), `notebooker` (Jupyter → engine de relatórios agendados), `PyBloqs` (relatórios HTML via Python sem frontend) |
| Jane Street | $39.6B receita 2025 | `core` (stdlib alternativa OCaml — base de toda infra), `magic-trace` (tracer via Intel Processor Trace, repo mais popular), `async` (concorrência cooperativa OCaml — infra que move $2T/mês em equity volume), `hardcaml` (design de hardware FPGA/ASIC em OCaml) |
| D.E. Shaw | $90B | `pyflyby` (auto-import IPython/Jupyter), `pjrmi` (RPC Python↔Java sem glue code), `versioned-hdf5` (git para arquivos HDF5, com Quansight Labs), `nbstripout-fast` (remove outputs de notebooks pre-commit, em Rust) |
| Hudson River Trading | $20B capital | `corral` (structured concurrency C++20), `slang-server` (LSP para SystemVerilog — design de chips FPGA), `heracles-ql` (DSL Python para alertas em escala) |
| Optiver | market maker global | `timestamp9` (timestamps em nanosegundos para Python), `optiver-asyncpg` (fork de asyncpg para latência ultra-baixa) |
| WorldQuant | $9B | `WorldQuant_alpha101_code` (implementação comunitária do paper "101 Formulaic Alphas" — referência para pesquisa de alpha) |

## Key insights

- "Edge está nas pessoas, não no código" — tese de Two Sigma/Jane
  Street/D.E. Shaw/HRT para justificar open source como branding de
  recrutamento.
- Renaissance aposta o oposto — qualquer código público é uma dica para
  concorrentes, daí NDAs absolutos e zero publicação.
- Ambas as teses estão corretas há 25+ anos — não há vencedor único entre
  "pesquisador inteligente + ferramentas boas" vs "pesquisador médio +
  ferramentas secretas".

## Implicações para o vault

- **Tese unificadora**: a divisão "open vs closed" em quant mapeia
  diretamente em onde está o moat — pessoas (abrem) vs sinais (fecham). Two
  Sigma aposta que "pesquisador inteligente + ferramentas boas" > "pesquisador
  médio + ferramentas secretas"; Renaissance aposta o oposto. Ambos corretos
  há 25+ anos.
- Para qualquer projeto de trading/agente quant no vault: `ArcticDB` e
  `flint`/`dtale` são candidatos diretos de infraestrutura para armazenar e
  explorar séries temporais de ticks; `WorldQuant_alpha101_code` é ponto de
  partida para geração de sinais (alimenta o framework de combinação de
  sinais fracos do artigo companheiro).
- `WorldQuant_alpha101_code` e `ArcticDB`/`flint` são candidatos de
  ferramentas para qualquer implementação futura de pipeline de sinais.

## Links

- [[03-RESOURCES/concepts/finance-trading/algorithmic-trading]]
