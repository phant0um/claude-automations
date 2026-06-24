---
title: "Pensamento Computacional"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# Pensamento Computacional

A habilidade de resolver qualquer problema como um computador resolveria — antes de escrever uma linha de código.

## O que é

Pensamento computacional é o conjunto de habilidades cognitivas para formular problemas de forma que um computador (ou humano) possa resolvê-los eficientemente. Não depende de linguagem — é uma forma de pensar que precede a programação. Jeannette Wing, que popularizou o conceito em 2006, define como "os processos de pensamento envolvidos na formulação de problemas e suas soluções de forma que as soluções sejam representadas de modo a poderem ser executadas por um agente de processamento de informações".

Os **quatro pilares** são interdependentes e usados juntos na prática:

1. **Decomposição:** dividir um problema complexo em subproblemas menores e gerenciáveis. Ex: "construir um e-commerce" vira: autenticação + catálogo + carrinho + pagamento + entrega.
2. **Reconhecimento de padrões:** identificar semelhanças, repetições ou regularidades entre problemas. Ex: perceber que ordenar nomes e ordenar números seguem o mesmo algoritmo de comparação.
3. **Abstração:** focar no essencial, ignorar detalhes irrelevantes. Ex: modelar um "Usuário" como nome + email + senha, sem se preocupar com cor do cabelo.
4. **Algoritmo:** criar uma solução passo a passo, sistemática e reproduzível para o problema decomposto.

## Como funciona

Exemplo cotidiano → lógica computacional: "fazer café"

```
DECOMPOSIÇÃO: encher água, adicionar café, ligar cafeteira, aguardar, servir
PADRÃO: "encher" é igual para água e suco — procedimento reutilizável
ABSTRAÇÃO: ignorar cor da xícara, temperatura da água (dentro do range)
ALGORITMO:
  1. SE cafeteira.temAgua() == false: cafeteira.encherAgua()
  2. cafeteira.adicionarCafe(quantidade)
  3. cafeteira.ligar()
  4. AGUARDAR cafeteira.estaProto()
  5. SERVIR em xicara
```

## Por que importa

É o pré-requisito real antes de aprender qualquer linguagem — a FIAP usa pensamento computacional na Fase 1 exatamente para calibrar o raciocínio antes de Java. Em concursos públicos, questões de "lógica de programação" testam decomposição e algoritmo mesmo sem código. Além disso, com IA gerando código cada vez mais, a habilidade que permanece valiosa é saber **o que pedir** — que é decomposição + abstração aplicadas.

## Exemplo

Problema: "verificar se uma palavra é palíndromo"
- Decomposição: ler palavra → normalizar (minúsculas, sem espaço) → comparar com reverso
- Abstração: ignorar acentos e maiúsculas
- Algoritmo: `palavra == reverso(palavra)`

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/algoritmo]]
- [[03-RESOURCES/concepts/engenharia-de-software]]
