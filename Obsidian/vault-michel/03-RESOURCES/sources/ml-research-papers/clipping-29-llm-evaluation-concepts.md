---
title: "29 LLM Evaluation Concepts Every Engineer Needs to Know"
type: source
source_type: article
author: "Anshuman Mishra"
created: 2026-05-06
tags: [evaluation, llm, metrics, production]
triagem_score: 7
---

29 LLM eval concepts: non-determinism, fuzzy correctness, golden sets, rubrics, LLM-as-judge, RAG triad (faithfulness/answer relevance/context precision), human evaluation, automated pipelines.

## Source

Ingested from: `clippings/29 LLM Evaluation Concepts Every Engineer Needs to Know.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Por que eval de LLM é diferente de eval tradicional

Sistemas de software tradicionais têm outputs determinísticos: dado input X, a saída é sempre Y. Avaliação é simples — compare Y esperado com Y obtido.

LLMs são não-determinísticos e produzem texto livre. "A capital da França é Paris" e "Paris é a capital francesa" são igualmente corretas mas não são strings idênticas. Isso exige toda uma nova categoria de métricas e metodologias.

## Conceitos fundamentais

**Non-determinism:** mesmo prompt, temperatura > 0, outputs diferentes. Consequência: você precisa de múltiplas amostras por prompt para estimar a distribuição de qualidade, não apenas uma resposta.

**Fuzzy correctness:** correto é um espectro, não binário. "Quase certo" pode ser aceitável em contextos de baixo risco e inaceitável em medicina ou direito. Rubrics capturam esse gradiente.

**Golden sets:** conjunto curado de pares (input, output ideal) para benchmarking. Crítico mas custoso de manter. Degradam com drift do modelo — golden sets precisam ser revisados quando o modelo base muda.

**Rubrics:** critérios explícitos de avaliação ("resposta cita fonte corretamente = 1 ponto, resposta inclui disclaimer = 1 ponto..."). Permitem avaliação estruturada por humanos e LLM-as-judge.

## O RAG Triad

A tríade mais usada para avaliar sistemas RAG:

**Faithfulness (fidelidade):** a resposta é suportada pelos documentos recuperados? Detecta alucinações — o modelo inventou algo não presente no contexto.

**Answer relevance:** a resposta responde à pergunta do usuário? Mesmo que fiel ao contexto, uma resposta pode ser irrelevante por ser muito genérica ou off-topic.

**Context precision (context relevance):** os documentos recuperados são relevantes para a pergunta? Avalia a qualidade do retrieval em si, independente da geração.

Um sistema RAG pode ter alta faithfulness (não alucina) mas baixa context precision (recupera documentos errados) — resultado: respostas corretas mas sobre o tema errado.

## LLM-as-Judge

Usar um LLM mais capaz para avaliar outputs de outro LLM. Vantagens: escala (avalia milhares de respostas por hora), custo (mais barato que humanos), consistência (não tem dias ruins).

**Problemas conhecidos:**
- **Position bias:** juízes LLM tendem a favorecer a primeira resposta em pairwise comparisons
- **Length bias:** respostas mais longas são sistematicamente preferidas, mesmo quando menos corretas
- **Self-preference:** GPT-4 avaliando GPT-4 vs Claude tem viés para si mesmo
- **Verbosity trap:** juízes recompensam linguagem confiante, não acurácia

**Mitigações:** avalie em ambas as ordens e faça média, use rubrics explícitas em vez de preferência geral, calibre o juiz contra golden sets humanos.

## Pipeline de avaliação automatizada

Uma pipeline de eval production-grade tipicamente tem:

1. **Offline eval:** antes de deploy, roda bateria de golden sets + rubrics. Gate de qualidade.
2. **Shadow eval:** em produção, uma amostra de queries reais vai para o novo modelo em paralelo. Compara com modelo atual.
3. **Online eval:** LLM-as-judge avalia uma amostra do tráfego real em tempo real. Dashboard de qualidade contínua.
4. **Human eval escalada:** quando LLM-as-judge detecta degradação, amostra vai para revisão humana.

## Métricas para casos específicos

**Para RAG:**
- RAGAS (framework open-source): automatiza o RAG triad
- BLEU/ROUGE: overlap de n-grams com referência. Útil como baseline mas não captura semântica

**Para classificação:**
- Precision/recall/F1 por categoria
- Confusion matrix para identificar classes problemáticas

**Para geração longa:**
- BERTScore: similaridade semântica entre gerado e referência via embeddings
- G-Eval: avaliação baseada em LLM com critérios customizáveis

**Para agentes:**
- Task completion rate: o agente completou a tarefa?
- Steps efficiency: quantos passos foram necessários vs mínimo possível?
- Hallucination rate em tool calls: o agente inventou parâmetros?

## Avaliação humana: quando e como

Automação não substitui humanos para:
- Calibrar novos juízes LLM (você precisa de ground truth humano)
- Avaliar dimensões subjetivas (tom, adequação cultural, sensibilidade)
- Investigar falhas que métricas automáticas não detectaram

**Annotation best practices:** múltiplos anotadores por exemplo, inter-annotator agreement medido (Kappa de Cohen), desacordos resolvidos por especialista, não por maioria simples.

## Problemas comuns em eval de produção

**Dataset contamination:** golden sets vazaram para training data do modelo. Resultado: métricas infladas que não se transferem para dados reais.

**Distribution shift:** o golden set foi criado com queries de 2023. Em 2025, o perfil de queries mudou. Eval passa mas qualidade em produção cai.

**Metric gaming:** quando o modelo é otimizado para uma métrica específica, começa a maximizá-la em detrimento de qualidade real. Veja Goodhart's Law.

**Evaluation-production gap:** o contexto de eval (prompt, temperatura, formato) nunca é idêntico ao de produção. Pequenas diferenças podem causar grandes divergências.

## Relevância para o vault

O vault-michel usa agentes que produzem outputs avaliáveis: ingestões, consolidações, respostas do Nexus. Aplicar um pipeline de eval simplificado — golden set de 20 perguntas sobre conteúdo do vault, LLM-as-judge para faithfulness, log de task completion — daria visibilidade sobre degradação de qualidade ao longo do tempo.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/retrieval-augmented-generation]]
- [[03-RESOURCES/sources/memory-context-rag/clipping-vector-database-a-deep-dive]]
