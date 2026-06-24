---
title: "Resolvers: The Routing Table for Intelligence"
type: source
source_file: .raw/articles/Resolvers The Routing Table for Intelligence.md
author: Garry Tan (@garrytan)
ingested: 2026-04-17
tags: [resolvers, agent-governance, routing, context-rot, gbrain, gstack]
triagem_score: 9
---

# Resolvers: The Routing Table for Intelligence

> [!summary]
> Garry Tan explica como resolvers (tabelas de roteamento de contexto) são a camada de governança invisível de sistemas agênticos. Sem eles, skills inventam lógica própria de filing e o sistema vira uma gaveta de lixo. Com eles, 200 linhas substituem 20.000 linhas de contexto.

## O Problema: 20.000 linhas de confissão

CLAUDE.md cresceu para 20k linhas. Resultado: atenção degradada, respostas lentas e imprecisas, mais alucinações. O próprio Claude pediu para cortar.

**A fix foi um arquivo de 200 linhas**: árvore de decisão numerada + ponteiros para documentos. Quando o modelo precisa arquivar algo, percorre a árvore.

## O que é um Resolver

Um resolver é uma tabela de roteamento para contexto. Quando o tipo de tarefa X aparece, carregue o documento Y primeiro.

**Resolvers são fractais** — existem em toda camada do sistema:
- **Skill resolver** (AGENTS.md): tipo de tarefa → arquivo de skill
- **Filing resolver** (RESOLVER.md): tipo de conteúdo → diretório
- **Context resolver** (dentro de cada skill): sub-roteamento interno

## O Problema Invisível: Skills não Registradas

Audit de 13 skills: apenas 3 referenciavam o resolver. 10 tinham paths hardcoded.

Depois de 40+ skills: 6 eram completamente inalcançáveis (15% das capacidades no escuro).

**Fix:** `check-resolvable` — meta-skill que percorre toda a cadeia e encontra dead links. Roda semanalmente.

## Context Rot

- Dia 1: resolver perfeito
- Dia 30: 3 novas skills sem registro
- Dia 60: trigger descriptions obsoletas
- Dia 90: o resolver é um documento histórico

**Solução emergente**: RLM (reinforcement learning) que observa cada dispatch de tarefa e reescreve triggers baseado em evidências observadas. AutoDream do Claude Code é uma versão primitiva disso.

## Resolvers como Gestão

Skills = funcionários. Resolver = organograma. Filing rules = processo interno. check-resolvable = auditoria de compliance. Trigger evals = avaliações de desempenho.

> [!insight]
> O problema não é que modelos não são inteligentes o suficiente. O problema é que construímos organizações sem camada de gestão. Apenas uma pilha de funcionários talentosos e a esperança de que vão se coordenar.

## Projetos Open-Source

- **GBrain** — sistema de memória pessoal; ships com resolver pattern built-in (`gbrain init`)
- **GStack** — 72.000+ stars; fat skills em markdown; layer de coding
- **OpenClaw / Hermes Agent** — harness fino; condutor do agent loop

## Conceitos Relacionados

- [[resolver-pattern]]
- [[claude-agent-harness-architecture]]
- [[claude-skills]]
- [[context-engineering]]

## Entidades Mencionadas

- [[Garry-Tan]] — autor (@garrytan); YC partner; criador do GBrain/GStack
- [[GBrain]] — sistema de memória pessoal open-source
- [[GStack]] — 72k+ stars; fat skills em markdown
- [[OpenClaw]] — harness agent de Garry Tan

## O Problema de 20.000 Linhas — Como Chegou Lá e O Que Ensina

A história de um CLAUDE.md crescendo para 20.000 linhas não é um caso extremo — é o resultado natural de um sistema sem uma teoria de quando adicionar contexto vs. quando estruturá-lo externamente.

O mecanismo: cada vez que o agente comete um erro ou produz output inconsistente, a resposta instintiva é adicionar mais contexto ao CLAUDE.md. "Da próxima vez, lembre-se de X." A adição individual faz sentido. Após 6 meses de adições individuais, o documento tem 20.000 linhas.

O problema: atenção degradada com contexto longo. O agente não "lê" o CLAUDE.md como um humano — ele processa todos os tokens com atenção distribuída. Com 20.000 tokens de CLAUDE.md e 10.000 tokens de prompt de tarefa, as instruções do CLAUDE.md recebem ~67% da atenção disponível em vez de 100%. Instruções específicas ficam diluídas em um mar de contexto.

**A solução de 200 linhas como árvore de decisão:** em vez de especificar cada regra, o resolver especifica o caminho para encontrar a regra certa. O agente aprende "quando o tipo de tarefa é X, leia o arquivo Y primeiro". O contexto rico fica nos arquivos Y — carregados apenas quando X ocorre.

## Resolvers Como Fractais — Os Três Níveis

A propriedade fractal dos resolvers significa que o mesmo padrão ocorre em escalas diferentes do sistema:

**Nível 1 — Skill resolver (AGENTS.md):**
```
Tipo de tarefa → arquivo de skill específico
"análise de contrato" → skill/legal-review.md
"debugging Python" → skill/python-debug.md
"escrita técnica" → skill/tech-writing.md
```

**Nível 2 — Filing resolver (RESOLVER.md):**
```
Tipo de conteúdo → diretório de destino
"novo conceito abstraído" → 03-RESOURCES/concepts/
"nova entidade identificada" → 03-RESOURCES/entities/
"artigo processado" → 03-RESOURCES/sources/
"output gerado" → 06-GENERATED/
```

**Nível 3 — Context resolver (dentro de cada skill):**
```
Sub-tipo de tarefa → seção da skill ou arquivo de referência
"contrato de SaaS" → references/saas-contracts.md
"contrato de emprego" → references/employment-law.md
```

Para vault-michel: o AGENTS.md atual funciona como um nível 1 resolver. O `04-SYSTEM/wiki/hot.md` serve como filing guidance informal. Um RESOLVER.md formal que especifique explicitamente onde cada tipo de artefato vai seria o nível 2 missing.

## O Problema de Skills Não Registradas — Um Sistema Que Perde Capacidade

O audit de 13 skills com apenas 3 registradas no resolver revela um problema de degradação silenciosa: o sistema perde capacidades sem nenhum sinal de alerta.

Do ponto de vista do usuário, uma skill não registrada é simplesmente uma capability inexistente — o agente nunca vai oferecê-la porque nunca vai encontrá-la. Do ponto de vista do sistema, é desperdício: o trabalho de criar a skill foi feito, mas o benefício é zero.

**Por que paths hardcoded causam o problema:** quando um desenvolvedor cria uma skill e precisa testá-la, a solução rápida é colocar o path absoluto diretamente na skill que vai chamá-la. Funciona no momento. Mas quando o resolver é consultado depois, ele não sabe que essa skill existe — nunca foi registrada.

O `check-resolvable` meta-skill resolve isso sistematicamente: percorre todas as skills do sistema e verifica se cada uma tem uma entrada no resolver que aponta para ela. Skills não encontradas são "dead links" — reportadas para registro ou remoção.

## Context Rot — O Ciclo de Vida do Resolver

O ciclo de context rot descrito (perfeito no dia 1 → degradado no dia 90) é inevitável sem manutenção ativa. Cada nova skill adicionada sem registro no resolver aumenta a porcentagem de capacidade inacessível. Cada trigger description obsoleta (porque o domínio mudou, ou a terminologia mudou) reduz a taxa de matching correto.

A solução de RLM (reinforcement learning based on observed dispatches) descrita no artigo é a abordagem mais ambiciosa: o sistema observa quando o agente é chamado para uma tarefa, registra qual skill foi ativada, e ajusta os triggers com base em resultados reais. Se a skill de "análise de contrato" é frequentemente ativada para tarefas de "revisão de SLA", o trigger da skill é atualizado para incluir "SLA".

O AutoDream do Claude Code mencionado como "versão primitiva disso" é o início de uma direção onde resolvers se auto-mantêm baseados em evidências operacionais — não dependem de manutenção manual.

## Gestão de Skills Como Gestão de Equipe

A analogia de Garry Tan (skills = funcionários, resolver = organograma) tem implicações práticas que vão além da metáfora:

**Skills sem resolver entry = funcionários não no organograma:** eles trabalham, mas ninguém sabe como contatá-los para tasks que precisam de sua expertise.

**Trigger descriptions obsoletas = job descriptions que não correspondem ao trabalho atual:** o funcionário foi contratado para "análise de dados" mas agora faz "machine learning" — chamar o resolver por "análise de dados" não vai encontrá-lo para as tasks de ML que ele realmente faz.

**check-resolvable = auditoria de RH:** verifica que todos os funcionários têm entradas válidas no sistema, que os job descriptions correspondem ao trabalho real, e que não há funcionários que ninguém contata há meses (candidatos para desligamento).

**Trigger evals = avaliações de desempenho:** testa se a skill, quando ativada via seu trigger, produz o output esperado. Uma skill que passou no trigger eval há 3 meses pode ter degradado se o ambiente mudou.

## Aplicação Direta para vault-michel

O AGENTS.md do vault serve como resolver de nível 1, mas sem o `check-resolvable` meta-skill. Ação concreta derivada deste artigo:

1. Criar um script (ou skill) que percorre `04-SYSTEM/agents/*.md` e verifica que cada agente tem uma entrada correspondente no AGENTS.md
2. Verificar que cada entrada no AGENTS.md aponta para um arquivo de agente existente
3. Identificar agentes criados mas nunca mencionados no AGENTS.md (dead capabilities)
4. Identificar entradas no AGENTS.md que apontam para arquivos deletados ou renomeados (dead links)

Este processo de auditoria, rodado mensalmente, previne o decay de 15% de capacidades inacessíveis observado por Garry Tan.
