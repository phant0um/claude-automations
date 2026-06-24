---
title: "The Claude Code Starter Kit for New Projects"
type: source
source_type: clipping
category: articles
ingested: 2026-05-05
author: "@zodchiii"
platform: X/Twitter
tags: [claude-code, config, starter-kit, skills, settings, claude-md]
triagem_score: 8
---

# The Claude Code Starter Kit for New Projects

**Author:** @zodchiii | **Published:** 2026-05-05

## Summary

Drop-in configuration kit that replaces 2-3 hours of per-project Claude Code setup with a 5-minute folder copy. Contains 4 config files (CLAUDE.md, .gitignore, settings.json, settings.local.json) and 9 slash command skills (/review, /test, /commit, /pr, /debug, /refactor, /docs, /deploy-check, /security). Addresses zero-state problem: new projects have no context, overly permissive defaults, and no deny rules.

## Key Takeaways
- 4 config files + 9 skills = fully configured Claude Code in 5 minutes
- CLAUDE.md template: stack, commands, architecture, rules — under 60 lines
- settings.json handles permissions + hooks; settings.local.json for personal overrides (gitignored)
- 9 skills cover the full dev lifecycle: review → test → commit → PR → debug → refactor → docs → deploy-check → security
- Solves: missing context, permissive defaults, .env exposure risk

## Concepts Linked
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]

## Entities Linked
- [[03-RESOURCES/entities/Claude Code]]

---

## O Problema que o Starter Kit Resolve

Cada novo projeto começa do zero com Claude Code: sem contexto sobre o stack, sem permissions configuradas, sem nenhuma regra de segurança. O desenvolvedor passa 2-3 horas em cada projeto novo configurando:

1. CLAUDE.md com convenções e arquitetura do projeto
2. settings.json com permissions (quais comandos o agente pode rodar)
3. Regras de deny (o que nunca deve fazer — ex: nunca commitar .env)
4. Skills para fluxos de trabalho comuns

O Starter Kit de @zodchiii empacota essa configuração em arquivos reutilizáveis que funcionam como template de partida para qualquer projeto.

---

## Os 4 Arquivos de Configuração

### 1. CLAUDE.md (Constituição do Projeto)
Template com <60 linhas cobrindo:

```markdown
# Project

**Stack:** [list your stack]
**Architecture:** [brief description]
**Key commands:** 
- `npm test` — run tests
- `npm run build` — build for production

# Rules

- Never commit .env or secrets
- Always run tests before committing
- Follow existing code style

# Files to know
- `src/index.ts` — entry point
- `src/config.ts` — all configuration
```

A brevidade é intencional: CLAUDE.md fica no contexto de toda sessão. Cada linha extra é tokens extras em cada call. O template de zodchiii mantém <60 linhas para manter custo de contexto baixo.

### 2. settings.json (Permissions e Hooks)
Configura quais tool calls o agente pode fazer sem pedir permissão:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm test:*)",
      "Bash(npm run build:*)",
      "Bash(git diff:*)",
      "Bash(git status:*)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Write(.env*)",
      "Write(**/.gitignore)"
    ]
  }
}
```

**Deny rules críticas:** Bloquear escrita em `.env*` previne o problema mais comum de exposição de credenciais. Bloquear `rm -rf` previne deleção acidental de codebase.

### 3. settings.local.json (Overrides Pessoais — Gitignored)
Para configurações específicas do desenvolvedor que não devem entrar no repositório:

- Caminhos locais específicos da máquina
- Configurações de debug pessoais
- Tokens e credenciais de desenvolvimento (nunca commitar)
- Hooks específicos do ambiente local

Este arquivo é automaticamente incluído no `.gitignore` gerado pelo kit — garantindo que nunca entre no repositório por acidente.

### 4. .gitignore (Extensão de Segurança)
Adiciona ao .gitignore padrão do projeto:
- `settings.local.json`
- `.env*`
- Arquivos de debug do agente
- Logs de sessão do Claude Code

---

## As 9 Skills do Dev Lifecycle

### /review — Code Review
Revisa mudanças staged contra critérios de qualidade: coverage de testes, seguimento de convenções, potenciais bugs, performance obviamente ruim.

### /test — Geração de Testes
Gera testes para arquivos especificados. Cobre happy path + edge cases + error conditions. Segue framework de testes existente no projeto.

### /commit — Commit Estruturado
Gera mensagem de commit seguindo Conventional Commits (feat, fix, docs, refactor, etc.), com verificação de que testes passam antes de commitar.

### /pr — Pull Request
Gera descrição completa de PR: summary, test plan, screenshot instructions, breaking changes. Detecta automaticamente branch base e compara diff.

### /debug — Debugging Sistemático
Protocolo de debug em 4 steps: reproduzir o erro, isolar o componente, formar hipótese, verificar. Evita tentativas aleatórias de fix.

### /refactor — Refactoring Seguro
Refactoring com net-zero behavior change: identifica testes existentes, refatora, confirma que testes ainda passam. Não adiciona features durante refactor.

### /docs — Documentação
Gera ou atualiza documentação para o código especificado. JSDoc/docstrings para funções, README para módulos, ADR para decisões arquiteturais.

### /deploy-check — Pre-deploy Checklist
Verifica: testes passando, sem TODOs críticos, sem credenciais hardcoded, dependências atualizadas, variáveis de ambiente documentadas.

### /security — Security Review
Escaneia por vulnerabilidades comuns: injection, exposed credentials, insecure dependencies, missing input validation, unsafe deserialization.

---

## Comparação com Configuração Manual

| Dimensão | Manual | Starter Kit |
|---|---|---|
| Tempo de setup | 2-3 horas | 5 minutos |
| Cobertura de segurança | Depende do dev | Padronizada (deny rules) |
| Consistência entre projetos | Variável | Uniforme |
| Skills de lifecycle | Criadas do zero | 9 prontas para uso |
| Risco de .env exposure | Alto (fácil esquecer) | Baixo (deny rule explícita) |

---

## Limitações

- Template é genérico — projetos com stacks muito específicos precisarão adaptar o CLAUDE.md base.
- 9 skills cobrem o ciclo padrão mas projetos com workflows únicos precisarão de skills adicionais.
- settings.json de deny pode ser muito restritivo para projetos que precisam de operações de filesystem mais amplas.

---

## Extensões Recomendadas

Ao usar o Starter Kit como base, adicionar:
- Skill `/ingest` se o projeto tem pipeline de dados
- Deny rule para `Bash(curl * | bash)` (execução de scripts remotos)
- Skill `/performance` para projetos com SLAs de latência

---

## Conexões

- [[03-RESOURCES/sources/claude-code-skills/claude-code-5-layer-architecture-2026]] — o kit implementa as 5 camadas
- [[03-RESOURCES/sources/ai-agents-harness/how-claude-code-works-in-large-codebases]] — CLAUDE.md como base de navegação
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
