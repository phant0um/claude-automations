---
title: "Paving the way for agents in biology"
type: source
source: "Clippings/Paving the way for agents in biology.md"
url: "https://www.anthropic.com/research/agents-in-biology"
author: "[[03-RESOURCES/entities/anthropic]]"
published: 2026-06-08
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
paper: "https://arxiv.org/pdf/2606.06749"
---

## Tese central

Para que agentes de IA sejam úteis em biologia (descoberta científica, resposta a surtos), a infraestrutura de dados biológicos precisa ser redesenhada para agentes — hoje ela é "uma cidade antiga construída antes dos carros": cheia de formatos de arquivo idiossincráticos, bancos de dados espalhados e scripts de retrieval avulsos. Como estudo de caso, a Anthropic e colaboradores testaram agentes científicos (Claude, Biomni, Edison Analysis, GPT) recuperando dados de sequência da NCBI Virus. Mesmo os modelos mais fortes não atingiram consistentemente a precisão necessária — mas a precisão subiu para quase 100% ao adicionar **gget virus**, uma camada de retrieval determinística. A lição: camadas de retrieval determinísticas são (atualmente) cruciais para tornar workflows de agentes confiáveis, e bancos de dados biológicos precisarão ser desenhados pensando em agentes como usuários em escala.

## Argumentos principais

- **Analogia central — "cidade antiga vs. cidade feita para carros"**: infraestrutura de software foi basicamente feita para as necessidades de agentes (controle de versão, APIs bem documentadas, gerenciadores de pacotes — "estradas pavimentadas, faixas claras, sinais padronizados"). Infraestrutura de biologia computacional é frágil, heterogênea, dependente de processo — "ruas estreitas e sinuosas".
- **Por que agentes de código avançaram mais rápido que agentes de biologia**: software fornece outputs testáveis que podem ser compilados/validados rapidamente (ex.: resolver issue do GitHub gerando patch que passa nos testes do projeto). Biologia oferece poucas recompensas simples e verificáveis, porém significativas.
- **O gargalo não é só raciocínio — é a ausência de camadas de execução determinística** para consultar dados biológicos. Um cientista pode expressar intenção (ex.: "encontre todas as quinases humanas com este domínio e traga suas estruturas"), mas agentes frequentemente não têm forma confiável de acessar os bancos de dados que contêm essa informação.
- **Erros pequenos têm consequências severas em biologia**: pegar coordenadas do genoma errado, misturar registros RefSeq e GenBank sem intenção, tratar genomas parciais como completos, confundir nomes de segmentos em vírus segmentados, ou perder registros relevantes por campos de metadados inconsistentes — tudo isso pode invalidar a interpretação biológica posterior.
- **Conexão com a palestra de Karpathy sobre dev web**: Karpathy fez vibe-coding de um app web, mas ao tentar torná-lo real (auth, pagamentos, deploy) perdeu uma semana clicando em dashboards de browser. "O código foi a parte mais fácil! A maior parte do trabalho foi no browser, clicando coisas." Conclusão dele: precisamos construir para agentes. Pesquisadores de biologia computacional já enfrentam essa fricção há muito tempo.
- **"Click tax" em virologia**: instruções de curadoria de datasets para NCBI Virus circulam como longas listas de filtros complexos que usuários devem reproduzir manualmente na interface web — exatamente o tipo de workflow de "clicar no browser" que Karpathy reclamava.
- **Mesmo com API, pode ser difícil para agentes**: se a API não expõe a mesma semântica de filtros da interface web, se campos de metadados são mal documentados ou inconsistentes, se identificadores mudam entre fontes, ou se "a resposta certa" depende de convenções que humanos especialistas sabem mas máquinas precisam inferir.
- **Solução proposta — gget virus**: ferramenta desenvolvida em colaboração com a NCBI que coordena REST, Datasets e E-utilities APIs; decide quais filtros podem ser aplicados via APIs existentes vs. quais precisam ser checados localmente; faz batching para grandes result sets (SARS-CoV-2, Influenza A) sem cortar arbitrariamente; quando um filtro depende de informação em outro banco (ex.: registros GenBank indicando se a sequência contém certa proteína viral), retrieva esses registros e preserva a informação relevante no output final; retorna outputs padronizados legíveis por humanos e máquinas, com logs detalhados mostrando como o resultado final foi produzido.
- **"Adicionar uma camada de retrieval determinística torna a escolha do modelo muito menos importante"** — accuracy subiu acima de 90% para todos os agentes (pico de 99.7% para GPT-5.5), e a variabilidade run-to-run foi praticamente eliminada. Implicação: dataset construction confiável não precisa depender do modelo mais novo/caro.
- **Visão de longo prazo / contraponto**: se a curva de capacidade dos modelos continuar, é fácil imaginar um futuro próximo onde o benefício de ferramentas como gget virus se aproxima de zero — agentes ficam bons o suficiente para navegar portais bagunçados, reconciliar identificadores, paginar corretamente e se recuperar de falhas sozinhos. Mas mesmo que um agente consiga fazer isso, não significa que a tarefa deva ser feita (e reinventada) por um agente toda vez — pode ser caro demais, lento demais, difícil de auditar ou de confiar para trabalho científico rotineiro.

## Key insights

- **VirBench**: novo benchmark com 120 queries realistas de sequências virais cobrindo 40 patógenos, com contagens ground-truth verificadas manualmente. Reflete tarefas de vigilância viral, design de ensaios diagnósticos e construção de dados de treino para modelos de proteína.
- **Resultados sem gget virus**: Claude Sonnet 4, Claude Opus 4.7, Biomni, Edison Analysis, GPT-5.2-pro e GPT-5.5 atingiram acurácias médias entre **16.9% e 91.3%**. A barra efetiva é ~100% (um registro faltante/incorreto pode mudar se um ensaio diagnóstico cobre a diversidade circulante, ou se um surto começou semanas antes/depois do que ocorreu).
- **Problema de reprodutibilidade**: o mesmo modelo produziu respostas substancialmente diferentes quando a mesma pergunta foi feita três vezes. Para a query de exemplo de Ebolavirus (TaxID 3052462, ZEBOV, host humano, África, coletado entre 01/01/2014–06/20/2014, ≥15.200 bases, ≤1.900 N's, excluindo lab-passaged), Sonnet 4 retornou 106 sequências numa run (esperado: 266), 15 numa segunda, e 5 numa terceira — com prompt idêntico.
- **Impacto em análise filogenética (TMRCA)**: árvore construída de dataset curado manualmente recuperou TMRCA de janeiro de 2014 (consistente com literatura, 95% HPD 27/jan–14/mar). Duas das três runs do Sonnet 4 produziram árvores visivelmente incompletas — uma empurrou o TMRCA inferido para 1922; a run 1 (que parecia plausível) falhou em recuperar sequências da Guiné e mudou o TMRCA estimado para abril de 2014.
- **Impacto em terapêuticos**: ao examinar epítopos ligados pelos anticorpos maftivimab e MBP134 (candidatos de tratamento prioritários da OMS para o surto atual de Bundibugyo), sequências da run 1 do Sonnet 4 chegaram perto dos resultados de query manual; na repetição, perdeu a maioria dos resíduos mutados; na terceira run, destacou um conjunto diferente de resíduos — três impressões diferentes de variabilidade nas regiões-alvo.
- **Padrão de falha**: agentes subcontaram quando falharam em recuperar grandes result sets, e supercontaram quando filtros foram aplicados incorretamente. Maiores desvios ocorreram em vírus com muitos registros disponíveis (Influenza A, HIV-1, SARS-CoV-2). Performance degradou conforme queries ficaram mais complexas, especialmente além de 3-4 filtros simultâneos.
- **GPT-5.5 descobriu gget virus sozinho**: em 1 de 360 runs (Query 32, terceira repetição), GPT-5.5 identificou e usou gget virus por conta própria, sem ser explicitamente instruído — e foi a única run dessa pergunta que produziu a resposta correta.
- Citação de Nils Homer (Fulcrum Genomics): "AI assistants need to work with your code, your outputs, and your analysis logic" — permite que agentes inspecionem não só o que foi recuperado, mas como, transformando uma resposta plausível em algo verificável e reproduzível.

## Exemplos e evidencias

- **Contexto real-world urgente**: surto de Bundibugyo virus (Ebola) na RDC, declarado em maio de 2026 — INRB Kinshasa confirmou 8 de 13 amostras positivas em um dia; em 29 de maio, OMS reportou >1.000 casos confirmados/suspeitos e >200 mortes. Genomas quase completos do surto foram gerados, mas a análise comparativa contra genomas históricos do Ebola depende de NCBI Virus/Pathoplexus — e o primeiro passo dessa análise hoje é clicar manualmente numa interface web reproduzindo filtros complexos.
- Outras ferramentas/esforços citados como "context engines" para biologia: ToolUniverse, Edison Scientific's Robin, Biomni, e agentes biomédicos relacionados.
- Ferramentas tradicionais que já tentavam mover dados biológicos para fora de interfaces de browser: Biopython, BioPerl, BioJulia, Entrez Direct, BioMart, gget.
- Paper completo: arXiv 2606.06749 (Nasri, Gurev, Varilly, Ramesh, O'Leary, Cool, Renard, Sabeti, Luebbert).

## Implicacoes para o vault

- Caso concreto e bem documentado do princípio **"deterministic retrieval layers reduzem variância e tornam a escolha de modelo menos crítica"** — relevante para `[[03-RESOURCES/concepts/agent-systems/harness-engineering]]` e `[[03-RESOURCES/concepts/agent-systems/tool-use-agents]]`: a confiabilidade vem da ferramenta, não (apenas) do modelo.
- Reforça o padrão **"agent-friendly infrastructure"** já discutido em outras fontes do vault sobre Karpathy (vibe-coding, "build for agents") — conecta `[[03-RESOURCES/concepts/agent-systems/agentic-engineering-levels]]` e `[[03-RESOURCES/concepts/agent-systems/harness-adaptation]]` a um domínio totalmente diferente (biologia computacional), mostrando que o problema é geral, não específico de coding agents.
- Dado real e citável de **falta de reprodutibilidade run-to-run de LLMs** mesmo com prompt idêntico (5/15/106 sequências em três runs do Sonnet 4) — útil como exemplo concreto em discussões sobre `[[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]]` e necessidade de verificação determinística.
- Não há concept/entity específico de "agentes em biologia" ou "scientific agents" no vault hoje — domínio novo, mas um único artigo não justifica criar concept dedicado ainda (recomendação: revisar se mais fontes desse domínio aparecerem).

## Links

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/tool-use-agents]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]]
- [[03-RESOURCES/entities/anthropic]]
