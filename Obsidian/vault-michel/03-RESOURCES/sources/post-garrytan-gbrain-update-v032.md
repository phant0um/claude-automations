---
title: "GBrain Update — 14 PRs em 72h, v0.31.2 → v0.32.4"
type: source
source_file: Clippings/Post by @garrytan on X.md
origin: post no X (@garrytan)
ingested: 2026-05-14
tags: [gbrain, garry-tan, agent-memory, open-source, production]
---
# GBrain Update — 14 PRs em 72h, v0.31.2 → v0.32.4

> [!key-insight] Core point
> GBrain saltou de v0.31.2 para v0.32.4 em 72 horas com 14 PRs e +28.746 linhas — destaques: sistema de junção de fatos (memória quente), takes v2 reescrito com aprendizados de 100K takes, e embedding recipes.

## Conteúdo

### PRs de destaque

- **#885** sistema de junção de fatos ao system-of-record (+5.682) — camada de memória quente
- **#795** takes v2 (+5.306) — reescrito a partir de aprendizados de produção com 100K takes
- **#796** extração de fatos durante a sincronização (+3.418) — memória quente em tempo real
- **#859** resolvers de área funcional (+3.166) — compressão da tabela de roteamento
- **#810** 5 novas receitas de embedding (+1.818) — fechou cluster de 17 PRs de uma vez
- **#801** limpeza graciosa do MCP (+1.863)
- **#816** auto-upgrade do thin-client (+1.608)
- **#808** threading multi-fonte (+1.571)
- **#844** IDs de modelo canônicos (+1.304)
- **#804** onda de correções do doctor, adaptando 5 PRs da comunidade (+828)

Total: +28.746 / -1.173 linhas em 72 horas. Oito incrementos de versão.

## Conexões

- [[03-RESOURCES/entities/Garry-Tan]]
- [[03-RESOURCES/concepts/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-memory-four-layers]]
