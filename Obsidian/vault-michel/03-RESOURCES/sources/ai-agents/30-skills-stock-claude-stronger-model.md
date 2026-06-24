---
title: "30 Skills That Turn Stock Claude Into a Stronger Model"
type: source
source: "Clippings/30 Skills That Turn Stock Claude Into a Stronger Model.md"
created: 2026-06-23
updated: 2026-06-23
score: A
tags: [ai-agents, source-page, claude-skills, skill-authoring, prompt-engineering]
---

## Tese Central

A maioria das pessoas re-onboardia Claude todo dia: abre um chat novo, explica quem são, o que fazem, o tom que querem, as regras que seguem, recebem uma resposta boa, e a sessão fecha. Skills fixem isso — são conjuntos de instruções salvos que Claude carrega sozinho quando seu request combina com o que a skill é para. O artigo apresenta 30 skills práticas em 6 categorias que param a repetição diária.

## O que é uma Skill

- **Prompt** = algo que você digita uma vez, funciona para uma mensagem, e some
- **Skill** = conjunto de instruções salvo que Claude carrega sozinho quando seu request combina com a descrição
- Diferença: prompt é dizer a um novo contratado o que fazer toda manhã; skill é o contratado que já sabe o trabalho e executa quando a situação chega
- Uma skill tem duas partes: **description** (diz Claude quando usar) e **instructions** (diz Claude o que fazer)
- Você não chama a skill por nome — digita "turn this into a thread" e a skill de thread ativa sozinha
- "You stop being the context Claude needs and the context starts living inside the tool"

## Como adicionar uma skill em 2 minutos

1. Abrir skills section em settings, criar nova skill
2. Dar nome, descrição de quando deve disparar, e instruções
3. Salvar e trabalhar normalmente — ativa sozinha quando request combina

Exemplo completo (voice-match):
```text
---
name: voice-match
description: Use whenever I ask to write a post, thread, caption, or any public content in my voice
---

You write in my voice, here are the rules:
- short punchy sentences, no filler
- conversational, never corporate
- always a financial or practical angle, never abstract theory
- specific numbers over vague words
- never use: game changer, dive into, unlock, delve
- open with a hook that earns the second line

When I give you an idea, return the finished piece in this voice, not a generic version
```

## As 30 Skills (6 categorias × 5 skills)

### Content Creation
1. **Voice Match** — escreve em sua voz sem colar exemplos. Trigger: "write a post about [topic]"
2. **Quote Engine** — pega texto longo e acha 5 quotes prontas para postar. Trigger: "pull quotes from this"
3. **Repurpose Engine** — pega um conteúdo e gera versões nativas para X, LinkedIn, e script de vídeo. Trigger: "repurpose this for all platforms"
4. **Hook Lab** — gera 10 opening lines scroll-stopping. Trigger: "give me hooks for [topic]"
5. **Post Analyzer** — analisa por que um post funcionou ou não e diz o que mudar. Trigger: "analyze this post"

### Building
1. **Spec to App** — transforma descrição em plain language em app funcional, uma feature por vez. Trigger: "build me an app that [does X]"
2. **Bug Hunter** — diagnostica erro, corrige root cause, escreve teste que impede retorno. Trigger: "this is broken, here's the error"
3. **Code Reviewer** — revisa mudanças por bugs, security, bad patterns. Trigger: "review this code"
4. **Deploy Helper** — guia de código funcional a link vivo, passo a passo. Trigger: "help me deploy this"
5. **API Wiring** — conecta projeto a serviço externo com auth e error handling corretos. Trigger: "connect this to [service] API"

### Freelance
1. **Lead Qualifier** — pontua inbound message em budget, fit, intent → call ou skip. Trigger: "is this lead worth my time"
2. **Proposal Writer** — transforma brief curto em proposta com scope, price, timeline. Trigger: "write a proposal for [client]"
3. **Scope Guard** — detecta scope creep e rascunha boundary reply educada. Trigger: "is this in scope"
4. **Client Update** — transforma semana de trabalho em progress update que cliente lê. Trigger: "write a client update from this"
5. **Invoice Builder** — gera invoice itemized de uma linha de texto. Trigger: "make an invoice for [work, amount]"

### Design
1. **Brand Kit** — trava cores, fontes, estilo para consistência. Trigger: "design this on brand"
2. **Landing Page** — constrói landing page completa com copy e layout de uma descrição. Trigger: "build a landing page for [product]"
3. **Logo Concepts** — gera SVG logo directions editáveis. Trigger: "give me logo concepts for [name]"
4. **UI Critique** — revisa screen e lista o que prejudica clarity e conversion. Trigger: "critique this UI"
5. **Slide Designer** — transforma bullets em deck bem estruturado. Trigger: "make this into slides"

### Life & Productivity
1. **Morning Brief** — uma mensagem com calendar, urgent email, e algo relevante. Trigger: "give me my morning brief"
2. **Inbox Triage** — sorteia inbox em reply now, reply later, ignore. Trigger: "triage my inbox"
3. **Meal Planner** — constrói semana de refeições + grocery list. Trigger: "plan my meals for the week"
4. **Travel Planner** — transforma destino e datas em itinerário day-by-day. Trigger: "plan a trip to [place] for [dates]"
5. **Decision Helper** — lay out de hard choice com tradeoffs reais. Trigger: "help me decide between [A and B]"

### Research
1. **Company Teardown** — breakdown de business model, revenue signals, weak points. Trigger: "do a teardown of [company]"
2. **Daily Digest** — update filtrado sobre seu nicho. Trigger: "give me today's digest on [topic]"
3. **Source Checker** — verifica claim e avalia solidez da evidência. Trigger: "check this claim"
4. **Paper Summary** — transforma paper longo em findings que importam em plain language. Trigger: "summarize this paper"
5. **Competitor Watch** — tracka competidor e pinga só em moves reais. Trigger: "watch [competitor] and tell me what changes"

## Key Insights

- Skills são a transição de "re-explicar contexto todo dia" para "contexto vive dentro da ferramenta"
- Você não chama skills por nome — elas ativam sozinhas quando o request combina com a description
- Cada skill tem duas partes: description (quando) + instructions (o que)
- Skills são arquivos pequenos e simples — não precisam de setup complexo
- Não instale as 30 de uma vez — comece com as 2-3 mais usadas, sinta o impacto, expanda
- Repetição é o sinal de que uma skill deveria estar fazendo isso em seu lugar
- "The point isn't 30 skills, it's that Claude stops starting from zero every morning"

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/skill-authoring]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/ai-agents/prompt-debt]]

## Minha Síntese

**O que muda:** Skills são a unidade de captura de conhecimento repetitivo. O artigo mostra que o problema não é o modelo ser fraco — é você re-injetar contexto a cada sessão. Skills resolvem isso ao fazer o contexto viver dentro da ferramenta. A estrutura description + instructions é simples mas poderosa: a description é o roteamento automático, as instructions são o conhecimento capturado.

**Conexão pessoal:** O vault-michel já tem conceitos sobre agentic-skills e skill-authoring. Este artigo fornece 30 exemplos concretos que podem servir como template para criar skills para o Hermes Agent ou para Claude Code. A categoria Research (company-teardown, daily-digest, source-checker, paper-summary) é diretamente aplicável ao workflow de ingest do vault — automatizar parte da extração de tese central e key insights.

**Próximo passo:** Criar 2-3 skills reais para o workflow de ingest do vault: uma que extrai tese central e key arguments de um Clipping, uma que gera a estrutura de source page seguindo as convenções do vault, e uma voice-match para garantir consistência de tom nas sínteses.