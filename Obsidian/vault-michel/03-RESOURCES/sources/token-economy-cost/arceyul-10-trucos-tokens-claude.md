---
title: "arc. — 10 trucos para usar Claude todo el día sin agotar tokens"
type: source
source_file: "Clippings/Thread by @arceyul on Thread Reader App.md"
origin: thread no X (@arceyul)
ingested: 2026-05-14
tags: [claude, token-efficiency, prompts, produtividade, trucos]
triagem_score: 7
---
# arc. — 10 trucos para usar Claude todo el día sin agotar tokens

> [!key-insight] Core point
> Claude conta tokens, não mensagens — 10 técnicas para maximizar uso diário sem atingir o limite, com estimativas de economia por técnica.

## Conteúdo

| # | Técnica | Economia estimada |
|---|---|---|
| 1 | Editar prompt original (ícone ✏️) em vez de acumular follow-ups | Até 40% tokens |
| 2 | Nova conversa a cada ~20 mensagens (pedir resumo, copiar, reabrir) | Até 50× menos tokens/turno |
| 3 | Agrupar várias perguntas num único mensagem | Proporcional ao nº de turnos economizados |
| 4 | Subir arquivos recorrentes a Projetos (cache) | Zero custo por reusar |
| 5 | Configurar memória + instruções personalizadas uma vez (Settings → Memory) | Elimina 3-5 msgs de setup |
| 6 | Desativar busca web, modo pesquisa, conectores quando não necessários | Tokens extra eliminados |
| 7 | Usar Haiku para tarefas simples (formatação, gramática, brainstorm) | Custo significativamente menor |
| 8 | Escolher modelo pela tarefa: Haiku / Sonnet / Opus | Até 5× diferença de custo |
| 9 | Distribuir em 2-3 sessões diárias (janela de 5h reinicia) | 150-200 msgs/dia vs 45 em sessão única |
| 10 | Identificar maiores consumidores (docs extensos, conversas longas, busca web) | Otimiza casos de uso custosos |

**Prompt de resumo para nova conversa:**
```
Resume los puntos clave de esta conversación en 5 viñetas concisas,
incluyendo el contexto esencial, decisiones tomadas y próximos pasos,
para que pueda continuar en un nuevo chat.
```

## Conexões
- [[03-RESOURCES/entities/arceyul]]
- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]]

---

## Mecanismo: por que Claude conta tokens, não mensagens

Um equívoco comum sobre planos com "limite de mensagens": o Claude Pro cobra por uso de contexto (tokens processados), não por número de mensagens. Isso tem implicações práticas importantes:

- Uma mensagem com 10 arquivos anexos pode consumir mais tokens que 20 mensagens simples
- Um histórico de conversa longo é retransmitido a cada turno — tokens acumulam exponencialmente
- Web search, análise de imagens e raciocínio estendido consomem tokens extras além do texto

As 10 técnicas do @arceyul atacam exatamente esses três vetores.

## Análise técnica de cada técnica

### Técnica 1: Editar prompt original em vez de acumular follow-ups

Cada follow-up mensagem adiciona ao histórico da conversa. O histórico completo é retransmitido a cada turno. Editar o prompt original (ícone ✏️ no Claude.ai) substitui a versão anterior em vez de adicionar — o contexto não cresce.

**Quando usar**: quando o problema era no prompt, não na resposta. Se você precisa de mais output baseado na resposta, follow-up é correto. Se o prompt estava errado, edite.

### Técnica 2: Nova conversa a cada ~20 mensagens

Uma conversa de 20 mensagens com resposta média de 500 tokens = ~10.000 tokens de histórico sendo retransmitidos. Na mensagem 21, pagar por 10.000 tokens de contexto para processar uma nova pergunta de 50 tokens.

O prompt de resumo fornecido é a chave: extrair o essencial antes de abrir nova conversa. O resumo de 5 pontos (~300 tokens) substitui 10.000 tokens de histórico — redução de 97%.

**Quando usar**: qualquer conversa que passou de 15-20 turnos. Especialmente após blocos de debugging ou exploração que já foram resolvidos.

### Técnica 3: Agrupar múltiplas perguntas em uma mensagem

Cada turno tem overhead de processamento. Três perguntas em três turnos = três overheads + três vezes o histórico. Três perguntas em um turno = um overhead + o histórico uma vez.

**Quando usar**: quando as perguntas são independentes e podem ser respondidas em paralelo. Não agrupar perguntas sequenciais onde a resposta de uma muda o contexto da próxima.

### Técnica 4: Subir arquivos recorrentes a Projetos (cache)

Projetos do Claude.ai armazenam arquivos no cache — eles são carregados uma vez e reutilizados em múltiplas conversas sem custo adicional por reutilização. O CLAUDE.md do vault é um exemplo: definido uma vez, cacheado, referenciado em cada sessão sem custo de retransmissão.

**Quando usar**: qualquer documento que você usa em mais de 3 conversas diferentes — código de referência, guidelines, bases de conhecimento, templates.

### Técnica 5: Configurar memória e instruções uma vez

Instruções de personalidade e comportamento repetidas em cada conversa consomem tokens todo turno. Configuradas em Settings → Memory/Instructions, são carregadas automaticamente e podem ser otimizadas pelo Claude para máxima densidade.

**Quando usar**: qualquer preferência que você repetiria em mais de 2 conversas ("sempre responda em PT-BR", "use markdown", "seja conciso").

### Técnica 6: Desativar features não necessárias

Web search, análise estendida e conectores adicionam tokens de contexto e processamento mesmo quando não relevantes para a tarefa. Um resultado de web search pode adicionar 2.000-5.000 tokens de contexto de resultados mesmo para uma pergunta simples.

**Quando usar**: desativar por padrão e ativar explicitamente quando necessário. "Pesquise na web sobre X" é melhor que deixar o web search sempre ativo.

### Técnica 7 e 8: Roteamento por modelo (Haiku / Sonnet / Opus)

A diferença de custo entre modelos é real:
- **Haiku**: ~20× mais barato que Opus em custo por token
- **Sonnet**: ~5× mais barato que Opus
- **Opus**: o mais capaz, o mais caro

Para tarefas que não requerem raciocínio avançado (formatação, correção gramatical, extração simples, brainstorm inicial), Haiku produz resultado equivalente a Sonnet a 20% do custo.

A heurística: use o modelo mais barato que resolve o problema corretamente. Escale para modelos mais caros apenas quando o mais barato falha.

### Técnica 9: Distribuir em 2-3 sessões diárias

O Claude Pro reinicia o contador de uso após uma janela de tempo (reportada como ~5h). Usar 45 mensagens de uma vez vs distribuir em 3 sessões de 15 mensagens cada pode triplicar o volume total de uso diário efetivo.

**Estratégia**: sessão matinal (planejamento e pesquisa), sessão tarde (implementação), sessão noite (revisão e síntese).

### Técnica 10: Identificar os maiores consumidores

Auditoria de uso: quais tipos de tarefa consomem mais tokens? As categorias típicas de alto consumo:
- Documentos muito extensos como contexto
- Conversas longas sem reset
- Web search habilitada em tarefas que não precisam
- Uso de Opus para tarefas que Haiku resolve

Uma vez identificado o maior consumidor, o impacto de otimizá-lo supera otimizar dezenas de casos menores.

## Comparação de economia total potencial

Combinando todas as 10 técnicas para um usuário Pro típico:

| Antes | Depois | Redução |
|---|---|---|
| Conversa de 30 turnos, Opus, web search ativo, sem cache | Conversa de 10 turnos por sessão, Sonnet, web search desativado, Projetos com cache | ~70-80% de tokens por tarefa equivalente |

## Aplicação no vault

O vault já implementa implicitamente várias dessas técnicas:
- **Técnica 4**: hot.md como cache de contexto — carregado uma vez, reutilizado
- **Técnica 6**: subagentes isolados — cada agente não herda contexto desnecessário do agente pai
- **Técnica 8**: recomendações de modelo por agente em `04-SYSTEM/agents/`

Para maximizar eficiência, aplicar explicitamente:
- **Técnica 2**: usar `/compact` antes de qualquer sessão que passou de 15 turnos
- **Técnica 9**: sessão matinal para planejamento, sessão noturna para execução de lote

## Referências adicionais

- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]] — teoria por trás das técnicas
- [[03-RESOURCES/sources/skills-prompting-mcp/post-dunik-7-claudemd-stop-and-ask]] — regra de CLAUDE.md que elimina tokens de tentativa-e-erro
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-nicbstme-external-css-html-token-savings]] — técnica de CSS externo para outputs HTML
