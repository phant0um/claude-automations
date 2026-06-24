---
title: "Peter Yang — Personal OS com Claude Code (baseado em Moritz)"
type: source
source_file: "Clippings/Thread by @petergyang on Thread Reader App.md"
origin: thread no X (@petergyang)
ingested: 2026-05-14
tags: [claude-code, personal-os, memory, skills, routines, moritz]
triagem_score: 8
---
# Peter Yang — Personal OS com Claude Code (baseado em Moritz)

> [!key-insight] Core point
> 5 takeaways de Moritz sobre como montar um Personal OS com Claude Code: estrutura de arquivos, memory loop, CLIs/MCPs, skills por workflow, e routines locais + remotas.

## Conteúdo

### 1. Estrutura de arquivos base
- `soul.md` — personalidade e tom do agente
- `user.md` — o que o agente sabe sobre você
- `tools.md` — lista de CLIs/MCPs/APIs disponíveis
- `memory/` — notas diárias de chats passados + arquivo de memória long-term

### 2. Memory Loop
- Regra no `claude.md`: após toda conversa, escrever uma linha num arquivo de memória diária
- Rotina noturna ("Dreaming"): comprime arquivos diários em memória long-term

### 3. CLIs, MCPs e APIs críticos
- `gws` CLI — Google Workspace
- `wacli` — WhatsApp
- `postiz cli` — posting em social platforms

### 4. Skill por workflow repetido
- Qualquer workflow feito 2× → virar skill
- Exemplos: skill de compras (reabastece carrinho da semana anterior), skill de upload de vídeo (cria pastas Drive para editor)
- Anthropic official skills: [github.com/anthropics/skills](https://github.com/anthropics/skills)

### 5. Routines locais e remotas
- **Local:** CEO Brief (sumário do dia), todo diário, Dream (compressão noturna de memória)
- **Remote (GitHub):** planejamento semanal de conteúdo, YouTube monitor de canais concorrentes

**Recursos:** [Tutorial completo (YouTube)](https://youtu.be/ACRd0Ikg_KI) | [Post escrito](https://creatoreconomy.so/p/build-a-claude-code-personal-os-step-by-step-moritz)

## A estrutura de arquivos em detalhe

O Personal OS de Moritz é uma implementação concreta de algo que a maioria dos projetos de "agente pessoal" deixa abstrato: o conjunto mínimo de arquivos que um agente precisa para agir como assistente pessoal eficaz.

### soul.md — O "caráter" do agente

Não é apenas um prompt de sistema. É um documento que define como o agente se comunica: formal ou casual, direto ou elaborado, quando questionar ou quando executar. Sem um `soul.md` explícito, o agente adapta o estilo ao contexto da conversa — o que significa inconsistência entre sessões. Com `soul.md`, o estilo é determinístico e previsível.

### user.md — Contexto persistente sobre o usuário

O que o usuário faz, onde mora, preferências alimentares, horário de trabalho, compromissos regulares, pessoas importantes na vida do usuário. Isso é o que permite ao agente fazer sugestões contextualizadas — "você tem reunião com João amanhã, quer preparar a pauta?" — sem o usuário precisar re-explicar sua vida a cada sessão.

### tools.md — Inventário de capacidades

Lista de CLIs, MCPs, e APIs disponíveis com uma linha de descrição de cada um. O agente consulta `tools.md` antes de planejar uma ação para saber o que pode usar. Sem isso, o agente pode planejar ações que dependem de ferramentas que não estão instaladas, ou ignorar ferramentas que poderiam resolver o problema mais eficientemente.

### memory/ — Dois layers distintos

- **Diário (notas de sessão):** arquivo por dia com uma linha por conversa — "2026-05-21: revisou PR do módulo de pagamentos, preferiu abordagem B sobre A por legibilidade"
- **Long-term (arquivo consolidado):** memória comprimida de semanas/meses — os padrões e preferências que persistem, não os detalhes efêmeros

## O Memory Loop em detalhe

A regra no `claude.md` que força uma linha de memória após cada conversa é simples mas tem implicações importantes. Ela converte o agente de "ferramenta que esquece" em "assistente que aprende". A linha de memória captura:
- O que foi feito
- Qual abordagem foi escolhida (quando havia alternativas)
- O que o usuário aprovou ou rejeitou

Com o tempo, o arquivo diário acumula evidência sobre as preferências do usuário que é mais confiável do que qualquer declaração explícita de preferência — porque reflete comportamento real, não intenção declarada.

### Dreaming: compressão noturna

A rotina noturna de compressão (o "Dreaming" de Lance Martin) converte arquivos diários em memória long-term. O processo:
1. Lê os últimos N dias de notas
2. Identifica padrões recorrentes (preferências consistentes, erros repetidos, workflows que funcionaram)
3. Gera uma entrada consolidada em `memory/long-term.md`
4. Opcionalmente arquiva ou deleta os arquivos diários já processados

O resultado é que o agente na próxima sessão carrega memória comprimida de meses, não logs brutos de cada conversa — custo de contexto controlado, sem perder a substância.

## Skills por workflow: o threshold de 2×

A regra "qualquer workflow feito 2× vira skill" é um princípio de automação pragmático. Na segunda vez que você executa o mesmo workflow, você já tem evidência suficiente de que é recorrente. Criar o skill na segunda vez custa menos do que esperar pela quinta — porque você ainda tem o workflow fresco na memória.

O exemplo de compra semanal ilustra o padrão: skill de compras que reabastece o carrinho baseado na semana anterior captura preferências implícitas (o usuário sempre compra leite integral, não desnatado) que seriam difíceis de especificar explicitamente mas fáceis de aprender por observação.

## Routines: local vs remoto

A distinção local/remoto é sobre onde o código roda, não sobre onde o agente está:

- **Local (agendado na máquina):** CEO Brief e todo diário rodam de manhã, Dream roda à noite. Dependem do computador estar ligado e conectado.
- **Remote (GitHub Actions/similar):** planejamento semanal de conteúdo e monitoramento de YouTube rodam na infraestrutura do GitHub, independentemente de a máquina do usuário estar ligada.

Para routines críticas (memória, briefs diários), local é mais confiável — você tem controle. Para routines de monitoramento que precisam rodar 24/7, remote é mais adequado.

## Limitações

- Requer CLIs específicos (`gws`, `wacli`, `postiz`) que precisam de setup e auth separados
- O Dreaming manual (mesmo que automatizado) pode perder nuances que o diário capturava
- `user.md` precisa de atualização quando a vida do usuário muda — informação desatualizada é pior que ausência de informação
- Routines remotas têm custos de API (GitHub Actions tem limite gratuito)

## Conexões
- [[03-RESOURCES/entities/Peter-Yang]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/pkm-obsidian/self-writing-vault]]
