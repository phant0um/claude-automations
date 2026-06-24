---
title: Claude Research Mode
type: concept
status: developing
tags: [claude, research, agentic, multi-source, web-search, extended-thinking]
created: 2026-04-19
updated: 2026-04-19
---

# Claude Research Mode

Feature agentica do Claude que transforma uma pergunta num processo de investigação sistemática multi-fonte. Em vez de uma única busca, Claude executa múltiplas buscas em cadeia — cada resultado alimenta a próxima — e entrega um relatório completo com citações.

> [!key-insight] Diferença qualitativa
> Web search = uma busca, uma resposta. Research mode = investigação autônoma que persegue ângulos, preenche lacunas, e sintetiza de múltiplas fontes. Trabalho de horas feito em minutos.

## Como funciona (4 passos)

1. **Extended Thinking ativa automaticamente** — Claude planeja abordagem, identifica o que precisa investigar
2. **Múltiplas buscas em cadeia** — Claude decide o que buscar a seguir baseado no que já encontrou; persegue leads
3. **Síntese cross-source** — web + integrações conectadas (Gmail, Google Drive, Calendar, etc.)
4. **Output com citações** — cada claim linkado à fonte original para verificação fácil

**Duração:** 5–45 minutos dependendo da complexidade.

## Quando usar Research vs alternativas

| Feature | Use quando |
|---|---|
| **Research mode** | Relatório abrangente multi-source; análise comparativa; horas de trabalho manual |
| **Web search simples** | Fato específico rápido; 1–2 fontes; velocidade > abrangência |
| **Extended Thinking** | Raciocínio complexo sem busca externa; matemática, debugging, análise lógica |
| **Enterprise Search** | Conhecimento interno da organização; documentos, Slack, emails internos |

## Como ativar

1. Encontrar botão **Research** no canto inferior esquerdo do chat
2. Clicar — fica azul quando ativo
3. Digitar prompt e enviar
4. **Pré-requisito**: Web search deve estar habilitado em Search and tools settings

## Prompts efetivos para Research

- **Seja específico** sobre objetivos: *"Analyze the electric vehicle battery market — identify key players, technology trends, and supply chain challenges that might affect investment decisions"*
- **Especifique estrutura**: *"Compare venue options including: location, meeting space, catering, pricing"*
- **Inclua restrições**: budget, timelines, geografias
- **Peça para o Claude refinar o prompt** antes de ativar o Research, se incerto

## Research + integrações

Com Google Workspace conectado, Research vira ainda mais poderosa:
- *"Summarize what's been discussed about Project X across my emails and Slack, then research industry best practices"*
- *"Review my calendar commitments for next week and research each company I'm meeting with"*
- Pode **desligar web search** para fazer research apenas nas suas ferramentas internas

## Casos de uso

- Market analysis e competitive research
- Planejamento de projetos complexos (team offsites, product launches)
- Briefings que requerem informação atual e verificada
- Síntese de emails + calendar + docs + web num único relatório

## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/claude-101-anthropic-course]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-connectors]] — integrações que potencializam o Research
- [[03-RESOURCES/concepts/learning-cognition/adaptive-thinking]] — Extended Thinking que ativa automaticamente no Research
