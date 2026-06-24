---
title: "Agent Performance Model-Bound versus Harness-Bound"
type: source
source: Clippings/Agent Performance Model-Bound versus Harness-Bound.md
source_type: clipping
created: 2026-05-19
ingested: 2026-05-19
triagem_score: 7
triagem_cat: ai-agents
tags: [ai-agents, clipping]
---

## Tese central

Framework Model-Bound vs Harness-Bound: quando a limitação de performance de um agente está no modelo LLM subjacente vs. na infraestrutura ao redor dele — e como diagnosticar e tratar cada caso.

## Key insights

- Um agente Model-Bound não melhora com melhor prompting, mais contexto, ou mais ferramentas — precisa de modelo mais capaz
- Um agente Harness-Bound pode ter performance dramaticamente melhorada sem trocar o modelo — apenas melhorando tools, memória, contexto
- O diagnóstico correto antes de investir em melhoria evita desperdício de tempo e custo

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]

## Fonte

Arquivo original: `Clippings/Agent Performance Model-Bound versus Harness-Bound.md`

---

## A distinção fundamental

Quando um agente performa mal, há dois diagnósticos possíveis:

**Model-Bound:** o modelo LLM não tem as capacidades necessárias para a tarefa. O raciocínio é insuficiente, o conhecimento está ausente, ou a capacidade de seguir instruções complexas é limitada. Melhorar o harness não vai resolver — o gargalo é o modelo em si.

**Harness-Bound:** o modelo tem as capacidades, mas o ambiente ao redor dele está limitando a performance. Contexto insuficiente, ferramentas inadequadas, memória mal estruturada, prompt mal organizado. Trocar o modelo por um mais caro não vai resolver — o gargalo é a infra.

A maioria dos desenvolvedores assume Model-Bound quando a performance decepciona e vai direto para modelos maiores/mais caros. Frequentemente, o problema é Harness-Bound e a solução é mais barata e mais impactante.

## Diagnóstico: como identificar a causa

### Teste de oráculo

Forneça ao agente toda a informação que ele precisaria para resolver a tarefa — mesmo informação que normalmente precisaria recuperar de ferramentas. Se o agente resolve corretamente com informação completa mas falha quando precisa buscá-la, o problema é Harness-Bound (retrieval, contexto, ferramentas).

Se o agente falha mesmo com informação completa e explícita, o problema é Model-Bound (capacidade de raciocínio, instrução following).

### Análise de falhas por categoria

Categorize uma amostra de falhas:
- Falha porque não tinha informação disponível → Harness-Bound (memória/retrieval)
- Falha porque usou ferramenta errada → Harness-Bound (design de tools ou prompting de tool use)
- Falha porque o raciocínio estava errado mesmo com contexto completo → Model-Bound
- Falha porque não seguiu instruções → pode ser ambos (instrução mal escrita = Harness; limitação de instruction following = Model)

### Ablation de componentes

Isole cada componente do harness e teste com e sem ele. Se remover a memória externa degrada performance significativamente, o sistema é dependente do harness para aquela capacidade — e a memória precisa melhorar.

## Quando o problema é Harness-Bound

### Sintomas comuns

- O agente "esquece" contexto importante do início da conversa
- O agente usa ferramentas na ordem errada ou falha ao interpretar outputs de ferramentas
- Performance varia muito com pequenas mudanças no prompt
- O agente funciona bem em testes mas falha em produção (onde o contexto é diferente)
- O agente toma decisões corretas mas com passos desnecessários

### Soluções de harness

**Contexto:** restruturar o system prompt. Informação crítica deve estar no início, não enterrada. Use headers e formatação para ajudar o modelo a localizar informação relevante.

**Memória:** implementar retrieval semântico para contexto de longo prazo. O agente não deve depender de ter toda a informação no contexto — deve saber buscar o que precisa.

**Ferramentas:** redesenhar as ferramentas disponíveis. Ferramentas com interfaces ambíguas, parâmetros confusos, ou outputs mal formatados causam erros de uso mesmo em modelos capazes.

**Observação:** garantir que o agente recebe feedback adequado das ferramentas. "Erro: timeout" não é feedback suficiente. "Erro: timeout após 30s tentando conectar em api.exemplo.com — considere verificar conectividade ou usar endpoint alternativo" é.

**Pipeline structure:** dividir tarefas complexas em subtarefas menores com feedback loops. Um agente tentando fazer 10 coisas de uma vez vai falhar onde 3 agentes especializados teriam sucesso.

## Quando o problema é Model-Bound

### Sintomas comuns

- O agente falha mesmo com contexto completo e explícito
- O agente não consegue seguir cadeias de raciocínio multi-passo
- O agente produz outputs inconsistentes para o mesmo input
- O agente não consegue usar ferramentas complexas mesmo com exemplos
- Performance não melhora com melhor prompting

### Soluções de modelo

- Upgrade para modelo mais capaz (ex: Sonnet → Opus para tasks que exigem raciocínio profundo)
- Fine-tuning em exemplos do domínio específico
- Usar extended thinking / chain-of-thought explícito para tarefas de raciocínio
- Decomposição de tarefas: dividir em subtarefas que o modelo atual consegue resolver

## A dimensão econômica

A decisão Model-Bound vs Harness-Bound tem implicação direta de custo:

| Abordagem | Custo relativo | ROI se diagnóstico correto |
|---|---|---|
| Upgrade de modelo | Alto (2-10x por token) | Baixo se Harness-Bound |
| Melhoria de harness | Médio (engenharia) | Alto se Harness-Bound |
| Fine-tuning | Muito alto (dados + compute) | Médio (específico para domínio) |

A regra prática: esgote melhorias de harness antes de considerar upgrade de modelo ou fine-tuning.

## Aplicação no vault

O vault tem agentes com perfis diferentes de Model-Bound vs Harness-Bound:

- **Nexus como orquestrador:** provavelmente mais Harness-Bound — o modelo base é capaz, mas o CLAUDE.md (harness) define o comportamento. Melhorias no CLAUDE.md têm ROI maior que upgrade de modelo.
- **ingest-report:** pode ser Model-Bound para sínteses muito complexas (muitos artigos, conexões não óbvias). Extended thinking ajuda mais que harness changes.
- **guard:** Harness-Bound em regras claras, Model-Bound para edge cases de segurança ambíguos.

Diagnosticar corretamente antes de investir em melhorias evita trocar o modelo quando o CLAUDE.md precisa de revisão — e vice-versa.

## Links relacionados

- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/sources/ml-research-papers/clipping-ram-framework-reasoning-alignment-memory]]
