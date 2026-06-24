---
title: A Primer in Post-Training Reasoning Data
type: source
source: Clippings/2606.02113v1.md
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, llm-ml-foundations, post-training, reasoning, paper]
authors: [Yaoming Li, Guangxiang Zhao, Qilong Shi, Lin Sun, Xiangzheng Zhang, Tong Yang]
affiliations: [Peking University, Tsinghua University, Qiyuan Tech]
arxiv: "2606.02113"
---

# A Primer in Post-Training Reasoning Data

**Tese central:** A unidade reutilizável do post-training não é um par prompt–resposta, mas uma **interface de feedback portando verificador** cujo valor depende do verificador, do modelo base, da linhagem, do otimizador, do scaffold e do orçamento de inferência. O campo carece de uma linguagem comum para atribuir ganhos — este primer sintetiza 150+ estudos públicos para construir esse framework de atribuição.

## Argumentos principais

### 1. Taxonomia ancorada em verificador (Seção 2)

Os dados de raciocínio devem ser classificados por **contrato de verificação** (o que pode ser checado), não por domínio. Três contratos:

- **Verificação programática:** respostas normalizáveis, código executável, estados de prova Lean. Sinal é local — certifica o artefato final sem certificar robustez ou movimento além da política base.
- **Verificação ambiental:** tarefas de tool use, web, app, OS, repositório — expõem estados, ações, observações, predicados terminais. Transcrições SFT limpas apagam ações falhas, retentativas e ramificações onde a atribuição de crédito é visível. Devem ser episódios reproduzíveis, não apenas transcrições de sucesso.
- **Verificação que requer julgamento:** domínios médicos, factualidade, segurança, rubrica — o juiz torna-se parte do objeto de dados. Prompts ocultos ou rubrica podem transformar ganhos em preferências específicas do juiz.

**Três eixos transversais:**
- *Granularidade de supervisão:* rótulos de resultado vs. rótulos de passo vs. escores de continuação
- *Limites de comportamento:* quando responder, recusar, abstrair, fornecer completação segura
- *Linhagem intergeracional:* flywheels sintéticos podem propagar estilo de trace, política de decodificação, filtro ou preferência de professor — não a distribuição de perguntas

### 2. O que torna dados de raciocínio bons? (Seção 3)

| Dimensão | Relativo a |
|----------|-----------|
| Correção | Contrato de verificador (não string de resposta) |
| Dificuldade | Modelo base + protocolo de amostragem |
| Qualidade do trace | Trajetória (validade local, fundamentação, auditabilidade) |
| Cobertura | Linhagem (mistura de fontes, filtros, professores) |

**Armadilha 1 — "Trace longo = bom raciocínio":** Traces podem racionalizar decisões moldadas por features enviesadas (Turpin et al. 2023, Lanham et al. 2023). Qualidade exige validade e fundamentação, não comprimento.

**Armadilha 2 — "Dados mais difíceis são melhores":** Dificuldade é relativa ao modelo base. Um item pode ser inalcançável para uma base, útil para outra, e saturado para uma terceira. DAPO remove grupos de prompts com precisão 0 ou 1 (Yu et al. 2025).

**Armadilha 3 — "Mais dados = melhor cobertura":** Cobertura é uma receita, não uma contagem (Guha et al. 2025 — OpenThoughts). Dados sintéticos podem estreitar recursivamente, transmitir traços ocultos do professor, vazar campos privados por traces, ou contaminar benchmarks por canais de busca (Shumailov et al. 2024 — model collapse em Nature).

### 3. Como dados de raciocínio são construídos? (Seção 4)

Cada camada da construção é um handle de atribuição:

| Camada | Handle | Risco principal |
|--------|--------|----------------|
| Sourcing de prompts | suporte do problema / banda de pass-rate | distribuição base-condicional |
| Escrita de trace | estilo herdado do professor | transmite formato, decomposição, comportamento de parada |
| Substrato de busca | exploração e reprodutibilidade | compressão de transcrição apaga ramificações |
| Âncora de self-play | onde curation re-entra | define limites de suporte e confiabilidade de rótulos |
| Recompensa/verificador | o que conta como sucesso | gaming (master-key attacks, rewards espúrios) |
| Pipeline frontier | onde relatórios convergem | visibilidade do otimizador ≠ isolamento causal |

**Self-play não elimina curation** — apenas move a curadoria para a âncora (resposta externa, interpretador, verificador, voto por maioria, arquivo, divisão de papéis). STaR ancora em respostas externas; Absolute Zero usa o interpretador Python; TTRL usa voto majoritário test-time.

**Frontier pipelines:** distill-then-RL (cold start via teacher traces), small-warmup multi-stage RL, pure-RL (reduz herança do professor mas aumenta dependência de verificador). O otimizador é a unidade errada de comparação — um ganho reportado é interpretável apenas após declarar suporte de prompt, teacher de trace, substrato, âncora, verificador, scaffold e orçamento de inferência.

### 4. Scaling: Assíntotas no substrato de dados, eficiência no otimizador (Seção 5)

Framework matemático (Khatri et al. 2025, Tan et al. 2026):
- **A** = teto alcançável (ceiling) — movido por: substrato de dados, qualidade do verificador, cobertura de suporte, contexto, arquitetura, topologia de busca
- **B/k** = eficiência de aproximação — movida por: design de loss, amostragem, orçamento de rollout, curriculum, precisão, distilação de warm-start

**Debate RLVR:** Yue et al. (2025) e Wu et al. (2026) leem o RLVR atual como aguçamento de trajetórias já acessíveis à política base (não expansão de fronteira). Contra-literatura: ProRL estende comprimento de horizonte, RL-PLUS injeta rollouts externos, CoT-Pass@K muda a métrica de sucesso.

**Dados únicos vs. reutilização:** D_total = D_unique × τ (Tan et al. 2026). Lança pequenas (LIMO, s1) funcionam quando a base já suporta a habilidade; grandes (OpenThoughts, Big-Math) cobrem regime onde gradients úteis estão na cauda ou múltiplas bases.

**Scaling de verificador:** Verificadores escalam com a política, mas não necessariamente na direção correta — master-key attacks, perturbações GSMSymbolic, verifier-gaming mostram que signals de reward podem ser amplos mas frágeis.

## Key insights

1. **Unidade reutilizável = interface de feedback portando verificador**, não par prompt–resposta. Isso muda como avaliar, construir e escalar datasets.

2. **Dados de agentes devem ser reproduzíveis como episódios** — transcrições limpas de sucesso apagam exatamente os branches (falhas, retentativas, diffs de estado) onde atribuição de crédito é visível.

3. **Linhagem deve ser metadata em nível de amostra** — contamination, teacher traits, decontamination status, verifier version. Release time não é timestamp neutro.

4. **"O otimizador explica o ganho" é a armadilha mais perigosa** — DeepSeek-R1, Kimi K1.5, Qwen3, Magistral, Phi-4, Llama-Nemotron parecem convergir no scaffold RL visível mas divergem upstream em sourcing, trace writing, substrato, âncoras e design de verificador.

5. **Dificuldade como estimativa datada base-condicional** — "dificuldade média" esconde modelo base, formato de prompt, contagem de rollout, temperatura e verificador.

6. **Score de scaling não é auto-explicativo** — pode mover o teto, melhorar velocidade de aproximação, ou mudar a superfície de medição. Esses são claims diferentes.

7. **Âncora de self-play determina o que é treinávelele** — AlphaEvolve é auditável precisamente porque evaluator e evolutionary archive permanecem âncoras explícitas (Novikov et al. 2025).

## Exemplos e evidências

**Datasets e sistemas citados:**
- **DeepMath-103K** (He et al. 2025b) — extração e verificação de regras operacionais
- **DAPO** (Yu et al. 2025) — filtragem por pass-rate (remove grupos com accuracy 0 ou 1)
- **OpenThoughts** (Guha et al. 2025) — ablações de fonte, mistura, filtro, gerador, professor
- **PRM800K** (Lightman et al. 2023) — supervisão de processo com rótulos humanos
- **Math-Shepherd** (Wang et al. 2024) — valores de rollout sem anotação humana
- **OmegaPRM** (Luo et al. 2024) — localização de primeiro erro
- **Skywork-OR1** (He et al. 2025a) — dificuldade estimada contra variantes do modelo
- **Big-Math** (Albalak et al. 2025) — regime de grande pool, cobertura multi-base
- **LIMO / s1** (Ye et al. 2025, Muennighoff et al. 2025) — centenas de exemplos elicitam comportamento forte quando habilidade já está no suporte da base
- **STaR** (Zelikman et al. 2022) — self-play ancorado em respostas externas
- **Absolute Zero** (Zhao et al. 2025a) — usa interpretador Python como âncora
- **TTRL** (Zuo et al. 2025) — voto majoritário test-time como reward
- **AlphaEvolve** (Novikov et al. 2025) — arquivo evolutivo como âncora auditável

**Ataques e falhas documentados:**
- Master-key attacks em LLM-as-judge (Zhao et al. 2025b)
- Perturbações GSMSymbolic em math accuracy (Mirzadeh et al. 2025)
- Subliminal learning — LLMs transmitem traços comportamentais via sinais ocultos nos dados (Cloud et al. 2025)
- Model collapse em treinamento recursivo em dados gerados (Shumailov et al. 2024 — Nature)
- Search-time data contamination (Han et al. 2025)

**Frontiers:**
- DeepSeek-R1, Kimi K1.5, Qwen3, Magistral, Phi-4-reasoning, Llama-Nemotron — convergem no scaffold visível (distill+RL), divergem upstream

## Implicações para o vault

1. **Confirma e enriquece** [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] — adiciona o framework de atribuição baseado em verificador e a distinção ceiling vs. efficiency de scaling.

2. **Enriquece** [[03-RESOURCES/concepts/llm-ml-foundations/generator-verifier-loop]] — o paper trata o verificador como objeto de dados com failure surfaces próprias (não apenas como componente de pipeline). A ideia de co-evolving generators+verifiers (CoVerRL, DeepSeekMath-V2) adiciona a necessidade de versionamento.

3. **Enriquece** [[03-RESOURCES/concepts/llm-ml-foundations/rl-training-llms]] — o debate RLVR (Yue et al. vs. ProRL, RL-PLUS) e a decomposição asymptote-efficiency são contribuições diretas para o cluster de RL scaling.

4. **Enriquece** [[03-RESOURCES/concepts/llm-ml-foundations/synthetic-data-for-agents]] — self-play relocates curation; lineage como metadata; model collapse risk.

5. **Enriquece** [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]] — lista de ataques concretos a verificadores (master-key, GSMSymbolic, spurious rewards de Shao et al. 2026).

6. **Enriquece** [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — dados de trajetória de agente devem ser episódios reproduzíveis; audit fields para agent trajectory (Tabela A3).

7. **Nova contribuição:** Framework de atribuição de 4 perguntas (what objects, what makes useful, how constructed, how scales) é um meta-framework ausente no vault — candidato a conceito próprio `post-training-attribution-framework`.

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]]
- [[03-RESOURCES/concepts/llm-ml-foundations/generator-verifier-loop]]
- [[03-RESOURCES/concepts/llm-ml-foundations/rl-training-llms]]
- [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]]
- [[03-RESOURCES/concepts/llm-ml-foundations/synthetic-data-for-agents]]
- [[03-RESOURCES/concepts/llm-ml-foundations/test-time-scaling]]
- [[03-RESOURCES/concepts/llm-ml-foundations/test-time-compute]]
- [[03-RESOURCES/concepts/llm-ml-foundations/credit-assignment]]
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
