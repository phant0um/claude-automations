---
title: "How to Build an AI Second Brain for Your OpenClaw/Hermes That Learns While You Sleep"
type: source
source: "Clippings/How to Build an AI Second Brain for Your OpenClawHermes That Learns While You Sleep  (full guide).md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
Quando você roda mais de um agent runtime (ex: Hermes + OpenClaw), cada um com sua própria memória, eles viram "duas pessoas mantendo diários separados" — a memória de longo prazo diverge entre runtimes, máquinas e sessões. A solução é uma terceira camada, **gbrain**, um knowledge layer estruturado e independente de runtime, onde cada página separa "Compiled Truth" (estado atual, sempre reescrito) de "Timeline" (log append-only de evidências).

## Argumentos principais
- **Três camadas que não devem se misturar**:
  1. **Runtime (Hermes/OpenClaw)** — quem acorda, executa, entrega. Hermes: bom para loops pessoais em cron fixo (resumo matinal, auditoria noturna, push para Telegram/Slack/CLI); tem memória própria via `MEMORY.md`/`USER.md` injetados no boot + `session_search`. Cron jobs do Hermes disparam sessão NOVA que não herda contexto do chat atual, e por padrão pula memory providers (`skip_memory=True`) — um job das 1h precisa carregar seu próprio contexto (prompt autocontido, `context_from`, workdir, ou leitura direta do gbrain).
  2. **Runtime memory** — memória de boot curta/longa de cada runtime. OpenClaw: `MEMORY.md` (camada curada compacta) + daily notes (camada de trabalho) + **Dreaming** (consolidação de memória em background, opt-in, off por padrão, com 3 fases Light/REM/Deep — só Deep escreve candidatos duráveis no `MEMORY.md`).
  3. **gbrain** — camada de conhecimento unificada, independente de qualquer runtime. Pode rodar sua própria ingestão/dream cycle/agente completo, mas aqui é usado só para UMA função: decidir como os eventos de hoje devem reaparecer amanhã.
- **Por que gbrain é necessário**: revisão noturna sozinha não é suficiente — o agente resume à noite, mas a próxima sessão nem sempre encontra esse resumo. Exemplo do artigo: lição registrada ("respostas a devs de alta confiança devem ser mais curtas e casuais, sem listas, sem over-explaining") fica presa no cron output ou daily memory de UM runtime — se outro runtime ou outra máquina pegar a tarefa depois, a lição se perde. Sincronizar `MEMORY.md` manualmente faz a memória "driftar" lentamente.
  - Se você roda só UM runtime, a memória dele já basta — gbrain resolve o problema de quando você roda 2+ ao mesmo tempo ou vai trocar de runtime no futuro.
- **Cinco "destinos" possíveis para qualquer informação**:
  - `daily log` — aconteceu hoje
  - `runtime memory` — esse runtime precisa saber no próximo boot (regra de comportamento)
  - `gbrain page` — estado atual de um objeto de vida longa (pessoa, empresa, projeto, conceito)
  - `open loop` — precisa ser revisitado em algum momento futuro (vira scheduled task)
  - `archive` — só valor histórico
  - Os dois que confundem as pessoas: "responder mais curto da próxima vez" → regra de comportamento (runtime memory). "Por que um dev específico é sensível a respostas de IA, o que aconteceu antes, estado atual da relação" → gbrain page. O primeiro é "como agir da próxima vez"; o segundo é "o que esse objeto É agora". Empurrar os dois pro `MEMORY.md` faz ele virar "mush" rápido.
  - Regra extra: lembretes vão para o scheduler, não para o brain. "Checar atualização de billing na quarta" = scheduled task/open loop; a página gbrain do cliente guarda só estado atual + evidência + boundary de ação. OpenClaw já separa isso: timing preciso → Scheduled Tasks; checagens periódicas com contexto completo → Heartbeat; follow-ups de curto prazo inferidos da conversa → commitments.
- **Estrutura de página gbrain (schema recomendado, GitHub garrytan/gbrain)**: cada página divide em DUAS metades separadas por `---`:
  - **Compiled Truth** (acima da linha): estado atual, sempre reescrito quando nova evidência muda a conclusão. Seções: State (What / Why it matters / Current owner / Current status / Confidence / Last updated), Open Threads (checklist de perguntas/coisas a checar), Operating Notes (o que observar, o que não fazer, quando perguntar a um humano).
  - **Timeline** (abaixo da linha): append-only, log de evidências — `YYYY-MM-DD | source | what happened | why it changed/did not change the current state`.
  - Pergunta "qual o estado atual" → lê acima. Pergunta "o que aconteceu" → lê abaixo. Resolve o problema central de memória de agentes: conclusões sozinhas não carregam confiança, e logs crus forçam o agente a re-raciocinar do zero toda vez.
- **7 regras de escrita no gbrain** (do schema recomendado):
  1. Ler o RESOLVER primeiro — pertence a pessoa, empresa, projeto, conceito, writing asset, ou inbox?
  2. Um objeto principal por página — não duplicar páginas para a mesma pessoa/empresa/projeto
  3. Metade superior é estado atual — não despejar log corrido em Compiled Truth
  4. Metade inferior só anexa evidência — Timeline é append-only, não apagar histórico
  5. Reescrever metade superior só quando nova evidência MUDA a conclusão; senão só adicionar à timeline
  6. Toda operating note precisa de escopo — se aplica a todas as tarefas, ou só a um canal/cliente/projeto?
  7. Memória sensível-a-ação precisa carregar boundaries — pode enviar? pode prometer? quando perguntar a um humano? quando expira?
  - A regra 7 é a mais importante: não escrever "Cliente A está com pressa" — escrever estado + source + scope + action boundary ("pode rascunhar resposta, mas não pode prometer prazo de fix") + expiry + next trigger.
  - Caveat: isso só registra o boundary para o agente LER — não é a camada de enforcement. Bloqueio real vem de configurações de aprovação do runtime, sandboxing, tool policy, ou config de scheduled task.
- **Memory Candidate card**: antes de promover algo a memória de longo prazo, o agente preenche um card: Source / What changed / Future task affected / Layer (runtime startup rule | gbrain page | open loop/scheduled task | archive) / Target page / Confidence / Expiry-action boundary / Decision. Força a pergunta "como isso vai mudar comportamento ou julgamento depois?" — se não consegue responder, não promove.
- **3 produtos do "nightly learning"**: (1) Candidate list — o que de hoje pode valer a pena guardar; (2) Promotion decision — qual camada cada candidato vai; (3) Wake-up diff — o que do estado atual mudou antes do agente de amanhã acordar. Em vez de "resuma o que aconteceu hoje", o prompt deve pedir: classificar eventos em daily log / runtime memory update / gbrain page update / open loop / archive, e para cada candidato declarar por que será reusado, se vai para runtime memory ou gbrain (cross-session/cross-runtime), se atualiza Compiled Truth ou só apende Timeline, e se tem condição de expiração.
- **5 perguntas para saber se o second brain está realmente construído**:
  1. O que uma sessão aprendeu ontem, uma sessão nova consegue usar hoje (mesmo runtime/máquina diferente)?
  2. Quando Dreaming/revisão noturna gera um candidato de longo prazo, ele é promovido a uma página gbrain que QUALQUER sessão acha?
  3. O estado atual de um objeto tem fonte única?
  4. Quando chega evidência nova, o sistema reescreve a conclusão da metade superior, em vez de só empilhar logs?
  5. Quando uma sessão nova acorda, ela consegue partir de um "wake-up pack" de ~200 linhas em vez de vasculhar 50 páginas de daily log?
  - Se as respostas são incertas, falta uma camada de conhecimento neutra de runtime — mais cron ou mais um plugin de memória não resolve.

## Key insights
- "Don't let your agent wake up every morning like it's day one" — a frase-resumo do problema que gbrain resolve.
- O autor é honesto sobre limitação: ainda não resolveu o "merge timing" de candidatos de dois runtimes — roda dois jobs noturnos em sequência e revisa manualmente uma vez antes de promover. A direção (camada de conhecimento independente de runtime) é o que importa, não a implementação atual.
- "Start here" — 3 ações concretas: (1) deixar a memória nativa de cada runtime como está, só canalizar candidatos de longo prazo para um arquivo compartilhado; (2) adicionar um RESOLVER ao gbrain (decide se info pertence a people/companies/projects/ideas/concepts/writing/sources/inbox antes de qualquer escrita); (3) escolher os 3 objetos mais mencionados e criar páginas gbrain primeiro (ex: `projects/x-manager.md`, `companies/openclaw.md`, `concepts/agent-memory.md`).

## Exemplos e evidencias
- Exemplo de incidente real: dev de alta confiança reagiu mal a uma resposta "AI-flavored"; a lição ficou presa em runtime memory de um único agent e se perdeu para outras sessões/máquinas.
- Exemplo de página gbrain de billing: "Customer A's billing issue is currently high priority" com Source (data + thread de suporte), Scope (billing/support replies), Action boundary (pode rascunhar resposta, não pode prometer prazo), Expiry (reescrever após billing owner atualizar status), Next trigger (checar antes de qualquer resposta relacionada a billing).

## Implicacoes para o vault
Esta fonte é a confirmação mais explícita encontrada até agora do padrão **Compiled Truth + Timeline** já documentado em [[03-RESOURCES/concepts/agent-systems/agent-shared-memory]] — o concept já cita gbrain como implementação de referência mas sem o detalhe da estrutura de página de duas metades, do RESOLVER, do Memory Candidate card, e das 7 regras de escrita. Adicionar essas referências ao concept existente.

Para o vault-michel:
- `04-SYSTEM/wiki/hot.md` já funciona como "compiled truth" compartilhado — o padrão Compiled Truth/Timeline valida essa escolha de design.
- O conceito de "Memory Candidate card" é aplicável ao processo de ingest: antes de promover algo de Clippings para um concept/entity permanente, perguntar "como isso muda comportamento/julgamento futuro?" — se não há resposta, não promove (mantém apenas no source page).
- "5 perguntas de teste" são um checklist útil para auditar a maturidade do sistema de memória do vault (ver [[04-SYSTEM/wiki/agent-registry]] / próxima revisão de `hill`).
- Não criar página gbrain separada agora — vault-michel já tem analógico (`hot.md` + sources + concepts); registrar via append no concept existente é suficiente.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-shared-memory]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
