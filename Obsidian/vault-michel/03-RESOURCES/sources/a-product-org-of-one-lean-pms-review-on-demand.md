---
title: "A product org of one: how lean PMs get engineering, legal, and UX review on demand"
type: source
source: "Clippings/A product org of one how lean PMs get engineering, legal, and UX review on demand.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [articles]
---

## Tese central
Pedir a um único chat de IA "o que você pensa desse PRD?" produz uma leitura "agradável e medianizada" porque os modelos aprendem a concordar — em vez disso, o autor roda sete revisores separados, cada um em seu próprio contexto, lendo um framework diferente antes de falar, devolvendo perguntas em vez de notas. Isso comprime dias de coordenação de calendário (engenharia, legal, UX) em uma única passada.

## Argumentos principais
- Um único assistente segurando sete perspectivas ao mesmo tempo "lixa" (sands) as posições em algo liso e seguro — a discordância entre disciplinas é exatamente o que se precisa ouvir, e ela se perde quando promediada.
- Anthropic lançou Claude Code v2.1.172 em 10 de junho permitindo que subagentes lancem seus próprios subagentes, até cinco níveis de profundidade — sinal de que o padrão vencedor é decomposição: pegar um problema difícil, dividir em subproblemas, deixar cada um trabalhar sua peça.
- Cada revisor devolve no mesmo formato: findings ranqueados por severidade com evidência, apenas as perguntas bloqueantes, e um próximo movimento recomendado. São read-only (criticam o doc sem tocá-lo) e dão perguntas em vez de veredictos, porque "uma nota não melhora um PRD; as perguntas são o que te mandam de volta aos buracos reais".

## Key insights
1. **Engineering**: lê um framework de priorização, ataca viabilidade, dependências escondidas, escala, edge cases, e a conta de manutenção que você está assumindo silenciosamente.
2. **Design**: trabalha o fluxo do usuário e os estados que todo mundo esquece (vazio, erro, carregando, parcialmente preenchido), mais acessibilidade e se você inventou um padrão novo que os usuários agora precisam aprender.
3. **Executive**: lê um framework de "strategy-kernel" (diagnóstico, política, ação de Rumelt) e pergunta se isso conecta com objetivos da empresa, qual o custo de oportunidade, e quais são os critérios de morte (kill criteria).
4. **Legal**: sinaliza privacidade e tratamento de dados (GDPR, CCPA), retenção, consentimento e licenciamento — abre com "isto não é aconselhamento legal", o que o autor considera "a quantidade certa de humildade".
5. **UX Research**: separa o que foi validado do que foi assumido, nomeia a suposição que carrega mais risco, e aponta para o estudo mais barato que des-arriscaria essa suposição.
6. **Devil's Advocate**: lê um framework de "pivot-triggers" e desafia o próprio problema — estamos construindo para três usuários que reclamaram alto? um help doc resolveria? o que falhou nas últimas três vezes que tentamos isso?
7. **Customer Voice**: solta o jargão e fala como a pessoa que vai usar a coisa — consigo descobrir isso sem tutorial? o que acontece quando eu erro? por que eu trocaria do que já uso?

## Exemplos e evidências
- Citação de abertura: "If you're a PM who drops a PRD into Claude and asks 'what do you think?'... The answer comes back clean and confident, and it barely helps."
- Cenário concreto de falha: staff engineer pergunta sobre escala além de dez mil usuários, legal pede política de retenção de dados, VP pergunta o que não está sendo construído — nada disso aparece na revisão de um único chat.
- Versão produtizada: "/review workflow in PM OS" — os sete revisores, os frameworks já conectados, output estruturado, rodando dentro de Claude Code, Cursor, ou Cowork. Numa PRD completa adiciona mais dois (optimist e critic) totalizando nove.
- Ressalva explícita do autor: "It won't replace your real cross-functional review and it isn't trying to. It clears the dumb, embarrassing gaps."

## Implicações para o vault
Caso de uso concreto do padrão multi-agente já documentado em `subagent-pattern-empirical` e `claude-code-subagents`: especialização por persona/framework em vez de um agente generalista, aplicada a revisão de documentos de produto (não código). Reforça a tese de que subagentes isolados servem para evitar a "média" de um único contexto tentando representar múltiplos pontos de vista conflitantes — relevante para o design de qualquer "council" ou "review panel" de agentes no vault.

## Links
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-subagents]]
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/anthropic]]
