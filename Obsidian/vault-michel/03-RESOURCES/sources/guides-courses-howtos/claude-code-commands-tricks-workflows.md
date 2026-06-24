---
title: "35 Claude Code Commands, Tricks, and Workflows That Most Users Don't Know"
type: source
author: Khairallah AL-Awady (@eng_khairallah1)
created: 2026-04-24
updated: 2026-04-24
tags: [claude-code, workflow, productivity, commands]
source_file: "35 Claude Code Commands, Tricks, and Workflows That Most Users Don't….md"
triagem_score: 7
---

# 35 Claude Code Commands, Tricks, and Workflows That Most Users Don't Know

**Autor:** [[03-RESOURCES/entities/Khairallah-AL-Awady]] (@eng_khairallah1)

Compilação de 35 técnicas testadas diariamente para maximizar produtividade com Claude Code. Organizadas em 5 categorias.

## Comandos Essenciais (01–08)

| # | Técnica | Descrição |
|---|---------|-----------|
| 01 | **Plan Mode (Shift+Tab)** | Analisa codebase e cria plano de arquitetura SEM escrever código. Previne mais bugs que qualquer outra técnica. |
| 02 | **/compact** | Comprime histórico da conversa em resumo focado após 30–45 min. Evita [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]]. |
| 03 | **/clear** | Limpa contexto completamente. Uma conversa por feature. |
| 04 | **/init** | Escaneia codebase e gera CLAUDE.md com estrutura, stack e decisões de arquitetura. |
| 05 | **/cost** | Exibe uso de tokens na sessão atual. Checar a cada hora. |
| 06 | **/memory** | Adiciona instruções persistentes aplicadas automaticamente em todas as sessões futuras. |
| 07 | **! prefix** | Prefixo `!` executa como comando terminal em vez de enviar para Claude. |
| 08 | **Multi-Model Switching** | Opus para planejamento/arquitetura. Sonnet para implementação/execução. |

## Técnicas de Produtividade (09–18)

| # | Técnica | Descrição |
|---|---------|-----------|
| 09 | **Reference File** | Apontar para arquivo existente como modelo de padrão ("Implemente seguindo exatamente src/auth/login.ts"). |
| 10 | **Screenshot Debug** | Paste com Ctrl+V de screenshot de UI com descrição concisa. Mais rápido que texto. |
| 11 | **Test-First Workflow** | Escrever testes antes da implementação — TDD via prompt. |
| 12 | **Incremental Build** | Nunca "construa o feature inteiro". Schema → API → Validação → Frontend, com testes entre cada passo. |
| 13 | **Codebase Question** | Antes de modificar área desconhecida: "explique como os dados fluem de X a Y neste módulo". |
| 14 | **Diff Review** | Após mudanças: "Mostre diff de todos os arquivos modificados. Explique cada mudança em uma frase." |
| 15 | **Error Paste** | Colar COMPLETA a mensagem de erro + stack trace. Forçar análise step-by-step antes de fix. |
| 16 | **Undo Checkpoint** | `git add . && git commit -m "checkpoint before [change]"` antes de qualquer mudança maior. |
| 17 | **Parallel Session** | Dois terminais: um para backend, outro para frontend. Contexto limpo e focado em cada um. |
| 18 | **Documentation Pass** | Após completar feature: gerar documentação completa imediatamente (mais precisa que dias depois). |

## Técnicas de Arquitetura (19–26)

| # | Técnica | Descrição |
|---|---------|-----------|
| 19 | **Architecture Audit** | "Proponha 2 abordagens arquiteturais para [requisitos]. Pros, contras, complexidade estimada, riscos." |
| 20 | **Dependency Check** | Antes de qualquer pacote novo: manutenção ativa? Issues de segurança? Tamanho de bundle? Alternativas? |
| 21 | **Pattern Enforcer** | No CLAUDE.md: "Novos arquivos devem seguir padrões em src/api/example-route.ts." |
| 22 | **Migration Builder** | Mudanças de schema: gerar migration + atualizar repository + API routes + TypeScript types em um prompt. |
| 23 | **API Design Review** | Revisar definições de rotas: naming inconsistente, respostas de erro faltando, paginação, auth. |
| 24 | **Security Scan** | SQL injection, XSS, secrets expostos, input validation, IDOR, rate limiting — por severidade. |
| 25 | **Performance Profiler** | N+1 queries, indexes faltando, re-renders desnecessários, lazy loading, caching. |
| 26 | **Refactoring Planner** | "Proponha plano de refatoração para este arquivo. Mostre estrutura proposta. NÃO inicie ainda." |

## Automação de Workflow (27–31)

| # | Técnica | Descrição |
|---|---------|-----------|
| 27 | **Git Hook Writer** | Gerar pre-commit hook com linter, type checking, bloqueio de console.log em produção. |
| 28 | **CI Pipeline Builder** | GitHub Actions workflow: PR trigger, testes, lint, build, comentário de resultado no PR. |
| 29 | **Environment Setup Script** | setup.sh para novos devs: deps, .env, DB local, migrations, seed, verificação via testes. |
| 30 | **Release Notes Generator** | `git log` desde última tag → release notes por categoria em linguagem de usuário. |
| 31 | **Database Seed Builder** | Seed realista com múltiplos perfis de usuário, relacionamentos e edge cases. |

## Debug e Recuperação (32–35)

| # | Técnica | Descrição |
|---|---------|-----------|
| 32 | **Reproduction Prompt** | Bug report → minimal reproduction → failing test → fix. |
| 33 | **Blame Investigator** | "Leia git log desta semana. Qual commit introduziu o bug? Por quê? Qual o fix?" |
| 34 | **Dependency Conflict Resolver** | Analisar conflito de dependências, propor resolução com menor número de mudanças. |
| 35 | **Recovery Mode** | Quando preso em loop: parar, mostrar versão original do git, reestabelecer o objetivo, recomeçar do zero. |

## Setup Recomendado para Novos Projetos

1. `/init` — gerar CLAUDE.md
2. Adicionar padrões de código ao CLAUDE.md
3. `/memory` — adicionar regras persistentes
4. Plan Mode — desenhar arquitetura antes de escrever código
5. Build incrementalmente — uma feature por vez, testada a cada passo

## Conexões

- Comandos de sessão conectam a [[03-RESOURCES/concepts/llm-ml-foundations/context-window]] (/compact, /clear) e [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]]
- Plan Mode é o coração de [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] (EPCC)
- /init e /memory formam o núcleo de [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]]
- Multi-Model Switching é instância de [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- Test-First + Incremental Build são práticas de [[03-RESOURCES/concepts/claude-code-tooling/claude-power-user-framework]]
- Recovery Mode é estratégia de última instância quando [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] não é reversível com /compact
