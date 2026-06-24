---
title: "Herança"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations, java, oop]
status: developing
---

# Herança

Uma classe reutiliza e especializa o comportamento de outra — poderoso quando bem usado, perigoso quando abusado.

## O que é

Herança é o mecanismo pelo qual uma classe (filha/subclasse) herda atributos e métodos de outra (pai/superclasse). Em Java, usa-se a keyword `extends`. A subclasse ganha tudo que é `public` ou `protected` do pai e pode sobrescrever métodos com `@Override`.

O construtor do pai nunca é herdado automaticamente — você o chama explicitamente com `super()` na primeira linha do construtor filho. Sem essa chamada, Java insere um `super()` implícito (sem argumentos); se o pai não tiver construtor vazio, dá erro de compilação.

A armadilha clássica: herança profunda (A → B → C → D → ...) cria acoplamento rígido e fragilidade — mudar o pai quebra toda a cadeia. A regra de ouro da OOP moderna é **preferir composição a herança**: use herança apenas quando a relação é genuinamente "é um" (Cachorro é um Animal), não quando é "tem um" (Carro tem um Motor).

## Como funciona

```java
class Veiculo {
    protected String marca;
    protected int ano;

    public Veiculo(String marca, int ano) {
        this.marca = marca;
        this.ano = ano;
    }

    public String descricao() {
        return marca + " (" + ano + ")";
    }
}

class Carro extends Veiculo {
    private int portas;

    public Carro(String marca, int ano, int portas) {
        super(marca, ano); // obrigatório primeiro
        this.portas = portas;
    }

    @Override
    public String descricao() {
        return super.descricao() + " - " + portas + " portas";
    }
}
```

## Por que importa

Na FIAP, herança aparece desde a Fase 1 de Java e é cobrada em diagramas UML de classe. Em concursos de TI, questões pedem para identificar o que é herdado, o que é sobrescrito e o que é `final` (impede herança). Entender quando NÃO usar herança (e usar composição) diferencia um design mediano de um design sólido.

## Exemplo

`Piloto extends Carro` está errado — piloto não "é um" carro. Correto: classe `Piloto` com atributo `Carro carro` (composição). Use `final class` para bloquear herança quando a classe não foi projetada para ser estendida.

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/polimorfismo]]
- [[03-RESOURCES/concepts/encapsulamento]]
- [[03-RESOURCES/concepts/uml]]
