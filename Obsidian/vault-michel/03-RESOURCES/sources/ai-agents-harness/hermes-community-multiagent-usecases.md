---
title: "Hermes Agent — Multi-Agent Orchestration, Personal AI OS e Case Studies (Comunidade)"
type: consolidated-source
created: 2026-06-14
updated: 2026-06-14
tags: [ai-agents, hermes-agent, kanban, multi-agent-orchestration, personal-os, second-brain, case-studies, nous-research]
---

## Tese central

Consolidação de 14 fontes da comunidade (Reddit/X/blogs) sobre como o Hermes Agent é usado em produção fora dos docs oficiais: orquestração multi-agente via Kanban, arquiteturas de "personal AI OS"/second brain compartilhado, e case studies concretos (trading, automação de vídeo/ads, analyst pessoal). Padrão recorrente: Hermes funciona melhor como **camada de coordenação/contexto persistente** sob outro agente executor (Claude Code) ou como hub que orquestra ferramentas externas via skills/MCP — não necessariamente como "o agente que faz tudo".

---

## Kanban Multi-Agent Board (relatos de campo)

Duas fontes documentam o Hermes Kanban em uso real, complementando (sem repetir) as 9 pages oficiais já consolidadas.

### "Context soup" e receipts vs. vibes (field manual)

O argumento central de [[03-RESOURCES/sources/ai-agents-harness/hermes-kanban-field-manual-tonysimons|hermes-kanban-field-manual-tonysimons]]: "one agent is the wrong unit" — sessões longas acumulam **context soup** (estado residual que causa falhas silenciosas), e o board substitui isso por contratos explícitos e "receipts" rastreáveis.

Taxonomia de estados que **não são sinônimos**: *Triage* (spec ainda é mush), *Blocked* (decisão humana falta), *Scheduled* (tempo é a dependência), *Running* (processo vivo agora). TTL nos claims (`hermes kanban claim <id> --ttl 900`) funciona como lease, não propriedade — evita "ghost locks".

Três "dumb failures" recorrentes que comem tardes inteiras:
1. **Wrong board** — terminal apontado para o board errado
2. **Scratch ghost** — output cai num diretório temporário que ninguém revisita
3. **Stale lock** — card mostra "running" mas o processo já morreu

Sequência de debugging recomendada: `boards show → show → runs → log --tail 4000 → tail → pgrep → reclaim` se necessário. `--default-workdir` no board resolve boa parte do "where did the files go?".

### Setup completo de 4 agentes via Telegram (mission control)

[[03-RESOURCES/sources/ai-agents-harness/hermes-kanban-mission-control-for-your-agents|hermes-kanban-mission-control-for-your-agents]] é continuação direta da fonte acima — cobre o **setup arquitetural completo**, não a operação tática.

- **6 colunas/estados do board**: Triage → Todo → Ready → In Progress → Blocked → Done. Todo não se move até o pai terminar; Blocked pausa tudo até intervenção humana.
- **Handoff summary = "o insight inteiro"**: cada agente, ao terminar, escreve um resumo (arquivos alterados, o que construiu, o que o próximo precisa saber) — isso é o que transforma um grupo de agentes isolados em um time.
- **Orchestrator = "PM que nunca escreve código"**: lê objetivo de alto nível, checa `kanban_list` (profiles existentes), quebra em tasks linkadas e se afasta. Regra crítica: o sistema silenciosamente ignora tasks cujo assignee não bate com um profile real — `kanban_list` é sempre o passo zero.
- **3 padrões recorrentes de uso**: (1) *Pipeline* — cada task depende da anterior; (2) *Human in the loop* — `kanban_block(reason=...)` não é falha, é comportamento de primeira classe; humano vê no dashboard, corrige, `unblock`, e o agente retoma exatamente do ponto de bloqueio; (3) *Triage specifier* — comando `specify` transforma uma ideia de três palavras numa task completa com objetivo/abordagem/critérios de aceite, antes de qualquer execução.
- **Setup de 4 profiles em ~20 min**: `hermes profile create <nome> --clone`; cada agente recebe SOUL.md próprio + skills instaladas por profile (ex: backend-developer recebe skills InsForge). Demo real: clone funcional do Google Docs construído end-to-end por PM/backend/frontend/tester.
- **Dashboard ao vivo** (`hermes dashboard`, `127.0.0.1:9119`, WebSocket): "Lanes by profile" mostra quem é dono do quê na coluna Running; "Nudge dispatcher" força um ciclo imediato em vez de esperar 60s.
- **3 modos de falha antes de escalar**: (1) database overload com 10+ agentes — usar `hermes kanban dispatch --max 4`; (2) scratch workspace é apagado quando a task vira "done" — usar `worktree` ou apontar caminho do projeto na descrição; (3) modelo local (Ollama/GPU) satura com paralelismo alto — `--max 2` para setups locais; modelos via API raramente têm esse problema.
- **Framework de 4 camadas**: SOUL.md (identidade fixa) / Skills (job training passo-a-passo) / Memory (conhecimento de ambiente entre sessões) / Kanban (coordenação — estado compartilhado + handoff + human-in-the-loop a qualquer momento). Mapeia quase 1:1 com CLAUDE.md ~ SOUL.md, skills/ ~ Skills, hot.md ~ Memory — Kanban é a camada que o vault ainda não tem equivalente.
- Dado de escala: **Skills Hub com 687 skills em 18 categorias** (87 built-in, 79 opcionais, 16 Anthropic, 505 LobeHub).

---

## Paperclip / Agent Army

### Paperclip + Hermes: scheduler vs executor (10 agentes em paralelo)

[[03-RESOURCES/sources/ai-agents-harness/paperclip-hermes-10-agents|paperclip-hermes-10-agents]] documenta uma arquitetura distinta do Kanban nativo: **Paperclip = scheduler** (task queue, agent pool management, rate limiting, retry com backoff, result aggregation — "infra pura, sem inteligência de tarefa"); **Hermes = executor** (context management isolado por agente, tool execution, error handling, output formatting). Os dois nunca se misturam.

- **Control room UI**: para cada um dos 10 agentes mostra status, tarefa, progress, output parcial em stream, custo acumulado em tokens. Três modos de interação: *supervisão passiva* (só observar), *intervenção cirúrgica* (pausar/modificar/retomar 1 agente sem afetar os outros 9), *escalation* (Hermes escala ambiguidade não-resolvível para o control room).
- **Por que 10, especificamente**: ponto empírico de equilíbrio — abaixo de 5, paralelismo insuficiente; 10-15 é a "zona de eficiência" (humano supervisiona sem overwhelm); acima de 20, supervisão humana inviável e exige meta-agente. "10 agentes" é limite **ergonômico**, não técnico.
- **Isolamento de contexto é o enabler real**: sem isolamento total, agentes interferem entre si e a coerência colapsa. O gargalo prático não é o scheduler (que pode orquestrar "1000 agentes" teoricamente) — é custo de tokens × paralelismo, uma decisão econômica.
- **4 casos de uso demonstrados**: research paralelo (10 tópicos → relatório agregado), batch processing (10 docs em paralelo), A/B de abordagem (5 agentes estratégia A vs 5 estratégia B, comparação revela a melhor), pipeline com estágios (output de um alimenta o próximo).
- **Trade-off paralelo vs sequencial**: 10 tarefas sequenciais = 10× latência, 1× custo; em paralelo = ~1× latência, 10× custo. Paralelo vale quando tarefas são independentes, latência é crítica, ou há deadline de batch. Sequencial vale quando há dependência real, custo é constraint primário, ou volume é pequeno.
- Limitação não resolvida nativamente: **state compartilhado entre agentes paralelos** requer coordenação extra (shared memory/mensageria) — a arquitetura Paperclip+Hermes não resolve isso por si.

### Hermes Agent Army: os 5 pilares e deployment Docker

[[03-RESOURCES/sources/ai-agents-harness/hermes-agent-army-nateherk|hermes-agent-army-nateherk]] (de @nateherk) descreve outra dimensão de "exército de agentes": não paralelismo de tarefa única, mas **uma frota de agentes especializados, cada um em seu próprio container**, gerenciada por um meta-agente.

- **5 pilares**: Memory (`user.md` preferências estáticas + `memory.md` contexto dinâmico de negócio — carregamento seletivo, nunca segredos pois vão para git), Skills (91 built-in + 520+ community hub, progressive disclosure via `trigger` explícito no front-matter), Soul (`soul.md` define personalidade por instância — tom, como lida com ambiguidade, quando escala vs assume), Crons (linguagem natural → cron; flags `CONTEXTFROM`/`WORKDIR`/`NOAGENT` — `NOAGENT` roda tasks puramente operacionais sem LLM, economizando tokens), Self-Improving Loop (trabalho → feedback → memory → padrão repetitivo → vira skill).
- **Deployment**: VPS Hostinger KVM2 (precisa ser **KVM**, não OpenVZ — OpenVZ não suporta Docker por limitação de kernel namespace), Mac Mini, ou Docker. Um container por agente = isolamento de credenciais (.env próprio), portabilidade (mesmo compose file roda em qualquer host), rollback granular sem afetar outros agentes.
- **Padrão "assistant for the assistant"**: gerenciar a frota via um projeto Claude Code dedicado (`vps-agents`) com acesso SSH ao VPS — meta-agente com permissões mais amplas que qualquer agente individual, mas escopadas ao VPS da frota, não ao resto dos sistemas.
- **Regra prática de manutenção**: "errou duas vezes no mesmo ponto → criar skill" (segundo erro confirma que não era ruído); "stale memory = causa #1 de comportamento estranho".
- **Comparativo Hermes vs Claude Code vs OpenClaw**: Claude Code = terminal, foco coding desk, contexto por sessão, `/loop`. Hermes = Telegram/CLI, foco on-the-go + crons nativos, contexto persistente via `memory.md`, 140K stars (no momento da fonte). OpenClaw = CLI, on-the-go, contexto persistente, 350K stars.
- **Comparação explícita com vault-michel**: Hermes Army distribui contexto (cada agente = própria memória); vault-michel centraliza (hot.md + AGENTS.md = estado compartilhado). Distribuída permite especialização mais profunda; centralizada facilita consistência entre agentes — trade-off, não veredito.

### Auto-think / Auto-build: o "buildroom" como padrão de self-improvement seguro

[[03-RESOURCES/sources/ai-agents-harness/hermes-agent-auto-think-auto-build-gkisokay|hermes-agent-auto-think-auto-build-gkisokay]] (de @gkisokay) descreve uma arquitetura de "agent army" orientada a **self-improvement com guardrails**, separando descoberta de execução em dois lanes com gate explícito.

- **Split Auto-think (Dreamer) / Auto-build**: Dreamer faz intake de ideias (pesquisa, pressão do sistema, runs falhos, retenção) → gera *idea contracts* candidatos. Auto-build é o loop verificado: Main → Coder → QA → Trust → Retention → Operator. "Dreamer pode dizer 'tem calor aqui.' Main decide se o calor é real."
- **Cadeia de contratos JSON** (handoff sequence): `research-input → idea-contract → intent-review → main-review → product-plan → build-plan → verification → qa-verification → verification-delta → trust-report → retention-review → operator-summary`. São **pre-execution commitments**, não logs post-hoc — qualquer ação do Coder precisa de main-review aprovado + build-plan + verification-report, ou "nunca aconteceu oficialmente".
- **Verification Delta** (o mecanismo mais forte): em vez de "os testes passaram?", pergunta "a evidência do Coder e do QA concordam?". Estados: `confirmed` (mesma conclusão por caminhos independentes), `drift` (QA achou comportamento diferente do relatado — informação de melhoria, não só falha), `regression` (algo que funcionava parou), `missing_evidence` (build rejeitado por falta de artefatos verificáveis).
- **Guardrails explícitos**: Dreamer não aprova o próprio trabalho; Coder não expande escopo silenciosamente; QA não valida sem verificação independente (não vê o resumo do Coder); Retention não deleta estado vivo sozinha; Control Room não esconde incerteza.
- **Comparação com outros frameworks** — nenhum dos comparáveis (AutoGPT básico, LangGraph típico) tem separação explícita discovery/build com gate + verification delta + QA cego ao resumo do Coder simultaneamente.
- **Aplicação proposta ao vault-michel**: Dreamer = novo conteúdo em `Clippings/`/`00-INBOX/`; Main = triagem (ingestão completa vs resumo vs descarte); Coder = skill `wiki-ingest`; QA = checagem de wikilinks + hot.md + manifest; Trust = score de cobertura por área; Retention = consolidar vs manter separado. Formalizar esses contratos de handoff seria a próxima evolução de maturidade do pipeline de ingest.

---

## Personal AI OS / Second Brain

### As 13 camadas arquiteturais e o efeito composto (análise honesta v0.16.0)

[[03-RESOURCES/sources/ai-agents-harness/hermes-agent-personal-ai-os|hermes-agent-personal-ai-os]] é a fonte mais densa do lote — análise de 44KB do Hermes v0.16.0 mapeando 13 camadas para analogias de SO (Memory↔RAM+disk, Profiles↔process isolation, Kanban↔scheduler, Cron↔scheduler daemon, /goal↔long-running process com judge model, Skill Creation↔macro system, Autonomous Curator↔garbage collector com ciclo de 7 dias, Tool Search↔dynamic linker, Gateway↔network stack via SSEP, Voice↔I/O layer, Security 4 camadas↔kernel security, Skills Hub/MCP Catalog↔package manager com 19.932 skills, Interface↔shell+display server).

- **Tese central**: Hermes é "infrastructure que melhora com uso" — efeito composto que **não pode ser replicado** trocando para um modelo mais forte com contexto em branco. Progressão documentada: dia 1 (blank slate) → semana 2 (tarefas de 10 mensagens caem para 3) → mês 1 (15-20 skills criadas, tarefas de 20 turnos caem para 5) → mês 3 (40+ skills + deep memory). **Dado quantificado: agentes com 20+ skills auto-criadas terminam tarefas similares ~40% mais rápido que instâncias frescas.**
- **Token economics**: sistema completo (5 crons diários + 2 sessões /goal + research sub-agent + kanban) = ~10-11M tokens/mês. Custo: GPT-5.5 (~$27/mês) vs Claude Sonnet 4 (~$85) vs Claude Opus 4 (~$250). Caminho mais barato: tudo via GPT-5.5, reservando Opus só para o /goal diário onde profundidade de raciocínio compensa.
- **6 métodos de otimização de tokens**: compact file reader (-14% por leitura), prompt caching (~-75% em sessões multi-turn), `/compress`, Tool Search (schemas on-demand), subagent delegation (só sumários retornam ao contexto principal), retrieval-based memory (Mem0: -72% tokens vs injeção completa).
- **Posicionamento vs. frameworks**: Claude Code = daily driver de desk, melhor coding depth; Hermes = infraestrutura 24/7, vence quando histórico importa (14/18 benchmarks vs Claude Code, segundo a fonte); OpenClaw = chat-first, maior marketplace, melhor UX não-técnica; CrewAI = orchestration framework Python, não standalone. `hermes claw migrate` é comando de migração nomeado de concorrente específico — positioning inequívoco.
- **SSEP (Structured Stream-Event Protocol, v0.16.0)**: gateway emite eventos típados (MessageChunk, ToolCallFinished etc.) → adapters por plataforma, cada um renderiza o que pode e descarta o resto silenciosamente.
- **Tool Search resolveu o "context window problem" de MCPs**: 15+ MCP servers normalmente consomem o contexto inteiro em schemas; Tool Search reduz para ~3 bridge tools (~300 tokens). Accuracy sobe de 49%→74% (testes Anthropic Opus 4).
- **Profiles distribuíveis via git**: skills, soul.md e workflows são portáveis entre máquinas; memórias e sessões ficam local. Transforma Hermes em plataforma de distribuição de "configurações de agente".
- **Memory providers plugáveis** (8 externos): Mem0 (knowledge graph, -72% tokens), Honcho (memória dialética USER+AI separada, self-host para PII), Hindsight, Holographic, RetainDB, ByteRover, Supermemory, OpenViking. Limites configuráveis: `memory_char_limit: 2200` chars (~800 tokens), `user_char_limit: 1375` (~500 tokens).
- **Human oversight nativo**: estado "Blocked" no Kanban + botões de aprovação Telegram/Slack + `/undo N` (v0.16.0) = pause-and-resume com contexto preservado, não ad-hoc.
- **Workflow real de 1 dia citado** (~$2-4 total, 9 camadas): cron 8h dispara content-lead profile com /goal → 3 sub-agentes paralelos (trending + performance + competitor check) → Tool Search carrega só schemas necessários → Kanban tracked → skill `content-post` gera 2 drafts → Telegram aprova 1/rejeita 1 → publica via xurl → webhook de competidor gera follow-up → cron 23h faz revisão diária + session recall + sumário Telegram.
- **Citações de operadores reais**: Johnny (Nous Research) — planning session matinal + cron às 23h que confere "did you do what you wanted to do", virou infraestrutura permanente a partir do uso. Karan (treinou os primeiros modelos Hermes) — "I really hate doing ablations. [...] Hermes does it now."
- **Limitações honestas (jun/2026)**: Desktop App sem paridade total com CLI para browser automation; concorrência de agentes pressiona context window e custo; profile isolation é funcional mas não robusta como process isolation de SO real; qualidade de skill criada automaticamente varia, curation humana ainda ajuda; auto-compaction em sessões longas pode causar context loss; SSEP é novo e tem edge cases em plataformas menos comuns.
- **Contradições não resolvidas registradas na própria fonte**: 687 skills (masterclass anterior) vs 19.932 skills nesta fonte — possivelmente o segundo número é o MCP Catalog total, não o Skills Hub Hermes-específico; star count do Hermes permanece inconsistente entre fontes (73k vs 150k).

### Hermes + Obsidian Vault = AI Brain (setup externo equivalente)

[[03-RESOURCES/sources/ai-agents-harness/hermes-agent--obsidian-vault--ai-brain|hermes-agent--obsidian-vault--ai-brain]] descreve um setup Obsidian+Hermes que é, na prática, **uma versão externa do que vault-michel já implementa** — com Hermes no lugar de Claude Code.

- **Princípio central**: vault = camada de memória legível por humanos (markdown como source of truth inspecionável); Hermes lê, age via ferramentas/crons, e escreve resultados de volta. Filesystem MCP com boundary explícito — Hermes acessa só a pasta do vault, nunca o laptop inteiro ("diferença entre ferramenta útil e agente assustador").
- **Regra de ouro**: primeiros 7 dias **output-only** em `05-HERMES-OUTPUTS/` — não deixar o agente espalhar arquivos pelo vault antes do sistema ser confiável. Construir um workflow por vez, não sete automações no dia 1.
- **Estrutura mínima sugerida**: `00-INBOX → 01-DAILY → 02-PROJECTS → 03-NOTES → 04-RESOURCES → 05-HERMES-OUTPUTS (briefings/inbox/projects/research/reviews) → 06-SYSTEM (CLAUDE.md, templates/)`. `06-SYSTEM/CLAUDE.md` é o "steering file" que toda skill recorrente consulta — atualizado semanalmente.
- **5 workflows recomendados em ordem**: (1) morning brief — prova o loop completo; (2) inbox processor — propõe filing, não move automaticamente na primeira semana; (3) project health check — revela onde o usuário está se enganando; (4) weekly synthesis — conecta daily notes + projects + outputs; (5) connection finder — sugere wikilinks via relatório, humano decide.
- **Safety setup**: filesystem MCP escopado só ao vault, proibir deleção nos primeiros dias, exigir review para mudanças de status de projeto e conteúdo sensível, segredos nunca entram no vault.
- Comando de instalação Hermes: `curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash`. MCP setup: `hermes mcp add obsidian_fs --command npx --args -y @modelcontextprotocol/server-filesystem "/path/to/vault"`.

### gbrain: knowledge layer independente de runtime para Hermes+OpenClaw

[[03-RESOURCES/sources/ai-agents-harness/gbrain-shared-second-brain-hermes-openclaw|gbrain-shared-second-brain-hermes-openclaw]] aborda o problema de **rodar 2+ agent runtimes** (Hermes + OpenClaw) que viram "duas pessoas mantendo diários separados" — memória de longo prazo diverge entre runtimes/máquinas/sessões.

- **3 camadas que não devem se misturar**: (1) Runtime (Hermes/OpenClaw — quem executa; cron jobs do Hermes disparam sessão nova que **não herda contexto do chat atual** e por padrão pula memory providers `skip_memory=True` — um job das 1h precisa de contexto autocontido via `context_from`/workdir/leitura direta do gbrain); (2) Runtime memory (MEMORY.md/USER.md de cada runtime — camada curada compacta + daily notes + Dreaming opt-in com fases Light/REM/Deep, só Deep escreve no MEMORY.md); (3) gbrain — camada unificada cuja única função aqui é decidir como eventos de hoje reaparecem amanhã.
- **5 destinos possíveis para qualquer informação**: daily log (aconteceu hoje), runtime memory (regra de comportamento — "responder mais curto da próxima vez"), gbrain page (estado de objeto de vida longa — pessoa/empresa/projeto/conceito), open loop (scheduled task futura), archive (só valor histórico). Confundir os dois primeiros ("como agir" vs "o que esse objeto É agora") faz o MEMORY.md virar "mush".
- **Estrutura de página gbrain** (schema garrytan/gbrain): cada página dividida por `---` em **Compiled Truth** (acima — estado atual sempre reescrito: State/Open Threads/Operating Notes) e **Timeline** (abaixo — append-only, `YYYY-MM-DD | source | what happened | why it changed/did not change`).
- **7 regras de escrita**: (1) RESOLVER primeiro — a quê pertence (pessoa/empresa/projeto/conceito/writing asset/inbox); (2) um objeto principal por página; (3) metade superior = estado atual, não log corrido; (4) metade inferior só anexa; (5) reescrever superior só quando evidência nova MUDA a conclusão; (6) toda operating note precisa de escopo declarado; (7) memória sensível-a-ação precisa de action boundary explícito (pode enviar? pode prometer? quando perguntar a humano? quando expira?) — caveat: isso é só o agente LER o boundary, enforcement real vem de config de aprovação/sandboxing/tool policy.
- **Memory Candidate card**: antes de promover algo a memória de longo prazo — Source / What changed / Future task affected / Layer / Target page / Confidence / Expiry-action boundary / Decision. Se não consegue responder "como isso muda comportamento futuro?", não promove.
- **5 perguntas de teste para "second brain está construído"**: (1) o que uma sessão aprendeu ontem, uma sessão nova usa hoje (mesmo runtime, máquina diferente)? (2) candidato de Dreaming é promovido a página que QUALQUER sessão acha? (3) estado atual de um objeto tem fonte única? (4) evidência nova reescreve a conclusão em vez de só empilhar logs? (5) sessão nova consegue partir de um "wake-up pack" de ~200 linhas em vez de vasculhar 50 daily logs?
- **Honestidade do autor**: "merge timing" de candidatos de 2 runtimes ainda não resolvido — roda 2 jobs noturnos em sequência e revisa manualmente antes de promover. "Start here": (1) deixar memória nativa como está, canalizar só candidatos de longo prazo para arquivo compartilhado; (2) adicionar RESOLVER ao gbrain; (3) criar páginas gbrain para os 3 objetos mais mencionados primeiro.
- **Aplicação ao vault-michel**: `hot.md` já funciona como "compiled truth" compartilhado — valida essa escolha. Memory Candidate card é aplicável ao ingest: antes de promover de Clippings para concept/entity permanente, perguntar "como isso muda comportamento/julgamento futuro?". As 5 perguntas de teste servem como checklist de auditoria de maturidade do sistema de memória do vault.

---

## Case studies: trading bot, viralbuilder, analyst pessoal

### Trading agent self-improving (Hermes + Claude + Mac Mini M4)

[[03-RESOURCES/sources/ai-agents-harness/i-built-a-self-improving-ai-trading-agent-with-hermes-it-learns-from-every-trade-and-fixes-itself|i-built-a-self-improving-ai-trading-agent-with-hermes]]: stack = **Hermes (self-learning engine, memória persistente) + Claude (analyst/strategy writer) + Mac Mini M4 (compute local) + Railway (fallback hosting)** + live market feeds + news APIs.

- Loop completo: estratégia → trades → resultados → análise → estratégia melhorada, em ciclo contínuo sem supervisão manual constante.
- **4 regras obrigatórias** para trading agents sérios: accuracy (dados limpos), reliability (24/7 sem depender do laptop ligado), defined goal (targets numéricos explícitos), self-improvement (reescreve a própria estratégia).
- **Metas numéricas concretas citadas**: +47% retorno em 30 dias, Sharpe mínimo 1.0, max drawdown definido, ciclo de reflexão a cada poucos dias.
- **Frequências do ciclo**: 30min (estratégia checa mercado) / diário (reshuffle de posições) / semanal (Hermes revisa todos os trades e reescreve parâmetros).
- Hermes gerencia conhecimento via **keep/archive/rollback** — nada é irreversível, permite experimentação segura.
- Escala de dados: **1.5M+ data points** e crescendo continuamente via market feeds.
- Human-in-the-loop no nível certo: usuário aprova as melhorias propostas, mas não as executa manualmente.
- Citação-resumo: "The holy grail of AI trading was always an agent that learns from its own mistakes. For years it was too complex to build. Now it takes a weekend."
- Mac Mini M4 roda 24/7 "por alguns dólares por mês em eletricidade" — eliminando cloud bills, com Railway só como fallback.

### Stack de produção de vídeo/ads: Hermes + Claude + Higgsfield + ViralBuilder

Duas fontes do mesmo autor (@kidpakerot) descrevem o mesmo stack em níveis diferentes de detalhe:

- [[03-RESOURCES/sources/ai-agents-harness/clipping-kidpakerot-hermes-claude-higgsfield-viralbuilder-stack|clipping-kidpakerot-hermes-claude-higgsfield-viralbuilder-stack]] (versão completa): pipeline de 4 ferramentas para produção de vídeo-ad e-commerce — **ViralBuilder** (pesquisa de mercado/formatos vencedores, similar a Gethookd) → skill Claude `video-prompt-builder` (traduz briefing criativo em prompt shot-by-shot estruturado) → **Higgsfield MCP** (renderiza o vídeo) — tudo orquestrado de uma sessão Claude Code com **Hermes como camada de contexto/memória/routing**: carrega contexto de marca, armazena skills, define regras de roteamento, garante que Claude "sempre entra informado".
  - Skill `video-prompt-builder` gera 4 seções fixas: shot-by-shot effect timeline, master effect inventory, effect density map, energy arc — formatadas para o pipeline de renderização do Higgsfield.
  - **Claim de ROI**: produção de ad e-commerce cai de meio-dia + $500–$2.000/criativo para **10 minutos a custo de assinatura**.
  - Higgsfield conecta via MCP em `https://mcp.higgsfield.ai/mcp` (Claude Code → Settings → Connectors). Um único prompt encadeado dispara as 4 ferramentas: research → brief → prompt → render.
- [[03-RESOURCES/sources/ai-agents-harness/clipping-post-kidpakerot-hermes-higgsfield|clipping-post-kidpakerot-hermes-higgsfield]] (post original em português, menos detalhado): mesma stack — Hermes + Claude + Higgsfield via MCP para produção shot-by-shot, ViralBuilder para pesquisa de ângulo criativo. Sem dados adicionais além do já coberto acima — manter apenas como referência ao post original.

### Analyst pessoal e setups de roteamento de custo (clippings curtos)

Três clippings de baixa-confiança (`misc-low-confidence/`), cada um registrando um padrão de uso pessoal distinto, sem profundidade analítica adicional — citados aqui para referência cruzada:

- [[03-RESOURCES/sources/misc-low-confidence/clipping-hermes-ultimate-analyst|clipping-hermes-ultimate-analyst]] (@0xJeff): Hermes como analista de investimento pessoal — briefings diários via X API, monitoramento Polybond/Polymarket, tracking de tese de investimento. Stack de modelo: DeepSeek API + assinatura Claude; OpenWebUI para outputs visuais.
- [[03-RESOURCES/sources/misc-low-confidence/clipping-what-i-use-hermes-agent-for|clipping-what-i-use-hermes-agent-for]] (@vmiss33): setup multi-agente pessoal com **roteamento por custo** — Tech Research Agent (MiniMax M2.7), Tech Task Master (GPT 5.5), Lifestyle Agent (Nemotron 3 free), Research Agent (Qwen 3.5 9B local). Filosofia de cost-minimization via escolha de modelo por papel — é uma instância concreta do "token economics"/model routing discutido em maior detalhe na fonte Personal AI OS acima.
- [[03-RESOURCES/sources/misc-low-confidence/post-by-aurimas-gr-on-x|post-by-aurimas-gr-on-x]] (@Aurimas_Gr): nota breve com tese "AI Agent Memory = peça central do context engineering" — sem insights detalhados preenchidos na fonte original (placeholder "insight pendente"). Relevante apenas como ponteiro de tema (memory architecture), já coberto em profundidade pelas fontes de gbrain e Personal AI OS acima.

---

## Síntese: padrões recorrentes entre as 14 fontes

1. **Coordenação > paralelismo bruto**: tanto o Kanban field manual quanto o Paperclip/10-agentes concordam que o gargalo real não é "quantos agentes rodam ao mesmo tempo", mas como o contexto/estado sobrevive entre handoffs — seja via board (Kanban), seja via isolamento rígido + agregação (Paperclip).
2. **Human-in-the-loop como feature de primeira classe, não exceção**: `kanban_block`/`unblock`, "Blocked" state, `/undo N`, control room de intervenção cirúrgica, e aprovação de trades/posts — todos tratam o ponto de decisão humana como parte do design, não como fallback de erro.
3. **Self-improvement com guardrails**: Auto-think/Auto-build (contratos JSON + verification delta), trading agent (keep/archive/rollback), e o Autonomous Curator da fonte Personal AI OS são implementações distintas do mesmo princípio — melhoria contínua só é segura com checkpoints reversíveis e verificação independente.
4. **Vault/markdown como substrato compartilhado**: tanto "Hermes + Obsidian = AI Brain" quanto gbrain assumem que a camada de conhecimento de longo prazo deve ser markdown legível, versionável, independente do runtime — exatamente a aposta arquitetural de vault-michel.
5. **Token economics como decisão de design, não otimização tardia**: routing por modelo (GPT-5.5 para crons/triage, Opus para reasoning profundo) aparece em 3 fontes independentes (Personal AI OS, trading agent via Mac Mini local, "what I use Hermes for" com 4 modelos por papel).

---

## Fontes consolidadas

- [[03-RESOURCES/sources/ai-agents-harness/hermes-kanban-field-manual-tonysimons]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-kanban-mission-control-for-your-agents]]
- [[03-RESOURCES/sources/ai-agents-harness/paperclip-hermes-10-agents]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-army-nateherk]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-auto-think-auto-build-gkisokay]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-personal-ai-os]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent--obsidian-vault--ai-brain]]
- [[03-RESOURCES/sources/ai-agents-harness/gbrain-shared-second-brain-hermes-openclaw]]
- [[03-RESOURCES/sources/ai-agents-harness/i-built-a-self-improving-ai-trading-agent-with-hermes-it-learns-from-every-trade-and-fixes-itself]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-kidpakerot-hermes-claude-higgsfield-viralbuilder-stack]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-post-kidpakerot-hermes-higgsfield]]
- [[03-RESOURCES/sources/misc-low-confidence/clipping-hermes-ultimate-analyst]]
- [[03-RESOURCES/sources/misc-low-confidence/clipping-what-i-use-hermes-agent-for]]
- [[03-RESOURCES/sources/misc-low-confidence/post-by-aurimas-gr-on-x]]
