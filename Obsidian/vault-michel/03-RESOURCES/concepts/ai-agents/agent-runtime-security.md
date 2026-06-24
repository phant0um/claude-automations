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
- **[2026-06-24]** You can write "do not modify prod. — [[claude-code-hooks-the-most-powerful-feature-nobody-uses]]
- **[2026-06-24]** Control what an eve agent's model sees and when, across instructions, skills, the workspace, and sub — [[context-control]]
- **[2026-06-24]** Introducing Flounder: An Autonomous White-Hat Security Auditor. — [[flounder-an-autonomous-white-hat-security-auditor]]
- **[2026-06-24]** The hype the last couple of weeks has been around implementing loops and to quote Satya Nadella: \*A — [[how-we-built-secure-automated-learning-loops-in-modal-and-claude-code]]
- **[2026-06-24]** While the validity of LLMs’ use in the legal context remains subject to ethical and legal debate, le — [[llms-prompted-for-legal-context-object-more-overrefusal-from-small-on-premises-llms-in-criminal-legal-context]]
- **[2026-06-24]** Memory is the word AI engineers borrow whenever dealing with a complex system that needs access to i — [[memory-is-not-storage]]
- **[2026-06-24]** **Anthropic made the Slack agent credible for enterprises. — [[the-real-claude-tag-question-is-context-ownership]]
- **[2026-06-24]** ## Cybersecurity Skills Router / Reverse-Engineering Skill Routing Pack. — [[authorized-penetration-testing-security-research-skill-router-pack-ai-powered-routing-on-demand-toolchain-bootstrapping-self-evolving-knowledge-base-supports-claude-code-kiro-cursor-cline-and-other-ai-coding-clients-ai]]
- **[2026-06-24]** For an AI agent to do its best work on a human-agent team, it needs access to the same tools, docume — [[agent-identity-a-new-access-model-for-autonomous-team-wide-ai]]
- **[2026-06-24]** If you run a clinic or hospital network, you already know the cost of missed appointments. — [[build-a-healthcare-appointment-agent-with-amazon-nova-2-sonic]]
- **[2026-06-24]** How an eve session runs. — [[execution-model-and-durability]]
- **[2026-06-24]** **TLDR:** The full playbook for optimizing GLM-5. — [[how-to-get-elite-glm-5-2-outputs]]

## Links

- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/ai-agents/harness]]
- [[03-RESOURCES/concepts/ai-agents/security]]
- [[03-RESOURCES/concepts/ai-agents/skill]]
- [[03-RESOURCES/concepts/ai-agents/memory]]
- **[2026-06-24]** Eve separa app runtime (trusted, secrets, Node.js) de sandbox (isolated, no secrets, /workspace). Auth fails closed.... — [[security-model-eve]]
- **[2026-06-24]** Fault tolerance extrema = Isolation + Redundancy + Static Stability. PlanetScale: control plane (mais dependências) vs... — [[the-principles-of-extreme-fault-tolerance]]
