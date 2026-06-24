---
title: "Streamlining Security Investigations with Agents"
type: source
source: "Clippings/Streamlining Security Investigations with Agents.md"
url: "https://slack.engineering/streamlining-security-investigations-with-agents/"
author: "Dominic Marks (Slack Security Engineering)"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents, multi-agent-systems, agent-security, orchestration, production-case-study]
---

# Streamlining Security Investigations with Agents

**Autor:** Dominic Marks, Staff Software Engineer — Slack Security Engineering
**Fonte:** Slack Engineering Blog (primeiro post de uma série)

## Tese central

Slack construiu um serviço de investigação de segurança **agêntico** que despacha times de agentes de IA para investigar alertas colaborativamente. Em um trimestre: **7.500+ investigações, 500.000+ tool calls**. O design evoluiu de um prompt monolítico de ~300 palavras para uma arquitetura de **múltiplos invocations de modelo, cada um com propósito único e structured output**, orquestrados em fases — trocando "prompt guidelines" por controle fino e granular sobre o processo de investigação.

## Argumentos principais

1. **Prototype monolítico falhou por falta de controle granular**. O prompt original tinha 5 seções (Orientation, Manifest, Methodology, Formatting, Classification) rodando sobre um MCP server "stdio mode" reaproveitando uma coding agent CLI como execution environment. Performance era altamente variável: às vezes cross-referenciava evidência entre fontes com qualidade impressionante; às vezes pulava para conclusões espúrias sem questionar os próprios métodos. **"Prompts são apenas guidelines; não são um método efetivo para controle fino."**

2. **Solução: decompor em sequência de model invocations com structured output**. Cada task tem propósito único + formato de output definido por JSON schema. Guidance vaga como "question your evidence" virou uma **task separada e discreta** no fluxo, com comportamento muito mais previsível. Trade-off explícito: structured output não é "grátis" — se o formato é complexo demais para o modelo, a execução pode falhar; também sujeito a cheating/hallucination.

3. **Inspirações da literatura**: Meta-Prompting (Stanford/OpenAI, "Task-Agnostic Scaffolding") e "Unleashing Emergent Cognitive Synergy... Multi-Persona Self-Collaboration" (Microsoft Research). Ambos descrevem múltiplas personas **dentro de uma única invocation de modelo** — Slack adaptou para **personas como invocations independentes** para manter controle. Também inspirados por security tabletop exercises.

4. **Arquitetura de 3 personas (Investigation Loop)**:
   - **Director Agent**: progride a investigação do início ao fim; interroga experts formando perguntas; usa uma "journaling tool" para planejamento.
   - **Expert Agent**: 4 domain experts especializados — **Access** (auth/authz/perimeter), **Cloud** (infra/compute/orchestration/networking), **Code** (análise de source code/config), **Threat** (threat intel). Cada um produz findings a partir de seus data sources em resposta às perguntas do Director.
   - **Critic Agent** ("meta-expert"): avalia/quantifica qualidade dos findings dos experts via rubric definido, anota com credibility score, e fecha o loop devolvendo conclusões ao Director. A relação **fracamente adversarial** Critic↔Expert mitiga alucinação e variabilidade de interpretação.

5. **Knowledge Pyramid — model routing por custo/função**. Fluxo: experts (modelo barato, muitos tool calls, alto volume de tokens) → Critic revisa findings + tool calls/results que os suportam (também token-intensive) → Critic monta timeline atualizada integrando timeline corrente + novos findings, mantendo só os mais críveis → Director (modelo caro) recebe a timeline condensada. **Permite usar modelos low/medium/high-cost estrategicamente para expert/critic/director respectivamente** — análogo direto a model-routing por função na arquitetura.

6. **Investigation Flow em 3 fases, controladas pelo Director**:
   - **Discovery**: fase inicial — garantir que toda fonte de dados disponível seja examinada; Director gera pergunta broadcast para todo o time de experts.
   - **Director Decision**: meta-fase onde Director decide avançar de fase ou continuar (prompt inclui guidance sobre quando avançar).
   - **Trace**: Director escolhe um expert específico para questionar; flexibilidade para variar parâmetros de invocation por fase (modelo diferente, budget de tokens maior).
   - **Conclude**: transição quando há informação suficiente para o relatório final.

7. **Arquitetura de serviço de produção** (não mais a coding-agent-CLI do protótipo):
   - **Hub**: API do serviço + storage persistente + metrics endpoint (visualização de atividade, uso de tokens, custo).
   - **Worker**: pega tasks de investigação da fila, produz event stream de volta ao hub, escalável horizontalmente.
   - **Dashboard**: observação em tempo real via consumo do event stream + ferramentas de management para inspecionar cada model invocation (crítico para debugging).

## Key insights

- **Structured output transforma "guidance" em "task"**: o mesmo conteúdo de instrução ("question your evidence") tem comportamento muito mais previsível quando vira uma etapa discreta com schema próprio, vs. uma frase dentro de um prompt monolítico.
- **Adversarial-mas-colaborativo (Critic vs Expert) é um mecanismo de qualidade**, não apenas um passo a mais — ele captura blind spots que o expert original não viu.
- **Routing de custo por papel funcional** (não por dificuldade da tarefa global) — experts baratos fazem o trabalho de "garimpo" de alto volume; modelos caros só veem a destilação.
- Agentes fazem **descobertas espontâneas não solicitadas** — não são apenas "regras estáticas de detecção" executadas mais rápido.

## Exemplos e evidências

**Caso real**: alerta originalmente disparado por uma sequência de comandos específica (indicador de comprometimento). Durante a investigação, os agentes traçaram a hierarquia de processos e **descobriram independentemente uma exposição de credencial em um processo ancestral** — não relacionado ao alerta original.

Trecho do relatório (editado):
> *Investigation Report: Credential Exposure in Monitoring Workflow [ESCALATE]*
> *Summary: While investigating [command sequence], the investigation uncovered a credential exposure elsewhere in the process ancestry chain.*
> 1. Credential Exposure: credencial exposta em parâmetros de linha de comando dentro da cadeia de ancestralidade.
> 2. Expert-Critic Contradiction: o **expert** avaliou incorretamente o handling de credenciais como seguro; o **critic** identificou corretamente as credenciais expostas — sinalizando um "blind spot" de análise que requer atenção.

O Director então **pivotou a investigação** para focar nesse novo achado, reportando tanto a necessidade de mitigação quanto a falha de análise do expert original (encaminhado à equipe responsável).

Métricas de escala do trimestre: **7.500+ investigações**, **500.000+ tool calls**.

Tópicos prometidos para próximos posts: alinhamento/orientação durante investigações multi-persona, artefatos como canal de comunicação entre participantes, human-in-the-loop em investigações de segurança.

## Implicações para o vault

1. **Validação empírica em produção do padrão Director/Expert/Critic**, complementar ao `[[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]` e `[[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]` — aqui o "verifier" (Critic) não só valida mas pode **redirecionar** o trabalho do orquestrador.
2. **Knowledge Pyramid (routing por custo/função)** é um caso concreto e production-grade de `[[03-RESOURCES/concepts/agent-systems/agent-model-routing]]` — relevante para o `model-router` recém-criado no vault (commit e331221).
3. **Fases controladas por um agente orquestrador** (Discovery → Director Decision → Trace → Conclude) é um padrão aplicável a pipelines do vault (ex: pipeline-ads, ingest-report) — fases explícitas com critério de transição decidido pelo próprio agente.
4. Relevante para `[[04-SYSTEM/agents/core/guard]]` (segurança, Opus) — caso de uso direto de agentic security investigation que pode inspirar extensões futuras do agente guard.

## Links

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[03-RESOURCES/concepts/agent-security]]
- [[04-SYSTEM/agents/core/guard]]
