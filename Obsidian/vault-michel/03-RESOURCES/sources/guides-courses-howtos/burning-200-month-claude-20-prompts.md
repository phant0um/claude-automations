---
title: "You're Burning $200/Month on Claude. These 20 Prompts Fix That."
type: source
source_type: clipping
source_file: "Clippings/You're burning $200month on Claude. These 20 prompts fix that..md"
source_url: "https://x.com/thegreatest_sv/status/2053128520138739985"
author: "@thegreatest_sv"
created: 2026-05-14
tags: [token-efficiency, claude-code, prompt-engineering, cost-optimization, caveman-mode, opus-47, budget-prompting]
triagem_score: 7
---

# You're Burning $200/Month on Claude. These 20 Prompts Fix That.

**Author:** @thegreatest_sv  
**Context:** Opus 4.7 API rates; typical Claude Code session = 80,000–200,000 tokens / $3–15

## Top 10 Saving Prompts

| # | Technique | Est. Savings/Month | Mechanism |
|---|---|---|---|
| 1 | **Startup audit** | ~$45 | Add minimal-response instructions before first message; cuts 11k→800 tokens |
| 2 | **Caveman mode in CLAUDE.md** | ~$25 | 22–87% output reduction; [source](https://github.com/juliusbrussee/caveman) |
| 3 | **Diff only** | ~$15 | Show only changed lines + 3 context lines; 8k→400 tokens per edit |
| 4 | **No preamble rule** | ~$8 | Ban "Great question", "Of course", "Let me" — 30 tokens × 100 resp/day |
| 5 | **Thinking cap** | ~$20 | Explicit "minimal reasoning" for simple tasks; stops 50k-token pre-answers |
| 6 | **Output budget** | ~$8 | "Your response budget is 300 tokens." Hard cap on explanations |
| 7 | **File scope lock** | ~$20 | "Only read files inside /src/[folder]." Stops full-repo reads for one function |
| 8 | **Plan before agent** | ~$20 | Require text plan + approval before any multi-file task; catches wrong approaches |
| 9 | **Context compression** | ~$30 | Ask for 500-token project summary as working memory |
| 10 | **Session handoff** | ~$8 | 200-token summary saved to `.claude/SESSION_[date].md` |

**Combined top-10 savings: ~$179/month**

## Combined CLAUDE.md Snippet (Prompts 2+3+4+5+6)

```
Respond in minimal words. No preamble. No summary. No markdown unless showing code.
Start with the answer. Show only changed lines in code edits.
For simple tasks: skip extended reasoning.
Budget: 300 tokens unless I say otherwise.
```

## 10 Scenario-Specific Prompts

| Scenario | Key prompt pattern | Savings |
|---|---|---|
| Bug fixing | "Read only [specific file]. Fix only the broken logic. Show only changed lines." | 40k→800 tokens; ~$90/month at 5 bugs/day |
| Article writing | Explicit word count + format + "Start with first sentence of piece, not intro" | 60% output cut |
| Concept explanation | "Explain in 3 sentences maximum. Simplest words possible." | 80% reduction |
| Code review | "Flag only: bugs, security issues, breaking changes. Output: file→issue→severity." | 70% cut |
| Research | "5 key players (1 sentence each). 3 market trends (1 data point each). 1 opportunity sentence." | 5k→400 tokens |
| Data analysis | "Read only first 20 rows to understand structure. Answer: [specific question]." | 15k→1k tokens |
| Context contamination | "New task. Disregard everything from previous conversation." | 3k–8k tokens saved |

## Core Insight

> "Most people optimize the model. Nobody audits the prompts. That's where the real money goes."

The model is not the problem. The prompts are. The same model, same plan, same bill — prompt discipline is the lever.

## References

- [github.com/juliusbrussee/caveman](https://github.com/juliusbrussee/caveman) — caveman mode
- [github.com/nadimtuhin/claude-token-optimizer](https://github.com/nadimtuhin/claude-token-optimizer)
- [github.com/ooples/token-optimizer-mcp](https://github.com/ooples/token-optimizer-mcp)

## Por que o modelo não é o problema — análise do custo real

A maioria dos usuários que excede o orçamento mensal atribui o problema à intensidade de uso. O artigo reposiciona: o problema é *ineficiência estrutural de prompts*. Os números explicam:

Uma sessão de Claude Code típica (80k–200k tokens, $3–15) pode ser decomposta:
- **Tokens necessários**: input do codebase relevante + instrução + output de qualidade
- **Tokens desperdiçados**: re-reads desnecessários, preambles verbosos, reasoning extenso para tarefas simples, outputs explicativos que ninguém pediu

A técnica #1 (startup audit) demonstra isso com precisão: sem instruções de resposta mínima, a primeira mensagem de uma sessão frequentemente gera 11k tokens de contexto de setup. Com uma única linha de instrução no CLAUDE.md, cai para 800. Essa redução de 93% acontece *antes* de qualquer trabalho real.

## Caveman Mode — como funciona tecnicamente

O caveman mode (técnica #2, ~$25/mês de economia) é um sistema de compressão de output via instrução explícita. A implementação base do repositório `juliusbrussee/caveman` adiciona ao CLAUDE.md:

```
Write like caveman. No greeting. No explanation unless asked.
Short sentence. Action word first. Code → show code. No filler.
```

O resultado é redução de 22–87% no comprimento dos outputs. A variância é grande porque depende do tipo de tarefa: para tarefas de código (onde o output é majoritariamente código, não prosa), a redução é menor. Para tarefas de explicação, análise ou planejamento, a redução pode chegar a 87%.

**Trade-off real**: respostas muito comprimidas podem omitir contexto útil. A versão ideal do caveman mode é configurável por tarefa ("caveman mode off para esta análise") — exatamente o que o sistema deste vault permite com "stop caveman".

## File scope lock — o hack mais subestimado

A técnica #7 ($20/mês de economia) — "Only read files inside /src/[folder]" — resolve um problema específico do Claude Code: por padrão, quando pedido para "corrigir o bug na função X", o agente pode decidir ler o repositório inteiro para entender o contexto. Em repos grandes, isso é dezenas de arquivos e centenas de milhares de tokens.

O scope lock é uma instrução de *boundary*, não de *método*: você não está dizendo como o agente deve trabalhar, está dizendo onde ele *pode* trabalhar. Isso respeita a autonomia do agente (ele decide como resolver) mas elimina o search space desnecessário.

Para o vault-michel, o equivalente seria: "Only read files in `03-RESOURCES/concepts/` for this task" quando atualizando um conceito específico.

## Session handoff — evitar o "context contamination bug"

A técnica #10 (session handoff via SESSION_[date].md) resolve o "context contamination bug": quando você abre uma nova sessão sem estado de sessão anterior, o agente começa do zero. Quando você adiciona "continue from SESSION_2026-05-22.md", ele tem o estado exato de onde parou — arquivos modificados, decisões tomadas, próximos passos planejados.

**Para este vault**: o padrão `04-SYSTEM/sessions/` já implementa isso parcialmente. A adição seria padronizar um template de session handoff que o Nexus gera automaticamente ao encerrar tarefas complexas.

## Janela de 5 horas — mecânica real do rate limiting

A técnica #20 (hack da janela de 5 horas) revela a mecânica de rate limiting do Claude: o limite não é por dia calendário, mas por janela rolante de 5 horas. Isso significa:

- Gastar o limite todo às 9h → volta às 14h (não à meia-noite)
- Uso distribuído ao longo do dia nunca atinge o teto
- Sessões intensas devem ser planejadas com intervalo de 5h entre picos

Para usuários do plano $20/mês que fazem sessões longas de Claude Code, entender essa mecânica muda completamente a estratégia de uso.

## Connections

- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]] — update: concrete $ savings benchmarks added
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — extended: budget/scope patterns
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — context compression as engineering practice
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] — session handoff prevents context contamination between tasks
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — CLAUDE.md as the permanent home for caveman rules
