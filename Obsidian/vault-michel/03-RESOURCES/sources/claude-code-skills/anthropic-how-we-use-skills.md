---
title: "Lessons from Building Claude Code: How We Use Skills"
type: source
source: "Clippings/Lessons from Building Claude Code How We Use Skills.md"
author: "@trq212 (Tariq, Anthropic)"
origin: "https://x.com/trq212/status/2033949937936085378"
created: 2026-03-17
ingested: 2026-05-28
tags: [ai-agents, source, claude-code, skills, anthropic-internal, skill-types, skill-design]
---

## Tese central

Skills são o extension point mais usado no Claude Code, mas a flexibilidade torna difícil saber o que funciona melhor. Após catalogar centenas de skills em uso na Anthropic, os padrões convergem em 9 tipos e um conjunto de best practices de escrita, distribuição e composição.

## Argumentos principais

**Skill não é só markdown:** é uma pasta com scripts, assets, dados — o agente pode descobrir, explorar e manipular. Frontmatter suporta hooks dinâmicos, config options. As skills mais interessantes usam estrutura de pasta e config criativamente.

**9 tipos canônicos de skills:**

| # | Tipo | Exemplos |
|---|------|---------|
| 1 | Library & API Reference | billing-lib, internal-platform-cli, frontend-design |
| 2 | Product Verification | signup-flow-driver, checkout-verifier, tmux-cli-driver |
| 3 | Data Fetching & Analysis | funnel-query, cohort-compare, grafana |
| 4 | Business Process & Automation | standup-post, create-ticket, weekly-recap |
| 5 | Code Scaffolding & Templates | new-workflow, new-migration, create-app |
| 6 | Code Quality & Review | adversarial-review, code-style, testing-practices |
| 7 | CI/CD & Deployment | babysit-pr, deploy-service, cherry-pick-prod |
| 8 | Runbooks | service-debugging, oncall-runner, log-correlator |
| 9 | Infrastructure Operations | resource-orphans, dependency-management, cost-investigation |

## Key insights

1. **Skill Creator:** Anthropic lançou ferramenta para criar skills mais facilmente. Skills começam como poucas linhas + 1 gotcha, melhoram à medida que Claude encontra novos edge cases.

2. **Gotchas section = conteúdo de maior sinal.** Deve ser construído a partir de pontos de falha reais de Claude ao usar a skill. Atualizar continuamente.

3. **Progressive disclosure via filesystem:** usar estrutura de pasta como forma de context engineering. Dizer ao Claude quais arquivos existem — ele os lê quando apropriado. Exemplos: `references/api.md`, `assets/template.md`, pastas de scripts composicionais.

4. **Não railroade o Claude:** dar informação necessária, flexibilidade para adaptar. Skills são reusáveis — ser muito específico nas instruções é anti-pattern.

5. **description field é para o modelo, não para o usuário:** Claude escaneia a listing de todas as skills disponíveis por description para decidir "existe uma skill para isso?". É uma declaração de trigger, não summary.

6. **On-demand hooks:** skills podem registrar hooks que só ativam quando a skill é chamada e duram a sessão. `/careful` bloqueia `rm -rf`, `DROP TABLE`, force-push só quando tocando prod. `/freeze` bloqueia edições fora de um diretório específico.

7. **Memória via filesystem:** standup skill com `standups.log` — próxima execução Claude lê histórico próprio e detecta o que mudou desde ontem. Dados estáveis em `${CLAUDE_PLUGIN_DATA}`.

8. **Escala para marketplace:** verificar repo (`.claude/skills`) funciona bem para equipes pequenas. Marketplace interno permite distribuição e seleção por equipe. Curação antes de release é crítica — fácil criar skills ruins ou redundantes.

9. **Medir com PreToolUse hook:** log de uso permite encontrar skills populares e undertriggering.

10. **Composição por referência:** skills que dependem de outras podem referenciar por nome. Se a skill dependente estiver instalada, o modelo a invoca.

## Exemplos e evidências

- **frontend-design skill:** construída por engenheiro da Anthropic iterando com clientes para melhorar "taste" de design do Claude. Evita padrões clássicos como fonte Inter e gradientes roxos. Exemplo concreto de Gotchas bem calibradas.
- **adversarial-review:** spawna subagente "fresh eyes" para criticar, implementa fixes, itera até findings reduzirem a nitpicks. Modelo de quality gate autônomo.
- **babysit-pr:** monitora PR → retenta CI flaky → resolve merge conflicts → habilita auto-merge.
- **Anthropic usa centenas de skills em uso ativo internamente.**

## Implicações para o vault

- Vault usa skills em `04-SYSTEM/skills/` — mapear contra os 9 tipos para identificar gaps.
- **Gap óbvio:** Product Verification skills (verificação end-to-end via Playwright/headless) — vault não tem.
- Gotchas section deve ser adicionada a cada skill existente do vault.
- `description` das skills do vault deve ser auditado para funcionar como trigger para o modelo, não como documentação humana.
- Considerar on-demand hooks para operações destrutivas (guard agent integration).

## Links

- [[03-RESOURCES/entities/trq212-tariq]] — autor (Anthropic)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — anatomia oficial
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — patterns de skills
- [[03-RESOURCES/sources/claude-code-skills/anatomy-claude-skill-40-line-markdown]] — anatomia mínima
- [[03-RESOURCES/sources/claude-code-skills/complete-guide-building-skills-claude]] — guia completo
- [[03-RESOURCES/concepts/claude-code-tooling/skillify]] — skillify como ferramenta de criação

## Relações
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]] — skills como parâmetros treináveis; convergência com SkillOpt

- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] — SuperClaude = Nível 3-4; skills = Nível 2
