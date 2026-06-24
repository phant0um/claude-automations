---
title: "Filesystem-Pilling Your Vertical Agent"
type: source
source: "Clippings/Filesystem-Pilling Your Vertical Agent.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
"Filesystem e bash é tudo que você precisa" é o jeito de facto de construir agentes há pelo menos seis meses (desde a chegada mainstream de Manus), mas estudos de caso concretos do que isso compra na prática são raros. O artigo detalha como a Shortcut habilitou enriquecimento de dados não construindo uma ferramenta de enriquecimento sob medida, mas "filesystem-pillando" as ferramentas genéricas que já tinha — a lição geral: ao enfrentar um problema vertical, transformá-lo num problema geral e deixar o agente compor o pipeline, em vez de construir a ferramenta bespoke.

## Argumentos principais
- "Filesystem-pilling" significa dar ao agente um filesystem e shell reais, roteando o trabalho por arquivos em disco em vez de outros meios — dados ficam em arquivos, o agente lê/escreve com bash, e o que flui pela transcrição são majoritariamente *pointers* para os dados, não os dados em si. Razão imediata: economiza tokens tanto recebendo inputs quanto gerando outputs.
- A solução "óbvia" para um problema vertical (enriquecimento de dados em planilha) é espelhar a grade: um agente por célula (Paradigm, Clay, Quadratic, Freckle). Demonstra bem mas resolve só uma forma de problema — qualquer coluna que quebre o modelo de célula (labels não-planos, label≠query, respostas independentes que não padronizam) expõe a causa raiz: um agente-célula confina a inteligência a linha×coluna×formato exato de label, e o problema de pesquisa não é célula-shaped.
- A correção não foi construir uma ferramenta de enriquecimento melhor — foi "filesystem-pillar" uma busca web simples: o `web_search` da Shortcut recebe um arquivo `.txt` de queries (uma por linha) mais um schema de output para o batch inteiro, roda concorrentemente, escreve uma linha JSONL por resultado. A ferramenta não sabe nada sobre planilhas, linhas ou células — o agente compõe o trabalho em código.

## Key insights
1. **Bash**: o mesmo comando pode imprimir 5 linhas ou 5.000 — não tentar limitar a saída, deixar rodar e capturar o overflow. Quando o output é grande demais para o contexto, ele não é colado de volta na transcrição; vai para disco, e o modelo recebe um head truncado mais um path. Exemplo de referência citado: o bash tool do `pi` limita output a 50KB/2000 linhas e anexa o path completo quando ultrapassa.
2. **MCP**: a maioria dos outputs de ferramentas MCP são "abominações" — 2MB de JSON profundamente aninhado. Não deixar isso entrar em contexto; persistir em disco e usar um parser JSON para devolver um path mais a *shape* dos dados, não os valores. A partir da shape e alguns exemplos, o modelo vai direto aos valores que quer (jq nos dois campos necessários, filtrar para as 12 linhas que combinam) em vez de ler 4182 contatos para usar uma dúzia.
3. **Subagentes**: para tarefas altamente paralelizáveis (pesquisar 200 empresas), o movimento naive é digitar um briefing completo em prosa para cada chamada de subagente, reinflando quase o mesmo parágrafo 200 vezes no output do pai. A correção é uma pequena mudança na ferramenta de subagente: deixar aceitar a query como arquivo `.txt`, não só string inline — uma vez que a query é arquivo, o agente compõe as 200 programaticamente via bash em vez de escrever à mão.
4. **Padrão comum às três técnicas**: manter o volume fora do modelo e deixar arquivos carregarem em seu lugar — mais rápido, mais barato, e os tokens não gastos em volume ficam disponíveis para raciocínio: "a leaner context is a smarter agent."
5. **Os três tipos de quebra do modelo célula-por-célula**: (a) labels não-planos — "Comp → Base" e "Comp → Equity" são uma coisa lógica dividida por header aninhado; um tool com label de célula único não tem onde colocar essa hierarquia; (b) o label não é a query — "Notable projects of B. Okoro" é uma query de busca terrível; "open-source projects and conference talks by B. Okoro, the candidate who led a payments rewrite" é uma boa query, mas compor essa query precisa das outras células da linha, que o agente-célula nunca vê; (c) respostas independentes não padronizam — olhando qualquer coluna, "highest degree" aparece em quatro formatos diferentes porque cada agente-célula respondeu isoladamente, sem nada vendo a coluna como um todo para uniformizar.
6. **A correção fecha 2 das 3 falhas imediatamente**: as três colunas colapsam num único lookup por pessoa (cada linha é uma query real, com nome/título/empresa entrelaçados, em vez de um label de célula isolado); um schema, aplicado ao batch inteiro, fixa a forma da resposta para toda linha de uma vez — resultado citado: 3x de economia em lookups.
7. **A terceira falha (padronização) cai para o próximo passo**: o arquivo de resultados volta ao mesmo loop de agente que lançou a busca, que agora lê com a coluna inteira em vista — colapsa "PhD" e "Doctorate" numa forma só, força "8 years" para 8, reemite queries que voltaram rasas, itera até a coluna ficar consistente por construção. Essa é a etapa que o modelo de célula estruturalmente não pode ter, porque nenhum agente-célula vê além da própria célula.
8. **Rerunnable + auditable "de graça"**: porque cada passo deixou um arquivo atrás, o workflow ganha duas propriedades — rerunnable (corrigir um estágio posterior reprocessa o JSONL salvo em vez de re-rodar a pesquisa web cara) e auditable (toda etapa intermediária — queries compostas, resultados crus, snippets, até fontes rejeitadas — é um arquivo real que o usuário pode ler e baixar).

## Exemplos e evidências
- Clay (planilha-driven enrichment) levantou $100M numa valuation de $3.1B em agosto de 2025 — citado como evidência do tamanho do mercado de enriquecimento de dados.
- Exemplos de código mostrando: comando bash com output truncado + path; resultado MCP de 2.1MB salvo em arquivo com shape JSON anexada; loop bash compondo 200 arquivos `.txt` de briefing de subagente a partir de `companies.json`.
- Exemplo de `web_search` da Shortcut com `inputPath` apontando para arquivo de 4.000 linhas e `outputSchema` JSON fixo para todo o batch.
- Exemplo de saída JSONL: linhas com `status: "found"`/`"not_found"`, `answer` estruturado, `sources` com URL.

## Implicações para o vault
Caso de estudo concreto e bem documentado do princípio "filesystem como memória/overflow de contexto" já presente no concept `virtual-filesystem-llm` — adiciona um ângulo não coberto ainda: usar arquivos não só para *armazenar* contexto fora da janela, mas para *compor* trabalho paralelo (queries de subagente como arquivos, não strings infladas no prompt). A lição central ("não construir a ferramenta vertical, transformar em problema geral") é um contra-ponto valioso a qualquer tentação de construir ferramentas excessivamente específicas dentro de `04-SYSTEM/agents/` quando uma combinação genérica de bash+arquivos resolveria com a mesma robustez.

## Links
- [[03-RESOURCES/concepts/pkm-obsidian/virtual-filesystem-llm]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-subagents]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
