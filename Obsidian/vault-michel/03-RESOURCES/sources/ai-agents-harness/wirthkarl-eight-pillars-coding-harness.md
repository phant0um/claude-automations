---
title: "Building the harness around our coding agents: eight failure modes, eight pillars"
type: source
source: "Clippings/Building the harness around our coding agents eight failure modes, eight pillars.md"
author: "@wirthkarl"
origin: "https://x.com/wirthkarl/status/2059270673730580732"
created: 2026-05-26
ingested: 2026-05-28
tags: [ai-agents, source, harness, coding-agents, eight-pillars, nimbalyst, failure-modes]
---

## Tese central

Equipes que constroem com IA acabam construindo dois produtos: o produto que entregam e o sistema ao redor de seus agentes que o torna útil. Esse sistema — o **harness** — tem 8 pilares essenciais, cada um respondendo a um failure mode específico e recorrente. O harness é portátil, composto de partes conhecidas, e deve ser tratado como produto que a equipe entrega para si mesma.

## Argumentos principais

**Definição de harness:** camada durável ao redor do modelo — instruções, tools, permissões, contexto, verificação. Claude Code e Codex são harnesses. Sua equipe possui a camada acima deles.

**Os 8 pilares e seus failure modes:**

| # | Pilar | Failure mode que responde | Meta |
|---|-------|--------------------------|------|
| 1 | **Context** | Agente não conhece o projeto; resolve tudo como se nunca visse antes | Know the project |
| 2 | **Provenance** | Agente não consegue rastrear o "por quê" de cada artefato | Trace the why |
| 3 | **Capability** | Agente não age no mundo real nem observa resultados | Act and observe |
| 4 | **Workflow** | Agente reinventa como executar cada tarefa | Reuse the arcs |
| 5 | **Restraint** | Agente faz algo perigoso porque nada o impede | Stay in bounds |
| 6 | **Verification** | Agente anuncia "corrigido" sem prova | Prove the fix |
| 7 | **Visual interface** | Resultados desaparecem em parede de chat | Show the work |
| 8 | **Coordination** | Humano perde controle com múltiplos agentes em paralelo | Track every agent |

## Key insights

1. **Restraint + Capability crescem juntos:** cada nova tool precisa de scope correspondente ou vira liability. Construir os dois pilares simultaneamente.

2. **Harness portável = optionalidade real:** se trocar o agente subjacente (Claude Code → Codex → próximo) significa reconstruir o harness, você não tem optionalidade. Mesmo CLAUDE.md, mesmos tools, mesmo graph — qualquer agente por baixo.

3. **Harness composta sobre partes conhecidas:** quase nada no bom harness é novo — são partes de terceiros (Claude Code, MCP, Playwright, tracker, test runner, repo) montadas de forma que o agente possa pull context correto e verificar o que produziu.

4. **Worked example (bug tracker item vazio):** um bug que tomou 4 sessões anteriores de "corrigido" foi resolvido em 1 sessão porque cada pilar carregou sua parte — Context carregou CLAUDE.md + Y.Doc rules; Provenance mostrou as 4 sessões anteriores; Capability rodou `wrangler tail`; Verification exigiu Playwright spec verde antes de anunciar fix.

5. **Harness se melhora continuamente:** revisar transcripts → padrões de erro → regras novas. Skills escritas quando o mesmo convention é explicado duas vezes. "The harness gets better every week without anyone setting aside a harness sprint."

6. **Multi-agent coordination é problema do segundo trimestre.** Get one agent reliable first.

7. **Franework calibração:** você pode nomear algum failure mode recorrente que não mapeia em nenhum pilar? Se sim, o framework está faltando algo. Você pode colapsar 2 pilares sem trazer um failure mode de volta? Se sim, tem um pilar a mais.

## Exemplos e evidências

- **Nimbalyst**: workspace open-source criado pela equipe para montar o próprio harness nos 8 pilares. Repositório: `docs/THE_HARNESS.md` com implementação viva (arquivos, regras, MCP tools, slash commands, tracker workflows).
- **Plan mode no harness:** `/investigate` → `/design` produz plano que próxima sessão herda. `/release-alpha` executa version-bump + changelog + tag da mesma forma toda vez.
- **Bug workstream:** 5 sessões, dias de trabalho. A sessão final leu summary do workstream + sessões anteriores antes de escrever código. Filed handoff brief para próxima sessão confirmar soak.

## Implicações para o vault

- Este vault **já opera nos 8 pilares**: CLAUDE.md (Context), `.raw/.manifest.json` + wikilinks (Provenance), Bash tools + shell (Capability), skills/ (Workflow), guard + permissions (Restraint), verify agent (Verification), hot.md (Coordination).
- **Gap identificado:** Visual interface — sem workspace visual para diffs/mockups/diagramas lado a lado.
- **Recomendação "boring parts first"** valida a abordagem do vault: specs/planos em arquivos legíveis pelo agente, root instruction file, approval gates, links entre tickets/docs/sessões.

## Links

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — conceito central; adicionar 8-pillars framework
- [[03-RESOURCES/entities/wirthkarl]] — autor
- [[03-RESOURCES/entities/Nimbalyst]] — produto open-source descrito
- [[03-RESOURCES/sources/ai-agents-harness/claude-code-agent-harness-architecture]] — arquitetura complementar
- [[03-RESOURCES/sources/ai-agents-harness/anatomy-agent-harness-akshay-pachaar]] — 12 componentes vs 8 pilares
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — pilar 8 (Coordination)
- [[03-RESOURCES/concepts/agent-systems/spec-driven-development]] — pilares 1+4 (Context + Workflow)
