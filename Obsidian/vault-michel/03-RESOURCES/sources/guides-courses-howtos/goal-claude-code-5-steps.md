---
title: How to Use /goal in Claude Code (5-step workflow)
type: source
source: Clippings/gemini-code-1778767956414.md
created: 2026-05-15
ingested: 2026-05-15
tags: [ai-agents]
triagem_score: 7
---

## Tese central
/goal foca em estado final ao invés de passos individuais — agente planeja, executa, verifica, debuga até cada success criterion ser atingido.

## Key insights
- Workflow 5 passos: OPEN → TYPE /goal → FILL (Contexto, Critérios, Regras, Quality Bar) → APPROVE PLAN → WALK AWAY.
- Anatomia: Resultado (1 linha), Contexto, Critérios mensuráveis, Regras operacionais, Entregável final (provas).
- Use Opus 4.7 + High Effort para tarefas longas; exija provas (screenshots/testes/URL); não interrompa o loop.

## Links
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/claude-code-tooling/goal-command]]

---

## O Workflow de 5 Passos em Detalhe

### Passo 1 — OPEN: Abrir Claude Code na sessão certa

Não abra o /goal em uma sessão com contexto poluído de tasks anteriores. Comece fresh — o /goal vai acumular seu próprio contexto durante as iterações, e contexto residual de outra task pode causar interferência.

Dica prática: se você acabou de fazer outra task complexa, use `/compact` antes ou abra uma nova sessão. O /goal precisa de contexto limpo para o modelo validador operar sem viés de decisões anteriores.

### Passo 2 — TYPE /goal: Ativar o Modo de Objetivo

Digitar `/goal` ativa o modo de objetivo no harness. Em alguns clientes (Codex desktop), isso muda a UI para mostrar os critérios de forma mais proeminente. No Claude Code CLI, é um slash command que instrui o agente a entrar no loop de validação.

Variações de trigger por plataforma:
- Claude Code: `/goal`
- Hermes: criar task com campo `type: goal`
- Codex CLI: flag `--goal`
- Codex Desktop: `Settings → goals=true` + botão na UI

### Passo 3 — FILL: Preencher os 4 Campos

Este é o passo mais crítico. A qualidade do /goal é determinada pela qualidade dos campos:

**Contexto:** não repita o que está no CLAUDE.md. Adicione apenas o que é específico desta task: versão da biblioteca relevante, módulo afetado, comportamento atual vs comportamento desejado.

**Critérios mensuráveis:** a lista que o modelo usará para decidir se terminou. Cada critério deve ter um método de verificação explícito:

```markdown
- [ ] `npm test` retorna exit code 0 (verifica via terminal)
- [ ] `npm run build` sem erros (verifica via terminal)
- [ ] Endpoint responde com status 200 para request válido (verifica via curl)
- [ ] Endpoint responde com status 401 para request sem token (verifica via curl)
- [ ] Console do browser não mostra erros JS (verifica via screenshot)
```

**Regras operacionais:** constraints que o agente deve respeitar durante o loop. Crítico incluir o que NÃO fazer:
- "Não modifique arquivos fora de `src/auth/`"
- "Não adicione dependências novas ao package.json"
- "Não altere o schema do banco de dados"

**Quality Bar:** o padrão mínimo de qualidade, além dos critérios binários. Ex: "o código deve seguir as convenções do CLAUDE.md", "sem TypeScript any", "sem console.log em produção".

**Entregável final (provas):** o que o agente deve anexar ao encerrar o loop como evidência. Screenshots, output de terminal, URL testável, lista de arquivos modificados.

### Passo 4 — APPROVE PLAN: Revisar o Plano do Agente

Antes de executar, o agente gera um plano: quais arquivos vai tocar, em que ordem, qual é a lógica de cada step. Esta é sua última oportunidade de intervir sem custo.

Sinais de plano problemático:
- "Vou refatorar o módulo X" quando X não é o escopo do goal
- "Vou instalar a dependência Y" quando você bloqueou isso nas regras
- Mais de 10 arquivos afetados para uma task que deveria ser simples
- Nenhuma menção a testes quando os critérios incluem testes

Se o plano parece razoável, aprove. Se não, corrija antes de executar — é muito mais barato corrigir o plano do que desfazer a execução.

### Passo 5 — WALK AWAY: Deixar o Loop Rodar

Esta é a mudança de paradigma central. O instinto é acompanhar cada iteração, fazer microajustes, aprovar cada commit. Resistir a isso: a razão de usar /goal é exatamente remover o humano do loop.

Exceções legítimas para interromper:
- O agente pede input explicitamente (regra operacional não cobriu algo)
- Você percebe que um dos critérios está errado
- O agente está claramente preso em loop por critério inalcançável
- O custo de tokens está muito alto sem convergência

Quando o /goal encerra, revisar as provas antes de considerar o trabalho completo.

---

## Anatomia do /goal vs Instrução Direta

| Dimensão | Instrução Direta | /goal |
|---|---|---|
| Quem valida | Humano (cada step) | Modelo (critérios) |
| Iterações | Controladas pelo humano | Automáticas até convergência |
| Custo humano | Alto (presença contínua) | Baixo (setup + revisão final) |
| Custo de tokens | Menor (less iterations) | Maior (validação em cada ciclo) |
| Melhor para | Tasks simples, <30min | Tasks complexas, >1h |
| Risco de loop | N/A | Alto se critério mal definido |

---

## Exemplos de /goal para o Vault-Michel

**Exemplo 1 — Ingest de batch:**
```
Resultado: todos os arquivos em 00-INBOX/ foram processados e movidos
Critérios: 00-INBOX/ está vazio, cada arquivo tem entrada em .raw/.manifest.json,
           hot.md foi atualizado, zero wikilinks mortos criados
Regras: não delete arquivos sem criar a nota correspondente primeiro
Provas: output do lint de wikilinks, conteúdo do 00-INBOX/ vazio
```

**Exemplo 2 — Correção de wikilinks:**
```
Resultado: zero wikilinks mortos no vault
Critérios: script de verificação retorna 0 dead links
Regras: não crie páginas novas para resolver links mortos (corrija os links)
Provas: output do script de verificação
```

---

## Limitações

- O modelo validador pode ser enganado por critérios que parecem passar mas não passam semanticamente (ex: `npm test` passa mas os testes são triviais e não cobrem o comportamento)
- Loops longos acumulam contexto e aumentam o custo por iteração — monitor ativamente
- /goal não substitui review humano; é uma automação de execução, não de julgamento
- Hermes com /goal persistente pode continuar rodando mesmo quando você esqueceu que iniciou — mantenha lista de goals ativos no control room
