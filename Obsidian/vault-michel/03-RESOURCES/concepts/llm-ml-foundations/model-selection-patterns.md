---
title: "Model Selection Patterns"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# Model Selection Patterns

Framework para escolher qual LLM usar para uma tarefa específica, equilibrando capacidade, custo, latência e restrições operacionais.

## O que é

Model selection patterns são heurísticas e matrizes de decisão para escolher o modelo certo antes de construir. A escolha errada — Opus para classificação simples, Haiku para auditoria de segurança — desperdiça orçamento ou produz saída inadequada.

## Como funciona

**Dimensões de decisão:**

| Dimensão | Perguntas-chave |
|---|---|
| Capacidade vs. custo | A tarefa precisa de raciocínio profundo ou é extração mecânica? |
| Latência | Response em <1s (streaming), <5s (sync), ou batch? |
| Context window | Quanto contexto precisa processar de uma vez? (8k vs 200k) |
| Privacidade | Dados sensíveis → modelo local ou VPC; dados públicos → cloud OK |
| Benchmark vs. tarefa real | Qual modelo tem melhor performance no seu dataset específico, não no MMLU |

**Padrões comuns:**

- **Simples-barato**: extração de entidades, classificação, sumarização curta → Haiku/GPT-4o-mini
- **Raciocínio padrão**: código, análise, pergunta-resposta complexa → Sonnet/GPT-4o
- **Raciocínio crítico**: auditoria, decisão estratégica, síntese de pesquisa → Opus/o1
- **Local/edge**: privacidade, offline, custo zero de API → Llama 3 8B Q4, Phi-3-mini
- **Especializado**: modelos fine-tunados no domínio podem superar modelos gerais maiores a menor custo

**Teste antes de fixar**: benchmark no seu dataset real com 50–100 exemplos antes de escolher. Performance em leaderboards públicos não correlaciona perfeitamente com performance na tarefa específica.

## Por que importa

Model selection é a primeira decisão de arquitetura em qualquer sistema LLM. Errar aqui multiplica o custo de todas as iterações seguintes. Um framework de seleção explícito — e revisitado a cada novo modelo lançado — é infraestrutura operacional essencial.

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/model-routing]]

## Evidências
- **[2026-06-19]** Modelo caro (Claude) usado para escrever/refinar skills, modelo barato (MiniMax) usado para executar no dia a dia — roteamento por fase do ciclo de vida do skill, não só por tipo de tarefa — [[how-i-turned-minimax-into-fable-5-97-percent-cheaper]]
- **[2026-06-19]** Kimi K2.7 Code com MCP de design inspiration rivaliza Claude Fable 5 em qualidade de landing page a 1/16 do custo — contexto > capacidade nominal do modelo — [[03-RESOURCES/sources/kimi-k27-code-vs-claude-fable-5-landing-pages]]

- **[2026-06-24]** Deploy the full Claude desktop experience - chat, Claude Cowork, and Claude Code - using inference on AWS, Google Cloud — [[claude-desktop-on-aws-google-cloud-and-microsoft-foundry]]