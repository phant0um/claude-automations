---
title: 12 Recursos Indispensáveis no Claude Code
type: source
source_url: Twitter/@_avichawla
author: Avi Chawla
created: 2026-04-18
updated: 2026-04-18
tags: [claude-code, tools, features, best-practices, ai-development]
---

# 12 Recursos Indispensáveis no Claude Code

**Autor:** [[Avi Chawla]]  
**Fonte:** Twitter thread (@_avichawla)  
**Data:** 2026-04-18

## Resumo Executivo

Avi Chawla (engenheiro e educador em IA/Claude) lista os 12 recursos mais críticos do Claude Code para desenvolvimento profissional. O foco é em **governance (permissões, regras), automação (hooks, skills), e delegação (subagentes)**.

## Os 12 Recursos

### Tier 1: Fundação (Memória + Segurança)

1. **[[CLAUDE.md]]** — Memória do projeto. Armazena pilha, convenções, regras que o Claude carrega ao iniciar.
2. **Permissões** — Whitelist/blacklist de ferramentas por sessão. Crítico para código voltado a produção.

### Tier 2: Planejamento + Comportamento

3. **Modo Plano** — [[EnterPlanMode]] obriga o Claude a esboçar antes de executar (user aprova).
4. **Regras** — Definem "rails" comportamentais (fazer/não fazer) específicos do projeto.

### Tier 3: Reutilização + Automação

5. **[[Skills|Habilidades]]** — Prompts reutilizáveis em `.claude/skills/`. Escrita única, execução repetida.
6. **Ganchos (Hooks)** — Executam shell scripts em eventos (PreToolUse, PostToolUse). Perfeito para linting/testes automáticos.

### Tier 4: Extensão + Integração

7. **[[MCP]]** — Conecta Claude a bancos de dados, APIs, serviços. Acesso ao mundo real.
8. **Plugins** — Adiciona Docker, pytest, VS Code extensions sem código de integração.
9. **Comandos de Barra** — Atalhos em `.claude/commands/` para disparar fluxos complexos.

### Tier 5: Paralelo + Modo Avançado

10. **Subagentes** — Instâncias paralelas do Claude dividindo tarefas multi-passo.
11. **Modo Voz** — Hands-free interaction para consultas rápidas.
12. **Rewind** — Volta a checkpoints na sessão, reinicia limpo a partir de lá.

---

## Insight-Chave

**Progressão de poder:** Memória → Segurança → Planejamento → Reutilização → Automação → Extensão → Paralelismo.

Cada layer habilita a layer seguinte. CLAUDE.md + Permissões = base segura. Skills + Hooks = força de trabalho reutilizável. MCP + Subagentes = sistema distribuído.

---

## Conexões com a Vault

- [[04-SYSTEM/agents/Claude-Code]] — Implementação prática
- [[03-RESOURCES/concepts/prompt-engineering]] — Base para skills
- [[03-RESOURCES/entities/Avi-Chawla]] — Autor

## Aplicação Prática

Seus 3 skills recém-criados (`/ingest-source`, `/explain-concept`, `/prompt-review`) exemplificam **Tier 3 (Reutilização)**. Próximo passo: Tier 4 (MCP para integrar com sua vault) e Tier 5 (Subagentes para ingestão em batch).
