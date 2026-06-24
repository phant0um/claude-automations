---
title: "Polimorfismo"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations, java, oop]
status: developing
---

# Polimorfismo

O mesmo código funciona com objetos de tipos diferentes — a propriedade que torna sistemas extensíveis sem reescritas.

## O que é

Polimorfismo ("muitas formas") é a capacidade de um mesmo método se comportar de formas diferentes dependendo do objeto que o executa. Em Java, isso acontece principalmente de duas maneiras: sobrescrita (override) em tempo de execução e sobrecarga (overload) em tempo de compilação.

No polimorfismo em tempo de execução, uma variável do tipo pai pode guardar um objeto filho, e o método chamado é o da classe real do objeto — não o da variável. Isso permite escrever código genérico que funciona com qualquer subtipo futuro sem modificação. Interfaces ampliam esse poder: definem um contrato que qualquer classe pode implementar, independentemente de hierarquia.

Sobrecarga (overload) é diferente: mesmo nome de método, assinaturas distintas (número ou tipo de parâmetros). Resolvida em tempo de compilação. Útil, mas não é o "polimorfismo poderoso" — esse é o de override via herança/interface.

## Como funciona

```java
// Polimorfismo via herança (override)
class Animal {
    public String som() { return "..."; }
}
class Cachorro extends Animal {
    @Override public String som() { return "Au!"; }
}
class Gato extends Animal {
    @Override public String som() { return "Miau!"; }
}

// Código genérico — funciona com qualquer Animal
List<Animal> animais = List.of(new Cachorro(), new Gato());
for (Animal a : animais) {
    System.out.println(a.som()); // resolve em runtime
}

// Polimorfismo via interface
interface Pagamento { void processar(double valor); }
class CartaoCredito implements Pagamento { /* ... */ }
class Pix implements Pagamento { /* ... */ }
```

## Por que importa

Sem polimorfismo, você escreve um `if/else` ou `switch` gigante para cada tipo. Com polimorfismo, adicionar um novo tipo não toca no código existente — princípio Open/Closed do SOLID. Na FIAP Fase 2+ (Spring MVC, padrões de projeto), polimorfismo via interfaces é onipresente. Em concursos, cai como "qual a saída deste código com override".

## Exemplo

```java
// Sobrecarga (overload) — mesmo nome, assinaturas diferentes
class Calculadora {
    int somar(int a, int b) { return a + b; }
    double somar(double a, double b) { return a + b; }
}
```

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/heranca]]
- [[03-RESOURCES/concepts/encapsulamento]]
