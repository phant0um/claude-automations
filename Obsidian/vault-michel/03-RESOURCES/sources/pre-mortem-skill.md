---
title: "Pre-mortem Skill — SKILL.md definition"
type: source
source_file: Clippings/pre-mortem skill.md
origin: skill
ingested: 2026-05-14
tags: [skill, pre-mortem, decision-making, risk-analysis, gary-klein, parallel-agents]
---

# Pre-mortem Skill

> [!key-insight] Core insight
> Skill `premortem` em espanhol que usa o método Gary Klein + sub-agentes paralelos: imaginar que o plano já falhou 6 meses depois e trabalhar para trás. Claude deixa de ser cortês e começa a explicar como o plano morreu — mecanismo psicológico distinto de "avalie este plano".

## Natureza do Arquivo

Este é um **SKILL.md definition** — um skill procedural completo escrito em espanhol para Claude Code / Hermes / qualquer harness que suporte SKILL.md. Não está atualmente em `04-SYSTEM/skills/` do vault-michel.

**Nota:** Este skill deveria ser avaliado para instalação em `04-SYSTEM/skills/premortem.md` dado o potencial para análise de decisões críticas (ex: SEI Agent MVP, concurso strategy).

## Estrutura do Skill

**Nome:** `premortem`
**Triggers obrigatórios:** "premortem esto", "premortem mi", "ejecuta un premortem", "qué podría matar esto", "prueba de estrés este plan", "qué me estoy perdiendo", "encuentra los puntos ciegos"
**Triggers fortes:** "qué podría salir mal", "hazle agujeros a esto", "abogado del diablo"
**Não disparar em:** feedback simples, perguntas factuais, decisões já tomadas e irreversíveis

## Por Que Funciona (Psicologia)

- Método de Gary Klein (Harvard Business Review); adotado Google, Goldman Sachs, P&G
- Kahneman: "técnica mais valiosa para tomada de decisão"
- Prospective hindsight (Wharton/Cornell): "isso já falhou" → modo narrativo → razões mais específicas e honestas que "o que poderia dar errado?"
- Claude por default é amigável e otimista; o framing "está morto, explica como morreu" quebra esse padrão

## Fluxo em 6 Passos

1. **Coleta de contexto** — busca em CLAUDE.md, memory/, arquivos do projeto (máx 30s)
2. **Avalia suficiência** — precisa de: o que é, para quem, como é sucesso
3. **Completa lacunas** — máx 1 pergunta por vez
4. **Premortem bruto** — lista exaustiva de razões de falha (específicas ao plano, não genéricas)
5. **Sub-agentes paralelos** — 1 agente por razão de falha, todos em paralelo; cada um produz: história do falha, suposto subjacente, sinais de alerta precoce
6. **Síntese** — falha mais provável + falha mais perigosa + suposto oculto + plano revisado + checklist pré-lançamento

## Output

- `premortem-report-[timestamp].html` — relatório visual dark-themed com cards por modo de falha
- `premortem-transcript-[timestamp].md` — transcrição completa como referência
- Resumo conciso no chat (máx 3 frases): falha mais provável + suposto oculto + revisão mais importante

## Exemplo de Uso

Lançamento de workshop $297 sobre Claude Cowork para diretores de marketing (50 vagas):
- 6 modos de falha identificados: aprovação de budget, mismatch de audiência (solopreneurs vs diretores), tempo de preparação subestimado, ROI questionável ($14.850 máximo), etc.
- Síntese: "execute piloto de $47 com 20 pessoas antes de comprometer com workshop $297"

## Notas Importantes para Uso

- Sempre lançar todos os agentes de falha **em paralelo** (sequencial contamina resultados)
- O framing "isso já falhou" é o mecanismo psicológico crítico — sem ele vira risk assessment cortês
- Número de falhas deve refletir a realidade do plano: não forçar 7 se há 3, não parar em 3 se há 7
- Diferente do "LLM Council" — conseil dá perspectivas agora; premortem vai ao futuro onde falhou

## Conexões

- [[03-RESOURCES/concepts/claude-skills]] — este é um skill portável no padrão SKILL.md
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — usa sub-agentes paralelos por razão de falha
- [[04-SYSTEM/skills/]] — candidato a instalação; avaliar para decisões de alto custo de erro
