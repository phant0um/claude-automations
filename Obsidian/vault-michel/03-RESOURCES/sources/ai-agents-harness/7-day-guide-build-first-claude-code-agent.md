---
title: "7-Day Guide: Build Your First Claude Code Agent"
type: source
source: "Clippings/7-Day Guide Build Your First Claude Code Agent.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
A maioria das pessoas usa Claude Code como usava o ChatGPT (pedir, colar erro, aceitar diff, esperar não quebrar nada), o que funciona para tarefas pequenas mas falha quando o repo cresce ou a tarefa exige julgamento. A solução não é "mais autonomia" — é um pequeno stack de agente: um arquivo de contexto, três skills, três subagentes, dois hooks, acesso MCP estreito e permissões "chatas" (boring). Isso basta para tornar Claude Code muito mais consistente.

## Argumentos principais
- Reliability vem antes de autonomy: "a lot of people try to make the agent autonomous before it is reliable."
- O erro do principiante é tentar construir um agente gigante de uma vez; o caminho certo é: um repo, um CLAUDE.md, três skills, três agentes, dois hooks, uma conexão MCP estreita, permissões claras, uma tarefa real — e só então melhorar o stack quando o trabalho real expor uma lacuna.
- O workflow completo (Day 7) — Idea → Researcher investiga → Builder faz a menor mudança útil → QA skill checa → Reviewer inspeciona o diff → Hook confirma testes antes do final → Release-notes skill resume — é a "diferença importante": não pedir "fix this bug" diretamente, mas dar um caminho.

## Key insights
- **Day 1 — CLAUDE.md**: deve ser curto; contém as "regras da casa": inspecionar arquivos relevantes antes de editar, seguir padrões existentes, evitar rewrites amplos, diffs pequenos e revisáveis; nunca adicionar dependências sem perguntar, nunca mudar APIs públicas sem pedido, nunca tocar secrets/env, nunca rodar migrations sem perguntar, nunca afirmar que testes passaram sem terem rodado. Resposta final deve sempre incluir: resumo, arquivos alterados, testes/checks executados, riscos/follow-ups.
- **Day 2 — Três skills**: `research.md` (usar antes de implementar quando a tarefa é ambígua — restabelecer a pergunta exata, inspecionar arquivos, buscar padrões similares, resumir comportamento atual, separar fatos de suposições, recomendar o menor próximo passo; regra: não editar arquivos durante pesquisa, citar paths, marcar incerteza), `qa.md` (usar depois de mudanças de código — revisar arquivos alterados, checar regressões óbvias, procurar testes faltantes, rodar o check mais estreito útil, diagnosticar antes de editar de novo se falhar, explicar se nenhum check puder rodar), `release-notes.md` (usar depois de feature/fix/refactor — resumo curto, mudanças visíveis ao usuário, mudanças técnicas, notas de migração, riscos conhecidos; estilo: inglês simples, sem hype).
- **Day 3 — Três subagentes**: researcher (investiga, não edita a menos que pedido; output: arquivos relevantes, comportamento atual, abordagem recomendada, riscos), builder (faz edições focadas, segue padrões existentes, evita limpeza não relacionada, pergunta antes de adicionar dependências; output: arquivos alterados, o que mudou, checks a rodar), reviewer (inspeciona o diff, procura bugs, checa cobertura de teste, verifica que comandos foram realmente executados, sinaliza incerteza; output: julgamento pass/fail, issues encontrados, checks executados, riscos remanescentes). Resolve o problema comum de pedir a um único agente para investigar, escrever código, revisar a si mesmo e explicar tudo numa única execução — isso "também funciona" mas "também perde coisas".
- **Day 4 — Dois hooks "chatos"**: `test-before-final.md` (antes da resposta final após mudanças de código: identificar o check relevante, rodar o teste mais estreito primeiro, se não houver teste rodar o check seguro disponível, se nenhum check puder rodar dizer isso claramente, nunca afirmar que testes passaram sem terem rodado) e `pre-commit-check.md` (revisar arquivos alterados, confirmar que nenhum segredo foi adicionado, confirmar que nenhum arquivo não relacionado mudou, confirmar formatação/lint/status de teste, escrever mensagem de commit concisa). Regra: não tornar hooks "inteligentes" — chatos economizam erros caros.
- **Day 5 — MCP só onde importa**: boas primeiras conexões — GitHub issues/PRs, docs do projeto, logs de erro, schema de banco de dados, docs de design system. Más primeiras conexões — cada workspace, cada inbox, cada banco de dados, cada pasta de docs, cada ferramenta interna. Mais acesso não é automaticamente melhor — dá mais formas do agente se distrair ou tocar a coisa errada.
- **Day 6 — Permissões claras**: "Claude pode" — ler arquivos do projeto, buscar no repo, propor edições, fazer mudanças escopadas quando pedido, rodar checks locais seguros. "Claude deve pedir antes de" — instalar pacotes, mudar arquivos env, deletar arquivos, tocar secrets, rodar migrations, fazer deploy, force-push, refatorações amplas.
- **Day 7 — Rodar um workflow completo**: prompt de exemplo dado no artigo mostra a estrutura: usar comportamento researcher → inspecionar code paths → resumir causa provável → propor fix mínimo → usar comportamento builder → usar skill QA → usar comportamento reviewer antes da resposta final, com as mesmas regras de não adicionar dependências/mudar APIs/pedir antes de tocar migrations/não afirmar testes sem tê-los rodado.

## Exemplos e evidências
- Estrutura final de pastas proposta: `/project` com `CLAUDE.md`, `/skills` (research.md, qa.md, release-notes.md), `/agents` (researcher.md, builder.md, reviewer.md), `/hooks` (test-before-final.md, pre-commit-check.md).
- Fontes citadas: docs.anthropic.com/en/docs/claude-code/{overview, sub-agents, hooks, skills, mcp}.

## Implicações para o vault
Este é um template prático e replicável que confirma e detalha em código real a arquitetura de camadas já documentada em `claude-code-five-layer-architecture` e `claude-agent-harness-architecture`: contexto (CLAUDE.md), skills (procedimentos), subagentes (isolamento), hooks (enforcement determinístico), MCP (acesso externo), permissões (settings.json). Serve como checklist concreto reutilizável para revisar a estrutura de `04-SYSTEM/agents/` do próprio vault.

## Links
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-five-layer-architecture]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-subagents]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/entities/Claude Code]]

## Minha Síntese

**O que muda:** Checklist concreto (CLAUDE.md curto, 3 skills, 3 subagentes, 2 hooks chatos, MCP estreito) pra auditar `04-SYSTEM/agents/` contra um template prático já testado, em vez de design ad-hoc.

**Conexão pessoal:** Reforça padrão já presente no vault (guard/hill/spec/extend/verify) — falta formalizar hooks "chatos" tipo pre-commit-check equivalente.

**Próximo passo:** Nenhum próximo passo imediato.
