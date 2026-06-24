---
title: "Multi-Agent Architectures, Clearly Explained"
type: source
source_type: article
author: "Neo Kim"
created: 2026-05-06
tags: [multi-agent, architecture, orchestration, ai-agents]
triagem_score: 8
---

6 multi-agent architectures: orchestrator-worker, pipeline, hierarchical, swarm, mesh, handoffs. Real examples: Anthropic Claude Research (90.2% improvement), Stripe DAG pipeline (26% time reduction), IBM watsonx Orchestrate, Spotify (15min to 5sec).

## Source

Ingested from: `clippings/Multi-Agent Architectures, Clearly Explained.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## As 6 Arquiteturas em Detalhe

### 1. Orchestrator-Worker

Um agente central (orchestrator) decompõe o task e delega subtasks para workers especializados. O orchestrator mantém o plano, monitora progresso e agrega resultados. Workers não se comunicam entre si — toda coordenação passa pelo orchestrator.

**Vantagens:** Controle centralizado, fácil de debugar, comportamento previsível.
**Desvantagens:** Gargalo no orchestrator, ponto único de falha.
**Exemplo:** Anthropic Claude Research — orchestrator planeja pesquisa, workers executam buscas paralelas. Resultado: 90.2% de melhoria vs. single-agent.

### 2. Pipeline (DAG)

Agentes organizados em grafo acíclico dirigido. Saída de um agente é entrada do próximo. Etapas podem ser paralelas (branches no DAG) ou sequenciais. Sem estado compartilhado — cada agente recebe exatamente o que precisa do anterior.

**Vantagens:** Composabilidade, paralelismo natural, cada stage testável isoladamente.
**Desvantagens:** Erro numa etapa pode propagar sem recuperação; rigidez estrutural.
**Exemplo:** Stripe fraud detection — DAG com 26% de redução no tempo de processamento de transações suspeitas.

### 3. Hierarchical (Hierárquico)

Múltiplos níveis de orchestrators. Um orchestrator de nível 1 delega para orchestrators de nível 2, que por sua vez delegam para workers. Permite escalar coordenação para tasks muito complexas sem sobrecarregar um único orchestrator.

**Vantagens:** Escala bem, permite especialização por domínio em cada nível.
**Desvantagens:** Latência acumula em cada nível; difícil de debugar.
**Exemplo:** IBM watsonx Orchestrate — hierarquia de agentes para automação de RH empresarial.

### 4. Swarm (Enxame)

Agentes homogêneos operando em paralelo sem coordenação central. Cada agente tem as mesmas capacidades e atua sobre diferentes partições do problema. Resultados são agregados por votação, media, ou outro mecanismo de consenso.

**Vantagens:** Extremamente paralelo, resiliente a falhas individuais, simples de escalar.
**Desvantagens:** Sem divisão de trabalho por especialidade; difícil coordenar tasks com dependências.
**Aplicação:** Avaliação de modelos (múltiplos juízes), geração de diversidade de soluções.

### 5. Mesh (Malha)

Agentes peer-to-peer que se comunicam diretamente entre si conforme necessário. Não há orchestrator fixo — qualquer agente pode iniciar comunicação com qualquer outro. Topologia mais próxima de um time humano real.

**Vantagens:** Flexibilidade máxima, sem gargalo central, suporta workflows emergentes.
**Desvantagens:** Muito difícil de debugar, risco de loops, coordenação implícita opaca.
**Estado da arte:** Ainda experimental em produção; usado em pesquisa de multi-agent systems.

### 6. Handoff Pattern

Um agente completa sua parte e passa o contexto explicitamente para o próximo. Diferente de pipeline (que é predefinido), handoff permite escolha dinâmica do próximo agente com base no estado. O handoff document é o contrato entre agentes.

**Vantagens:** Contexto rico preservado entre agentes, escolha dinâmica de successor.
**Desvantagens:** Handoff document pode ficar grande; overhead de serialização.
**Exemplo:** Vault-michel /handoff skill — compacta conversação em documento para próxima sessão.

---

## Métricas Reais de Produção

| Empresa | Arquitetura | Resultado |
|---|---|---|
| Anthropic | Orchestrator-Worker | +90.2% em research tasks |
| Stripe | DAG Pipeline | -26% tempo de processamento |
| IBM watsonx | Hierarchical | Automação RH enterprise |
| Spotify | Pipeline | 15min → 5sec em recomendações |

---

## Critérios de Escolha de Arquitetura

**Use orchestrator-worker quando:** Task tem estrutura clara de plano-execução, workers são especializados, você precisa de controle.

**Use pipeline quando:** Workflow é predefinido, etapas têm dependências lineares/DAG, volume é alto e latência importa.

**Use hierárquico quando:** Scale requer múltiplos níveis de delegação, domínios são bem separados.

**Use swarm quando:** Task é paralelizável e homogênea, você precisa de diversidade de perspectivas.

**Use mesh quando:** Task é genuinamente emergente e você aceita menor observabilidade.

**Use handoff quando:** Contexto é rico e precisa ser preservado, agentes mudam ao longo da execução.

---

## Falhas Comuns de Coordenação

A pesquisa sobre multi-agent systems em produção (ver [[03-RESOURCES/sources/ai-agents-harness/coordination-as-an-architectural-layer-for-llm-based-multi-agent-systems-an]]) mostra falhas entre 41% e 87% — a maioria por problemas de coordenação, não por capacidade do modelo base. Causas principais: estado compartilhado inconsistente, ausência de protocolos de handoff formais, e falta de observabilidade entre agentes.

---

## Links

- [[03-RESOURCES/concepts/multi-agent-systems]]
- [[03-RESOURCES/concepts/agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/sources/ai-agents-harness/coordination-as-an-architectural-layer-for-llm-based-multi-agent-systems-an]]
- [[03-RESOURCES/sources/claude-code-skills/skill-handoff]]

---

## Análise Arquitetural Comparativa

### Por Que a Taxonomia de 6 Arquiteturas é Útil

A maioria das implementações de multi-agent systems usa um dos 6 padrões ou uma combinação deles, mesmo quando não os nomeia formalmente. Ter a taxonomia permite:

1. **Diagnóstico de problemas:** "Nosso sistema de review de código tem gargalo" → provavelmente é orchestrator-worker com orchestrator sobrecarregado; considere dividir em hierárquico.
2. **Comunicação entre equipes:** "Mudamos de pipeline para orchestrator-worker" comunica claramente a mudança arquitetural sem descrever a implementação específica.
3. **Predição de trade-offs:** conhecendo a arquitetura, os trade-offs esperados (latência, observabilidade, resilência) são previsíveis antes de observá-los em produção.

### Por Que o Handoff Pattern é Frequentemente Subutilizado

O Handoff é muitas vezes implementado informalmente — o contexto é "passado" de forma implícita, frequentemente pela concatenação do chat completo para o próximo agente. Isso tem dois problemas:

**Problema 1 — Volume:** Concatenar toda a conversa anterior cria contextos massivos. O segundo agente recebe 50k tokens de histórico quando 2k de handoff estruturado seriam suficientes.

**Problema 2 — Sinal/ruído:** Conversas têm muita tentativa-e-erro, digressões, e raciocínio intermediário que é valioso para o agente que o fez, mas ruído para o próximo agente. Um handoff document estruturado extrai apenas o que o próximo agente precisa saber.

O `/handoff` skill do vault-michel implementa o Handoff Pattern corretamente: compacta a sessão em um documento com seções específicas (o que foi feito, o que está pendente, decisões importantes, contexto necessário para continuar).

### Trade-offs Nuançados da Arquitetura Swarm

O Swarm é apresentado como "resiliente" porque falhas individuais não derrubam o sistema. Mas há um tipo de falha que o Swarm amplia em vez de resistir: **falha correlacionada**.

Se todos os K agentes do swarm usam o mesmo modelo e são expostos ao mesmo viés sistemático, uma falha correlacionada ocorre: todos erram na mesma direção, a agregação por votação retorna o erro com alta confiança, e o sistema exibe comportamento incorreto com a aparência de alta certeza.

Mitigação: usar múltiplos modelos no swarm (ensemble heterogêneo), ou usar modelos com diferentes temperatures/configurações de amostragem, para introduzir diversidade real além da randomicidade de amostragem.

### A Relação entre Arquitetura e Custo

Os dados reais de produção da tabela (Anthropic +90.2%, Stripe -26%, Spotify 15min→5sec) não especificam o custo em tokens — apenas os benefícios. Na prática, o custo varia dramaticamente por arquitetura:

| Arquitetura | Overhead de coordenação | Paralelismo | Custo relativo |
|-------------|------------------------|-------------|----------------|
| Orchestrator-Worker | Médio (orchestrator lê todos os outputs) | Alto | Médio |
| Pipeline (DAG) | Baixo (sem coordenação central) | Médio-alto (branches paralelos) | Baixo |
| Hierárquico | Alto (múltiplos orchestrators) | Alto | Alto |
| Swarm | Baixo (K chamadas independentes) | Máximo | Alto (K × custo) |
| Mesh | Alto (comunicação peer-to-peer) | Alto | Muito alto |
| Handoff | Baixo (um agente por vez) | Zero (sequencial) | Baixo |

O Handoff Pattern tem o menor custo porque é fundamentalmente sequencial — mas isso também o torna o mais lento em latência total.

### Debugging em Multi-Agent Systems: O Problema Real

A observabilidade é frequentemente apresentada como "difícil em mesh, fácil em orchestrator-worker." Mas o verdadeiro desafio em qualquer arquitetura multi-agent é rastrear a cadeia causal quando algo dá errado:

- O orchestrator recebeu o output certo do worker?
- O worker recebeu o context certo do orchestrator?
- A falha foi na geração do output ou na interpretação do input?
- Se múltiplos workers produziram outputs diferentes, qual critério de seleção foi usado?

Sem logging estruturado de cada call (input completo, output completo, timestamp, session ID), análise post-mortem em qualquer arquitetura multi-agent é especulação. A tooling de observabilidade (LangSmith, Weave, AgentOps) existe exatamente para isso, mas adiciona custo de infraestrutura e latência.

### Implicação para o Vault-Michel

O vault-michel usa uma versão simplificada de Orchestrator-Worker: o Nexus como orchestrator central que delega para agentes especializados. Para sessões longas de pesquisa multi-fonte, o Pipeline (DAG) seria mais eficiente — paralelize a ingestão de múltiplas fontes em branches, agregue os resultados em síntese final. O skill `michel-skills:batch-ingest` implementa exatamente isso.
