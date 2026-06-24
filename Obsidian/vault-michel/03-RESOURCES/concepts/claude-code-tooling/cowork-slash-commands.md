---
title: Cowork Slash Commands
type: concept
status: developing
tags: [claude-cowork, slash-commands, workflow, productivity, automation]
created: 2026-05-01
updated: 2026-05-01
---

# Cowork Slash Commands

Slash commands são ações explícitas no [[03-RESOURCES/entities/Claude-Cowork]] digitadas com `/`. São uma das 6 camadas que a maioria dos usuários nunca usa plenamente. Os 12 comandos documentados cobrem desde gestão de contexto até input por voz e sub-agentes especializados.

> [!key-insight] Os 3 mais importantes
> `/plan` (token discipline), `/compact` (context management), `/cost` (budget visibility). Estes três sozinhos evitam a maioria dos "token disasters" em sessões complexas.

## Referência completa dos 12 comandos

### Tier Beginner — usar hoje

| Comando | O que faz | Quando usar |
|---------|-----------|-------------|
| `/schedule` | Cria task recorrente em background | Qualquer coisa que você faz manualmente toda semana |
| `/loop` | Poll em intervalo dentro da sessão atual | Monitorar builds, deploys, outputs em tempo real |
| `/plan` | Escreve plano passo a passo antes de executar | **Sempre que a task toca 3+ arquivos** |
| `/compact` | Comprime contexto; 40–60% context savings | Antes de Claude começar a repetir erros |
| `/clear` | Reset nuclear da thread | Contexto tão poluído que Claude está te combatendo |

### Tier Intermediate — configurar esta semana

| Comando | O que faz | Quando usar |
|---------|-----------|-------------|
| `/resume` | Retoma conversa anterior pelo nome | Trabalho multi-sessão; par obrigatório com `/rename` |
| `/rename` | Auto-nomeia thread por conteúdo | Sempre; transforma sidebar em índice buscável |
| `/cost` | Mostra custo estimado de tokens antes de executar | Antes de qualquer task no plano Pro |
| `/memory` | Lista memory files e contexto carregado | Primeiro diagnóstico quando Claude age de forma estranha |
| `/doctor` | Lista apps conectados, skills, permissões, comandos disponíveis | Qualquer coisa quebrada sem motivo óbvio |

### Tier Pro — setup deliberado

| Comando | O que faz | Quando usar |
|---------|-----------|-------------|
| `/voice` | Push-to-talk; Espaço = gravar; mix typing + voz | Prompts longos; pensar em voz alta |
| `/agents` | Spawna sub-agente especializado dentro do projeto | Criar "test writer" ou "PR reviewer" com conventions próprias |

---

## Detalhe dos comandos mais críticos

### `/plan` — o mais importante

```
/plan> Migrar todos os logs de /archive para /processed, 
       renomear com formato YYYY-MM-DD-[nome], 
       e gerar relatório de contagem por mês
```

**Por que funciona:** força Claude a declarar sua intenção antes de agir. Você revisa. Aprova. Então ele executa. Custo: 3 segundos. Custo de pular: folder corruption.

> [!warning] Regra prática
> Se a task toca mais de 3 arquivos ou tem qualquer operação destrutiva (rename, move, delete), `/plan` é obrigatório.

### `/compact` — gestão de context rot

O `/compact` comprime o histórico mantendo os pontos significativos. Analogia: é o `git squash` de uma sessão.

**Quando rodar:** ao perceber que Claude começa a:
- Contradizer coisas que disse 20 mensagens atrás
- Esquecer arquivos já lidos
- Repetir trabalho já feito

**Não esperar pelos sintomas** — rodar proativamente quando o thread está longo.

Ver também: [[03-RESOURCES/concepts/llm-ml-foundations/context-window]] e [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]]

### `/schedule` — o mais subutilizado

```
/schedule> Every weekday 7:30am: triage Gmail, summarize calendar, 
           save to /Daily/[date].md
```

**Diferença de plano:**
- **Pro:** roda apenas enquanto Cowork está aberto
- **Max:** roda em background mesmo com laptop fechado

Ver automações completas: [[03-RESOURCES/concepts/claude-code-tooling/cowork-scheduled-automations]]

### `/cost` — token budget discipline

Mostra custo estimado **antes** de executar. No plano Pro, a diferença entre terminar a semana e queimar a alocação na quarta.

**Workflow:** `/cost` → se 3x do normal → reduce scope com `/plan` → executar.

### `/agents` — sub-especialistas por projeto

Dentro de qualquer projeto, `/agents` gera um sub-agente com conhecimento específico do repo. Exemplos:

- **test-writer agent:** conhece suas testing conventions
- **PR reviewer agent:** conhece o code style da equipe

Claude usa automaticamente o agente relevante quando detecta o contexto.

Relacionado: [[03-RESOURCES/concepts/agent-systems/subagent-spawning]] e [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] (pasta `agents/`)

---

## Padrões de uso composto

### Pattern: Plan → Cost → Execute

```
1. /plan   → revisar o plano proposto
2. /cost   → verificar budget de tokens  
3. Executar se dentro do orçamento
```

### Pattern: Loop + Schedule para monitoring

```
/loop > A cada 3 minutos, checar se deploy log mostra green
/schedule > Salvar resultado final em /Deploy/[date].md
```

### Pattern: Compact + Resume para multi-day work

```
[Fim do dia 1]: /compact → /rename "projeto-x-dia1"
[Início do dia 2]: /resume "projeto-x-dia1"
```

---

## Progressão de adoção

**Semana 1:** `/plan` + `/compact` + `/clear` — gestão de contexto.  
**Semana 2:** `/cost` + `/memory` + `/doctor` — visibilidade e diagnóstico.  
**Semana 3+:** `/schedule` + `/voice` + `/agents` — automação e especialização.

---

## Fontes

- [[03-RESOURCES/sources/claude-code-cowork/claude-cowork-60-commands-workflows]] — 60 commands, 4 months daily use
- [[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]] — plugins como camada acima dos comandos
- [[03-RESOURCES/entities/Claude-Cowork]] — entidade: o produto
