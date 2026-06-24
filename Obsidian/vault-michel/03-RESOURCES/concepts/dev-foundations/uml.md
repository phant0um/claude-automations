---
title: "UML"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# UML

A linguagem visual universal para modelar software — usada em projetos FIAP, documentação técnica e questões de concurso.

## O que é

UML (Unified Modeling Language) é uma notação padronizada para representar visualmente a estrutura e o comportamento de sistemas de software. Não é uma linguagem de programação — é uma linguagem de modelagem: você usa diagramas para planejar antes de codificar, documentar o que foi feito, ou comunicar arquitetura para a equipe.

Os três diagramas mais usados no contexto ADS são: **Diagrama de Classes** (estrutura estática — classes, atributos, métodos e relações), **Diagrama de Sequência** (como objetos interagem ao longo do tempo para um caso de uso específico), e **Diagrama de Casos de Uso** (o que o sistema faz do ponto de vista do usuário — atores e funcionalidades).

Ferramentas comuns: draw.io (grátis, web), Lucidchart, PlantUML (texto → diagrama), StarUML. Na FIAP, normalmente se usa draw.io ou Astah.

## Como funciona

**Diagrama de Classes — notação:**
```
┌─────────────────────────┐
│ <<classe>>              │
│ ContaBancaria           │
├─────────────────────────┤
│ - saldo: double         │  ← atributo privado
│ # titular: String       │  ← atributo protegido
│ + numero: int           │  ← atributo público
├─────────────────────────┤
│ + getSaldo(): double    │
│ + sacar(v: double): void│
└─────────────────────────┘
```

Relações entre classes:
- **Herança (extends):** seta com triângulo vazio → (`ContaCorrente ──▷ ContaBancaria`)
- **Implementação (implements):** seta pontilhada com triângulo (`ContaCorrente ··▷ Pagavel`)
- **Associação:** linha simples (`Cliente ── ContaBancaria`)
- **Composição:** losango preenchido (`Pedido ◆── ItemPedido`)
- **Dependência:** seta pontilhada (`Controller ··→ Service`)

Multiplicidade: `1`, `0..1`, `*`, `1..*` nas pontas das associações.

## Por que importa

Na FIAP, UML é exigido em fases de modelagem e projetos integradores — você entrega diagrama de classes junto com o código. Em concursos de TI (Analista de Sistemas), questões de UML são frequentes: "identifique a relação entre as classes", "quantos métodos a classe X herda". Além disso, saber modelar antes de codificar previne retrabalho — é a diferença entre arquitetar e improvisar.

## Exemplo

Diagrama de Sequência para login:
```
Cliente → Controller: POST /login(usuario, senha)
Controller → AuthService: autenticar(usuario, senha)
AuthService → UsuarioDAO: buscarPorEmail(usuario)
UsuarioDAO → Controller: Usuario
AuthService → Controller: token JWT
Controller → Cliente: 200 OK + token
```

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/heranca]]
- [[03-RESOURCES/concepts/mvc-architecture]]
- [[03-RESOURCES/concepts/engenharia-de-software]]
