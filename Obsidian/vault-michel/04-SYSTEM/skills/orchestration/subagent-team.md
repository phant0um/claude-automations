---
skill: subagent-team
version: 1.0
author: Nexus Agent System
tags: [orchestration, parallel, team, researcher, editor, pm, analyst]
---

# Skill: Subagent Team

## Propósito
Orquestrar um time de sub-agentes especializados para tarefas que requerem múltiplas perspectivas simultâneas — substituindo workflows seriais por execução paralela coordenada.

---

## Condições de Ativação
Ative esta skill quando:
- A tarefa envolver >2 domínios distintos que podem ser trabalhados em paralelo
- O usuário solicitar `@team [tarefa]`
- Uma análise profunda exigir simultaneamente: pesquisa + estrutura + revisão crítica

NÃO ative para: tarefas sequenciais estritas; operações que precisam de output de um agente para iniciar outro; tarefas <10 min.

---

## Catálogo de Sub-Agentes Disponíveis

| Sub-Agente | Modelo | Especialidade | Quando Convocar |
|-----------|--------|--------------|----------------|
| **Researcher** | `claude-sonnet-4-6` + web search MCP | Coleta e síntese de dados, fact-checking | Sempre que houver questões factuais abertas |
| **Editor** | `claude-haiku-4-5` | Refinamento de texto, clareza, consistência | Output textual que vai para usuário final |
| **PM (Product Manager)** | `claude-sonnet-4-6` | Priorização, user stories, OKRs | Decisões de produto/feature |
| **Analyst** | `claude-sonnet-4-6` | Dados, métricas, padrões quantitativos | Qualquer análise com números |
| **Critic** | `claude-opus-4-8` | Revisão adversarial, red-team | Antes de decisões críticas irreversíveis |
| **Ops** | `claude-haiku-4-5` | Tarefas operacionais, scripts, automação | Execução mecânica de procedimentos |

> **Regra de ouro de custo**: Convoque Opus (Critic) apenas quando a decisão for irreversível ou de alto impacto. Para revisões normais, Sonnet é suficiente.

---

## Protocolo de Execução

### PASSO 1 — Decomposição *(Nexus/Sonnet)*
Quebre a tarefa em sub-tarefas independentes:
- Identifique: quais sub-tarefas NÃO dependem umas das outras (paralelizáveis)
- Identifique: dependências sequenciais obrigatórias
- Atribua: cada sub-tarefa ao sub-agente mais adequado

Exemplo de decomposição para "análise competitiva de produto X":
```
PARALELO:
  Researcher → coleta dados de mercado, reviews, pricing
  Analyst → busca métricas de crescimento e benchmarks
  PM → define critérios de avaliação e framework de análise
SEQUENCIAL (após paralelos):
  Editor → consolida em documento coeso
  Critic → revisão adversarial do documento final
```

### PASSO 2 — Briefing dos Sub-Agentes *(Nexus)*

**Antes de montar o prompt:** se a sessão tiver >10 mensagens de contexto, rodar `/brief <agente>` para cada sub-agente antes de continuar. Brief = [[04-SYSTEM/skills/orchestration/brief]].

Para cada sub-agente, forneça na ordem:
```
[1] Brief da sessão (output de /brief — decisões tomadas, restrições ativas)
[2] Skills injetadas (conteúdo completo das skills relevantes para este agente)
    → consultar tabela de roteamento do Nexus: [[04-SYSTEM/agents/nexus-agent-system/nexus]]
[3] Prompt do sub-agente:
    Você é o <Nome> do time Nexus.
    Tarefa: <sub-tarefa específica>
    Input disponível: <o que você tem acesso>
    Output esperado: <formato e conteúdo exato>
    Prazo de contexto: <tokens budget — mantenha conciso>
    Modelo de entrega: escreva em <arquivo>.md ao concluir
```

**Regra:** nunca entregar apenas o prompt sem brief + skills. Sub-agente sem contexto re-deriva premissas resolvidas e pode contradizer decisões da sessão.

### PASSO 3 — Execução Paralela *(múltiplos sub-agentes)*
- Dispatcher os sub-agentes paralelizáveis simultaneamente
- Cada sub-agente escreve seu output em arquivo dedicado: `team/<agente>-output.md`
- Não espere por todos para iniciar os sequenciais — inicie assim que dependências forem satisfeitas

### PASSO 4 — Consolidação *(Editor/Haiku)*
- Leia todos os `team/*-output.md`
- Elimine redundâncias, resolva contradições (marque divergências com `[CONFLITO]`)
- Produza `team/consolidated.md` mantendo atribuição de cada contribuição

### PASSO 5 — Revisão Adversarial (se crítico) *(Critic/Opus)*
Instrução para o Critic:
```
Leia consolidated.md com olhar de red-team.
Questione:
- Pressupostos não declarados
- Conclusões que não seguem dos dados
- Riscos não endereçados
- Vieses de confirmação
NÃO seja construtivo — seja cético. Seu papel é encontrar o que está errado.
Output: lista de findings com severidade (BLOQUEANTE | IMPORTANTE | MENOR)
```

Se findings BLOQUEANTES: retorne ao agente responsável para revisão.

---

## Artefatos de Saída
- `team/<agente>-output.md` — saídas individuais
- `team/consolidated.md` — versão integrada
- `team/critic-review.md` — se revisão adversarial foi executada

---

## Restrições
- NUNCA convoque todos os sub-agentes para tarefas que um único agente resolve
- NUNCA use Opus para Researcher, Editor, ou Ops — desperdício claro
- NUNCA ignore findings BLOQUEANTES do Critic — eles existem para isso
- Se um sub-agente exceder 2× o tempo estimado: cancele e atribua ao próximo mais capaz
- **Max spawn depth: 2** (parent → subagent → 1 nível mais). Se subagent precisa de modelo mais capaz → retorna ao parent com contexto, não escala sozinho
- **Single-threaded writes:** apenas 1 agente escreve por arquivo. Outros contribuem inteligência (review, análise), não ações de escrita concorrentes
