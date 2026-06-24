---
title: "Claude Code Agent"
type: agent
created: 2026-05-31
updated: 2026-05-31
tags: [agent, claude-code, harness, vault-so]
status: developing
---

# Claude Code Agent

Claude Code é o harness principal do vault-michel — o runtime que executa todos os outros agentes, skills e workflows descritos em `04-SYSTEM/agents/`.

## Papel no Sistema

| Camada | O que Claude Code faz |
|--------|-----------------------|
| **Harness** | Lê CLAUDE.md, carrega skills, executa hooks, chama tools |
| **Orquestrador** | Dispara sub-agents (wiki-ingest, audit, review) via Agent tool |
| **Operador** | Executa git, filesystem, bash — com permissões em `.claude/settings.json` |
| **Memória** | Lê/escreve `~/.claude/projects/…/memory/` entre sessões |

## Arquitetura no Vault

```
CLAUDE.md (behavioral contract)
    ↓
Claude Code CLI (harness)
    ├── Skills (04-SYSTEM/skills/)
    ├── Agents (04-SYSTEM/agents/)
    ├── Hooks (session-startup, caveman, token-economy)
    └── MCP servers (filesystem-vault, context-mode, token-savior, obsidian)
```

## Configuração Relevante

- **Settings:** `.claude/settings.json` — permissões, env, hooks
- **Memory:** `~/.claude/projects/-Users-michelcsasznik/memory/MEMORY.md`
- **Hot cache:** `[[04-SYSTEM/wiki/hot.md]]` — context de alta frequência
- **Skills index:** `~/.claude/skills/index.md` — auto-loaded globais

## Modelos

| Caso de uso | Modelo |
|-------------|--------|
| Tarefas padrão (80%) | claude-sonnet-4-6 |
| Raciocínio pesado, auditoria | claude-opus-4-8 |
| Batch / rascunho rápido | claude-haiku-4-5 |

## Capacidades Chave

- **Sub-agents paralelos** — wiki-ingest batch, análises independentes
- **MCP tools** — filesystem-vault, context-mode, token-savior, obsidian
- **Hooks** — session-startup, caveman-mode, UserPromptSubmit
- **Skills** — markdown skills carregados por trigger
- **Worktrees** — isolamento por branch para mudanças destrutivas

## Limites e Anti-patterns

- Sem memória de sessão anterior sem ler `memory/` explicitamente
- Context window ≠ memória — após compressão, contexto antigo some
- Sub-agents começam sem contexto da sessão pai — brief obrigatório
- Skills não são globais: precisam ser invocadas pelo nome

## Evidências

- **[2026-06-21]** Análise da Anthropic de ~400.000 sessões de Claude Code (out/2025-abr/2026, ~235.000 pessoas) mostra divisão de trabalho estável: humanos decidem o quê fazer (planejamento), Claude decide como fazer (execução). Quanto mais expertise de d... — [[agentic-coding-and-persistent-returns-to-expertise]]
- **[2026-06-21]** A maioria dos usuários do Claude nunca configura nada além do prompt — reconstroem o mesmo contexto/instrução em cada chat. O artigo descreve camadas de setup progressivas (preferências de resposta, styles, Projects, Project Instructions... — [[claude-setup-the-ai-skill-most-users-still-ignore-in-2026]]
- **[2026-06-21]** Os 4 princípios originais de Karpathy para CLAUDE.md (Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven Execution — janeiro 2026, popularizados por Forrest Chang) fecham ~40% das falhas de sessões Claude Code não super... — [[claude-keeps-breaking-your-code-because-you-re-missing-one-file-here-are-the-12-]]
- **[2026-06-21]** Spec de GitHub issue propondo transformar um agente read-only (que só lê uma estrutura de curso via metáfora de VFS — ls/tree/cat/grep) em um agente capaz de editar, mas sempre via diff completo (`write`/`edit` de arquivo inteiro), valid... — [[course-agent-write-back-editing-via-approval-gated-vfs-diffs-fixed-sidebar-issue]]
- **[2026-06-21]** Docker (State of Agentic AI report: 45% das organizações reportam dificuldade de garantir que ferramentas de agentes são seguras) propõe que segurança de agentes exige 4 domínios — isolamento de execução, controle de acesso a ferramentas... — [[how-to-secure-ai-agents-a-practical-overview]]
- **[2026-06-21]** Claude é fraco quando recebe só uma frase sem contexto. O ganho de capacidade real vem de uma sequência ordenada de 7 camadas de setup (Projects → working brief estruturado em XML → web search → connectors → subagentes → regras de aprova... — [[how-to-make-claude-100x-more-powerful-7-setup-layers]]
- **[2026-06-21]** Workflow para criar um "skill" pessoal de escrita no Claude: extrair os próprios posts públicos do LinkedIn via ferramenta de scraping legal/pública (Apify, ~$2/1000 posts), subir a planilha ao Claude, gerar um relatório de padrões dos m... — [[how-to-train-claude-on-your-best-linkedin-posts]]
- **[2026-06-21]** "Loop engineering" é a skill emergente que substitui prompting direto: em vez de instruir um agente passo a passo, você projeta um pequeno sistema que encontra trabalho, entrega ao agente, verifica o resultado e decide o próximo moviment... — [[loop-engineering-build-an-ai-that-codes-while-you-sleep]]
- **[2026-06-21]** Loop engineering trata codificação não como prompt único mas como ciclo repetido de feedback: planejar, agir, observar o resultado, ajustar até o trabalho estar de fato pronto. Diferente de prompt engineering (escrever uma pergunta melho... — [[loop-engineering-teaching-ai-agents-to-learn-from-their-own-mistakes]]
- **[2026-06-21]** Contraponto direto ao hype de "loop engineering": Peter Steinberger (que populariza a frase "você deveria desenhar loops, não prompts") gastou $1.3M em tokens OpenAI em 30 dias rodando ~100 agentes — porque a OpenAI paga a conta dele. Pa... — [[loop-engineering-is-for-rich-builders-do-this-instead]]
- **[2026-06-21]** Um prompt dá uma resposta e espera você decidir o próximo passo; um loop roda o ciclo completo sozinho (Discover → Plan → Execute → Verify → Iterate) até atingir um objetivo definido uma vez. Das 5 etapas, Verify, State e regra de parada... — [[loops-explained-claude-gpt-mira-and-what-actually-works]]
- **[2026-06-21]** A maioria usa Claude como caixa de chat (pergunta→resposta→fecha a aba), deixando inexplorada uma camada inteira que transforma a ferramenta de algo que se pergunta em algo que trabalha por você. 7 features — Projects, Connectors, Skills... — [[most-people-use-claude-like-a-chatbox-7-features-make-it-a-coworker]]
- **[2026-06-21]** Eve (Vercel) é framework filesystem-first para agentes de IA duráveis: capacidades centrais do agente vivem em locais convencionais do sistema de arquivos (instructions.md, tools/, skills/, channels/, schedules/), tornando o projeto mais... — [[verceleve-the-framework-for-building-agents]]

- **[2026-06-24]** We let Codex and Claude Code autonomously iterate on the nanoGPT speedrun optimizer track for two weeks, producing ~10k — [[autonomous-ai-research-for-nanogpt-speedrun]]
- **[2026-06-24]** Your agent writes clean code for 12 steps.Step 13: wrong file. Step 14: ignores your rules. Step 15: deletes something i — [[claude-code-hooks-what-nobody-tells-you-until-step-20-breaks-everything]]
- **[2026-06-24]** Deploy the full Claude desktop experience - chat, Claude Cowork, and Claude Code - using inference on AWS, Google Cloud — [[claude-desktop-on-aws-google-cloud-and-microsoft-foundry]]
- **[2026-06-24]** tags: — [[data-recipes-for-agentic-models]]
- **[2026-06-24]** Most looping agents have amnesia. Each cycle starts fresh, so they retry the same failed fix three times because nothing — [[how-to-build-a-claude-code-agent-that-learns-from-each-loop-exact-setup-inside]]
## Perspectivas

- **[2026-06-21]** '7 setup layers' e os '7 features que tornam Claude um coworker' convergem no mesmo padrão: o ganho de produtividade vem de configuração (CLAUDE.md, skills, memória), não do modelo em si. — [[how-to-make-claude-100x-more-powerful-7-setup-layers]]

## Links

- [[04-SYSTEM/AGENTS]] — firmware do vault
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — padrão thin harness
- [[03-RESOURCES/concepts/claude-code-subagents]] — sub-agents pattern
- [[03-RESOURCES/concepts/claude-md-behavioral-contract]] — CLAUDE.md como contrato comportamental
- [[04-SYSTEM/wiki/hot.md]] — cache quente
