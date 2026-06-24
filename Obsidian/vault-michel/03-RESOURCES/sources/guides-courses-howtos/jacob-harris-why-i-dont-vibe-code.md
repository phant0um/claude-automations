---
title: "Why I Don't Vibe Code — Jacob Harris (tradução @dotey)"
type: source
category: dev/coding-philosophy
author: "Jacob Harris / @dotey (tradução)"
source: "https://x.com/dotey/status/2056247701264630062"
original_url: "https://jacobharr.is/personal/i-dont-vibe-code"
published: 2026-05-18
ingested: 2026-05-18
hash: 61a99eccf723e58de135bdfdf6f9af79
tags:
  - vibe-coding
  - software-craftsmanship
  - llm-limits
  - essential-complexity
  - coding-philosophy
triagem_score: 7
---

# Why I Don't Vibe Code — Jacob Harris

## Tese central

O autor (ex-jornalista de dados, desenvolvedor experiente) elenca 5 razões pessoais para não usar LLMs na programação cotidiana. O núcleo: vibe coding elimina exatamente as fontes de aprendizado, design e julgamento que constroem expertise real — e "friction" não é bug, é feature.

## 5 razões

### 1. Sou pão-duro
Encontrou o teto de tokens no primeiro uso e recusou dar cartão de crédito. Voltou ao Emacs puro e não sentiu falta. Sinal de que a dependência era opcional.

### 2. Tenho experiência suficiente para relativizar
Ciclos de hype anteriores (low-code, no-code) prometiam o mesmo. Mapeia sobre Fred Brooks (*The Mythical Man-Month*, "No Silver Bullet"): LLMs atacam a **complexidade acidental** (escrever código é chato) mas a **complexidade essencial** (design de abstrações corretas, elegantes, manuteníveis) permanece intacta e humana.

> LLMs são "fancy autocomplete" — não conseguem explicar *por que* escolheram um caminho arquitetural.

### 3. Ele ama a bagunça
Como ex-data journalist, treinou o instinto de "interrogar dados" — perguntar o que os dados *não* dizem, não apenas o que dizem. LLMs não fazem meta-cognição: para eles, o modelo *é* a realidade. Analogia com o caso DOGE/SSA: 9M de registros com nascimento >120 anos atrás sem data de morte → interpretação literal sem questionar qualidade dos dados.

> "Pedir a um LLM que reconheça os limites da sua realidade é como perguntar a um peixinho dourado como está a temperatura da água."

### 4. Preciso da fricção
A fricção é sinal de design: quando codificar fica difícil, é porque a arquitetura está errada. ADRs (Architectural Decision Records) forçam documentar *o que* e *por quê* antes de implementar. LLMs atravessam a fricção cegamente — produzem código que funciona nos testes mas sem nenhuma explicação do *porquê* daquela escolha.

> "O único design doc que sobra é um arquivo Markdown de 2 anos atrás usado para instruir o modelo."

### 5. Me importo demais
Programar é expressão criativa. Assim como um pintor não terceiriza sua arte para IA, o autor não quer abrir mão do prazer de transformar ideias vagas em sistemas reais.

## Key insights sistêmicos

- **Complexidade acidental vs essencial** (Brooks 1987): LLMs só atacam a acidental; a essencial exige experiência humana.
- **Vibe coding bem-sucedido** = desenvolvedor especialista que sabe conduzir + projetos onde errar é barato.
- **O ataque à "fricção"** é um ataque velado a revisores de código, PMs, designers, QA, compliance — pessoas reais que evitam bugs de produção.
- **Software é colaboração**: remover "overhead humano" acelera, mas não melhora — e isola.

## Fred Brooks e a distinção acidental vs essencial

A referência a Brooks (1986) é o argumento intelectual mais sólido do artigo. Brooks distingue dois tipos de complexidade em software:

**Complexidade acidental:** surge dos meios que usamos para expressar software — linguagens, ferramentas, protocolos, convenções. É acidental porque mudou muito ao longo do tempo (do Assembly ao Python, de HTTP raw a REST frameworks) e continuará mudando. LLMs atacam essa camada com sucesso: escrever código boilerplate, lembrar APIs, seguir convenções de estilo.

**Complexidade essencial:** intrínseca ao problema sendo resolvido. A dificuldade de modelar um domínio de negócio, de identificar as abstrações corretas, de antecipar como o sistema precisa evoluir — essa complexidade existe independente da ferramenta usada para expressar a solução. Ela requer experiência, julgamento, e compreensão profunda do domínio.

O argumento do autor: vibe coding eliminando a complexidade acidental (boilerplate, sintaxe) dá a ilusão de progresso, mas as decisões que determinam qualidade do software — as abstrações corretas, os trade-offs adequados ao contexto, a manutenibilidade a longo prazo — permanecem humanas. LLMs não são "fancy autocomplete" como ironiza, mas também não conseguem explicar *por que* escolheram um caminho arquitetural.

## A crítica ao instinto de "interrogar dados"

A analogia com jornalismo de dados é a mais original do artigo. Jornalistas de dados são treinados para questionar a qualidade e interpretação de datasets antes de concluir qualquer coisa. O caso DOGE/SSA que o autor menciona é ilustrativo: 9 milhões de registros com data de nascimento que implicaria mais de 120 anos sem data de morte. Uma ferramenta AI que recebe esses dados e os processa literalmente produzirá análise tecnicamente correta mas factualmente absurda.

LLMs têm um problema estrutural aqui: eles são treinados para ser úteis e confiantes, não para questionar a premissa da tarefa. A meta-cognição — "espera, esses dados parecem errados" — vai contra o instinto de completar a tarefa. Isso não é uma limitação de capacidade (os modelos certamente conseguem detectar anomalias quando explicitamente solicitados), mas uma limitação de comportamento default.

O autor é raro ao articular isso claramente: o problema não é que LLMs falham ao executar a tarefa — é que eles não falham de formas detectáveis quando a tarefa está mal formulada.

## Fricção como sinal de design — implicações para engenharia

A observação de que "quando codificar fica difícil, é porque a arquitetura está errada" tem implicações práticas para como usar LLMs em coding:

Se LLMs eliminam a fricção de implementar (escrevem o código difícil rapidamente), eles também eliminam o sinal que indicaria que a arquitetura precisa de revisão. Um desenvolvedor implementando manualmente sente quando uma abstração é errada — a implementação fica tortuosa, há muita duplicação, os edge cases se multiplicam. Um LLM implementará essa mesma abstração errada eficientemente, sem o feedback de que a escolha arquitetural foi ruim.

ADRs (Architectural Decision Records) mencionados pelo autor são uma forma de preservar esse sinal: documentar não apenas o que foi decidido, mas por que, e o que foi rejeitado. Com LLMs, a tentação é pular ADRs porque a implementação acontece rapidamente. O risco é acumular decisões arquiteturais sem raciocínio documentado — exatamente o que o autor critica.

## A perspectiva contrária — onde vibe coding funciona

O artigo é honesto ao qualificar: vibe coding funciona para desenvolvedores especialistas conduzindo o processo em projetos onde errar é barato. O autor não argumenta que LLMs são inúteis — argumenta que ele, especificamente, prefere não usá-los em seu trabalho cotidiano.

Os casos onde o argumento do autor é mais fraco:
- **Prototipagem:** complexidade essencial baixa, pressa alta, descartável se errar — vibe coding é superior
- **Scripts utilitários:** sem usuários, sem manutenção de longo prazo, sem consequências de arquitetura ruim
- **Aprendizado de APIs novas:** LLMs reduzem drasticamente o tempo de familiarização com APIs desconhecidas

Os casos onde o argumento é mais forte:
- **Software de longo prazo com múltiplos mantenedores:** decisões arquiteturais ruins se amplificam ao longo do tempo
- **Domínios onde a qualidade dos dados é incerta:** journalism, pesquisa, análise financeira
- **Trabalho criativo onde o processo é o ponto:** programar como expressão, não como meio

## Implicações para o contexto deste vault

O argumento de Jacob Harris é relevante para pensar o papel de Claude no vault: Claude é mais útil quando opera em domínios com complexidade essencial baixa e bem definida (ingestão de fontes, manutenção de wikilinks, atualização de hot.md) do que quando precisa de julgamento sobre o que constitui uma boa síntese ou conexão entre conceitos — que permanece humano.

## Links

- Conceitos: [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]], [[03-RESOURCES/concepts/agent-systems/agent-error-correction]]
- Ver também: [[03-RESOURCES/concepts/agent-systems/agent-harness]] (thin harness, fat skill)
