---
title: "Claude Code / Codex / Grok 长任务工作流：只读计划、按计划执行、单独验收"
type: source
source: "Clippings/Claude Code  Codex  Grok 长任务工作流：只读计划、按计划执行、单独验收.md"
created: 2026-06-23
updated: 2026-06-23
score: A
tags: [ai-agents, source-page, long-task-workflow, planning-execution-separation, codex, claude-code, grok, agent-verification]
---

## Tese Central

Quando uma task fica longa, envolve múltiplos arquivos, e precisa verificação contínua, não deixe a mesma sessão fazer planejamento, edição de código e verificação simultaneamente. Separe "pensar claro" (计划), "executar mudanças" (执行), e "verificar resultados" (验收) em três linhas — o processo fica mais lógico, mais fácil de audit, e reduz retrabalho.

## Contexto

OpenAI publicou guia Codex long-running work; xAI Grok Build adicionou /goal (executa por checklist); Claude Desktop unificou Chat, Cowork, Code. A tendência: agents fazem tarefas cada vez mais longas — migração, refatoração, investigação, research, deploy. Tarefa longa = uso precisa mudar.

O problema com a abordagem de "jogar tudo no Agent": ele lê arquivos, decide plano, começa a mudar, descobre info faltando, continua lendo, test falha, muda outro lugar, escreve summary completo — mas o humano não consegue julgar: o plano era razoável? quais mudanças eram necessárias vs inventadas?

## As Três Linhas

### Linha 1: Só lê e planeja
- Pode ver código, docs, perguntar — mas NÃO pode mudar arquivos
- Objetivo: deixar a task clara — resolver o quê, quais arquivos, como mudar, quais comportamentos não mudar, como verificar

Prompt de plan:
```text
请先不要修改任何文件。请阅读相关代码和文档，写一份执行计划。
计划里包含：
1. 这次真正要解决的问题是什么
2. 预期结果是什么
3. 哪些现有行为不能改变
4. 可能涉及哪些文件或模块
5. 推荐的最小修改方案
6. 需要运行哪些验证命令
7. 哪些情况需要停止并问我

如果信息不够，请列出来，不要猜。
```

Após plan pronto, checa três: (1) objetivo alinha com problema original? (2) escopo de mudanças ampliou? (3) comandos de verificação são específicos?

### Linha 2: Só executa segundo a task list
- Pega task list e execution prompt da Linha 1
- Só faz mudanças necessárias; pode descobrir problemas mas NÃO reescreve o objetivo
- Se plano insuficiente: para e explica, não continua扩改

Prompt de execução:
```text
请严格按任务单执行。
要求：
1. 只修改完成任务所必需的文件
2. 不做额外重构和格式整理
3. 每个修改文件都说明为什么必须改
4. 如果发现任务单有问题，请停止并说明原因
5. 完成后运行任务单里的验证命令
6. 无法验证的地方写「未验证」
请不要把计划之外的优化一起做掉。
```

Resolve: agentes expandem escopo (mudam código adjacente, transformam bug pequeno em refatoração arquitetural). Fazem isso não por incompetência mas por querer completar.

### Linha 3: Só verifica evidência
- Não participa de escrever código — só olha diff, testes, logs, comportamento final
- Responde: problema original sumiu? escopo de mudanças foi contido? evidência é suficiente? estilo é consistente? há conteúdo não verificado?

Prompt de verificação:
```text
请只做验收，不要修改代码。请检查：
1. 原问题是否真的解决
2. 改动范围是否收住
3. 证据是否充分
4. 风格是否一致
5. 失败过程是否记录
6. 是否存在不确定点
重点写风险和证据，不要写自夸总结。
```

Se verificação encontra problema: escreve de volta na task list, entrega para Linha 2. Cada rodada tem registro.

## Grok /goal: Long tasks precisam de boundaries

```text
/goal Migrate the auth module to the new API.

Constraints:
- 不改变现有登录行为
- 不修改数据库 schema
- 不重构无关模块
- 每完成一个 checklist 项都运行对应测试
- 如果发现旧 API 行为不明确，先 pause 并报告

Success criteria:
- 现有 auth 测试通过
- 手动登录流程可复现
- 所有修改文件都有原因说明
- 未验证内容单独列出
```

Só dar uma frase de /goal não basta — condições de parada (quando continuar, quando pausar, quando pedir humano) devem estar incluídas.

## Quando vale as três linhas

Não vale para: mudar copy, função pequena, typo óbvio — direto no agent.

Vale quando:
- Task muda 3+ arquivos
- Envolve DB, auth, payment, produção config
- Migração de API antiga
- Refatorar módulo compartilhado
- Causa de teste falhando é incerta
- Preocupação que agent vai mudar demais
- Task já rodou uma vez mas resultado instável (agent diz que consertou, test passou parcial, mas parece que contornou o problema)

## Workflow copiável

1. **Plan thread:** "请先不要修改任何文件..." → plano com problema, resultado esperado, comportamentos invariantes, arquivos, mínima mudança, comandos de verificação, stop conditions
2. **Task list:** organize plano em tasks/todo.md, GitHub Issue, ou Obsidian task page — preserva success criteria, verification commands, stop conditions
3. **Execution thread:** "请严格按任务单执行..." — só arquivos necessários, sem refatoração extra, explica cada mudança, roda verificação
4. **Verification thread:** "请只做验收..." — 6 checks focados em risco e evidência, não em auto-elogio

> "计划线程负责想清楚，执行线程负责把代码改出来，验收线程负责检查结果。职责越清楚，越容易发现问题出在哪一步。"

## Key Insights

- Tarefa longa = separar planejamento, execução e verificação em três sessões distintas
- Plan thread nunca toca em arquivos — só lê, entende e escreve plano
- Execution thread não re-discute plano — segue task list, para se encontrar problema
- Verification thread não modifica — só avalia diff, testes, logs vs critérios
- Agent "diz completo" é claim, não proof — verificação foca em evidência
- Cada rodada de correção é escrita na task list, não em memória de sessão
- Grok /goal precisa de constraints e success criteria explícitos, não só objetivo
- Quando resultado de rodada anterior é instável, abrir verification thread em vez de continuar na mesma sessão

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/coding-agents]]

## Minha Síntese

**O que muda:** A separação de planejamento, execução e verificação em três threads é um padrão operacional claro para tasks longas de coding agents. Não é teoria — é prompt engineering aplicado à divisão de responsabilidades. Cada thread tem um prompt específico que restringe o que o agent pode fazer. O resultado é auditabilidade: você pode ver onde o erro entrou, em qual passo.

**Conexão pessoal:** O vault-michel já usa handoff-file-pattern e generator-verifier-loop como conceitos. Este artigo dá os prompts concretos para implementar as três linhas. O pattern de "plan thread só lê" alinha com o Karpathy Principle 1 (Think before acting) e com o AGENTS.md do vault. A idea de "escrever correções de volta na task list" é exatamente como o vault `.claude/todo.md` funciona.

**Próximo passo:** Criar templates de prompt para as três linhas no vault (04-SYSTEM/skills/ ou similar). Começar usando o pattern de plan thread para o próximo task complexo do vault — especialmente para reestruturações ou migracoes que envolvam 3+ arquivos.