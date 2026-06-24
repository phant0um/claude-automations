---
title: "A Framework to Study AI Models in Reasoning, Alignment, and Memory (RAM)"
type: source
source_type: paper
created: 2026-05-06
tags: [reasoning, alignment, memory, framework]
triagem_score: 7
---

RAM framework for studying AI models across three dimensions: Reasoning (logical inference), Alignment (value adherence), and Memory (information retention). Evaluation methodology for holistic AI assessment.

## Source

Ingested from: `clippings/A framework to study AI models in Reasoning, Alignment, and use of Memory (RAM)..md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Motivação do framework

Avaliações de LLM existentes tendem a ser unidimensionais: benchmarks de raciocínio (MMLU, GSM8K, HumanEval) medem capacidade cognitiva, mas não comportamento seguro. Benchmarks de alignment (TruthfulQA, SafetyBench) medem valores, mas não capacidade. Nenhum avalia memória de forma sistemática.

O framework RAM propõe uma estrutura triaxial para avaliação holística — um modelo pode ser excelente em reasoning mas deficiente em alignment, ou ter boa alignment mas memória deficiente. A interação entre as três dimensões é tão importante quanto cada uma isoladamente.

## Os três eixos

### R — Reasoning (Raciocínio)

Capacidade de derivar conclusões válidas a partir de premissas, seguir cadeias lógicas multi-passo, e resolver problemas que exigem planejamento.

**Subdimensões:**
- **Logical inference:** dados A → B e B → C, inferir A → C
- **Mathematical reasoning:** aritmética, álgebra, geometria, raciocínio probabilístico
- **Causal reasoning:** distinguir correlação de causalidade, raciocinar sobre intervenções
- **Analogical reasoning:** transferir estrutura de um domínio para outro
- **Counterfactual reasoning:** "se X tivesse acontecido, então Y seria..."

**Limitação conhecida:** modelos podem demonstrar raciocínio aparente (chain-of-thought coerente) sem raciocínio genuíno. Ver Burkov — fluência de raciocínio ≠ racionalidade.

### A — Alignment (Alinhamento)

Aderência a valores humanos, normas sociais, e instruções do usuário e sistema. Não apenas "não faça coisas ruins", mas calibração refinada sobre o que é útil vs. prejudicial em contextos específicos.

**Subdimensões:**
- **Instruction following:** executa o que foi pedido, não mais nem menos
- **Value adherence:** mantém princípios éticos mesmo sob pressão ou jailbreak
- **Helpfulness:** maximiza utilidade para o usuário dentro dos constraints
- **Honesty:** não afirma coisas falsas; expressa incerteza calibrada
- **Harm avoidance:** recusa ou mitiga requests que causariam dano

**Tensão fundamental:** helpfulness e harm avoidance são frequentemente em tensão. Um modelo muito conservador é unhelpful; um muito permissivo é perigoso. Alignment bem calibrado navega essa tensão contextualmente.

### M — Memory (Memória)

Capacidade de reter, recuperar, e usar informação ao longo do tempo — tanto dentro de uma sessão (in-context) quanto entre sessões (external memory).

**Subdimensões:**
- **In-context retention:** usa informação do início da conversa no final
- **External memory retrieval:** recupera informação de fontes externas de forma pertinente
- **Memory consolidation:** integra nova informação com conhecimento existente sem contradição
- **Forgetting appropriately:** não usa informação desatualizada quando informação nova contradiz
- **Multi-session continuity:** mantém contexto relevante entre sessões separadas

## Interações entre dimensões

As três dimensões não são independentes — sua interação define comportamento complexo:

**Reasoning × Alignment:** um modelo com alto reasoning mas baixo alignment pode usar capacidades cognitivas para encontrar formas mais sofisticadas de ser prejudicial. Alto reasoning + alto alignment é o objetivo, mas alto alignment sem reasoning produce recusas excessivamente conservadoras ("não posso ajudar com isso" para perguntas inocentes).

**Reasoning × Memory:** raciocínio sem memória é memória sem aprendizado — cada sessão começa do zero. Memória sem raciocínio é armazenamento sem síntese — o modelo lembra fatos mas não conecta. A combinação permite aprendizado cumulativo.

**Alignment × Memory:** memória de longo prazo sem alignment pode persistir comportamentos indesejados. Alignment sem memória de contexto leva a recusas que não fazem sentido dado o histórico da conversa ("você me pediu para ajudar com este projeto há 10 minutos — por que está tratando esta pergunta relacionada como suspeita?").

## Metodologia de avaliação RAM

O paper propõe benchmarks específicos por dimensão:

**Para Reasoning:**
- Testes de inferência formal com lógica proposicional
- Problemas matemáticos multi-passo com verificação de processo, não apenas resultado
- Tarefas de planejamento com múltiplos constraints

**Para Alignment:**
- Adversarial prompts calibrados (não apenas jailbreaks óbvios)
- Cenários de trade-off valores (quando ser útil pode causar dano menor)
- Consistency checks (o modelo mantém os mesmos valores em formulações diferentes?)

**Para Memory:**
- Conversas longas com informação importante no início testadas no final
- RAG evaluation com documentos relevantes vs. distractores
- Multi-session tests onde informação da sessão anterior deve ser usada na atual

## Onde modelos atuais falham

**Reasoning failures:** problemas de aritmética simples, inconsistências em raciocínio multi-passo, falhas em raciocínio counterfactual.

**Alignment failures:** over-refusal (recusar pedidos legítimos), sycophancy (concordar com o usuário mesmo quando errado), inconsistência de valores entre reformulações.

**Memory failures:** "losing the thread" em conversas longas, falha em usar informação relevante do contexto, recuperação de informação errada quando múltiplos documentos são fornecidos.

## Aplicação do framework

RAM é útil para:
1. **Seleção de modelo:** qual modelo usar para qual caso de uso depende do perfil RAM necessário
2. **Fine-tuning dirigido:** identificar a dimensão deficiente antes de investir em fine-tuning
3. **Design de sistema:** compensar weaknesses de modelo com design de harness (memória externa para compensar M fraco, human-in-the-loop para compensar A inconsistente)

## Relevância para o vault

O framework RAM é uma lente útil para avaliar os agentes do vault: o Nexus precisa de alto M (memória entre sessões) e alto A (seguir CLAUDE.md fielmente); o guard precisa de alto A (segurança) mesmo com R moderado; o ingest-report precisa de R (síntese) e M (contexto de quais artigos já foram processados). Mapear o perfil RAM ideal de cada agente tornaria mais claro que modelo usar para cada um.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/sources/ml-research-papers/clipping-29-llm-evaluation-concepts]]
- [[03-RESOURCES/sources/ml-research-papers/clipping-post-burkov-llm-rationality-gap]]
