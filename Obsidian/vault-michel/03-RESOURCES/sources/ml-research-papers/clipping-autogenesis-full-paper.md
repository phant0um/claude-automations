---
title: "Autogenesis: A Self-Evolving Agent Protocol (Full Paper)"
type: source
source_type: paper
author: "Wentao Zhang"
created: 2026-05-06
tags: [self-evolving, agent-protocol, agp, autonomous]
triagem_score: 9
---

AGP (Autogenesis Protocol): Resource Substrate Protocol Layer (RSPL) models prompts/agents/tools/environments/memory as versioned resources. Self-Evolution Protocol Layer (SEPL) specifies closed-loop improvement with auditable lineage and rollback. Full paper version of previously ingested stub.

## Source

Ingested from: `clippings/Autogenesis A Self-Evolving Agent Protocol.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Arquitetura do AGP em Detalhe

O Autogenesis Protocol é uma proposta de protocolo formal — não uma implementação específica — para sistemas de agentes que evoluem a si mesmos de forma auditável e reversível. A motivação central é que sistemas agênticos modernos são frágeis: qualquer mudança em prompt, ferramenta, ou memória é feita ad hoc, sem versionamento, sem rollback, e sem lineage de por que a mudança foi feita.

### Resource Substrate Protocol Layer (RSPL)

A RSPL trata todos os componentes do sistema como recursos versionados:

| Tipo de Recurso | Exemplos | Propriedades |
|---|---|---|
| **Prompts** | system prompt, few-shots, CLAUDE.md | versão, hash, autor, timestamp |
| **Agents** | subagente especializado, orquestrador | capacidades declaradas, dependências |
| **Tools** | MCP servers, funções Python, APIs | schema, rate limits, side effects |
| **Environments** | contexto de execução, sandbox | isolamento, permissões, estado |
| **Memory** | episódios, fatos, preferências | TTL, confiança, fonte |

Cada recurso tem um identificador único, histórico de versões, e metadados de proveniência. Isso resolve o problema de "que versão do prompt estava ativa quando o agente cometeu esse erro?" — fundamental para debugging de sistemas agênticos.

### Self-Evolution Protocol Layer (SEPL)

A SEPL especifica como o sistema pode modificar recursos da RSPL de forma controlada:

**Loop de melhoria fechado:**
```
Observação de performance → Hipótese de melhoria
→ Proposta de modificação de recurso
→ Validação em sandbox
→ Aplicação com lineage registrado
→ Rollback automático se degradação detectada
```

Pontos críticos:
- **Sandboxing obrigatório**: modificações são testadas em ambiente isolado antes de promovidas à produção
- **Lineage auditável**: toda modificação registra quem propôs (humano ou agente), qual hipótese motivou, e qual evidência suportava
- **Rollback automatizado**: se métricas pioram após N episódios com o recurso novo, o sistema reverte automaticamente para a versão anterior
- **Quórum para modificações críticas**: mudanças em recursos de alta influência (system prompt principal, orquestrador) requerem aprovação humana mesmo em modo autônomo

## Comparação com Abordagens Existentes

| Abordagem | Versioning | Rollback | Lineage | Auto-evolução |
|---|---|---|---|---|
| **AHE** (harness engineering) | implícito | não | parcial | sim |
| **LoRA/PEFT** | modelo, não harness | difícil | não | não (precisa humano) |
| **Constitutional AI** | regras fixas | não | não | não |
| **AGP/Autogenesis** | explícito (RSPL) | automático | completo | sim (SEPL) |

A diferença do AGP para AHE é que AHE evolui especificamente harnesses de código, enquanto AGP é um protocolo geral que cobre qualquer componente do sistema agêntico.

## Propriedades de Segurança

O paper endereça explicitamente riscos de sistemas auto-evolutivos:

**Drift indetectado**: sem lineage, um sistema pode derivar gradualmente para comportamento não-intencional sem que nenhuma mudança única seja claramente errada. O AGP previne isso com versionamento explícito — cada mudança é um diff auditável.

**Lock-in de prompt ruim**: se um prompt evoluído piora performance em uma sub-tarefa rara, o sistema pode não detectar por semanas. O rollback automático do SEPL usa métricas combinadas para detectar degradações parciais.

**Bootstrap problem**: quem valida a primeira versão do protocolo de validação? AGP resolve com um "genesis version" imutável — a versão 0 de cada recurso crítico é definida pelo humano e marcada como non-evolvable.

## Limitações

- O paper é uma proposta de protocolo, não uma implementação verificada em benchmark
- A RSPL assume que todos os componentes podem ser serializados como recursos — há componentes emergentes (comportamentos que surgem da interação de vários recursos) que não se mapeiam facilmente
- O overhead de versionamento pode ser proibitivo em sistemas com alta frequência de modificação
- Rollback automático assume que métricas de performance capturam o que importa — métricas mal escolhidas podem preservar comportamentos ruins que são difíceis de quantificar

## Relevância para o Vault

O vault-michel já pratica uma versão primitiva do AGP: CLAUDE.md é versionado por git (RSPL manual), erros são logados em `04-SYSTEM/wiki/errors.md` (lineage parcial), e mudanças de comportamento dos agentes são feitas cirurgicamente (princípio Karpathy). O AGP fornece o vocabulário formal para descrever e eventualmente automatizar esse processo.

## Relações

- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — tema central
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — a RSPL generaliza o conceito de harness
- [[03-RESOURCES/sources/ai-agents-harness/clipping-agentic-harness-engineering-full-paper]] — AHE é um caso especial de SEPL aplicado a harnesses
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — memory como recurso RSPL
