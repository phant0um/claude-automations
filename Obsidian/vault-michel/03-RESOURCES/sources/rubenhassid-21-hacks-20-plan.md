---
title: "21 Hacks para o Plano Claude de $20/mês — @rubenhassid"
type: source
source_file: Clippings/Post by @rubenhassid on X.md
origin: post no X
author: "@rubenhassid"
published: 2026-04-12
ingested: 2026-05-14
tags: [claude-optimization, token-economics, cowork, projects, productivity, claude-plan]
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

## Conexões

- [[03-RESOURCES/entities/Ruben-Hassid]] — autor; @rubenhassid
- [[03-RESOURCES/concepts/prompt-caching]] — hack #15 (desligar conectores desnecessários)
- [[03-RESOURCES/concepts/claude-projects]] — hack #12 (Projects evita re-envio de arquivos)
- [[03-RESOURCES/concepts/context-engineering]] — disciplina de contexto como tema central
- [[03-RESOURCES/entities/Claude-Cowork]] — hacks #2, #13 (uso correto do Cowork)
- [[03-RESOURCES/concepts/claude-folder-anatomy]] — hack #18 (Preferências Pessoais)
