---
title: "How to Build an Obsidian Dashboard That Shows You Everything That Matters Today"
type: source
source: Clippings/How to Build an Obsidian Dashboard That Shows You Everything That Matters Today.md
source_type: clipping
created: 2026-05-19
ingested: 2026-05-19
triagem_score: 7
triagem_cat: obsidian
tags: [clipping, obsidian]
---

## Tese central

cyrilXBT: Bases + Dataview para dashboard Obsidian — relevante para vault

## Key insights

- Seção: The Core Principle: Read Not Store
- Seção: What the Dashboard Shows
- Seção: The Technical Foundation

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]

## Fonte

Arquivo original: `Clippings/How to Build an Obsidian Dashboard That Shows You Everything That Matters Today.md`

---

## Princípio Core: Read Not Store

O insight mais importante deste artigo é a inversão do paradigma típico de PKM: em vez de armazenar tudo e tentar encontrar depois, o dashboard privilegia o que precisa ser lido hoje. A pergunta não é "onde está essa nota?" mas "o que devo ver agora?".

Isso resolve o problema de "cemitério de notas" — vaults com milhares de arquivos onde nada é consumido porque não há mecanismo de surfacing. O dashboard funciona como um curador diário automático que agrega o que importa sem exigir busca manual.

**Contraste com abordagens tradicionais:**
- Pasta aninhada → difícil navegar, fácil esquecer
- Tags → uteis para filtro mas não criam superfície temporal
- Busca → pull ativo, exige que o usuário já saiba o que quer
- Dashboard Dataview → push passivo, entrega o que é relevante sem ação

---

## Fundação Técnica: Bases + Dataview

### Obsidian Bases

Bases é o sistema de database nativo do Obsidian que trata notas como registros estruturados. Cada nota com frontmatter YAML pode ser consultada como uma tabela: filtre por `type`, `created`, `due`, `status`, ou qualquer campo customizado.

Diferente do Dataview (plugin de terceiros), Bases é nativo e renderiza em tempo real sem compilar JavaScript. Para um dashboard que carrega na abertura do vault, Bases é mais performático.

### Dataview

Dataview permite consultas DQL (Dataview Query Language) inline nas notas. Um bloco `dataview` funciona como uma query SQL sobre os metadados do vault:

```dataview
TABLE title, created, tags
FROM "03-RESOURCES/sources"
WHERE contains(tags, "clipping")
SORT created DESC
LIMIT 10
```

Para o dashboard "o que importa hoje", as queries mais úteis são:
- Notas criadas/atualizadas hoje
- Tarefas com due date = today
- Projetos com status = active
- Sources não-processadas (sem tag `ingested`)

---

## O Que o Dashboard Mostra

Um dashboard eficiente para "tudo que importa hoje" tipicamente inclui:

**1. Agenda do dia** — tasks com `due:: today` ou `scheduled:: today`, puxadas de qualquer nota do vault. Elimina a necessidade de app separado para to-do.

**2. Inbox de capturas brutas** — notas em `00-INBOX/` ainda não processadas. Surfacing diário previne acúmulo e garante que capturas virem conhecimento ativo.

**3. Projetos ativos** — notas em `01-PROJECTS/` com `status:: active`, ordenadas por `updated`. O que ficou parado há mais tempo fica visível sem busca ativa.

**4. Feed recente de sources** — últimas 5-10 notas em `03-RESOURCES/sources/` por data de criação. Mantém contexto das leituras recentes sem ter que navegar a pasta.

**5. Daily note do dia** — link direto para `05-DAILY/{{date}}.md` via template Templater. Um clique e a nota do dia está pronta.

---

## Implementação no Vault-Michel

Para este vault, um dashboard em `04-SYSTEM/wiki/hot.md` ou como nota separada `00-INBOX/dashboard.md` pode agregar:

```dataview
TABLE title, triagem_score
FROM "03-RESOURCES/sources"
WHERE triagem_score >= 8
SORT created DESC
LIMIT 5
```

```dataview
TASK
FROM "01-PROJECTS"
WHERE !completed AND due <= date(today)
```

```dataview
LIST
FROM "00-INBOX"
SORT file.mtime DESC
LIMIT 10
```

A combinação dessas três queries cobre: conhecimento de alta prioridade a processar, tarefas vencidas, e capturas brutas esperando processamento.

---

## Limitações e Tradeoffs

**Performance:** vaults grandes (>5.000 notas) com múltiplos blocos Dataview pesados na nota principal podem introduzir lag na abertura. Mitigação: usar `LIMIT` em todas as queries, evitar `FROM ""` (varre tudo), preferir queries em pastas específicas.

**Manutenção:** o dashboard só é tão bom quanto a disciplina de frontmatter. Se notas não têm `due`, `status`, ou `type` consistentes, as queries retornam resultados incorretos ou vazios.

**Bases vs Dataview:** Bases ainda não suporta todas as operações que Dataview permite (especialmente TASK queries). Para um dashboard completo, provavelmente ambos são necessários — Bases para visualizações de tabela de notas, Dataview para tasks e queries complexas.

**Alternativa sem plugins:** para quem quer evitar dependência de Dataview (plugin de terceiro), um dashboard manual com links explícitos `[[nota]]` e atualização via hook ou script externo é mais robusto a longo prazo, mas exige mais manutenção humana ou automação externa.

---

## Relevância para o Vault-Michel

O padrão de "surfacing inteligente" descrito aqui complementa o `04-SYSTEM/wiki/hot.md` atual, que funciona como cache de contexto para agentes. Um dashboard Dataview focado no operador humano (Michel) resolve o problema complementar: não o que o agente precisa saber, mas o que o humano precisa ver ao abrir o vault de manhã.

A combinação ideal é: `hot.md` para agentes, dashboard Dataview para humano — separação clara de audiência.
