---
title: "The Agent Loop Architecture"
type: source
source: "Clippings/The Agent Loop Architecture.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Todo o discurso sobre "loops" como primitivo agêntico ignora a pergunta que importa: o que roda o loop? A resposta é uma arquitetura de três camadas — Loop, Skill, Orchestrator — onde durabilidade (cada passo checkpointed, cada decisão persistida, recovery a partir do último passo bem-sucedido) é fundamental, não opcional, porque sem ela o investimento de "compounding" reseta a zero a cada crash ou restart.

## Argumentos principais
- Referencia e estende dois frameworks anteriores: Matt Van Horn traçou a linhagem dos agent loops (de ReAct para tool-use, para loops de orquestração, para loops supervisionando loops) e argumentou que loops que não sobrevivem a um restart não são loops de verdade; Addy Osmani decompôs os blocos internos de um loop (automações, worktrees, skills, conectores, sub-agentes) com foco em orquestração — "desenhe o sistema que prompta o agente em vez de você".
- Onde loops simples quebram: o padrão `/loop` e `/goal` (single-agent, single-session) cobre muito terreno, mas falha no "Stage 5" de Van Horn — loops supervisionando outros loops, loops em schedule (não disparados por humano), loops que sobrevivem a restart/deploy/crash, loops que spawnam sub-agentes e esperam resultado (às vezes horas depois), loops que precisam ser observáveis depois do fato. Isso não é problema de prompting, é problema de infraestrutura.
- Citação de @runes_leo via Van Horn: "a coisa mais cara em AI coding não é mais escrever código, é gerenciar o agent loop" — um `while True` num terminal, ou um processo de longa duração numa VM, não dá nenhuma dessas garantias.
- Cenário concreto de falha sem durabilidade: processo morre/reinicia (deploy, OOM, spot instance reclamada) — o loop reinicia do zero, sem saber em que passo estava, se já mandou aquela mensagem no Slack, se já invocou o sub-agente. Resultado: re-fetch de dados já obtidos, re-chamada de LLM para decisões já tomadas, notificação duplicada, sub-agente duplicado — "você acorda com três mensagens idênticas no Slack e um time confuso".
- A correção não é "melhor error handling" — é um modelo de execução onde cada passo é checkpointed, cada decisão é persistida, e recovery significa retomar do último passo bem-sucedido.
- **Camada 1 — The Loop:** cron + decision-maker. Roda em schedule/trigger, avalia estado, decide o que fazer a seguir. O que cron nunca teve é a decisão no meio — o cron é o heartbeat, o LLM é quem decide, os steps são a execução durável que faz checkpoint do progresso.
- **Camada 2 — The Skill:** não é um prompt, é um workflow durável — multi-step, retryable, composable, deployável independentemente. "O loop é encanamento. O ativo é a skill que ele chama" (Van Horn). Cada nova skill que o sistema aprende torna todo loop mais capaz — é a parte que compõe.
- **Camada 3 — The Orchestrator:** o motor que roda tudo — agenda crons, executa steps, gerencia retries, aplica limites de concorrência, armazena histórico de execução, e hot-deploya novas funções sem perturbar as que já estão rodando. Camada invisível por design, mas fundamental — "agentes são 'loops + skills + orquestração', não apenas 'LLM + tools'; LLM e tools ficam dentro dos loops e podem ser trocados sem mudar a arquitetura".
- Tratamento explícito de falha: `onFailure` dispara depois que os retries se esgotam, posta num canal de ops, preserva o evento original (nada se perde), e a próxima execução agendada retoma de onde a falhada não conseguiu. Checkpointing a nível de step não é só correção — é economia de dinheiro, porque retry do zero significa rechamar LLMs múltiplas vezes, multiplicado por dezenas de agentes no sistema.
- **O agente que constrói suas próprias skills:** o sistema não é estático — o agente não só roda dentro de loops, ele autora novos loops e os registra no orchestration engine. Cada função deployada é uma skill durável que roda independentemente, disparável de um loop, agente, ou schedule, com retry próprio.
- Exemplo passo a passo de skill auto-construída: (1) humano expressa necessidade ("nossos serviços têm picos de latência à noite e ninguém percebe até de manhã"); (2) agente escreve duas funções (health check loop a cada 30min classificando saúde via LLM; incident triage skill correlacionando métricas com deploys recentes); (3) agente deploya — código é pego por um sidecar process, funções ficam live imediatamente, sem pipeline de deploy nem PR; (4) skill roda autonomamente; (5) agente itera com base em sinal — um review loop semanal lê o histórico de execuções, avalia taxa de sucesso/duração/correlação com incidentes reais, e se necessário invoca update da skill via LLM.
- Validação e conflitos: código gerado pelo agente pode ser type-checked e o próprio agente pode invocar a função para testá-la. Para conflitos (dois health checks detectando problema no mesmo serviço simultaneamente), o orchestrator usa concorrência tipo singleton — segundo triage espera o primeiro terminar, sem alertas duplicados.
- Observabilidade não é dashboard pendurado depois — é inerente à execução durável: cada `step.run()` é um checkpoint, cada checkpoint é observável. "Quando quem escreveu o código não é um humano, observabilidade não é nice-to-have, é a camada de confiança".

## Key insights
- Satya Nadella (citado) distingue "human capital" (conhecimento e julgamento construídos por anos) de "token capital" (workflows de IA, padrões de decisão, skills aprendidas construídas sobre modelos foundation) — os dois compõem juntos, e "uma empresa deveria poder trocar o modelo generalista sem perder a expertise de 'veterano da empresa' construída no sistema de aprendizado".
- Esse é exatamente o padrão de skill library: funções duráveis não se importam com qual LLM as chama — desacopla capacidade institucional de qualquer modelo específico.
- "Se suas skills morrem no restart do processo, o compounding reseta a zero" — frase que resume por que durabilidade é pré-requisito, não otimização, para qualquer estratégia de longo prazo baseada em agentes.
- Tabela de requisitos de durabilidade vs. falhas de um while-loop básico: retry independente por step, lifecycle de sub-agente (spawn/wait/cancel), entrega garantida de evento mesmo com processo fora do ar, observabilidade post-hoc, hot-deploy sem downtime, controle de concorrência — nenhum desses existe "de graça" num loop ingênuo.

## Exemplos e evidências
- Trechos de código TypeScript completos usando Inngest como orchestration engine: `infraHealthCheck` (cron de 30min + step.run + step.invoke condicional), `incidentTriage` (retries:3, múltiplos step.run, onFailure handler), `reviewSkillPerformance` (cron semanal, análise de performance, invoke condicional para atualizar a skill).
- Projeto real referenciado: github.com/inngest/utah — "agent harness construído sobre a orquestração durável do Inngest que também é orchestration-aware", com sidecar process que permite o agente principal escrever e editar funções Inngest no próprio workspace.
- Citação central de Van Horn: "Essas coisas têm que sobreviver a um restart."

## Implicações para o vault
Mapeia diretamente para a arquitetura de skills/loops/agentes deste vault: `04-SYSTEM/agents/` (skills do Claude Code) seria a Camada 2; cron jobs/scheduled tasks (`mcp__scheduled-tasks__*`, `CronCreate`) seriam a Camada 1; o que falta no setup atual é uma Camada 3 explícita de orquestração com checkpoint/observabilidade — hoje o "estado" do pipeline de ingest vive em logs ad-hoc (`/tmp/ingest_log_*.txt`) em vez de um orchestrator durável. Vale considerar se o sistema Nexus deveria formalizar checkpoints por step ao invés de logs append-only simples, especialmente para pipelines multi-arquivo como este batch de 12 fontes.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/concepts/agent-systems/agent-platform-architecture]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-orchestration]]
- [[03-RESOURCES/entities/Inngest]]

## Minha Síntese

**O que muda:** Identifica uma lacuna concreta no pipeline de ingest deste vault: hoje os logs (`/tmp/ingest_log_batch*.txt`) são append-only e não funcionam como checkpoints reais — se o processo falhar no meio de um batch de 12 fontes, não há como saber automaticamente "quais das 12 já foram totalmente processadas (incluindo concept absorption e archive)" sem reler o log manualmente.

**Conexão pessoal:** Conecta direto com o objetivo de "self-improving vault" e com o ADR-003 (model routing) — a arquitetura de 3 camadas (Loop/Skill/Orchestrator) é um vocabulário útil para descrever o que o Nexus já tenta fazer informalmente.

**Próximo passo:** Nenhum próximo passo imediato — vale revisitar quando o pipeline de ingest crescer a ponto de logs append-only deixarem de ser suficientes para recovery (ex.: batches de 50+ arquivos).
