---
title: "how to get Fable-level intelligence back"
type: source
source: "Clippings/how to get Fable-level intelligence back.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Depois que o Fable 5 foi desligado pela Anthropic e o Opus 4.8 pareceu uma regressão de inteligência, a solução não é esperar a empresa "ligar de volta" o modelo antigo — é reconstruir esse nível de inteligência com um **council** (conselho): um painel de modelos mais baratos/abertos respondendo em paralelo, mais um modelo-juiz frontier que lê todas as respostas e escreve a melhor versão combinada, superando qualquer modelo único trabalhando solo, por uma fração do custo.

## Argumentos principais
- O padrão atual de uso de IA é: pergunta difícil → enviada ao modelo mais caro disponível → ler uma única resposta → confiar nela porque não há contra-checagem. O council existe para mudar exatamente isso: enviar a mesma pergunta a um painel de modelos, ter um modelo separado lendo todas as respostas, notando onde concordam, onde se contradizem e o que cada um perdeu, e escrevendo a melhor versão combinada — essa resposta combinada supera o melhor modelo do painel trabalhando solo.
- Benchmark citado (teste de raciocínio publicado pela própria OpenRouter): um painel de 2 modelos + juiz scored 69/100, contra 65,3 do Fable 5 (o modelo único mais forte do teste); um time de 3 modelos baratos arbitrados ficou em 64,7 — quase no nível do Fable 5 sozinho, a aproximadamente metade do custo por pergunta. A conclusão do autor: a qualidade não veio de comprar um modelo mais inteligente, veio de um modelo revisando e combinando cuidadosamente o trabalho de vários modelos mais baratos — checar o trabalho importa mais que adicionar mais "trabalhadores".
- O council não é só uma técnica para respostas melhores — o argumento maior é sobre **orquestração**: tarefas longas e multi-etapa são essencialmente uma sequência de decisões (qual é o plano, qual ordem, o que é arriscado, o que fazer quando o passo 4 contradiz o passo 2), e boas decisões nunca vieram de uma única mente. Colocar um council no comando de uma tarefa grande produz um melhor tomador de decisões dirigindo tudo a partir daí.
- Reframing de como gastar o modelo frontier caro: não o desperdice como "apenas mais uma voz no painel" — coloque-o no **assento de juiz**. Deixe os modelos baratos/abertos fazerem o rascunho paralelo, e gaste o modelo caro na etapa que carrega a qualidade: ler tudo e tomar a decisão final.
- Distinção crítica entre **council** e **router**: um router escolhe um modelo (geralmente o mais barato capaz) para economizar — você sai com a resposta de um único modelo ou um placar comparativo, nunca fusão de fato. Um council é definido pelo juiz: o modelo que lê todas as respostas e escreve algo melhor do que qualquer membro individual produziu. "Sem etapa de síntese, é só um roteador" — heurística prática para detectar produtos de "fusão" que na verdade são apenas roteadores rebatizados.
- Três formas de pagar/operar um council: (1) **por requisição** — OpenRouter Fusion (zero setup, browser, botões quality/budget/custom) ou orcarouter (define-se o painel e o juiz em um arquivo de config DSL, ~12 linhas); (2) **usar assinaturas existentes** — gavel roda Claude+ChatGPT+Gemini em paralelo usando os logins já pagos, com Claude fazendo a fusão e só o modelo principal tocando os arquivos (os outros são apenas consultivos/read-only, o que mantém seguro rodar em código real); (3) **self-hosted** — openfusion (qualquer backend, estratégias consensus/best-of-n/first-to-finish, pode expor o council como endpoint único), fusion-fable (painel cego de modelos frontier + juiz forte), llm-consortium (juiz que re-roda o painel até as respostas convergirem em um threshold de confiança).
- Quando convocar o council: a heurística prática é "eu pagaria por um modelo premium para responder isso?" — se sim, é pergunta de council; se não, use o modelo rápido/barato padrão. Casos específicos citados: migração de código (council decide o plano de migração/ordem/risco, mas a execução das edições propriamente ditas vai para um agente mais barato — migração é um "problema de decisão", não um "problema de código", então um council sintetizador de prosa funciona bem para o plano mas não para escrever o código em si, já que não há referee objetivo para "qual código é melhor"); pesquisa profunda (painel lê fontes em paralelo, juiz reconcilia divergências — a divergência é exatamente onde a resposta real se esconde); orquestração de trabalho longo e complexo; definição de metas para um agente mais leve; construção de base de conhecimento (council decide estrutura/entidades/duplicatas, agente mais leve povoa).
- Para código especificamente, o juiz muda de natureza: em vez de sintetizar prosa, o council mantém o candidato cujo patch passa os testes — "mesmo council, referee objetivo". A lição central: council é um padrão que se ajusta por tarefa (prosa/pesquisa pedem juiz sintetizador; código pede juiz que roda os testes), não um produto único.

## Key insights
- A frase mais afiada do artigo: "checking the work matters more than adding workers" — o ganho de qualidade do council vem da revisão cuidadosa, não simplesmente de ter mais modelos respondendo.
- O council é mais lento e mais caro por chamada que um modelo único (espera-se o painel completo mais a passada de síntese) — não é o padrão default para todo dia, é a ferramenta para quando a decisão vale o custo.
- A narrativa popular de que "fusion é ótima para pesquisa e inútil para código" é descrita como "uma linha de lançamento de concorrente, não um resultado medido" — a versão mais precisa é que sintetizar prosa é a forma errada de julgar código, não que councils não funcionem para código (mudando o juiz para um que roda testes, o padrão funciona igualmente bem).

## Exemplos e evidências
- Benchmark de raciocínio publicado pela OpenRouter: painel de 2 + juiz = 69/100; Fable 5 solo = 65,3/100; trio barato arbitrado = 64,7/100 a ~metade do custo por pergunta.
- Ferramentas concretas citadas com URLs: openrouter.ai/fusion, orcarouter (DSL de config), github.com/junkim100/gavel, github.com/nachoiacovino/openfusion, github.com/duolahypercho/fusion-fable, github.com/irthomasthomas/llm-consortium.
- Exemplo de DSL do orcarouter com ~12 linhas definindo painel paralelo (Claude Opus 4.8, GPT-5.5, Gemini 3.1 Pro) e estratégia de árbitro `best_of_n`.

## Implicações para o vault
- Conecta diretamente com `multi-model-orchestration` e `internalized-multi-agent-debate` já catalogados — esta fonte fornece um framework prático e nomeado ("council" com painel + juiz) e uma distinção conceitual nova e útil (council vs. router) que vale destacar nesses conceitos existentes.
- A heurística "council decide, agente mais barato executa" é uma instância concreta do padrão hierárquico já mapeado em `hierarchical-orchestration` — vale conectar como exemplo aplicado.
- Tematicamente irmã de `self-improving-loop-300-agent-swarm-kimi` (mesmo batch): ambos defendem usar o modelo caro apenas no papel de verificador/juiz, não de gerador, e deixar volume barato fazer o trabalho de rascunho — um padrão recorrente que vale uma nota de síntese própria no vault se mais fontes confirmarem.

## Links
- [[03-RESOURCES/concepts/agent-systems/multi-model-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/internalized-multi-agent-debate]]
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]]
- [[03-RESOURCES/entities/Claude]]
