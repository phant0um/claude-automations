---
title: "How to Connect Obsidian + Hermes: Turn 1,400 Notes Into an Autonomous System"
type: source
category: ai-agents
score: A
author: "@zeuuss_01"
source_url: "https://x.com/zeuuss_01/status/2062636077123330347"
published: 2026-06-04
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, obsidian, hermes, pkm-obsidian, vault-workflow, self-writing-vault]
---

# How to Connect Obsidian + Hermes: Turn 1,400 Notes Into an Autonomous System

> 1 command. Under $20/mo. 23 skills. 0 hours of manual upkeep.

## Tese central

O gargalo do PKM nunca foi captura — foi **ativação**. Um vault de 1.400 notas acumula mais conexões do que qualquer humano consegue manter manualmente. Quando a camada de ativação roda em agente por <$20/mês, disciplina deixa de ser o fosso e vira o gargalo. O Hermes Agent wired no Obsidian transforma o vault de repositório passivo em parceiro de pesquisa autônomo.

## Argumentos principais

1. **Discipline Trap**: cada nota adicionada aumenta o custo de manutenção enquanto a memória de trabalho humana permanece constante. Vaults estancam por peso, não por falta de captura.
2. **Setup é trivial**: Obsidian usa markdown plano; Hermes tem provider Obsidian nativo. Um comando instala a memória layer. O plugin **Obsidian Local REST API** dá ao agente acesso live read/write durante execução (não só no boot).
3. **Loop de 4 estágios**: quando algo entra no vault, não espera em fila manual — flui por 4 etapas onde o humano toca apenas 2.
4. **Skills como time com funções fixas**: workflows executados mais de 2× viram skill file. O agente nunca re-descobre a mesma solução; a biblioteca vai de zero a dúzias em semanas.
5. **Duplo compounding**: Obsidian acumula links ao longo de meses (nota de janeiro conecta a março, abril, maio); Hermes acumula skills a cada sessão. A interação potencializa ambos.

## Key insights

- **SOUL.md é a lente, não personalidade**: sem ele, suas notas são biblioteca de conteúdo; com ele, o agente lê como sua operação. Três elementos obrigatórios: obsessões atuais (perguntas específicas que você está mastigando *agora*), como quer ser desafiado (ex: "surfaça contradições entre o que acredito hoje vs. o que salvei 6 semanas atrás"), e o que nunca quer (recaps genéricos, bajulação, padding).
- **Compounding em 90 dias**: semana 1 = conexão + brief mínimo; 30 dias = 10+ skills, vault auto-linking; 90 dias = rede densa, upkeep tendendo a zero.
- **Limites honestos**: sínteses realmente difíceis ou lógica security-sensitive → modelo premium (regra: se resposta errada custa >100× a diferença de preço, use o caro). Julgamento profundo, gosto e decisão sobre o que importa permanecem humanos. Volume de output é inimigo, não meta — tunar briefs para menos e mais afiado.

## Exemplos e evidências

- 1.400 notas no vault do autor → vault "leu cada palavra que eu escrevi" em 3 semanas
- 0 horas de manutenção manual semanal
- Skill library: 0→23 em 6 semanas
- Custo: <$20/mês

## Implicações para o vault-michel

Este vault **já implementa** a maioria dos padrões descritos:
- Hermes wired via MCP Obsidian (Local REST API equivalente)
- SOUL.md equivalente: Nexus SOUL.md block (identity + obsessões + voice + manias) — [[04-SYSTEM/AGENTS.md]]
- Skills reusáveis: `04-SYSTEM/skills/` com 20+ skills; auto-escrita via `/evolve`
- Pipeline diário automatizado (launchd 16h): [[04-SYSTEM/wiki/controle-pipeline]]
- Compounding já visível: [[03-RESOURCES/concepts/agent-systems/compound-engineering]]

**Gap potencial identificado**: o loop de 4 estágios do Hermes (com 2 pontos de toque humano) é mais explícito que o pipeline atual. Considerar documentar os pontos de toque humano no vault como ADR.

**Gap SOUL.md**: a seção `Identity` do `CLAUDE.md` cobre parcialmente o conceito SOUL.md, mas falta componente explícito de "obsessões atuais" e "como desafiar" — observação registrada, sem criação de arquivo.

## Links

- Entidade: [[03-RESOURCES/entities/hermes]]
- Conceito: [[03-RESOURCES/concepts/pkm-obsidian/self-writing-vault]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/compound-engineering]]
- Conceito: [[03-RESOURCES/concepts/pkm-obsidian/obsidian-agent-skills]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]
- Vault atual: [[04-SYSTEM/AGENTS.md]]
