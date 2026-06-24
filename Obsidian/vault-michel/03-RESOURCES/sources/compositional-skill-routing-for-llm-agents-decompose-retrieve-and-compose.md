---
title: "Compositional Skill Routing for LLM Agents: Decompose, Retrieve, and Compose"
type: source
source: "Clippings/Compositional Skill Routing for LLM Agents Decompose, Retrieve, and Compose.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
LLM agents cada vez mais dependem de skills externas (especificações reutilizáveis de ferramentas), mas tarefas reais frequentemente exigem *compor* múltiplas skills, não apenas selecionar uma. O paper formaliza isso como "Compositional Skill Routing": dado uma query complexa e uma biblioteca grande de skills, decompor em subtarefas atômicas, recuperar a skill apropriada para cada subtarefa, e compor um plano executável (DAG). O achado central — via o framework SkillWeaver e o benchmark CompSkillBench (2.209 skills reais do ecossistema MCP) — é que a qualidade da decomposição da tarefa, não a retrieval em si, é o gargalo primário: decomposição LLM padrão atinge só 34,2% de category recall no nível de step.

## Argumentos principais
- **Formalização do problema**: dado biblioteca de skills S = {s1,...,sN} (cada skill = nome, descrição, corpo de especificação, categorias funcionais), e query complexa q, produzir (1) decomposição D(q) = [t1,...,tK] de subtarefas atômicas, (2) atribuição σ mapeando cada subtarefa a uma skill, (3) plano de execução (DAG) especificando dependências entre steps.
- **SkillWeaver — 3 estágios**: (1) **Decompose** — LLM instruction-tuned produz lista ordenada de subtarefas atômicas, cada uma exigindo exatamente uma skill; (2) **Retrieve** — bi-encoder (all-MiniLM-L6-v2, 384-dim) recupera top-m candidatos por subtarefa via similaridade de cosseno, indexado com FAISS para busca exata por produto interno; comparam representação metadata-only vs. body-aware (corpo da especificação truncado em 2000 chars); (3) **Compose** — seleciona atribuição final combinando relevância de retrieval com compatibilidade entre steps (coerção de tipo I/O, Jaccard de categoria, co-ocorrência de keywords), com α=0.5 controlando o trade-off (robusto no intervalo [0.3, 0.7]).
- **SAD — Skill-Aware Decomposition**: insight chave é que decompositores LLM produzem descrições genéricas mal alinhadas com metadados de skill. SAD é um procedimento iterativo de ponto fixo — decompõe, recupera candidatos para cada subtarefa, constrói um conjunto de "hints" a partir dos top-H candidatos agregados, e re-decompõe condicionado nesses hints. Convergência é garantida formalmente (espaço finito de hint sets) e na prática uma iteração já é suficiente.
- **CompSkillBench**: primeiro benchmark dedicado a routing composicional. Construído a partir do registro público awesome-mcp-servers (2.228 entradas → filtragem de qualidade → deduplicação → 2.209 skills únicas mapeadas em 24 categorias funcionais canônicas a partir de 49 tags finas). 300 queries em 3 níveis de dificuldade: Easy (150, 2 skills/2 categorias), Medium (100, 3 skills/3 categorias), Hard (50, 4-5 skills/4-5 categorias).
- **Métricas em 3 granularidades**: nível de step (Skill Recall@k, Category Recall@k — métrica relaxada já que skills da mesma categoria são frequentemente intercambiáveis), nível de cadeia (Chain Exact Match, Chain Category Match), e Decomposition Accuracy (DA — fração de queries onde o número predito de subtarefas casa exatamente com o ground truth; métrica estrita — uma decomposição com 1 step extra válido ainda recebe DA=0).
- **Achado central — decomposição é o gargalo**: LLM decomposition padrão atinge apenas 34,2% CatR@1 sobre pool de 2.209 skills reais. Análise condicionada a DA confirma que granularidade correta de decomposição (número certo de steps) é o fator limitante primário — CatR@1 sobe para 41,2% quando DA=1.
- **SAD fecha boa parte do gap**: melhora DA de 51,0% para 67,7% (+32,7%, estatisticamente significativo, p<10⁻⁶) numa única iteração. O gap remanescente de CatR@1 (37% vs. teto de 72% @10) é parcialmente fechado por um reranker LLM-listwise piloto (+10,3% relativo @1, p<0.01) — transformando o que seria "trabalho futuro" (cross-encoder reranking) numa alavanca já validada empiricamente.
- **Metadados bastam para retrieval**: encoding metadata-only atinge CatR@10 de 69,0% — descrições concisas de skill já carregam sinal discriminativo forte mesmo sobre pool de 2.209 skills, sem precisar do corpo completo da especificação.
- **SAD generaliza para skills não vistas**: ganho relativo de DA de +35,6% mesmo com categorias held-out completamente ausentes do pool de retrieval, e +23,2% com skill held-out aleatório — confirma que o método aprende a nível de vocabulário, não memoriza skills específicas.
- Validação de viabilidade end-to-end via estudo piloto de execução (não avaliação controlada formal): planos roteados por SAD atingem 76,7% de taxa de conclusão de cadeia.

## Key insights
- O insight mais contraintuitivo e útil é a *direção* do feedback em SAD: métodos clássicos de retrieval-augmented generation (Self-RAG, ReAct, Reflexion) alimentam evidência recuperada na etapa de *geração/ação* (output-side), refinando o que o modelo produz dado um plano fixo. SAD alimenta skills recuperadas de volta no *input da decomposição* (input-side) — corrigindo a granularidade do plano *antes* da retrieval ser finalizada. Isso é estruturalmente mais difícil (exige revisar o plano a partir de overlap parcial de keyword com candidatos imperfeitos de Pass-1) mas é precisamente adequado ao gargalo identificado (granularidade de decomposição, não qualidade de geração).
- Decomposition Accuracy é uma métrica deliberadamente estrita — uma decomposição "melhor que o ground truth" (com um step intermediário válido extra) ainda é penalizada com DA=0, forçando o sistema a casar a granularidade exata esperada, não só a cobrir os mesmos passos de forma diferente.
- O problema de skill routing composicional é estruturalmente diferente de tool selection single-skill (SkillRouter) ou de toolset filtering flat (CRAFT) — exige cadeias ordenadas multi-skill com dependências, e nenhum trabalho anterior otimiza conjuntamente granularidade de decomposição, retrieval e compatibilidade entre skills.

## Exemplos e evidências
- Pool de skills real: 2.209 skills do ecossistema público MCP (10.000+ servidores registrados no protocolo), distribuídas em categorias como Developer Tools (357), Finance (270), Integrations (229), Knowledge Mgmt (180), Search/Extraction (140), Security (122).
- Exemplo motivador citado no paper: query "Download the dataset, transform it, and create visual reports" exige 3 skills de categorias distintas (api-client, csv-parser/etl-pipeline, chart-gen/dashboard) — caso canônico de roteamento single-skill insuficiente.
- Query construction usa frases-verbo específicas de categoria (ex: "query the database", "send a notification") que não copiam diretamente nomes/descrições de skill — garante que sucesso de retrieval exige matching semântico genuíno, não overlap lexical.

## Implicações para o vault
Atualiza [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] com um benchmark concreto sobre o ecossistema MCP real (2.209 skills) e conecta diretamente com [[03-RESOURCES/concepts/agent-systems/skill-authoring]] e [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — fornece evidência quantitativa de que, conforme bibliotecas de skill crescem (MCP já tem 10k+ servidores), a decomposição de tarefa — não a busca/retrieval — se torna o gargalo dominante. Relevante também para quem desenha skill libraries no próprio vault (`04-SYSTEM/skills/`): a confirmação de que "metadata-only" retrieval já captura a maior parte do sinal discriminativo é argumento a favor de manter descrições de skill concisas e bem escritas em vez de depender do corpo completo.

## Links
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/agent-systems/skill-authoring]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
