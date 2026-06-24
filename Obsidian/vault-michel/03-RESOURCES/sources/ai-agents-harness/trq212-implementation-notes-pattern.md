---
title: "@trq212 — Implementation Notes Pattern"
type: source
category: dev/coding-pattern
author: "@trq212"
source_url: "https://threadreaderapp.com/thread/2056415973125796184.html"
published: 2026-05-18
ingested: 2026-05-18
tags: [source, dev, coding-pattern, prompt-engineering, spec, implementation-notes]
triagem_score: 8
---

# @trq212 — Implementation Notes Pattern

## Tese central

Ao implementar qualquer spec, instrua o modelo a manter um arquivo `implementation-notes.html` (ou `.md`) paralelo que registra decisões tomadas onde a spec era ambígua, desvios intencionais, tradeoffs considerados, e perguntas em aberto — reduzindo surpresas e mantendo o humano no loop sem precisar microgerenciar.

## Key insights

**O prompt canônico (versão refinada com Claude):**

> Implement `<SPEC>`. As you work maintain a running `implementation-notes.html` file that captures anything I should know about how the implementation diverges from or interprets the spec, including:
> - **Design decisions:** choices you made where the spec was ambiguous
> - **Deviations:** places where you intentionally departed from the spec, and why
> - **Tradeoffs:** alternatives you considered and why you picked what you did
> - **Open questions:** anything you'd want me to confirm or revise

**Por que funciona:**
- Toda spec tem ambiguidades e unknown unknowns — o modelo precisa tomar decisões em tempo de execução
- Sem o arquivo de notas, essas decisões ficam invisíveis; o humano recebe código mas não o raciocínio
- Com o arquivo, o modelo tem um "out" legítimo para decidir autonomamente e ainda manter o operador informado
- Reduz revisões posteriores: erros de interpretação ficam evidentes antes de virar dívida técnica

**Variação:** usar `.html` em vez de `.md` porque HTML suporta estrutura rica sem render overhead (alinha com filosofia [[03-RESOURCES/entities/trq212-tariq|@trq212]] de HTML-first para artefatos Claude Code).

## Links

- [[03-RESOURCES/entities/trq212-tariq]] — autor, eng Claude Code na Anthropic
- [[03-RESOURCES/concepts/claude-code-tooling/anatomy-claude-prompt]] — estrutura de prompts eficazes
- [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]] — padrão de especificação para agentes

---

## Mecanismo: por que o arquivo de notas funciona

Toda spec tem dois tipos de lacunas: **ambiguidades explícitas** (o spec diz "suporte a múltiplos formatos" sem definir quais) e **unknown unknowns** (casos de borda que nem o autor da spec previu). O modelo, ao implementar, encontra ambos constantemente e precisa tomar decisões.

Sem o arquivo de notas, o modelo toma essas decisões silenciosamente. O humano recebe o código, não o raciocínio. Quando algo não está como esperado, começa uma sessão de arqueologia: "por que o modelo fez X quando eu esperava Y?" — frequentemente irreconstrituível sem ver o histórico da sessão.

Com o arquivo de notas, o modelo tem um canal legítimo para documentar decisões em tempo real. Mais importante: **ter o canal muda o comportamento do modelo**. Em vez de "decidir e seguir em frente", o modelo adota um modo de "decidir, documentar, e sinalizara para revisão". O arquivo cria accountability estrutural sem exigir microgerenciamento.

## O formato HTML: por que faz diferença

A recomendação de `.html` em vez de `.md` não é estética. HTML suporta:

- **Estrutura semântica sem render overhead:** `<section>`, `<details>`, `<summary>` criam hierarquia navegável que Markdown plano não consegue sem plugins
- **Notas colapsáveis:** `<details><summary>Design decision: formato de data</summary>...</details>` permite escanear rapidamente sem ler cada detalhe
- **Timestamps inline:** `<time datetime="2026-05-18">` sem dependência de render de metadata
- **Links internos:** âncoras HTML permitem navegar entre seções de um arquivo grande sem Markdown extensions

No Claude Code especificamente, artefatos HTML são renderizados diretamente no painel de output — o desenvolvedor vê uma página estruturada, não texto bruto.

## Variações do padrão

**Variação minimalista** — para tarefas menores:
```
Implement <SPEC>. Maintain implementation-notes.md with: decisions made where spec was ambiguous, and open questions.
```

**Variação estrita** — para projetos críticos:
```
Implement <SPEC>. Before writing any code, identify all ambiguities and write them to implementation-notes.html under "Pre-Implementation Questions". Get confirmation on critical ambiguities before proceeding. Document all decisions as you implement.
```

**Variação auditável** — para compliance:
```
Implement <SPEC>. Maintain implementation-notes.html with timestamps for each decision. Each entry must include: the ambiguity encountered, the options considered, the choice made, and the rationale. This document will be reviewed as part of the code review process.
```

## Integração com spec-kit

O padrão de implementation notes é complementar ao `/speckit.analyze` do [[03-RESOURCES/sources/open-source-ecosystems/spec-kit-github-official-readme|spec-kit]]. Enquanto `analyze` verifica consistência *entre* artefatos antes da implementação, `implementation-notes` captura inconsistências *descobertas durante* a implementação.

Os dois juntos formam um ciclo completo:
1. `analyze` — previne problemas conhecíveis antes do código
2. `implementation-notes` — captura o que só se descobre ao implementar
3. Human review do `implementation-notes` — fecha o loop informacional

## Aplicação no vault-michel

O padrão mapeia diretamente para o workflow de ingestão do vault. Quando `wiki-ingest` processa uma fonte complexa (múltiplas entidades, links ambíguos, categorização incerta), o agente poderia manter um arquivo de "ingest-notes.md" documentando:

- Por que um conceito foi classificado como `concept` e não `entity`
- Que links foram adicionados por inferência e não estavam na fonte original
- Perguntas abertas sobre se uma entidade já existe com nome diferente

Atualmente, essas decisões são tomadas silenciosamente. Implementar o padrão reduziria revisões pós-ingestão.

## Comparação com padrões relacionados

| Padrão | Timing | Audiência | Output |
|---|---|---|---|
| Implementation Notes | Durante implementação | Operador/revisor | Decisões e desvios documentados |
| Code Comments | Durante implementação | Próximo desenvolvedor | Contexto técnico no código |
| Commit messages | Pós-implementação | Histórico git | O que mudou e por quê |
| PR description | Pós-implementação | Revisor de PR | Resumo da mudança |
| AGENTS.md | Pré-implementação | Agente executor | Instruções e restrições |

Implementation Notes complementa todos os outros — captura o "como foi decidido" que nenhum dos outros registra.

## Limitações

- **Overhead de tokens:** manter o arquivo de notas em paralelo aumenta o consumo de tokens da sessão em ~10–20% dependendo do tamanho da spec
- **Qualidade variável:** o modelo pode gerar notas superficiais ("escolhi int porque parecia adequado") sem estrutura que force profundidade; o prompt canônico precisa ser suficientemente específico
- **Não substitui revisão humana:** o arquivo captura o raciocínio do modelo, não valida se o raciocínio estava correto; perguntas abertas ainda precisam de resposta humana
- **Vida útil:** o arquivo é útil durante a implementação e na revisão inicial; depois disso, o conteúdo mais valioso deve migrar para decisões de arquitetura documentadas formalmente
