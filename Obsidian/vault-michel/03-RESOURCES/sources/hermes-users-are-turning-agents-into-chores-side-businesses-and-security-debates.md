---
title: "Hermes users are turning agents into chores, side businesses, and security debates"
type: source
source: "Clippings/Hermes users are turning agents into chores, side businesses, and security debates.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Uma varredura de threads do r/hermesagent no Reddit (artigo gerado pelo próprio Hermes Agent a partir dos top 100 posts do subreddit em um mês) mostra que a comunidade não está debatendo se agentes são transformadores — está debatendo detalhes operacionais: qual modelo é barato o suficiente para rodar sem falir, o que um agente deveria ter permissão para tocar, e quais tarefas são tediosas o bastante para serem definitivamente terceirizadas.

## Argumentos principais
- Tokens baratos mudaram o cálculo: thread sobre DeepSeek v4 Pro ("quase de graça, melhor que Opus para mim") teve 402 comentários; um usuário relatou ter processado 8 bilhões de tokens em DeepSeek v4 em poucas semanas por $60; outro relatou que DeepSeek "loopou" em trabalho de setup até um modelo mais caro ajudar a corrigir.
- O debate de custo rapidamente se tornou político: threads sobre DeepSeek viraram discussões sobre dados, China, EUA e que tipo de risco de provedor as pessoas aceitam por volume barato.
- Threads de ansiedade recorrente sobre gasto: "Burned through $10 in an hour", "Budget Model for Hermes", "Best 20 USD/month token plan for 1B tokens/month", "You're probably accidentally tokenmaxxing. Learn to delegate more" — a tese do artigo é que um agente torna a escolha de modelo *operacional*: modelo barato bom-o-suficiente muda a frequência com que as pessoas deixam o sistema rodar; modelo caro que economiza horas de debug ainda pode vencer.
- Os exemplos mais comentados não eram visionários, eram mundanos: reverse-engineering de app de ônibus escolar anunciado via Alexa; gestão de reclamações médicas fora da rede (coleta de superbill, parse de itens, upload, captura de tela para aprovação, submissão, criação de lembrete de acompanhamento); alertas de preço de voo; scraping de eventos; monitoramento de ofertas.
- Caso de microbusiness: "I made €2,700 last month installing Hermes Agent for French companies" — oferta era instalação, configuração, monitoramento, ajuste de workflow e hosting, com empresas pagando seu próprio uso de LLM. Réplicas migraram rápido de "como você encontrou clientes?" para o que pequenas empresas queriam: Slack conectado a base de conhecimento, alertas de notícias curados, automações, workflows específicos da empresa.
- A pergunta de risco que ligou tudo: "who is responsible if hermes leaks the company api?" — uma vez que um agente é útil o bastante para vender, rodar toda semana, ou se conectar a sistemas de negócio, ele deixa de ser "problema de brinquedo".
- A discussão de confiança mais afiada veio de um post (maior score do mês, 200+ comentários) revelando que instalações padrão do Hermes (e de outros) roteiam silenciosamente tráfego web para "Parallel" sem disclosure explícito — réplicas propuseram contramedidas práticas: SearXNG self-hosted, Firecrawl, Camoufox, Little Snitch no macOS, aprovação explícita antes de chamadas externas, e escaneamento de mudanças open-source antes de atualizar.
- Mesma preocupação de instalação local apareceu em dois posts distintos sobre rodar Hermes em desktop/home server vs. Docker — acesso local é útil precisamente porque está mais perto de fotos, configs, API keys, comandos shell e estado do home-server do que um app de chat selado estaria.
- Post popular de setup ("here's the first thing you MUST do with your Hermes Agent") argumentou: comece com skills, depois tools — skills definem o que o agente sabe fazer, tools definem o que ele pode tocar. Réplica pressionou: "default should be off... one of my agents is down to 5 skills now."
- A comparação direta com Claude apareceu em "Why use Hermes over Claude?": vários comentários admitiram que Claude pode ser mais "smooth"; o caso do Hermes foi enquadrado em torno de ownership, memória local, skills editáveis, cron jobs, troca de provedor, e capacidade de rodar de uma VPS ou caixa que você controla. Citação direta: "If you want the smoothest paid app experience, Claude may just be easier. If you want an agent you can bend into your own weird little operating system, Hermes makes more sense."
- Posts sobre memória e skills não foram conversa de nicho — foram o assunto principal: "Memory Providers: I tested them all" (152 comentários), "Landscape of second brain and memory solutions for AI native workflow" (82 comentários), "Create skills first if u want to use cheap models", "I built model-task-router, a Hermes skill that auto-routes tasks to the right model".

## Key insights
- Citação reveladora sobre expectativa do usuário: alguém descreveu um setup como doloroso e foi repreendido — "Every time the ai tells me what steps I need to run next, I'm like, no son, that's your job now ;)" — mostra que usuários esperam que o próprio agente execute os passos de setup, não apenas instruir o humano a fazê-los.
- O mês não chegou a uma resposta única sobre "para que serve o Hermes" — em vez disso, mostrou uma pergunta mais estreita e útil tomando conta da conversa: que parte do seu trabalho é estruturada, frequente e tediosa o bastante para que um agente deva ser dono dela, e quais limites precisam existir antes de deixá-lo tentar?

## Exemplos e evidências
- Threads citadas com contagem de comentários como evidência de saliência: DeepSeek v4 pro (402), "Hermes Agent default installs silently routing web traffic to Parallel" (maior score do mês, 200+ comentários), Memory Providers (152), Landscape of second brain/memory (82).
- Citações diretas atribuídas a usuários específicos do Reddit (u/rjn2-8, u/fAngXXX_, u/Veduis, u/itsdodobitch, u/CapitalIncome845, u/boudywho, u/hometechgeek) — método jornalístico de citar handles como fonte primária.
- Nota meta do próprio artigo: gerado via scripts que buscam top 100 posts de um subreddit no último mês e processam com um LLM após etapas de ordenação — o artigo é, ele mesmo, um produto de pipeline agêntico de pesquisa.

## Implicações para o vault
Evidência forte e atual (mid-2026) para `[[03-RESOURCES/concepts/agent-systems/agent-security]]` e `[[03-RESOURCES/concepts/agent-systems/claude-code-security]]` — particularmente o caso do roteamento silencioso de tráfego web sem disclosure é um exemplo concreto de "default permission" mal configurado, relevante para qualquer decisão futura sobre MCP servers/tools padrão no próprio vault. Também conecta com `[[03-RESOURCES/concepts/agent-systems/model-routing]]` (escolha de modelo como decisão operacional, não cosmética) e oferece contraponto honesto a `[[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]`, equilibrando o entusiasmo de outra source deste batch (3-agent research department) com os riscos reais relatados pela própria comunidade de usuários.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-security]]
- [[03-RESOURCES/concepts/agent-systems/model-routing]]
- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/entities/Claude]]
