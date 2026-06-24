---
title: "How we found a bug in the hyper HTTP library"
type: source
source: "Clippings/How we found a bug in the hyper HTTP library.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [articles]
---

## Tese central
Uma rearquitetura de performance (substituir um intermediário de rede por socket Unix local, mais rápido) expôs uma race condition de anos na biblioteca Rust `hyper`, presente em múltiplas versões major: o loop de despacho HTTP/1 descartava o resultado de `poll_flush` com `let _ =`, perdendo o sinal de `Poll::Pending` quando o buffer de socket estava cheio, e prosseguia para fazer `shutdown` da conexão mesmo com megabytes de dados ainda no buffer interno — cortando a resposta antes do envio completo. A correção, depois de seis semanas de investigação, foi de quatro linhas: checar se o flush realmente terminou antes de decidir que o loop terminou.

## Argumentos principais
- **Sintoma**: requisições de transformação de imagem falhavam intermitentemente, só para imagens grandes, retornando HTTP 200 sem erro logado — mas com o corpo cortado (ex.: resposta de 2MB chegando com algumas centenas de KB).
- **Mudança que expôs o bug**: a Images binding originalmente passava dados pela FL (serviço intermediário interno full-pipeline, com overhead de DNS/roteamento). A rearquitetura trocou isso por um binding interno via socket Unix direto entre Workers runtime e Images service, no mesmo processo — mais rápido, mas trocando quem lê do outro lado do socket.
- **Por que a mudança revelou o bug, não criou**: o bug (em `dispatch.rs` do hyper) sempre existiu — a FL anterior consumia dados rápido o bastante para o buffer do socket quase nunca enchesse durante uma resposta. O novo leitor lia num ritmo que ocasionalmente deixava o buffer enchendo durante respostas grandes; poucos milissegundos de backpressure foram o suficiente para expor a falha.
- **Processo de debugging por eliminação** (múltiplos becos sem saída e pistas úteis): reprodução isolada do binding sozinho (19/25 falhas num batch, ~200KB recebidos — suspeitosamente perto do tamanho do buffer de socket em produção); descartada hipótese de timeout (truncamento não correlacionava com duração); descartada hipótese de versão do hyper (testado em 0.14, 1.7, 1.8 — bug em todas); reprodução local (macOS/Debian VM) nunca disparou o bug mesmo sob carga — só ocorria no caminho de produção com concorrência real e cliente real do Workers runtime; runtime do Workers descartado via inspeção de syscalls; distributed tracing confirmou que o corpo já chegava truncado antes da camada externa — isolando o problema ao pipeline interno (binding).
- **`strace` como ferramenta decisiva**: ao interceptar syscalls do Images service, comparar uma requisição bem-sucedida (múltiplos `sendto` até o buffer esvaziar, depois `shutdown`) contra uma falha (um único `sendto` parcial seguido imediatamente por `shutdown`, sem sinal de término do cliente entre os dois) revelou a race condition diretamente. Importante: ampliar o filtro de syscalls do `strace` mudava o timing o suficiente para o bug desaparecer — confirmando a natureza timing-sensitive.
- **Mecanismo exato do bug em `dispatch.rs`**: o loop de despacho chama `poll_read`, `poll_write`, `poll_flush` descartando cada resultado com `let _ =`; quando `poll_flush` retorna `Poll::Pending` (buffer cheio, flush incompleto), esse sinal é perdido; o loop verifica `wants_read_again()` (false, já recebeu a requisição completa) e retorna `Poll::Ready(Ok(()))` — sinalizando "terminado" mesmo com dados ainda no buffer interno do hyper, disparando `shutdown(SHUT_WR)` prematuro.
- **Por que `curl` nunca reproduzia**: curl lê dados tão rápido quanto chegam, o buffer do socket nunca enche, o flush sempre completa de imediato, e o valor descartado nunca importa — só o caminho de produção, com leitor que pausa por alguns milissegundos, expunha a janela exata da race.

## Key insights
- Bugs de race condition dependentes de timing podem ficar invisíveis por anos em bibliotecas amplamente usadas porque o "caminho feliz" (leitor rápido) mascara completamente a falha — só uma mudança de infraestrutura que alterou quem lê do outro lado do socket revelou a condição latente.
- Ferramentas de observabilidade de nível de aplicação (tracing, logging) reportaram "tudo certo" porque o sistema genuinamente acreditava que tinha terminado — só instrumentação no nível de syscall (`strace`) revelou o que realmente aconteceu no kernel.
- O ato de instrumentar pode alterar o fenômeno observado: ampliar o filtro do `strace` mudou o timing o suficiente para o bug não se manifestar, confirmando indiretamente a causa antes mesmo de ler o código-fonte do `hyper`.

## Exemplos e evidências
- Números concretos: seis semanas de investigação, fix de quatro linhas; em uma requisição de exemplo, apenas ~200KB de 3.3MB esperados chegaram; em outra, 219KB de 14.9MB chegaram antes do shutdown prematuro.
- Trechos de `strace` comparando sucesso (múltiplos `sendto` até esvaziar buffer, depois `shutdown`) vs. falha (um `sendto` parcial seguido de `shutdown` imediato).
- Código simplificado do `poll_loop` mostrando o `let _ =` problemático, e a correção aplicada (`poll_flush` cujo resultado é checado explicitamente; se `is_pending()`, retorna `Poll::Pending` em vez de prosseguir).
- Teste de regressão construído: wrapper customizado em torno de TCP stream que aceita 8KB no primeiro write e depois retorna `Poll::Pending` em todo write subsequente, simulando buffer cheio — confirmou que sem o fix o shutdown ocorria com 492KB de 500KB ainda no buffer; com o fix, esperava.

## Implicações para o vault
Caso de debugging metodológico de alto nível, relevante a `[[03-RESOURCES/concepts/dev-foundations/rust-systems]]` (Rust/async/Poll patterns) e a qualquer discussão futura sobre `integration-testing.md` — ilustra concretamente por que testes locais/curl não pegam bugs de concorrência real e por que instrumentação de syscall é necessária quando tracing de aplicação mente (porque o sistema genuinamente não sabe que está incompleto). Não há concept dedicado a "race conditions em Rust async" no vault; criado abaixo para capturar o padrão.

## Links
- [[03-RESOURCES/concepts/dev-foundations/rust-systems]]
- [[03-RESOURCES/concepts/dev-foundations/integration-testing]]
- [[03-RESOURCES/concepts/dev-foundations/race-condition-async-rust]]
