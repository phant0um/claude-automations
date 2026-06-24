---
title: "Give Your Claude Agent a Memory: The 4 Layers, From Sticky Note to Self-Improving"
type: source
source: "Clippings/Give Your Claude Agent a Memory The 4 Layers, From Sticky Note to Self-Improving.md"
author: "@dunik_7"
created: 2026-05-25
ingested: 2026-05-28
tags: [ai-agents, memory, claude, source]
---

## Tese central

Memória de agente não é um switch binário — é uma pilha de quatro camadas, cada uma resolvendo um problema que a anterior não consegue. A maioria das pessoas usa apenas as camadas inferiores e se pergunta por que o agente nunca melhora.

## Argumentos principais

1. **Agentes sem memória são peixes dourados**: recomeçam do zero a cada sessão, redescobrem os mesmos contextos, cometem os mesmos erros na centésima execução que cometeram na primeira.
2. **A distinção crítica de Projects**: Projects persistem *instruções*, não *histórico de conversas*. Quem confunde os dois perde contexto silenciosamente.
3. **O filtro da memória viva**: não tudo merece ser salvo — a pergunta-filtro é "isso mudaria como o agente age na próxima sessão?". Memória que armazena tudo é tão inútil quanto memória que armazena nada.
4. **Layer 4 só vale para workhorse agents**: consolidação noturna pressupõe padrões repetidos. Um agente de uso único não tem nada para consolidar.

## Key insights

- **Layer 1 (Sticky Note)**: configuração explícita de identidade/preferências nas memórias do usuário. Explícito bate inferido toda vez — e funciona imediatamente.
- **Layer 2 (Projects)**: workspace persistente com custom instructions. Armadilha: as instruções carregam, o histórico de conversa não.
- **Layer 3 (memory.md / CLAUDE.md)**: arquivo único lido no início e atualizado no fim. Disciplina em duas regras: (a) mantenha enxuto — token cost real, (b) use seções estruturadas (Preferences, Decisions, Known workarounds, Mistakes to avoid).
- **Layer 4 (Dream / Consolidation)**: cron job noturno/semanal que lê a memória existente + transcrições de sessão e reescreve limpo — duplicatas mescladas, entradas obsoletas substituídas, novos padrões surfaceados. **Regra de segurança**: sempre escrever resultado em arquivo *novo*, manter o antigo read-only até revisão.

## Exemplos e evidências

- Exemplo prático da export tool: agente descobre que tool falha em arquivos >50MB, cria workaround; sem memória, redescobre o mesmo bug na sessão seguinte.
- Template de memory.md com 4 seções: Preferences, Decisions (datadas), Known workarounds, Mistakes to avoid.
- Prompt de Layer 1: bloco "Remember the following about me" com role, projetos, estilo de comunicação, "never [X]".

## Implicações para o vault

- A Layer 4 deste framework = [[03-RESOURCES/concepts/pkm-obsidian/dream-cycle-self-consolidation]] — mesma ideia, terminologia diferente.
- Layer 3 = `CLAUDE.md` do próprio vault. Princípio "mantenha enxuto" valida o teto de 200 linhas documentado em feedback_claudemd_limits.md.
- A distinção Layer 2 (Projects = instruções, não histórico) é um vetor de confusão real para usuários Claude — documentar como anti-padrão.
- "Filtro de comportamento futuro" é o critério operacional para decidir o que entra em [[04-SYSTEM/wiki/hot]].

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]] — framework técnico complementar (Working/Episodic/Semantic/Personal)
- [[03-RESOURCES/concepts/agent-systems/agent-memory-layers]] — camadas de memória com lifespans
- [[03-RESOURCES/concepts/pkm-obsidian/dream-cycle-self-consolidation]] — Layer 4 / dream cycle
- [[03-RESOURCES/concepts/agent-systems/browser-agent-amnesia]] — problema de base (goldfish agents)
- [[04-SYSTEM/wiki/hot]] — implementação vault-michel das Layer 1-3
