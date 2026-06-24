---
title: How to Build AI Workflows When You're Tired of Optimizing Prompts
type: source
source: "Clippings/How to Build AI Workflows When You're Tired of Optimizing Prompts.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Quando você passa mais tempo gerenciando a IA do que ela economiza para você — copiando outputs entre abas de chat, lembrando o que o passo 3 precisa do passo 1 — você não tem um problema de prompt, tem um problema de arquitetura. A solução é converter prompts em workflows onde cada passo escreve em um arquivo (handoff file) e o passo seguinte lê esse arquivo, carregando contexto adiante sem o humano carregá-lo manualmente.

## Argumentos principais
- O sinal de que prompting parou de funcionar: você está fazendo o trabalho de coordenação que a IA deveria fazer — copiar entre passos, lembrar o que um passo posterior precisa de um anterior, abrir múltiplos chats porque o contexto fica poluído.
- Estudo citado (arXiv, outubro 2025) mostra que a acurácia de LLMs cai significativamente quando informação relevante está embutida em contextos mais longos, mesmo quando todos os tokens irrelevantes são mascarados — usado como evidência de que "otimizar a palavra certa" não resolve um problema de arquitetura.
- Prompt de autodiagnóstico fornecido literalmente, para colar ao final de uma conversa longa: pede ao LLM para analisar se a tarefa poderia ser estruturada como sequência de passos com handoffs, e o que entrada/instrução/saída/checkpoint pareceriam como workflow.
- Como achar as "costuras" (seams) numa conversa longa: procurar os momentos onde você mudou de marcha, disse "ok, agora vamos fazer X", copiou algo de mais cedo no chat e colou numa nova solicitação, ou teve que lembrar a IA do que estava sendo trabalhado porque ela esqueceu. Cada costura é um passo candidato a workflow.
- Caso de uso do autor (ideação de conteúdo): pesquisa manual em Reddit/notícias/arXiv, cada fonte num chat separado por causa de poluição de contexto — terminava esquecendo o que achou na fonte anterior ao terminar a próxima. Criar skills isolados por fonte não resolveu — o autor ainda era o "middleware" coordenando manualmente entre eles.
- Distinção citada do guia "Building Effective Agents" da Anthropic (dezembro 2024): workflows são sistemas onde LLMs e tools são orquestrados por caminhos de código predefinidos; agentes são sistemas onde LLMs dirigem dinamicamente seus próprios processos. Para não-programadores, workflows são o ponto ideal: você define o caminho, a IA faz o trabalho em cada parada.
- Cinco padrões de workflow da Anthropic explicados em linguagem simples: **prompt chaining** (linha de montagem — saída do passo 1 é entrada do passo 2); **routing** (triagem por tipo de entrada, como separador de correio); **parallelization** (várias coisas ao mesmo tempo, como três pesquisadores em vez de um); **orchestrator-workers** (agente-chefe que decompõe e delega a agentes trabalhadores); **evaluator-optimizer** (um agente faz o trabalho, outro avalia, o primeiro revisa com base no feedback).
- "Handoff files": cada passo escreve seu trabalho em arquivo (markdown, Google Doc, bloco de texto estruturado) para o próximo passo ler — o formato importa menos que o princípio. O autor testou variáveis em memória (somem quando a sessão termina), entradas de banco de dados (exigem setup/manutenção) e arquivos de estado compartilhado (corrompem quando dois passos escrevem ao mesmo tempo); markdown em Obsidian venceu por ser "chato e confiável".
- Decision gates: nem todo passo precisa de checkpoint humano — só os pontos onde uma decisão real precisa ser tomada (qual ângulo seguir, qual fonte priorizar, se corta uma seção). Regra prática: um gate no ponto onde a saída se torna pública ou irreversível.
- Estrutura mínima viável de workflow tem quatro partes: input, instructions, output, checkpoint — sem necessidade de software ou código, só uma pasta com arquivos.

## Key insights
- Pesquisa citada de Clare Liguori (AWS, "steering accuracy beats prompts workflows", testada em 3.000 runs de avaliação): instruções de prompt simples atingiram 82,5% de acurácia (1 em 5 interações falhava); adicionar loops de feedback estruturado ("steering hooks") elevou a acurácia a 100% em 600 runs. A conclusão do autor: "estrutura melhor fez a diferença, não prompts melhores."
- Citação do guia da Anthropic reforçando começar simples: explicitamente alertam contra começar com frameworks ou arquiteturas complexas — comece com dois passos, torne-os confiáveis, depois adicione um terceiro.
- "Boring beats clever": pessoas que extraem valor real de workflows de IA constroem workflows entediantes e os rodam 50 vezes — não workflows impressionantes que rodam duas vezes.

## Exemplos e evidências
- Workflow completo de 4 passos detalhado: Step 1 (pesquisa Reddit → `reddit-findings.md`), Step 2 (scraping de notícias → `news-findings.md`), Step 3 (busca arXiv → `arxiv-findings.md`), Step 4 (síntese lendo os três arquivos → `idea-angles.md` com 5-10 ângulos de artigo).
- Comparação lado a lado "prompt way vs. workflow way" para a mesma tarefa de ideação de conteúdo, mostrando como o caminho de prompt perde nuance (queixas do Reddit "enterradas" no texto combinado) enquanto o caminho de workflow preserva clareza por arquivo.
- Exemplo pessoal do autor de primeiro workflow recomendado para principiantes: briefing matinal de duas etapas (ler tarefas do Asana, formatar, entregar) — "simples o bastante para construir numa tarde, útil o bastante para rodar todo dia da semana desde que construído."
- Referência cruzada a guia próprio do autor (canal Telegram) sobre approval gates em workflows do Hermes.

## Implicações para o vault
Esta source é evidência primária forte para `[[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]`, já catalogado no vault — confirma e detalha exatamente o padrão (markdown como meio de handoff entre passos de um pipeline, vencendo banco de dados e estado em memória por simplicidade e confiabilidade). Conecta diretamente também com `[[03-RESOURCES/concepts/agent-systems/evaluator-optimizer-workflow]]` e `[[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]` (os cinco padrões da Anthropic). É notável que o próprio Nexus Agent System do vault já usa handoff files (`04-SYSTEM/wiki/hot.md`, manifests) exatamente neste espírito — esta source funciona como validação externa direta da arquitetura de pipeline já adotada (ingest → triagem → report).

## Links
- [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]
- [[03-RESOURCES/concepts/agent-systems/evaluator-optimizer-workflow]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/entities/Obsidian]]
