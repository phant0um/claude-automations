---
title: Flow-Based Programming (FBP)
type: concept
status: developing
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [paradigm, low-code, dataflow]
---

# Flow-Based Programming (FBP)

Paradigma proposto por J. Paul Morrison (IBM, 1971). Programa = grafo de nós (componentes black-box) conectados por canais que transportam pacotes de dados. Foco em fluxo de dados, não em controle.

## Conceitos-chave

- **Nós (components)** — black-boxes c/ portas de input/output
- **Conexões** — canais bufferizados que transportam pacotes
- **Pacotes (Information Packets)** — dados que fluem entre nós
- **Concorrência natural** — nós rodam em paralelo
- **Reusabilidade** — nó isolado, sem state compartilhado
- **Visualização** — grafo é o programa

## Vantagens

- Visualização clara do fluxo
- Paralelismo intrínseco
- Baixo coupling entre componentes
- Substituição/modificação de nós sem afetar resto
- Debug visual (inspecionar pacotes em trânsito)

## Implementações

- **Node-RED** (IBM, JS)
- **NoFlo** (JS)
- **Apache NiFi** (data flow Java/JVM)
- **LabVIEW** (instrumentação)
- **Unreal Blueprints** (game scripting)

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 13 (Node-RED)

## Relacionado

- [[03-RESOURCES/concepts/dev-foundations/low-code|Low-code]]
- [[03-RESOURCES/entities/Node-RED|Node-RED]]
