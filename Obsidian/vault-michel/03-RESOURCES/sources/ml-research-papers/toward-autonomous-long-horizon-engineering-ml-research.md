---
title: "Toward Autonomous Long-Horizon Engineering for ML Research"
type: source
created: 2026-04-19
updated: 2026-04-19
tags: [ai-agents, ml-research, long-horizon, multi-agent, orchestration, paper-reproduction, benchmarks]
authors: [Guoxin Chen, Jie Chen, Lei Chen, Jiale Zhao, Fanzhe Meng, Wayne Xin Zhao, Ruihua Song, Cheng Chen, Ji-Rong Wen, Kai Jia]
source_type: research-paper
arxiv: "2604.13018"
triagem_score: 10
---

# Toward Autonomous Long-Horizon Engineering for ML Research

**Sistema:** [[03-RESOURCES/entities/AiScientist]] — sistema de engenharia autônoma de longo horizonte para pesquisa em ML.

**Tese central:** Performance de longo horizonte é um problema *conjunto* de orquestração e continuidade de estado. Nem um sem o outro é suficiente.

## Problema Endereçado

"ML research engineering" — agente autônomo que owna o ciclo completo:
1. Interpretar paper/especificação de pesquisa (underspecified)
2. Configurar ambiente (Docker, GPUs, datasets, dependências)
3. Implementar o código from scratch
4. Executar experimentos
5. Diagnosticar falhas e refinar iterativamente

**4 dimensões de dificuldade:**
- **Underspecification** — papers omitem detalhes críticos de implementação
- **System Setup Burden** — configuração de ambiente vai muito além do algoritmo
- **Delayed Feedback** — evidência só aparece horas depois de implementar
- **State Continuity** — cada rodada produz artefatos que rodadas futuras devem interpretar corretamente

**Baseline humana:** Top ML PhDs atingem 41% no PaperBench em 48h. Melhor agente anterior: 21%.

## Arquitetura: AiScientist

### Princípio: Thin Control over Thick State

- **Thin** = interface de controle pequena e estável para decisões de stage-level
- **Thick** = estado externalizado e durável (análises, código, logs, resultados)
- Orquestrador opera sobre concise summaries + workspace map (não o workspace completo)

### [[03-RESOURCES/concepts/pkm-obsidian/file-as-bus]] — File-as-Bus Protocol

Agentes coordenam via arquivos em workspace compartilhado com permissões escopadas, não por handoffs conversacionais.

**Estrutura do workspace:**
```
paper_analysis/     → análise estruturada do paper, métricas alvo, ambiguidades
submission/         → repositório de reprodução (código, configs, reproduce.sh)
agent/
  prioritized_task.md
  plan.md
  impl_log.md
  exp_log.md
  experiments/      → outputs detalhados de cada run
```

**Por que importa:** Agentes re-entram sempre do estado atual dos artefatos — não dependem de contexto conversacional herdado. Downstream agents retomam sem replay do raciocínio dos predecessores.

### [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]] — Agent-as-Tool

Hierarquia de 3 tiers:

**Tier-0 — Orchestrator:** gerencia planning de stage, delega para specialists via interface tool (mesma interface de shell/file/web). Seletivo: delega só quando custo-benefício justifica.

**Tier-1 — Specialists:**
- **Paper Comprehension** — transforma paper em detalhes de implementação + métricas alvo
- **Prioritization** — converte compreensão em execution contract priorizado (`prioritized_tasks.md`)
- **Implementation** — full mode (build from scratch) ou fix mode (patch baseado em `exp_log.md`)
- **Experimentation** — executa pipeline, compara métricas vs targets, registra em `exp_log.md`
- **Generic Helper** — auxiliares leves para subtarefas avulsas

**Tier-2 — Subagents:** leaf workers escopados dentro de um specialist (ex: extração de estrutura, setup de ambiente, download de recursos). Não spawnam camadas mais profundas.

### Evidence-Driven Loop

Padrão adaptativo, não pipeline rígido:
1. Estabelecer scaffold executável (objetivo inicial)
2. Alternar implement ↔ experiment (padrão dominante)
3. Failed runs → targeted fixes (não reruns cegos)
4. Rounds iniciais: executabilidade/cobertura → rounds tardios: diagnose discrepâncias, ajuste hiperparâmetros, refinamento incremental

## Resultados Empíricos

### PaperBench (20 papers, from-scratch replication)

| Backbone | Baseline melhor | AiScientist | Ganho |
|---|---|---|---|
| Gemini-3-Flash | 20.60 (IterAgent) | 30.52 | +9.92 pts |
| GLM-5 | 22.58 (BasicAgent) | 33.73 | +11.15 pts |

Custo: $15.67/task (Gemini) vs $27.44 do IterAgent — mais eficiente e melhor.

### MLE-Bench Lite (competition-style ML tasks)

| Sistema | Any Medal% |
|---|---|
| AiScientist (Gemini-3-Flash) | **81.82** |
| AiScientist (GLM-5) | **81.82** |
| LoongFlow (melhor baseline controlado) | 77.27 |
| AIBuildAI (leaderboard oficial) | 77.27 |

81.82% supera todos os resultados do leaderboard oficial reportados no paper.

**Caso concreto:** MLE-Bench Lite "Detecting Insults" — 74 ciclos de experimento em 23h sem intervenção humana; AUC de 0.903 → 0.982; 18 best-so-far updates.

## Ablation Study — File-as-Bus

Remover File-as-Bus:
- PaperBench: −6.41 pontos
- MLE-Bench Lite Any Medal%: −31.82 pontos

**Padrão revelador:** Remover File-as-Bus não afeta muito Valid Submission e Bronze, mas colapsa Silver/Gold/Any Medal — porque File-as-Bus é crítico para *refinamento tardio*, não para estabelecer ponto de partida competitivo.

## Takeaways Destilados

1. **Mais interação ≠ melhor resultado.** IterAgent tem mais rounds que BasicAgent mas ainda perde pro AiScientist — rounds só ajudam quando constroem sobre progresso anterior.
2. **Long-horizon ML engineering é problema de sistemas**, não de raciocínio local.
3. **Durable state continuity é o bottleneck principal** — File-as-Bus é o mecanismo; sem ele, o sistema degenera.
4. **Hierarquia de especialistas contribui materialmente** além da continuidade de estado.

## LLMs Usados

- **Gemini-3-Flash** (Google DeepMind, 2025) — backbone primário; AiScientist 30.52 PaperBench / 81.82 MLE-Bench Lite
- **GLM-5** (Zhipu AI, 2026) — backbone secundário; AiScientist 33.73 PaperBench / 81.82 MLE-Bench Lite
- **GPT-5.4** (OpenAI, 2026) — usado apenas como grading model no PaperBench ($832 para 20-task eval completa)

## MLE-Bench Leaderboard Oficial (contexto)

| Sistema | Modelo | Any Medal% |
|---|---|---|
| AiScientist (Ours) | Gemini-3-Flash/GLM-5 | **81.82** |
| AIBuildAI | Claude-Opus-4.6 | 77.27 |
| ML-Master 2.0 | DeepSeekV3.2-Spe | 75.76 |
| Famou-Agent 2.0 | Gemini-2.5-Pro | 75.76 |
| MARS | Gemini-3-Pro | 74.24 |
| R&D-Agent | GPT-5 | 68.18 |
| InternAgent | DeepSeek-R1 | 62.12 |

## Sistemas Relacionados (benchmarks/baselines)

- **PaperBench** — benchmark OpenAI para reprodução de papers (Starace et al., 2025)
- **MLE-Bench Lite** — benchmark OpenAI para ML engineering em tarefas de competição (Chan et al., 2025)
- **AIDE** — AI-driven exploration no espaço de código (Jiang et al., 2025)
- **LoongFlow** — plan-execute-summarize cognitivo (Wan et al., 2025)
- **ML-Master 2.0** — integração de exploration e reasoning (Zhu et al., 2026)
- **CAMEL / MetaGPT / ChatDev** — frameworks clássicos de multi-agent coordination

## Conexões no Vault

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — AiScientist é implementação avançada deste padrão
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — File-as-Bus é solução específica de context engineering para long-horizon
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — durable artifacts = memória externa persistente
- [[03-RESOURCES/concepts/pkm-obsidian/file-as-bus]] — conceito central deste paper
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]] — thin control over thick state
- [[03-RESOURCES/entities/AiScientist]] — sistema principal descrito
