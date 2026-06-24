---
title: "Pre-mortem Skill — SKILL.md definition"
type: source
source_file: Clippings/pre-mortem skill.md
origin: skill
ingested: 2026-05-14
tags: [skill, pre-mortem, decision-making, risk-analysis, gary-klein, parallel-agents]
triagem_score: 7
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

## O mecanismo psicológico central — por que funciona melhor que "avalie este plano"

A distinção entre pre-mortem e avaliação de risco convencional não é cosmética. Estudos de Deborah Mitchell, Jay Russo e Paul Schoemaker (Journal of Experimental Psychology, 1989) demonstraram que antecipar como um evento específico *aconteceu* aumenta a capacidade de identificar causas em 30% comparado a antecipar como ele *poderia* acontecer.

O mecanismo: quando o frame é "o que poderia dar errado?", o cérebro acessa heurísticas gerais e produz uma lista de riscos genérica ("talvez o mercado não aceite", "concorrência", "falta de recursos"). Quando o frame é "já falhou — explique como", o cérebro entra em modo narrativo: constrói uma história *específica* com agentes, causas, sequência temporal. Narrativas específicas expõem supostos que a análise abstrata deixa invisíveis.

Aplicado ao Claude: o framing "está morto" quebra o viés de otimismo padrão do modelo. Claude por default tende a validar planos com caveats. Com o pre-mortem, o modelo não pode validar — só pode explicar como falhou.

## Diferença prática: Pre-mortem vs LLM Council vs Risk Assessment

Três técnicas frequentemente confundidas:

**Risk Assessment padrão**: "Quais são os riscos?" → lista estática, probabilidades estimadas, genérico por natureza. Útil para compliance e documentação, mas fraco para descobrir o que você não sabe que não sabe.

**LLM Council / múltiplas perspectivas**: diferentes "personas" ou papéis analisam o plano *agora*, do ponto de vista atual. Útil para ver o plano de múltiplos ângulos, mas ainda limitado pela perspectiva de quem ainda não viveu a falha.

**Pre-mortem**: vai ao futuro onde *já* falhou e trabalha para trás. A diferença temporal muda o tipo de informação que emerge. O council diz "talvez o timing seja ruim". O pre-mortem diz "a campanha foi ao ar em dezembro quando a janela de atenção do mercado estava fechada porque era fim de ano fiscal".

## Aplicações concretas neste vault

**Decisão de alto custo de erro:** Antes de comprometer o concurso público como rota principal (vs. mercado de trabalho em TI), um pre-mortem identificaria: assumiu que o estudo de 6 meses seria suficiente (mas edital pode mudar), assumiu que a modalidade presencial seria viável (logística), assumiu que o índice de aprovação valeria o custo de oportunidade.

**Projeto de código:** Antes de refatorar arquitetura do vault de flat para hierárquica — pre-mortem identifica: links quebrados em cascata, migração de manifest incompleta, incompatibilidade com claude-obsidian plugin.

**Decisão de produto/negócio:** O exemplo do workshop $297 do próprio skill demonstra como o pre-mortem produziu recomendação acionável ("piloto de $47 antes de comprometer") que uma análise de risco convencional dificilmente teria especificado.

## Por que sub-agentes paralelos são críticos (não sequenciais)

O skill especifica que cada razão de falha deve ser analisada por um sub-agente separado, rodando **em paralelo**. A razão não é apenas performance — é *independência epistêmica*.

Quando um único agente analisa razões de falha sequencialmente, a análise da razão 3 já está contaminada pelo raciocínio das razões 1 e 2. O agente começará a buscar coerência narrativa, não novas perspectivas. Sub-agentes paralelos com contextos independentes produzem modos de falha genuinamente diferentes — especialmente importante para encontrar os "cisnes negros" que nenhuma análise sequencial encontraria.

## Output — HTML vs MD e custo de contexto

O skill especifica output em `.html` dark-themed com cards por modo de falha. Para a política deste vault ([[03-RESOURCES/sources/skills-prompting-mcp/clipping-md-or-html-format-decision]]), isso é uma exceção legítima à regra "sempre MD": o relatório de pre-mortem é um entregável one-shot para revisão humana, não material de referência que o Claude re-lerá. A estética do HTML serve o propósito (clareza na apresentação dos modos de falha).

A transcrição `.md` paralela é onde o valor de longo prazo fica — referenciável, indexável, re-ingerível.

## Conexões

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — este é um skill portável no padrão SKILL.md
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — usa sub-agentes paralelos por razão de falha
- [[04-SYSTEM/skills/]] — candidato a instalação; avaliar para decisões de alto custo de erro
