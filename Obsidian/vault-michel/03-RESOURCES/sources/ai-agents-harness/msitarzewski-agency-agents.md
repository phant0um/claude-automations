---
title: "msitarzewski/agency-agents — A complete AI agency at your fingertips"
type: source
category: tools
author: "@msitarzewski"
source: "https://github.com/msitarzewski/agency-agents"
published:
ingested: 2026-05-18
tags: [claude-code, ai-agents, agent-personalities, multi-tool, github-repo]
triagem_score: 7
---

# msitarzewski/agency-agents

## Tese central

Coleção de personalidades de agentes IA especializados (The Agency), cada um com identidade, missão, deliverables e métricas de sucesso definidos — instaláveis diretamente no Claude Code e compatíveis com 9+ ferramentas (Cursor, Aider, Gemini CLI, Copilot, Windsurf, etc.).

## Key Insights

- Nasceu de um thread no Reddit e meses de iteração; foco em profundidade de domínio, não templates genéricos.
- Cada agente tem: especialidade técnica, personalidade distinta, deliverables concretos (código real), e success metrics.
- Instalação em Claude Code: `./scripts/install.sh --tool claude-code` ou cópia manual de `engineering/*.md` para `~/.claude/agents/`.
- Multi-tool: script `convert.sh` gera arquivos de integração para todos os tools suportados automaticamente.

## Divisões principais

| Divisão | Agentes notáveis |
|---|---|
| Engineering (25+) | Frontend Developer, Backend Architect, AI Engineer, Security Engineer, Software Architect, SRE, Autonomous Optimization Architect |
| Design | UI/UX specialists |
| Marketing | Reddit community ninja, whimsy injector |
| Quality | Reality checker |

## Agentes de destaque

- **Autonomous Optimization Architect** — LLM routing, cost optimization, shadow testing
- **Codebase Onboarding Engineer** — exploração read-only de repos novos, fatos sobre estrutura
- **AI Data Remediation Engineer** — self-healing pipelines, semantic clustering, zero data loss
- **Email Intelligence Engineer** — parsing MIME, contexto reasoning-ready para agentes
- **Voice AI Integration Engineer** — Whisper, ASR, speaker diarization

## Links

- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- Ver também: [[03-RESOURCES/sources/agentic-skills-claude-chatgpt-gemini]]

---

## Por que identidade e personalidade importam em agentes

A maioria dos repositórios de agentes IA fornece templates genéricos — "você é um assistente de engenharia". O agency-agents parte de uma premissa diferente: agentes com **identidade distinta, missão específica e deliverables concretos** produzem output de qualidade substancialmente superior aos genéricos.

O mecanismo: personalidade e missão específicas reduzem o espaço de decisão do modelo. Um "Frontend Developer" com stack definida (React, TypeScript, Tailwind), convenções explícitas e deliverables concretos (componentes funcionais, testes unitários, Storybook stories) não precisa raciocinar sobre qual abordagem adotar — a identidade já definiu.

## Anatomia de um agente do agency-agents

Cada arquivo de agente tem estrutura consistente:

```markdown
# [Nome do Agente]

## Mission
[Uma frase sobre o propósito do agente]

## Expertise
[Stack técnica, domínios de conhecimento, ferramentas]

## Personality
[Tom, estilo de comunicação, valores de trabalho]

## Deliverables
[O que o agente produz: código, análises, relatórios]

## Success Metrics
[Como medir se o agente fez bem o trabalho]

## Process
[Como o agente aborda problemas — seu SOP]
```

A seção `Success Metrics` é raramente encontrada em agentes genéricos — ela obriga o construtor a definir o que "bom" significa para aquele agente específico.

## Agentes de destaque: análise detalhada

### Autonomous Optimization Architect
Faz roteamento dinâmico de LLM: determina qual modelo usar para cada tarefa (por custo, latência, qualidade). Usa shadow testing para validar que a troca de modelo não degrada qualidade antes de mudar em produção. Este é o agente de maior impacto financeiro: otimizar gasto de LLM via roteamento inteligente pode reduzir custos em 40-70%.

### Codebase Onboarding Engineer
Explora novos repos em modo read-only — nunca escreve, apenas lê e relata. Produz: estrutura de diretórios com anotações, fluxos principais de dados, convenções de código identificadas, gaps de documentação, pontos de entrada recomendados. Ideal como primeiro agente a rodar em um codebase desconhecido.

### AI Data Remediation Engineer
Self-healing data pipelines: quando dados chegam malformados, corrompidos ou inconsistentes, esse agente classifica o problema, aplica remediação automática quando possível, escala para humano quando não. O objetivo "zero data loss" significa que dados irremediáveis são arquivados, não descartados.

### Email Intelligence Engineer
Parseia MIME completo (incluindo attachments), extrai entidades, classifica intent, gera contexto reasoning-ready para outros agentes. O output não é um resumo de email — é dados estruturados que outro agente pode usar para tomar decisão.

### Voice AI Integration Engineer
Integra Whisper (STT), modelos de síntese de voz (TTS), diarização de speakers. Especializado em pipeline completo de voz: captura → transcrição → processamento → resposta → síntese — incluindo edge cases de múltiplos speakers e ruído de fundo.

## Sistema de instalação multi-tool

O script `convert.sh` é o que torna o agency-agents genuinamente multi-tool: gera automaticamente os formatos de configuração para cada ferramenta suportada. Um agente definido uma vez pode ser exportado para:
- Claude Code (`~/.claude/agents/`)
- Cursor (`.cursor/rules/`)
- Aider (arquivo de instruções)
- Gemini CLI (config de agente)
- Copilot (instrução de workspace)
- Windsurf (config de agente)

Isso resolve um problema real: equipes que usam ferramentas diferentes podem compartilhar definições de agente sem reescrever.

## Comparação com sub-agents do @heynavtoor

| Dimensão | agency-agents | 7 sub-agents (@heynavtoor) |
|---|---|---|
| Número de agentes | 25+ engineering + design + marketing | 7 especializados por role |
| Complexidade por agente | Alta (personalidade completa, métricas) | Média (instruções focadas) |
| Instalação | Script automático, multi-tool | Manual, pasta `.claude/agents/` |
| Manutenção | Repo ativo, contribuições abertas | Definição estática |
| Adequado para | Equipes técnicas, projetos complexos | Indivíduos, workflows de content |

## Aplicação no vault

O vault tem agentes em `04-SYSTEM/agents/`. A estrutura do agency-agents — com `Mission`, `Deliverables` e `Success Metrics` explícitos — é um padrão de qualidade superior ao que o vault usa atualmente. Migrar as definições de agentes do vault para este formato melhoraria consistência de output e facilitaria debug quando um agente produz resultado abaixo do esperado.

O `Codebase Onboarding Engineer` tem análogo direto no vault: um agente de "Vault Exploration" que mapeia a estrutura do vault para novos usuários (ou para o próprio sistema após mudanças estruturais grandes).

## Referências adicionais

- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]] — engenharia de harness para agentes
- [[03-RESOURCES/sources/ai-agents-harness/7-claude-sub-agents-200k-team-heynavtoor]] — alternativa mais simples com 7 agentes
- [[03-RESOURCES/sources/misc-low-confidence/post-kloss-xyz-goal-23-casos-de-uso]] — casos de uso que agentes especializados executam melhor
