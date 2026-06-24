---
title: "CEO da Obsidian Escreveu as Agent Skills Oficiais"
type: source
source_file: Clippings/Post by @dr_cintas on X.md
origin: post no X (@dr_cintas)
ingested: 2026-05-14
tags: [obsidian, agent-skills, claude-code, mcp, defuddle]
triagem_score: 8
---
# CEO da Obsidian Escreveu as Agent Skills Oficiais

> [!key-insight] Core point
> O CEO da Obsidian escreveu pessoalmente 5 Agent Skills oficiais para o próprio app — disponíveis em MIT, compatíveis com Claude Code, Codex CLI e OpenCode.

## Conteúdo

5 skills que corrigem cada camada onde agentes erram com Obsidian:

1. **obsidian-markdown** — wikilinks, callouts, embeds, frontmatter
2. **obsidian-bases** — visualizações de banco de dados com filtros, fórmulas, agregações
3. **json-canvas** — telas visuais vinculadas às notas
4. **obsidian-cli** — busca, criar, gerenciar tarefas do terminal
5. **defuddle** — markdown limpo de qualquer página web

- Licença MIT
- Funciona com Claude Code, Codex CLI, OpenCode
- Criadas pelo próprio CEO (não comunidade)

## Conexões

- [[03-RESOURCES/concepts/pkm-obsidian/obsidian-agent-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/entities/Hermes-Agent]]

---

## Por Que Isso é Significativo

O fato de o CEO da Obsidian ter escrito pessoalmente as agent skills oficiais — e não a comunidade — é sinal de que a integração com agentes de IA é feature de primeira classe, não afterthought. Kepano (Stephan Ango) normalmente delegaria skills de integração para contribuidores da comunidade; o fato de ter feito pessoalmente indica que as skills da comunidade não eram suficientemente precisas.

O repositório (`kepano/obsidian-skills` no GitHub, licença MIT) é a referência canônica para qualquer agente que precisa interagir com Obsidian de forma correta.

---

## O Problema que Cada Skill Resolve

### Por Que Agentes Erram com Obsidian Sem Skills

LLMs foram treinados em Markdown genérico (CommonMark, GitHub Flavored Markdown). Obsidian usa extensões proprietárias que LLMs frequentemente erram:

**Wikilinks:** `[[note]]` é Markdown proprietary do Obsidian. LLMs tendem a usar `[note](note.md)` (standard Markdown) ou `[note](./note)` — links que não funcionam no Obsidian.

**Callouts:** `> [!tip] Título` é específico do Obsidian. LLMs usam `> **tip:**` ou `> :bulb:` — que não renderizam como callouts coloridos.

**Frontmatter arrays:** `tags: [tag1, tag2]` vs. `tags:\n  - tag1\n  - tag2` — ambos são YAML válido mas Obsidian trata diferente em alguns contextos.

**Obsidian Bases:** Feature lançada em 2025, quase certamente ausente do training data. Agentes sem a skill simplesmente não sabem que o recurso existe.

---

## Análise de Cada Skill

### obsidian-markdown — A Mais Crítica
Corrige os erros mais frequentes. Sem ela, agentes criam:
- `[note](note.md)` em vez de `[[note]]`
- Frontmatter com tags inline em vez de lista YAML
- Blockquotes simples em vez de callouts estilizados
- Paths de embed incorretos (`![[path/to/image.png]]` vs. apenas `![[image.png]]`)

### obsidian-bases — Para Workflows de Banco de Dados
Essencial para quem usa Obsidian como second brain com views de banco de dados. Sem ela, agentes não conseguem criar, modificar, ou consultar databases.

### json-canvas — Para Mapas Visuais
JSON Canvas é formato aberto (jsoncanvas.org) mas específico. Criado pelo mesmo kepano. Skills ensina a estrutura: `{"nodes": [...], "edges": [...]}` com propriedades corretas para cada tipo de node.

### obsidian-cli — Para Automação de Terminal
Permite criar workflows de terminal que integram com o vault. `obsidian://open?vault=VaultName&file=NoteName` é o pattern principal.

### defuddle — Pré-processamento de Conteúdo Web
Especialmente útil antes de ingestão: converte HTML de web clipper em Markdown limpo, remove headers/footers de navegação, normaliza estrutura para processamento posterior.

---

## Adoção no Vault-Michel

O vault usa derivações destas skills via `claude-obsidian` plugin:
- `claude-obsidian:obsidian-markdown` — baseada em obsidian-markdown de kepano
- `claude-obsidian:obsidian-bases` — baseada em obsidian-bases de kepano
- `claude-obsidian:canvas` — baseada em json-canvas de kepano
- `claude-obsidian:defuddle` — baseada em defuddle de kepano

A skill `claude-obsidian:wiki-ingest` combina todos os outros e adiciona o workflow específico do vault (atualizar hot.md, criar cross-links, atualizar manifest).

---

## Extensibilidade

O repositório kepano/obsidian-skills segue o padrão que outras skills podem estender. Uma organização com vault Obsidian customizado pode:
1. Usar as 5 skills oficiais como base
2. Adicionar skills de domínio (ex: `company-conventions.md` com regras internas)
3. Combinar num CLAUDE.md que referencia todas

Este modelo permite customização sem forkar as skills base.

---

## Por Que Skills Oficiais Têm Vantagem de Longevidade

Skills da comunidade seguem o ciclo de vida do autor — se o mantenedor perde interesse, o skill fica desatualizado. Skills oficiais de kepano têm uma vantagem estrutural: o CEO tem incentivo permanente para manter as skills funcionando com versões atuais do Claude Code, porque afeta diretamente como o produto Obsidian é percebido em integrações com IA. Isso torna as 5 skills de kepano uma escolha mais segura a longo prazo do que equivalentes da comunidade com funcionalidade similar.

## Links Adicionais

- [[03-RESOURCES/sources/claude-code-skills/clipping-kepanoobsidian-skills-agent-skills-for-obsidian-teach-your-a]] — source clipping com detalhes técnicos
- [[03-RESOURCES/concepts/pkm-obsidian/obsidian-agent-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/entities/Obsidian]]
