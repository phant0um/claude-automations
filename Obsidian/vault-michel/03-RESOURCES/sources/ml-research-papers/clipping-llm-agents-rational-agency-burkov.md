---
title: "LLM Agents Are Not Rational Agents (Burkov, X/Twitter)"
type: source
source_type: social-media
platform: X/Twitter
url: "https://x.com/burkov/status/2048942593480794260"
author: "[[03-RESOURCES/entities/Andriy-Burkov]]"
published: 2026-04-27
created: 2026-05-05
tags:
  - llm
  - agents
  - rationality
  - expected-utility
  - ai-limitations
triagem_score: 8
---

## Summary

Andriy Burkov (PhD in agent systems) argues that LLM-based agents are fundamentally not rational agents in the decision-theoretic sense. A rational agent maximizes expected utility for its user; an LLM optimizes next-token prediction conditioned on prompt, context window, and training distribution. These are not the same objective.

Wrapping an LLM in a loop does not produce a rational decision-maker — it produces a text generator that mimics the surface form of deliberation. The LLM may output phrases like "I will compare expected outcomes" but its internal mechanism is statistical continuation, not utility maximization.

## Core Argument

- **Rational agent** (formal def.): always selects the action with maximum expected utility — even if a worse-sounding action has better numerical consequences.
- **LLM "agent"**: generates text statistically appropriate to the prompt + context. This can simulate rationality for narrow tasks where training distribution closely matches the environment.
- **The gap becomes fatal** for general-purpose problem solving: stable preferences, calibrated beliefs, causal world models, and utility computation are absent by default.

## Key Distinction

| Rational Agent | LLM-Based Agent |
|---|---|
| Maximizes expected utility | Optimizes next-token probability |
| Selects action via utility calculus | Generates plausible continuation |
| Fails predictably (bad model) | Fails strangely, fragilely, irreparably |
| Has causal world model | Has pattern compression |

## Why Failures Are "Irremediable"

For narrow tasks, imitation suffices. For open-ended responsibility, the mismatch produces failures that are not fixable by better prompting — they stem from the architectural gap between token prediction and utility maximization.

> "We are asking a simulator of rational agency to be a rational agent."

## O argumento em detalhe

### A definição formal de agente racional

Na teoria da decisão (Savage, 1954; von Neumann-Morgenstern, 1947), um agente racional é definido por:
1. **Preferências completas e transitivas:** pode comparar qualquer par de outcomes e essas comparações são consistentes
2. **Crenças calibradas:** probabilidades subjetivas que atualizam corretamente com evidências (Bayesianismo)
3. **Maximização de utilidade esperada:** seleciona a ação que maximiza $\sum_s P(s) \cdot U(s, a)$ onde $s$ são estados possíveis, $a$ é a ação, e $U$ é a função de utilidade

Burkov (PhD em sistemas de agentes) conhece essa definição tecnicamente. Seu argumento é que LLMs não implementam nenhum dos três componentes.

### Por que token prediction ≠ utilidade esperada

Um LLM prevê o próximo token condicionado no contexto. Durante o treino, o modelo aprendeu que em situações parecidas com a situação atual, determinados tokens aparecem com determinada frequência. O output é a distribuição de probabilidade mais plausível dado o contexto — não a ação com maior utilidade esperada.

A diferença é sutil mas fatal para casos não-triviais: o texto mais plausível para "o que fazer em situação X" não é necessariamente a ação ótima para maximizar utilidade em X. É a ação que mais frequentemente aparece em textos sobre situações parecidas com X no corpus de treino.

Para tarefas onde a distribuição de treino se alinha bem com o que seria ótimo (coding, escrita, análise), essa distinção não importa muito. Para tarefas de decisão com consequências reais e preferências idiossincráticas do usuário, a distinção pode ser a diferença entre sucesso e dano.

### "Simulator de agente racional" vs. agente racional

A frase de Burkov — "estamos pedindo a um simulador de agência racional para ser um agente racional" — captura a assimetria:

Um simulador convincente de X pode parecer idêntico a X em situações normais e falhar de maneiras inesperadas em situações anômalas. O "uncanny valley" de agentes LLM: eles são convincentes o suficiente para gerar confiança, mas falham de formas que um agente racional verdadeiro não falharia.

## Por que as falhas são "irremediáveis"

### Falhas de agentes racionais: previsíveis

Um agente racional falha quando seu modelo do mundo está errado ou quando sua função de utilidade é mal especificada. Essas falhas são diagnosticáveis: você pode identificar qual premissa estava errada e corrigir. O agente com modelo corrigido não repete o mesmo erro.

### Falhas de LLM-agents: estranhas e frágeis

LLM-agents falham por razões que não mapeiam para erros corrigíveis no modelo de mundo:
- O padrão de texto na situação não aparecia suficientemente no treino
- O contexto da conversa influenciou o output de formas não-óbvias
- A phrasing da instrução ativou associações indesejadas

"Melhor prompting" pode mitigar algumas dessas falhas, mas não há garantia de cobertura. O espaço de falhas é não-enumerável — você não pode listar todos os casos onde o LLM vai falhar por razões de distribuição de treino.

## Implicações práticas para design de sistemas agênticos

### Quando a distinção importa

Para tarefas com escopo bem definido onde o LLM viu muitos exemplos similares durante treino, a distinção entre "simulator" e "agente racional" não importa operacionalmente. O LLM vai acertar com alta frequência.

Para tarefas com:
- Preferências altamente idiossincráticas do usuário
- Trade-offs que dependem de valores não inferíveis do texto
- Consequências irreversíveis de erros
- Situações genuinamente fora da distribuição de treino

...a distinção se torna crítica. Nesses casos, o design correto é não confiar no LLM como agente autônomo, mas usá-lo como ferramenta dentro de um sistema com supervisão humana para as decisões que importam.

### Scaffold de agência racional

Uma resposta ao argumento de Burkov é: construir o scaffold de agência racional ao redor do LLM. Em vez de pedir ao LLM para maximizar utilidade diretamente, usar o LLM para:
- Enumerar opções possíveis
- Estimar probabilidades de outcomes (onde tem dados)
- Articular trade-offs explicitamente

E manter o humano como o executor da escolha final. O LLM como "cogwheel de raciocínio" — não como agente racional autônomo.

### A assimetria de dano

Para tarefas de baixo stakes (draft de email, resumo de documento, explicação de conceito), falhas de LLM-agent são baratas — o humano detecta e corrige. Para tarefas de alto stakes (decisões financeiras, ações legais, alocação de recursos), o custo de uma falha "estranha e frágil" pode ser catastrófico. A recomendação implícita de Burkov: calibrar o grau de autonomia dado ao LLM-agent inversamente ao custo de uma falha irremediável.

## Contra-argumentos e limitações do argumento

- **Modelos com RL:** Claude, GPT, Gemini são treinados com RLHF, que introduz um sinal de preferência humana. Isso aproxima o training objective da maximização de utilidade humana — mas ainda não é equivalente (o reward model é uma aproximação das preferências, não as preferências reais).
- **Raciocínio extended:** CoT, chain-of-thought, e raciocínio com scratchpad podem implementar versões parciais de planejamento utilitário. O argumento de Burkov é mais forte contra LLMs sem raciocínio estendido.
- **Narrow tasks:** para domínios muito específicos com muitos dados de treino, a distinção pode ser academicamente válida mas operacionalmente irrelevante.

## Conexão com o vault-michel

O Nexus (agente orquestrador do vault) é um caso de uso onde o argumento de Burkov se aplica parcialmente. Para tarefas de ingest e wikilink, o Nexus é um "simulator de agência racional" confiável — há muitos exemplos similares e as consequências de erros são baixas. Para decisões estruturais grandes (reorganizar o vault, mudar convenções globais), o CLAUDE.md impõe "confirmar antes de agir" — precisamente porque o custo de uma falha estranha é alto.

## Related Pages

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-rational-agency-gap]] — core concept extracted from this source
- [[03-RESOURCES/concepts/expected-utility-maximization]] — decision-theoretic framework
- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]] — related (tool-use focus, not utility theory)
- [[03-RESOURCES/entities/Andriy-Burkov]] — author
