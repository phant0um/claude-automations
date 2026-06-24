---
title: "The Claude Code Starter Kit for New Projects"
type: source
source_type: article
author: "zodchiii"
created: 2026-05-06
tags: [claude-code, starter-kit, config, setup]
triagem_score: 7
---

Standardized 4-file project config template: CLAUDE.md + settings.json + .gitignore + 9 SKILL.md slash commands. Bootstraps Claude Code project in 5 minutes with best practices.

## Source

Ingested from: `clippings/The Claude Code Starter Kit for New Projects (All Config Files Included).md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Por que um starter kit importa

Projetos Claude Code sem configuração inicial sofrem de problemas previsíveis: Claude não sabe a stack do projeto, não tem regras de coding style, toma decisões inconsistentes entre sessões, e acumula permissions desnecessárias. Um starter kit resolve isso na largada — 5 minutos de setup que evitam horas de correção.

## Os 4 arquivos do kit

### 1. CLAUDE.md — o firmware do projeto

O arquivo mais importante. Define o "sistema operacional" do assistente para aquele projeto específico. Estrutura recomendada pelo kit:

```markdown
## Project
[1-2 parágrafos: o que é, stack, arquitetura]

## Commands
[como rodar, testar, fazer build]

## Code Style
[convenções do projeto: naming, indentação, imports]

## Architecture
[decisões arquiteturais importantes, por que não X]

## Do Not
[lista explícita de ações proibidas]
```

O CLAUDE.md é lido no início de cada sessão — funciona como cache de contexto persistente. Informações aqui não precisam ser repetidas a cada conversa.

### 2. settings.json — permissões e comportamento

Controla o que Claude Code pode fazer sem pedir permissão:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(git status)",
      "Bash(git diff *)",
      "Read(**)",
      "Edit(**)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force)"
    ]
  }
}
```

A filosofia é minimal permissions: permissões explícitas para operações de rotina, bloqueio explícito para operações destrutivas, confirmação para tudo mais.

### 3. .gitignore — o que não versionar

O kit inclui .gitignore pré-configurado que exclui:
- `.claude/` (configurações locais de sessão)
- `*.env` e arquivos de credentials
- Diretórios de cache e temporários

Crítico: não versionar settings.json com tokens ou API keys hardcoded.

### 4. As 9 skills — slash commands do projeto

Skills são arquivos `.md` em `.claude/skills/` ou `~/.claude/skills/` que definem workflows complexos invocáveis como `/nome-da-skill`. O kit padrão inclui:

1. `/commit` — escreve commit message seguindo convenção do projeto
2. `/review` — code review focado nos critérios do projeto
3. `/test` — roda testes e interpreta falhas
4. `/refactor` — refatoração com preservação de comportamento
5. `/docs` — gera documentação a partir do código
6. `/debug` — debug sistemático com hipóteses explícitas
7. `/security` — revisão de segurança focada em vulnerabilidades comuns
8. `/deploy` — checklist de deploy para o ambiente do projeto
9. `/onboard` — explicação do projeto para novo desenvolvedor

Cada skill é um prompt estruturado que instrui Claude a seguir um processo específico, não apenas "faça X". A diferença entre `/commit` e "escreva um commit" é que a skill inclui: formato de mensagem, escopo de mudanças para revisar, verificações antes de commitar.

## Benefícios documentados

**Consistência:** mesmas convenções aplicadas em todas as sessões. Sem "hoje o Claude usou camelCase, amanhã usou snake_case".

**Velocidade:** Claude não precisa explorar a codebase para entender o projeto — o CLAUDE.md já explica. Menos tokens gastos em descoberta, mais em execução.

**Segurança:** settings.json como declaração explícita de permissões é auditável. Você sabe exatamente o que Claude pode fazer sem confirmar.

**Onboarding:** um novo desenvolvedor no projeto lê o CLAUDE.md e tem contexto imediato — o arquivo serve tanto ao Claude quanto a humanos.

## Comparação com abordagens alternativas

**Sem config (default):** Claude descobre o projeto toda sessão. Inconsistente, ineficiente, sem guardrails.

**Somente CLAUDE.md:** melhor que nada, mas sem settings.json o Claude pede permissão constantemente. Sem skills, workflows complexos são verbosos.

**Config completo (este kit):** setup inicial de 5 minutos, benefício multiplicado por cada sessão de trabalho. ROI positivo após a primeira sessão.

## Adaptação para o vault

O vault-michel já tem um CLAUDE.md sofisticado (raiz do vault) que cobre princípios, convenções, e workflow. A adaptação ao modelo do starter kit seria: adicionar skills específicas para workflows recorrentes que ainda são verbosos (ex: `/ingest-url`, `/consolidar-conceito`, `/criar-agente`). O vault usa skills globais (`~/.claude/skills/`) mas poderia ter skills de projeto em `.claude/skills/` para workflows específicos do vault.

## Detalhamento das 9 skills: o que cada uma deve conter

Uma skill eficaz não é apenas "faça X" — é um processo com estrutura, critérios e output esperado. Exemplos do que cada skill deve incluir além do comando básico:

**/commit:** formato de mensagem (conventional commits ou projeto-específico), escopo de revisão (diff completo vs staged only), verificações antes de commitar (tests passando, sem secrets hardcoded), e o padrão de "por que" na mensagem além do "o quê".

**/review:** checklist de itens a revisar (lógica, segurança, performance, testes, docs), priorização (crítico > importante > sugestão), e formato de output (bullet list ordenado por severidade). Sem checklist, "faça code review" produz feedback inconsistente entre sessões.

**/debug:** processo de hipóteses explícitas (liste 3 causas possíveis antes de investigar a primeira), protocolo de bisect (isolar onde o bug surge), e instrução de reportar o raciocínio mesmo se a hipótese for descartada — para que o usuário possa acompanhar o processo.

**/security:** lista de vulnerabilidades comuns para a stack do projeto (injeção SQL, XSS, CSRF para web; race conditions para concurrent; hardcoded secrets para qualquer projeto), instrução de priorizar por exploitability, e output com referência a CVE ou OWASP quando aplicável.

## Anti-padrões de configuração

**CLAUDE.md muito genérico:** "escreva código limpo" não é instrução acionável. "Use TypeScript strict mode, preferir composição sobre herança, nomear funções com verbos no imperativo" é acionável.

**settings.json muito permissivo:** `"allow": ["Bash(**)"]` elimina todas as proteções. O princípio de menor privilégio se aplica aqui: listar explicitamente os comandos permitidos, não wildcards amplos.

**Skills duplicando o CLAUDE.md:** Se o CLAUDE.md já define as convenções de commit, a skill `/commit` não precisa repeti-las — ela pode referenciar implicitamente ("seguindo as convenções do projeto"). Duplicação cria inconsistência quando um arquivo é atualizado e o outro não.

**Sem seção "Do Not" no CLAUDE.md:** A lista de proibições é tão importante quanto as instruções positivas. "Nunca apague arquivos sem confirmar", "nunca faça push para main diretamente", "nunca use console.log em produção" — itens específicos ao projeto que o Claude não saberia evitar sem instrução explícita.

## Mensuração do ROI

O valor do starter kit é real mas assimétrico por tipo de projeto:

- **Projetos novos:** ROI máximo. Setup de 5 minutos economiza potencialmente 2-4h de sessões inconsistentes antes do projeto ter maturidade suficiente para o Claude navegar sem suporte
- **Projetos existentes sendo migrados para Claude Code:** ROI médio. O maior trabalho é documentar o que já existe — stack, convenções, decisões arquiteturais — no CLAUDE.md. Esse trabalho tem valor independente do Claude (onboarding de novos devs)
- **Projetos de vida curta (<1 semana):** ROI baixo. O overhead de setup pode superar o benefício para projetos muito pequenos e descartáveis

## Links

- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-five-layer-architecture]]
- [[03-RESOURCES/sources/claude-code-skills/top-13-skills-et-plugins-claude-code-en-2026]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — anatomia do .claude/ que o starter kit popula
