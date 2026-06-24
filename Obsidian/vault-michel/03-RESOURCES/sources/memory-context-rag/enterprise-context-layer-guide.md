---
title: "What an Enterprise Context Layer Actually Is"
type: source
source: "Clippings/What an Enterprise Context Layer Actually Is.md"
created: 2026-06-01
ingested: 2026-06-02
tags: [ai-agents, enterprise-ai, context-layer, knowledge-graph, agent-architecture]
author: "@prukalpa"
---

## Tese central
Context layer empresarial não é catálogo de dados ou semantic layer — é o sistema que transforma conhecimento, expertise e normas em contexto machine-usable para agentes IA, sendo a infraestrutura compartilhada que torna o décimo agente dramaticamente melhor que o primeiro.

## Argumentos principais
- 3 tipos de contexto que todo agente precisa para operar em negócio real:
  - **Knowledge**: mapa do negócio — entidades, definições, métricas, relações, glossário
  - **Expertise**: como o trabalho é feito — procedimentos, workflows, playbooks; hoje dispersos em SOPs, tickets, Slack, cabeças de pessoas
  - **Norms**: regras de ação aceitável — políticas, permissões, paths de aprovação, compliance; o que é PERMITIDO além do que é verdadeiro
- Context layer = core substrate + 5 capabilities operacionais
- Shared enterprise brain: fundação que cada agente usa e para a qual contribui de volta
- Os 3 tipos no substrate: Knowledge → AI-ready data + knowledge graph; Expertise + Norms → skills

## Arquitetura — Core Context Substrate
**3 partes integradas (nenhuma funciona sem as outras):**
1. **AI-ready data + knowledge graph**: representação integrada de ativos de dados; estrutura confiável e interpretável por agentes
2. **Semantics + ontology**: o que as coisas significam e como se conectam — sem isso dados são não-interpretáveis
3. **Skills**: como o trabalho é feito aqui e o que é permitido — sem isso descrição sem operação

**5 capabilities (sistema operacional que produz, governa, entrega e melhora o substrate):**
Não completamente detalhadas na fonte, mas implicadas como: produção, governança, delivery, feedback loop, e atualização contínua.

## Key insights
- "Data without semantics is uninterpretable, semantics without data describes a business nobody can query"
- O décimo agente é dramaticamente melhor que o primeiro porque herda o que os anteriores aprenderam — efeito compounding
- Norms são distintas de Knowledge e Expertise: não apenas o que é verdadeiro ou como fazer, mas o que é PERMITIDO
- Context layer ≠ RAG system: vai além de busca vetorial — inclui governança, ontologia e operação
- Enterprise context layer = "shared enterprise brain": fundação única, não silos por agente

## Exemplos e evidências
- Contexto: autor tem mesma conversa com CIOs quase todos os dias — dor validada em múltiplas organizações
- Analogia: "talking to a colleague who was there for every session"
- Skills em substrate = know-how operacional + compliance constraints em formato machine-usable

## Implicações para o vault
- vault-michel implementa versão pessoal deste padrão: Knowledge (03-RESOURCES/concepts), Expertise (04-SYSTEM/skills), Norms (CLAUDE.md + guard)
- O "décimo agente melhor" alinha com knowledge-compounding: vault fica mais valioso com cada ingest
- Substrate 3-partes (data + semantics + skills) = mapa direto para (sources + concepts/entities + skills) no vault
- Lacuna: vault não tem knowledge graph explícito (wikilinks são aproximação; Qdrant seria upgrade)
- Norms como categoria distinta: guard agent do vault serve esse papel mas não está formalizado como tal

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[04-SYSTEM/agents/core/guard]]
- [[04-SYSTEM/agents/nexus]]
