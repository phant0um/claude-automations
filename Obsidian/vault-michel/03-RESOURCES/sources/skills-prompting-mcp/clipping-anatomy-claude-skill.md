---
title: "The Anatomy of a Claude Skill — 40-Line Markdown File Replaces a $1,200/Month Contractor"
type: source
source: "Clippings/The Anatomy of a Claude Skill How a 40-Line Markdown File Replaces a $1,200Month Contractor.md"
author: "@heynavtoor"
published: 2026-05-22
created: 2026-05-23
ingested: 2026-05-23
tags: [ai-agents, clippings, claude-code, skills, prompting]
---

## Tese central

Um prompt diz ao modelo o que fazer uma vez. Uma skill diz como você faz as coisas — toda vez, em toda sessão, em toda máquina, para sempre. Skills são memória procedural legível. O problema não é o modelo; é tudo ao redor do modelo.

## Argumentos principais

- **Portabilidade vs prompts**: prompts morrem quando você troca de máquina ou de sessão. Skills persistem — job description vs frase única.
- **Custo**: teams pagam $400–$1200/mês por contractors que fazem menos do que um arquivo markdown de 40 linhas. Skill = contratação mais barata que você vai fazer.
- **Ecossistema**: Anthropic shipou Skills em early 2026. Comunidade shipou 600+ nos 90 dias seguintes. Lobehub tem 500+ community skills. 16 skills oficiais no marketplace.
- **Skills são o primitive mais sub-explicado de todo o Claude stack**.

## Key insights — 6 componentes de uma skill de produção

1. **Frontmatter** — 3 linhas: name, description, trigger phrase. Modelo lê frontmatter primeiro quando scanneia library. Description vaga = skill nunca carregada. Trigger precisa = skill chamada no job certo.

2. **Trigger** — sinal que diz "use esta skill agora". Pode ser palavra, tipo de arquivo, padrão de tarefa. "Quando usuário pedir rascunho de tweet" bate "para social media tasks". Diferença entre skill que dispara e skill que dorme.

3. **Instructions** — body da skill: voice, regras, formato, do-nots. É onde seu gosto vive. Júnior escreve 50 linhas. Sênior escreve 10 afiadas. Cada linha cortada = token economizado em cada chamada.

4. **References** — sub-arquivos que skill puxa sob demanda: style guide, glossário, lista de clientes. Skill fica pequena; referências dão profundidade. Claude carrega só o que precisa.

5. **Examples** — casos que mostram ao modelo o que "bom" parece. Mais importante que explanações longas. 3 bons exemplos valem mais que 10 parágrafos de instruções.

6. **Metadata** — version, author, last_updated. Skills precisam de manutenção. Sem metadata, você não sabe o que está rodando em produção.

## Exemplos e evidências

```markdown
---
name: tweet-writer
description: Write punchy, high-engagement tweets for tech founders. Trigger when user asks for tweet, thread, or X post.
triggers: [tweet, thread, X post, twitter]
---

## Voice
Direct. No filler. First line is the hook. No hashtags unless asked.

## Format
- Single tweet: ≤ 280 chars
- Thread: 3-7 tweets, numbered
- No em-dashes. No "Excited to share".

## References
@brand-voice.md
@client-list.md
```

**Regra do senior**: cada linha de instrução que você corta = token economizado em toda call futura. Skills de produção são afiadas, não extensas.

## Implicações para o vault

- Confirma design do sistema de skills do vault (em `04-SYSTEM/skills/`) — mesmos 6 componentes estão presentes nas skills do vault
- Conecta com [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] — skills são o veículo de compounding de workflow
- Referência para auditar skills existentes: todas têm os 6 componentes? Description é afiada o suficiente para o modelo carregar no contexto certo?

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[03-RESOURCES/entities/Anthropic]]
