---
title: "How to Use /goal In Codex Like a Pro"
type: source
source_file: Clippings/How to Use goal In Codex Like a Pro.md
origin: post no X
author: "@ziwenxu_"
published: 2026-05-01
ingested: 2026-05-14
tags: [codex, goal-command, agentic, openai, outcome-declaration, long-running-sessions]
triagem_score: 7
---

# How to Use /goal In Codex Like a Pro

> [!key-insight] Core insight
> `/goal` transforma o Codex de um executor de passos em um motor de verificação de realidade: em vez de "faça X", você declara "X é verdade" — e o agente continua trabalhando até que seja.

## Sections

### O Conceito Central

- Prompt regular = instrução (o que fazer)
- `/goal` = condição de sucesso (o que deve ser verdade ao final)
- "Intention Decay": em chats normais, a missão original se perde sob o peso do trabalho conforme o context window enche; `/goal` age como âncora persistente de sessão

### Toolkit de Comandos

| Comando | Função |
|---------|--------|
| `/goal <objetivo>` | Define ou substitui a missão |
| `/goal` | Verifica status |
| `/goal pause` | Pausa |
| `/goal resume` | Retoma |
| `/goal clear` | Limpa antes de trabalho não relacionado |
| `Shift+Tab` | Sai do Plan Mode antes de executar |
| `codex resume <id>` | Recupera sessões longas |

### Status Possíveis

- **PURSUING / ACTIVE** — loop em execução
- **PAUSED** — aguardando ajuste de constraints
- **ACHIEVED / COMPLETE** — missão cumprida
- **UNMET** — agente não encontrou caminho para o objetivo
- **BUDGET_LIMITED** — limite de tokens atingido

### Template de /goal Bem Escrito

```
/goal Make [final outcome] true.
Scope: [what Codex can touch]

Constraints:
- [what must not change]
- [rules to follow]

Done when:
1. [verifiable condition]
2. [test/command/file that proves progress]
3. [final evidence]

Stop if:
- [condition where Codex should pause]
- [anything risky or destructive]
```

### 6 Falhas Comuns

1. **Plan Mode Trap** — `/goal` dentro de `/plan` não inicia loop; exit via Shift+Tab primeiro
2. **Mid-Run Amnesia** — auto-compact durante goal pode perder o "North Star"; não use `/compact` manual durante goal
3. **Ghost Session** — iniciar thread com `/goal` esconde na história; enviar uma linha de status antes
4. **Vague Adjectives** — "improve", "all", "thorough" são poison; usar estados verificáveis
5. **No Kill Switch** — adicionar sempre "Limit this run to X tokens"
6. **Sledgehammer Problem** — agente pode deletar/dropar para limpar; usar "Stop if" para operações destrutivas

### Quando Usar (e Quando Não Usar)

**Bom:** bug com testes + risk review, preparar repo para launch, sync de docs/scripts/tests, migração com limites claros, implementar spec, auditoria end-to-end

**Ruim:** perguntas pontuais, edições mínimas, pedidos vagos ("improve everything"), decisões de produto que precisam de taste, operações destrutivas sem aprovação humana

### O Pattern Arquiteto

1. **Plan** até a condição de sucesso estar clara
2. **Audit** o plano contra o repo
3. **Execute** com /goal

> "Prompts are for conversation. Goals are for shipping."

## Por que `/goal` é diferente de um prompt normal

Quando você escreve um prompt, está descrevendo *ações*. Quando usa `/goal`, está descrevendo um *estado final verificável*. Essa distinção tem consequências práticas profundas:

**Prompts normais** são ambíguos sobre quando parar. O modelo executa a instrução e para — mesmo que o resultado esteja quebrado. Se você pediu "adicione tratamento de erro na função X", o modelo adiciona código, mesmo que ele compile mas não funcione.

**`/goal` inverte o fluxo**: o agente continua em loop até que a condição de sucesso seja verdadeira. Ele escreve código, executa testes, analisa falhas, reescreve, e repete. O critério de parada não é "fiz o que foi pedido" — é "o estado desejado é real".

Isso aproxima o Codex de como sistemas de controle funcionam: goal → observe → act → check → loop. É fundamentalmente diferente de um LLM que responde uma vez.

## Intention Decay na prática

Em sessões longas, o "norte" do objetivo original se dissolve. Cada mensagem adiciona contexto novo que dilui o foco original. Ao atingir 70–80% do context window, o agente pode começar a otimizar para as últimas mensagens, esquecendo o objetivo inicial.

O `/goal` resolve isso sendo injetado como ancora persistente — não como mensagem no histórico, mas como parte do estado da sessão. Mesmo após compactação automática de contexto, o goal permanece ativo.

**Indicador prático**: se você percebe que o agente "mudou de assunto" ou está resolvendo problemas que não pediu, o goal foi corrompido. Use `/goal` sem argumento para verificar o status atual antes de continuar.

## Diferença entre `/goal` e `/plan`

| | `/plan` | `/goal` |
|---|---|---|
| Output | Texto descrevendo o que será feito | Loop de execução ativo |
| Quando para | Após apresentar o plano | Quando condição de sucesso é verdadeira |
| Intervenção humana | Implícita (você aprova o plano) | Explícita (configurada em "Stop if") |
| Ideal para | Trabalho que precisa de revisão antes | Trabalho com critério de sucesso claro |

O pattern recomendado (Arquiteto) une os dois: `/plan` para entender a abordagem, revisão humana, depois `/goal` para execução.

## Relação com o vault

O `/goal` tem análogo direto no contexto deste vault. O [[04-SYSTEM/AGENTS]] define o "firmware" do vault — quem o Nexus é, quais são as regras não-negociáveis, quais são os objetivos de 2026. Funciona como um goal permanente de sistema: em vez de declarar a cada sessão o que deve ser verdade, ele já está lá.

A diferença é que o `/goal` do Codex é transiente (por sessão) enquanto o AGENTS.md é persistente. Para tarefas complexas do vault — ingestão de 50 fontes, auditoria de wikilinks, consolidação de conceitos — um goal bem escrito com critério de sucesso verificável ("todos os arquivos em `/Clippings/` com triagem_score ≥ 7 têm página correspondente em `03-RESOURCES/sources/`") seria mais eficiente do que prompt sequencial.

## Quando usar em projetos de estudo (FIAP / concurso)

Para o ciclo de preparação para concurso, `/goal` seria aplicável a tarefas como:
- "Todos os tópicos de Lógica do edital têm pelo menos um exercício resolvido no vault"
- "Todos os artigos de Java do semestre têm resumo em `02-AREAS/fiap/`"
- "O índice `fiap-index.md` lista todos os arquivos de cada fase"

A condição de sucesso é verificável por script ou por inspeção — exatamente o tipo de critério que `/goal` foi desenhado para perseguir.

## Conexões

- [[03-RESOURCES/concepts/claude-code-tooling/goal-command]] — conceito central; atualizar com contexto Codex CLI
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — intention decay é problema de context rot
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — long-running sessions 10h-20h
- [[03-RESOURCES/entities/Claude Code]] — /goal também disponível no Claude Code
