---
title: "Not all Interpretability is mechanistic"
type: source
source: "Clippings/Not all Interpretability is mechanistic.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [articles]
---

## Tese central

Interpretabilidade mecanística (mech interp) é um ramo recente de um campo anos mais antigo — tratar o ramo como a árvore inteira tem custo concreto: você reaprende falhas já conhecidas, importa a validação errada (ou nenhuma), e encolhe a caixa de ferramentas disponível.

## Argumentos principais

- **Mech interp** significa reverse-engineer a computação interna do modelo em algoritmo legível por humano (pesos, ativações, conexões → circuito). O termo é "escorregadio": Saphra e Wiegreffe (2024) catalogam 4 usos, de um técnico estrito (claim causal sobre como componentes internos produzem output) até um puramente cultural (comunidade e suas normas) — é o uso cultural que causa dano, porque relabela todo resultado de interpretabilidade como "mech interp" e apaga distinções que importam.
- **Interpretabilidade não começou com circuitos/neurônios.** Ordem histórica real: feature attribution primeiro (saliency maps, LRP, DeepLIFT, integrated gradients, LIME, SHAP, Grad-CAM) → modelos interpretáveis por design (ProtoPNet, concept bottleneck models) → probing (sondas lineares testando o que representações internas codificam) → counterfactual explanations (menor mudança de input que vira o output) → mech interp por último (circuitos, superposition, sparse autoencoders).
- **A crise da feature attribution já foi vivida e documentada**: Adebayo et al. (2018) "Sanity Checks for Saliency Maps" mostrou que vários métodos de atribuição populares produzem o mesmo heatmap plausível mesmo após randomizar pesos do modelo ou labels — uma explicação que não depende do modelo não está explicando o modelo. Quem entra via mech interp sem ler essa história "redescobre" essa falha do zero (e ela já existe também para SAEs, que falharam testes básicos em 2 papers recentes).
- **Cada tradição tem sua própria validação** — mech interp valida com intervenções causais (activation patching, ablations); attribution tem seus próprios axiomas (completeness, sensitivity, implementation-invariance). Conflar os dois leva a aplicar a ferramenta de validação errada, ou pular validação porque "a imagem parece certa".
- **Taxonomia das 6 famílias**: Attribution (integrated gradients, SHAP, LIME), Probing (linear probes, structural probes), Concept-based (TCAV, concept bottlenecks), Example-based (influence functions, prototype networks), Counterfactual (actionable recourse), Mechanistic (circuits, superposition, SAEs) — cada uma responde perguntas que circuitos não respondem.

## Key insights

- "Quando 'mechanistic' para de nomear um método e começa a nomear uma vibe, todo resultado de interpretabilidade é relabelado como mech interp, e as distinções que importam desaparecem."
- O bom trabalho usa o método que cabe na pergunta — não existe hierarquia onde mech interp é "o" método correto e o resto é preliminar.

## Exemplos e evidências

- Jain & Wallace (2019) "Attention is not Explanation" vs. Wiegreffe & Pinter (2019) "Attention is not not Explanation" — debate documentado sobre faithfulness de attention weights em NLP.
- Concept bottleneck models (Koh et al. 2020) permitem intervenção direta: mudar um conceito previsto muda a predição — explicação é o próprio modelo, não história post-hoc.

## Implicações para o vault

F2.5 Concept Absorption em DOIS conceitos existentes: `[[03-RESOURCES/concepts/llm-ml-foundations/ai-interpretability]]` (campo amplo, recebe a taxonomia completa e o framing "conflação é perigosa") e `[[03-RESOURCES/concepts/llm-ml-foundations/mechanistic-interpretability]]` (ramo específico, recebe a clarificação de escopo/fronteiras vs. resto do campo). Nenhum concept novo necessário — os 2 já existentes cobrem exatamente a dualidade tratada por esta fonte.

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/ai-interpretability]]
- [[03-RESOURCES/concepts/llm-ml-foundations/mechanistic-interpretability]]
