---
title: "Distribution Fine Tuning (DFT) — Fixing LLM Writing Quality"
type: source
created: 2026-05-18
updated: 2026-05-18
tags: [ai-agents, llm-training, fine-tuning, writing-quality, post-training]
triagem_score: 7
source_url: "https://threadreaderapp.com/thread/2056406211369541947.html"
author: "@rosmine"
published: 2026-05-18
category: ai-agents
---

## Tese central

Distribution Fine Tuning (DFT) é um passo de pós-treinamento que reduz a distância distribucional entre outputs de LLM e texto humano de referência — corrigindo a qualidade de escrita não por métrica de "qualidade" vaga, mas por similaridade distribucional mensurável.

## Key insights

1. **Problema:** SFT não é suficiente. Existe uma lacuna distribucional enorme entre outputs de LLM e texto humano de referência — mesmo após SFT padrão.
2. **Solução:** DFT mede e minimiza a distância distribucional entre output do modelo e dados de treino humanos, ao invés de otimizar "qualidade de escrita" (indefinida).
3. **Resultados mensurados:**
   - Redução de 49% na distância distribucional
   - +164% em scores de criatividade
   - +28% em coerência
   - +146% em detalhe de significado
4. **Eliminação de "slop signs":** DFT previne overuse de padrões característicos de AI como emdash ou construções "it's not X, it's Y".
5. **Detecção:** modelo treinado com DFT enganou o detector pangram em 100% dos casos de teste.
6. **Plano:** lançar modelo open weights treinado com DFT (demo atual treinado para documentos web).
7. **Demo disponível:** dft.rosmine.ai | Relatório técnico: rosmine.ai

## Links

- Thread: https://threadreaderapp.com/thread/2056406211369541947.html
- Relatório técnico: https://rosmine.ai/2026/05/18/fixing-llm-writing-with-distribution-fine-tuning/
- Demo: https://dft.rosmine.ai/
- Relacionado: [[03-RESOURCES/concepts/llm-ml-foundations/automated-alignment-researcher]], [[03-RESOURCES/concepts/agent-systems/agentic-rl]]

---

## Mecanismo técnico: como o DFT funciona

### O problema que o SFT não resolve

Supervised Fine-Tuning (SFT) treina o modelo para imitar exemplos de alta qualidade. O problema: o modelo aprende a distribuição dos exemplos de treino, não a distribuição do texto humano em geral. O resultado é texto que parece correto por métricas de qualidade (coerência, gramática, relevância) mas tem uma assinatura distribucional diferente do texto humano — identificável por detectores e perceptível por leitores atentos.

### O que DFT mede

DFT quantifica a **distância distribucional** entre o output do modelo e um corpus de referência de texto humano. Em vez de "esse texto é bom ou ruim", pergunta "essa distribuição de escolhas léxicas, estruturas sintáticas e padrões de pontuação é similar à distribuição humana?"

A métrica usada é variante de divergência KL ou distância de Wasserstein sobre a distribuição de outputs — não foi especificada publicamente no relatório técnico completo.

### O processo de fine-tuning

1. Coleta de corpus de referência humano (documentos web, no caso do demo atual)
2. Geração de outputs do modelo para os mesmos inputs
3. Medição da distância distribucional entre output do modelo e referência humana
4. Fine-tuning para minimizar essa distância (não para maximizar "qualidade")
5. Avaliação: redução de 49% na distância distribucional mensurada

## Os "slop signs": o que DFT elimina

O texto gerado por LLMs tem padrões característicos que são raros no texto humano:

- **Emdash em excesso** (—): LLMs usam emdash 3-7× mais que humanos em prosa informal
- **Construção "it's not X, it's Y"**: padrão de contraste que os modelos aprenderam de tutoriais e posts de LinkedIn
- **Listas de 3 itens**: tendência a estruturar qualquer argumento em exatamente 3 pontos
- **Abertura com "Absolutely!" ou "Certainly!"**: padrão de concordância entusiasmada
- **Adjetivos superlatives repetidos**: "groundbreaking", "revolutionary", "transformative"

DFT reduz esses padrões sem precisar listar cada um explicitamente — o modelo aprende a distribuição do texto humano onde esses padrões são raros.

## Resultados em detalhes

| Métrica | Melhoria |
|---|---|
| Distância distribucional | −49% |
| Score de criatividade | +164% |
| Coerência | +28% |
| Detalhe de significado | +146% |
| Detecção por pangram (AI detector) | 0% detectado (100% evasão) |

A evasão de detectores é um efeito colateral, não um objetivo — o objetivo é texto que se parece com texto humano porque foi treinado para ter a mesma distribuição, não porque foi otimizado para enganar detectores.

## Comparação com abordagens alternativas

| Abordagem | Mecanismo | Limitação |
|---|---|---|
| SFT padrão | Imitação de exemplos | Mantém assinatura distribucional de LLM |
| RLHF | Preferência humana | Otimiza "parece bom", não "é distribucionalmente humano" |
| Prompt engineering | Instruções para evitar padrões | Requer lista explícita de anti-padrões; não escala |
| DFT | Minimização de distância distribucional | Requer corpus de referência; mais caro que SFT |

## Relevância para produção de conteúdo

Para qualquer workflow que produz texto para consumo humano — posts, relatórios, documentação, comunicação empresarial — DFT representa uma melhoria qualitativa que prompts não conseguem alcançar. Um modelo treinado com DFT produz texto que leitores humanos percebem como mais natural sem saber explicar por quê.

## Relevância para o vault

O vault usa Claude para síntese de fontes, criação de notas conceituais e geração de briefings. Texto com menos "slop signs" resulta em notas mais utilizáveis e menos necessidade de edição pós-geração. Quando o modelo DFT com open weights for lançado, é candidato a substituir o modelo atual para tarefas de escrita longa no vault.

## Referências adicionais

- [[03-RESOURCES/concepts/llm-ml-foundations/automated-alignment-researcher]] — alinhamento como processo contínuo
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — RL aplicado a agentes
- Demo disponível: https://dft.rosmine.ai/
