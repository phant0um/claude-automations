---
title: "Using LLMs to secure source code"
type: source
source: "Clippings/Using LLMs to secure source code.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, security, vulnerability-detection, claude-opus, anthropic]
---

## Tese central

Com LLMs como Claude Opus, a descoberta de vulnerabilidades de segurança é agora simples de paralelizar — o gargalo deslocou-se para verificação, triage e patching. O artigo apresenta um pipeline de seis etapas (threat model → sandbox → discovery → verification → triage → patching) com as melhores práticas destiladas de parcerias com equipes de segurança.

## Argumentos principais

- Discovery otimiza para recall; verification otimiza para precisão — rodar ambos no mesmo agente leva a self-censura e exclusão de true positives. Agentes separados com contextos isolados são mandatórios.
- Threat modeling antes do scanning reduz drasticamente false positives: equipes com threat models bem definidos tiveram 90% de achados exploitáveis. Equipes sem threat model tiveram 40% de false positive rate em alguns casos.
- Um adversarial verifier independente "reduziu pela metade a taxa de achados não-exploitáveis"; exigir que o verifier também construa PoC funcional reduziu false positives a "quase zero."
- Prompts mais prescritivos na discovery pioram os resultados — deixar o modelo escolher como escanear produz mais bugs novos. Fornecer goal e context, não checklist de como fazê-lo.
- Na discovery, paralelizar por partições (attack surface, endpoint, componente) e depois rodar uma passagem sistêmica evita convergência em bugs superficiais. Escalar horizontalmente sem particionamento gera principalmente duplicatas.

## Key insights

- `THREAT_MODEL.md` deve viver no repo e ser lido pelo agente de discovery antes de escanear — documenta trust boundaries, o que é e não é vulnerabilidade no contexto do sistema.
- Discovery → Verification → Triage → Patching forma um defender's loop; as primeiras duas etapas (threat model + sandbox) são setup único por codebase.
- Triage tornou-se o novo gargalo: modelos conseguem encontrar centenas de candidatos antes do almoço, mas deduplcar por root cause e priorizar por exploitabilidade real exige estrutura explícita.
- Para patching: escrever teste que falha primeiro, implementar fix, confirmar que o PoC original não funciona mais, re-atacar com agente fresh de discovery — "test-driven remediation."
- Rubrica de severidade explícita (reachability, attacker control, preconditions, authentication, read vs. write, blast radius) evita que modelos ancorem no bug class para inflar severity.

## Exemplos e evidências

- Até 22 de maio de 2026, o scanning da Anthropic de software open source havia divulgado 1.596 vulnerabilidades. Apenas 97 foram patchadas — o gargalo não é encontrar, é corrigir.
- Um time pentesting com harness de sandbox e PoC alcançou taxa de true positives "próxima de 100%".
- Verifier adversarial "roughly halved" a taxa de achados não-exploitáveis da fase de discovery.
- Equipe que revisou CVEs históricos e distilou em "bug-shape hints" encontrou 3 issues exploitáveis em uma hora usando abordagem "what have people exploited in the past".

## Implicações para o vault

Companion direto do repositório `defending-code-reference-harness`. O padrão de separação de agentes por função (discover/verify/triage/patch) é aplicável a outros domínios de multi-agent orchestration além de segurança. O conceito de "adversarial verifier" ecoa o padrão adversarial-verification dos dynamic workflows.

## Links

- [[03-RESOURCES/sources/anthropicsdefending-code-reference-harness-skills-for-threat-modeling-scanning-triage-patching-plus-an-autonomous-scanning-harness-you-can-customize]]
- [[03-RESOURCES/concepts/ai-agents/agentic-harness]]
- [[03-RESOURCES/concepts/ai-agents/adversarial-verification]]
- [[03-RESOURCES/entities/anthropic]]
