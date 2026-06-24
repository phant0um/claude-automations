---
title: "Claude Security Scan — 3 Skills, 100% Detection Rate, ~$1/mês"
type: source
created: 2026-05-18
updated: 2026-05-18
tags: [ai-agents, security, claude-skills, claude-code]
source_url: "https://zenn.dev/sabakan1/articles/57ca07f4b277b4"
author: "sabakan1"
category: ai-agents, security
triagem_score: 8
---

## Tese central

Um único skill de segurança monolítico foi dividido em 3 skills especializados alinhados ao ciclo de desenvolvimento, atingindo 100% de detecção em test harness por ~$1/mês — substituindo ferramentas de $200+/hora e Snyk ($98/mês).

## Key insights

1. **3 skills, 3 momentos do ciclo:**
   - `/security-review` — PR creation; apenas git diff; ~$0.02/execução
   - `/full-scan` — pré-release; todos os arquivos + CVE de dependências; ~$0.18–0.72
   - `/security-scan` — pós-deploy; comportamento runtime + HTTP dinâmico; ~$0.05
2. **Custo total: ~$0.8–1.2/mês** vs. Snyk $98/mês ou consultor $200–500/hora.
3. **Detecção 100%** medida objetivamente via test harness — não auto-avaliação.
4. **Instalação via `gh skill`:** `gh skill install sabakan0123/claude-security-skills` — suporta Claude Code, Cursor, Codex com escopo global ou por projeto.
5. **Lição de arquitetura:** separar estático de dinâmico evita custo redundante e falsos negativos. "Sem problemas estáticos" ≠ "sem problemas dinâmicos".
6. **Recomendação de segurança:** sempre fazer `gh skill preview` antes de instalar skills de segurança.

## Como funciona cada skill em detalhe

### `/security-review` — Análise estática de PR

Executa apenas sobre o `git diff` do PR. Isso tem três vantagens: o custo é mínimo (~$0.02), o feedback chega antes do merge quando é mais barato corrigir, e o escopo limitado evita falsos positivos causados por contexto irrelevante. O skill verifica injeção de SQL, XSS, deserialização insegura, segredos hardcoded, e problemas de autenticação/autorização — os vetores mais comuns em code review.

### `/full-scan` — Análise pré-release

Cobre toda a codebase em vez de apenas o diff. Inclui verificação de CVEs em dependências (equivalente ao que o Snyk faz pela metade do preço). O custo variável ($0.18–0.72) reflete o tamanho da codebase — projetos maiores custam mais, mas ainda assim é uma fração do custo de consultores ou ferramentas SaaS.

### `/security-scan` — Análise pós-deploy

Analisa comportamento em runtime: endpoints HTTP expostos, fluxos de autenticação em produção, cabeçalhos de segurança, e comportamentos dinâmicos que não aparecem na análise estática. É o único dos três que detecta problemas que só existem quando o código está rodando — a distinção entre "sem vulnerabilidades no código" e "sem vulnerabilidades no sistema" é crucial.

## Por que dividir em 3 skills é melhor do que 1

A tentação natural é criar um skill único de segurança que faz tudo. O autor tentou isso e identificou dois problemas:

1. **Custo redundante:** fazer full-scan em todo PR é caro e desnecessário. Análise estática de diff resolve 80% dos casos a 10% do custo.
2. **Falsos negativos por mistura:** análise estática e dinâmica têm modelos mentais diferentes. Um único prompt tentando fazer os dois tende a fazer ambos mal — o modelo alterna entre "o que o código diz" e "o que o sistema faz", perdendo nuances de cada camada.

A separação segue o princípio de responsabilidade única aplicado a agentes: cada skill tem um contexto claro, um momento claro, e uma métrica de sucesso clara.

## Comparação de custo com alternativas

| Ferramenta | Custo mensal | Detecção |
|---|---|---|
| Snyk | $98/mês | Automática, CI/CD |
| Consultor de segurança | $200–500/hora | Manual, episódico |
| 3 skills (sabakan) | ~$1/mês | 100% no test harness |
| GitHub Advanced Security | $49/usuário/mês | SAST automático |

O diferencial não é só custo: o test harness com 100% de detecção é uma métrica objetiva que ferramentas como SAST tradicionais raramente conseguem em todos os casos do harness porque elas são baseadas em regras fixas — o LLM lida com variações sintáticas que burlam regex.

## Instalação e configuração

```bash
# Instalar globalmente
gh skill install sabakan0123/claude-security-skills --global

# Instalar por projeto
gh skill install sabakan0123/claude-security-skills

# Sempre fazer preview antes de instalar skills de segurança
gh skill preview sabakan0123/claude-security-skills
```

A recomendação de `preview` antes de instalar é especialmente importante para skills de segurança: um skill malicioso nessa categoria tem acesso ao código e pode vazar segredos durante a "análise".

## Aplicação no vault-michel

O padrão de 3 skills mapeados para 3 momentos do ciclo é diretamente aplicável ao design de skills do vault. Em vez de um único skill de qualidade, o vault poderia ter:
- `/wiki-check` — verificação rápida de wikilinks no arquivo recém-editado
- `/wiki-audit` — auditoria completa do vault (pré-publicação de sessão)
- `/wiki-runtime` — verificação de consistência entre hot.md e o estado real do vault

O mesmo princípio: custo proporcional ao escopo, separação de análise estática (estrutura de links) da dinâmica (coerência semântica).

## Links

- Zenn: https://zenn.dev/sabakan1/articles/57ca07f4b277b4
- Repo: `sabakan0123/claude-security-skills`
- Relacionado: [[03-RESOURCES/concepts/agent-systems/agentic-skills]], [[03-RESOURCES/concepts/agent-systems/agent-harness]], [[03-RESOURCES/entities/Claude Code]]
