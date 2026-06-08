---
skill: brief
version: 1.0
trigger: "/brief [agente-destino]" | "@brief antes de delegar para [agente]"
model: claude-haiku-4-5
tags: [orchestration, context, delegation, compression, nexus]
---

# Skill: Brief

## Propósito

Destilar o contexto da sessão atual em um brief orientado à ação antes de delegar para um subagente. Evita que o subagente herde noise de conversas longas ou re-derive contexto do zero.

**Diferença de `/compact`:** compact gerencia o context window do modelo principal. `brief` produz um documento de handoff para um subagente específico — contexto filtrado pela lens da tarefa dele.

**Por que importa:** subagente lançado sem brief lê N mensagens de contexto, re-deriva premissas já resolvidas, e pode contradizer decisões já tomadas na sessão. Brief = contexto certo, para o agente certo, na hora certa.

---

## Condições de Ativação

Ative automaticamente (Nexus deve chamar esta skill) quando:
- Delegando para subagente após conversa com >10 mensagens
- Subagente vai tomar decisões que dependem de context da sessão atual
- Sessão tem múltiplas decisões tomadas que o subagente precisa respeitar

NÃO ative para: subagentes que operam completamente autônomos com input próprio (ex: wiki-ingest com arquivo .raw); delegações simples de 1 passo sem histórico relevante.

---

## Modelo por Etapa

| Etapa | Modelo | Razão |
|-------|--------|-------|
| Toda a execução | Haiku | Destilação é lookup + formatação, não síntese |

---

## Protocolo

### 1. Identificar Agente Destino

Qual agente vai receber o brief? Determina o filtro de relevância.

Cada agente precisa de tipos diferentes de contexto:
- `guard` → decisões de escopo + restrições ativas
- `hill` → comportamentos problemáticos observados + versão do agente
- `verify` → spec + critérios de aceitação acordados
- `extend` → o que vai ser adicionado + restrições de "não mudar"
- `review` → o que mudou na sessão + o que deve ser preservado

### 2. Varrer Contexto da Sessão

Percorrer o histórico da conversa e extrair apenas:

```
A. DECISÕES TOMADAS
   [lista de decisões relevantes para o agente destino — com justificativa se não óbvia]

B. RESTRIÇÕES ATIVAS
   [princípios do CLAUDE.md que se aplicam a essa tarefa]
   [restrições específicas mencionadas pelo usuário nesta sessão]

C. ESTADO ATUAL
   [arquivos modificados, agentes alterados, estado do vault relevante]

D. TAREFA DELEGADA
   [o que exatamente o subagente deve fazer — 1-3 frases]
   [o que está fora do escopo desta delegação — 1-3 frases]

E. CONTEXTO IGNORAR
   [tópicos da sessão que NÃO são relevantes para este subagente]
```

### 3. Formatar Brief

```markdown
# Brief para @<agente-destino> — <data>

## Decisões tomadas nesta sessão
- [decisão 1] — [justificativa se relevante]
- [decisão 2]

## Restrições ativas
- [restrição do CLAUDE.md]
- [restrição específica da sessão]

## Estado atual relevante
- [arquivo X foi modificado: o que mudou]
- [agente Y está na versão Z]

## Sua tarefa
[1-3 frases do que o subagente deve fazer]

## Fora do escopo desta delegação
[o que o subagente NÃO deve fazer/mudar]

## Ignorar desta sessão
[tópicos irrelevantes para este subagente]
```

### 4. Entregar

O brief é passado como contexto inicial ao subagente pelo Nexus, antes das skills injetadas.

Ordem no prompt do subagente:
```
1. Brief (desta skill)
2. Skills injetadas (da tabela de roteamento do Nexus)
3. Tarefa específica
```

---

## Restrições

- NUNCA incluir o histórico completo da conversa — brief é filtro, não dump
- NUNCA omitir decisões que o subagente poderia contradizer
- Máximo 30 linhas — se precisar de mais: a sessão tem problemas de escopo, não de brief
- Se não houver decisões relevantes para o agente destino: brief de 3 linhas é suficiente

---

## Relacionado

- [[04-SYSTEM/agents/nexus]] — Nexus chama esta skill antes de cada delegação não-trivial
- [[04-SYSTEM/skills/orchestration/subagent-team]] — subagent-team usa brief no PASSO 2 de briefing
