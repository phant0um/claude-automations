---
title: "LLMs Improving LLMs: Agentic Discovery for Test-Time Scaling"
type: source
source: Clippings/LLMs Improving LLMs Agentic Discovery for Test-Time Scaling.md
created: 2026-05-17
ingested: 2026-05-17
tags: [ai-agents, research, test-time-scaling]
triagem_score: 10
---

## Tese central
Agentes LLM podem descobrir autonomamente técnicas de test-time scaling que melhoram performance de outros LLMs — meta-improvement loop sem human-in-the-loop. Colaboração UMD + Google + Meta produz evidência empírica de que LLMs podem fazer pesquisa de otimização sobre si mesmos de forma confiável.

## Key insights
- **Meta-improvement loop:** agente explora estratégias de inference → valida em benchmarks → seleciona melhores → propaga como técnicas descobertas. Loop fecha sem humano no caminho crítico
- **UMD + Google + Meta:** colaboração cross-org de alto rigor — resultado não é artefato de laboratório único mas validado por pesquisadores de backgrounds diferentes
- **Test-time scaling como espaço de busca:** técnicas de inference-time compute (chain-of-thought, self-consistency, beam search, verifier-guided decoding) formam espaço combinatório enorme — agente explora sistematicamente em vez de humano iterar manualmente
- **Analogia com automated alignment researcher:** loop de descoberta é instância do mesmo paradigma — agente como pesquisador que gera hipóteses, valida empiricamente, reporta resultados

## O que é test-time scaling

Test-time scaling (ou inference-time compute scaling) é conjunto de técnicas que melhoram qualidade de resposta usando mais compute em inferência em vez de apenas no treinamento:

- **Chain-of-thought:** gerar raciocínio passo-a-passo antes da resposta
- **Self-consistency:** gerar múltiplas respostas com temperatura > 0, selecionar por maioria
- **Best-of-N:** gerar N respostas, usar verifier para selecionar melhor
- **Tree of Thought:** explorar múltiplos caminhos de raciocínio em paralelo
- **MCTS com LLM:** Monte Carlo Tree Search guiado por LLM para problemas de busca

Cada técnica tem custo (tokens extras), ganho (qualidade), e sensibilidade a tipo de tarefa. Combinação ótima é específica ao modelo e à tarefa.

## Arquitetura do sistema de descoberta

### Agente explorador

LLM com conjunto de ferramentas:
- Gerador de técnicas: propõe variações de estratégias existentes ou combinações novas
- Executor: aplica técnica a modelo alvo em conjunto de tarefas de eval
- Avaliador: mede performance resultante em benchmark
- Memória: acumula resultados de explorações anteriores

### Loop de exploração

```
[1] Agente lê literatura de técnicas conhecidas (few-shot context)
[2] Propõe variação ou combinação nova
[3] Executa técnica em modelo alvo (GPT-3.5, Llama, etc.) em mini-benchmark
[4] Registra resultado: (técnica, modelo, tarefa, ganho)
[5] Analisa padrão em resultados acumulados
[6] Propõe hipótese sobre quais técnicas generalizam
[7] Valida hipótese em benchmark completo
[8] Reporta técnicas confirmadas
```

### Validação em benchmark

Técnicas descobertas são validadas em benchmarks estabelecidos (MATH, HumanEval, MMLU, etc.) para garantir que ganho não é artefato de mini-benchmark. Comparação com técnicas humanas do estado da arte.

## Resultados reportados

Paper reporta que agente redescobriu técnicas conhecidas (CoT, self-consistency) e identificou variações não documentadas anteriormente que produzem ganhos adicionais de 3-7% em benchmarks de raciocínio matemático.

Mais significativo: agente identificou que combinação específica de best-of-N com verifier treinado é mais eficiente por FLOP que CoT puro em problemas de código — resultado não óbvio sem exploração sistemática.

## Implicações

### Para pesquisa de LLMs

Se agente pode descobrir técnicas de otimização, escopo de pesquisa humana pode se deslocar de "descobrir técnicas" para "verificar e interpretar descobertas agênticas" — aceleração de ciclo de pesquisa.

### Para produção de IA

Pipeline de otimização automática de inference strategy por modelo e tarefa — sem engenheiro ajustando parâmetros manualmente. Cada deploy poderia ter sua própria estratégia ótima descoberta por agente.

### Para alignment

Agentes que otimizam outros LLMs sem supervisão humana levantam questão de quem valida que otimização não introduz comportamentos indesejados. Pipeline precisa de eval de safety além de eval de performance.

## Conexão com autoresearch-loop

É implementação concreta de autoresearch-loop aplicado a pesquisa de ML: domínio formal (benchmarks), feedback verificável (métricas), exploração sistemática, sem alucinação de resultados (resultados são empíricos).

## Implicação para ciclo de pesquisa de IA

Se agentes podem descobrir técnicas de otimização de inference, um ciclo emerge:
1. Pesquisadores humanos treinam modelo base (GPT-5, Claude 4)
2. Agentes de descoberta encontram técnicas de inference que maximizam performance
3. Melhores técnicas viram defaults nos sistemas de produção
4. Pesquisadores humanos avaliam resultados e decidem sobre próximo ciclo de treinamento

Humanos focam em: definir objetivos e valores, avaliar comportamentos emergentes, decidir sobre treinamento. Agentes focam em: explorar espaço de estratégias, validar empiricamente, otimizar dentro de objetivos definidos.

## Por que colaboração cross-org (UMD + Google + Meta) importa

Pesquisa em técnicas de inference que melhora performance é diretamente aplicável a produto. Google e Meta têm incentivo econômico forte para que essas descobertas sejam reais e robustas. Participação de grandes labs adiciona rigor de validação e recurso computacional — experimentos que validem em escala real, não apenas em benchmarks pequenos.

Paper publicado abertamente = comunidade pode replicar e expandir. Decisão de publicar abertamente é estratégica: posiciona os labs como líderes em pesquisa de agentes, atrai talentos, e constrói reputação mesmo que técnicas específicas sejam implementadas internamente.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/automated-alignment-researcher]]
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/llm-ml-foundations/test-time-compute]]
