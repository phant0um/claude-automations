---
title: "Building a Good Vertical Agent"
type: source
source: "[@BrainsAndTennis](https://x.com/BrainsAndTennis/status/2065190286519906657) — Shortcut (agente de spreadsheet)"
created: 2026-06-13
ingested: 2026-06-13
tags: [ai-agents]
---

## Tese central

"A good agent is a faithful compression of its task distribution." Com modelo fixo, acurácia = função da qualidade do contexto — contexto inchado enterra o sinal, contexto faltante força adivinhação.

## Argumentos principais

- **Context como cache em camadas (analogia CPU L1/L2/L3)**:
  - **L1 (always resident)**: os 80% do uso comum, vive no system prompt, instantâneo, mas custa tokens em toda task.
  - **L2 (on demand)**: specs em inglês curado, ~15% do uso, 1 passo de descoberta (`console.log(getXInfo())`) — custo zero até ser necessário.
  - **L3 (escape hatch)**: API tome bruto (70k linhas), nunca cabe no prompt, mas acessível via skill de ~100 linhas que ensina greps específicos (3-6 chamadas) para minerar o que precisar.
- **"Um tool, não trinta"**: toda capacidade roda sob um único `execute_code` — porque acurácia do modelo degrada com mais tools (mais schema, mais confusão, mais formas de escolher errado). O modelo escreve código; código chama funções; funções tocam o sistema.
- **L1 = engenharia desproporcional**: ler um range de 200 linhas não é só "ler" — é compressão ativa: (1) aliasing de fórmulas repetidas (500 fórmulas → 1 legenda + alias), (2) contexto de linha/coluna anexado de graça (headers detectados automaticamente), (3) compressão de estilo (células agrupadas por estilo idêntico). Diffs de escrita também são comprimidos e **categorizados** ("Changed without issues" vs "MUST FIX") — feedback loop = linter embutido nas próprias edições do agente.
- **L2 = specs prosa, não dumps de assinatura**: ensinam a receita canônica completa (ex: pivot table — ordem certa de chamadas, gotchas de runtime que só se aprende falhando).
- **L3 = skill que mapeia o tomo**: ~100 linhas ensinando greps por tipo de pergunta — agente nunca fica preso, sempre tem escape hatch limitado.
- **A hierarquia se move com a força do modelo**: o que é L1 hoje era L3 ontem — conforme modelos melhoram, L3 vira L2, L2 vira L1. A hierarquia em si nunca desaparece (contexto sempre escasso vs. tudo que poderia conter).

## Key insights

- "Everyone can build an agent — it isn't that hard, and isn't that deep either. What separates a good one from a toy is real understanding of your domain and patience for tedious work in the few places that matter."
- Codex/Claude Code ~30 tools, Pi 7 tools — divergência de 4x num ponto básico de design = sinal de que não há princípio acordado; este artigo propõe um.

## Implicações para o vault

Esta é provavelmente a fonte **mais aplicável diretamente** do cluster. O framework L1/L2/L3 é uma versão concreta e operacionalizável de [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]] e [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]] — mas com receita prática (specs em prosa para L2, skill-que-mapeia-tomo para L3). Aplicação ao SO do vault: `04-SYSTEM/AGENTS.md` + CLAUDE.md = L1 (always resident); `04-SYSTEM/skills/*.md` = L2 (carregados on-demand por trigger); referências completas (ex: schema completo do `.manifest.json`, listas completas de 40+ agentes) = L3, acessível via grep/Read explícito. A observação "1 tool, não 30" é argumento a favor de manter o MCP filesystem como interface única em vez de multiplicar tools especializadas. Conecta também com [[03-RESOURCES/concepts/agent-systems/skill-authoring]].

Este é o **1 framework imediatamente aplicável** do cluster geral — diferente dos artigos 1, 2, 4, 8, 9, 10 (confirmação) e dos artigos 5, 6 (ideias novas/research-stage). Conecta-se também a [[03-RESOURCES/sources/ai-agents-harness/latent-context-language-models-lclm]] via a reformulação "reasoning globally over compressed context, expand only what's needed".

## Links

- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]]
- [[03-RESOURCES/concepts/agent-systems/skill-authoring]]
