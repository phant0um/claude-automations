---
title: Race Condition em Rust Async
type: concept
created: 2026-06-22
updated: 2026-06-22
tags: [concept, dev-foundations]
---

# Race Condition em Rust Async

Falha de concorrência timing-dependent em código assíncrono Rust onde o resultado de uma operação (`Poll::Pending` vs `Poll::Ready`) é descartado ou mal-checado, levando o sistema a agir como se um trabalho estivesse completo quando na verdade ainda está pendente.

## Padrão

Em loops de polling (`poll_read`, `poll_write`, `poll_flush`), descartar o retorno com `let _ = expr` perde o sinal de `Poll::Pending`. Se uma etapa downstream depende desse sinal (ex.: decidir se a conexão pode ser encerrada), o loop pode concluir prematuramente — executando `shutdown` ou liberando recursos com trabalho ainda em andamento (ex.: dados ainda no buffer interno, não flush para o socket).

## Por que é difícil de detectar

- O "caminho feliz" (operação rápida, sem backpressure) mascara completamente a falha — o bug só se manifesta quando uma operação específica (ex.: flush) não completa na primeira tentativa.
- Observabilidade de nível de aplicação (logs, tracing) reporta "sucesso" porque o próprio sistema acredita ter terminado — só instrumentação de syscall (`strace`) revela o estado real do kernel.
- Instrumentar pode alterar o timing o suficiente para o bug não se manifestar (efeito observador) — dificultando reprodução sob debug ativo.

## Por que importa

- Pode permanecer latente por anos numa biblioteca amplamente usada até uma mudança de infraestrutura não-relacionada (ex.: trocar quem lê do outro lado de um socket) alterar o timing o suficiente para expor a condição.
- Reforça que testes locais com clientes "rápidos" (ex.: curl) não reproduzem bugs que só aparecem sob backpressure real de produção.

## Evidências

- **[2026-06-22]** Bug de anos na biblioteca `hyper` (Rust): `let _ = poll_flush(...)` descartava `Poll::Pending`, causando `shutdown` prematuro de conexão com megabytes ainda no buffer; exposto por troca de intermediário de rede (FL → socket Unix direto) que mudou o timing do reader. Fix de 4 linhas após 6 semanas de investigação — [[03-RESOURCES/sources/how-we-found-a-bug-in-the-hyper-http-library]]

## Links
- [[03-RESOURCES/concepts/dev-foundations/rust-systems]]
- [[03-RESOURCES/concepts/dev-foundations/integration-testing]]
- [[03-RESOURCES/sources/how-we-found-a-bug-in-the-hyper-http-library]]
