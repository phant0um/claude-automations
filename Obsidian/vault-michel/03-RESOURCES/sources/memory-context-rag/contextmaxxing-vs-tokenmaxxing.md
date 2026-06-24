---
title: "Contextmaxxing > Tokenmaxxing: Why Better Memory Beats Burning More Tokens"
type: source
source_file: Clippings/Contextmaxxing > Tokenmaxxing Why Better Memory Beats Burning More Tokens.md
origin: post no X (@ashwingop)
author: "@ashwingop / Ashwin Gopinath"
published: 2026-05-10
ingested: 2026-05-14
tags: [context-engineering, token-efficiency, memory, agents, enterprise-ai, sentra]
triagem_score: 8
---

# Contextmaxxing vs Tokenmaxxing

Artigo de [[03-RESOURCES/entities/Ashwin-Gopinath]] (co-fundador da Sentra AI) argumentando que a próxima fase de AI enterprise não é consumir mais tokens — é garantir que cada token seja apontado para o contexto certo.

## Definições

- **Tokenmaxxing**: maximizar atividade de AI, consumindo o máximo de tokens possível com agentes autônomos. Primeiro reflexo racional diante de AI útil.
- **Contextmaxxing**: maximizar contexto relevante por ação de AI, antes de agir. A pergunta não é "quanto AI?", mas "qual é o contexto certo?"

> [!key-insight] Insight Central
> "O modelo não fica mais inteligente em loops de reconstrução de contexto. Ele paga repetidamente para reconstruir o estado ausente."

## O Problema do Uber (2026)

CTO do Uber afirmou que a empresa esgotou o orçamento de AI meses antes do previsto em 2026 por uso excessivo de Claude Code. Gopinath lê como "early glimpse of the next enterprise cost curve", não como falha pontual.

## Por que Tokenmaxxing Não é Burrice

Tokenmaxxing é o primeiro reflexo racional: se AI é útil, use mais. Airbnb: agente de suporte resolve 40% dos casos sem escalação humana. O problema não é usar AI — é gastar tokens **reconstruindo contexto que a empresa já tem**.

## Bom Burn vs Mal Burn

| Bom | Ruim |
|-----|------|
| Reasoning, escrita, testes, verificação | Reconstruir por que uma migração existe |
| Julgamento sobre o estado atual | Buscar constraints de clientes em tickets velhos |
| Execução com contexto rico | Reler transcripts que outro agente leu ontem |

## Memory como Infraestrutura Econômica

Sem memória: cada agente começa do zero, paga para "conhecer a empresa" antes de trabalhar.

Com memória: agente começa do **estado**. Tokens vão para julgamento, execução, verificação.

Gopinath menciona Karpathy's LLM Wiki, GBrain do Garry Tan, e Obsidian como aproximações individuais do problema. O desafio enterprise: a memória tem que ser **compartilhada, permissionada, atualizada em tempo real, e segura para agents lerem e escreverem**.

## Resultado Prático (Sentra)

Redução de 50-98% em context-tokens para tarefas equivalentes. Em alguns casos, contexto relevante = centenas de tokens ao invés de dezenas de milhares.

## Nova Métrica Proposta

Não "tokens gastos" — e sim:
- **Contexto útil por token**
- **Outcome verificado / trabalho por token**

## Conexões

- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — disciplina base
- [[03-RESOURCES/entities/Ashwin-Gopinath]] — autor
- [[03-RESOURCES/entities/Sentra-AI]] — empresa do autor
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — memory systems
- [[03-RESOURCES/sources/token-economy-cost/hook-fights-34-percent-token-waste]] — tokenmaxxing failure mode

## O Mecanismo Econômico do Tokenmaxxing

O tokenmaxxing tem uma lógica econômica clara e racional: se AI é útil e o custo marginal de uma interação é baixo, maximize o número de interações. A curva de custo inicial de AI parece linear — dobrar o uso dobra o custo. A curva real é diferente.

O problema emerge quando os agentes precisam "conhecer a empresa" antes de trabalhar. Em um sistema sem memória compartilhada:
- Cada sessão começa do zero: o agente não sabe que a migração do banco de dados existe, que o cliente X tem restrições especiais, ou que a abordagem Y foi tentada e falhou no mês passado
- Para trabalhar com qualidade, o agente precisa reconstituir esse contexto: lê tickets velhos, busca documentação, processa transcripts de sessões anteriores
- Esse trabalho de contextualization consome tokens sem produzir output de negócio

O resultado é a curva de custo não-linear do Uber: o gasto com AI escalou exponencialmente porque cada novo agente adicionado ao sistema precisava reconstruir o mesmo contexto que os agentes anteriores já haviam processado — e esse contexto não estava em lugar nenhum acessível.

## Bom Burn vs Mal Burn — Distinção Técnica

A distinção entre "bom burn" e "mal burn" é mais precisa do que parece à primeira vista. O critério técnico:

**Bom burn:** tokens gastos em operações que produzem output diferente dependendo dos tokens. Raciocinar sobre um problema que não tem solução pré-existente, escrever conteúdo novo, verificar corretude de implementação específica. O output não existiria sem esses tokens.

**Mal burn:** tokens gastos em operações cujo resultado é predeterminado pelo contexto que a empresa já tem armazenado em algum lugar. "Por que essa migração existe?" tem uma resposta no ticket do Jira de março. "Quais são as constraints do cliente X?" está no CRM. "O agente de ontem leu esse transcript?" — sim, mas o agente de hoje também vai ler, pagando duas vezes pela mesma operação.

O mal burn é fundamentalmente um problema de acesso à memória, não de inteligência. O agente poderia responder instantaneamente se a informação estivesse acessível — ele paga para reconstruí-la porque não está.

## Por Que a Solução Enterprise é Difícil

Gopinath identifica o problema pessoal (Karpathy's LLM Wiki, GBrain, Obsidian) como mais fácil de resolver que o problema enterprise. A diferença estrutural:

**Solução pessoal:** uma pessoa, um sistema de memória, controle total sobre o que entra e sai. Consistência garantida porque há um único autor.

**Solução enterprise:** múltiplos agentes, múltiplas equipes, diferentes níveis de permissão, dados que mudam em tempo real, compliance e auditoria. A memória precisa ser:
- **Compartilhada:** o agente de vendas e o agente de suporte precisam do mesmo contexto de cliente
- **Permissionada:** o agente de contabilidade não deveria ter acesso aos dados de HR
- **Atualizada em tempo real:** uma decisão tomada às 14h afeta os agentes que rodam às 15h
- **Segura para agents lerem e escreverem:** sem corrupção, sem race conditions, com auditoria

Este conjunto de requisitos não é resolvido por um arquivo `.md` bem estruturado — requer infraestrutura de memória distribuída com controle de acesso. É o problema que a Sentra AI afirma resolver.

## Os Números de Sentra — 50-98% de Redução

A afirmação de redução de 50-98% em context-tokens para tarefas equivalentes é extraordinária. O intervalo amplo (50-98%) é explicado pela variação entre casos de uso:

- **Tarefas de domínio público (50% de redução):** o contexto é amplamente disponível em dados de treinamento. A memória adiciona pouco porque o modelo já "sabe" o contexto.
- **Tarefas de domínio privado (98% de redução):** o contexto é único para a empresa — convenções internas, histórico de decisões, configurações específicas de sistemas. Sem memória, o agente reconstrói esse contexto from scratch gastando dezenas de milhares de tokens. Com memória, o contexto relevante cabe em centenas de tokens.

A variação reflete a proporção de contexto privado vs. público na tarefa. Enterprise AI é dominantemente contexto privado — que é exatamente onde a memória estruturada tem maior impacto.

## Nova Métrica — Por Que "Tokens Gastos" É a Métrica Errada

A proposta de substituir "tokens gastos" por "contexto útil por token" e "outcome verificado / trabalho por token" resolve uma perversidade da métrica atual: otimizar para "menos tokens" penaliza o bom uso (tokens gastos em raciocínio que produz valor real) tanto quanto o mal uso (tokens gastos em reconstrução de contexto).

As novas métricas:
- **Contexto útil por token:** fração dos tokens injetados no contexto que são referenciados pelo raciocínio do modelo. Tokens de contexto que o modelo nunca usa = puro desperdício.
- **Outcome verificado / trabalho por token:** tokens gastos por unidade de output verificado (tarefa completa, query respondida, documento produzido). Esta métrica penaliza loops de reconstrução de contexto que não produzem output verificável.

Para vault-michel: a métrica relevante não é "quantos tokens foram usados na sessão de ingestão" mas "quantas páginas verificadas foram criadas ou atualizadas por token consumido". Sessões com context rot alto (reconstruindo estado que já estava no vault) têm baixa eficiência mesmo com baixo consumo total.
