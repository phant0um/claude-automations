---
title: /goal - Ultimate Guide (Codex + Claude Code)
type: source
source: Clippings/goal - Ultimate Guide.md
created: 2026-05-15
ingested: 2026-05-15
tags: [ai-agents]
triagem_score: 7
---

## Tese central
/goal = loop autônomo onde modelo pequeno valida critérios; remove humano como bottleneck — "24/7 mini AI employee".

## Key insights
- Sem /goal: humano aprova cada passo. Com /goal: Claude valida sozinho e fecha o loop até critério ser TRUE.
- Funciona em Codex CLI, Claude Code CLI, Hermes agent, Codex desktop (Settings → goals=true).
- Ralph loop viralizado meses atrás — /goal é a versão nativa institucionalizada do mesmo padrão.

## Links
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/claude-code-tooling/goal-command]]

---

## O que é o /goal e Como Funciona

### Definição

`/goal` é um comando de loop autônomo disponível em Claude Code, Codex CLI, e Hermes. Em vez de instruir o agente passo-a-passo, você define um estado final desejado com critérios de sucesso mensuráveis. O agente planeja, executa, verifica contra os critérios, e itera até todos os critérios retornarem TRUE — sem intervenção humana em cada ciclo.

### O Loop de Validação Interno

O mecanismo central do /goal é substituir o humano como validador por um modelo menor (frequentemente o mesmo modelo em modo compacto, ou um modelo mais barato) que avalia objetivamente se cada critério foi atingido:

```
[humano define /goal] → [agente planeja] → [executa]
        ↑                                      ↓
[todos TRUE? → encerra]  ←  [modelo valida critérios]
        ↓ (algum FALSE)
[agente re-planeja e re-executa]
```

A inovação não é técnica — é ergonômica. O humano não é mais bottleneck entre iterações. O loop roda 24/7 até convergir.

### Anatomia de um /goal Bem Formado

Um /goal eficaz tem 5 componentes:

**1. Resultado (1 linha):** o que deve estar verdadeiro no final. Ex: "O endpoint `/api/users` retorna lista paginada com autenticação JWT."

**2. Contexto:** informação que o agente precisa mas não tem acesso direto. Stack, convenções, dependências externas relevantes.

**3. Critérios mensuráveis:** a lista de verificações que o modelo validador usa. Cada critério deve ser TRUE/FALSE sem ambiguidade:
- `npm test` retorna exit code 0
- `curl -H "Authorization: Bearer invalid" /api/users` retorna 401
- Resposta inclui `X-Total-Count` header
- Latência p99 < 200ms em carga de 100 req/s

**4. Regras operacionais:** o que o agente pode e não pode fazer. Ex: "não modificar schema existente", "não adicionar dependências sem aprovação".

**5. Entregável final (provas):** o que o agente deve produzir como evidência de conclusão. Screenshots, output de testes, URL funcionando, diff de código.

---

## Comparação com o Ralph Loop

O Ralph loop (viral meses antes do /goal ser institucionalizado) era a mesma ideia implementada via prompt engineering manual: o operador escrevia um prompt que instruía o agente a verificar seus próprios critérios e iterar. Funcionava, mas era frágil — dependia de o prompt estar muito bem escrito.

`/goal` é a versão nativa do mesmo padrão: o harness gerencia o loop, a verificação, e o estado entre iterações. O operador não precisa engenhar o prompt de loop — só define os critérios.

**Diferença prática:** com Ralph loop, o agente pode "esquecer" que está em loop se o contexto ficar muito longo. Com /goal nativo, o harness mantém o loop explicitamente, independente do comprimento do contexto.

---

## Plataformas e Configuração

### Claude Code CLI
`/goal` é um slash command nativo. Ativar em `Settings → goals=true` ou via CLI flag. O agente usa o modelo padrão configurado.

### Codex CLI
Suporte nativo. Flags:
```bash
codex --goal "descrição do objetivo" --criteria "arquivo_de_criterios.md"
```

### Hermes
Hermes trata /goal como um tipo especial de task: persiste o estado entre sessões, envia notificação quando completo, e guarda o log de iterações no control room.

---

## Casos de Uso e Anti-Casos

**Ideal para /goal:**
- Implementar feature completa com testes (critérios: testes passam, coverage >80%)
- Refatorar módulo com zero regressões (critério: suite de testes verde antes e depois)
- Configurar CI/CD (critério: pipeline verde, deploy funciona)
- Migração de banco de dados (critério: zero registros perdidos, queries equivalentes)

**Não ideal para /goal:**
- Tasks criativas ou subjetivas sem critério objetivo (ex: "melhore o estilo do código")
- Tasks que requerem input humano no meio (ex: "pergunte ao cliente sobre o design")
- Tasks muito curtas onde o overhead do loop não vale (ex: "corrija este typo")
- Qualquer task onde "errado" tem custo catastrófico e irreversível

---

## Boas Práticas

**Use Opus 4.7 + High Effort para tasks longas:** modelos mais capazes no loop reduzem o número de iterações, economizando no total mesmo com custo por token maior.

**Exija provas concretas:** critérios vagos como "o código está limpo" não são verificáveis. Sempre: "lint retorna 0 warnings", "cobertura de testes > X%".

**Não interrompa o loop:** interromper no meio invalida o estado interno do agente. Se precisar intervir, espere o ciclo atual completar.

**Comece com critérios conservadores:** é melhor um /goal que termina e você adiciona mais critérios do que um /goal que nunca termina por critério inalcançável.

---

## Relevância para o Vault

O padrão /goal é diretamente aplicável a tarefas do vault que têm critérios objetivos:
- "Processar todos os arquivos em `00-INBOX/` — critério: pasta vazia"
- "Corrigir todos os wikilinks mortos — critério: lint retorna 0 broken links"
- "Atualizar hot.md com todos os sources da semana — critério: todos sources com `created >= DATE` estão em hot.md"

A combinação `/goal` + skills do vault cria um loop de automação que pode rodar sem supervisão contínua.

---

## Limitações

- Critérios mal definidos geram loops infinitos ou convergência prematura com resultado errado
- O modelo validador pode ter falsos positivos — "testes passam" não significa "código correto", apenas que os testes existentes passam
- Loops longos acumulam contexto, aumentando custo por iteração ao longo do tempo — monitor o custo se o loop levar muitas iterações
- Hermes persiste estado entre sessões, o que é poderoso mas requer cleanup explícito de /goals abandonados para não acumular estado inválido
