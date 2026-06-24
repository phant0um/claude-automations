---
title: "Self-Revising Discovery Systems for Science: A Categorical Framework for Agentic Artificial Intelligence"
type: source
source: "Clippings/Self-Revising Discovery Systems for Science A Categorical Framework for Agentic Artificial Intelligence.md"
url: "https://arxiv.org/html/2606.01444v1"
authors: ["Fiona Y. Wang", "Markus J. Buehler"]
institution: "MIT — Laboratory for Atomistic and Molecular Mechanics"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents, category-theory, scientific-discovery, multi-agent-systems, world-model, self-revising-systems, paper]
---

# Self-Revising Discovery Systems for Science: A Categorical Framework for Agentic Artificial Intelligence

**Autores:** Fiona Y. Wang, Markus J. Buehler (MIT)
**ArXiv:** 2606.01444

## Tese central

Descoberta científica não é apenas geração de respostas dentro de um vocabulário fixo — é a **revisão do regime representacional** em que evidência, artefatos, operações e verificadores são tipados. Os autores constroem uma fundação categórica (category theory) para sistemas agênticos de descoberta científica, formalizando a diferença estrutural entre **retrieval** (adicionar artefato já representável), **search** (encontrar novo caminho dentro de um schema fixo) e **discovery** (mudar o regime/schema em que artefatos e operações são tipados — novo tipo efetivo, nova operação admissível, novo verificador, nova ferramenta).

## Argumentos principais

1. **Sistemas agênticos de descoberta são "typed artifact systems"**. O estado persistente não é um transcript de conversa, vetor latente, ou checkpoint único — é um registro crescente de artefatos tipados (dados, simulações, modelos, hipóteses, código, medições, relatórios, críticas, decisões) com proveniência explícita. Tipagem não é overhead burocrático: é o que distingue uma claim científica de uma resposta fluente.

2. **Cinco componentes recorrentes** em qualquer sistema de descoberta agêntico:
   - Schema de tipos de artefato e operações (morfismos)
   - População de artefatos sobre esse schema
   - Grafo de proveniência (cada artefato aceito registra pais + operação que o produziu)
   - Gate/verificador (MDL, pressure scoring, schema overlap, peer review, community feedback)
   - Mecanismo de regime-update (quando evidência não cabe no schema atual, o sistema deve estender/revisar schema, gramática, verificador ou registro de ferramentas)

3. **Estado de artefatos como copresheaf**. Formalmente, o estado científico no tempo *t* é um functor covariante $I_t: \mathcal{S}_b \to \mathbf{Set}$ sobre uma categoria-schema $\mathcal{S}_b$ (objetos = tipos de artefato, morfismos = operações permitidas). A proveniência realizada é a **categoria de elementos** $\int_{\mathcal{S}_b} I_t$ — não é uma metáfora, é literalmente o grafo de proveniência tipado.

4. **Updates de regime fixo são endofunctoriais sob hipóteses explícitas**. Um update $\Phi_b$ dentro de um regime fixo lê a população de artefatos atual, seleciona operações compatíveis, propõe novos artefatos, aplica um gate, e retorna a próxima população. Para ser um endofunctor genuíno (não apenas um endomap), $\Phi_b$ precisa preservar **morfismos de refinamento** — i.e., se um estado A estende um estado B adicionando artefatos verificados sem sobrescrever proveniência prévia, o update de A deve estender o update de B da mesma forma. Isso traduz um requisito de engenharia familiar: refatorar um pipeline não pode quebrar workflows válidos antigos. Em código, isso vira um **audit contract**: IDs de artefato estáveis, assinaturas tipadas de tool/skill, lineage explícito de pais, semântica append-only ou supersession explícita, status records para chamadas falhas/retried, sem merge/delete silencioso de artefatos aceitos.

5. **Discovery é transição de regime verificada, não apenas iteração**. Seja $u: \mathcal{S}_b \to \mathcal{S}_{b'}$ um mapa de schema (old → new). O estado antigo é transportado para o novo schema via **left Kan extension** $\operatorname{Lan}_u I_t$. Para um tipo novo $A'$ que não recebe morfismos da imagem de $u$, a categoria comma indexando o colimit é vazia → $(\operatorname{Lan}_u I_t)(A') = \varnothing$ — **transporte puro não consegue popular tipos isolados novos**. Uma transição de descoberta = transporte + estado pós-transição verificado contendo evidência nova, artefatos novos, resultados novos de verificador, ou produções gramaticais novas não explicadas por transporte.

6. **Quantificação do "quanto de descoberta ocorreu"**. Dado um mapa de comparação $\bar\rho: \operatorname{Lan}_u I_t \to I'_{t+1}$ (via adjunção $\operatorname{Lan}_u \dashv u^*$), a imagem de $\bar\rho$ é o "transported-evidence substate". Artefatos fora dessa imagem são o conteúdo empírico/representacional que o sistema teve que adquirir além da reinterpretação funtorial de evidência antiga. Quando o novo regime carrega um funcional de description-length relativo $L_{b'}$, o **custo de descoberta** = bit budget $L_{b'}(I'_{t+1} \mid \operatorname{im}(\bar\rho))$ necessário para especificar o estado pós-transição dado a evidência transportada.

7. **Generalização do knowledge graph científico**. Um knowledge graph convencional fixa $\mathcal{S}_b$, esquece gates/discourse/regime-transitions, e vê a proveniência só como entity-relation graph. O framework dos autores (knowledge–computation graph $\mathfrak{K}_t^b$) inclui adicionalmente: gate/verifier $V_b$, funcional MDL $L_b$, categoria de discurso $\mathsf{D}_t$ (claims, posts, evidência, objeções, replicações), e mapa de publicação $\pi_t$. É um estado científico **executável, verifier-aware, provenance-preserving**.

## Key insights

- **Discovery muda o mundo, mas não apaga o passado**: artefatos antigos persistem como evidência transportada, com proveniência auditável preservada — o que muda é o regime em que essa evidência pode ser representada e composta.
- A distinção retrieval vs search vs discovery não depende de "novidade subjetiva" — é estrutural e categórica: retrieval adiciona ao schema existente; search itera dentro do schema; discovery muda o schema.
- Reading via Lema de Yoneda: um artefato $x \in I_t(A)$ é conhecido pelas operações tipadas em que pode participar e os artefatos downstream que essas operações produzem — "an artifact is known by what can be done with it."
- Em sistemas reais, $\Phi_b$ pode ser estocástico (agentes amostram, ferramentas falham, schedulers ramificam, feedback humano assíncrono) → deve ser lido como relação/kernel estocástico/morfismo em categoria de Kleisli para um monad de probabilidade apropriado.

## Exemplos e evidências

### Builder/Breaker (protein-mechanics, MDL gate)

Sistema quantitativo: o **Breaker** escolhe novas proteínas para expor falhas do modelo simbólico atual; o **Builder** propõe edits ao DAG simbólico; um **gate de Minimum Description Length (MDL)** aceita um candidato apenas se reduz o description length total após refit pareado:

$$L(M,D) = L_{\text{model}}(M) + L_{\text{data}}(D \mid M)$$

Critério de aceitação: $L(M', D \cup E) < L(M, D \cup E)$ — a lei revisada precisa comprimir o conjunto de evidência aumentado melhor que o modelo anterior, **ambos refit na mesma evidência** (não é uma sequência monótona de R² — é um teste pareado por iteração).

A lei aceita final ("**mode-conditioned compliance**") expressa flexibilidade de proteína como:

$$\hat{B}^{(z)}_{pi} = \alpha + \beta \cdot \phi_{pi}\psi_{pi}$$

onde $\phi_{pi}$ = log-compliance normalizada (compressão local, derivada do pseudoinverso da matriz de Kirchhoff GNM) e $\psi_{pi}$ = participação no modo coletivo mais lento (com ReLU shift). Valores ajustados: $\alpha=-0.1332$, $\beta=0.2239$, $\theta=2.2678$.

O evento de descoberta categórico chave: o schema admite uma **nova operação multi-input (produto)**:
$$\texttt{LogNormCompliance} \times \texttt{ReLUModeAmpl} \to \texttt{ModeConditionedCompliance}$$
— alvo composite-reachable a partir de quantidades físicas antigas **somente após** o novo regime admitir transformações unárias + operação de produto. Isso não é "usar um novo objeto isolado"; é uma transição de regime que adiciona um morfismo composto.

Trajetória empírica em 4 iterações: Iteração 0 (modelo local mínimo em proteínas compactas) → Iteração 1 (estrutura de borda/modo lento, +9.0 bits) → Iteração 2 (regime hinge/domain-motion via adenylate kinase 4AKE/1AKE como stress test canônico, +37.3 bits, reorganiza o DAG) → Iteração 3 (consolidação na lei multiplicativa final, +54.3 bits).

### CategoryScienceClaw

Camada categórica sobre **ScienceClaw × Infinite**: registro extensível de skills científicas tipadas, artefatos imutáveis com lineage de pais, "open needs" rankeados por pressão, coordenação plannerless, mutação de workflow, discurso público estruturado (posts, hipóteses, métodos, findings, votos, comentários, reputação, moderação). Exemplo de fiber-network: registra modelos candidatos, alternativas rejeitadas, gate AIC, testes de perturbação, e um "orientation-tensor anisotropic stiffness surrogate" aceito sobre um descritor isotrópico de fiber-count — model selection (incluindo a alternativa rejeitada) é gravado como proveniência tipada.

## Implicações para o vault

1. **Modelo formal para agent-memory-architecture / world-model**: o framework copresheaf + categoria de elementos dá um vocabulário rigoroso para o que o vault já faz informalmente (artefatos tipados, lineage, gates de aceitação). Útil como referência ao desenhar `04-SYSTEM/agents/` que precisam revisar seu próprio "schema" (skills, formatos, convenções).
2. **Audit contract = invariant protection do CLAUDE.md**: a exigência de "refinement morphisms preservados" (IDs estáveis, lineage explícito, append-only/supersession explícita, sem merge silencioso) é exatamente o espírito das seções `[INVARIANT]` e do princípio "surgical changes" do vault.
3. **MDL gate como modelo para self-improvement**: a lógica "aceitar revisão só se comprime evidência acumulada melhor que a anterior, ambas refit na mesma evidência" é um critério mais rigoroso que "parece melhor agora" — aplicável a `04-SYSTEM/wiki/errors.md` e ciclos de hill/extend (uma skill nova só deveria substituir a antiga se explica os casos de falha acumulados E os antigos sem regressão).
4. **Discovery vs search vs retrieval** mapeia diretamente para níveis de autonomia do vault: ingest = retrieval; reorganização dentro de `03-RESOURCES/` = search; criar uma nova categoria/space ou mudar convenções de `CLAUDE.md` = discovery (requer confirmação explícita, conforme regras de "Large restructures").

## Links

- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/llm-ml-foundations/world-model-l1-l2-l3]]
- [[03-RESOURCES/concepts/agent-systems/halo-harness-self-optimization]]
- [[03-RESOURCES/concepts/agent-systems/spec-driven-development]]
