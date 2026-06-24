---
title: "How to QUICKLY set up Claude Cowork (the right way)"
type: source
source_file: ".raw/articles/How to QUICKLY set up Claude Cowork (the right way).md"
author: Corey Ganim (@coreyganim)
ingested: 2026-04-17
tags: [claude-cowork, setup, onboarding, context-files, global-instructions, scheduled-tasks]
triagem_score: 7
---

# How to QUICKLY set up Claude Cowork (the right way)

**Autor:** [[03-RESOURCES/entities/Corey-Ganim]] (@coreyganim)

## Resumo

Guia de onboarding de 30 minutos para o [[03-RESOURCES/entities/Claude-Cowork]]. Detalha 6 passos: conectar ferramentas, criar 3 arquivos de contexto, configurar global instructions, instalar skills, criar primeira tarefa agendada e calibrar na primeira semana.

> [!tip] Insight chave
> A configuração de 30 minutos mais 5 minutos/dia de calibração na primeira semana é o que separa quem usa Claude como chatbot genérico de quem opera como se tivesse um time de 10 pessoas.

## Os 6 passos

### 1. Conectar ferramentas primeiro (5 min)
Conectar **antes** de criar arquivos de contexto — assim Claude pode varrer documentos existentes do Drive em vez de você digitar tudo do zero. Conectores mínimos:
- Google Workspace (Drive, Gmail, Calendar) — "não negociável"
- Slack ou Teams
- Notion / Asana / Linear
- Zoom (novo em abril 2026 — puxa contexto de reuniões e gravações)

**Teste rápido:** peça para Claude encontrar um documento recente no Drive.

### 2. Três arquivos de contexto (10 min)

| Arquivo | Conteúdo |
|---------|----------|
| `about-me.md` | O que faz, projetos atuais, clientes, ferramentas, pessoas-chave |
| `voice.md` | Estilo de comunicação, palavras odiadas, exemplos de escrita real |
| `preferences.md` | Perguntas vs execução direta, formato de output, regras rígidas |

**Atalho:** Claude pode varrer o Drive e rascunhar 80% do `about-me.md` automaticamente.

### 3. Global Instructions (~800 palavras)
Condensa os 3 arquivos em um brief permanente. Estrutura:
- Quem sou (2-3 frases)
- Como trabalho (preferências)
- Output defaults (emails → bullets; conteúdo → parágrafos; pesquisa → tabelas)
- Voz (3-4 características)
- Contexto de negócio atual
- Regras (sempre X, nunca Y)

**Onde ativar:** Claude Desktop → Settings → Cowork → Global Instructions

### 4. Instalar 3-5 skills (5 min)
Olhar a última semana: o que foi repetitivo? Começar com isso. Instalar plugins por keyword no buscador do Cowork.

### 5. Primeira tarefa agendada (5 min)
Exemplos iniciais:
- **Morning briefing** (dias úteis, 8h): inbox urgente + agenda + top 3 prioridades
- **Weekly recap** (sexta, 16h): completadas + atrasadas + wins da semana
- **Meeting prep** (30 min antes de calls): contexto do interlocutor + 3 talking points

Regra: quanto mais específico o prompt da tarefa, melhor o output. "Summarize my inbox" → genérico. Especificar critérios → utilizável.

### 6. Calibração na primeira semana
Tratar semana 1 como calibração, não produção. Cada erro = feedback explícito para ajustar. Ao fim da semana: 2-3 edits nos context files, global instructions mais enxutas, tarefas agendadas refinadas.

## Conceitos relacionados
- [[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]] — plugins que estendem este setup
- [[03-RESOURCES/entities/Claude-Cowork]] — o produto configurado
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — conectores MCPs subjacentes

## O princípio de "conectar primeiro" — por que a ordem importa

A instrução de conectar ferramentas antes de criar arquivos de contexto não é preferência de UX — é a ordem que maximiza a qualidade dos context files. Quando Drive está conectado, Claude pode:

1. Varrer os últimos 30 documentos ativos no Drive
2. Identificar padrões de projeto, stakeholders recorrentes, terminologia usada
3. Gerar 80% do `about-me.md` a partir de documentos reais

Sem Drive conectado, o usuário precisa descrever manualmente quem são seus clientes, quais são seus projetos, quais são suas ferramentas. Esse processo é tedioso e produz context files genéricos que não capturam nuances do trabalho real.

O "teste rápido" — pedir para Claude encontrar um documento recente no Drive — serve como health check: confirma que a integração está funcionando antes de construir context files que dependem dela.

## Os 3 context files — engenharia do contexto persistente

A separação em `about-me.md`, `voice.md`, e `preferences.md` não é arbitrária — cada arquivo serve uma função cognitiva diferente:

**`about-me.md` — contexto factual:** quem o usuário é no contexto profissional. O que faz, em qual empresa, quais são os projetos atuais, quais clientes, quais ferramentas usa regularmente, quais são as pessoas-chave com quem trabalha. Claude usa isso para calibrar a relevância de respostas (não sugerir integração com Jira se a empresa usa Linear).

**`voice.md` — calibração de estilo:** este é o arquivo mais impactante para qualidade de output. Não descreve o que você quer — mostra como você escreve e comunica. Inclui:
- Exemplos reais de emails enviados (o mais eficaz para calibrar tom)
- Palavras e frases que você nunca usa ("proativo", "sinergia", "alavancar")
- Comprimento típico de comunicações (você responde emails em 2 linhas ou 5 parágrafos?)
- Nível de formalidade por contexto (email para CEO vs slack para colega)

**`preferences.md` — regras de comportamento:** como Claude deve tomar decisões sobre como interagir. A distinção "perguntar vs executar diretamente" é a mais crítica: alguns usuários querem Claude perguntando se deve continuar; outros querem execução direta com report do resultado. Sem essa definição, Claude usa defaults que podem ser o oposto do que o usuário prefere.

## As Global Instructions como destilação de contexto

O processo de condensar os 3 arquivos em ~800 palavras de Global Instructions tem uma lógica específica:

Os context files são ricos mas longos — um `about-me.md` bem feito pode ter 2.000 palavras. Colocar tudo como Global Instructions consumiria tokens em cada sessão sem retorno proporcional. A destilação resolve isso: os 80/20 de cada context file (o que é mais crítico, mais frequentemente relevante) vai para Global Instructions; o detalhe completo fica nos context files para referência.

A estrutura recomendada de ~800 palavras:
- Quem sou (2–3 frases): suficiente para calibração básica
- Como trabalho (preferências centrais): as top-3 regras de comportamento
- Output defaults: o que Claude deve produzir por default para cada tipo de request
- Voz (3–4 características): o essencial do voice.md
- Contexto de negócio atual: o projeto mais importante neste momento
- Regras (sempre X, nunca Y): as hard constraints

## O papel das tarefas agendadas na operação cotidiana

As tarefas agendadas transformam Claude Cowork de ferramenta reativa em sistema proativo. A diferença é qualitativa:

**Modo reativo (sem tarefas agendadas):** Claude responde quando invocado. O usuário precisa lembrar de pedir o briefing matinal, o recap semanal, a prep de reunião. Dependência de memória humana para aproveitar o sistema.

**Modo proativo (com tarefas agendadas):** Claude monitora e entrega contexto antes de ser solicitado. O briefing matinal aparece às 8h sem ação do usuário. O recap de sexta está pronto às 16h. A prep de reunião chega 30 minutos antes da call.

A regra "quanto mais específico o prompt, melhor o output" se aplica com força especial a tarefas agendadas porque não há ciclo de refinamento interativo. O prompt precisa ser preciso o suficiente para produzir output utilizável sem follow-up. Exemplo:

**Vago:** "Summarize my inbox"
**Específico:** "Revise meu Gmail das últimas 24h. Identifique emails que exigem ação hoje (deadline ou urgência). Para cada um: sender, assunto, ação necessária, deadline se mencionado. Limite a 5 items. Ignore newsletters e notificações automáticas."

## Calibração na primeira semana — o que ajustar

O conselho de tratar semana 1 como calibração, não produção, é pragmático. O que tipicamente precisa de ajuste:

**Global Instructions muito genéricas:** os defaults do Cowork são razoáveis mas não capturam especificidades. Após 5 dias de uso, o usuário sabe quais instruções fazem diferença no output e quais são ruído.

**Tarefas agendadas com prompts vagos:** o briefing matinal que produz output genérico na segunda-feira revela que o prompt precisa de mais especificidade. Iterar até que o output seja diretamente utilizável sem revisão.

**Skills irrelevantes:** instalar 5 skills e descobrir que 2 não se aplicam ao trabalho real. Desinstalar para reduzir ruído de slash commands disponíveis.

**Output defaults errados:** se Claude está respondendo emails com bullets quando você prefere prosa, ajustar nos Output defaults das Global Instructions.

## Conceitos relacionados
- [[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]] — plugins que estendem este setup
- [[03-RESOURCES/entities/Claude-Cowork]] — o produto configurado
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — conectores MCPs subjacentes

## Referências cruzadas
- Artigo complementar: [[03-RESOURCES/sources/claude-code-cowork/cowork-plugin-guide-coreyganim]] — plugins e slash commands
