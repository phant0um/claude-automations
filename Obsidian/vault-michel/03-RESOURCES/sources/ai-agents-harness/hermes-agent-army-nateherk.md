---
title: "From Zero to Ultimate Hermes Agent Army"
type: source
source_file: Clippings/From Zero to Ultimate Hermes Agent Army.md
origin: artigo
author: "@nateherk"
published: 2026-05-09
ingested: 2026-05-14
tags: [agent, hermes, skill-library, crons, self-improvement, vps, docker]
triagem_score: 8
---

# From Zero to Ultimate Hermes Agent Army

> [!key-insight] Core insight
> Hermes é um agente pocket-first, voice-first, com crons e self-improving loop — complementar ao Claude Code, não substituto. O unlock central: context (skills + memory + soul) fica em git, portável entre qualquer agente.

## Os Cinco Pilares

1. **Memory** — `user.md` (preferências pessoais) + `memory.md` (contexto de negócio); carregados automaticamente na sessão; nunca coloque segredos aqui
2. **Skills** — playbooks reutilizáveis como `skill.md` com YAML front-matter que dispara carregamento condicional (progressive disclosure); 91 built-in + 520+ na community hub
3. **Soul** — `soul.md` define personalidade do agente; cada instância pode ter vibe diferente (conciso, sarcástico, formal)
4. **Crons** — automações agendadas em linguagem natural; cada cron roda em sessão isolada; flags: `CONTEXTFROM`, `WORKDIR`, `NOAGENT`
5. **Self-Improving Loop** — trabalho → feedback → salvar em memory → padrões repetitivos → transformar em skill

## Arquitetura de Deployment

- VPS (Hostinger KVM2, Ubuntu 24.04) ou Mac Mini ou Docker container
- Docker por padrão: cada agente tem seu próprio container, `.env`, keys, memória isolada
- Telegram como interface principal on-the-go; CLI para deep work
- GitHub backup nightly: skills + memory em repo privado (nunca commita segredos)

## Gestão Multi-Agent

- Um agente por Docker container, cada um com credenciais escopadas (least-privilege)
- Separar quando: precisa de credenciais/secrets próprios, memória longa própria, papel distinto
- Dashboard com Kanban board para visão multi-agent
- Gerenciar via Claude Code project (`vps-agents`) — "assistant for the assistant"

## Hermes vs Claude Code vs OpenClaw

| Dimensão | Claude Code | Hermes | OpenClaw |
|---|---|---|---|
| Interface | Terminal | Telegram/CLI | CLI |
| Foco | Coding desk | On-the-go + crons | On-the-go |
| Contexto | Session | Persistente (memory.md) | Persistente |
| Crons | /loop | Nativos | — |
| Stars | — | 140K | 350K |

## Manutenção

- Errou duas vezes no mesmo ponto → corrigir + atualizar skill ou memory
- Mesma instrução duas vezes → criar skill
- Tone errado → editar soul
- Novo cron → skill primeiro, depois agendar
- Stale memory = causa #1 de comportamento estranho

## Conexões

- [[03-RESOURCES/entities/Hermes-Agent]] — entidade principal; atualizada com detalhes de deployment
- [[03-RESOURCES/entities/OpenClaw]] — comparativo; criado por Peter Steinberger (agora OpenAI)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — SKILL.md standard compartilhado
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] — auto-compaction no Telegram pode causar context rot silencioso
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — user.md + memory.md como camadas de memória
- [[03-RESOURCES/entities/HyperFrames]] — Hermes instalou HyperFrames autonomamente para gerar vídeo sobre si mesmo

## Os Cinco Pilares em Detalhe — Mecanismos de Funcionamento

### Memory: user.md e memory.md Como Camadas Distintas

A separação entre `user.md` e `memory.md` é arquitetural, não cosmética. São dois tipos de informação com ciclos de vida diferentes:

**user.md (preferências pessoais, estáticas):** como o agente deve se comunicar, quais formatos você prefere, quais ferramentas você usa, seu nível de expertise em diferentes domínios. Muda raramente — talvez a cada semanas.

**memory.md (contexto de negócio/projeto, dinâmico):** estado atual de projetos, decisões recentes, contexto que afeta a próxima sessão. Atualiza frequentemente — pode mudar durante uma sessão.

Esta separação permite uma regra de carregamento eficiente: `user.md` é sempre carregado (contexto base, raramente muda); `memory.md` pode ser carregado seletivamente baseado na tarefa da sessão. O agente não precisa ler todo o histórico de negócio para responder uma pergunta que só precisa de preferências pessoais.

**Por que "nunca coloque segredos aqui":** esses arquivos ficam em git para backup. Qualquer secret em `user.md` ou `memory.md` vai para o repo — mesmo privado, isso é um risco de segurança e um mau hábito operacional.

### Skills: O Sistema de Progressive Disclosure em Hermes

O front-matter YAML da skill Hermes (`description`, `trigger`, `requires`) implementa o mesmo padrão de progressive disclosure do SKILL.md formal, com uma diferença: Hermes usa correspondência explícita via `trigger` em vez de correspondência semântica implícita.

O `trigger` especifica termos de ativação exatos ou padrões. Quando o usuário menciona um trigger term, Hermes carrega essa skill no contexto. Skills sem trigger relevante permanecem dormentes — não consomem tokens na sessão.

Os 91 skills built-in + 520+ na community hub representam um catálogo de procedures bem-testados para casos de uso comuns. Antes de escrever um skill do zero, verificar se um skill da community hub resolve o caso é a abordagem de menor esforço.

### Soul: Por Que Personalidade É Configurável

O `soul.md` resolve um problema real em sistemas multi-agente: múltiplas instâncias Hermes com estilos diferentes para contextos diferentes. Um agente de suporte ao cliente precisa de um tom diferente de um agente de coding. Um agente pessoal pode ter um estilo informal que seria inapropriado em um agente de negócios.

Fazer a personalidade configurável via arquivo (em vez de hardcoded no prompt) significa que mudar o tom de um agente é uma edição de texto, não uma mudança de prompt. A soul também determina como o agente lida com ambiguidade, como escala urgência, e quando pede clarificação versus assume e age.

### Crons: Linguagem Natural → Automação Agendada

A capacidade de definir crons em linguagem natural ("todo dia às 8h, faça X") é tecnicamente um compilador de linguagem natural para expressões cron. O sistema Hermes interpreta a instrução e registra o job no scheduler.

**Flags importantes:**
- `CONTEXTFROM`: especifica qual arquivo de memória ou skill carregar no início do cron
- `WORKDIR`: diretório de trabalho para a execução do cron (relevante para tasks de coding)
- `NOAGENT`: roda o cron como script determinístico sem inferência LLM (para tasks que não precisam de reasoning)

A flag `NOAGENT` é particularmente valiosa: tasks que são puramente operacionais (backup, sincronização, limpeza) não precisam de LLM. Rodar esses crons sem o LLM economiza tokens e aumenta confiabilidade.

## Arquitetura de Deployment — Escolhas e Trade-offs

### Docker vs. VPS Bare Metal

O deployment padrão usa Docker com um container por agente. As vantagens:
- Isolamento de credenciais: cada agente tem seu próprio `.env` com as secrets necessárias para seu papel
- Portabilidade: o mesmo compose file roda em VPS, Mac Mini, ou cloud provider
- Rollback: reverter um agente problemático é `docker rollback` — sem afetar outros agentes

O VPS escolhido (Hostinger KVM2) é específico: KVM virtualização (não OpenVZ) é necessário para Docker funcionar corretamente. OpenVZ VPS não suporta Docker por limitações de kernel namespace.

### O Padrão "Assistant for the Assistant"

Gerenciar a frota de agentes via um projeto Claude Code específico (`vps-agents`) é o padrão "assistant for the assistant": um agente de meta-nível que tem acesso SSH ao VPS e pode modificar configs, reiniciar containers, e fazer deploy de novas versões dos outros agentes.

Este meta-agente tem permissões mais amplas que qualquer agente individual — ele pode modificar todos eles. Por isso, o princípio de least-privilege se aplica de forma invertida: o meta-agente precisa de acesso amplo justificado pela sua função administrativa, mas esse acesso deve ser explicitamente scoped ao VPS do agente fleet, não ao resto dos sistemas.

## Self-Improving Loop — O Mecanismo de Compound Learning

O loop de auto-melhoria (trabalho → erro → correção → atualização de skill/memory) é o que diferencia um agente estático de um agente que melhora com o uso. O mecanismo concreto:

1. O agente comete um erro ou produz output inconsistente
2. O usuário corrige e explica o problema
3. O agente (ou o usuário) identifica se o problema era de conhecimento (→ atualiza `memory.md`) ou de procedure (→ cria ou atualiza um skill)
4. A correção fica persistente: a próxima sessão começa com o conhecimento ou procedure correto já disponível

**A regra prática:** "errou duas vezes no mesmo ponto → criar skill". O segundo erro confirma que o primeiro não era ruído — é um gap de procedure sistemático. Um skill date/time evita que um terceiro erro aconteça.

O indicador de context rot ("stale memory = causa #1 de comportamento estranho") é o sinal de que o loop não está funcionando: a memória não foi atualizada depois de uma mudança importante e o agente está operando com estado desatualizado.

## Comparação com Vault-Michel

| Dimensão | Hermes Army | vault-michel |
|----------|-------------|--------------|
| Memória | user.md + memory.md por agente | hot.md + agent-specific memory |
| Skills | SKILL.md com trigger automático | Formal skills + manual invocation |
| Personalidade | soul.md configurável | Definida no CLAUDE.md principal |
| Crons | Native scheduler | hooks + scheduled tasks |
| Multi-agent | Docker por container | Nexus + specialists em AGENTS.md |
| Self-improvement | Memory update loop | errors.md log + consolidação |

A principal diferença arquitetural: Hermes distribui context (cada agente tem sua própria memória); vault-michel centraliza context (hot.md + AGENTS.md são o estado compartilhado de todos os agentes). Ambas as abordagens têm trade-offs — distribuída permite especialização mais profunda; centralizada facilita consistência entre agentes.
