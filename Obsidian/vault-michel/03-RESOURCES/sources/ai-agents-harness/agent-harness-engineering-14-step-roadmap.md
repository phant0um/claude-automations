---
title: "Agent harness engineering with Claude: 14-step roadmap from one agent to a self-improving system"
type: source
source: "Clippings/Agent harness engineering with Claude 14-step roadmap from one agent to a self-improving system..md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Todo mundo fala de loops; quase ninguém fala sobre o que o loop roda em cima — o harness. "Um loop só é tão bom quanto o harness por baixo dele." A peça citando Addy Osmani resume: "loop engineering fica um andar acima do harness. O harness é o ambiente em que um agente roda. O loop é o harness, mas roda num timer, gera helpers, e se alimenta." Harness engineering é desenhar esse ambiente: modelo, ferramentas, permissões, contexto, memória — a camada "sem glamour" que decide se tudo acima funciona.

## Argumentos principais
- Um harness é apenas quatro coisas: o modelo (pensa), as ferramentas (alcance), as permissões (nessas ferramentas), e o contexto (o que lê no início de cada execução). Tudo o resto — subagentes, hooks, memória — é uma forma de moldar uma dessas quatro.
- Três andares, não misturar: o **harness** é o runtime estático (modelo, ferramentas, permissões, contexto); o **loop** prompta o agente num timer, gera helpers, se alimenta, rodando sobre o harness; o **sistema auto-melhorável** é um loop mais memória que compõe — cada execução deixa a próxima mais afiada.
- A versão honesta de "auto-melhoria": "o modelo nunca mudou. O harness em torno dele ficou mais afiado. É isso que 'self-improving' honestamente significa — não um modelo que aprende, mas um harness que acumula."

## Key insights
1. **O harness vive numa pasta `.claude/`**: CLAUDE.md (fatos permanentes, lido toda sessão), settings.json (permissões, modelo, hooks), .mcp.json (conexões externas), rules/ (comportamentos escopados por path), agents/ (definições de subagentes, ~30 linhas cada), skills/ (workflows reutilizáveis), agent-memory/ (o que sobrevive entre execuções). Regra de ouro: manter pequeno o suficiente para explicar por que cada arquivo existe — se não conseguir dizer para que serve uma rule/hook/subagente, deletar.
2. **O harness default**: modelo capaz, ferramentas built-in (read, write, bash, search), prompts de aprovação em tudo que é arriscado — sem contexto de projeto, sem subagentes customizados, sem memória. Bom para tarefa única; ruim para qualquer coisa feita mais de uma vez (o agente re-deriva o projeto do zero a cada sessão).
3. **CLAUDE.md — regra dos ~500 tokens**: deve conter apenas fatos permanentes ("usamos pnpm, não npm"), não procedimentos ("para adicionar uma feature, primeiro..." — isso vai para uma skill) nem comportamento path-específico (vai para rules/). Teste prático: ler o CLAUDE.md em voz alta — toda linha deve ser um fato necessário em toda sessão.
4. **settings.json — teste do "quão caro é desfazer"**: barato de desfazer → auto-aprovar; caro de desfazer (force-push, deletar arquivos, tocar secrets) → sempre negar ou perguntar; meio-termo é OK auto-aprovar se logado.
5. **Subagentes — isolamento de contexto para trabalho sujo**: ponto não é paralelismo per se, é "manter ruído fora do contexto principal". O subagente mais valioso de qualquer harness é o que checa o trabalho que o agente principal fez — um modelo revisando seu próprio output é fácil demais consigo mesmo; um revisor separado com contexto novo pega o que o escritor convenceu a si mesmo a aceitar (o "writer-vs-checker split").
6. **Skills — procedimentos reutilizáveis**: rodam na mesma janela de contexto (diferente de subagente). Gatilho para criar uma: "você nota que está colando as mesmas instruções em toda conversa nova." Como skills são a unidade reutilizável, são o que faz o harness melhorar com o tempo — cada vez que o procedimento falha de uma nova forma, a lição é adicionada à skill, e a próxima execução herda.
7. **Hooks — regras determinísticas que o modelo não consegue alucinar**: um hook roda em ponto fixo do ciclo de vida (antes de uma ferramenta, depois de um arquivo mudar, no fim da sessão) e seu exit code pode *bloquear* a ação. "Hooks são enforcement, CLAUDE.md é sugestão." Dois hooks merecem lugar em quase todo harness: um PreToolUse gate bloqueando comandos perigosos deterministicamente (rm -rf, ler .env, push para main — exit 2 para antes de acontecer) e um PostToolUse formatter rodando linter/formatter depois de cada edição. Usar hooks para o que *deve* ou *nunca deve* acontecer; não para julgamento (isso é trabalho do modelo). Um harness bom tem um ou dois hooks afiados, não vinte.
8. **Loop**: `/loop 30m /goal <condição>` reusa tudo que o harness já construiu (rules, subagente revisor, hook de segurança) — "o loop não adicionou inteligência. Reusou tudo no harness." Um harness bom torna um loop trivial.
9. **Dynamic workflows**: para tarefas complexas demais para um loop único (massivamente paralelas, altamente estruturadas, adversariais), Claude pode escrever seu próprio harness JavaScript on-the-fly (`agent()` para gerar, `parallel()` para abrir leque, `pipeline()` para encadear). Um dynamic workflow só é tão bom quanto os subagentes e skills que pode chamar — "o workflow é o regente, seu harness é a orquestra."
10. **Memória**: um arquivo de estado (markdown em agent-memory/, ou um board) registra o que foi tentado, o que funcionou, o que falhou, quais regras sobreviveram. Padrão: escrever antes de sair (toda execução termina atualizando o state file), ler no início (toda execução começa lendo o state file e skills relevantes), destilar em skills (quando a lição é geral, ela "se gradua" do state file para uma skill que se aplica a todo projeto futuro).
11. **Fechando o loop**: output → reviewer subagent checa → resultado escrito em memória → lições gerais destiladas em skills → próxima execução herda skills mais afiadas e memória mais rica.
12. **Empacotar o harness**: agrupar skills, subagentes e rules num plugin para o time inteiro instalar o mesmo setup de uma vez — mesmas convenções, mesmos hooks de segurança, mesmo revisor. O harness deixa de ser setup pessoal e se torna infraestrutura compartilhada.

## Exemplos e evidências
- Citação de Addy Osmani (autor da peça longa sobre loops): "Loop engineering sits one floor above the harness."
- Exemplo de settings.json com autoApprove para Read/Grep/testes seguros e deny para `rm -rf*`, `git push*`, edição de `.env*`/`secrets/*`.
- Exemplo de hooks JSON: PreToolUse com matcher "Bash" chamando `block-dangerous.sh` (exit 2 bloqueia); PostToolUse com matcher "Edit|Write" chamando `prettier --write`.
- Exemplo de memory file com seções "Verified facts" (ex: "prc is in dollars, not cents") e "Lessons learned" (ex: "Windows CI runners fail TLS 1.2 in PowerShell — use bash").

## Lista de erros comuns ("harness mistakes")
- Rodar no default (sem contexto, regras, memória).
- CLAUDE.md inchado com procedimentos em vez de fatos.
- Enforcement em CLAUDE.md em vez de hooks (modelo pode ignorar sugestão; não pode ignorar hook que sai com exit 2).
- Um agente escrevendo e avaliando seu próprio trabalho (sem subagente revisor).
- Nenhuma memória — toda execução reinicia do zero.
- Enrolar um loop em torno de um harness ruim — produz slop mais rápido.
- Vinte hooks (um ou dois afiados vencem uma pilha que ninguém entende).
- Shippar um harness sem escaneá-lo — segredos vazados e permissões amplas se propagam para quem instala.

## Implicações para o vault
Este artigo é a referência mais completa e estruturada já capturada sobre a arquitetura de harness, consolidando e dando ordem sequencial (14 passos, 3 andares) aos conceitos já existentes no vault: `agentic-harness`, `agentic-harness-engineering`, `claude-agent-harness-architecture`, `claude-code-five-layer-architecture`, `claude-code-subagents`, `claude-code-skills`, `loop-engineering-patterns`. Serve como checklist de auditoria direta para `04-SYSTEM/agents/`: confirmar que CLAUDE.md do vault está sob ~500 tokens equivalentes de fatos permanentes (hoje tem seções maiores, mas estruturadas), que existem hooks de segurança (verificar `.claude/settings.json`), e que subagentes seguem o padrão writer-vs-checker (ex: `guard`, `verify`, `review` já cumprem esse papel).

## Links
- [[03-RESOURCES/concepts/agent-systems/agentic-harness]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-five-layer-architecture]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-subagents]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/entities/Claude Code]]
