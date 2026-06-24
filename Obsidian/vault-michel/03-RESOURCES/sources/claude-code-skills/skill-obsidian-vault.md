---
title: "Skill: obsidian-vault"
type: source
source_type: clipping
source_path: clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741 4.md
created: 2026-05-09
ingested: 2026-05-09
tags: [ai-agents, clipping]
triagem_score: 7
---

## Resumo

| name | obsidian-vault |
| --- | --- |
| description | Search, create, and manage notes in the Obsidian vault with wikilinks and index notes. Use when user wants to find, create, or organize notes in Obsidian. |

## Obsidian Vault

## Vault location

`/mnt/d/Obsidian Vault/AI Research/`

Mostly flat at root level.

## Naming conventions

- **Index notes**: aggregate related topics (e.g., `Ralph Wiggum Index.md`, `Skills Index.md`, `RAG Index.md`)
- **Title case** for all note names
- No folders for organization - use links and index notes instead

## Linking

- Use Obsidian `[[wikilinks]]` syntax for all internal links
- Links sem target específico (`[[Conceito]]`) são resolvidos pelo Obsidian automaticamente
- Links com path explícito (`[[pasta/arquivo]]`) para evitar ambiguidade em vaults com muitos arquivos

## O que é a Skill obsidian-vault

Esta skill é um template de instrução para agentes que precisam interagir com vaults Obsidian. Ela define o padrão operacional para:
- Buscar notas existentes antes de criar novas
- Criar notas com frontmatter adequado
- Atualizar notas existentes sem quebrar wikilinks
- Manter índices e notas de agregação atualizados

É distinta do vault-michel (o vault concreto) — é o protocolo genérico que pode ser aplicado a qualquer vault Obsidian.

## Protocolo de Operação

### Buscar Antes de Criar

O erro mais comum ao usar agentes com vaults é criar duplicatas. O protocolo:

```
1. Receber pedido de nota sobre "X"
2. Buscar no vault: find . -name "*x*" -o -name "*X*" (case-insensitive)
3. Se existe: atualizar a nota existente
4. Se não existe: criar nova nota com frontmatter correto
```

### Estrutura de Nota Padrão

```markdown
---
title: "Nome da Nota"
type: concept | entity | source | project | area
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [tag1, tag2]
---

# Nome da Nota

[Conteúdo principal]

## Links Relacionados
- [[NomeDaNotaRelacionada]]
- [[OutraNotaRelacionada]]
```

### Index Notes

Index notes são o mecanismo de navegação em vaults flat (sem pastas):

```markdown
# Skills Index

Todas as notas sobre skills de agentes:

## Por Categoria
- [[Skill diagnose]] — debugging disciplinado
- [[Skill grill-with-docs]] — stress-test de planos
- [[Skill design-an-interface]] — design it twice
- [[Skill obsidian-vault]] — gestão de vault (esta nota)
```

Index notes são atualizadas sempre que uma nova nota relevante é criada — o agente não deixa notas "soltas" sem referência em pelo menos um índice.

## Diferença entre Flat Vault e Vault com Pastas

A skill original foi projetada para um vault **flat** (sem subpastas) — toda nota na raiz, navegação apenas via links e índices. O vault-michel usa uma estrutura diferente: 9 pastas temáticas (`00-INBOX`, `01-PROJECTS`, etc.).

**Flat vault** (estilo da skill original):
- Mais simples de manter
- Busca por título direta
- Risco de colisão de nomes

**Vault com pastas** (estilo vault-michel):
- Organização visual clara
- Wikilinks precisam de path (`[[03-RESOURCES/concepts/X]]`)
- Mais robusto para vaults grandes (>1000 notas)

## Operações Comuns e Como Executar

### Criar uma nota de conceito

```bash
# 1. Verificar se já existe
find /vault -name "*nome-conceito*"

# 2. Criar com frontmatter
cat > /vault/concepts/NomeConceito.md << EOF
---
title: "Nome do Conceito"
type: concept
created: $(date +%Y-%m-%d)
---
# Nome do Conceito

[Definição e contexto]
EOF

# 3. Adicionar ao índice relevante
echo "- [[NomeConceito]] — descrição curta" >> /vault/concepts/Index.md
```

### Atualizar uma nota existente

Regra: nunca substituir conteúdo existente. Sempre adicionar seções ou expandir:

```
1. Ler a nota atual
2. Identificar onde adicionar o novo conteúdo
3. Inserir após o último parágrafo da seção relevante
4. Atualizar frontmatter: `updated: [data atual]`
```

### Reparar wikilinks quebrados

```bash
# Encontrar links para arquivos que não existem
grep -r "\[\[" /vault --include="*.md" | \
  grep -v "^Binary" | \
  awk -F'[[' '{for(i=2;i<=NF;i++) print $i}' | \
  awk -F']]' '{print $1}' | \
  sort | uniq | \
  while read link; do
    [ ! -f "/vault/$link.md" ] && echo "BROKEN: $link"
  done
```

## Integração com vault-michel

O vault-michel adapta esta skill com várias customizações:

| Aspecto | Skill Original | vault-michel |
|---------|---------------|-------------|
| Estrutura | Flat | 9 pastas temáticas |
| Naming | Title Case | kebab-case |
| Frontmatter | Mínimo | Completo (type, triagem_score, etc.) |
| Índices | Index notes | hot.md + wiki-index |
| Agente | Genérico | Nexus + especialistas |

As diferenças são documentadas em `04-SYSTEM/wiki/hot.md` e `CLAUDE.md` do vault — o agente deve preferir as convenções do vault sobre as convenções genéricas desta skill quando em conflito.

## Hot Cache (vault-michel específico)

Uma extensão crítica da skill obsidian-vault no vault-michel é o `hot.md` — um arquivo de cache quente que lista as notas mais recentemente acessadas ou modificadas. O agente o lê no início de cada sessão para restaurar contexto rapidamente sem varrer o vault inteiro.

```markdown
# Hot Cache — Notas Recentes
Última atualização: 2026-05-23

## Modificadas recentemente
- [[03-RESOURCES/sources/claude-code-skills/skill-obsidian-vault]] — expandida 2026-05-23
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — atualizada 2026-05-20

## Em progresso
- [[01-PROJECTS/projeto-alpha]] — revisão pendente
```

## Limitações da Skill Genérica

- Não tem lógica de resolução de conflitos de wikilinks (dois arquivos com o mesmo nome)
- Não cobre automação de ingestão (apenas criação/edição manual-like)
- Sem suporte a Obsidian Canvas, Dataview, ou plugins — apenas notas Markdown
- O vault path hardcoded (`/mnt/d/Obsidian Vault/AI Research/`) precisa ser customizado por usuário

## Origem

- Path: `clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741 4.md`
- Categoria: ai-agents
- Ingerido: 2026-05-09

## Cross-links

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[04-SYSTEM/wiki/hot]]
- [[04-SYSTEM/AGENTS]]
