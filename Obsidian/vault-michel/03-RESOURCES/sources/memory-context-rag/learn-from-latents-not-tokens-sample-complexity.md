---
title: "Learn from your own latents and not from tokens: A sample-complexity theory"
type: source
source: "Clippings/Learn from your own latents and not from tokens A sample-complexity theory.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [articles]
---

## Tese central

Modelos generativos (LLMs, difusão) atingem performance impressionante mas custam ordens de magnitude mais dados que aprendizes biológicos. Uma família alternativa de métodos — auto-supervisão preditiva sobre as próprias representações latentes (data2vec, JEPA, BYOL, DINO), em vez de reconstrução do sinal bruto (tokens/pixels) — oferece ganhos *exponenciais* de eficiência amostral em dados com estrutura hierárquica latente, e arquiteturas que já fazem isso de forma single-scale (como data2vec) provavelmente já capturam implicitamente o benefício de empilhamento multi-escala (H-JEPA), tornando esse empilhamento explícito largamente redundante.

## Argumentos principais

- LLMs de fronteira treinam com 10^13–10^14 tokens, mais de 5 ordens de magnitude além do que uma criança encontra antes de atingir competência adulta — sugerindo que pré-treino a nível de token está longe do ótimo.
- Duas hipóteses concorrentes para essa lacuna: (1) aprendizado biológico é multimodal e fundamentado (grounded); (2) aprendizado pode ser mais eficiente em um espaço latente mais abstrato do que nos tokens brutos — esta é a hipótese perseguida pelo paper.
- A ideia de "predizer as próprias latentes" (em vez de reconstruir input) se relaciona a predictive coding em neurociência computacional (o córtex tentaria predizer sua própria atividade futura) e já é usada empiricamente por BYOL, DINO, data2vec e JEPA — mas o **porquê** e o **quanto** essa abordagem melhora eficiência de dados não tinha teoria rigorosa até este trabalho.
- Uma segunda questão em aberto era se empilhar esses métodos em hierarquias multi-escala (H-JEPA) traz benefício real — implementações recentes mostram apenas ganhos modestos, por razões não claras. Este paper também endereça essa questão.
- Para tornar o problema tratável, os autores usam o **Random Hierarchy Model (RHM)** — uma gramática probabilística livre de contexto (PCFG) simplificada, com topologia de árvore fixa e regras de produção aleatórias, que gera strings de tokens visíveis recursivamente a partir de uma árvore de símbolos latentes de profundidade L. RHM já produziu teorias quantitativamente preditivas (scaling laws de linguagem natural, generalização composicional em modelos de difusão).

## Key insights

**Baseline conhecido (trabalhos anteriores)**: para arquiteturas profundas em dados RHM —
- Aprendizado supervisionado end-to-end requer ordem de **m^L** amostras (m = número de regras de produção por símbolo, L = profundidade da árvore latente)
- Objetivos SSL a nível de token (masked-language modeling, difusão) requerem ordem de **m^(L+1)**
- Ambos crescem **exponencialmente** com a profundidade L da hierarquia latente (logo, polinomialmente no comprimento da sequência/dimensão de input)

**Três resultados centrais deste paper**:

1. **Algoritmo eficiente de representation learning** (Seção 3): um algoritmo de clustering hierárquico recupera a árvore latente completa (não-raiz) a partir de ordem **m^3** amostras — independente da profundidade L, portanto exponencialmente mais eficiente que SSL a nível de token.

2. **Arquitetura end-to-end empilhada com a mesma escala** (Seção 4): uma nova arquitetura — pilha de pequenos módulos "predictor-clusterer" que predizem suas próprias latentes em cada nível — treinada end-to-end via gradiente descendente, atinge a mesma escala m^3 no RHM (chamada SLC network no paper).

3. **Teoria de data2vec** (Seção 5): primeira análise de sample-complexity desse tipo de método — mostram empírica e teoricamente (sob suposições razoáveis) que data2vec **implicitamente já realiza predição hierárquica de latentes multi-escala**, atingindo também sample complexity de ordem m^3.

**Implicação central**: aprender a partir das próprias latentes pode gerar ganhos *enormes* de sample-complexity sobre objetivos a nível de token (m^3 vs. m^(L+1) — para L grande, a diferença é exponencial). E como um único módulo de predição de latentes (data2vec) já parece fazer descoberta hierárquica multi-escala implicitamente, isso **enfraquece o argumento para empilhamento explícito** como em H-JEPA.

## Exemplos e evidências

- O gap empírico de dados: LLMs treinam em ~10^13–10^14 tokens vs. o que uma criança ouve antes de competência linguística adulta de nível adulto — diferença de >5 ordens de magnitude (citando literatura de aquisição de linguagem: Gilkerson et al. 2017, Linzen 2020, Frank 2023).
- RHM (Cagnetta et al., Physical Review X 2024) é citado como tendo já produzido relações entre scaling laws de redes neurais e estatísticas de linguagem natural, e teoria de generalização composicional/memorização em modelos de difusão para linguagem e imagens — ou seja, é um modelo sintético com histórico de validação empírica em deep nets reais.
- A figura 1 do paper ilustra o mecanismo central: a sample complexity P para aprender a invariância sinonímica de correlações entre um alvo de predição (Z) e seu contexto (T) escala como **m^(d_tree)**, onde d_tree é a distância na árvore entre os dois — supervisão em latentes (algoritmo ILC dos autores, rede SLC, e data2vec) atinge a melhor escala possível, ~m^3, enquanto SSL a nível de token é gargalado pelas correlações mais fracas (distâncias maiores na árvore).
- H-JEPA (empilhamento explícito de JEPA) foi proposto há anos (LeCun 2022) e implementado recentemente (HiT-JEPA 2025, hierarchical JEPA para redes 5G 2026) com "ganhos no máximo moderados, por razões que permanecem pouco claras" — este paper oferece uma explicação teórica para essa observação empírica.

## Implicações para o vault

- Não há overlap direto com agentes/Claude Code/FIAP — esta é uma fonte de ML theory pura (self-supervised learning, sample complexity), categorizada como "articles".
- Relevante como background teórico caso o vault aprofunde tópicos de "data efficiency" ou "world models" em IA — conecta-se conceitualmente (mas não foi linkado por ausência de concept equivalente no vault) a ideias de representação hierárquica e predictive coding que aparecem en passant em discussões de agentic world modeling.
- Nenhum concept/entity novo foi criado: o tema (JEPA/data2vec/sample-complexity teórica) não tem presença recorrente no vault hoje; criar um concept novo seria prematuro para uma única fonte teórica isolada.

## Links
- (sem wikilinks diretos — tema isolado no vault no momento da ingestão)
