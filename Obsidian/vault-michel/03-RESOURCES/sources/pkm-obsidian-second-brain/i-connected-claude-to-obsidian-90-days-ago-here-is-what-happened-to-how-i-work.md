---
title: "I Connected Claude to Obsidian 90 Days Ago. Here Is What Happened to How I Work."
type: source
source: "Clippings/I Connected Claude to Obsidian 90 Days Ago. Here Is What Happened to How I Work..md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Conectar Claude ao Obsidian via Filesystem MCP transforma o vault de um sistema de armazenamento em um parceiro de pensamento que lê tudo que você já escreveu e raciocina sobre isso simultaneamente — o efeito mais valioso não é automação de tarefas, mas a surfacing de conexões não-óbvias entre notas esquecidas no momento exato em que são relevantes.

## Argumentos principais

- O CLAUDE.md não é um arquivo de configuração — é o documento mais importante do vault, uma descrição viva de quem você é e o que importa. Atualizá-lo semanalmente tem mais alavancagem do que qualquer outra rotina.
- Automatizar demais é um problema real: em 12 workflows agendados, o volume de outputs automatizados excedeu a capacidade de processar — cortou para 5 e o sistema ficou mais útil.
- A qualidade do vault é o teto do sistema: outputs de Claude são apenas tão bons quanto as notas de entrada. Notas de baixa qualidade geram síntese medíocre.
- Dados de 90 dias revelam padrões invisíveis em qualquer semana individual.

## Key insights

- Setup: instalar Claude Desktop, editar JSON para configurar Filesystem MCP com path do vault, reiniciar, testar — total ~2 horas.
- Cinco workflows core recomendados (e nada mais por 30 dias): morning brief, inbox processor, project health, connection finder, weekly review.
- Morning brief prompt base: ler CLAUDE.md, todos os project files ativos, daily note de ontem → gerar: most important thing today, project status, open loops, uma conexão entre vault e o que deveria estar pensando. Salvar em BRIEFINGS/[DATE]-morning-brief.md.
- CLAUDE.md específico (Versão 2 depois da revelação da semana 3): content pillars, audience, voice, projetos com status e next actions, top 3 priorities da semana, writing standards, o que nunca publica, o que está tentando descobrir.
- Três padrões identificados aos 90 dias: (1) melhor trabalho nos primeiros 90 minutos do dia → reestruturou agenda; (2) conteúdo com números específicos supera tudo mais → adicionou requirement ao CLAUDE.md; (3) decisões rápidas sem checar vault têm 40% mais taxa de revisão/reversão → adicionou regra para decisões de consequência moderada+.
- Semana 2: morning brief manual levava 45 minutos; automatizado gerou em 4 minutos na primeira vez.
- Seis coisas que parou de fazer manualmente: project status tracking, keyword search for related notes, starting articles from scratch, template-filling for meeting notes, re-explaining context at session start, compiling weekly reviews.

## Exemplos e evidências

- Autor (@cyrilXBT): vault com centenas de notas, 3 anos de pensamento acumulado; setup numa tarde de domingo.
- Mês 2: publicou mais do que em qualquer mês anterior sem trabalhar mais horas — blank page problem eliminado.
- Consumo de notícias gerais caiu ~80% após morning brief se tornar fonte primária; tempo de consumo de 45 min/dia para 5 min/dia.
- Mês 2, falha de aprendizado: 12 workflows agendados → cortou para 5 → sistema melhorou imediatamente.
- Decision quality: decisões rápidas sem decision support prompt têm 40% mais taxa de revisão/reversão.

## Implicações para o vault

- Valida a arquitetura atual do vault-michel: CLAUDE.md como documento central, morning briefing automatizado, 5 workflows core.
- O princípio "automated output you don't read is noise" é um anti-pattern a documentar — o vault já aplica isso (poucos workflows bem usados > muitos ignorados).
- A semana 3 revelation sobre CLAUDE.md confirma que o CLAUDE.md do vault deve ser revisado regularmente e com alta especificidade.
- Connection finder como a skill de maior alavancagem valida o agente connection-finder.md já existente no vault.

## Links

- [[03-RESOURCES/concepts/ai-agents/obsidian-claude-integration]]
- [[03-RESOURCES/concepts/ai-agents/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/learning-cognition/second-brain]]
- [[04-SYSTEM/wiki/hot]]
