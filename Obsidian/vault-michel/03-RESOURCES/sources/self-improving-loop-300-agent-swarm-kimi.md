---
title: "The Self-Improving Loop: a 300-agent swarm on Kimi K2.6, verified by Opus 4.8"
type: source
source: "Clippings/The Self-Improving Loop a 300-agent swarm on Kimi K2.6, verified by Opus 4.8.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Um modelo open-weight (Kimi K2.6) consegue rodar 300 sub-agentes paralelos em até 4.000 passos coordenados a partir de um único prompt e, com um gate de verificação feito por um modelo caro (Opus 4.8), o sistema inteiro vira um loop que se torna mais barato e mais preciso a cada execução — não porque o modelo "aprende" (retreina pesos), mas porque o que envolve o modelo (specs, skills, arquivo de constraints) compõe ao longo do tempo.

## Argumentos principais
- A unidade de valor não é o modelo isolado, é o **loop**: spec → decomposição → execução paralela → verificação → captura como skill → constraints permanentes → replay → automação em background.
- Um prompt de uma linha ("pesquise o mercado de apps fitness") dá ao swarm permissão para decidir tudo errado. Uma **spec** (formato estruturado: GOAL, SCOPE, RULES, SOURCES, OUTPUT, ON CONFLICT, STOP CONDITION) é o artefato de maior leverage do processo, porque se torna a semente da skill reutilizável.
- Diferente de CrewAI/LangGraph/AutoGen, o usuário não define a estrutura de agentes — descreve o objetivo e o swarm constrói seu próprio "org chart" (decomposição automática).
- Antes de gastar créditos, é crítico **ler o plano de decomposição** (quantos sub-agentes, ordem de dependência, orçamento de passos) e confirmar antes de executar — pular essa etapa é o erro mais caro e mais comum.
- 4.000 passos é um orçamento **total coordenado** entre os agentes, não por agente — um run de 300 agentes tira média de ~13 passos cada (subtarefas curtas e especializadas).
- Cada sub-agente trabalha em uma janela de contexto própria e isolada; só o output estruturado retorna ao coordenador. Isso evita o colapso por "lossy summarization" que ocorre quando um único agente enche sua janela de contexto em tarefas longas.
- Custo baixo (US$0,95/M tokens in, US$4/M out, US$0,16 com cache hit) muda o que vale a pena tentar: dá para jogar fora a primeira tentativa e rodar de novo.
- O output deve ser sempre **arquivos reais**, não texto de chat — e a especificidade do OUTPUT na spec ("1 .xlsx, uma linha por modelo + brief de 200 palavras") evita que os agentes parem cedo, ao contrário de pedidos vagos como "um relatório completo".
- O swarm tem uma falha conhecida: sem demanda explícita de verificação, ele produz afirmações confiantes e sub-citadas, e agentes independentes às vezes se contradizem. "Parece pronto" e "está correto" são coisas diferentes.
- Opus 4.8 atua só como gate de verificação (refutar, não elogiar) — segundo a Anthropic, é ~4x menos propenso que o Opus 4.7 a deixar passar uma falha no próprio código sem comentar, e é o primeiro Claude a score 0% em relatar de forma acrítica resultados falhos.
- O loop só se torna "self-improving" de fato quando o workflow inteiro é salvo como **Skill** reutilizável (input format, passos do agente, output format, regras de validação) — a primeira execução leva 20 minutos, as seguintes 30 segundos.
- "Document-to-Skill": documentos próprios (propostas, relatórios) podem ser capturados como skill de estilo/estrutura, fazendo com que outputs futuros pareçam "seu trabalho" e não "AI slop genérico".
- O feedback do gate de verificação deve ser baked em um arquivo de constraints (CONSTRAINTS.md) lido automaticamente no início de cada sessão — transformando o erro do run #1 em regra permanente do run #2, fazendo o "verify gate" ter cada vez menos o que pegar.
- O estágio final é promover o loop estável e skill-backed a um **agente em background** disparado por schedule/novo arquivo/URL monitorada, só notificando o humano quando há desvio acima de um threshold.

## Key insights
- A métrica que importa não é "qual modelo é mais inteligente", é "quantos você consegue rodar em paralelo, quem está checando o trabalho, e se seu setup está mais afiado hoje do que ontem".
- O paralelo com o lançamento da DeepSeek é citado explicitamente: um modelo open-weight reframa o que os labs fechados achavam que possuíam, e o campo recalibra da noite para o dia.
- "Cheap volume" só é superpower quando há algo confiável checando o trabalho — sem isso, volume barato apenas escala o erro mais rápido.
- A maior parte das pessoas usa Kimi como chatbox simples (10% do produto) — o swarm de 300 agentes e o sistema de skills é a parte que quase ninguém abre.

## Exemplos e evidências
- Kimi K2.6 Agent Swarm: 300 sub-agentes paralelos × 4.000 passos por run (acima de 100/1.500 do K2.5); um run entrega 100+ arquivos, revisões de literatura de 100.000 palavras, ou datasets de 20.000 linhas.
- Pricing citado: US$0,95/M tokens de entrada, US$4,00/M de saída, US$0,16/M com cache hit.
- Caso de uso de monitoramento competitivo: primeiro run exige spec completa + verificação manual; o quarto run já é um prompt de 30 segundos contra a skill salva, com output mais afiado porque herda cada correção dos runs anteriores.
- Comparativo de tempo: 20 minutos no primeiro run, 30 segundos no run cinquenta.

## Implicações para o vault
- Reforça o padrão já presente no vault de "skill graduation" / "self-improving systems": o ganho de compostos vem do sistema em torno do modelo (specs, constraints, skills), não do modelo em si — alinhado com `claudemd-self-improvement-loop` e `self-improving-vault`.
- Confirma o padrão generator-verifier-loop já catalogado: aqui materializado como swarm (gerador) + Opus como verificador único, reforçando a tese de que verificação barata e onipresente é o que torna volume barato seguro.
- O conceito de "decomposição automática sem grafo definido pelo usuário" é uma evolução do paradigma de orquestração multi-agente além de CrewAI/LangGraph — vale registrar como contraponto a abordagens de orquestração explícita já mapeadas em `multi-agent-orchestration`.

## Links
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/claude-code-tooling/claudemd-self-improvement-loop]]
- [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]]
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]]
- [[03-RESOURCES/entities/Kimi-K2.6]]
- [[03-RESOURCES/entities/Claude-Opus-48]]
