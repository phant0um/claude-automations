---
title: "obsidian-second-brain — Claude Code Skill for Obsidian"
type: source
source_type: clipping
category: ai-agents
ingested: 2026-05-05
author: "Eugeniu Ghelbur"
source_url: "https://github.com/eugeniughelbur/obsidian-second-brain"
tags: [obsidian, second-brain, claude-code, llm-wiki, karpathy, auto-synthesis, scheduled-agents]
triagem_score: 9
---

# obsidian-second-brain — Claude Code Skill for Obsidian

**Author:** Eugeniu Ghelbur (AI Automation Engineer @ Single Grain)

## Summary

Extension of Karpathy's LLM Wiki pattern into a self-maintaining Obsidian vault. Key difference: new sources rewrite existing pages (not just append), contradictions reconcile automatically, unnamed patterns are synthesized into new pages, and 4 scheduled agents (nightly close, weekly review, contradiction sweep, vault-health) keep the vault alive without prompting. 31 commands including live research from X, web, and YouTube.

## Key Takeaways
- Evolves Karpathy's append-only wiki into a self-rewriting system
- `/obsidian-reconcile` resolves contradictions automatically
- `/obsidian-synthesize` finds unnamed patterns across notes
- 4 scheduled agents: nightly close, weekly review, contradiction sweep, health check
- AI-first note format: `## For future Claude` preamble + frontmatter for LLM retrieval
- Research toolkit: `/x-read`, `/x-pulse`, `/research`, `/research-deep`, `/youtube`
- 4 role presets available

## Concepts Linked
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]

## Entities Linked
- [[03-RESOURCES/entities/Obsidian]]
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/Andrej Karpathy]]

---

## Contexto Arquitetural

O projeto `obsidian-second-brain` de Ghelbur resolve uma limitação fundamental do padrão LLM Wiki original: Karpathy projetou um sistema de acumulação — novas informações são appendadas ao wiki, tornando-o progressivamente mais completo. Mas acumulação sem reconciliação produz vaults com contradições não resolvidas, padrões sem nome e notas orphan que nunca são lidas. O obsidian-second-brain trata isso como problema de engenharia, não de disciplina pessoal.

### Reescrita Ativa vs Append-Only

A distinção mais importante do projeto é a mudança de paradigma: em vez de adicionar uma seção nova a uma nota existente quando uma fonte contradiz o que já está lá, o comando `/obsidian-reconcile` reescreve a nota para integrar ambas as perspectivas. Isso requer que o agente:

1. Leia a nota existente completa
2. Identifique a claim em conflito com a nova fonte
3. Determine se é contradição real ou distinção de contexto
4. Reescreva a seção relevante para refletir o estado atual do conhecimento

O risco óbvio é perda de informação histórica — uma nota reescrita não preserva a progressão do entendimento. A mitigação é git: todo vault sob controle de versão mantém o histórico completo de reescritas.

### Os 31 Comandos — Princípio de Design

Os 31 comandos seguem uma filosofia de composição: comandos de pesquisa (`/research`, `/x-read`, `/youtube`) produzem notas brutas; comandos de síntese (`/obsidian-synthesize`) operam sobre essas notas; comandos de manutenção (`/obsidian-reconcile`, `/obsidian-health`) mantêm a coerência. O fluxo é: captura → síntese → manutenção, não captura → leitura.

O número 31 pode parecer excessivo para um vault pequeno. Para vaults com menos de 200 notas, provavelmente 8-10 comandos cobrem 90% dos casos de uso. O valor dos 31 emerge em vaults maiores onde a manutenção manual se torna inviável.

### Formato AI-First: `## For future Claude`

A seção `## For future Claude` no topo de cada nota é a inovação mais portável do projeto — não requer nenhuma infraestrutura adicional. É uma instrução explícita para o próximo agente que ler a nota: "isso é o que importa aqui", "use este conceito quando...", "cuidado com a armadilha X". Reduz o custo de retrieval porque o agente não precisa raciocinar sobre como usar a nota — a nota já diz.

Este padrão é análogo a docstrings em código: não são para humanos que escreveram o código (que sabem o que a função faz), são para quem vai ler o código depois — humano ou agente.

### Os 4 Agentes Agendados — Detalhes de Implementação

Os agentes agendados requerem Claude Code com suporte a tarefas programadas (via hooks ou cron). Cada agente tem um escopo bem definido:

| Agente | Frequência | Escopo | Output |
|--------|-----------|--------|--------|
| Nightly close | Diária | Notas do dia | Índice diário, consolidação de inbox |
| Weekly review | Semanal | Vault completo | Relatório de tendências emergentes |
| Contradiction sweep | Semanal | Claims factuais | Lista de contradições para reconciliar |
| Vault health | Diária | Links e frontmatter | Relatório de orphans, dead links |

A separação em 4 agentes especializados (em vez de um agente genérico de manutenção) é intencional: cada agente tem um prompt otimizado para sua tarefa específica. Um agente de "contradiction sweep" precisa de instruções muito diferentes de um agente de "nightly close".

### 4 Role Presets

O projeto inclui 4 presets de papel que configuram o comportamento padrão do agente:
- **Researcher** — prioriza pesquisa e síntese de novas informações
- **Writer** — prioriza desenvolvimento e aprofundamento de ideias existentes
- **Curator** — prioriza organização, links e manutenção da estrutura
- **Analyst** — prioriza identificação de padrões e contradições

O usuário seleciona o preset no início da sessão; o agente calibra seus comandos e prioridades de acordo.

### Limitações do Projeto

- **Dependência de MCP filesystem:** sem acesso direto ao vault via MCP, os comandos degradam para operações manuais lentas.
- **Cognitive overhead de 31 comandos:** usuários novos levam tempo para aprender qual comando usar em cada situação.
- **Risco de reconciliação incorreta:** `/obsidian-reconcile` pode perder nuance em domínios onde múltiplas perspectivas conflitantes são intencionalmente mantidas (ex: notas de diferentes escolas de pensamento).
- **Custo de agentes agendados:** 4 agentes rodando diariamente/semanalmente têm custo de tokens não trivial em vaults grandes.

### Relevância para Vault-Michel

O vault-michel deriva diretamente deste projeto: a skill `wiki-ingest` implementa o fluxo de ingestão, `wiki-lint` implementa o health check, e o formato `## For future Claude` é usado em conceitos críticos. A diferença é que o vault-michel usa uma versão simplificada — sem todos os 31 comandos, focando nos mais usados — e integra com o sistema de agentes SO descrito em `04-SYSTEM/AGENTS.md`.
