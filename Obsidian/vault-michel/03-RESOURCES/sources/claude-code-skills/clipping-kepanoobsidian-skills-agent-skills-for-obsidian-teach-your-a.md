---
title: "kepanoobsidian-skills Agent skills for Obsidian. Teach your agent to use Markdow"
type: source
source: clipping
created: 2026-05-01
updated: 2026-05-01
tags: [clipping, ai-agents, tools]
triagem_score: 8
---

# kepanoobsidian-skills Agent skills for Obsidian. Teach your agent to use Markdow

**Source File:** kepanoobsidian-skills Agent skills for Obsidian. Teach your agent to use Markdown, Bases, JSON Canvas, and use the CLI..md  
**Size:** 3091 bytes

## Summary

--- title: "kepano/obsidian-skills: Agent skills for Obsidian. Teach your agent to use Markdown, Bases, JSON Canvas, and use the CLI." source: "https://github.com/kepano/obsidian-skills" author: published: created: 2026-05-01 description: "Agent skills for Obsidian. Teach your agent to use Markdown, Bases, JSON Canvas, and use the CLI. - kepano/obsidian-skills" tags: - "clippings" --- Agent Skil

---

**Original Location:** `Clippings/kepanoobsidian-skills Agent skills for Obsidian. Teach your agent to use Markdown, Bases, JSON Canvas, and use the CLI..md`

---

## Contexto: Kepano é o CEO da Obsidian

Stephan Ango (kepano) é o CEO e co-criador da Obsidian. O repositório `kepano/obsidian-skills` representa as skills *oficiais* — projetadas pelo próprio criador do app para corrigir as formas específicas como agentes erram ao interagir com Obsidian.

O repositório (licença MIT) funciona com Claude Code, Codex CLI, OpenCode, e qualquer agente que suporte agent skills (arquivos Markdown de instrução).

---

## As 5 Skills Oficiais

### 1. obsidian-markdown
Ensina o agente a usar a sintaxe Markdown específica do Obsidian:

- **Wikilinks:** `[[note-name]]` vs `[[note-name|display text]]` vs `[[note-name#heading]]`
- **Callouts:** `> [!tip]`, `> [!warning]`, `> [!note]` — agentes frequentemente usam blockquotes simples quando callouts são mais apropriados
- **Embeds:** `![[note-name]]` para embutir conteúdo de outras notas
- **Frontmatter YAML:** campos `title`, `tags`, `created`, `aliases` — formato correto com colchetes vs. lista com hífens
- **Tags:** `#tag` inline vs. `tags: [tag1, tag2]` no frontmatter

**Por que é necessária:** LLMs foram treinados em Markdown genérico, não em Obsidian-flavored Markdown. Sem esta skill, agentes criam links quebrados, frontmatter inválido, e callouts mal formatados.

### 2. obsidian-bases
Ensina a usar Obsidian Bases — o sistema de banco de dados embutido no Obsidian (lançado 2025):

- Criar views de banco de dados com filtros em notas
- Sintaxe de fórmulas para campos calculados
- Aggregações (count, sum, average) em coleções de notas
- Filtros por frontmatter fields, tags, e propriedades

**Por que é necessária:** Obsidian Bases é feature relativamente nova, provavelmente ausente do training data dos LLMs. Sem esta skill, agentes não sabem criar ou modificar views de banco de dados.

### 3. json-canvas
Ensina a criar e editar JSON Canvas — o formato de telas visuais do Obsidian:

- Estrutura JSON do formato: nodes (text, file, group, link) e edges (conexões)
- Como criar telas vinculadas a notas existentes
- Posicionamento e dimensionamento de nodes
- Conexões entre nodes com labels

**Por que é necessária:** JSON Canvas é formato proprietário do Obsidian. Sem instrução explícita, agentes tentam criar Markdown e não entendem o formato JSON.

### 4. obsidian-cli
Ensina a usar a CLI do Obsidian para operações do terminal:

- `obsidian://open?vault=X&file=Y` — abrir notas diretamente
- Buscar notas via URI scheme
- Criar notas via linha de comando
- Gerenciar tarefas (checklist items) via terminal

**Por que é necessária:** A CLI do Obsidian usa URI schemes específicos, não comandos de shell padrão. Agentes tentam usar `cat`, `ls`, e `mkdir` quando deveriam usar URIs.

### 5. defuddle
Skill para limpar e processar Markdown de qualquer página web:

- Remove boilerplate HTML convertido para Markdown
- Preserva estrutura semântica (headings, listas, código)
- Normaliza links para formato wikilink quando possível
- Limpa frontmatter gerado por web clippers (Readwise, Omnivore)

**Por que é necessária:** Web clippers geram Markdown sujo com muito ruído. Defuddle limpa automaticamente antes de processar.

---

## Como Instalar

```bash
# Clonar o repositório
git clone https://github.com/kepano/obsidian-skills

# Copiar skills para o projeto
cp obsidian-skills/*.md .claude/skills/

# Ou referenciar no CLAUDE.md
# @.claude/skills/obsidian-markdown.md
```

As skills são detectadas automaticamente por Claude Code quando presentes no diretório de skills do projeto.

---

## Diferença em Relação a Skills da Comunidade

Skills oficiais têm vantagens sobre skills criadas pela comunidade:
- Mantidas pelo criador do app — acompanham mudanças de features
- Baseadas em bugs reais reportados por usuários Obsidian
- Testadas com Claude Code, Codex CLI e OpenCode
- Documentação in-skill é precisa (não baseada em suposições)

---

## Aplicação no Vault-Michel

O vault-michel usa versão adaptada destas skills integrada ao sistema de skills do Claude Code. A skill `claude-obsidian:obsidian-markdown` e `claude-obsidian:obsidian-bases` são derivadas do repositório kepano.

O skill `defuddle` é especialmente relevante para o workflow de ingestão: antes de processar qualquer clipping do Readwise, rodar defuddle remove ruído e melhora qualidade da ingestão.

---

## Conexões

- [[03-RESOURCES/sources/pkm-obsidian-second-brain/post-dr-cintas-obsidian-agent-skills]] — post sobre este mesmo repositório
- [[03-RESOURCES/concepts/pkm-obsidian/obsidian-agent-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/entities/Obsidian]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — skills como "fat skills" no modelo thin harness / fat skills do Garry Tan
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/i-connected-claude-obsidian-vault-damidefi]] — caso prático Claude+Obsidian; skills kepano habilitam o Layer 3 (Memory) daquele sistema
