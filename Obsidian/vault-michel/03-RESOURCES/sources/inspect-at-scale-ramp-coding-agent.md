---
title: "Inspect at Scale"
type: source
source: "Clippings/Inspect at Scale.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Post da Ramp sobre "Inspect" (agente de código interno deles, não o framework Inspect da Anthropic) documentando a evolução de "ferramenta de engenheiro escrever código" para "ambiente de trabalho agêntico da fábrica de software inteira" — 76,5% de todos os PRs merged na Ramp nos últimos 6 meses foram criados com Inspect, 750+ pessoas usam diariamente, 10.000+ sessões/dia.

## Argumentos principais
- Escala: 800k sessões, 30M tool calls, 100M message parts extraídos/sanitizados/armazenados como dataset pra identificar padrões de acesso, failure paths, retrabalho de tool e hallucination de modelo.
- **Rewiring do control plane do sandbox (Sandboxes V2)**: caminho antigo roteava comandos de controle por servidor HTTP Bun dentro de cada sandbox — lento e propenso a erro. Substituído por WebSocket direto via Cloudflare Durable Object — tempo até interativo caiu de ~6,5s pra 2s.
- Outras otimizações: regiões de compute mais próximas do usuário/banco (eliminando round-trip cross-region), remoção de trabalho redundante no caminho prompt→modelo (~600ms economizados por mensagem), queries de sessão otimizadas.
- **Sandbox por repositório, não genérico**: cada repo tem perguntas próprias respondidas na imagem de build — pré-aquecer build cache, cache incremental do mypy, bancos de teste pré-construídos no monolito Python; `terraform init` já rodado em repos de infra; stack local já de pé em repos de microsserviço. Ferramentas/MCPs disponíveis por padrão variam por repo deliberadamente — "não é carregar tudo em todo lugar, é fazer o caminho comum parecer obviamente certo".
- **Caso RTK (Rust Token Killer)** — achado de contradição direta: Ramp habilitou RTK (proxy que reescreve comandos antes de executar pra comprimir output de shell) por 5 semanas em seus repos mais usados. Resultado teórico: ~150k sessões, 3,2M comandos shell proxiados, ~335B tokens de input "economizados" — ~US$1M em economia teórica de token. Na prática, o modelo via o comando reescrito, não o original; isso gerava confusão (o modelo tentava contornar o wrapper, ajustar flags, escapar o comando, repetir com abordagem diferente — múltiplas vezes por sessão), de forma que comandos precisavam ser re-executados e o sistema acabou **usando mais tokens**, não menos. Lição explícita: "economia de token só é útil se preserva o entendimento do modelo sobre o ambiente — se a otimização torna o agente menos previsível, a economia teórica desaparece em retrabalho."
- **Próximos passos**: agentes de review próprios (Review Buddy já revisou 8.836 PRs em 1 mês), trazer Inspect mais perto de como o trabalho realmente acontece (times, projetos, áreas de ownership, incidentes, threads de planejamento) — não só a task isolada.

## Key insights
- O achado de RTK é o ponto mais importante para qualquer usuário que já usa RTK como ferramenta de economia de token: economia "no papel" (bytes/tokens comprimidos) não é o mesmo que economia líquida em produção — se o modelo perde a relação causal entre o que pediu e o que rodou, ele compensa com retrabalho que cancela o ganho. Mesmo padrão do achado headroom/CCR do batch anterior (lib que comprime mas o agente recupera o que precisa de volta = líquido negativo).
- Otimização de sandbox por-repo (não genérica) é o oposto de "um harness serve todos os casos" — confirma que customização por contexto de uso bate abordagem one-size-fits-all em produção real de alto volume.

## Exemplos e evidências
- 76,5% dos PRs merged em 6 meses via Inspect; 98,6% dos Ramplings de Eng/Produto/Design/Dados já usaram; 58,1% deles com 50+ sessões/mês.
- RTK: 150k sessões, 3,2M comandos shell, ~335B tokens "economizados" no papel, ~US$1M teórico — resultado líquido negativo por retrabalho.
- Sandbox time-to-interactive: 6,5s → 2s pós Sandboxes V2.

## Implicações para o vault
**Relevância direta**: este vault usa RTK ativamente (hook global `~/.claude/RTK.md`, `rtk gain`/`rtk proxy` no fluxo diário). O achado da Ramp é evidência empírica de risco real — se o modelo perde visibilidade do comando original reescrito pelo RTK, o resultado pode ser retrabalho que cancela a economia. Vale considerar rodar `rtk gain --history` periodicamente pra confirmar que a economia reportada é líquida (sessões sem retry/retrabalho elevado), não só teórica — mesma disciplina de medição que o achado headroom/CCR já recomendou.

## Links
- [[03-RESOURCES/sources/hermes-search-files-densification-pr]]
- [[03-RESOURCES/concepts/agent-systems/token-economy]]
