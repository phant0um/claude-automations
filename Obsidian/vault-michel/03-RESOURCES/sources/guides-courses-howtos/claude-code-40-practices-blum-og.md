---
title: "40 práticas de Claude Code — @Blum_OG"
type: source
category: claude-code
author: "@Blum_OG"
source: "https://x.com/Blum_OG/status/2056077090970042828"
published: 2026-05-17
ingested: 2026-05-18
tags: [claude-code, best-practices, context-management, engineering-mindset]
triagem_score: 8
---

# 40 Práticas de Claude Code — @Blum_OG

## Tese central

A diferença entre engenheiros medianos e elite no uso do Claude Code não é velocidade de digitação — é gerenciar contexto como um sistema de engenharia de IA, não como um terminal mais rápido.

## Key Insights

### Práticas operacionais

- Enviar logs do terminal diretamente — sem cópia manual
- Rebobinar sessões agressivamente — cadeias de contexto ruins acumulam rápido
- Reiniciar após duas correções falhas — a sessão já está contaminada
- Perguntas laterais envenenam sessões longas — mantê-las separadas
- Forçar Claude a verificar seu próprio trabalho antes de marcar como concluído
- Subagentes pesquisam sem poluir o contexto principal

### CLAUDE.md

- Mantê-lo brutalmente enxuto — regras inchadas diluem as importantes
- Toda regra deve prevenir um erro real — nada mais

### Insights menos óbvios (os mais valiosos)

- **Janela de contexto maior ≠ output melhor** — contra-intuitivo mas crítico
- **Maior fonte de degradação de qualidade: contexto acumulado bagunçado**, não o modelo
- Logs brutos superam descrições emocionais de bugs em toda análise
- Prompts de voz produzem mais nuances do que os digitados

### Mudança de enquadramento

| Nível | Mentalidade |
|---|---|
| Médio | Codificar mais rápido |
| Elite | Gerenciar um sistema de engenharia de IA |

- O engenheiro elite para de agir como solo dev e começa a orquestrar inteligência
- Engenheiros 10x não digitam mais — operam num nível diferente de abstração

## Práticas operacionais em detalhe

### Rebobinar sessões agressivamente

A sessão do Claude Code mantém todo o histórico de conversa como contexto. Quando esse histórico contém tentativas malsucedidas, correções, e raciocínio errôneo, cada mensagem subsequente é influenciada por esse ruído. Rebobinar não é admitir derrota — é reconhecer que o contexto acumulado é o problema, não o modelo.

A heurística de "reiniciar após duas correções falhas" é concreta: se você corrigiu o agente duas vezes no mesmo problema e ele ainda errou, a sessão está contaminada. A terceira tentativa na mesma sessão raramente melhora — o padrão de erro já está profundamente enraizado no contexto.

### Perguntas laterais envenenam sessões longas

Uma sessão de Claude Code tem um "estado" implícito: o problema que está sendo resolvido, as decisões tomadas, o código que está sendo construído. Perguntas fora desse escopo — "enquanto você está lá, o que acha de X?" — forçam o modelo a alternar entre estados. Quando a atenção retorna ao problema principal, o contexto das perguntas laterais permanece e pode influenciar respostas subsequentes de forma não-intencional.

A prática correta: sessão separada para cada linha de trabalho separada.

### Forçar auto-verificação antes de marcar como concluído

O padrão "Claude diz que terminou mas não testou" é tão comum que merece uma prática explícita: antes de aceitar "pronto" como resposta, pedir que o agente execute o código, rode os testes, ou verifique o output contra o critério especificado. Auto-verificação antes de marcar concluído reduz drasticamente o número de "na verdade tem um bug" depois.

### Subagentes pesquisam sem poluir o contexto principal

Quando você precisa de informação de pesquisa (documentação, exemplos, contexto de uma biblioteca), pedir ao agente principal para pesquisar injeta essa informação no contexto da sessão de trabalho. Um subagente que pesquisa e retorna apenas o resumo relevante mantém o contexto principal limpo — focado no código, não na documentação que levou a ele.

## CLAUDE.md: a filosofia do enxuto

A instrução "mantê-lo brutalmente enxuto" e "toda regra deve prevenir um erro real" são as mais contraintuitivas. A tendência natural é adicionar regras ao CLAUDE.md — "adicione estas convenções", "lembre-se de sempre fazer X". O problema é que regras competem por atenção: um CLAUDE.md com 50 regras tem cada regra com 1/50 da atenção. As mais importantes ficam diluídas pelas menos importantes.

O critério "previne um erro real" funciona como filtro: se a regra não foi adicionada em resposta a um erro que realmente aconteceu, provavelmente não é necessária. Regras hipotéticas ("talvez o agente cometa este erro") raramente justificam o overhead de contexto.

## Os insights contra-intuitivos mais valiosos

### Janela de contexto maior ≠ output melhor

Este é provavelmente o insight mais importante e menos intuitivo da lista. A lógica que parece óbvia é: mais contexto = mais informação = melhor output. A lógica real: mais contexto significa que o modelo precisa alocar atenção sobre mais tokens, e a atenção é um recurso finito. Em sessões longas, o modelo "esquece" detalhes das partes iniciais da conversa de forma funcional — não porque não os vê, mas porque sua atenção é distribuída sobre uma janela maior.

A prática otimizada é a contraintuitiva: contexto curto e limpo supera contexto longo e bagunçado.

### Logs brutos superam descrições emocionais de bugs

"Tentei fazer X e não funcionou, é muito frustrante" contém zero informação útil para debugging. O stack trace, a linha de erro, o estado do sistema no momento da falha — isso é o que permite diagnóstico. A prática: sempre que possível, colar o output bruto do terminal em vez de descrever o que aconteceu.

### Prompts de voz produzem mais nuance

A hipótese é que ao falar, as pessoas naturalmente fornecem contexto que omitem ao digitar — porque escrever é mais trabalhoso, então economiza-se palavras. Voz permite elaborar sobre incertezas, hesitações, e nuances que um prompt digitado comprimiria ou omitiria. Para tarefas complexas onde o contexto importa, voz → transcrição → prompt pode capturar intenção melhor que digitação direta.

## A mudança de enquadramento: orquestrador vs executor

A diferença entre "codificar mais rápido" e "gerenciar um sistema de engenharia de IA" é uma mudança de nível de abstração. No nível de executor, você pensa em função por função, bug por bug, arquivo por arquivo. No nível de orquestrador, você pensa em contexto, em estrutura de sessão, em qual agente é melhor para qual subtarefa, em quando reiniciar vs continuar.

Engenheiros que operam no nível de orquestrador produzem mais porque delegam os detalhes de execução de forma mais eficiente — não porque digitam mais rápido ou têm prompts magicamente melhores.

## Relação com os princípios de Karpathy

As 40 práticas implementam concretamente os 4 princípios de Karpathy:
- "Pense antes de agir" → rebobinar sessões, forçar auto-verificação, perguntas laterais separadas
- "Simplicidade primeiro" → CLAUDE.md enxuto, contexto curto e limpo
- "Mudanças cirúrgicas" → refatoração seletiva (não "reescreva tudo"), contexto focado
- "Orientado ao objetivo" → DONE WHEN explícito, verificação antes de marcar concluído

## Links

- Conceito: [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agent-error-correction]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- Ver: [[03-RESOURCES/sources/token-economy-cost/7-claude-code-mistakes-token-waste]]
- Ver: [[03-RESOURCES/sources/guides-courses-howtos/best-practices-claude-opus-47-claude-code]]
