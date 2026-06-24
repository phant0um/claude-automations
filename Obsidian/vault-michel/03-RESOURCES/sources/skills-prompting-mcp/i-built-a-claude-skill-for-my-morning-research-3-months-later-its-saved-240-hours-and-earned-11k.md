---
title: "i built a claude skill for my morning research. 3 months later it's saved 240 hours and earned $11K"
type: source
source: "Clippings/i built a claude skill for my morning research. 3 months later it's saved 240 hours and earned $11K.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, claude-code-skills, roi, automation, morning-research, cowork]
---

## Tese central

Uma única Claude Skill bem briefada — a `MorningBrief` — rodando automaticamente todo dia útil às 6h durante 3 meses (março–junho 2026) economizou 240 horas e gerou $11K em upsells que teriam sido perdidos, demonstrando o efeito de composição de skills que melhoram com o tempo via Memory.

## Argumentos principais

- A skill `MorningBrief` é definida por um único `CLAUDE.md` dentro de uma pasta Cowork (Research-Operations) com: 4 indústrias a monitorar, lista de 30 fontes confiáveis, formato de output (1 página, 5 seções, 2 fontes citadas por claim, máx. 600 palavras), e voice (sharp, concrete, sem hedging).
- Cowork's Scheduled Tasks dispara a skill toda semana às 6h; brief chega às 6h45; leitura em 15 minutos (vs. 90 minutos de pesquisa manual prévia).
- O efeito de composição: Memory carrega correções feitas quando o brief perde algo ou flagra a história errada — ao longo de 90 dias, a skill internalizou qual tipo de notícia priorizar. Mês 1: leitura cuidadosa. Mês 2: skim. Mês 3: briefs mais nítidos do que o autor escreveria.
- Custo: ~$0.80 por run. 64 runs automáticos em 13 semanas.

## Key insights

- 240 horas economizadas são verificadas contra blocos reais de calendário, não estimativa back-of-envelope: 90 min/dia × 5 dias/semana × 13 semanas − 15 min/dia de leitura do brief.
- Os $11K em upsells vieram de 3 eventos específicos: (1) funding announcement de competidor de cliente flagrado como "material" → expansão de $4K; (2) mudança de política de healthcare ops afetando compliance de cliente → $3,5K; (3) hiring move em tier-1 firm indicando market entry → $3,5K.
- Três lições aprendidas: (1) investir na source list desde o início — reconstruída na semana 3 porque metade das fontes era ruído; (2) rodar manualmente 5 vezes antes de agendar — first scheduled runs teriam tido problemas; (3) escrever "what's material" com precisão — vague instructions → vague briefs.
- "It's not a 1-week story. It's a 3-month story." — o valor de skills com Memory é um investimento de médio prazo.

## Exemplos e evidências

- Funding announcement capturado em 2 de abril de 2026, 3 dias depois do evento — provavelmente teria sido perdido no scroll manual.
- Tempo de build: 90 minutos na primeira vez; 30 minutos para replicar hoje com o que foi aprendido.
- Plataforma Cowork (não Obsidian) hospeda o workflow com Scheduled Tasks integrado.

## Implicações para o vault

Caso de uso de ROI concreto e mensurável de skills com Memory — demonstra o argumento de "skill library como estratégia de AI" com números reais. O padrão de `MorningBrief` é diretamente aplicável ao vault: a skill `connection-finder` ou um agente de síntese diária poderiam seguir o mesmo template (CLAUDE.md com fontes, formato, voice, scheduled). A lição de "source list tight primeiro" é aplicável ao design de skills de research no vault.

## Links

- [[03-RESOURCES/concepts/ai-agents/claude-code-skills]]
- [[03-RESOURCES/concepts/ai-agents/skill-memory-compounding]]
- [[03-RESOURCES/sources/every-companys-first-ai-strategy-should-be-a-skill-library]]
