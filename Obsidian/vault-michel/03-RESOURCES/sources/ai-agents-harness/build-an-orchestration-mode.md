---
title: "Build an orchestration mode"
type: source
source: "Clippings/Build an orchestration mode.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, orchestration, multi-agent-systems, claude-api, harness-engineering, tool-design]
---

## Tese central
Documentação oficial da Anthropic ensinando a construir um **"orchestration mode"** — um interruptor de nível de sessão que, quando ligado, faz o modelo aplicar máxima minúcia em toda solicitação substantiva, explorando a tarefa sozinho e então distribuindo o trabalho para subagentes paralelos por padrão; quando desligado, a mesma ferramenta de orquestração volta a exigir opt-in por solicitação. O modo não é um parâmetro de API — é construído inteiramente a partir de peças documentadas (nível de esforço, mensagens de sistema mid-conversation, e "consentimento permanente" embutido na descrição da ferramenta).

## Argumentos principais
- **O modo é montado a partir de três peças, todas já documentadas e públicas**:
  1. **Um nível de esforço (Effort)**: requisições rodam em um valor documentado como `xhigh`. Não há nível oculto acima dos publicados.
  2. **Um lembrete de modo (mode reminder)**: uma mensagem de sistema mid-conversation avisa o modelo que o modo está ativo, com um refresco de uma linha a cada várias rodadas e um aviso de saída quando o modo é desligado. O campo `system` de nível superior nunca muda — o que mantém o prefixo cacheado intacto (preserva prompt caching).
  3. **Consentimento permanente (standing consent) na descrição da ferramenta**: a descrição da ferramenta de orquestração afirma que, enquanto o modo está ligado, o modelo deve autorar e rodar um workflow para toda tarefa substantiva sem perguntar antes.
- **A ferramenta `Workflow` carrega o "contrato comportamental" real**: a regra de opt-in, o consentimento permanente que se aplica enquanto o modo está ligado, orientação de granularidade para dimensionar o fan-out, e os "padrões de qualidade" que o modelo pode usar — uma onda de verificação adversarial, um "completeness critic" (um agente que caça o que os outros perderam), e sequenciamento multi-fase (entender, projetar, implementar, revisar como chamadas de workflow separadas, lendo resultados entre fases).
- **Um padrão default útil é híbrido**: explorar inline primeiro para descobrir a lista de trabalho, depois distribuir (fan out) sobre ela.
- **Granularidade**: cada subtarefa deve ter escopo de uma preocupação, componente ou questão distinta — não por linha ou seção de arquivo. Uma revisão focada de um módulo de poucas centenas de linhas raramente precisa de mais de ~10 subtarefas; uma auditoria ampla de um codebase grande pode justificar mais.
- **Subagentes recebem uma ferramenta `report_findings`** para devolver resultados como JSON estruturado em vez de prosa, e usam a ferramenta bash `bash_20250124` definida pela Anthropic, rodando localmente.
- **Uma segunda onda de verificação adversarial**: depois que a primeira leva de subagentes termina, uma segunda onda reusa o mesmo caminho de subagente para tentar **refutar** cada resultado — cada verificador re-deriva as alegações a partir da fonte por conta própria, "default to refuted if uncertain", e cita arquivo:linha ou saída de comando que decidiu o veredito. Tanto o resultado original quanto seu veredito retornam ao orquestrador para que ele os pese juntos.
- **Um journal idempotente baseado em hash de conteúdo** torna o fan-out resumível: antes de despachar um subagente, procura o SHA-256 do prompt em um arquivo JSON local e devolve o resultado gravado se já existir. Interromper e re-rodar recomputa só as subtarefas que nunca terminaram. O journal deduplica entre runs, não dentro de uma única onda de fan-out — apagar o arquivo recomeça do zero.
- **Caminho para um harness de produção** — três adições recomendadas além desse exemplo deliberadamente pequeno:
  - **Scripts de orquestração sandboxed**: deixar o modelo emitir um pequeno programa de orquestração (com branching, loops e passos de redução) e rodá-lo dentro de um interpretador isolado, em vez de aceitar apenas uma lista plana de strings de subtarefas.
  - **Journaling durável**: substituir o arquivo JSON local por um armazenamento que sobrevive a reinícios de processo e é seguro sob escritores concorrentes em múltiplas máquinas.
  - **Imposição de orçamento (budget enforcement)**: rastrear o total de subagentes lançados em toda a sessão (não só por chamada de Workflow) e recusar exceder um teto rígido para que um plano descontrolado não esgote a cota.
- O texto enfatiza repetidamente que **os padrões carregam-se inalterados** — lembretes de modo, consentimento permanente na descrição da ferramenta, journaling, e a onda de verificação — apenas o substrato de execução ao redor deles fica mais robusto.
- **Aviso de risco explícito**: "The bash tool in this example runs model-written commands directly on your machine with no sandbox" — não há sandbox no exemplo; rodar exige conforto com exposição total, e produção exige adicionar sandboxing.

## Key insights
- **Colocar a mensagem de sistema DEPOIS do turno do usuário preserva o cache de prompt** — mantém todo byte cacheado anterior intocado, e satisfaz a regra de posicionamento de que uma mensagem de sistema segue um turno de usuário. Esse é um detalhe técnico sutil de "como sinalizar mudança de comportamento sem invalidar o cache" — relevante para qualquer discussão de [[03-RESOURCES/concepts/agent-systems/prompt-caching]].
- **`MAX_CONCURRENT` vs `MAX_TOTAL_SUBTASKS`**: separar "quantos rodam ao mesmo tempo" de "quantos o modelo pode enfileirar numa chamada" permite que o modelo planeje um backlog grande sem disparar tudo de uma vez — um padrão de design reutilizável para qualquer orquestrador de subagentes.
- **Isolamento de falhas**: um subagente que falha degrada para uma string de erro em vez de encerrar a corrida inteira — um princípio de resiliência que generaliza para qualquer arquitetura multi-agente.
- **A constante `DOC_TEST_MODE`** mostra um padrão elegante de "harness de teste de documentação": permite que o exemplo seja validado automaticamente (compila, termina rápido, usa diretório descartável) sem rodar a orquestração completa — útil como referência de engenharia para escrever exemplos de código auto-testáveis em documentação.
- **O "mode reminder" é deliberadamente curto** — ele apenas vira a chave e aponta para a descrição da ferramenta, onde vivem as instruções pesadas. Isso evita inflar o contexto a cada rodada e mantém a "fonte da verdade" comportamental em um único lugar (a descrição da tool), espelhando a lição de "trim ruthlessly" do CLAUDE.md no playbook de Boris Cherny (ver [[03-RESOURCES/sources/claude-code-is-insane-once-you-set-it-up-right-heres-the-full-playbook]]).
- **O custo é explícito e avisado**: "the fan-out itself multiplies token usage: a single request can spawn many subagent conversations, so reserve the mode for work that justifies the cost" — um lembrete de que orquestração tem ROI condicional, não é grátis.
- A combinação "scout inline → fan out → verify adversarially" é, na prática, uma instância concreta e documentada oficialmente do padrão **generator-verifier loop**.

## Exemplos e evidências
- Exemplo é um único arquivo Python completo, executável (`orchestration_mode.py`), com ~450 linhas incluindo: setup de constantes, definição de `WORKFLOW_TOOL`/`BASH_TOOL`/`REPORT_TOOL`, handler de bash local, `run_subagent`, journaling com SHA-256, `run_workflow` com fan-out + verificação, e o loop de toggle do modo via mensagens de sistema mid-conversation.
- Modelo usado no exemplo: `claude-opus-4-8`, com `effort: xhigh` e `thinking: {type: adaptive}`.
- Constantes-chave do exemplo: `MAX_CONCURRENT = 10`, `MAX_TOTAL_SUBTASKS = 200` (ou 2 em modo de teste), `MAX_SUBAGENT_TURNS = 15`, `MAX_MAIN_TURNS = 30`, `TURNS_BETWEEN_REFRESHERS = 10`.
- Comando de execução de exemplo: `python orchestration_mode.py "Review this repository for flaky tests and propose fixes."`
- A funcionalidade de mensagens de sistema mid-conversation está disponível **apenas no Claude Opus 4.8** no momento da publicação.
- Citação da descrição da ferramenta Workflow que define o "standing consent": "while a system message confirms orchestration mode is on, that opt-in is standing. Author and run a workflow for every substantive task by default... Work solo only on conversational turns or trivial mechanical edits."

## Implicações para o vault
- É uma implementação **oficial e documentada pela Anthropic** do mesmo padrão que [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] e [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]] já descrevem de forma mais geral — vale citar como referência canônica/primária ao atualizar essas páginas.
- Conecta-se diretamente com [[03-RESOURCES/concepts/agent-systems/subagent-spawning]] e [[03-RESOURCES/concepts/agent-systems/subagent-pattern-empirical]]: o documento detalha exatamente os mecanismos de granularidade, isolamento e journaling que aquelas páginas provavelmente discutem em termos mais abstratos.
- O padrão de "verificação adversarial em segunda onda, default-to-refuted" é uma instância muito concreta de [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]] e merece ser citado lá como exemplo de referência oficial.
- A discussão sobre como preservar o cache de prompt ao injetar mensagens de sistema mid-conversation (posicionar depois do turno do usuário) é relevante para [[03-RESOURCES/concepts/agent-systems/prompt-caching]] e [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]] — um detalhe técnico pouco discutido em fontes anteriores do vault.
- Cross-link forte com [[03-RESOURCES/sources/claude-code-is-insane-once-you-set-it-up-right-heres-the-full-playbook]]: ambos descrevem "fan out de subagentes especializados que devolvem resultado e mantêm o contexto principal limpo" — um pelo lado da API/documentação oficial, o outro pelo lado da prática de Boris Cherny no Claude Code (sub-agentes em `.claude/agents/`). Útil contrastar: aqui o "consentimento permanente" é codificado na ferramenta; lá, o usuário decide manualmente quando invocar sub-agentes.
- Também conecta com [[03-RESOURCES/sources/anthropic-says-claude-writes-80-of-its-code-here-are-4-layers-and-7-st]] — o "gate" descrito ali (held-out score, replay test, rubrica humana) é estruturalmente equivalente à "onda de verificação adversarial" descrita aqui: ambos são mecanismos de checagem externa que decidem se uma mudança/resultado sobrevive.
- Não identificadas contradições — é documentação primária complementando conceitos já mapeados no vault, com detalhes de implementação que outras fontes só descrevem em alto nível.

## Links
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/agent-systems/subagent-pattern-empirical]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/prompt-caching]]
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/sources/claude-code-is-insane-once-you-set-it-up-right-heres-the-full-playbook]]
- [[03-RESOURCES/sources/anthropic-says-claude-writes-80-of-its-code-here-are-4-layers-and-7-st]]
