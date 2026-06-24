---
title: "How to Turn Claude Code Into a Full Team of Specialists"
type: source
source: Clippings/How to Turn Claude Code Into a Full Team of Specialists.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Claude Code "puro" é poderoso mas amnésico: cada sessão começa do zero, exigindo que o usuário re-ensine stack, convenções e padrão de "pronto" toda vez. ClaudeKit (theclaudekit.com) resolve isso vendendo "kits verticais" — pacotes de slash commands + skills + subagents pré-construídos por domínio — que transformam Claude Code instantaneamente num especialista completo daquele domínio, eliminando o re-prompting manual.

## Argumentos principais
- O problema não é capacidade, é continuidade: "That is one brilliant assistant with amnesia. Useful. But small." Claude Code sabe codar, escrever, pesquisar, editar vídeo — mas não sabe quem é você: stack, voz, benchmarks, checklist de "pronto".
- ClaudeKit não é prompt pack nem doc de "10 prompts matadores" — é um marketplace de kits verticais. Cada kit é um especialista completo: comandos, skills e subagents pré-construídos para um tipo de trabalho e um tipo de pessoa.
- Instalação trivial: `ck install [kitname]`, a partir de $14.99/mês por kit. Cada arquivo do kit é medido por custo de contexto antes de carregar — visibilidade explícita do impacto na context window.
- **EngineerKit** (25 comandos + skills + subagents read-only, regra única: "nothing ships on a vibe", tudo termina com evidência):
  - `/eng-debug` — puxa trace, lê últimos 15 commits perto da falha, reproduz o bug primeiro, recusa tocar código até nomear a causa em uma frase, entrega o menor fix + teste de regressão (red antes, green depois, suite completa)
  - `/eng-review` — revisa diff e só sinaliza o que bloquearia merge, com nível de confiança por finding
  - `/eng-ship` — commit, push, abre PR com descrição gerada do diff real; recusa-se a fazer isso se testes falham ou há secret no diff
  - `/eng-catchup` — "cura de memória": lê o que mudou desde o último pull/clear/fim de semana, evita reexplicar o próprio repo ao próprio assistente
- **VideoKit** (17 comandos): `/video-make` (descrição/URL/repo → vídeo renderizado, com check pós-render para confirmar que não há frames pretos); `/video-clone` (mede cenas de um vídeo de referência — cortes, paleta, tipografia, movimento — e reconstrói o estilo em Remotion com conteúdo próprio, reanalisando o próprio render contra o original); `/video-social` (um vídeo longo → cortado para TikTok/Reels/Shorts/LinkedIn/X em um run); `/video-repurpose` (acha os melhores momentos automaticamente).
- **MarketingKit**: foco diferencial em soar humano. `/mkt-humanize` varre os 14 "tells" de "isto foi escrito por IA" (em-dash como cola, tique "não é X, é Y", vocabulário banido como "delve"/"leverage"/"elevate") e reescreve na voz do usuário, mostrando antes/depois dos 5 piores fixes. `/mkt-launch` gera o conjunto completo de lançamento (X, LinkedIn, Product Hunt, email) já passado pelo voice engine. `/mkt-competitors` faz tear-down do motor de conteúdo de um concorrente. `/mkt-voice` constrói o arquivo de voz a partir de 5–10 posts reais do usuário.

## Key insights
- O produto vendido não é conhecimento, é continuidade operacional — o kit "já sabe" o workflow, já carrega o domain knowledge, já está plugado nas ferramentas certas, instantaneamente, em vez do usuário reconstruir esse contexto a cada sessão.
- Medir custo de contexto por arquivo antes de carregar é tratado como diferencial central do produto, não detalhe técnico — sinaliza que context budget é hoje um eixo competitivo entre ofertas de "Claude Code especializado".
- O enquadramento "You are not prompting from scratch anymore. You are hiring a department." é a tese de venda: kits = departamento contratável, não prompt melhor.

## Exemplos e evidências
- Preço: a partir de $14.99/mês por kit.
- `/eng-debug` ilustra o padrão verify-before-fix: nomear causa antes de tocar código, entregar teste de regressão que comprovadamente falha antes do fix e passa depois.
- `/mkt-humanize` lista tells concretos de texto gerado por IA: em-dash como conector, construção "it's not X it's Y", palavras como "delve", "leverage", "seamless", "elevate".

## Implicações para o vault
Caso de mercado concreto do padrão já mapeado em `[[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]]` (bundle Skills+Connectors+Commands+Subagents) e `[[03-RESOURCES/concepts/agent-systems/agentic-skills]]` — ClaudeKit é a versão comercial/vertical desse bundle, vendida como produto SaaS por nicho (eng, vídeo, marketing). Relevante para o próprio vault-michel como referência de "kit" estruturado (commands+skills+subagents por domínio) — o vault já roda algo análogo internamente via `04-SYSTEM/agents/` por sistema (finance-system, fullstack-agent-system, nexus-agent-system).

## Links
- [[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-subagents]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/cowork-slash-commands]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
