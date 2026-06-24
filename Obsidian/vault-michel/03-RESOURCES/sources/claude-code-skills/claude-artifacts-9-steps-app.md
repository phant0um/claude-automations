---
title: "How to build your first app with Claude Artifacts: 9 steps from idea to shareable product (no code)"
type: source
source: "Clippings/How to build your first app with Claude Artifacts 9 steps from idea to shareable product (no code).md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central

A maioria dos usuários paga pelo Claude e usa o painel de Artifacts apenas para ler código ou skimar documentos — nunca para construir algo. Mas o painel é um ambiente de build ao vivo: Claude escreve React de verdade, executa ao lado do chat, reconstrói a cada pedido, recebe dados, lembra entre sessões e publica em URL pública sem login. A habilidade necessária nunca foi programar — é descrever com precisão. O guia apresenta um roteiro de 9 passos, em 3 partes (Descrever / Construir / Publicar), de uma ideia em uma frase até um link compartilhável.

## Argumentos principais

- O gargalo não é técnico, é de framing: dizer "make me X" pode gerar uma explicação em texto em vez de um app funcional, porque Claude não sabe se o usuário queria uma explicação ou uma coisa construída.
- Apps grandes ("build me a CRM") falham porque têm muitas partes interdependentes — quando uma quebra, não dá pra saber qual. Apps pequenos e de um único job têm taxa de conclusão muito maior.
- Mudanças devem ser feitas uma de cada vez (one change per message) — pedir 4 mudanças simultâneas ("botões maiores, dark theme, delete, totais semanais") cria um emaranhado onde não dá pra isolar o que funcionou e o que quebrou. Versões anteriores ficam salvas, então rollback é grátis.
- Debug é descritivo, não técnico: o usuário descreve o sintoma ("quando clico Add com a caixa vazia, adiciona um hábito em branco; deveria não fazer nada") e Claude encontra a causa e corrige — o usuário nunca precisa ler/editar código.

## Key insights

**PARTE 1 — DESCREVER**

1. *Escolher um app pequeno o suficiente para terminar.* Um screen, um job (tip splitter, habit tracker, flashcard quiz, calculadora de orçamento, contador, decision spinner). v1 faz uma coisa bem; features extras vêm depois. "Boring beats ambitious."

2. *Escrever a ideia como spec, não como desejo.* Padrão: substantivos = o que o usuário vê, verbos = o que acontece quando ele age. Exemplo de spec real:
```text
Build me a habit tracker as an interactive app.
- I see a list of my habits, each with a row of 7 circles (one per day).
- I click a circle to mark that day done, and it fills in green.
- At the top: a text box to name a habit and an "Add habit" button.
- Show the current streak next to each habit.
Keep it clean and simple.
```

3. *Nomear o formato/deliverable explicitamente* — esse é "o truque que quase todo mundo perde". Palavras como "interactive app", "React app", "tool", "calculator", "dashboard", "game" sinalizam "construa a coisa real". Frase de segurança quando em dúvida: "as an interactive artifact I can use and share" — elimina toda ambiguidade.

**PARTE 2 — CONSTRUIR**

4. *Iterar uma mudança por vez.* O artifact é editável e versionado. Pedir uma coisa, ver o resultado, pedir a próxima. Rollback livre — versões anteriores não custam nada.

5. *Adicionar interatividade real.* Artifacts não é mockup estático — Claude escreve React com state real: botões agem, inputs atualizam ao vivo, números recalculam. Exemplo de prompt:
```text
When I add a habit, save it to the list and clear the text box.
Show a small bar chart of how many habits I completed each day
this week, and update it whenever I check one off.
```
Inclui: inputs/botões funcionais, cálculo ao vivo, charts, timers, drag, filtros — tudo descritível em uma frase.

6. *Alimentar com dados reais* — três caminhos: colar dados (lista/tabela/CSV no chat), fazer upload de arquivo (spreadsheet/CSV, Claude lê e constrói em torno do que existe), ou digitar dentro do próprio app (inputs construídos para isso). Exemplo: "Here is my expense list as CSV. Build a dashboard that totals spending by category and shows it as a pie chart."

7. *Fazer persistir entre sessões.* Por padrão um artifact esquece tudo ao fechar. Para trackers/journals/budgets isso é inútil — o ponto é que entradas de ontem continuem lá hoje. Solução: pedir explicitamente "make it remember my habits and check-ins so they are still here when I reopen this later." Detalhe técnico importante: armazenamento de browser comum (localStorage) **não funciona** dentro de artifacts — é preciso pedir que Claude use o storage que funciona (persistência nativa do artifact).

8. *Debugar descrevendo o sintoma, não editando código.* Fraco: "it's broken." Forte: "when I click Add with the box empty, it adds a blank habit. It should do nothing if the box is empty." — dizer o que fez, o que aconteceu, o que esperava.

**PARTE 3 — PUBLICAR**

9. *Polir e publicar o link.* Passo de design: "give it a clean modern look, a calm color scheme, generous spacing, and make it work well on a phone" resolve a maior parte da aparência de protótipo. Depois, botão Publish gera URL pública: qualquer um abre sem login/conta Claude, sem hosting/servidor/deploy/domínio configurado pelo usuário, e republicar atualiza o mesmo link.

## Exemplos e evidências

Lista consolidada de "hábitos que prendem seus apps no chat" (anti-padrões):
- Começar grande demais ("build me a full CRM" trava no dia 1)
- Pedir "X" em vez de "an interactive app" (pode virar descrição em vez de produto)
- Mudar 5 coisas de uma vez (impossível isolar o que funcionou)
- Editar o código você mesmo (desnecessário — descreva a mudança)
- Deixar em dados placeholder (lorem ipsum = demo, dados reais = ferramenta)
- Esquecer persistência (tracker que esquece overnight não é tracker)
- Nunca clicar Publish (app que só você abre é um brinquedo privado)

## Implicações para o vault

- Esta fonte documenta um workflow consumer (não-dev) do Claude Artifacts — relevante como contraponto/complemento ao material já existente sobre [[03-RESOURCES/entities/Claude-Design]] e [[03-RESOURCES/concepts/claude-artifacts]] (existente, foco mais técnico). Vale considerar adicionar referência cruzada lá.
- Para o contexto FIAP/concurso, o framework "spec como substantivos+verbos, uma mudança por vez, debug por sintoma" é diretamente aplicável a estudantes prototipando ferramentas de estudo (flashcards, trackers de progresso) sem código.
- O detalhe de persistência (localStorage não funciona em artifacts; precisa pedir storage nativo) é um gotcha técnico útil de registrar para qualquer prototipagem futura via Artifacts.

## Links
- [[03-RESOURCES/concepts/claude-artifacts]]
- [[03-RESOURCES/entities/Claude-Design]]
