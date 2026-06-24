---
title: "I Struggled with AI Agents Until I Built an Incident Response Agent"
type: source
source_type: article
author: "Fran Soto"
created: 2026-05-06
tags: [ai-agents, incident-response, devops, framework]
triagem_score: 8
---

10-step agent building framework: manual to LLM to MCP tools to skills to memory to SOPs to defined agent to periodic execution to state management to multi-agent fleet. Practical progression.

## Source

Ingested from: `clippings/I struggled with AI agents until I built an incident response agent.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## O Problema com "Construir Agentes"

O artigo parte da frustração do autor ao tentar construir agentes que "realmente funcionam" — a maioria das demos impressiona mas falha em produção porque foram construídas em um passo do zero para o sistema completo, sem entender as dependências entre cada componente. O incident response agent foi o primeiro que funcionou em produção, e o artigo decompõe por quê.

## Os 10 Passos em Detalhe

**Passo 1 → Manual**
Antes de automatizar qualquer coisa, execute o processo manualmente e documente cada decisão. O agente que você vai construir precisa replicar esse processo — se você não o entende completamente, o agente vai falhar nos edge cases que você não mapeou. Para incident response: execute manualmente 5 incidentes, documente todos os passos, identifique onde você toma decisões baseadas em julgamento vs onde você segue um algoritmo fixo.

**Passo 2 → LLM simples**
Substitua o passo manual por uma chamada de LLM que recebe o contexto do incidente e propõe os próximos passos. Sem ferramentas, sem memória — apenas "dado isso, o que fazer?" Objetivo: validar que o LLM consegue raciocinar sobre o domínio com o contexto certo. Se o LLM falha aqui, o problema é de contexto ou domínio, não de arquitetura de agente.

**Passo 3 → MCP Tools**
Adicione ferramentas via MCP para ações reais: consultar logs, criar tickets, enviar alertas, escalar para humanos. Cada ferramenta deve ser o mais simples possível — uma ação atômica, não um workflow. Teste cada ferramenta isoladamente antes de dar ao agente.

**Passo 4 → Skills**
Adicione skills para comportamentos especializados: como diagnosticar falhas de banco de dados, como interpretar stack traces de Python, como calcular severidade de incidente. Skills são contexto denso que o agente não precisa raciocinar — são know-how pré-empacotado.

**Passo 5 → Memory**
Adicione memória de episódio: o agente deve lembrar de incidentes anteriores similares e usar como referência. "Esse erro apareceu na semana passada — a solução foi X." Sem memória, o agente trata cada incidente como único e perde o contexto de padrões recorrentes.

**Passo 6 → SOPs**
Formalize os Standard Operating Procedures que você documentou no Passo 1. SOPs são diferentes de skills: skills são conhecimento técnico, SOPs são processos de decisão. "Se severidade > 3 e componente = payments, escalar para on-call imediatamente." SOPs tornam o comportamento do agente previsível e auditável.

**Passo 7 → Agente Definido**
Neste ponto, você tem todos os componentes — agora define formalmente o agente: escopo, persona, o que pode e não pode fazer, quais decisões requerem aprovação humana. O agente definido é a configuração completa: system prompt + skills + SOPs + ferramentas + memória. Teste extensivamente antes do próximo passo.

**Passo 8 → Execução Periódica**
Coloque o agente em modo de execução periódica: a cada 5 minutos, verifica novos incidentes, avalia severidade, e toma ação ou escala. Esta é a transição de "agente que responde a prompts" para "agente que monitora autonomamente." Requer estado persistente e mecanismo de deduplicação (não processar o mesmo incidente duas vezes).

**Passo 9 → State Management**
Com execução periódica, o agente precisa de gerenciamento de estado explícito: quais incidentes estão em progresso, quais ações foram tomadas, quais aguardam resposta humana. State management resolve o problema de "o agente esqueceu que estava investigando isso." Armazenamento simples (Redis, banco de dados, arquivo) com schema definido.

**Passo 10 → Multi-Agent Fleet**
Escale para múltiplos agentes especializados: um agente monitora infra, outro monitora banco de dados, outro monitora APIs externas. Um orquestrador agrega alertas e coordena resposta. Esta é a arquitetura final — mas só faz sentido quando os passos anteriores estão estáveis.

## Por que a Ordem Importa

O artigo é explícito: pular etapas gera falhas difíceis de diagnosticar. Se você vai direto para Passo 10 sem o Passo 1 (processo manual documentado), você não sabe o que o agente deveria estar fazendo e não consegue verificar se está correto.

A progressão também respeita o princípio de "adicionar complexidade apenas quando necessário": cada passo adiciona uma dependência nova. Passos 1-2 têm zero dependências externas. Passos 3-4 dependem de infraestrutura de ferramentas. Passos 5-6 dependem de storage. Passos 7-9 dependem de scheduling. Passo 10 depende de tudo anterior.

## Incident Response como Domínio de Teste Ideal

O autor explica por que incident response foi o domínio que finalmente funcionou:
- **Critério de sucesso claro**: o incidente foi resolvido? Sim/não. Fácil de medir.
- **Urgência real**: força o agente a tomar decisões rápidas, não ficar em loop de análise
- **Escalada para humanos natural**: quando o agente tem dúvida, escalar é o comportamento correto — fácil de implementar e de verificar
- **Dados históricos abundantes**: toda empresa tem logs de incidentes passados para treinar a memória do agente

## Relevância para o Vault

O framework de 10 passos é uma metodologia de construção de agentes aplicável a qualquer domínio. Os agentes do vault-michel seguem implicitamente essa progressão: o design manual (AGENTS.md) veio primeiro, depois ferramentas MCP, depois skills especializadas. O Passo 8 (execução periódica) corresponde aos agentes de manutenção schedulados do vault.

## Relações

- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — o "agente definido" do Passo 7 é o harness
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — Passo 10
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — Passos 5 e 9
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — Passo 3 (ferramentas)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — Passo 4
