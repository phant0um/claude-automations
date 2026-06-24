---
title: "Agent Runtime Security"
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, ai-agents, security, runtime, attack-surface]
---

# Agent Runtime Security

## Definição

O runtime de agentes autônomos (harness, tool execution layer, memory subsystem) é um attack surface emergente — não apenas o modelo ou o prompt, mas toda a stack de execução. Diferente de prompt injection (que ataca o input), runtime attacks compromistem a infraestrutura de execução do agente: skills maliciosas, ferramentas envenenadas, memória contaminada, e código não-auditado executando com privilégios do agente.

## Camadas de Ameaça

1. **Skill poisoning** — skills/ferramentas que parecem legítimas mas contêm instruções maliciosas embutidas (ex: SKILL.md com prompt injection sutil). [[detecting-malicious-agent-skills-in-the-wild-using-attention]] detecta via attention patterns.

2. **Tool description poisoning** — tool descriptions que manipulam o agente via metaprompting. [[think-twice-before-you-act-protecting-llm-agents-against-tool-description-poisoning-via-isolated-planning]] propõe isolamento do planning step.

3. **Memory contagion** — bias propagado temporalmente via memória do agente. [[memory-contagion-cross-temporal-propagation-of-evaluator-bias-via-agent-memory]] mostra que bias de um evaluator contamina sessões futuras.

4. **Runtime vulnerability** — o agent runtime layer (harness, CLI, sandbox) tem bugs exploráveis como qualquer software. [[local-llm-agents-as-vulnerable-runtimes-a-source-code-audit-of-the-agent-runtime-layer]] audita via source-code analysis.

5. **Black-box forensics** — sem audit trail, é impossível reconstruir o que um agente fez e por quê. [[black-box-forensics-for-conversational-llm-agents]] propõe técnicas de forensics.

6. **Deception / honeytokens** — armadilhas para detectar agentes maliciosos. [[honeyquest-for-llms-rethinking-cyber-deception-for-ai-attackers]] adapta honeypots para agentes.

## Defesa em Camadas

- **Capability governance**: [[nvidia-verified-agent-skills-provide-capability-governance-for-ai-agents]] — skills verificadas criptograficamente
- **Revocable capabilities**: [[lingering-authority-revocable-resource-and-effect-capabilities-for-coding-agents]] — recursos que podem ser revogados
- **Safe-to-check / unsafe-to-use**: [[safe-to-check-unsafe-to-use-relinking-at-the-compression-boundary-of-llm-agents]] — separação entre verificação e execução
- **AgenticOS**: [[agenticos-an-intent-oriented-secure-operating-system-architecture-for-autonomous-ai-agents]] — OS level security para agentes

## Evidências

- **[2026-06-23]** Agent runtime é attack surface emergente — 8+ sources no run mapeando vetores distintos — [[2026-06-23-relatorio-semanal-run2]]
- **[2026-06-23]** Skill poisoning detectable via attention patterns — [[detecting-malicious-agent-skills-in-the-wild-using-attention]]
- **[2026-06-23]** Tool description poisoning mitigated by isolated planning — [[think-twice-before-you-act-protecting-llm-agents-against-tool-description-poisoning-via-isolated-planning]]
- **[2026-06-23]** Memory contagion: evaluator bias persists across sessions — [[memory-contagion-cross-temporal-propagation-of-evaluator-bias-via-agent-memory]]
- **[2026-06-23]** Runtime layer auditable via source-code analysis — [[local-llm-agents-as-vulnerable-runtimes-a-source-code-audit-of-the-agent-runtime-layer]]
- **[2026-06-23]** Capability governance via cryptographically verified skills — [[nvidia-verified-agent-skills-provide-capability-governance-for-ai-agents]]
- **[2026-06-23]** Revocable resource-and-effect capabilities for coding agents — [[lingering-authority-revocable-resource-and-effect-capabilities-for-coding-agents]]

## Links

- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/ai-agents/harness]]
- [[03-RESOURCES/concepts/ai-agents/security]]
- [[03-RESOURCES/concepts/ai-agents/skill]]
- [[03-RESOURCES/concepts/ai-agents/memory]]