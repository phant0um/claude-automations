---
title: "Legacy Systems"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# Legacy Systems

Código antigo mas crítico em produção — a maioria do software que move dinheiro, saúde e infraestrutura do mundo é legacy, e saber trabalhar com ele é uma habilidade rara e valiosa.

## O que é

Legacy system é qualquer sistema em produção que, por idade ou contexto, acumula características que dificultam mudança: ausência de testes, tecnologias fora de suporte, conhecimento tribal (só uma pessoa sabe como funciona), e ausência de documentação atualizada.

## Como funciona

**Desafios típicos:**
- _Sem testes_: cada mudança é um salto no escuro; refatorar sem testes é reescrever com medo
- _Stack desatualizado_: COBOL em bancos, PHP 5 em e-commerces, Java 8 em sistemas corporativos
- _Conhecimento tribal_: a lógica de negócio está na cabeça de alguém que pode sair amanhã
- _Dependências ocultas_: módulos acoplados de formas não documentadas; mudar A quebra B inesperadamente

**Estratégias de modernização:**

_Strangler Fig Pattern:_ construir o sistema novo em paralelo, roteando gradualmente tráfego do legacy para o novo até o legacy ser "estrangulado" (desligado). Risco baixo, migração incremental.

_Anti-Corruption Layer (ACL):_ camada de tradução entre o sistema novo e o legacy — o novo nunca fala diretamente com o legacy; a ACL traduz conceitos de domínio. Permite evolução independente.

_Big Bang Rewrite:_ reescrever do zero e fazer cutover. Alta recompensa, alto risco — projetos que subestimam o conhecimento implícito no legacy frequentemente falham aqui.

**Abordagem pragmática:**
1. Characterization tests: escrever testes que documentam o comportamento atual (sem entender o porquê) antes de tocar no código
2. Identificar seams: pontos onde o comportamento pode ser interceptado/substituído sem alterar o resto
3. Extrair em módulos testáveis incrementalmente

## Por que importa

Desenvolvedores que sabem modernizar legacy são mais valiosos que os que só constroem greenfield. Todo sistema atual eventualmente se torna legacy — entender o ciclo é parte de ser engenheiro sênior.

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
