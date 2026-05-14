---
title: Prompting Is the Worst Way to Use Claude — Cowork + Obsidian Setup
type: source
source_file: .raw/articles/cowork-obsidian-second-brain-rubenhassid-2026-04-16.md
author: Ruben Hassid (@rubenhassid)
date_ingested: 2026-04-16
tags: [claude-cowork, obsidian, second-brain, workflow, skills, markdown]
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
> Este vault usa exatamente o stack descrito: claude-obsidian plugin + Obsidian apontando para a pasta do vault. O que Ruben descreve como "descoberta acidental" é o [[03-RESOURCES/concepts/llm-wiki-pattern]] documentado por Karpathy. A progressão Prompt → Projects → Cowork mapeia diretamente para [[03-RESOURCES/concepts/second-brain]].

## Links internos

- [[03-RESOURCES/entities/Claude-Cowork]] — produto central deste guia
- [[03-RESOURCES/entities/Obsidian]] — ferramenta de interface para o Cowork
- [[03-RESOURCES/concepts/second-brain]] — conceito que o stack implementa
- [[03-RESOURCES/concepts/claude-skills]] — Skills mencionadas no artigo
- [[03-RESOURCES/entities/Ruben-Hassid]] — autor
- [[03-RESOURCES/entities/Steph-Ango]] — CEO do Obsidian
