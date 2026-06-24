---
title: "feat(search_files): headroom compression evaluation report + lossless densification (PR #47866, NousResearch/hermes-agent)"
type: source
source: "Clippings/feat(search_files) headroom compression evaluation report + lossless densification by teknium1 · Pull Request 47866 · NousResearchhermes-agent.md"
created: 2026-06-17
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Uma avaliação rigorosa da biblioteca `headroom` (compressão de tool outputs, anunciada com "60-95% menos tokens") em tráfego real de um agente de código (Hermes) conclui que o mecanismo mais alardeado (CCR — Compress-Cache-Retrieve) é **net-negativo** para um agente que lê suas próprias saídas, e que a parte genuinamente lossless da biblioteca só dispara em 6% do tráfego real para 0,34% de economia líquida — mas a avaliação revela um ganho real e gratuito: a saída JSON do `search_files` pode ser densificada losslessly em ~58% menos tokens sem nenhuma dependência externa, superando o próprio headroom no seu melhor caso.

## Argumentos principais
- O headroom tem dois mecanismos com comportamentos muito diferentes: **SmartCrusher/diff** (densifica conteúdo estruturado losslessly, JSON→CSV+schema) é útil mas raramente dispara em tráfego real; **CCR** (remove conteúdo, deixa um marcador `<<ccr:HASH>>`, armazena o original para recuperação posterior) é estruturalmente net-negativo para um agente de código.
- O CCR foi verificado como funcionalmente correto antes de ser julgado: 12/12 e depois 10/10 marcadores de transcrições reais round-tripped exatamente para os originais; em uma run live o agente reconheceu autonomamente os marcadores e chamou `headroom_retrieve` corretamente.
- O problema é estrutural, não um bug: o agente **recupera o dado de volta porque precisa dele**, colocando o conteúdo no contexto duas vezes (marcador + blob recuperado) — mais tokens do que sem compressão nenhuma. CCR foi desenhado para comprimir histórico de conversa que o modelo já passou (mundo "proxy"), não para tool outputs ativos que um agente de código está usando agora.
- CCR também não pode ser totalmente desabilitado no caminho de biblioteca (opaque-string CCR sempre emite) e duplica/conflita com o compressor de sumarização próprio do Hermes (`agent/context_compressor.py`).
- Medido em corpus real de 3.000 outputs, restringindo a só lossless (rejeitando qualquer coisa que emita marcador CCR): economia líquida de **0,34%**, taxa de disparo de 6,2% das saídas grandes. As ferramentas que carregam o volume de tokens (`read_file`, `skill_view`, `patch`, `terminal`) tiveram **~0%** de ganho — ou excedem o threshold do CCR ou são no-op. O único ganho significativo foi `search_files`.
- Por tipo de conteúdo (com ML Kompress de prosa desabilitado para medição lossless): JSON em array reduz 62,5% (smart_crusher), diff de git reduz 64,8% (diff compressor) — ambos lossless, zero marcadores CCR; prosa e código não reduzem nada (noop). A densificação lossless só dispara em conteúdo estruturado abaixo do threshold de tamanho do CCR opaco — conteúdo de referência grande (arquivos de skill de 39KB, diffs de 25KB) excede esse threshold e recebe um marcador CCR em vez de densificação, o que colapsa a economia líquida para 0,34%.
- Conclusão: **CCR rejeitado** (net-negativo, não pode ser desabilitado, conflita com o summarizer próprio); **headroom como dependência rejeitado** (~0,3% líquido no tráfego real não justifica adicionar `litellm` + `tiktoken` + `tree-sitter` + `ast-grep-cli` + ~15 dependências transitivas, que ainda conflitam com os invariantes de prompt-cache e sumarização do Hermes); **a ideia que vale portar**: densificação lossless da única forma de conteúdo que de fato comprime bem — `search_files`.
- A mudança concreta enviada no PR: resultados de `search_files` repetem as chaves JSON `{path,line,content}` e a string completa do caminho para cada match. Um densificador nativo de ~40 linhas agrupa os matches por caminho e elide a repetição — lossless, zero dependências, e supera o headroom na mesma forma de conteúdo: **57,8% vs. os 2,5% gated do headroom** (que continua disparando seu próprio threshold de CCR e pulando essas saídas).

## Key insights
- Verificar que um mecanismo de compressão "funciona corretamente" (round-trip íntegro) não significa que ele é uma boa ideia para o caso de uso — o CCR é tecnicamente correto e ainda assim é a decisão errada para um agente que ativamente usa o conteúdo que comprimiu.
- A métrica que importa é a economia **líquida em corpus real**, não a economia "quando dispara" — um mecanismo pode reduzir 60%+ quando ativado e ainda assim entregar economia líquida de fração de 1% se raramente dispara ou se a recuperação cancela o ganho.
- O melhor ROI de engenharia muitas vezes não é adotar uma biblioteca externa robusta, mas extrair a ideia central (aqui, "densificação lossless de JSON estruturado repetitivo") e implementá-la nativamente em ~40 linhas, evitando uma árvore de dependências inteira.
- A avaliação documenta explicitamente o que **não** foi testado (proxy, wrap, MCP server, `headroom learn`, memória cross-agent, redução de output tokens, subsistemas de embedding/relevância) — disciplina de escopo que evita generalizar conclusões além do que foi medido.

## Exemplos e evidências
- Corpus real de até 3.000 tool outputs de transcrições reais do Hermes, com benchmark por tipo de ferramenta.
- Tabela de validação: 422 outputs reais de `search_files` content — densificação dispara em 97% dos casos, corpus de tokens cai de 679.967 para 286.648 (redução de 57,8%; quando dispara, média de 52,9%, mediana 54,8%, máximo 74,1%).
- Losslessness verificada: todo path, número de linha e byte de conteúdo recuperável a partir do `matches_text` (só whitespace final é rstrip'd; indentação preservada verbatim). Um audit live multi-turn produziu respostas byte-idênticas com e sem densificação.
- 155 testes de regressão passaram; 6 novos casos em `TestSearchResultDensify`; CI com matriz completa verde.
- Revisão de código por outro colaborador sugeriu melhorias adicionais (threshold considerar paths únicos em vez de apenas contagem de matches; método `from_dict()` para round-trip e compatibilidade retroativa) — não incorporadas neste PR, registradas como comentário.

## Implicações para o vault
- Este PR é evidência empírica direta e bem documentada para o conceito `token-compression` já catalogado, e especificamente uma instância de "lossless densification" que merece nota própria ou subseção dentro desse conceito — o caso é forte porque inclui um benchmark negativo (CCR) tão informativo quanto o resultado positivo.
- Conecta-se a `token-economy` e `agent-vfs-pattern`/`virtual-filesystem-llm`: ambos os PRs deste batch (este e o do course-video-manager) tratam de agentes que precisam navegar e ler conteúdo estruturado de forma eficiente em tokens — vale considerar interlinkar os dois como "padrões de engenharia de contexto para agentes de produção".
- O padrão "avaliar antes de adotar dependência" (rejeitar headroom como pacote, mas extrair e reimplementar nativamente a única parte que compensa) é uma heurística de engenharia de software valiosa, possivelmente digna de uma nota própria em `agent-systems` ou `engenharia-de-software` sobre build vs. buy em compressão de contexto.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/token-compression]]
- [[03-RESOURCES/concepts/agent-systems/token-economy]]
- [[03-RESOURCES/concepts/pkm-obsidian/virtual-filesystem-llm]]
- [[03-RESOURCES/concepts/agent-systems/agent-vfs-pattern]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/entities/NousResearch]]
