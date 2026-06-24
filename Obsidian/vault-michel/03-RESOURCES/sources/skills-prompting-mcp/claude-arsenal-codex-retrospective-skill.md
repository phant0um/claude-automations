---
title: "claude-arsenal: codex-retrospective skill"
type: source
source: "Clippings/claude-arsenalskillscodex-retrospective at main.md"
original_url: "https://github.com/majiayu000/claude-arsenal/blob/main/skills/codex-retrospective/SKILL.md"
author: "majiayu000"
published: 2026-05-28
created: 2026-05-28
ingested: 2026-05-29
tags: [ai-agents, claude-code, codex, skills, self-improvement, retrospective, agentsmd]
---

## Tese central

`codex-retrospective` é uma skill de auto-melhoria estruturada para o Codex: ao analisar sistematicamente o histórico de uso real, o agente identifica padrões de erro, pontos de fricção recorrentes e sucessos codificáveis, produzindo updates mínimos e baseados em evidências para `AGENTS.md` e novas skills tiny. O objetivo é fazer o Codex "meaningfully better at working with you" ao longo do tempo.

## Argumentos principais

- A maioria das pessoas melhora uso de agentes de forma reativa e manual — esta skill torna isso deliberado, regular e de alto leverage
- Inspiração declarada: "Greg Brockman's emphasis on updating the 'constitution' from real failures and friction" — executado como workflow arsenal-style repetível
- Princípio core: **"Minimal effective change, grounded in evidence from actual history"** — cada output deve ser a menor mudança possível, fundamentada em sessões reais, projetada para prevenir recorrência da mesma fricção
- O processo: (1) scope por janela de tempo ou área de foco → (2) Codex analisa histórico buscando padrões → (3) output em formato estrito → (4) human gate → (5) aplicação das mudanças mínimas
- Hard constraints: nunca rewrites grandes de AGENTS.md; nunca skills grandes — tiny, focused, high-ROI apenas; cada proposta deve referenciar histórico concreto
- Se nada de alta confiança foi encontrado: dizer claramente em vez de fabricar melhorias

## Key insights

- **Formato de output estrito:** (1) Retrospective Summary → (2) Proposed AGENTS.md Updates (diff ou append apenas) → (3) New/Refined Minimal Skills (máximo 1-2 tiny, com frontmatter completo) → (4) Rationale + Evidence → (5) Application Plan
- **Complemento com codex-fluent:** `codex-retrospective` = melhorias comportamentais e de conhecimento. `codex-fluent` = higiene de estado e contexto. Monthly ritual: retrospective dos últimos 30 dias → fluent diagnosis → aplicar melhores mudanças de ambos
- **Human gate obrigatório:** A skill ajuda a aplicar as mudanças mínimas de forma limpa (nunca sobrescrevendo grandes seções de AGENTS.md cegamente), mas o humano revisa antes
- **Triggers:** após sessão dolorosa/repetitiva; periódico (semanal/mensal); quando fluent reporta que Codex fica pedindo o mesmo contexto repetidamente; após corrigir a mesma classe de erro várias vezes
- **Sucesso em 4-8 semanas:** Codex comete menos erros básicos de domínio; menos tempo re-explicando preferências; AGENTS.md parece escrito por alguém que trabalhou com você por muito tempo; novos projetos rampeiam mais rápido porque a "constituição" já encoda lições difíceis
- **O que conta como "tiny useful skill":** definido por `references/minimal-skill-criteria.md` — critério explícito para evitar skill sprawl

## Exemplos e evidências

- 74 production-ready skills no claude-arsenal
- Exemplos reais (sanitizados) de retrospective outputs e diffs de AGENTS.md em `references/examples/`
- Referência: Greg Brockman's emphasis on updating "constitution" from real failures
- Core prompt template em `references/retrospective-prompt.md`
- Regras de que tipos de mudanças são aceitáveis em `references/agents-md-update-rules.md`

## Implicações para o vault

- O padrão de `codex-retrospective` é análogo ao processo de `hill` (agente de melhoria contínua do vault) — ambos usam histórico real como evidência para melhorias incrementais
- O princípio "minimal effective change grounded in evidence" é um framework aplicável ao próprio sistema de skills do vault em `04-SYSTEM/skills/`
- Conecta com [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning|agent feedback loop learning]] — loop de melhoria contínua baseado em histórico de uso
- A diferenciação codex-retrospective (comportamento/conhecimento) vs codex-fluent (estado/contexto) é uma divisão de responsabilidades clara que o vault pode adotar para seus próprios processos de melhoria
- O requisito de "evidência de histórico concreto" antes de propor mudanças é uma proteção contra o problema de agentes que "fabricam melhorias" sem fundamento

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]]
- [[03-RESOURCES/concepts/claude-code-tooling/claudemd-self-improvement-loop]]
- [[03-RESOURCES/sources/skills-prompting-mcp/claude-arsenal-codex-fluent-skill]]
- [[03-RESOURCES/entities/Claude Code]]
