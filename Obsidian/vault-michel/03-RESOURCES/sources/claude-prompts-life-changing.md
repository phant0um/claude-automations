---
title: "These Claude Prompts Changed My Life (resources included)"
type: source
source: "Clippings/These Claude Prompts Changed My Life (resources included).md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Um criador de conteúdo testou 300+ "mega prompts" no Claude em um ano e seleciona 6 frameworks de prompting que viraram sistemas funcionais de produtividade pessoal e operação de negócio — não prompts simples, mas instruções que constroem sistemas reutilizáveis (auditoria de vida, briefing de mercado, dashboard gamificado, motor de ideação de conteúdo, gerador de propostas, e um "Second Brain" que une tudo).

## Argumentos principais
- **Prompt #6 — Strategic Life Audit**: transforma o Claude em consultor estratégico de vida, combinando rigor analítico (McKinsey) com profundidade psicológica (terapeuta de alta performance). Funciona em 3 fases: Deep Discovery (uma pergunta por vez, sem permitir respostas "de superfície"/ensaiadas — Claude é instruído a confrontar respostas rehearsed), Mirror Phase (resume o que ouviu, surge contradições entre o que a pessoa diz querer e como gasta tempo/energia/dinheiro), Strategic Analysis (produz documento com: verdade desconfortável, diagnóstico de trajetória se nada mudar, lista de contradições, top-3 oportunidades de maior leverage com escolha forçada de uma única, plano de execução de 90 dias, e perfil estratégico em terceira pessoa para reutilizar como contexto em conversas futuras).
- **Prompt #5 — Daily Brief**: analista de inteligência de mercado pessoal (cripto/macro/AI) que usa web search obrigatoriamente, nunca "adivinha" números, e produz relatório estruturado em 12 seções fixas (macro update, "minha opinião" com posicionamento claro, top gainers/losers, deep dive BTC, overview cripto, setups a observar, catalisadores 24-72h, unlocks de token, radar de altcoin, ideias de trade com stop/target, ângulos de conteúdo, calendário de eventos). Pode ser automatizado via Perplexity Computer para Slack/email diário.
- **Prompt #4 — Gamified Habit Dashboard**: artifact interativo do Claude com sistema de pontos (10pt por hábito, +50 bônus por dia completo), streak tracker, multiplicador de streak (1.5x após 7 dias, 2x após 30), sistema de níveis com barra de progresso, overview semanal — pensado especificamente para quem tem dificuldade de consistência (o autor cita TDAH).
- **Prompt #3 — Content Ideation Engine**: opera em 2 estágios — avaliação de ideia (Claude dá 5 opções de título ranqueadas por CTR previsto, calibradas à marca/audiência específica via Claude Projects) e engenharia reversa de conteúdo viral (por que funcionou na plataforma original, qual foi o gatilho emocional, como traduzir para outro formato). O prompt completo gera 5 ângulos de conteúdo com hook, formato e "audience pull", depois estrutura roteiro em bullet points (cold open, setup, conteúdo central com retention beats, climax, close).
- **Prompt #2 — AI Proposal System**: workflow de agência que mantém um proposal-mestre no Claude e, após cada call gravada/transcrita (via Fireflies), roda um único prompt ("edite a proposta para alinhar com as necessidades específicas deste cliente"). A estrutura de saída tem 9 seções fixas (capa, sumário executivo, landscape competitivo, oportunidade, projeção de crescimento, scope of work em 3 fases, case studies, investimento em 3 tiers, próximos passos) com regra explícita de "nenhum placeholder, toda análise competitiva deve ser real".
- **Prompt #1 — Second Brain / Personal OS**: o prompt mais ambicioso, que une todos os anteriores em um sistema operacional pessoal com 7 módulos ativados por comando (Strategy, Finance/CFO, Communications, Content Engine, Team Operations, Market Intelligence, Goals & Habits), regras universais (sem preâmbulo, sempre dados reais não genéricos, sinalizar conflitos antes de executar, terminar todo output com "Next Steps"), e um setup inicial que força o Claude a perguntar metas/entidades/equipe/hábitos antes de operar. No caso do autor, é alimentado por mensagens de WhatsApp/Telegram/Slack/email processadas automaticamente via OpenClaw + Claude Dispatch.

## Key insights
- O padrão comum a todos os 6 prompts: eles não pedem uma resposta, pedem que o Claude **construa e mantenha um sistema** com estrutura de saída fixa, regras de validação, e contexto acumulado (via Projects ou memória persistente).
- O autor enfatiza repetidamente honestidade forçada: "be honest", "challenge me", "se a ideia é fraca, diga" — um padrão de design de prompt que combate a tendência do LLM a validar acriticamente o usuário.
- O Second Brain prompt é descrito como a evolução natural dos outros 5: sistemas separados exigem reabrir contexto manualmente; o Personal OS os conecta em um único fluxo contínuo.

## Exemplos e evidências
- Autor testou 300+ mega prompts em um ano de uso diário do Claude.
- O sistema de proposta de agência: cada proposta nova é derivada de notas de reunião + um proposal-mestre, citado como reduzindo drasticamente o tempo de customização manual.
- Dashboard de hábitos: estrutura de pontos e níveis explicitamente numérica (Level 2 = 500 pts, Level 5 = 5000 pts) pensada para quem precisa de reforço externo de consistência.

## Implicações para o vault
- Vários desses prompts são templates aplicáveis diretamente ao próprio sistema do vault: o "Daily Brief" se conecta a `04-SYSTEM/agents/finance-system/Macro.md` (já existente no sistema de agentes financeiros do usuário); o "Second Brain / Personal OS" é uma instância concreta do que o Nexus já tenta ser no vault-michel.
- O padrão de "Strategic Profile" reutilizável (parágrafo em 3ª pessoa para colar em conversas futuras) é uma forma manual do que o CLAUDE.md do vault já faz de modo persistente — vale considerar incorporar elementos do Strategic Life Audit como rotina periódica.
- Reforça `goal-prompt-structure` e `claude-md-behavioral-contract` como conceitos já mapeados que descrevem exatamente esse padrão de prompt-como-contrato-comportamental.

## Links
- [[03-RESOURCES/concepts/claude-code-tooling/goal-prompt-structure]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-md-behavioral-contract]]
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- [[03-RESOURCES/entities/Claude]]
