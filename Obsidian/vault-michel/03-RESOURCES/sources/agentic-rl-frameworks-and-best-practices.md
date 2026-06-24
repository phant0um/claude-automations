---
title: "Agentic RL: Frameworks and Best Practices"
type: source
source: "Clippings/Agentic RL Frameworks and Best Practices.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Cameron R. Wolfe apresenta um overview estruturado de como LLMs são treinados via RL para lidar com tarefas de longo horizonte em ambientes complexos (agentic RL), formalizando a diferença entre RL single-turn tradicional e RL multi-turn agêntico via uma reformulação de MDP (Markov Decision Process), e revisando frameworks práticos recentes (ToRL e outros) que extraem princípios de design reutilizáveis para sistemas agênticos de RL funcionais e performáticos.

## Argumentos principais
- **Componentes de um agente**: LLM backbone (precisa de instruction following, tool calling e reasoning avançados — modelos de reasoning são frequentemente preferidos), instructions (balanço entre simplicidade e especificidade — instruções muito detalhadas tornam-se frágeis e difíceis de manter), tools/environment (mediam acesso ao ambiente; tool calls representados via tokens especiais no stream, ex: `<tool_call>`/`</tool_call>`), e o agentic loop em si (gera output → executa tool call → ingere feedback → repete, até condição de término).
- **Context management e memory** são citados como componentes adicionais do harness: compactação/sumarização para tarefas longas (evitar overload de contexto) e memória persistente entre sessões/tarefas — conceitualmente, memória é "mais um aspecto do ambiente" porque é stateful e acessível via tool calls.
- **Formulação MDP single-turn**: estado = contexto de tokens atual; ação = token selecionado; transição = determinística (append do token); reward = geralmente terminal/outcome sobre o rollout completo; trajetória = sequência completa de tokens gerados.
- **Formulação MDP multi-turn (agêntico)**: estado = estado conjunto (contexto textual visível ao LLM + estado externo do ambiente); ação = output do agente em um dado step (de tokens individuais a tool calls de alto nível); transição = pode ser não-determinística (tool calls atualizam estado do ambiente e retornam observações estocásticas); reward = feedback sobre a trajetória, incluindo terminal e intermediário (process rewards) em tarefas longas; trajetória = trace multi-turn completo.
- **Infraestrutura de rollout é o maior desafio de engenharia**: rollouts agênticos variam muito em duração (mais turns de interação ou lentidão do ambiente); por isso a maioria dos sistemas usa RL assíncrono com arquitetura desagregada (em vez de colocada). Isolamento por rollout (containers Docker/sandboxing) é necessário porque o agente pode modificar estado compartilhado (editar arquivo, mudar entrada de banco) — sem isolamento, erros em um rollout corrompem outros.
- **Escalar ambientes é um desafio de sistemas**: um exemplo citado é o de SWE-Bench, onde cada iteração de RL gerava 512 containers Docker em paralelo, sobrecarregando o daemon Docker — resolvido integrando Kubernetes (via R2E-Gym) para escalonar containers num pool de nós.
- **GRPO vs. PPO**: GRPO é o mais comum, mas trabalhos recentes (ex: GLM-5.2) adotam PPO para tarefas de longo horizonte porque trajetórias muito longas, quando divididas por compactação em múltiplos sub-traces, geram número variável de traces treináveis por prompt — GRPO assume comparação grupo-relativa que não lida bem com isso; PPO com crítico estima vantagens token-level a partir de rollouts individuais.
- **ToRL (Tool-Integrated RL)**: treina agentes de tool-integrated reasoning (interleaving texto + código) com RL puro a partir de outcome rewards, partindo de um setup RL-Zero (modelo base pré-treinado, sem post-training prévio). Limita o número de chamadas de ferramenta por problema (`C=1` na maioria dos experimentos; `C=2` melhora moderadamente mas com custo significativo de eficiência). Erros de execução de código são retornados ao LLM como observação, mas truncados para a última linha (evitar overload de contexto com tracebacks verbosos). Reward: +1 correto, -1 incorreto, -0.5 código não-executável — mas penalizar código não-executável não ajuda performance (hipótese: torna o modelo excessivamente conservador).

## Key insights
- A principal diferença estrutural entre RL tradicional e agentic RL não é o otimizador, mas a *natureza da transição* — em RL agêntico a transição pode ser não-determinística e estocástica (porque depende do ambiente/ferramentas), enquanto em RL de LLM padrão a transição é puramente determinística (apêndice de token).
- Isolamento de ambiente (1 ambiente dedicado por rollout) não é só boa prática, é *necessário* para correção do treino — sem ele, rollouts paralelos do mesmo grupo (GRPO) corrompem uns aos outros via estado compartilhado.
- O motivo pelo qual modelos de produção como GLM-5.2 abandonam GRPO por PPO em tarefas de longo horizonte é um detalhe técnico raramente discutido: compactação de trajetórias longas quebra a premissa de "grupo de rollouts comparáveis" que o GRPO exige.
- Penalizar comportamento "ruim mas não catastrófico" (código que não executa) pode ser contraproducente — o agente aprende conservadorismo excessivo em vez de melhorar a habilidade real.

## Exemplos e evidências
- Citação de GLM-5.2 explicando a migração de GRPO para PPO por causa de variabilidade no número de traces treináveis após compactação de trajetórias longas.
- Citação de relato de scaling de ambientes SWE-Bench: 512 containers Docker por iteração de RL sobrecarregando o daemon Docker, resolvido com Kubernetes via R2E-Gym.
- ToRL: resultados mostram que penalidade por código não-executável (-0.5) não supera o reward puro outcome-based (+1/-1) — outcome reward simples é tão ou mais eficaz.

## Implicações para o vault
Fonte densa e estruturalmente complementar a [[03-RESOURCES/concepts/agent-systems/agentic-rl]] e [[03-RESOURCES/concepts/llm-ml-foundations/reinforcement-learning-from-human-feedback]] — formaliza a distinção MDP single-turn vs. multi-turn que estava implícita mas não explicitada na nota existente de `agentic-rl`. Conecta diretamente com [[03-RESOURCES/concepts/agent-systems/agent-loop]] (definição do agentic loop) e [[03-RESOURCES/concepts/agent-systems/long-horizon-agent-training]] (infra de rollout assíncrono, isolamento de ambiente).

## Links
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop]]
- [[03-RESOURCES/concepts/agent-systems/long-horizon-agent-training]]
- [[03-RESOURCES/concepts/llm-ml-foundations/reinforcement-learning-from-human-feedback]]
