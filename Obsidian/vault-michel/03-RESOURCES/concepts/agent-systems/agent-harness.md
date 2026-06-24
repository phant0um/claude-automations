---
title: Agent Harness
type: concept
status: developing
created: 2026-04-25
updated: 2026-04-25
tags:
  - ai-agents
  - architecture
  - harness
---

# Agent Harness

An **agent harness** is a thin, glue-layer runtime that coordinates between:
- An LLM (Claude, GPT, Gemini, etc.)
- External tools (git, APIs, filesystem)
- Memory systems (working/episodic/semantic)
- Skill library (markdown files with self-rewrite hooks)
- Protocol enforcement (permissions, tool schemas)

## The Core Principle

The harness does **NOT think**. It reads files, calls tools, writes logs, runs hooks. All intelligence lives in:
- Skill files (markdown)
- Memory files (markdown + JSON)
- Protocol files (structured constraints)

This inversion matters because it makes the system **portable and versionable**:
- Swap the harness tomorrow, lose nothing
- Swap the model, lose nothing
- Only skills, memory, and protocols accumulate value
- Those are plain text in git

## Thin Harness Design

**Target size:** < 200 lines of code

**Why so small?** The moment the harness starts reasoning about which skills to load or making decisions, you've put intelligence in the wrong place. That logic belongs in a skill file.

## Key Functions

### build_context()
Assembles context from three modules (memory, skills, protocols) respecting token budget:

1. Load preferences + active workspace (always)
2. Load semantic lessons (truncate if needed)
3. Load top 5 episodic entries by salience
4. Load only **matched skills** (progressive disclosure)
5. Load permissions (safety-critical, always)

**Mental model:** The context window is a computation box. Everything outside it does not exist to the model unless the harness retrieves, shapes, and injects it.

- **Targeted fragments = signal** → steer model toward better computation
- **Conflicting/stale fragments = noise** → confuse the model

### Lifecycle Hooks

Three hooks run at predictable moments:

1. **pre_tool_call** — before ANY tool invocation
   - Check tool schemas (blocked targets, arg types)
   - Check permissions (never allowed? requires approval?)
   - Check preconditions
   
2. **post_execution** — after ANY action (success or failure)
   - Log to episodic memory with pain scores
   - Failures get higher pain → surface more during retrieval
   
3. **on_failure** — when action fails
   - Count recent failures per skill
   - Flag skills for rewrite after 3+ failures in 14 days

## Common Harnesses

### Thin Harness (DIY)
- Custom conductor.py (< 200 LOC)
- Full control over context assembly
- Best for understanding how everything fits together
- Example: Avid's agentic-stack

### Claude Code / Cursor
- Uses built-in harness
- Already has loop, tool calling, file watching
- Point at `.agent/` folder, done
- Advantage: no implementation cost, built for productivity

### OpenClaw
- Similar to Claude Code
- Supports same memory/skills/protocols structure
- Alternative platform

## Harness vs Model vs Skills

| Component | Responsible for | Lifetime | Swappable? |
|-----------|-----------------|----------|-----------|
| **Harness** | Reading files, calling tools, hooks, budget | Build once, stays thin | Yes, immediately |
| **Model** | Reasoning over context, generating outputs | Ships monthly/quarterly | Yes, update model string |
| **Skills** | How-to for specific tasks, patterns, heuristics | Compound forever | Technically yes (but don't, accumulates value) |
| **Memory** | What happened, what works, preferences | Compound forever | Technically yes (but don't, knowledge is irreplaceable) |

## Design Anti-Patterns

**Bad:** Harness gets fat with business logic
- Decides which skills to load based on heuristics
- Implements its own memory retrieval strategy
- Tries to interpret skill outputs and adapt

**Good:** Harness stays dumb
- Loads only triggered skills via keyword matching
- Uses simple weighted formula for memory salience
- Trusts post_execution hook to log everything

## Harness Engineering em Top Companies (2026)

### Dado Chave: Harness > Model

Mesmos pesos do modelo, harnesses diferentes → **52.8% → 66.5% em Terminal Bench 2.0** (LangChain, via Clippings).

A **Vercel** foi ainda mais longe: deletou **80% das ferramentas** do harness e performance **aumentou**. Motivo: ferramentas desnecessárias poluem o espaço de decisão do modelo — less is more.

### Framework ThoughtWorks (mai/2026)

Matriz de 4 quadrantes para classificar componentes do harness:

|  | Computational | Inferential |
|--|--------------|-------------|
| **Guide** | Code that directs the model | Prompts/skills that shape reasoning |
| **Sensor** | Code that reads/observes state | Memory/context retrieval |

> "Most teams have sensors but no guides."

Guias (code e prompts que **direcionam** o modelo) são o gap comum em harnesses de produção.

### AHE: Auto-Evolução do Harness

[[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]] mostra empiricamente que:
- System prompt sozinho: **−2.3pp** (regride!)
- Memory isolado: **+5.6pp**
- Tools isolado: **+3.3pp**
- Middleware isolado: **+2.2pp**

Harnesses podem ser evoluídos automaticamente mantendo o modelo frozen. O substrate é [[03-RESOURCES/entities/NexAU]].

## Related Concepts

- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]] — auto-evolução do harness via AHE
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — what the harness coordinates
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — where harness defers to skills
- [[03-RESOURCES/concepts/pkm-obsidian/progressive-disclosure]] — context management pattern
- [[03-RESOURCES/entities/NexAU]] — substrate que expõe harness como arquivos editáveis
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — Claude Code's specific harness implementation (8 patterns, async generator, compaction)

## 12 Componentes de Produção (via Akshay Pachaar, abr/2026)

Síntese cross-framework (Anthropic, OpenAI, LangChain, CrewAI, AutoGen):
1. Orchestration Loop (TAO/ReAct; "dumb loop")
2. Tools (schemas + sandboxed exec)
3. Memory (short-term + long-term: CLAUDE.md, MEMORY.md, SQLite/Redis)
4. Context Management (compaction, observation masking, JIT retrieval, sub-agents)
5. Prompt Construction (hierarquia: system > tools > memory > history > user)
6. Output Parsing (native tool_calls, Pydantic schema)
7. State Management (git commits, typed dicts, previous_response_id)
8. Error Handling (4 tipos; cap 2 retries em produção)
9. Guardrails & Safety (input/output/tool; tripwire; ~40 capabilities no Claude Code)
10. Verification Loops (rules-based + visual + LLM-as-judge; Boris Cherny: 2-3x quality)
11. Subagent Orchestration (Fork/Teammate/Worktree / agents-as-tools / handoffs)
12. Prompt Caching (prefixo imutável; crítico para custo)

**Context Rot**: performance degrada 30%+ quando conteúdo chave cai em posições mid-window (Chroma + Stanford "Lost in the Middle") — mesmo em janelas de 1M tokens.

**Ralph Loop (Anthropic)**: Initializer Agent (setup) + Coding Agent por sessão (lê git logs + progress files, escolhe feature, trabalha, commita). Filesystem = continuidade cross-context.

**Co-evolução**: Claude Code foi treinado com harness específico. Mudar tool implementations pode degradar performance. Future-proof test: performance escala com modelos melhores sem adicionar complexidade ao harness.

## AEvo Ablation: Direct Empirical Proof of Harness Necessity

[[03-RESOURCES/concepts/pkm-obsidian/aevo-meta-editing-evolution]] (arXiv:2605.13821, 2026) provides the clearest controlled experiment on harness removal to date. On the Kernel optimization task (100 rounds):

| Variant | Reward Hacking | Best Valid Result |
|---------|---------------|-----------------|
| Full AEvo (with harness) | 0/3 runs | 1138 cycles |
| w/o Evolution Harness | **2/3 runs hacked** | N/A (invalid) |

The harness prevents reward hacking by isolating the evaluator: agents can submit candidates but cannot read evaluator internals, access hidden benchmark artifacts, or write official scores. Without this boundary, agents find and exploit evaluation shortcuts in 2 out of 3 independent runs. This is direct evidence that the "harness does not think" principle has a security corollary: **the harness must own evaluation**.

## Evidências
- **[2026-06-22]** Cloudflare abre os primitivos de durable execution, sandboxed code exec e virtual filesystem que usou para hardenizar seu harness first-party (Project Think), para qualquer harness/framework de terceiros (Flue/Pi) rodar em produção. — [[03-RESOURCES/sources/bringing-more-agent-harnesses-to-cloudflare-starting-with-flue]]
- **[2026-06-24]** 过去这几个月，社区里关于 Agent 的讨论焦点经历了一次完整的下沉。年初大家还在比模型分数，到 2026 年中，X 与 GitHub 上的工程师已经在讨论两件更具体的事：. — [[harness-loop-engineering-2026-ai-agent]]

- **[2026-06-24]** tags: — [[bayesian-control-for-coding-agents]]
## References

- [[03-RESOURCES/sources/ai-agents-harness/ai-agent-stack-2026]] — complete harness architecture
- [[03-RESOURCES/sources/ai-agents-harness/agent-development-kit-five-layers]] — ADK framing for hooks + subagents as harness layers
- [[03-RESOURCES/sources/ai-agents-harness/clipping-agentic-harness-engineering-ahe]] — AHE paper (arXiv 2604.25850)
- [[03-RESOURCES/sources/guides-courses-howtos/walkinglabs-learn-harness-engineering]] — beginner course; 5 subsystems; Anthropic experiment ($9 vs $200 same model)
- [[03-RESOURCES/sources/ai-agents-harness/anatomy-agent-harness-akshay-pachaar]] — 12 componentes; 7 decisões; Ralph Loop; comparativo frameworks (2026-04-06)
- `Clippings/A Closer Look at Harness Engineering from Top AI Companies.md`
- Thin harness philosophy: "thin conductor principle"
- **[2026-06-22]** CLI-Anything (HKUDS): harness pattern comercializado — wrapper CLI expõe software via comandos sem modificar original. SKILL.md auto-gerado torna cada harness descobrível por agents. 258 commands em FreeCAD, 48 unit + 7 E2E tests em Obsidian CLI — [[03-RESOURCES/sources/ai-agents/cli-anything-agent-native-software]]
- **[2026-06-24]** Default harness = agent loop + built-in tools (bash, read_file, write_file, glob, grep, web_fetch, web_search, todo,... — [[the-harness-eve-default]]
