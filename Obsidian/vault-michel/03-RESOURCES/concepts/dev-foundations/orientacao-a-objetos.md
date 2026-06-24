---
title: Orientação a Objetos (POO)
type: concept
status: developing
tags: [java, programacao, fiap, fase-5]
created: 2026-04-14
updated: 2026-05-19
---

# Orientação a Objetos (POO)

Paradigma de programação que organiza o código em **objetos** — instâncias de **classes** que encapsulam dados e comportamentos.

## Os 4 Pilares

| Pilar | Descrição |
|-------|-----------|
| **Abstração** | Modelar apenas o que é relevante para o contexto |
| **Encapsulamento** | Esconder a implementação; expor só o necessário |
| **Herança** | Uma classe filha reutiliza e estende a classe pai |
| **Polimorfismo** | Um mesmo método se comporta de formas diferentes por contexto |

## Em Java

```java
public class ContaBancaria {
    private double saldo;  // encapsulamento

    public ContaBancaria(double saldoInicial) {
        this.saldo = saldoInicial;
    }

    public double getSaldo() { return saldo; }

    public void depositar(double valor) {
        saldo += valor;
    }
}

// Herança
public class ContaCorrente extends ContaBancaria {
    private double limite;
    // ...
}
```

## Ver também

- [[03-RESOURCES/concepts/encapsulamento|Encapsulamento]]
- [[03-RESOURCES/concepts/heranca-polimorfismo|Herança e Polimorfismo]]
- [[03-RESOURCES/entities/Java|Java]]
- [[02-AREAS/fiap/fase-5/fase-5-index|Fase 5 — Orientação a Objetos]]
