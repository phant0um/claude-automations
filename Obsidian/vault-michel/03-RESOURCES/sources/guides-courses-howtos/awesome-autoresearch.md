---
title: "Awesome Autoresearch"
type: source
created: 2026-04-24
updated: 2026-04-24
tags: [autoresearch, autonomous-agents, self-improvement, research-agents, ai-science]
source_file: "Downloads/Arquivar2/🔬 Awesome Autoresearch.md"
origin: "github.com/alvinreal/awesome-autoresearch"
triagem_score: 9
---

# Awesome Autoresearch

Curated high-signal index of autonomous improvement loops, research agents, and descendants inspired by [[03-RESOURCES/entities/karpathy-autoresearch|karpathy/autoresearch]].

## O que é autoresearch

The `karpathy/autoresearch` pattern is a minimal autonomous loop where an agent:
1. Proposes a change (hypothesis/experiment)
2. Runs the experiment
3. Evaluates the result against a fitness function
4. **Keeps or reverts** based on the outcome
5. Repeats — overnight, unattended, with persistent lessons

The core insight: **"If you can measure it, you can optimize it."** The loop applies to any measurable metric — model loss, API latency, Sharpe ratio, test coverage, SQL query speed, etc.

---

## Descendants categorizados

### Uso Geral

| Repo | Descrição |
|------|-----------|
| `kayba-ai/recursive-improve` | Self-improvement com execution traces + failure analysis + keep-or-revert |
| `uditgoenka/autoresearch` | Claude Code skill para software, docs, security, debugging — qualquer goal mensurável |
| `leo-lilinxiao/codex-autoresearch` | Codex-native; resume support; lessons across runs; parallel experiments |
| `supratikpm/gemini-autoresearch` | Gemini CLI; Google Search grounding; 1M token context; headless overnight via `--yolo` |
| `greyhaven-ai/autocontext` | Closed-loop com evaluation, persistent knowledge, staged validation, distillation para runtimes locais |
| `jmilinovich/goal-md` | Agente constrói fitness function antes de otimizar (GOAL.md pattern) |
| `zkarimi22/autoresearch-anything` | Generalização para qualquer métrica — API perf, landing pages, SQL queries, config tuning |
| `ShengranHu/ADAS` | **Automated Design of Agentic Systems** (ICLR 2025) — meta-agentes que inventam arquiteturas de agentes |
| `MaximeRobeyns/self_improving_coding_agent` | **SICA** — ICLR 2025 Workshop; scaffold-level self-improvement em coding benchmarks |
| `metauto-ai/HGM` | **Huxley-Gödel Machine** — self-improvement para SWE-bench via meta-level optimization |
| `gepa-ai/gepa` | **GEPA** (ICLR 2026 Oral) — reflective prompt evolution; supera RL (GRPO) em benchmarks |
| `HKUDS/ClawTeam` | Agent swarm — spawna GPUs paralelas, distribui trabalho, agrega resultados |
| `WecoAI/aideml` | **AIDE** — tree-search ML engineering agent; iterative code generation + evaluation |

### Research Agent Systems

| Repo | Descrição |
|------|-----------|
| `SakanaAI/AI-Scientist` | **The AI Scientist** — primeiro sistema para descoberta científica totalmente automática |
| `SakanaAI/AI-Scientist-v2` | Workshop-level scientific discovery via agentic tree search; remove template dependency |
| `HKUDS/AI-Researcher` | NeurIPS 2025; full pipeline: hipótese → experimentos → manuscrito → peer review |
| `openags/Auto-Research` | Orchestrates team de AI agents: lit review, hypothesis gen, experiments, writing, peer review |
| `SamuelSchmidgall/AgentLaboratory` | Ideia → lit review → experimentos → report; modos autônomo e copiloto |
| `AgentRxiv` | Collaborative autonomous research com preprint server compartilhado entre agent labs |
| `hyperspaceai/agi` | P2P distributed research network com CRDT leaderboards e gossip de findings |
| `Human-Agent-Society/CORAL` | CORAL (arXiv:2604.01658) — multi-agent evolution open-ended; SOTA em 10 tasks math/algo/systems |
| `eimenhmdt/autoresearcher` | Early OSS para scientific workflows; literature review → autonomous research |

### Platform Ports & Hardware Forks

| Fork | Plataforma | Destaque |
|------|-----------|---------|
| `miolini/autoresearch-macos` | macOS / Apple Silicon MPS | Fork mais adotado para Mac |
| `trevin-creator/autoresearch-mlx` | MLX / Apple Silicon | Zero PyTorch/CUDA |
| `jsegov/autoresearch-win-rtx` | Windows / Consumer NVIDIA | VRAM floors explícitos |
| `lucasgelfond/autoresearch-webgpu` | Browser / WebGPU | Run in-browser sem Python |
| `tonitangpotato/autoresearch-engram` | Qualquer | Persistent cognitive memory cross-session |
| `ArmanJR-Lab/autoautoresearch` | Jetson AGX Orin | Director Go binary que injeta novelty (arxiv + DeepSeek) para escapar local minima |
| Colab/Kaggle T4 port | Free T4 GPU | Flash Attention 3 → PyTorch SDPA; zero cost |

### Domain-Specific Adaptations

| Domínio | Repo | Fitness Function |
|---------|------|-----------------|
| Trading | `chrisworsey55/atlas-gic` | Rolling Sharpe ratio |
| GPU Kernels | `RightNow-AI/autokernel` | Benchmark de profiling |
| Genealogy | `mattprusak/autoresearch-genealogy` | Archive verification |
| Voice AI | `ArchishmanSengupta/autovoiceevals` | Adversarial caller + hardening |
| Sudoku Solver | `Rkcr7/autoresearch-sudoku` | Hard benchmark sets (Rust solver) |
| Spring Boot | `jeongph/autospec` | Gradle build + JUnit XML |

### Evaluation & Benchmarks

| Benchmark | Descrição |
|-----------|-----------|
| `snap-stanford/MLAgentBench` | 13 tarefas de ML experimentation (CIFAR-10 to BabyLM) |
| `openai/mle-bench` | Mede performance de AI agents em ML engineering |
| `chchenhui/mlrbench` | MLR-Bench: 201 tarefas de NeurIPS/ICLR/ICML workshops |
| `THUDM/AgentBench` | 8 ambientes distintos; ICLR 2024 |

---

## Notable Use Cases

- **Shopify Liquid engine** — Tobi Lütke; gains em parse/render speed + allocation reductions
- **Driveline baseball biomechanics** — pitch-velocity prediction com ganhos grandes em model quality
- **Vesuvius Challenge ink detection** — multi-agent loop em ancient scroll detection; cross-scroll generalization
- **Earth system model optimization** — LLM propõe estruturas de equação; search process tuning parameters
- **Tennis XGBoost** — loop autoresearch com writeup sobre reward hacking (gamed iterations documentados)

---

## Conceitos Centrais

- [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]] — o padrão keep-or-revert
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — agentes que modificam seus próprios protocolos
- [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]] — risco central em loops autônomos
- [[03-RESOURCES/concepts/llm-ml-foundations/automated-alignment-researcher]] — instância de autoresearch em pesquisa de alinhamento
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — swarm e coordenação entre loops
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] — benchmarks e avaliação de agentes

## Entidades relacionadas

- [[03-RESOURCES/entities/karpathy-autoresearch]] — repositório original
- [[03-RESOURCES/entities/GEPA]] — ICLR 2026 Oral; reflective prompt evolution
- [[03-RESOURCES/entities/AIDE-weco]] — AIDE + Weco cloud platform
- [[03-RESOURCES/entities/AI-Scientist-Sakana]] — Sakana AI; first full scientific discovery system
- [[03-RESOURCES/entities/CORAL-research]] — arXiv:2604.01658; SOTA 10 tasks
- [[03-RESOURCES/entities/Andrej Karpathy]] — criador do autoresearch pattern
