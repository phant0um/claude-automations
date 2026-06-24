---
title: "anthropics/defending-code-reference-harness: Skills for threat modeling, scanning, triage, patching, plus an autonomous scanning harness you can customize"
type: source
source: "Clippings/anthropicsdefending-code-reference-harness Skills for threat modeling, scanning, triage, patching, plus an autonomous scanning harness you can customize.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, security, claude-code, vulnerability-detection]
---

## Tese central

O repositório `defending-code-reference-harness` da Anthropic é uma implementação de referência para descoberta e remediação autônoma de vulnerabilidades usando Claude, disponibilizando tanto skills interativas para Claude Code quanto um harness autônomo configurável para scanning de C/C++ com ASAN e sandboxing gVisor.

## Argumentos principais

- O repositório disponibiliza skills Claude Code para cada fase do pipeline de segurança: `/quickstart`, `/threat-model`, `/vuln-scan`, `/triage`, `/patch`, `/customize` — cada skill implementa uma etapa específica do loop find-and-fix.
- O harness autônomo executa o ciclo completo recon → find → verify → report → patch de forma não-supervisionada, rodando em sandbox gVisor para isolar a execução de código alvo.
- O pipeline é modular e extensível: a skill `/customize` permite portar o harness para outras linguagens, detectores ou classes de vulnerabilidade.
- Por segurança, as skills de leitura/escrita são seguras sem sandbox, mas o pipeline autônomo (especialmente `/patch` em resultados de pipeline) executa código alvo e requer sandbox gVisor via `bin/vp-sandboxed`.
- O projeto é uma referência, não um produto — o formato geral, prompts e sandboxing são reutilizáveis, mas não funciona out-of-the-box em todo codebase.

## Key insights

- A distinção entre skills interativas (seguras sem sandbox) e pipeline autônomo (requer gVisor) é fundamental para uso seguro em produção.
- O harness é pré-configurado para vulnerabilidades de memória em C/C++ com Docker+ASAN, mas a skill `/customize` guia a portabilidade para outros contextos.
- O repositório complementa o blog post "Using LLMs to secure source code" e o cookbook "Vulnerability Detection Agent" na plataforma Claude.
- Claude Security é o produto gerenciado da Anthropic que implementa esse pipeline em escala, como alternativa ao self-hosting.
- Credenciais (`~/.aws`, `~/.ssh`, `.env`) nunca devem estar disponíveis para o agente — isolamento de credentials é requisito de segurança explícito.

## Exemplos e evidências

- O Project Glasswing (Anthropic) usou abordagem similar e descobriu mais de 10.000 vulnerabilidades de alta/crítica severidade em software open source global até maio de 2026.
- O workflow de parceria com equipes de segurança resultou nas melhores práticas documentadas neste repositório.
- O `setup_sandbox.sh` automatiza a configuração do ambiente gVisor; o pipeline é invocado via `bin/vp-sandboxed`.

## Implicações para o vault

Confirma o paradigma de agentes autônomos de segurança com sandboxing como prática de referência. Conecta diretamente com o artigo "Using LLMs to secure source code" que detalha as seis etapas do loop. Relevante para qualquer discussão sobre harness de agentes, isolamento de execução e pipelines de segurança autônoma.

## Links

- [[03-RESOURCES/sources/using-llms-to-secure-source-code]]
- [[03-RESOURCES/concepts/ai-agents/agentic-harness]]
- [[03-RESOURCES/concepts/ai-agents/agent-security-sandboxing]]
