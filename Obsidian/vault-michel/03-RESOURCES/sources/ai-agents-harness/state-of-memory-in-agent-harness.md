---
title: "State of Memory in Agent Harness"
type: source
source: "Clippings/State of Memory in Agent Harness.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Memória em agentes de IA é um problema largamente não resolvido, e cada harness (Claude Code, Codex, Copilot, OpenClaw, Hermes, AWS Bedrock AgentCore, Windsurf, Devin) está resolvendo de forma diferente. O padrão que emerge é que todas as soluções nativas quebram na mesma fronteira: armazenamento limitado e local, recuperação majoritariamente por keyword, escopo restrito ao harness, tratamento fraco de staleness, e isolamento inadequado.

## Argumentos principais

- **Três tipos distintos chamados "memória"**:
  - **Working memory**: vive no context window durante a sessão, reseta ao fim — o problema de compaction pertence aqui.
  - **External memory**: qualquer coisa persistida fora dos pesos (vector stores, knowledge graphs, arquivos). Sobrevive sessões; os pesos não mudam. Toda memória de produção em 2026 vive aqui.
  - **Parametric memory**: conhecimento codificado nos pesos via gradient descent. Zero deployments de produção em 2026.
- **Teto formal**: recuperação precisa de Ω(k²) exemplos armazenados para igualar o que memória paramétrica faz com O(d) atualizações de peso (arXiv:2604.27707). Todo sistema opera dentro desse teto.
- **Claude Code — dois tracks**:
  - CLAUDE.md: config humano-escrita (convenções, instruções), lida no início da sessão.
  - Auto-memory: notas escritas pelo Claude de um background extraction agent, armazenadas em `~/.claude/projects/<repo>/memory/` com MEMORY.md index (cap 200 linhas/25KB), quatro categorias: user, feedback, project, reference. Recuperação por filename (não semântica), máximo 5 arquivos por turno, truncação silenciosa além do cap.
  - Shortcoming: seleção por nome de arquivo, não busca semântica — arquivo bem nomeado ganha sobre arquivo relevante.
- **Claude Managed Agents**: log de eventos append-only (nunca mutado) — rollback e audit são arquiteturais. Memory stores em `/mnt/memory/` como filesystem (até 8 por workspace, ~100KB cada), escrita imutável com versão, múltiplos agentes podem compartilhar concorrentemente. Shortcoming: feito para coordenação multi-agent em workspace, não memória pessoal de longo prazo.
- **OpenAI Codex**: um diretório de markdown (`~/.codex/memories/`), sem SQLite, sem embeddings. Desligado por padrão. Escrita em duas fases: per-rollout (após 6h idle, extração com schema estrito e redação de secrets) + global (consolidation sub-agent sob lock). Truncação silenciosa em 5,000 tokens, grep substring-only. Shortcoming: gate de 6h significa sessões consecutivas podem nunca consolidar; estado apenas local; indisponível em EEA/UK/Suíça ao launch.
- **GitHub Copilot**: verificação de citação just-in-time — memory items têm subject, factual content, citation (file+line), reasoning. Antes do uso, o agente valida a citação contra o branch atual, reescrevendo memória que o código contradiz. Auto-expiração após 28 dias. Único mecanismo de staleness com dados de outcome publicados: A/B test (p<0.00001), taxa de merge de PRs de 83% para 90% com memória ativa.
- **OpenClaw**: markdown em `~/.openclaw/workspace/` com SQLite index por agente + embeddings + hybrid retrieval (70% vector, 30% BM25). Quando o context window enche, dispara "silent internal turn" pedindo ao modelo escrever conteúdo importante antes de limpar — o que sobrevive é seletivo e inconsistente. Plugin Mem0 elimina essa dependência.
- **Hermes Agent**: três camadas built-in: MEMORY.md (2,200 chars) + USER.md (1,375 chars) ~1,300 tokens combinados, §-delimitado com gauge de utilização e consolidação a 80% de capacidade; skills (docs procedurais após 5+ tool-call tasks); SQLite FTS5 sobre todas as sessões. Cap minúsculo (~800 tokens de memória durável), FTS5 keyword-only. Plugin Mem0 remove o cap e adiciona recuperação semântica.
- **AWS Bedrock AgentCore**: três estratégias de extração async (semantic facts, preferences, narrative summary), ~20-40s para extrair, ~200ms para recuperar; fatos alterados marcados INVALID em vez de deletados. Publicou: LoCoMo 70.58, PrefEval 79, PolyBench-QA 83.02. Shortcoming: lock-in AWS, LoCoMo abaixo dos sistemas líderes.
- **Windsurf**: gerado e gerenciado pelo motor Cascade, sem workflow de developer. Arquivos locais em `~/.codeium/windsurf/memories/`. Shortcoming: o que é capturado é decisão do Cascade; invisible entre projetos; sem sharing de time.
- **Cognition Devin**: Knowledge (trigger-content facts curados por humano, sem auto-capture) + DeepWiki (docs de referência). Devin sugere Knowledge após sessões mas humano aprova antes de armazenar. Shortcoming: gate de aprovação mantém qualidade mas é fricção — times que não revisam não acumulam nada.

## Key insights

- **O padrão dos shortcomings é idêntico em todos os harnesses**: armazenamento limitado e local (Claude Code 25KB, Hermes 2,200 chars, Codex 5,000-token load), recuperação majoritariamente por keyword (Claude Code por filename, Codex por grep, Hermes por FTS5), memória scoped ao harness (Claude Code memory não significa nada para Codex), tratamento de staleness mínimo (apenas Copilot resolve isso), isolamento como afterthought.
- **Os benchmarks de memória são ruins**: LoCoMo (o mais comum) tem apenas 10 conversas, muitas perguntas não requerem memória (baseline trivial de grep ~74%), questões adversariais compartilham similaridade superficial. LongMemEval é ainda ok. MemoryArena (arXiv:2602.16313) testa memória que deve guiar ação — sistemas que near-saturam LoCoMo falham nele.
- **Nenhum benchmark testa em escala de produção**: caps perto de 1.5M tokens enquanto agentes de produção atingem 10M+. BEAM (ICLR 2026) é o único built para esse range.
- **Stability-plasticity dilemma se relocou**: mover para external memory não eliminou catastrophic forgetting — novas e velhas memórias competem por retrieval slots exatamente como competiam por pesos. Raw trajectories de tarefas fáceis prejudicam tarefas mais difíceis (forward transfer −9.5%).
- **Selective forgetting é não-resolvido**: sistemas lidam com retrieval mas não com forgetting seletivo (desaprender um fato stale mantendo a estrutura ao redor).
- **Memória é superfície de ataque**: 57-71% de contaminação cross-user sob uso normal; poisoning attacks a 6-38%.
- **O único dado real de outcome publicado é do Copilot**: PR merge rate +7 pontos percentuais, com precisão de code-review +3% e recall +4%. Todos os outros sistemas reportam benchmarks.

## Exemplos e evidências

- **Claude Code auto-memory**: `~/.claude/projects/<repo>/memory/MEMORY.md`, cap 200 linhas/25KB, máx 5 arquivos por turno.
- **Codex**: gate de 6h idle, 256 rollouts, 30 dias de age-pruning, truncação a 5,000 tokens, indisponível EEA/UK/Suíça.
- **Copilot**: A/B test p<0.00001, merge rate 83% → 90%, citation validation just-in-time, auto-expire 28 dias.
- **OpenClaw**: 247,000 stars — adoção massiva impulsionada em parte pela gap de memory.
- **Hermes**: 135,000 stars, 200+ models, cap ~800 tokens de memória durável.
- **AgentCore**: LoCoMo 70.58, PrefEval 79, PolyBench-QA 83.02.
- **Mem0 v3 (abril 2026)**: ~6,900 tokens e 1.44s por query, vs ~26,000 tokens e 17.12s para full-context retrieval. Single-pass ADD-only extraction, multi-signal retrieval (semantic + BM25 + entity linking), entity linking dentro do vector store.
- **Cross-user contamination**: 57-71% sob uso normal (arXiv:2604.01350); poisoning attacks 6-38% (arXiv:2601.05504).

## Implicações para o vault

- A arquitetura de memória do vault-michel (MEMORY.md em `~/.claude/projects/`) é exatamente o sistema Claude Code descrito aqui — com os mesmos limites (25KB cap, retrieval por filename, 5 arquivos/turno).
- O insight de que "arquivo bem nomeado ganha sobre arquivo relevante" explica por que a nomenclatura dos arquivos de memória do vault importa tanto.
- Confirma que a estratégia de hot.md como "hot cache" é uma solução pragmática para o problema de retrieval semântico ausente no Claude Code.
- O dado de contaminação cross-user (57-71%) é uma preocupação de segurança para qualquer sistema com múltiplos usuários — não aplicável diretamente ao vault pessoal, mas relevante para projetos com times.
- Candidato a expandir [[03-RESOURCES/concepts/ai-agents/agent-memory]].

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-memory]]
- [[03-RESOURCES/concepts/ai-agents/context-engineering]]
- [[03-RESOURCES/sources/ai-agent-memory]]
- [[04-SYSTEM/wiki/hot.md]]
