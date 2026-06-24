---
title: "Company Brain, Part 3: Interaction Memory"
type: source
source_type: article
created: 2026-05-06
tags: [memory, enterprise, interactions, context]
triagem_score: 7
---

Part 3: Interaction memory captures patterns from conversations, meetings, and communications. Temporal context, relationship dynamics, and interaction-based learning for organizational AI.

## Source

Ingested from: `clippings/Company Brain, Part 3 Interaction Memory.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## O que é memória de interação

Memória de interação é a camada que registra **como** pessoas se comunicam — não apenas **o que** foi decidido. É a diferença entre ter a ata de uma reunião e ter o entendimento de quem influencia quem, quais tópicos disparam conflito e quais abordagens funcionam com determinado stakeholder.

Enquanto a Part 1 da série trata da distinção data vs. memória e a Part 2 lida com memória documental, a Part 3 vai um nível acima: **memória emergente de padrões de interação ao longo do tempo**.

## Dimensões capturadas

**1. Contexto temporal**
Decisões têm genealogia. Saber que uma escolha técnica foi tomada sob pressão de deadline de Q3/2024 muda completamente como deve ser revisitada em 2025. Interaction memory preserva o momento, a urgência e o estado emocional da organização.

**2. Dinâmica de relacionamentos**
Quem pede validação de quem? Quais duplas produzem os melhores outputs? Quem raramente discorda em reunião mas bloqueia em execução? Esses padrões não aparecem em documentos — emergem apenas da análise de interações longitudinais.

**3. Aprendizado baseado em interação**
Diferente de RAG sobre documentos, interaction memory aprende de conversas não estruturadas: Slack, e-mail, transcrições de reunião, comentários em PRs. O sinal é mais ruidoso mas mais rico em contexto social e organizacional.

## Mecanismo técnico

A implementação típica envolve três camadas:

- **Captura:** integração com ferramentas de comunicação (Slack, Teams, email, Zoom transcripts). Eventos são normalizados em um esquema comum com participantes, timestamps, referências a entidades (projetos, decisões, pessoas).
- **Indexação semântica:** embeddings gerados por evento ou por janela de conversa. Armazenados em vector DB com metadata temporal e de participantes para filtragem híbrida.
- **Síntese periódica:** agentes rodando em batch (diário ou semanal) que consolidam padrões: "nos últimos 30 dias, o tópico X foi mencionado 47 vezes, principalmente por engenharia com tom de preocupação". Esse resumo alimenta o contexto do sistema.

## Comparação com memória documental

| Dimensão | Memória documental | Memória de interação |
|---|---|---|
| Fonte | Docs, wikis, relatórios | Conversas, reuniões, Slack |
| Estrutura | Semi-estruturada | Não estruturada |
| Atualização | On-demand | Contínua |
| Sinal | Decisões formais | Intenções, emoções, poder |
| Ruído | Baixo | Alto |
| Latência | Alta (doc precisa existir) | Baixa (captura em tempo real) |

## Desafios e limitações

**Privacidade:** monitorar interações levanta preocupações sérias. Funcionários com razão resistem a que conversas informais alimentem sistemas de IA. Requer consentimento explícito, granularidade de controle e anonimização antes de indexação.

**Viés de canal:** quem escreve mais no Slack fica sobre-representado. Decisões tomadas em chamadas de voz sem transcrição somem. A memória reflete os canais monitorados, não a organização real.

**Decay:** interações antigas podem ser mais ruído que sinal. Uma discussão de 3 anos sobre uma arquitetura abandonada não deve pesar igual a uma conversa de ontem. Mecanismos de temporal decay (pesos decrescentes com o tempo) são essenciais.

**Hallucination de padrões:** agregação de interações pode produzir "insights" estatisticamente plausíveis mas incorretos. Ex.: correlação entre horário de mensagem e qualidade da decisão não implica causalidade.

## Aplicações práticas

- **Onboarding acelerado:** novo engenheiro pergunta "por que usamos essa lib?" — o sistema responde com a conversa original de decisão, incluindo as objeções levantadas e o raciocínio final.
- **Briefing de reunião:** antes de uma 1:1, o executivo recebe um resumo dos últimos 90 dias de interações com aquela pessoa — tópicos recorrentes, pendências, tom geral.
- **Detecção de silos:** análise de grafo de interações revela equipes que não se comunicam, potenciais gargalos de informação.
- **Institutional memory preservation:** quando sêniors saem, suas interações ficam — incluindo o raciocínio não documentado.

## Relevância para o vault

Este vault opera com uma versão pessoal de interaction memory: as conversas com agentes são loggadas em `04-SYSTEM/logs/`, erros e correções vão para `04-SYSTEM/wiki/errors.md`, e o padrão de quais perguntas são feitas ao Nexus revela onde o conhecimento está fragmentado. Expandir essa camada — capturando padrões de quais tópicos são consultados com maior frequência — permitiria ao sistema sugerir consolidações proativamente.

## Implementação técnica em profundidade

### Captura granular vs. captura em massa

A captura de todas as interações gera ruído proporcional ao volume. O approach mais eficaz em implementações práticas é **captura seletiva baseada em sinal**:

- **Decisões explícitas:** mensagens contendo "vamos fazer X", "decidimos Y", "aprovado Z" — sinal alto, captura obrigatória
- **Perguntas recorrentes:** a mesma pergunta feita por pessoas diferentes em canais diferentes indica gap de conhecimento — sinal médio, captura para síntese
- **Conflitos não resolvidos:** threads com muitas respostas e sem consenso final — sinal para escalonamento ou documentação de trade-off
- **Conversas rotineiras:** updates de status, confirmações, smalltalk — ruído, descartável

Um classificador simples (rule-based ou LLM) pode fazer essa triagem antes da indexação, reduzindo o volume de embeddings e melhorando a relação sinal-ruído da memória.

### Decay temporal: implementações comuns

**Exponential decay:** peso de cada interação decresce exponencialmente com o tempo. $w(t) = e^{-\lambda t}$. Simples, mas não distingue entre informação que envelhece (decisão técnica superada) e informação perene (padrão de comunicação de um stakeholder).

**Event-based reset:** certas classes de eventos reiniciam o decay de itens relacionados. Uma reunião de retrospectiva que revisita uma decisão antiga "refresca" os itens relacionados na memória — eles voltam a ter peso alto porque ficaram relevantes novamente.

**Topic-based TTL:** diferentes categorias de informação têm TTL diferente. Decisões técnicas: 6 meses. Preferências de comunicação de stakeholder: 2 anos. Crises e seus resolutores: indeterminado (alta frequência de consulta em situações de crise similares).

### Grafo de interações como mapa de poder

A análise do grafo de interações — quem fala com quem, quem inicia vs. quem responde, quem é consistentemente o terceiro ponto de uma conversa bilateral — revela estrutura de poder informal que não aparece em nenhum organograma:

- **Brokers de informação:** pessoas que consistentemente aparecem em conversas entre equipes que raramente se comunicam diretamente
- **Validadores implícitos:** pessoas cujo sinal de aprovação (mesmo que não formal) precede a maioria das decisões de uma área
- **Silos detectáveis:** pares de equipes com zero interação em um período — indicador de desalinhamento potencial

Esse mapa tem valor para onboarding de liderança, planejamento de reestruturação, e detecção precoce de disfunção organizacional.

## Comparação com memória episódica humana

A memória de interação organizacional é análoga à memória episódica humana — memória de eventos específicos em contexto temporal. Neurociência sugere que memória episódica é particularmente robusta quando o evento tem carga emocional ou novidade. Sistemas de interaction memory podem simular isso priorizando interações com indicadores de urgência, conflito, ou primeira ocorrência de um tópico.

O risco inverso também existe: a memória episódica humana é altamente reconstrutiva — lembramos do que queremos lembrar, não do que aconteceu. Sistemas de interaction memory que agregam ao longo do tempo podem criar "narrativas" organizacionais que refletem o viés dos dados de treinamento (quem escreve mais, quais canais são monitorados) em vez da realidade organizacional.

## Aplicação expandida no vault

Além do que já foi documentado (logs de agentes, errors.md), o vault poderia implementar interaction memory de forma mais estruturada:

**Padrões de consulta:** registrar automaticamente quais tópicos são consultados ao Nexus com maior frequência — esses são os conceitos com maior demanda de clareza, candidatos a expansão ou reorganização.

**Histórico de decisões:** quando o Nexus escolhe entre duas abordagens possíveis (ex: criar nova página vs expandir existente), registrar a decisão e o raciocínio em um log de decisões. Isso cria uma memória de preferências que pode guiar decisões futuras similares.

**Mapa de consolidações:** rastrear quais fontes foram consolidadas com quais conceitos — para detectar quando uma área de conhecimento está fragmentada em muitas fontes sem consolidação central.

## Links

- [[03-RESOURCES/sources/memory-context-rag/clipping-company-brain-part-1-data-vs-memory]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
- [[03-RESOURCES/concepts/retrieval-augmented-generation]] — interaction memory como alternativa a RAG documental puro
