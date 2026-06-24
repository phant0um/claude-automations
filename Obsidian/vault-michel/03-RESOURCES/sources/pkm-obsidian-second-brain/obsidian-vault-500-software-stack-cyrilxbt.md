---
title: "The Obsidian Vault Setup That Replaced My $500 Per Month Software Stack"
type: source
source: "Clippings/The Obsidian Vault Setup That Replaced My $500 Per Month Software Stack.md"
origin_url: "https://x.com/cyrilXBT/status/2060540804230267050"
author: "@cyrilXBT"
published: 2026-05-29
created: 2026-05-31
ingested: 2026-05-31
tags: [source, obsidian, pkm, second-brain, vault-setup, plugins, workflows]
---

## Tese central

Um vault Obsidian bem configurado com 4 pastas, 5 plugins, e 3 workflows substituiu $500/mês em 9 apps (Notion, Roam, Evernote, Todoist, Bear, Readwise, Cron, Craft, Superhuman). A vantagem não é monetária — é o colapso do overhead mental de gerenciar múltiplas fontes de informação.

## Argumentos principais

1. **Obsidian vence na fundação** — arquivos markdown locais que você possui; sem lock-in proprietário; sem risco de downgrade/shutdown; funciona como lente sobre arquivos que já são seus.

2. **Conhecimento funciona por associação, não hierarquia** — apps construídos em hierarquias de pastas não capturam como ideias realmente se conectam. Obsidian é construído em torno de links, espelhando o funcionamento associativo do cérebro.

3. **Filosofia antes da estrutura** — construir para quem você realmente é (ocupado, inconsistente, às vezes distraído) não para quem você gostaria de ser. Três comportamentos reais: capturar rápido, processar ocasionalmente, surfar automaticamente.

4. **4 pastas, não 40** — `00-Inbox`, `01-Notes`, `02-Projects`, `03-Resources`. Resistir ao impulso de criar mais. Cada pasta tem uma lógica clara:
   - Inbox: captura sem organização, máx. 50 notas
   - Notes: ideias permanentes evergreen, 1 ideia por nota, com links
   - Projects: resultado definido + deadline; arquivar quando inativo >3 semanas
   - Resources: material de referência (livros, artigos, cursos)

5. **3 formatos de nota** — Evergreen Note (idea + why it matters + connections), Daily Note (norte do dia + captures + close-the-loop), Project Note (goal + tasks + decisions log).

6. **5 plugins que fazem trabalho real:**
   - Templater: templates dinâmicos com data/hora/variáveis
   - Dataview: consultas SQL-like no vault (`table status, deadline from "02-Projects" where status = "Active"`)
   - Tasks: task manager com due dates, recurrence, queries cross-vault (substituiu Todoist)
   - QuickAdd: captura para localização específica via atalho — maior redutor de fricção
   - Obsidian Git: backup automático para GitHub privado a cada 30 min

7. **3 workflows que mantêm o sistema vivo:**
   - Daily (manhã: 3 prioridades; dia: capturar tudo; noite: fechar loop — 20 min total)
   - Inbox Processing (15 min, uma decisão por nota: desenvolver/attachar/mover/deletar)
   - Weekly Review (domingo, 20-30 min — não-negociável)

8. **O weekly review é o que faz a diferença** — abrir 3 notas aleatórias semanalmente é o mecanismo que faz o vault compounding: ideias antigas surgem, conexões inesperadas aparecem. Sem weekly review, o vault só cresce, não fica mais inteligente.

## Key insights

- **Overhead mental > custo monetário** — o verdadeiro saving é o colapso do overhead de gerenciar múltiplas ferramentas, múltiplas contas, múltiplos lugares para informação viver.
- **"Open 3 random notes"** é o passo que parece trivial mas é o mecanismo de compounding do vault.
- **Captura manual de highlights** — parar de pagar pelo Readwise porque adicionar highlights manualmente à pasta Resources gerou mais engajamento que sync automático.
- **Tasks no contexto vs. lista desconectada** — tarefas dentro de project notes e daily notes (com contexto) > Todoist como lista separada.
- **Regra dos 30 dias** — usar apenas o básico por 30 dias antes de adicionar qualquer coisa; você descobre limitações reais vs. imaginárias.
- **O vault que funciona é o que você realmente usa, não o mais complexo.**

## Exemplos e evidências

- 9 apps cancelados: Notion ($16/mês), Roam ($15/mês), Evernote ($15/mês), Todoist ($4/mês), Bear ($30/ano), Readwise ($8/mês) — total ~$500/ano (não/mês como no título, mas soma do stack completo incluindo tiers premium).
- Dataview query: `table status, deadline from "02-Projects" where status = "Active" sort deadline asc`
- Task com due date: `- [ ] Write newsletter draft 📅 2026-06-01`
- Task query semanal: `due before next monday not done`
- QuickAdd: captura para Inbox com timestamp via atalho único

## Implicações para o vault

- Este vault (vault-michel) já implementa uma versão mais sofisticada deste sistema (ver `04-SYSTEM/AGENTS.md` e estrutura de pastas).
- Validação externa da filosofia do vault: estrutura simples, links como first-class citizens, weekly review como alavanca principal.
- O conceito de "vault compounding" mapeia diretamente para `[[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]`.
- Reforça valor do Obsidian Git para backup (`[[03-RESOURCES/entities/Obsidian]]`).
- Discordância parcial: este vault usa mais pastas e maior complexidade — justificada por uso com agentes IA, o que requer estrutura mais granular que um vault pessoal simples.

## Links

- [[03-RESOURCES/entities/Obsidian]]
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]]
- [[03-RESOURCES/concepts/pkm-obsidian/weekly-knowledge-routine]]
