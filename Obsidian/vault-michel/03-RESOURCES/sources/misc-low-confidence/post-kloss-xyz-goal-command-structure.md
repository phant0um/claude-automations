---
title: "/goal — Como Estruturar o Melhor Comando no Codex e Claude Code"
type: source
source_file: Clippings/Post by @kloss_xyz on X.md
origin: post no X (@kloss_xyz)
ingested: 2026-05-14
tags: [goal-command, claude-code, codex, hermes, prompt-engineering, agent-workflow]
triagem_score: 8
---
# /goal — Como Estruturar o Melhor Comando no Codex e Claude Code

> [!key-insight] Core point
> O comando /goal é o mais poderoso no Codex, Claude Code e Hermes — mas a maioria usa errado escrevendo apenas "não cometa erros"; a estrutura correta define missão, contexto, constraints, plano, critérios de done e stop rules.

## Conteúdo

### Por que a maioria usa errado

- Escrevem "não cometa erros" e rezam
- Falta estrutura para: missão clara, classificação de incertezas, eliminação de scope creep, fechamento de loops

### Estrutura completa do /goal

```
GOAL:
<resultado único claro e mensurável; apenas uma missão>

CONTEXT:
<repositório/arquivos/arquitetura/estado atual>
<suposições conhecidas, dependências e decisões anteriores relevantes>

CONSTRAINTS:
<o que não deve mudar>
<padrões/requisitos obrigatórios>
<arquivos/ações proibidos, se houver>

PRIORITY: (opcional)
1. <prioridade mais alta>
2. <prioridade secundária>
3. <prioridade terciária>

PLAN:
<entenda primeiro, depois aja>
<reafirme o entendimento antes de executar mudanças não triviais>
<prefira mudanças mínimas suficientes em vez de reescritas amplas>

DONE WHEN:
<estado de conclusão verificável>
<comportamento esperado preservado ou melhorado>

VERIFY:
<testes/build/lint/typecheck/validação manual>
<declare o que não pôde ser verificado e por quê>
<inclua plano de rollback/contenção para mudanças destrutivas>

OUTPUT:
<resumo conciso/docs/auditoria/resultado>
<arquivos alterados, decisões chave, riscos e follow-ups>

STOP RULES:
<pare em ambiguidades ou riscos de alto impacto>
<superfície incertezas com propostas de maior confiança antes de agir>
<não continue expandindo escopo após objetivo satisfeito>
```

## Por que cada seção existe

### GOAL: a missão única e mensurável

A restrição de "apenas uma missão" é crítica. Agentes com múltiplos objetivos no GOAL tendem a otimizar para o mais fácil ou mais literal — não necessariamente o mais importante. Um GOAL como "adiciona feature X e corrige bug Y e melhora performance de Z" quase sempre resulta em "X feito superficialmente, Y ignorado, Z não tocado". Uma missão, um resultado verificável.

### CONTEXT: o estado do mundo

Esta seção separa o que o agente precisa saber (repositório, arquitetura, estado atual) do que ele precisa fazer. Sem contexto explícito, o agente infere — e inferências sobre estado de código são frequentemente erradas, especialmente em projetos com convenções não-óbvias ou decisões arquiteturais que violam padrões comuns.

### CONSTRAINTS: os trilhos

Constraints negativas ("o que não deve mudar") são tão importantes quanto o GOAL positivo. Um agente sem constraints tende a "limpar" código que encontra no caminho, refatorar coisas que não estava pedido para tocar, e mudar convenções que existiam por razões que ele não conhece. Constraints explícitas transformam scope creep em erro detectável.

### PLAN: pense antes de agir

A instrução "entenda primeiro, depois aja" mapeia diretamente para o princípio 1 de Karpathy. O refinamento crucial é "reafirme o entendimento antes de executar mudanças não triviais" — o agente parafraseia o que vai fazer antes de fazer, o que cria uma oportunidade de intervenção humana se o entendimento estiver errado.

### DONE WHEN: o critério de conclusão

Sem DONE WHEN, o agente decide quando está "pronto" — e essa decisão frequentemente é prematura (testes passaram, parece funcionar) ou excessiva (continuou melhorando além do solicitado). Um estado de conclusão verificável e explícito fecha o loop: o agente sabe exatamente quando parar.

### VERIFY: diferente de DONE WHEN

DONE WHEN define o estado de conclusão. VERIFY define como confirmar que esse estado foi atingido — e crucialmente, pede que o agente declare o que não pôde verificar. Isso é honestidade estruturada: em vez de o agente fingir confiança, ele deve declarar suas limitações de verificação explicitamente.

### STOP RULES: circuit breakers

As stop rules são o componente mais importante para evitar dano. "Pare em ambiguidades" e "não expanda escopo após objetivo satisfeito" são as duas falhas mais comuns de agentes sem guardrails. Um agente que encontra ambiguidade e continua tomando decisões unilaterais frequentemente resolve o problema errado de forma irreversível.

## Comparação com prompts sem estrutura

Um prompt sem estrutura tipicamente tem:
- Goal implícito (inferido do pedido)
- Contexto ausente (agente infere do código)
- Constraints ausentes (agente decide o que pode tocar)
- Sem critério de conclusão (agente decide quando parar)
- Sem verificação estruturada

Resultado: comportamento altamente variável, onde o sucesso depende da qualidade da inferência do agente em múltiplas dimensões simultaneamente.

Com a estrutura /goal, cada dimensão é explícita. O agente não infere — executa. A variabilidade cai drasticamente porque o espaço de interpretação é muito menor.

## Aplicação prática: exemplo real

```
GOAL:
Adicionar validação de email no endpoint POST /users/register retornando 422 com mensagem em português se email inválido

CONTEXT:
FastAPI app em /src/api/. Validação existente usa Pydantic v2. Padrão de erro: {"detail": "mensagem", "code": "VALIDATION_ERROR"}. Endpoint atual em /src/api/users.py linha 45.

CONSTRAINTS:
Não modificar UserModel existente. Não mudar outros endpoints. Não adicionar dependências novas — usar apenas validação Pydantic.

DONE WHEN:
POST /users/register com email inválido retorna 422 com corpo {"detail": "Email inválido", "code": "VALIDATION_ERROR"}. Email válido continua passando.

VERIFY:
pytest tests/test_users.py -k "test_register" deve passar. Testar manualmente com curl ambos os casos.

STOP RULES:
Se UserModel precisar de mudança estrutural para implementar isso, pare e sinalize.
```

## Relação com o vault-michel

O padrão /goal pode ser aplicado a tasks do vault: ingest de fonte, auditoria de wikilinks, consolidação de notas. A estrutura é igualmente válida para agentes de conhecimento — substitui "repositório/arquivos" por "vault/notas" e "tests/build" por "wikilinks válidos/hot.md atualizado".

## Conexões

- [[03-RESOURCES/concepts/claude-code-tooling/goal-prompt-structure]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/entities/Claude Code]]
