---
title: "Managing Context in Long-Run Agentic Applications"
type: source
source: "Clippings/Managing context in long-run agentic applications.md"
url: "https://slack.engineering/managing-context-in-long-run-agentic-applications/"
author: "Dominic Marks (Staff Software Engineer, Slack)"
published: 2026-03
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, context-management, long-horizon, slack, security-agents, multi-agent, director-expert-critic]
---

# Managing Context in Long-Run Agentic Applications

Segundo artigo da série de Slack Engineering sobre agentes de investigação de segurança. Foco: manter alinhamento e coerência de raciocínio em sistemas agenticos de longa duração.

Escala operacional reportada: **7.500+ investigações** concluídas, **500K+ tool calls** processadas.

## Tese central

Em sistemas multi-agentes de longa duração, a janela de contexto não é gerenciada por compressão/sumarização genérica — é gerenciada por **canais de contexto especializados** que fornecem a cada agente exatamente a visão do estado da investigação que ele precisa. Passar histórico completo entre rodadas prejudica a criatividade e induz confirmation bias; não passar nada quebra a coerência. A solução é a meio-termo estruturado.

## Arquitetura: Director-Expert-Critic

Três papéis, três visões do estado:

| Agente | Responsabilidade | Canal de contexto |
|--------|-----------------|------------------|
| **Director** | Orquestra a investigação; decide perguntas, Experts, conclusão | Journal (memória de trabalho estruturada) |
| **Expert** | Especialista de domínio; coleta evidências via ferramentas | Journal (recebe) + findings (produz) |
| **Critic** | Avalia findings dos Experts; pontua credibilidade | Review (ferramentas de inspeção) + Timeline (produz) |

Investigações rodam em **fases** → **rounds**. Sem limite pré-definido de rounds; Director decide quando concluir.

## Três canais de contexto complementares

### 1. Director's Journal

Memória de trabalho estruturada do Director. Seis tipos de entrada:

| Tipo | Propósito |
|------|-----------|
| `decision` | Escolhas estratégicas |
| `observation` | Padrões notados |
| `finding` | Fatos confirmados |
| `question` | Itens abertos |
| `action` | Passos tomados/planejados |
| `hypothesis` | Teorias de trabalho |

Cada entrada é anotada com fase, número do round e timestamp. **Todo agente recebe o Journal em seu prompt** — é a narrativa comum que mantém todos alinhados.

### 2. Critic's Review

O Critic recebe um relatório-sumário e usa quatro ferramentas para inspecionar evidências:

| Ferramenta | Propósito |
|-----------|-----------|
| `get_tool_call` | Inspeciona argumentos e metadados de qualquer tool call |
| `get_tool_result` | Examina o output retornado por um tool use |
| `get_toolset_info` | Lista as ferramentas disponíveis para um Expert específico |
| `list_toolsets` | Lista todos os toolsets por Expert |

Output: relatório anotado com **credibility scores** por finding.

**Rubric de credibilidade (5 níveis):**

| Score | Label | Critério |
|-------|-------|---------|
| 0.9–1.0 | Trustworthy | Múltiplas fontes, sem indicadores contraditórios |
| 0.7–0.89 | Highly-plausible | Corroborado por fonte única |
| 0.5–0.69 | Plausible | Suporte misto |
| 0.3–0.49 | Speculative | Suporte fraco |
| 0.0–0.29 | Misguided | Sem evidência ou evidência mal interpretada |

**Distribuição empírica** sobre 170.000 findings revisados: Trustworthy 37,7% · Highly-plausible 25,4% · Plausible 11,1% · Speculative 10,4% · Misguided 15,4%.
Conclusão: ~26% dos findings não atingem o limiar de plausibilidade — sem Critic, esses dados contaminam a investigação.

**Mitigações contra hallucination do próprio Critic:**
1. Modelo mais forte para o Critic (menos tokens necessários → viável)
2. Instrução restrita: Critic só julga findings submetidos, nunca questões abertas
3. O Timeline task (ver abaixo) como terceira camada de verificação

### 3. Critic's Timeline

Tarefa separada que segue imediatamente o Review. Constrói a cronologia mais plausível a partir de três fontes: Review mais recente + Timeline anterior + Journal do Director.

Opera **inteiramente no prompt** (sem tool calls) — escopo estreito libera capacidade de raciocínio.

**Regras de consolidação:**
1. Incluir apenas eventos com citações críveis
2. Remover duplicatas de eventos mencionados por múltiplos Experts
3. Em conflito de timestamps, preferir fontes com evidência mais forte
4. Manter ordenação cronológica

**Gap identification:** Top 3 lacunas significativas reportadas (evidencial, temporal, lógica).

**Score de narrativa:** mesma escala de 5 níveis; confidence score 0.83 no exemplo real.

**Por que o Timeline reduz hallucinations:** um finding inventado só sobrevive se for *mais coerente* com o corpo de evidências do que qualquer observação real que ele compete — barreira alta.

## Gestão de Message History

Decisão de design central: **zero message history entre invocações de agentes.**

Os três canais (Journal + Review + Timeline) funcionam como sumarização de contexto *online*, eliminando a necessidade de histórico acumulado. Mesmo com janela infinita, passar o histórico bruto seria indesejável: contexto acumulado impediria resposta adequada a novas informações.

## Argumentos principais

1. **Contexto como problema de design, não de tamanho**: investigações complexas geram megabytes de output — o desafio não é "janela maior" mas "o que entra na janela de cada agente".
2. **Informação demais é tão ruim quanto informação de menos**: compartilhar todo o contexto com todos os agentes gera confirmation bias e inibe descobertas independentes.
3. **Escalabilidade comprovada por dados**: o mesmo design funciona para investigações triviais (10 minutos) e complexas (múltiplos rounds, centenas de inference requests).
4. **Modelo mais forte é justificável para o Critic**: como o Critic recebe sumário em vez de run completo, o custo adicional é controlável.

## Key insights

- O **Journal como shared working memory** resolve o problema de coerência sem expor tudo a todos — o Director escreve, todos leem.
- **Credibility scoring** transforma o output do Critic de texto em dado estruturado — permite filtrar o Timeline e criar audit trails automáticos.
- **Timeline como anti-hallucination layer**: narrativa coerente como critério de sobrevivência de findings — mais robusto que revisão item a item.
- **Zero message history** entre rounds é contra-intuitivo mas correto: repassar histórico aumenta custo, latência e degrada qualidade sem benefício de coerência (o Journal já provê continuidade).
- **Tarefa estreita = mais capacidade de raciocínio**: o Timeline task, por não usar tools, consegue raciocinar melhor sobre o conteúdo.

## Exemplos e evidências

Investigação specimen (false positive — kernel module): alert em 09:29Z, investigação concluída com confidence 0.83, 6 Experts consultados, 6.046 eventos analisados, ~12 minutos end-to-end. O Director identificou corretamente false positive em múltiplos rounds com correções de curso documentadas no Journal.

## Implicações para o vault

- **Padrão Director-Expert-Critic** é instância concreta do [[03-RESOURCES/concepts/agent-systems/orchestration-mode-pattern]] — o Director age como o "Orchestrator" do padrão.
- **Journal como shared memory** conecta a [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] e [[03-RESOURCES/concepts/agent-systems/agent-shared-memory]].
- **Credibility scoring** é técnica aplicável ao vault: avaliar findings de subagentes com rubric estruturado antes de promovê-los ao hot.md ou manifest.
- **Zero message history design** vai contra o padrão AdaCoM (que gerencia o histórico) — tensão conceitual com [[03-RESOURCES/concepts/agent-systems/context-management]].
- **Gap identification (top 3)** é princípio de foco que pode ser aplicado aos subagentes do pipeline-diario.

## Links

- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/agent-systems/orchestration-mode-pattern]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-shared-memory]]
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
