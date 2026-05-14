---
title: "Grafily — Obsidian Plugin para Family Graphs"
type: source
source_file: "Clippings/TheBestTvarynkagrafily Obsidian plugin for rendering pretty family graphs (family trees).md"
origin: GitHub repo (TheBestTvarynka/grafily)
ingested: 2026-05-14
tags: [obsidian, plugin, family-tree, genealogy, visualization]
---
# Grafily — Obsidian Plugin para Family Graphs

> [!key-insight] Core point
> Plugin Obsidian para renderizar grafos familiares interativos a partir de arquivos .md (one page per person), usando ReactFlow e dois algoritmos de layout distintos.

## Conteúdo

### O que é
- Plugin para genealogia/pesquisa familiar dentro do Obsidian
- Princípio: cada pessoa = uma nota `.md` com metadados estruturados
- Grafily escaneia diretório configurável, extrai metadados, constrói grafo de relacionamentos

### Algoritmos de visualização
| Algoritmo | Tipo | Vantagem |
|---|---|---|
| Reingold-Tilford | Tree-based | Centralização perfeita; mostra apenas ancestrais/descendentes diretos |
| Brandes-Köpf | Graph-based | Universal para qualquer complexidade familiar |

### Metadados por pessoa
```markdown
# Sobrenome Nome

**Spouse**: [[página cônjuge]]
**Parents**: [[pai]], [[mãe]]
**Birth**: YYYY-MM-DD
**Death**: YYYY-MM-DD  (opcional)
**Image**: [[foto]]
```

### Instalação
- Não listado na store oficial (autor é único usuário)
- Instalar via clonagem do repo + habilitar em Community Plugins
- Criado por: [@TheBestTvarynka (Pavlo Myroniuk)](https://github.com/TheBestTvarynka)

### Motivação
- Autor queria manter dados familiares privados (sem MyHeritage etc.)
- Obsidian: dono dos dados, fácil de usar, API de plugins poderosa

## Conexões
- [[03-RESOURCES/entities/Grafily]]
- [[03-RESOURCES/concepts/second-brain]]
- [[03-RESOURCES/concepts/semantic-file-system]]
