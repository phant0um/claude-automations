---
title: "Memory isn't a plugin. Skills aren't a plugin. They're the same harness."
type: source
source: Clippings/Memory isn't a plugin. Skills aren't a plugin. They're the same harness..md
created: 2026-05-17
ingested: 2026-05-17
tags: [ai-agents, concept, harness, claude]
triagem_score: 9
author: "@tricalt"
---

## Tese central
Memory e skills não são plugins independentes — são a mesma estrutura (harness) operando em fases diferentes do ciclo de um agente. Tratá-los como sistemas separados leva a duplicação de infra, fragmentação de state, e bugs de sincronização. @tricalt articula o insight em um post que se tornou referência no ecossistema Cowork.

## Key insights
- **Skills = memória executável:** skill é conhecimento procedural armazenado como instrução que o agente executa quando contexto corresponde. É memória de "como fazer X" em formato que dispara automaticamente
- **Memória = skill recuperável:** memória factual (quem é o usuário, qual projeto está ativo, qual era o estado da última sessão) é skill de "consultar contexto" — o mesmo mecanismo de retrieval e injection
- **Unificar storage/retrieval/exec layer:** se ambos são o mesmo mecanismo, sistema unificado é mais simples, mais consistente, e mais fácil de debugar que dois sistemas separados com suas próprias APIs
- **Thin harness / fat skill:** insight central de @tricalt alinha com princípio Karpathy — harness é o mecanismo uniforme, skill/memory são o conteúdo. Complexidade fica no conteúdo, não na infra

## O argumento central

### Diagnóstico do problema

Ecossistema de AI builders frequentemente separa:
- **Memory system:** banco de dados de fatos do usuário, histórico de sessões, preferências. Implementado como vector DB + retrieval pipeline
- **Skill system:** receitas de comportamento, SKILL.md files, triggers. Implementado como arquivo de configuração + matching de contexto

Duas infras separadas, dois formatos de dados separados, dois sistemas de atualização separados.

### A unificação

@tricalt observa que ambos compartilham a mesma estrutura:

```
[1] Armazenar: guardar informação estruturada
[2] Indexar: tornar recuperável por contexto
[3] Recuperar: injetar no prompt quando relevante
[4] Executar: agente usa a informação injetada
```

Diferença entre skill e memória é apenas no conteúdo:
- Skill: "quando usuário pede análise de dados, usar este template e estas ferramentas"
- Memória: "usuário prefere código em Python, projeto atual é vault-michel, última tarefa foi ingestão de 5 fontes"

Formato de armazenamento, retrieval trigger, e injection mechanism são idênticos. Sistema unificado implementa uma vez.

## Implementação unificada

### Unified Memory-Skill Store

```python
class UnifiedStore:
    def store(self, content, trigger_description, ttl=None, type="skill|memory"):
        """
        content: o que injetar no contexto quando ativado
        trigger_description: quando ativar (para matching semântico)
        ttl: None (permanente) ou timestamp (memória de sessão)
        """
        pass
    
    def retrieve(self, current_context, top_k=5):
        """
        Retorna conteúdo mais relevante para o contexto atual.
        Skills e memórias tratados igualmente — apenas relevância importa.
        """
        pass
```

Skill "análise de dados" e memória "usuário chama Michel" vivem na mesma store, são recuperadas pelo mesmo mecanismo, injetadas pelo mesmo pipeline.

### Vantagens da unificação

1. **Sem sincronização:** skill atualizada reflete imediatamente; memória atualizada disponível na próxima query. Sem dois caches para manter
2. **Prioridade unificada:** sistema pode rankear "qual instrução é mais relevante agora" entre skills e memórias usando mesmo critério de relevância
3. **Debugging simples:** uma store, um log de retrievals, um ponto de falha. Fragmentação de sistemas significa log de skill + log de memory + reconciliar ambos
4. **Evolução consistente:** melhorar retrieval melhora tanto skills quanto memórias simultaneamente

## Casos onde separação ainda faz sentido

- **TTL diferente:** memória episódica (curta) vs skill permanente — tags diferentes mas mesma store
- **Scope diferente:** memória global vs memória de projeto vs skill compartilhada — partições dentro da store unificada, não stores separadas
- **Privacidade:** memória pessoal que não deve vazar para outros usuários — controle de acesso dentro da store, não store separada

## Aplicação no vault-michel

Vault usa skills (pasta `~/.claude/skills/`) e memória (`~/.claude/projects/.../memory/`) como sistemas separados. Consolidação seria: store única com partições por tipo e TTL. Hot.md funciona como memória de alta prioridade injetada primeiro — implementação prática da ideia de unificação.

## Por que importa além de elegância arquitetural

Sistemas separados acumulam divergência. Skill diz "usuário prefere output em Markdown". Memória diz "usuário pediu HTML na última sessão". Qual vence? Com sistemas separados, não há resolução determinística. Com store unificada e timestamps, memória mais recente vence — comportamento previsível.

## Implicação para evolução do vault

Vault-michel tem skills em `~/.claude/skills/` e memória em `~/.claude/projects/.../memory/`. São sistemas separados atualmente. A unificação proposta por @tricalt sugeriria:

1. Uma store única com partições por tipo (skill/memory), TTL, e scope (global/project)
2. Retrieval unificado por relevância de contexto — skill e memória competem no mesmo ranking
3. Resolução de conflitos por timestamp — informação mais recente tem precedência

Migração para esse modelo seria simplificação real: menos sistemas para manter, comportamento mais previsível, debugging centralizado.

## Crítica ao insight

O insight de @tricalt é correto no nível de abstração, mas implementação prática tem nuances:

**Skills têm estrutura de invocação diferente de memória:** skill tem description que deve fazer matching semântico preciso para trigger. Memória deve ser injetada sempre que relevante (threshold mais baixo). Unificar o retrieval mas manter lógicas de threshold distintas resolve a tensão.

**Skills são receitas, memória é estado:** skill não muda entre execuções (é definição). Memória muda (é observação do mundo). Sistema unificado precisa de campo `mutable: true/false` para separar os dois semanticamente mesmo que compartilhem infra.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
