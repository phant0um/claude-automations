---
title: "Lessons from building Claude Code: How we use skills"
type: source
source: "Clippings/Lessons from building Claude Code How we use skills.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Skills no Claude Code são pastas de instruções, scripts e recursos que agentes descobrem e usam para executar tarefas com mais precisão e eficiência — não apenas markdown files. A equipe Anthropic usa centenas de skills internamente e identificou nove categorias, práticas concretas de design, e estratégias de distribuição que distinguem skills que funcionam de skills que confundem o agente.

## Argumentos principais

- **Skills são pastas, não markdown files**: podem incluir scripts, assets, dados, etc. que o agente descobre, explora e manipula. No Claude Code, têm configurações amplas (hooks dinâmicos incluídos). As melhores skills usam essas opções de configuração e estrutura de pasta efetivamente.
- **Nove categorias de skills** (identificadas pela equipe Anthropic catalogando suas skills internas):
  1. **Library and API reference**: como usar corretamente uma library, CLI, ou SDK — especialmente com edge cases e gotchas que Claude erra. Ex: `billing-lib`, `internal-platform-cli`, `sandbox-proxy`.
  2. **Product verification**: como testar ou verificar que código funciona — frequentemente paired com playwright, tmux, ou outras ferramentas externas. **Maior impacto mensurável em qualidade de output**. Vale um engenheiro passar uma semana fazendo verification skills excelentes. Ex: `signup-flow-driver`, `checkout-verifier`, `tmux-cli-driver`.
  3. **Data fetching and analysis**: conexão com stacks de dados e monitoring. Ex: `funnel-query`, `cohort-compare`, `grafana`, `datadog`.
  4. **Business process and team automation**: automatizar workflows repetitivos em um comando. Log de execuções anteriores ajuda o modelo a manter consistência. Ex: `standup-post`, `create-ticket`, `weekly-recap`.
  5. **Code scaffolding and templates**: boilerplate de framework para funções específicas no codebase. Ex: `new-<framework>-workflow`, `new-migration`, `create-app`.
  6. **Code quality and review**: enforçar qualidade e revisar código. Inclui scripts determinísticos para máxima robustez. Pode rodar como hooks ou GitHub Actions. Ex: `adversarial-review`, `code-style`, `testing-practices`.
  7. **CI/CD and deployment**: fetch, push, deploy. Ex: `babysit-pr`, `deploy-<service>`, `cherry-pick-prod`.
  8. **Runbooks**: pega um sintoma (Slack thread, alert, error signature), percorre investigação multi-tool, produz relatório estruturado. Ex: `<service>-debugging`, `oncall-runner`, `log-correlator`.
  9. **Infrastructure operations**: manutenção rotineira e procedimentos operacionais com guardrails para ações destrutivas. Ex: `<resource>-orphans`, `dependency-management`, `cost-investigation`.
- **Regra de fit**: "The best skills fit cleanly into one [category]; the ones that try to do too much straddle several and confuse the agent."
- **Práticas de design das skills**:
  - **Não declarar o óbvio**: Claude já sabe programar e pode ler seu codebase. Skill que repete o que Claude faria por padrão adiciona contexto sem valor. Foque no que empurra Claude para fora do seu jeito normal de pensar.
  - **Build a gotchas section**: conteúdo de maior sinal em qualquer skill. Construído a partir de pontos de falha comuns que Claude encontra. Ex: "subscriptions table is append-only — the row you want is the one with the highest version, not the most recent created_at." "This field is called @request_id in the API gateway and trace_id in the billing service. They're the same value."
  - **Use o filesystem e progressive disclosure**: o filesystem inteiro é uma forma de context engineering. Diga ao Claude que arquivos estão na skill e ele os lê no momento apropriado. Formas simples: apontar para outros markdown files. Formas avançadas: pastas de references, scripts, examples.
  - **Evite railroading Claude**: dê a informação necessária mas flexibilidade para adaptar à situação. Skills reutilizáveis precisam de flexibilidade porque serão usadas em contextos variados.
  - **Think through the setup**: algumas skills precisam ser configuradas com contexto do usuário. Padrão: armazenar em `config.json` no diretório da skill; se não configurado, o agente pergunta. Usar `AskUserQuestion` tool para perguntas estruturadas com múltipla escolha.
  - **Escreva descriptions para o modelo, não para humanos**: quando Claude Code inicia, constrói um listing de cada skill disponível com sua description. Essa listagem é o que Claude varre para decidir "existe uma skill para esse request?" — a description é um trigger, não um sumário. Inclua triggers como "babysit" na description.
  - **Ajude Claude a lembrar**: skills podem incluir memória simples via arquivos de log append-only ou JSON files, ou SQLite. Ex: `standup-post` skill com `standups.log` — na próxima execução, Claude lê seu próprio histórico e pode dizer o que mudou desde ontem. Usar `${CLAUDE_PLUGIN_DATA}` para diretório estável de dados.
  - **Scripts e geração de código**: dar scripts e libraries ao Claude deixa-o usar seus turnos em composição — decidindo o que fazer a seguir — em vez de reconstruir boilerplate. Em `data-science` skill, um conjunto de helper functions para buscar dados permite ao Claude gerar scripts on-the-fly para análise avançada.
  - **On-demand hooks**: skills podem incluir hooks que só ativam quando a skill é chamada e duram pela duração da sessão. Ex: `/careful` bloqueia `rm -rf`, `DROP TABLE`, force-push, `kubectl delete` via PreToolUse matcher. `/freeze` bloqueia qualquer Edit/Write fora de um diretório específico.
- **Distribuição de skills**:
  - Checar skills no repo sob `./.claude/skills`.
  - Ou criar um plugin e ter um marketplace interno de plugins.
  - Para times menores e poucos repos, checar no repo funciona. Em escala, marketplace interno permite instalar seletivamente (cada skill adicionada também adiciona um pouco de contexto ao modelo).
- **Gerenciamento de marketplace (Anthropic)**: sem equipe centralizada decidindo. Quem tem uma skill útil, faz upload para sandbox folder no GitHub e aponta no Slack. Quando tem tração, PR para o marketplace.
- **Composição de skills**: referenciar outras skills pelo nome — o modelo as invoca se estiverem instaladas. Dependency management não é nativo mas funciona via referência de nome.
- **Medição de skills**: `PreToolUse` hook para logar uso de skills internamente — encontrar skills populares ou que estão undertriggering versus expectativas.

## Key insights

- **Verification skills têm o maior impacto mensurável em qualidade de output**: "It can be worth having an engineer spend a week just making your verification skills excellent." Isso é uma afirmação muito forte — verificação como o investimento de maior ROI em skill-building.
- **A description é o mecanismo de trigger, não o sumário**: Claude varre descriptions para decidir qual skill invocar. Escrever para o modelo como trigger é fundamentalmente diferente de escrever para humanos como documentação.
- **Progressive disclosure via filesystem**: o filesystem inteiro é context engineering — ao invés de carregar tudo de uma vez, o SKILL.md aponta para outros arquivos que Claude lê em momentos apropriados.
- **On-demand hooks como guardrails situacionais**: hooks que você só quer quando sabe que está tocando produção — ter sempre ativado seria insuportável, mas ter como skill opcionalmente ativada é perfeito.
- **Skills crescem a partir de gotchas**: "Most of our best skills began as a few lines and a single gotcha, then got better because people kept adding to them as Claude hit new edge cases." Não tentar fazer a skill perfeita desde o início.
- **Memória dentro de skills**: o padrão de log append-only dentro da própria skill (em vez de depender de MEMORY.md global) mantém contexto específico da skill sem poluir a memória global.
- **Fitting skills a categorias evita skills que tentam fazer demais**: uma skill que tenta cobrir Library reference + Verification + Runbook vai confundir o agente e nunca será invocada no momento certo.

## Exemplos e evidências

- **Nine categories** com exemplos reais internos da Anthropic: cada categoria tem 3-5 exemplos concretos com nomes de skills e descrições de o que fazem.
- **Frontend design skill** (GitHub): construída iterando com clientes para melhorar o taste de design do Claude, evitando padrões clássicos como Inter font e purple gradients — exemplo de skill que empurra Claude para fora do seu modo normal.
- **Adversarial review pattern**: "spawns a fresh-eyes subagent to critique, implements fixes, iterates until findings degrade to nitpicks" — exemplo de como uma skill pode orquestrar subagentes.
- **Careful hook**: bloqueia `rm -rf`, `DROP TABLE`, force-push, `kubectl delete` via PreToolUse. Ativa apenas quando skill é chamada.
- **Standup-post com standups.log**: memória dentro da skill via arquivo de log.
- **Data-science skill com helper functions**: Claude gera scripts on-the-fly usando as funções; exemplo de screenshot de análise "What happened on Tuesday?" gerada via composição.
- **PreToolUse hook para logging de uso**: link para gist com código de exemplo no GitHub.
- Artigo escrito por Thariq Shihipar, membro do staff técnico da Anthropic em Claude Code.

## Implicações para o vault

- O vault-michel já usa skills (em `04-SYSTEM/skills/`). Este source é a referência canônica do time Anthropic sobre como fazê-las bem.
- As nove categorias são um framework de auditoria: as skills do vault se encaixam em qual categoria? Estão tentando cobrir muitas?
- O padrão de "description como trigger" é diretamente aplicável — auditar as descriptions das skills existentes para garantir que são triggers, não sumários.
- A prática de gotchas section é especialmente relevante para skills de ingestão que encontram edge cases específicos do vault.
- O conceito de "memória dentro de skills" (log files) é uma alternativa ao MEMORY.md global para manter contexto específico de workflow.
- On-demand hooks como `/careful` podem ser úteis para operações destrutivas no vault (git reset, delete de arquivos).
- Verification skills como maior ROI: o vault-michel deveria ter uma skill de verificação de ingestão (que o manifest foi atualizado, que os wikilinks resolvem, etc.).
- Confirma e expande dramaticamente [[03-RESOURCES/concepts/ai-agents/agent-skills]].

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-skills]]
- [[03-RESOURCES/concepts/ai-agents/context-engineering]]
- [[04-SYSTEM/skills]]
- [[03-RESOURCES/sources/every-agentic-engineering-hack-i-know-june-2026]]
- [[03-RESOURCES/sources/how-to-master-context-engineering-in-claude-code-5-patterns-and-13-steps-anthropic-engineers-use]]
