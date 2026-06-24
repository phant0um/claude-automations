---
title: "29 LLM Evaluation Concepts Every Engineer Needs to Know"
type: source
source: "Clippings/29 LLM Evaluation Concepts Every Engineer Needs to Know.md"
author: "[[Anshuman Mishra]]"
published: 2026-04-27
created: 2026-05-23
ingested: 2026-05-23
tags: [ai-agents, clippings, llm-eval, engineering]
---

## Tese central

LLM evaluation é uma disciplina própria — não é debugging, é medição. Engenheiros de software têm instintos de testing que não funcionam em LLMs (determinismo, binary pass/fail, CI) e precisam substituir por um framework de eval com critérios, rubrics, golden sets e julgamento contínuo.

## Argumentos principais

- **Non-determinism problem**: mesmo prompt → outputs diferentes. Temperature controla aleatoriedade. Uma passagem de teste é dado, não veredicto — você está sampleando de distribuição probabilística.
- **Fuzzy correctness**: qualidade LLM é multi-dimensional e subjetiva. Não há resposta única "correta". Definir "bom" é decisão de produto, não técnica.
- **Silent regression**: sem eval sistemática, toda mudança de prompt é aposta cega. CI não existe para LLMs — você descobre regressão quando usuário reclama.
- **Eval Coverage**: golden set construído da imaginação dos devs ≠ inputs reais. Amostra de production regularmente; adicione falhas ao golden set.

## Key insights (29 conceitos agrupados)

### Primitivos
1. **Criteria** — dimensões de qualidade específicas ao use case (suporte: empatia, resolução; código: validade, convenções)
2. **Quality dimensions** — Relevance, Coherence, Factual Accuracy, Helpfulness, Safety
3. **Rubric** — operacionaliza critérios em perguntas scoráveis e reproduzíveis
4. **Test cases** — par input/output; falha = score abaixo do threshold, não "errado"
5. **Golden set** — ground truth; tratar como artefato crítico, versionar, atualizar
6. **Pass/fail threshold** — decisão de produto; too low = garbage, too high = nada
7. **Eval coverage** — quão bem golden set reflete tráfego real de produção

### Scoring
8. **Human evaluation** — gold standard; lento, caro; usar estrategicamente (construir golden set, calibrar)
9. **Heuristic/code eval** — valida estrutura (JSON válido, comprimento, regex); primeira linha de defesa
10. **Semantic similarity** — embeddings + cosine similarity; rápido, mas mede proximidade à referência, não qualidade absoluta
11. **BLEU/ROUGE/Execution-based** — métricas task-specific; BLEU para tradução, ROUGE para summarização, execution para código
12. **LLM as Judge** — LLM mais capaz avalia outputs; escalável; tem vieses próprios. GPT-5/Claude Opus como juízes comuns
13. **Pointwise vs Pairwise** — pointwise: score absoluto; pairwise: qual é melhor; pairwise alinha melhor com preferência humana
14. **Temperature e reprodutibilidade** — setar temperature=0 em eval runs; aceitar resultados mais ruidosos se production usa temperatura alta
15. **Statistical rigor** — múltiplas runs, reportar mean + variance; diferença de 4.1→4.3 pode ser ruído

### Técnicas avançadas
16. **Calibration** — alinhar LLM judge com human judgment; ancorar com exemplos humanos
17. **Bias detection** — position bias (juiz favorece primeira resposta), verbosity bias (mais longo = melhor), self-preference bias
18. **Chain of Thought eval** — avaliar raciocínio intermediário, não só output final
19. **Failure mode analysis** — categorizar por tipo; pattern de falha → ação específica
20. **Regression testing** — suite eval em cada mudança de prompt/model
21. **A/B evaluation** — comparar versões com tráfego real; statistical significance necessária
22. **Hallucination detection** — verificar factual claims contra knowledge base
23. **Groundedness** — output ancorado em contexto fornecido (RAG use cases)
24. **Faithfulness** — summarização preserva conteúdo original sem distorção
25. **Preference learning** — treinar julgadores com feedback humano para calibrar
26. **Multi-turn eval** — avaliar consistência ao longo de conversas, não só turno único
27. **Latency vs quality tradeoff** — métricas de eval devem incluir latência em produção
28. **Eval infrastructure (Gavel)** — plataforma interna Zomato: scripts → produto para times de AI e ops
29. **Continuous eval** — eval não é evento, é sistema contínuo paralelo à produção

## Exemplos e evidências

- **Gavel (Zomato)**: eval platform interna que começou como scripts e hoje serve múltiplos times. Real-world case study de scaling eval.
- **Threshold example**: rubric 1-5, threshold 3 → abaixo = falha. Definição de threshold = decisão de produto, não técnica.
- **Golden set seeding**: usar queries reais anonimizadas de produção, não exemplos inventados.

## Implicações para o vault

- Complementa [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]] — eval é componente crítico de qualquer LLM pipeline
- Confirma necessidade de concept `llm-evaluation` — ausente no vault, 29 conceitos = cobertura específica
- Conecta com [[03-RESOURCES/sources/ai-agents-harness/clipping-9-agentic-patterns]] — qual padrão usar depende de quão bem você consegue avaliar o output

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/entities/Anshuman Mishra]]
