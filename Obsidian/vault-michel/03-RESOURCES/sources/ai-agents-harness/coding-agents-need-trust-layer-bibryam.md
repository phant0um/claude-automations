---
title: "Coding Agents Need a Trust Layer"
type: source
source: "Clippings/Coding Agents Need a Trust Layer.md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, agent-quality, trust-layer, guardrails, provenance, harness]
---

## Tese central

Agentes de código (Claude Code, Cursor, Codex) tornaram rascunhos mais baratos, mas não tornaram código mais confiável. O próximo gargalo é uma **camada de qualidade de agente** — que senta entre o agente e o pull request — composta por quatro elementos: sensores de feedback, evals semânticos, limites de refatoração e proveniência.

## Argumentos principais

- **Build verde não é suficiente:** compilou, formatou e passou testes existentes não garante que regras de negócio foram preservadas, que testes são significativos, que arquitetura foi respeitada ou que o agente não tocou ferramentas proibidas.
- **Sensores de feedback (Feedback sensors):** agentes sem feedback de compilador, lint, tipos e testes transferem ao revisor humano o papel de primeiro gatekeeper de qualidade — o que é "backwards". Ferramentas: `cargo-mutants` (mutation testing), `WuppieFuzz` (fuzzing), mensagens customizadas de lint.
- **Evals semânticos:** código pode compilar e ainda fazer a coisa errada. Testes verificam outputs; evals semânticos verificam *significado*. Ferramentas: golden examples, DeepEval, LLM-as-judge com exemplos revisados, hallucination checks, tool-use checks.
- **Limites de refatoração (Refactor boundaries):** agentes reescrevem código mais rápido do que humanos revisam. Em módulos limpos é útil; em hotspots legados é perigoso. Uma classe de 2.000 linhas com lógica de negócio não documentada pode ter comportamentos deletados silenciosamente. Zonas: verde (limpeza segura), amarelo (mudanças limitadas), vermelho (exige design humano primeiro). Ferramentas: CodeScene (hotspots), CODEOWNERS (caminhos de risco), dependency-cruiser/ArchUnit/Spring Modulith (boundaries).
- **Proveniência e inventário de superfície:** `git blame` mostra quem commitou, não qual agente/modelo/prompt/skill/servidor MCP contribuiu. Rastrear: agente, modelo, resumo de prompt, tool calls, arquivos gerados, pontos de takeover humano. MCP servers, plugins, skills e credenciais devem ser tratados como dependências de supply chain — com allowlist, versões pinadas, credenciais de least-privilege, scan via Snyk Agent Scan.
- **A superfície de ataque do agente não é apenas o modelo — é tudo que o modelo pode chamar.**

## Key insights

- O próximo disciplina de engenharia não é "vibe coding mais rápido" — é construir o harness ao redor dos agentes.
- Feedback deve chegar ao agente *enquanto trabalha*, não depois de abrir PR — fast failures in-loop.
- Evals semânticos capturam a classe de falhas que testes determinísticos frequentemente perdem (lógica de policy, transformações de dados, comportamentos visíveis ao cliente).
- O raio de explosão (blast radius) de um agente numa codebase legada é um risco de engenharia real, não hipotético.
- Vocabulário compartilhado MITRE ATLAS para riscos agênticos é um padrão emergente.
- Provenance trails + agent surface inventory = auditabilidade de código gerado por IA.

## Exemplos e evidências

- Classe de 2.000 linhas com anos de lógica de negócio = exemplo de zona vermelha onde agente pode deletar comportamento não documentado.
- Referência ao trabalho de Birgitta Böckeler sobre "maintainability sensors".
- Ferramentas mencionadas: CodeScene, CODEOWNERS, dependency-cruiser, ArchUnit, Spring Modulith, cargo-mutants, WuppieFuzz, DeepEval, Git AI, Git Notes, Agent Trace, Snyk Agent Scan, MITRE ATLAS.
- Post completo: [generativeprogrammer.com/p/the-missing-quality-layer-for-ai](https://generativeprogrammer.com/p/the-missing-quality-layer-for-ai)

## Implicações para o vault

- Expande e complementa [[03-RESOURCES/sources/ai-agents-harness/agent-governance-layers]] com os 4 pilares concretos.
- A ideia de "zonas verde/amarelo/vermelho" é diretamente aplicável à gestão de mudanças no vault.
- Sensores de feedback e evals semânticos são relevantes para o design do agente `verify` em [[04-SYSTEM/agents/]].
- Proveniência de agente é conceito ainda ausente no vault — candidato a nova nota de conceito.
- Complementa [[03-RESOURCES/sources/ai-agents-harness/agent-hooks-deterministic-control]] — hooks são um mecanismo de feedback in-loop.

## Links
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/concepts/agent-governance]]
- [[03-RESOURCES/sources/ai-agents-harness/agent-governance-layers]]
