---
title: "Hermes Kanban: Mission control for your Agents"
type: source
source: "Clippings/Hermes Kanban Mission control for your Agents.md"
source_url: "https://x.com/akshay_pachaar/status/2062526843564233040"
author: "@akshay_pachaar"
published: 2026-06-04
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, hermes-agent, kanban, multi-agent-orchestration, agent-coordination, telegram-gateway]
---

## Tese central

Agentes de IA prometiam funcionar como um time — dividir trabalho, retomar de onde o outro parou — mas na prática cada handoff é um "cold start" porque o agente seguinte não sabe o que o anterior construiu. Hermes Kanban resolve esse "shared-context problem" colocando agentes atrás de colunas de um quadro Kanban: cada task sobrevive a crashes/reboots, e cada handoff carrega exatamente o resumo de que o próximo agente precisa. O artigo é um walkthrough completo (~20 min) de como montar um time de 4 agentes (PM, backend, frontend, tester) que constrói software de ponta a ponta, operável inteiramente via Telegram.

## Argumentos principais

- **Por que um agente só não basta**: dividir "password reset" em backend (API), frontend (UI) e tester (E2E) é natural — mas rodar tudo num agente único enche a context window e o agente "perde o fio" do que fez 3 passos atrás. Você gasta mais tempo gerenciando do que economiza.
- **O problema real não é paralelismo, é contexto compartilhado**: separar agentes por domínio cria a pergunta "como o frontend sabe o que o backend construiu?" — esse é exatamente o problema que o Kanban resolve.
- **Modelo mental — quadro de tarefas com agentes nas colunas**: uma task tem título, descrição, dono e status; é movida pelo board até ser fechada. O board é a fonte única de verdade. Hermes Kanban mantém esse modelo humano e substitui pessoas por agentes atrás de cada coluna.
- **O resumo de handoff é "o insight inteiro"**: quando um agente termina, escreve um resumo — arquivos alterados, o que construiu, o que o próximo agente precisa saber. O próximo agente lê esse resumo antes de começar. É isso que transforma um grupo de agentes em time, não em estranhos.
- **Vocabulário de 6 colunas/estados**: Triage (ideias cruas, ainda sem spec completo), Todo (criada mas esperando dependência — não se move até o pai terminar), Ready (dependências cumpridas, esperando um agente pegar), In Progress (agente rodando ativamente), Blocked (agente bateu numa parede e sinalizou para humano — nada roda até desbloquear), Done (terminado, com histórico de execução, resumo e metadata preservados).
- **O orchestrator é o "PM" que nunca escreve código**: lê um objetivo de alto nível, checa quais agentes existem, quebra o objetivo em tasks linkadas, e se afasta. A regra que mais importa: checar quais profiles existem antes de criar tasks — o sistema silenciosamente ignora qualquer task cujo assignee não bate com um profile real, então o passo zero é sempre `kanban_list`.
- **Três padrões recorrentes de uso**:
  1. *Pipeline*: cada task depende da anterior (apenas a primeira começa em "ready"; o resto espera sua vez).
  2. *Human in the loop*: nem todo bloqueio é falha — às vezes o agente encontra um problema real e pára para perguntar (`kanban_block(reason=...)`); o humano vê no dashboard, verifica, corrige e desbloqueia (`hermes kanban unblock $IMPL`); o sistema reinicia o agente no próximo ciclo, que lê `kanban_show()` e sabe exatamente o que consertar — não começa do zero.
  3. *Triage specifier*: quando você só tem uma ideia rascunhada (ex.: "auth needs rate limiting"), o comando `specify` reescreve o título de três palavras numa task completa com objetivo, abordagem e critérios de aceite, antes de qualquer agente pegar.
- **Setup de quatro profiles em ~20 minutos**: `hermes profile create <nome> --clone` clona a config do profile default; cada agente recebe um SOUL.md com identidade fixa (quem é, como pensa); skills são instaladas por profile (ex.: `hermes -p backend-developer skills install InsForge/insforge-skills/insforge --force`).
- **Skills = "job training"**: passo-a-passo específico de como fazer certos tipos de trabalho. InsForge atua como camada de "backend context engineering" (open-source, Apache 2.0) usada pelo backend-developer; o Skills Hub do Hermes mantém **687 skills em 18 categorias**: 87 built-in, 79 opcionais, 16 da Anthropic (frontend-design, pdf, pptx, docx, mcp-builder...) e 505 da LobeHub.
- **Inicialização do board e gateway**: `hermes kanban init` cria `~/.hermes/kanban.db` (SQLite com toda task, contexto e histórico de execução); o chat gateway roda sob o profile do project-manager, conectado via bot do Telegram (token via @BotFather, user ID via @userinfobot), e roda 24/7 mantendo o sistema vivo e o PM acessível pelo celular.
- **Dashboard com WebSocket ao vivo**: `hermes dashboard` em `http://127.0.0.1:9119`; uma coluna por status, updates em tempo real sem refresh. "Lanes by profile" subagrupa a coluna Running por assignee (visualizar quem é dono do quê); "Nudge dispatcher" roda um ciclo imediatamente em vez de esperar 60s — útil logo após desbloquear uma task.
- **Três modos de falha a observar antes de carga séria**:
  1. *Database overload*: com 2-4 agentes em paralelo nunca acontece; com 10+ agentes escrevendo em alta frequência, o sistema desacelera — usar `hermes kanban dispatch --max 4`.
  2. *Scratch workspace deletion*: arquivos salvos em scratch workspace somem assim que a task é marcada "done" (scratch é apagado por design) — usar `worktree` para tarefas de código, ou colocar o caminho da pasta do projeto na descrição da task.
  3. *Local model saturation*: contra modelo local (Ollama, GPU local) o sistema pode lançar vários agentes ao mesmo tempo e sobrecarregar a GPU, disparando o auto-stop — para setups locais usar `hermes kanban dispatch --max 2`; modelos via API (Claude, GPT-4o) raramente têm esse problema.
- **"The full picture" — quatro peças, cada uma com um papel único**: SOUL.md é a identidade fixa do agente (quem é, como pensa); Skills são as instruções passo-a-passo para tipos específicos de trabalho; Memory é o que o agente sabe sobre o ambiente do usuário entre sessões; Kanban é a camada de coordenação — estado compartilhado, transferência de contexto e human-in-the-loop a qualquer momento.

## Key insights

- O verdadeiro gargalo de times multi-agente não é "dividir o trabalho" — é "transferir contexto sem perda" a cada handoff. Hermes Kanban resolve isso com o resumo obrigatório de `kanban_complete()` que o próximo agente lê antes de iniciar.
- Triagem (Triage → specify) é um mecanismo de "spec compiler": transforma rascunhos de três palavras em briefs completos com objetivo + abordagem + critérios de aceite, antes de qualquer execução começar — reduz drasticamente o "garbage in, garbage out" em pipelines autônomos.
- O human-in-the-loop não é tratado como exceção/falha, mas como padrão de primeira classe (`kanban_block` / `unblock`): o sistema é desenhado para parar e perguntar quando encontra um problema real, e retoma exatamente do ponto de bloqueio — sem perder contexto.
- A arquitetura inteira é "fail-safe by durability": toda task sobrevive a crashes e reboots porque vive em SQLite (`kanban.db`), não em memória de processo — alinhado com o princípio de "receipts beat vibes" já documentado em outras fontes Hermes do vault.
- A operação real do sistema é desenhada para "esquecer que o board existe": o usuário não roda comandos `kanban create` manualmente — apenas descreve o projeto ao PM via Telegram, e o PM traduz isso na sequência de comandos sob o capô. Isso é o oposto de "operar uma ferramenta": é "delegar uma intenção".
- O dimensionamento de paralelismo (`--max 2/4`) é um lembrete de que multi-agent não escala de graça — há limites reais de I/O (SQLite) e de hardware (GPU local) que precisam ser respeitados antes de "ligar tudo ao mesmo tempo".

## Exemplos e evidências

- Exemplo de decomposição típica de PM: criação de uma pipeline `backend → frontend → tester` com `kanban_create(parents=[...])` encadeados, terminando em `kanban_complete(summary="Created backend → frontend → QA dependency pipeline")`.
- Script de pipeline real via CLI: `hermes kanban create "Implement auth API" --assignee backend-developer --body "POST /register, POST /login, POST /refresh, POST /logout."` encadeado com `--parent $BACKEND` para frontend e tester, capturando IDs via `--json | jq -r .id`.
- Exemplo de bloqueio real: `kanban_block(reason="review-required: password strength check missing, reset tokens aren't single-use (can be replayed within 30 min)")` — mostra que o agente identifica problemas de segurança reais, não apenas erros técnicos triviais.
- Demonstração concreta: um clone funcional do Google Docs (com features de IA, backend "production ready") foi construído inteiramente por esse time de 4 agentes — prova de conceito do pitch "build a working software team in ~20 minutes."
- Números do Skills Hub: 687 skills totais / 18 categorias / 87 built-in / 79 opcionais / 16 oficiais Anthropic / 505 LobeHub — granularidade que mostra a escala do ecossistema de skills do Hermes.
- Quatro SOUL.md completos no artigo (project-manager, backend-developer, frontend-developer, tester) — cada um com 3-4 frases definindo identidade e escopo ("You do not write code yourself. You manage the work." / "You build and manage the entire backend using InsForge").

## Implicações para o vault

- Esta fonte é uma **continuação direta** de [[03-RESOURCES/sources/hermes-agent/hermes-kanban-field-manual-tonysimons]], já ingerida em 2026-05-31 — aquela cobre a operação tática diária do Kanban (debugging, "context soup", receipts vs. vibes); esta cobre o **setup arquitetural completo** (4 profiles, SOUL.md, skills, gateway, dashboard) e os modos de falha em escala.
- Confirma e aprofunda a seção "Multi-Agent via Kanban (v0.12.0+)" já presente em [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]] — esta fonte fornece o detalhe operacional que faltava (taxonomia das 6 colunas, os 3 padrões de uso, os 3 modos de falha) e pode enriquecer aquela seção.
- A separação explícita "SOUL.md = identidade / Skills = job training / Memory = conhecimento de ambiente / Kanban = coordenação" é um framework limpo de 4 camadas que mapeia quase 1:1 com como o vault já pensa agentes (CLAUDE.md ~ SOUL.md, skills/ ~ Skills, hot.md ~ Memory, e — ainda sem equivalente — Kanban como camada de coordenação multi-agente).
- O padrão "describe a goal to the PM via Telegram, and watch the board fill up" é a aplicação mais madura vista até agora do princípio "delegar intenção, não comandos" — reforça a tese (já presente em [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]) de que orquestração de qualidade depende de transferência de contexto sem perdas, não de paralelismo per se.
- Os números do Skills Hub (687 skills) são um dado novo de escala do ecossistema Hermes/LobeHub que pode atualizar [[03-RESOURCES/entities/hermes]].
- Nenhuma contradição encontrada com o conhecimento Hermes existente — esta fonte reforça e detalha o que já estava mapeado.

## Links
- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/sources/hermes-agent/hermes-kanban-field-manual-tonysimons]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
