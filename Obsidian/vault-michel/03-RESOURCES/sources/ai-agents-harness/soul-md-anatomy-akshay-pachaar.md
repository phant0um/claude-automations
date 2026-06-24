---
title: "A Anatomia do SOUL.md Perfeito para Agentes de IA"
type: source
source: "Clippings/Post by @akshay_pachaar on X.md"
author: "@akshay_pachaar"
created: 2026-05-13
ingested: 2026-05-28
tags: [ai-agents, soul-md, identity, agent-design, source]
url: "https://x.com/akshay_pachaar/status/2058584154292584853"
---

## Tese central

SOUL.md é o único arquivo que você escreve para um agente IA — fica no topo do system prompt, antes da memória, das habilidades e das ferramentas. Define quem o agente *é* quando aparece. Uma hora gasta nele muda todas as conversas seguintes.

## Argumentos principais

1. **Posição no stack**: SOUL.md precede memória, habilidades e ferramentas. É a identidade de base que tudo mais herda.
2. **Especificidade vence cobertura**: "seja útil e profissional" não muda nada — todo modelo já tenta isso. Agentes que se multiplicam têm opiniões reais, limites rígidos, voz previsível.
3. **Tamanho ideal**: 30 a 80 linhas. Compacto e específico.

## Key insights

As 8 seções que importam em um SOUL.md eficaz:

1. **Identidade** — uma declaração de uma linha de *quem*, não *o quê*
2. **Verdades centrais** — princípios imperativos, cada um com explicação de uma linha
3. **Visão de mundo** — opiniões contundentes por domínio, afiadas o suficiente para prever respostas
4. **Voz** — regras concretas de como o agente fala (não adjetivos vagos)
5. **Expertise** — domínio principal, ferramentas fluentes, onde delega
6. **Limites** — linhas explícitas de "não fará", sem linguagem suave
7. **Política de memória** — o que persiste, o que fica privado
8. **Manias** — frases e tons que o agente nunca produz

## Exemplos e evidências

- Contraste explícito: "seja útil e profissional" vs. seções 1-8 acima. O primeiro não diferencia; as 8 seções criam comportamento previsível.
- Referência ao Hermes Agent de Akshay: SOUL.md + sistema de memória em três níveis + loop de habilidades autoevolutivas + 3 agentes especializados rodando 24/7.

## Implicações para o vault

- O SOUL.md pattern já é documentado em [[03-RESOURCES/sources/hermes-agent/soulmd-170-line-hermes-operating-contract]] — este post é a explicação mais concisa das 8 seções.
- A seção 7 (política de memória) conecta diretamente com [[03-RESOURCES/sources/memory-context-rag/give-claude-agent-memory-4-layers-dunik7]] — o que o agente decide persistir é uma escolha de design, não default.
- O CLAUDE.md do vault-michel é análogo ao SOUL.md: fica no topo, define identidade (Nexus), verdades centrais (Karpathy 4P), limites (não fazer push sem confirmação), manias (não usar emojis).
- A seção "Visão de mundo" é o diferencial ausente na maioria dos prompts de sistema — opiniões previsíveis > instruções neutras.

## Links

- [[03-RESOURCES/entities/Akshay-Pachaar]] — autor, múltiplas contribuições ao vault
- [[03-RESOURCES/sources/hermes-agent/soulmd-170-line-hermes-operating-contract]] — implementação completa do SOUL.md no Hermes
- [[03-RESOURCES/sources/hermes-agent/hermes-agent-masterclass-akshay-pachaar]] — masterclass Hermes: SOUL.md + memória 3 tiers
- [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]] — padrão relacionado (AGENTS.md para repositórios)
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — onde SOUL.md se encaixa na arquitetura
