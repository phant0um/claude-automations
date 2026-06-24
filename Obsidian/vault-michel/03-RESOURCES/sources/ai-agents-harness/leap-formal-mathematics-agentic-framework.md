---
title: "LEAP: Supercharging LLMs for Formal Mathematics with Agentic Frameworks"
type: source
source: "Clippings/LEAP Supercharging LLMs for Formal Mathematics with Agentic Frameworks.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central

LLMs generalistas (não especializados) conseguem alcançar performance state-of-the-art em prova formal de teoremas (Lean) — sem nenhum fine-tuning especializado — desde que estruturados por um framework agêntico (LEAP) que decompõe problemas em um DAG hierárquico de blueprints informais + sketches formais, com refinamento iterativo guiado por feedback do compilador Lean. O gargalo de LLMs generalistas em matemática formal não é compreensão da linguagem formal nem raciocínio matemático — é a falta de interação estruturada e iterativa com o ambiente de prova.

## Argumentos principais

- A crença dominante na literatura é que provadores formais precisam de fine-tuning especializado em corpora formais (AlphaProof, DeepSeek Prover V2, Seed Prover, Goedel Prover V2). LEAP desafia essa premissa: usa *apenas* LLMs generalistas (Gemini-3.1-pro) e supera modelos especializados.
- Provas em linguagem natural sofrem de falácias lógicas e alucinações e são caras de verificar — mesmo para matemáticos humanos (ex.: a prova da conjectura de Kepler levou 4 anos de revisão por pares para chegar a "99% de certeza", e depois mais uma década de verificação formal). Linguagens formais (Lean, Isabelle, Coq, HOL Light) oferecem verificação automática garantida via kernel rigoroso.
- LLMs generalistas oferecem capacidades complementares aos provadores especializados: raciocínio informal forte, instruction following, tool use e auto-refinamento — exatamente o que um framework agêntico decomposto e iterativo precisa.
- O design é inspirado no fluxo de trabalho humano de matemáticos: usar a ferramenta "Lean Blueprint" (roadmap legível por humanos, ligado a código Lean, visualizado como DAG), usado em projetos de larga escala como a formalização do Último Teorema de Fermat.
- Outros sistemas agênticos (Hilbert, AlphaProofNexus/sketchprover, Aristotle, Seed Prover V1.5) ainda dependem de modelos especializados para os passos de prova em Lean propriamente ditos — LEAP é o primeiro a remover essa dependência por completo. Axiom e Numina alegam resultados fortes no Putnam 2025 mas são closed-source e cientificamente não-verificáveis.

## Key insights

**Arquitetura LEAP — AND-OR DAG**:
- Cada goal Lean é registrado como um nó OR no DAG. Um "state reader" recupera statement, dependências e lemmas relacionados.
- Tentativa direta primeiro: gera prova informal → traduz para Lean → checa com o compilador.
- Se falha, decomposição: gera blueprint informal propondo lemmas intermediários → traduz para um "proof sketch" em Lean. O sketch prova o goal atual assumindo apenas os lemmas propostos — o corpo do teorema principal é "sorry-free", `sorry` só é permitido nos statements dos lemmas novos propostos.
- Se o sketch é aceito pelo compilador, vira um nó AND, e os lemmas propostos viram novos nós OR filhos. Um "state writer" checa que a atualização preserva acyclicity antes de comitar ao DAG. O agente processa recursivamente os novos subgoals.

**Três design choices interligados**:
1. *Memoização hierárquica via DAG*: lemmas intermediários são nós compartilhados, reusáveis entre branches diferentes (evita re-derivação redundante). Suporta "anticipatory lemma planning" — o agente pode propor lemmas auxiliares não imediatamente necessários mas potencialmente úteis depois, ficando disponíveis na memória do grafo.
2. *Planejamento informal-formal interleaved*: tanto o caminho de prova direta quanto o de decomposição passam por um sketch informal antes da formalização — torna a construção da prova menos frágil que geração direta de código, e mais interpretável (cada tentativa formal vem acompanhada de um racional informal).
3. *Busca guiada por verificação*: dois níveis — (1) o compilador Lean checa correção sintática/de tipos dos sketches e candidatos; (2) um **LLM reviewer** avalia a qualidade da decomposição (lemmas relevantes, simplificam o problema, oferecem rota plausível) antes de comitar ao DAG — atua como filtro de busca, rejeitando decomposições fracas, disparando backtracking. Atualmente LEAP usa DFS simples sobre o DAG com backtracking.

**Lean-IMO-Bench**: novo benchmark de 60 problemas (30 Basic + 30 Advanced, balanceados entre álgebra/combinatória/teoria dos números/geometria), formalizando o IMO-ProofBench (vetado por painel de medalhistas IMO). Diferente de MiniF2F/PutnamBench (mais saturados), foca em statements curtos mas com provas altamente não-rotineiras e multi-step.

## Exemplos e evidências

**Putnam 2025** (12 problemas, top score 110/120, mediana 2): LEAP resolve **100% (12/12)**, igualando breakthroughs recentes (Axiom, Numina). Comparação:
- Gemini-3.1-pro (Pass@128 direto): 0%
- Goedel-Prover-V2-32B (Pass@128 direto): 0%
- Hilbert (rollout=2): 33.3% (4/12) — limitado a 7 dias de rollout por causa de complexidade exponencial O((n·b)^d), d=10
- Aristotle (closed-source, rollout=2): 75% (9/12)
- **LEAP (rollout=2): 100% (12/12)**

Custo computacional varia muito por problema: de 46 chamadas LLM (b2) a ~3.000 (a5); proof length de 300 a ~2.000 linhas Lean.

**Lean-IMO-Bench**: LEAP atinge **83.3% no Basic set e 56.7% no Advanced set** — overall solve rate, superando Aristotle (76.7% Basic / 20% Advanced) e Hilbert (36.6% / 6.6%). LEAP mantém **100% solve rate em Álgebra e Teoria dos Números em ambos os tiers**. Geometria fica perto de zero para todos os métodos — dificuldade conhecida de formalizar geometria olímpica em Lean sem frameworks específicos.

**Ablation — review LLM da decomposição**: focado no problema mais difícil (Putnam A5, mais rollouts e maior runtime). Removendo o reviewer LLM, o agente falha mesmo após 8 rollouts — o reviewer rejeita decomposições "formalmente admissíveis mas semanticamente vazias" (ex.: um lemma proposto que é sintaticamente idêntico ao goal original, causando loop improdutivo até esgotar o budget de busca).

**Ablation — memoização DAG**: variante "tree" (sem compartilhamento global de lemmas) já supera Hilbert (73.3%/40.0% vs 36.6%/6.6%), mostrando que planejamento informal-formal interleaved + busca guiada por verificação já são fortes sozinhos. O DAG completo melhora ainda mais para 83.3%/56.7% — ganho mais pronunciado em categorias avançadas (Algebra/Number Theory), onde lemmas compartilhados e contexto de grafo importam mais.

**One-shot vs. iterativo** (Lean-IMO-Bench Basic): Gemini-3.1-pro melhora de 20.0% (Pass@128 one-shot) para 36.6% (Pass@1 iterativo, até 20 revisões via compiler feedback) — Goedel-Prover-V2-32B não se beneficia do feedback loop (10.0% → 6.6%), sugerindo que formalização iterativa depende de capacidades além da síntese local de prova Lean (interpretar erros do compilador, manter contexto, revisar ao longo de múltiplos passos).

**Case studies de pesquisa** (problemas abertos/recém-resolvidos):
- *Hamiltonian decomposition de Cayley graphs direcionados* (problema posto por Donald Knuth): LEAP decompôs uma prova informal de ~20 páginas (mapas piecewise densos, intervalos dependentes de paridade, transições cross-row complexas) em um grafo de prova granular, sintetizando **mais de 5000 linhas de Lean 4** para verificar formalmente uma subprova crítica (routing dynamics de uma classe de cor formando ciclo de comprimento m²).
- *Erdős Problem 457* (densidade de grafos triangle-free, já resolvido): LEAP reconstruiu e verificou autonomamente a prova conhecida do zero em Lean 4, demonstrando capacidade de traduzir literatura existente para provas formais de alta confiança sem intervenção humana.

## Implicações para o vault

- LEAP é um exemplo concreto e mensurável do padrão "general-purpose model + scaffolding agêntico > modelo especializado fine-tuned" — relevante para [[03-RESOURCES/concepts/agent-systems/agentic-world-modeling]] e discussões sobre quando vale a pena especializar vs. orquestrar.
- O padrão AND-OR DAG com memoização hierárquica + LLM reviewer como filtro de busca é uma instância concreta de "verification-guided proof/plan search" — relacionável a [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] (decomposição de tarefas em subgoals com critérios de aceitação, análogo ao "Break It Down" de [[03-RESOURCES/sources/10-claude-code-subagents-kept]], mas aqui o "compilador" faz o papel de verificador formal).
- A lição do ablation (decomposição "formalmente válida mas semanticamente vazia" causa loop infinito sem reviewer) é um caso concreto do problema geral de "self-check sem critério semântico não detecta circularidade" — relevante para qualquer pipeline do vault que use self-review/self-correction loops.
- Não há overlap direto com FIAP/concurso, mas o conceito de "blueprint DAG com memoização" pode inspirar a estrutura de planos de estudo complexos com dependências entre tópicos.

## Links
- [[03-RESOURCES/concepts/agent-systems/agentic-world-modeling]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/sources/10-claude-code-subagents-kept]]
