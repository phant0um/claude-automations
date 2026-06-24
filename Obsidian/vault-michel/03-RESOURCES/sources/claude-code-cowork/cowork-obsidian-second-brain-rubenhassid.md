---
title: Prompting Is the Worst Way to Use Claude — Cowork + Obsidian Setup
type: source
source_file: .raw/articles/cowork-obsidian-second-brain-rubenhassid-2026-04-16.md
author: Ruben Hassid (@rubenhassid)
date_ingested: 2026-04-16
tags: [claude-cowork, obsidian, second-brain, workflow, skills, markdown]
triagem_score: 7
---

# Prompting Is the Worst Way to Use Claude — Cowork + Obsidian

Newsletter de Ruben Hassid (@rubenhassid) com guia passo-a-passo do stack Cowork + Obsidian como Second Brain. Perspectiva de não-desenvolvedor — audiência: usuários de Claude que nunca editaram arquivos .md antes.

## Argumento central

Prompting ad hoc produz outputs mediocres porque você não tem como dar contexto completo (tom, audiência, regras, histórico) a cada sessão. Progressão de soluções:

1. **Prompt avulso** → sem memória, sem contexto
2. **Projects** → upload por tópico, reutilizável, mas ainda um projeto por tema
3. **Cowork** → pasta local; arquivos SÃO o prompt; Claude lê antes de cada sessão para sempre

> "Os arquivos são o prompt. Para sempre."

## Setup do Cowork (estrutura de pasta)

```
Claude Cowork/
├── about-me/
│   ├── about-me.md              # Quem você é, tom, gostos, regras
│   ├── anti-ai-writing-style.md # O que você odeia no output de AI
│   └── my-company.md            # Info do negócio
├── claude-output/               # Não tocar — Claude entrega aqui
└── templates/                   # Não tocar — templates salvos
```

Global Instructions (Settings > Cowork > Global Instructions): pedir para sempre ler `about-me/` e não tocar no resto.

## Por que Obsidian resolve o problema de UX do Cowork

**Problema:** arquivos .md abertos no TextEdit parecem código. Usuários param de editar. Contexto fica desatualizado.

**Solução:** Obsidian aponta para a pasta Cowork, renderiza tudo com formatação, permite edição inline. Obsidian nunca injeta metadata nem muda o formato dos .md — Cowork continua lendo normalmente.

### Workflow diário resultante:
- **Obsidian** = interface de edição do "cérebro" (contexto, regras, estilo)
- **Cowork** = motor de execução (outputs, entregáveis, documentos)

## Skills no Cowork

Para tarefas repetidas semanalmente, Skills eliminam o re-prompting:
- Um arquivo .md por skill, chamado com `/comando`
- Skills ficam visíveis e editáveis no Obsidian
- Workflow de criação: prompt Cowork → entrevista → geração automática → mover para `SKILLS/` no Obsidian

## Comparativo de ferramentas de markdown

| Ferramenta | Problema fatal para esse uso |
|---|---|
| Notion | Cloud-based; import/re-import constante |
| Google Docs | Formato ≠ .md; conversão constante |
| Apple Notes | Formato fechado; não abre pastas |
| VS Code / Cursor | Interface de dev; terminal assumed |
| GitHub | git, commits, pushes — barreira técnica |
| Typora | $15; um arquivo por vez; sem busca cross-file |
| MarkEdit | Mac only; mesmo problema do Typora |
| **Obsidian** | ✓ Gratuito; ✓ local; ✓ busca full-text; ✓ não quebra Cowork |

## Detalhe sobre Obsidian

CEO Steph Ango: sem analytics, sem contas forçadas. Filosofia local-first radical. Gratuito para single-device; $4/mês para sincronização multi-device.

## Conexões com o vault

> [!key-insight] Este artigo valida o padrão já documentado
> Este vault usa exatamente o stack descrito: claude-obsidian plugin + Obsidian apontando para a pasta do vault. O que Ruben descreve como "descoberta acidental" é o [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]] documentado por Karpathy. A progressão Prompt → Projects → Cowork mapeia diretamente para [[03-RESOURCES/concepts/pkm-obsidian/second-brain]].

## Por que "arquivos SÃO o prompt" é o insight central

A maioria dos usuários de AI pensa em prompting como escrita — você redige uma instrução boa toda vez que precisa de um resultado bom. Ruben Hassid identifica o problema estrutural: isso não escala. Cada sessão começa do zero. Você re-explica quem é, qual é seu tom, quais são as regras.

A solução do Cowork inverte a relação: o contexto não está na mensagem — está em arquivos que o Claude lê antes de cada sessão. Você edita os arquivos uma vez. O Claude os lê para sempre. A "prompting" passa de transacional (escreve toda vez) para declarativa (escreve uma vez, dura para sempre).

Isso tem um nome técnico: **fat context** — a prática de enriquecer o contexto do agente com informação estável e persistente. `about-me.md`, `anti-ai-writing-style.md`, `my-company.md` são fat context. Skills são fat context processual.

## O problema da interface resolvido pelo Obsidian

O artigo identifica um problema de UX que destrói o stack para não-desenvolvedores: arquivos `.md` abertos em aplicativos genéricos (TextEdit, Notepad) parecem código-fonte. A reação natural é evitar editar. Quando o usuário para de editar os arquivos de contexto, o sistema perde o valor — o Claude passa a operar com informação desatualizada.

Obsidian resolve isso com renderização em tempo real: você edita e vê texto formatado, não sintaxe Markdown. O efeito psicológico é real: usuários editam arquivos que parecem documentos, não arquivos que parecem código.

O detalhe técnico relevante: Obsidian opera na pasta de arquivos sem modificar o formato `.md`. Não há risco de incompatibilidade — o Cowork lê exatamente o mesmo arquivo que o Obsidian renderiza.

## Skills no Cowork — workflow de criação

O artigo descreve o ciclo de vida de uma skill:

1. **Identificar padrão repetido**: tarefa que você pede mais de 2 vezes por semana
2. **Executar no Cowork**: deixar o Claude fazer a tarefa normalmente, observar
3. **Solicitar geração do skill**: "Com base no que acabamos de fazer, crie um skill.md para esta tarefa"
4. **Entrevista automática**: o Cowork entrevista você sobre variações, edge cases, formato de output
5. **Salvar em `/SKILLS/`**: visível e editável no Obsidian

O resultado: da 3ª execução em diante, `/nome-do-skill` reproduz o mesmo workflow sem re-explicar nada. Compounding de investimento em prompting.

## Cowork vs Claude Code — para quem não é dev

Ruben Hassid é explícito sobre o público do artigo: "nunca editou arquivos .md antes". Isso é a mesma audiência que o Claude Code perde — o Claude Code assume familiaridade com terminal, git, e estrutura de projetos.

O Cowork + Obsidian é o stack equivalente para knowledge workers: pasta local substituindo repositório git, Obsidian substituindo VS Code, Skills substituindo scripts. Menos poderoso que Claude Code em automação técnica, mas acessível sem barreira técnica.

Para este vault, o stack é mais próximo do Claude Code (usa claude-obsidian plugin + terminal) porque o usuário tem background técnico. O artigo é relevante como perspectiva de design UX para não-devs, não como receita a seguir.

## Por que Obsidian ganhou o comparativo de ferramentas

O comparativo de 7 ferramentas não é apenas técnico — é sobre fricção cognitiva. Notion (cloud), Google Docs (formato fechado), Apple Notes (sem busca cross-file), VS Code (interface dev), GitHub (git overhead), Typora ($15, arquivo por vez), MarkEdit (Mac only) — cada uma tem uma barreira que no dia a dia faz o usuário desistir de editar.

Obsidian elimina todas as barreiras:
- **Local-first**: sem login, sem cloud, sem dependência de internet
- **Gratuito single-device**: sem fricção financeira para começar
- **Busca full-text**: encontrar qualquer arquivo em segundos
- **Graph view**: visualizar conexões entre notas
- **Não modifica formato**: transparente para o Cowork

O ponto de Steph Ango (CEO Obsidian): "sem analytics, sem contas forçadas" — filosofia local-first radical que se alinha diretamente com o uso como interface para arquivos de AI.

## Links internos

- [[03-RESOURCES/entities/Claude-Cowork]] — produto central deste guia
- [[03-RESOURCES/entities/Obsidian]] — ferramenta de interface para o Cowork
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] — conceito que o stack implementa
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — Skills mencionadas no artigo
- [[03-RESOURCES/entities/Ruben-Hassid]] — autor
- [[03-RESOURCES/entities/Steph-Ango]] — CEO do Obsidian
