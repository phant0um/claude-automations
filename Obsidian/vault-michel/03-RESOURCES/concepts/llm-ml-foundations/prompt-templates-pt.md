---
title: "Prompt Templates PT-BR"
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-09
tags: [concept, prompts, portugues, templates, perplexity, produtividade]
---

# Prompt Templates PT-BR

Coleção de templates de prompt em português brasileiro para uso recorrente em ferramentas de AI (Perplexity, Claude, ChatGPT). Foco em saída estruturada, Markdown, tempo de leitura controlado e cobertura de domínios específicos do perfil do usuário (servidor público, dev, investidor, concurseiro).

## Princípios de Design (extraídos da coleção Perplexity v3.0)

1. **Persona explícita:** "Atue como [jornalista pessoal / coach / analista]"
2. **Escopo temporal preciso:** "últimos 7 dias" / "última semana" / "quinzena"
3. **Seções com emoji-headers Markdown** para orientação visual rápida
4. **Regra de omissão:** "Omita seções sem novidades" — evita conteúdo de preenchimento
5. **Limite de caracteres declarado** (≤ 2.000) para controle de custo/token
6. **Tempo de leitura alvo** (8–12 min ou 10 min) como âncora de densidade
7. **Restrições negativas explícitas:** "Sem tabelas", "Fatos > opinião", "Não recomende timing de compra"

## Templates por Domínio (Perplexity Rotinas Semanais v3.0)

| # | Domínio | Frequência | Personagem |
|---|---------|-----------|------------|
| 1 | Briefing diário de notícias | Seg–Sex | Jornalista pessoal |
| 2 | Coach de produtividade | Quarta | Coach de carreira |
| 3 | Julgados STF/STJ/TCU | Segunda | — |
| 4 | Agenda política e normativa | Segunda | Analista |
| 5 | Tech, IA, cripto, fintech | Terça | — |
| 6 | Boletim AI Agents | Sexta | — |
| 7 | Cultura nerd | Sábado | — |
| 8 | Viagens, milhas, fidelidade | Quinta | — |
| 9 | Radar de carteira ETFs/cripto | Quarta | — |
| 10 | Concursos públicos | Segunda | — |
| 11 | Foto & vídeo (quinzenal) | Sábado | — |
| 12 | CrossFit & nutrição GF | Domingo | — |
| 13 | Automação & Apple (quinzenal) | Terça | — |
| 14 | Câmbio & operações internacionais | Quinta | — |

## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/prompts-perplexity-rotinas-semanais-otimizadas]] — coleção v3.0 completa
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — padrões gerais de prompt engineering
- [[03-RESOURCES/concepts/pkm-obsidian/perplexity-routine]] — padrão de uso no Perplexity
