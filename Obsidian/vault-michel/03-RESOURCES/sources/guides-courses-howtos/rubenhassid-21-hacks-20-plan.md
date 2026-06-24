---
title: "21 Hacks para o Plano Claude de $20/mês — @rubenhassid"
type: source
source_file: Clippings/Post by @rubenhassid on X.md
origin: post no X
author: "@rubenhassid"
published: 2026-04-12
ingested: 2026-05-14
tags: [claude-optimization, token-economics, cowork, projects, productivity, claude-plan]
triagem_score: 7
---

# 21 Hacks para o Plano Claude de $20/mês

> [!key-insight] Core insight
> A maioria dos usuários gasta tokens desnecessariamente por hábitos errados — PDFs brutos, chats longos acumulados, múltiplas mensagens para uma tarefa. 21 ajustes simples tornam o plano $20/mês suficiente para quase todo uso sério.

## Sections

### Os 21 Hacks

| # | Problema | Fix |
|---|----------|-----|
| 1 | PDF bruto (1 pág = 3k tokens) | Colar texto em Google Doc → baixar como .md (<200 tokens) |
| 2 | Construir arquivos no Cowork cedo demais | Planejar no Chat primeiro; mover para Cowork só quando certo |
| 3 | Prompts de 500 palavras | 29 palavras: "Quero [tarefa] para [objetivo]. Faça perguntas via AskUserQuestion." |
| 4 | "Refaça tudo" para corrigir seção 3 | "Refaça apenas a seção 3. Mantenha tudo. Sem comentários." |
| 5 | 3 mensagens para 3 tarefas | Uma mensagem, três tarefas em lista |
| 6 | "Não, quis dizer," empilhando no histórico | Clicar 'Editar' na mensagem original e regenerar |
| 7 | Reescrever prompts do zero | Biblioteca de prompts — mesma estrutura, troca variável |
| 8 | Opus para gramática simples | Sonnet para rápido; Opus só para trabalho profundo |
| 9 | About-me de 22k palavras | Cortar para <2.000 palavras; session-notes.md no encerramento |
| 10 | Nunca reinicia, empilha chats longos | "Reinicie conversa a partir daqui" quando sair dos trilhos |
| 11 | Nunca resume antes de ficar longo | A cada 15-20 mensagens: resumir, copiar, nova sessão |
| 12 | Ignorar Projects | Usar Projects — enviar arquivo uma vez; todo chat referencia |
| 13 | 50 arquivos no Cowork "por via das dúvidas" | Só o que esta tarefa precisa; zero pastas para rascunhos rápidos |
| 14 | 3 tópicos em 1 chat | Novo tópico = novo chat; contexto morto = token morto |
| 15 | Busca e conectores ligados por padrão | Desligar tudo; ativar por tarefa |
| 16 | Relatório semanal manual | `/schedule` — "Toda segunda às 7h, crie meu briefing." |
| 17 | Claude Code explorar todo repositório | Ser específico: "Crie gráfico a partir deste CSV. Salve como chart.png." |
| 18 | Pular Preferências Pessoais | Settings → Preferências Pessoais → definir tom e estilo uma vez |
| 19 | Prompts preguiçosos "melhore isso" | Falar prompts com wispr.ai — contexto mais rico em um só tiro |
| 20 | Queimar limite em uma manhã | Claude roda em janela rolante de 5 horas — dividir uso |
| 21 | Usar Claude para o que não sabe fazer | Imagens → Gemini; busca real-time → Grok |

### Padrões de Contexto

- **PDF → .md**: redução de 93% de tokens (3k → 200 por página)
- **Session notes**: encerrar com "Escreva session-notes.md" preserva contexto entre sessões
- **5h rolling window**: ritmo sustentável sem atingir limites
- **AskUserQuestion**: força Claude a perguntar em vez de assumir — economiza iterações

## Os 5 hacks mais subestimados — análise aprofundada

### Hack #1: PDF → .md (93% de redução de tokens)

A conversão de PDF para Markdown via Google Docs é o hack de maior ROI absoluto. A razão técnica: PDFs são enviados ao Claude como imagens (cada página = imagem encodada em base64) ou texto extraído com ruído de formatação (tabelas quebradas, notas de rodapé fora de ordem, cabeçalhos repetidos em cada página). Isso gera um número absurdamente alto de tokens por unidade de informação.

O caminho Google Doc → Download como .md produz texto limpo, estruturado, sem overhead visual. A redução de 3k para 200 tokens por página (93%) é real para PDFs típicos de relatórios ou apostilas.

Para este vault: apostilas da FIAP em PDF passam por exatamente este processo antes de serem ingeridas. O gargalo é manual — o hack sugere padronizar esse fluxo.

### Hack #3: Prompts de 29 palavras com AskUserQuestion

O padrão de 29 palavras não é sobre brevidade — é sobre forçar o Claude a *perguntar* antes de agir. Sem `AskUserQuestion`, o Claude assume interpretação da instrução ambígua e produz output que pode estar completamente errado. Com `AskUserQuestion`, o Claude para e solicita esclarecimento antes de gastar tokens em direção errada.

O custo de uma pergunta de esclarecimento: ~50 tokens. O custo de resposta longa na direção errada: 2.000–10.000 tokens. A economia matemática é clara.

### Hack #6: Editar mensagem original em vez de "não, quis dizer"

Este hack resolve o "empilhamento histórico" — o problema de histórico de conversa que cresce com correções, onde o Claude precisa manter em contexto tanto a instrução errada quanto a corrigida, gerando ambiguidade. Editar na mensagem original e regenerar produz um histórico limpo onde o Claude nunca viu a instrução errada.

### Hack #10: Reiniciar conversa vs tentar corrigir

Quando uma conversa sai dos trilhos (output inconsistente, Claude "travado" em uma interpretação errada, contexto contaminado), a tentação é continuar na mesma sessão adicionando correções. Isso raramente funciona — cada correção adiciona contexto que o Claude precisa reconciliar.

"Reiniciar conversa a partir daqui" com um resumo do estado atual é mais eficiente: 200 tokens de resumo vs 10.000+ tokens de histórico problemático.

### Hack #16: `/schedule` para automações semanais

O Cowork schedule transforma tarefas manuais recorrentes em automações. O exemplo do "Briefing de Segunda às 7h" é ilustrativo mas genérico. Casos de uso concretos para este vault:

- Toda segunda: consolidar notas da semana anterior, identificar conceitos sem página, listar fontes pendentes de ingestão
- Toda quinta: verificar wikilinks quebrados, atualizar `hot.md` com notas mais acessadas da semana
- Todo dia 1: gerar relatório de progresso do concurso (tópicos cobertos vs edital)

## Padrões de contexto — o que o artigo chama de "contexto eficiente"

O artigo identifica 4 patterns de uso de contexto eficiente que aparecem em vários dos 21 hacks:

**1. Session Notes como handoff**: `session-notes.md` no encerramento preserva o estado exato da sessão — o que foi feito, o que ficou pendente, decisões tomadas. Na próxima sessão, Claude lê o arquivo e continua de onde parou sem re-explicação.

**2. About-me enxuto** (<2.000 palavras): mais longo não é mais útil. Um about-me de 22k palavras dilui o sinal — Claude não sabe o que é importante. 2.000 palavras com estrutura clara (quem sou, objetivos, regras, projetos atuais) é mais eficaz.

**3. Projects como biblioteca de referência**: arquivo enviado uma vez ao Project fica disponível em todos os chats. Não re-enviar — referenciar.

**4. Janela de 5 horas**: o ritmo de uso correto é distribuído, não concentrado. Sessões de 2–3 horas com intervalo de 5 horas são mais sustentáveis do que uma sessão de 6 horas que esgota o limite e força parada.

## Quando usar Gemini e Grok (hack #21)

O hack mais contraintuitivo: usar Claude para o que Claude faz bem, e outras ferramentas para o que elas fazem melhor. Imagens → Gemini, busca real-time → Grok, análise de tabelas grandes → outros modelos.

Isso não é abandono do Claude — é uso especializado. Um stack multi-modelo bem orquestrado é mais capaz do que um único modelo usado para tudo. O limite do plano $20/mês é o incentivo para usar cada ferramenta só onde ela tem vantagem real.

## Conexões

- [[03-RESOURCES/entities/Ruben-Hassid]] — autor; @rubenhassid
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — hack #15 (desligar conectores desnecessários)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-projects]] — hack #12 (Projects evita re-envio de arquivos)
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — disciplina de contexto como tema central
- [[03-RESOURCES/entities/Claude-Cowork]] — hacks #2, #13 (uso correto do Cowork)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — hack #18 (Preferências Pessoais)
