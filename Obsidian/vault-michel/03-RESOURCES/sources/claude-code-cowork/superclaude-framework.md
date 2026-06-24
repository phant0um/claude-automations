---
title: "SuperClaude Framework: Configuration framework enhancing Claude Code"
type: source
source: "Clippings/SuperClaude-OrgSuperClaude_Framework A configuration framework that enhances Claude Code with specialized commands, cognitive personas, and development methodologies..md"
original_url: "https://github.com/SuperClaude-Org/SuperClaude_Framework"
author: "SuperClaude-Org community"
published: 2026-05-30
created: 2026-05-31
ingested: 2026-05-31
tags: [claude-code, framework, slash-commands, agents, mcp, claude-code-cowork, meta-programming]
---

## Tese central

SuperClaude é um framework de meta-programação que transforma Claude Code em plataforma de desenvolvimento estruturada via injeção de instruções comportamentais e orquestração de componentes — 30 slash commands, 20 agentes especializados, 7 modos comportamentais, 8 servidores MCP.

## Argumentos principais

1. **Meta-programming configuration framework**: não é afiliado à Anthropic. Transforma Claude Code via behavioral instruction injection — não modifica o modelo, modifica o que o modelo recebe como instrução estruturada.

2. **Versão atual v4.3.0** (TypeScript plugin system planejado para v5.0, sem ETA):
   ```bash
   pipx install superclaude
   superclaude install        # instala 30 slash commands
   superclaude mcp            # instala servidores MCP (opcional)
   superclaude doctor         # verifica instalação
   ```

3. **30 slash commands `/sc:*`** organizados em 8 categorias:
   - Planning & Design: `/brainstorm`, `/design`, `/estimate`, `/spec-panel`
   - Development: `/implement`, `/build`, `/improve`, `/cleanup`, `/explain`
   - Testing & Quality: `/test`, `/analyze`, `/troubleshoot`, `/reflect`
   - Documentation: `/document`, `/help`
   - Version Control: `/git`
   - Project Management: `/pm`, `/task`, `/workflow`
   - Research & Analysis: `/research`, `/business-panel`
   - Utilities: `/agent`, `/index-repo`, `/recommend`, `/select-tool`, `/spawn`, `/load`, `/save`, `/sc`

4. **20 agentes especializados** incluindo: PM Agent (documentação contínua), Deep Research Agent (pesquisa autônoma web), Security Engineer, Frontend Architect. Coordenação automática baseada em contexto.

5. **7 modos comportamentais adaptativos**: Brainstorming, Business Panel, Deep Research, Orchestration, Token-Efficiency (-30-50% tokens), Task Management, Introspection.

6. **8 servidores MCP** (via airis-mcp-gateway):
   - Tavily → web search (Deep Research)
   - Context7 → documentação oficial
   - Sequential-Thinking → raciocínio multi-passo
   - Serena → persistência de sessão e memória
   - Playwright → automação cross-browser
   - Magic → geração de componentes UI
   - Morphllm-Fast-Apply → modificações de código context-aware
   - Chrome DevTools → análise de performance

7. **Performance com MCPs**: 2-3× mais rápido, 30-50% menos tokens vs. sem MCPs.

8. **Deep Research (v4.2)**: 3 estratégias adaptativas (Planning-Only, Intent-Planning, Unified), multi-hop reasoning com até 5 iterações, quality scoring 0.0-1.0, case-based learning cross-session. Profundidades: Quick (5-10 fontes, ~2min), Standard (10-20, ~5min), Deep (20-40, ~8min), Exhaustive (40+, ~10min).

9. **ReflexionMemory** built-in para error learning — sem instalação adicional. Mindbase (busca semântica cross-sessão) disponível como enhancement.

## Key insights

- "Claude Code reads these files at session start to ensure consistent, high-quality development aligned with project standards." — PLANNING.md, TASK.md, KNOWLEDGE.md são documentos de sessão lidos no início.
- O framework é community-maintained, não Anthropic — risco de desatualização com mudanças da API Claude Code.
- Custo de manutenção do mantenedor: $100/mês em Claude Max para testes.
- `/spawn` permite tarefas paralelas — relevante para padrão de subagentes do vault.
- Token-Efficiency mode (-30-50%) é complementar ao RTK e caveman mode do vault.
- O padrão PLANNING.md + TASK.md + KNOWLEDGE.md é análogo ao CLAUDE.md + hot.md + wiki do vault.

## Exemplos e evidências

**Uso básico:**
```bash
/sc:research "latest AI developments 2024"   # Deep web research
/sc:implement "add authentication to API"     # Code implementation
/sc:test --coverage                           # Test generation
/sc:pm --sprint                               # Sprint planning
/sc                                           # Lista todos os 30 comandos
```

**Comparação de performance:**
| Configuração | Velocidade | Tokens |
|---|---|---|
| Sem MCPs | Padrão | Padrão |
| Com MCPs (Serena + Sequential) | 2-3× mais rápido | -30-50% |

**Deep Research depths:**
| Depth | Sources | Hops | Time |
|---|---|---|---|
| Quick | 5-10 | 1 | ~2min |
| Exhaustive | 40+ | 5 | ~10min |

## Implicações para o vault

- SuperClaude é um framework externo que sobrepõe ao Claude Code — o vault-michel já tem uma camada equivalente via CLAUDE.md + skills + hooks + subagents. A questão é se vale adotar um framework comunitário vs. o sistema proprietário do vault.
- Os 20 agentes especializados + 7 modos são análogos ao sistema de 40+ agentes do vault (`04-SYSTEM/agents/`).
- O padrão PLANNING.md/TASK.md/KNOWLEDGE.md é interessante como adição ao vault.
- `/sc:research` com multi-hop até 5 iterações e quality scoring é mais sofisticado que o processo de pesquisa atual.
- Risco: dependência em framework comunitário não afiliado à Anthropic pode quebrar com updates do Claude Code.

> [!contradiction] Possível sobreposição com vault atual
> O vault já tem sistema completo de agents (40+), CLAUDE.md, skills e hooks. SuperClaude adiciona uma camada adicional de abstração via slash commands — o valor incremental versus a complexidade added precisa ser avaliado. O vault-michel pode extrair os padrões (PLANNING.md, agente especializado, deep research multi-hop) sem adotar o framework completo.

## Links

- [[03-RESOURCES/entities/SuperClaude]] — entidade do framework
- [[03-RESOURCES/entities/Claude Code]] — plataforma base
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-five-layer-architecture]] — arquitetura que SuperClaude sobrepõe
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — MCPs integrados
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — 20 agentes coordenados

- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] — SuperClaude = Nível 3-4; skills = Nível 2
