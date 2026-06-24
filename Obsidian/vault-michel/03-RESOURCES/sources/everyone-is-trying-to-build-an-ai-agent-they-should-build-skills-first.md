---
title: "Everyone Is Trying to Build an AI Agent. They Should Build Skills First."
type: source
source: "Clippings/Everyone Is Trying to Build an AI Agent. They Should Build Skills First..md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, claude-code-tooling]
---

## Tese central
Argumenta que a ordem certa de construção não-técnica é skills primeiro, agentes depois: skill é capacidade documentada e reutilizável ensinada uma vez a Claude/Codex; agente é só uma skill (ou conjunto) acoplada a um workflow que roda os passos sozinho — "a skill é o ativo, o workflow é o mecanismo de entrega". Apresenta 3 builds reais sem código (voz de conteúdo, reconciliação de gasto em anúncios, e uma terceira não detalhada no trecho capturado).

## Argumentos principais
- Razão central para começar por skill: ferramentas e modelos mudam, a plataforma que você ama hoje é substituída em meses — uma skill bem documentada na nuvem é portátil e sobrevive à ferramenta em que foi construída; você não está apostando numa ferramenta, está construindo algo que compõe valor.
- **Skill 1 (voz de conteúdo)**: extrai de 20 posts antigos não os tópicos, mas a mecânica de escrita (ritmo de frase, padrões de abertura/fechamento, palavras usadas/evitadas, ângulos recorrentes) como regras reutilizáveis — depois acopla a um workflow que lê transcrições diárias de chamada e gera rascunhos de conteúdo automaticamente.
- **Skill 2 (reconciliação de gasto em anúncios)**: cruza gasto real × orçamento autorizado × valor faturado por cliente, sinalizando automaticamente qualquer cliente com gasto acima do autorizado — captura erro que normalmente só o próprio cliente identifica.
- Tip de meta-skill: um segundo agente observando as edições do usuário sobre o output da skill e atualizando a skill de voz a cada feedback — mecanismo de aprendizado incremental sem retrain.

## Key insights
- "A skill é o ativo, o workflow é o mecanismo de entrega — não aposte na ferramenta, aposte na skill documentada" é justificativa direta e externa de por que este vault mantém skills em `04-SYSTEM/skills/` desacoplados de qualquer agente/modelo específico.
- O mecanismo "agente observa edições e atualiza a skill automaticamente" é um padrão de auto-melhoria aplicável: análogo ao próprio princípio `04-SYSTEM/wiki/errors.md` deste vault (logar correção → consolidar em regra), mas com automação adicional do passo de consolidação.

## Exemplos e evidências
- Prompts literais usados para extrair "skill de voz" e "skill de reconciliação"; caso real citado de cliente que foi de 2 posts/mês para diário sem se tornar escritor.

## Implicações para o vault
Confirma a arquitetura adotada (skills desacopladas, reutilizáveis, versionadas) — sem mudança necessária; o padrão "agente observa feedback e atualiza skill automaticamente" é candidato de exploração futura para `04-SYSTEM/wiki/errors.md`, fora de escopo desta ingestão.

## Links
- [[04-SYSTEM/skills/foundational/spec-lifecycle]]
- [[03-RESOURCES/sources/ai-claude-code-skill]]
