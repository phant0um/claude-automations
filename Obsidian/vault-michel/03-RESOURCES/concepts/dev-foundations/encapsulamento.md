---
title: "Encapsulamento"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations, java, oop]
status: developing
---

# Encapsulamento

Ocultar o estado interno de um objeto e expor apenas o necessário — o pilar que transforma código frágil em código confiável.

## O que é

Encapsulamento é o princípio OOP que consiste em esconder os dados internos de um objeto (atributos) e controlar o acesso a eles por meio de métodos públicos. Em vez de deixar qualquer parte do código alterar diretamente um atributo, você define quem pode ler (getter) e quem pode escrever (setter) — e com quais regras.

Em Java, isso se traduz em declarar atributos como `private` e fornecer métodos `public` para acesso controlado. O modificador `protected` é usado quando subclasses precisam de acesso. A regra geral: use sempre o modificador mais restritivo possível.

O princípio "tell don't ask" resume bem a mentalidade: em vez de pegar o saldo e calcular você mesmo, diga ao objeto "faça o saque" e deixe ele verificar as regras internamente. Isso reduz acoplamento e centraliza a lógica onde ela pertence.

## Como funciona

```java
public class ContaBancaria {
    private double saldo; // ninguém acessa diretamente

    public ContaBancaria(double saldoInicial) {
        this.saldo = saldoInicial;
    }

    public double getSaldo() { return saldo; }

    public void sacar(double valor) {
        if (valor <= 0 || valor > saldo)
            throw new IllegalArgumentException("Saque inválido");
        saldo -= valor;
    }

    public void depositar(double valor) {
        if (valor <= 0) throw new IllegalArgumentException("Valor inválido");
        saldo += valor;
    }
}
```

Ninguém fora da classe pode fazer `conta.saldo = -9999`. A validação vive onde deve viver.

## Por que importa

Na FIAP (Fase 1+), todo projeto Java cobra encapsulamento — é critério em projetos Fintech e MVC. Em concursos de TI, questões de OOP testam frequentemente a diferença entre `private`/`protected`/`public` e o conceito de "information hiding". É também pré-requisito para entender herança e polimorfismo com segurança.

## Exemplo

Sem encapsulamento: `conta.saldo -= 500` — qualquer bug em qualquer classe corrompe o saldo.
Com encapsulamento: `conta.sacar(500)` — a regra de negócio está garantida em um único lugar.

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/heranca]]
- [[03-RESOURCES/concepts/polimorfismo]]
- [[03-RESOURCES/concepts/dao-pattern]]
