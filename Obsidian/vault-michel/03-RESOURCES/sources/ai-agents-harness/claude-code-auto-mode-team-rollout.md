---
title: "How we rolled out Claude Code Auto Mode across our Engineering Team"
type: source
source: Clippings/How we rolled out Claude Code Auto Mode across our Engineering Team.md
author: "@dani_avila7"
org: Hedgineer
published: 2026-05-27
created: 2026-05-29
ingested: 2026-05-29
tags: [ai-agents, claude-code, auto-mode, team-deployment, observability, opentelemetry]
---

## Tese central

A Hedgineer centralizou a configuração de Claude Code Auto Mode em um único `managed-settings.json` distribuído via server-managed settings, substituindo configurações divergentes por engenheiro. O resultado: auto-approval subiu de 82% para 95%, "always allow" rules caíram 89%, e o classificador tratou 21.000 decisões de tool adicionais sem crescimento da equipe. O insight fundamental: settings sem observabilidade são chutes; observabilidade sem política para validar é ruído — o valor está em colocar os dois no mesmo loop.

## Argumentos principais

- **Problema pré-centralização**: cada engenheiro configurava suas próprias rules e overrides independentemente; sem alinhamento de política, comportamento divergia entre membros da equipe.
- **Quatro inputs para design da política**: infraestrutura, projetos, code patterns, e dados OpenTelemetry. O dado de OTEL foi o mais importante — mostrou exatamente o que a equipe fazia que o classificador ainda não confiava.
- **Server-managed settings como mecanismo de distribuição**: admins fazem push uma vez, cada desenvolvedor recebe na próxima inicialização. Três comandos CLI permitem a qualquer um inspecionar o que está ativo na sua máquina.
- **O loop correto**: observabilidade + política no mesmo loop. Settings sem observabilidade = chutes. Observabilidade sem política para validar = ruído.

## Key insights

**Métricas antes vs. depois da centralização:**
- Auto-approval rate: 82% → 95% (+13 pontos percentuais)
- "Always allow" rules criadas por engenheiros: queda de 89% (engenheiros pararam de criar workarounds individuais)
- Decisões de tool tratadas pelo classificador: +21.000 sem crescimento da equipe

**Por que OTEL foi o input mais importante**: dados de telemetria mostraram exatamente quais ações a equipe realizava que o classificador ainda não confiava, permitindo refinar a política baseada em comportamento real em vez de suposições.

**Server-managed settings como primitivo de governança de equipe**: o artigo mostra que Auto Mode não é apenas configuração individual mas pode ser uma política de engenharia gerenciada centralmente, análoga a linting rules ou CI configs.

**O que está mudando em seguida**: o artigo menciona "what we're changing next" com link para writeup completo em https://www.hedgineer.io/content/auto-mode-enterprise/ — sugere iteração contínua baseada em dados.

**Inspeção local**: três comandos CLI permitem qualquer desenvolvedor verificar o que está ativo — transparência da política para os destinatários.

**Contexto da empresa**: Hedgineer — fintech/engineering company (@dani_avila7). Meses de coleta de dados OTEL navegando padrões de uso entre equipe e Claude Code.

## Exemplos e evidências

- **Empresa**: Hedgineer
- **Período de coleta OTEL**: meses (pré-centralização)
- **Auto-approval**: 82% → 95%
- **"Always allow" rules**: queda de 89%
- **Decisões adicionais pelo classificador**: 21.000 sem crescimento de headcount
- **Mecanismo de distribuição**: server-managed settings, push único pelos admins

## Implicações para o vault

Primeiro dado empírico de rollout de Auto Mode em uma equipe de engenharia real com métricas. Complementa [[03-RESOURCES/concepts/agent-systems/auto-mode]] com evidência de produção.

O padrão de "policy + observability loop" é aplicável ao vault: usar dados de uso para refinar AGENTS.md e CLAUDE.md em vez de configuração intuitiva.

O conceito de "always allow rules caindo 89%" indica que configurações individuais de workaround são um anti-pattern — uma política centralizada bem calibrada elimina a necessidade de exceções ad-hoc.

## Links

- [[03-RESOURCES/concepts/agent-systems/auto-mode]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/entities/Claude Code]]
