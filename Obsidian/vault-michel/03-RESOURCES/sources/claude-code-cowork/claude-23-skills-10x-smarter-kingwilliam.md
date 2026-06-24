---
title: "How I set up Claude with 23 skills and made it 10x smarter"
type: source
source: "[@kingwilliam_](https://x.com/kingwilliam_/status/2064785796486295921)"
created: 2026-06-13
ingested: 2026-06-13
tags: [ai-agents]
---

## Tese central

"Prompt = você ensina Claude o trabalho uma vez. Skill = você ensina Claude
o trabalho para sempre." Skills são lidas automaticamente pelo agente via
`description`; o usuário não precisa invocar.

## Argumentos principais

- **Setup em 5 min**: pasta `~/.claude/skills/<nome>/SKILL.md` (pessoal,
  cross-project) ou `.claude/skills/<nome>/SKILL.md` (projeto). Erro mais
  comum: path errado (uma pasta a mais/menos). Verificar com `/skills` após
  restart.
- **Template SKILL.md**: frontmatter `name` + `description` (com triggers
  explícitos: "Use when...") + body com instruções.

## Key insights

### 23 skills, agrupadas em 5 categorias

| # | Skill | Função | Trigger/core |
|---|---|---|---|
| 1 | voice-match | escreve no "tom" do usuário | usa 5 posts como amostra, bane palavras odiadas, retorna 3 versões |
| 2 | hook-lab | gera ganchos/aberturas | 10 hooks por request, padrões testados (contraste, número, "nobody is talking about") |
| 3 | thread-architect | transforma ideia em thread | hook → 1 beat/linha → escalação → payoff final |
| 4 | repurposer | reformata 1 conteúdo para N plataformas | X / long-form / newsletter / video script, no ritmo nativo de cada |
| 5 | ruthless-editor | corta texto sem perder voz | remove abertura de "limpeza de garganta", troca adjetivos fracos |
| 6 | qt-engine | reage a posts/vídeos com ângulo próprio | acha o número/contraste que o original perdeu |
| 7 | deep-research | pesquisa real com fontes | múltiplas buscas, fontes primárias, separa fato verificado de claim |
| 8 | source-auditor | audita artigo/transcript | separa fatos / especulação / frameworks úteis / onde o autor provavelmente erra |
| 9 | devils-advocate | pressure-test de plano | argumenta o caso contrário mais forte, identifica assunção que afundaria o plano |
| 10 | decision-architect | decide entre opções | 4 passes (ganho 1 ano / regret 5 anos / custos ocultos / alinhamento identitário) + recomendação |
| 11 | doc-to-action | doc longo → ações | resumo 5 linhas + próximas ações + 1 coisa para as próximas 24h |
| 12 | plan-first | impede código antes de pensar | descreve entendimento + arquitetura + 3 failure points prováveis, espera aprovação |
| 13 | repo-onboarder | entende codebase antes de tocar | lê arquivos-chave, mapeia conexões, resume arquitetura, sinaliza risco |
| 14 | deploy-runbook | checklist de deploy | git push, env vars, deploy, verificação de auth/DB |
| 15 | bug-hunter | debug autônomo | lê arquivos, hipótese, fix, testa, repete até 3 abordagens |
| 16 | agentic-reviewer | revisa código antes de merge | checa "fez exatamente o pedido, nada mais", sem assunções silenciosas |
| 17 | cold-outreach | mensagens com resposta | <90 palavras, observação específica, 1 ask de baixo atrito, 3 versões |
| 18 | offer-sharpener | pressure-test de preço/oferta | quem mais serve esse buyer e a que preço, o que aumenta valor percebido |
| 19 | competitor-teardown | mapeia concorrente | posicionamento, preço, claims, gap não servido |
| 20 | idea-killer | tenta matar ideia antes do tempo gasto | maior razão de fracasso + menor teste de demanda em 2 semanas |
| 21 | weekly-review | review de 10 min | o que terminou/evitou/deu-drenou energia + 1 foco para próxima semana |
| 22 | brain-dump-sorter | organiza mente | prioridades reais vs ansiedades disfarçadas vs coisas para deixar ir + 1 ação 24h |
| 23 | second-brain | memória cross-session | escreve decisões/outcomes em MEMORY.md, nunca re-sugere abordagem que já falhou |

## Implicações para o vault

`second-brain` (skill #23) é literalmente o mecanismo de auto-memory já em
uso (`~/.claude/projects/.../memory/`). `plan-first` (#12) é o princípio
Karpathy "think before acting" já no CLAUDE.md. `doc-to-action` (#11) e
`source-auditor` (#8) são candidatos diretos a skills de
`04-SYSTEM/skills/` para o pipeline-diario (triagem/ingest já fazem parte
disso implicitamente). Ver também [[03-RESOURCES/sources/claude-code-cowork/how-to-actually-prompt-claude-fable-5]]
— a leitura "skill over-tuned" daquele artigo (deleção #1) é um contraponto
direto: catálogos grandes de skills (como este, 23 skills) correm o risco
de over-prescrição se cada SKILL.md tiver passos rígidos demais para Fable 5.
