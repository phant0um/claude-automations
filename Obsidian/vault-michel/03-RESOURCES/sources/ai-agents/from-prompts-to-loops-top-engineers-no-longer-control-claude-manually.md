---
title: "From Prompts to Loops: Top Engineers no longer control Claude manually"
type: source
source_url: "https://x.com/maqxbt/status/2069033378565837286"
author: "@maqxbt"
published: 2026-06-22
created: 2026-06-22
updated: 2026-06-22
score: A
category: ai-agents
tags: [source, ai-agents, loop-engineering, claude-code, boris-cherny, paradigm-shift]
---

# From Prompts to Loops: Top Engineers no longer control Claude manually

Boris Cherny, criador do Claude Code, declarou em junho de 2026: *"I no longer prompt Claude. I have loops running that prompt Claude themselves and decide what to do next. My job is to write these loops."* Esta não é apenas uma frase clever — é um sinal de que o paradigma de trabalho com IA para código mudou novamente.

## Tese Central

A evolução do trabalho com IA seguiu: prompting → sub-agents → Agent Teams → **Loop Engineering**. O limite dos Agent Teams é que ainda exigem atenção humana constante — o humano permanece como bottleneck, gerenciando, checando e reiniciando. Loop Engineering remove o humano do nível de decisão passo-a-passo: o humano apenas desenha o loop e faz oversight final. A vantagem competitiva mudou de "quem formula melhor tarefas" para "quem sabe desenhar processos onde tarefas se resolvem automaticamente."

## Pontos-Chave

### O Problema que Todos Sentiram

- Mesmo bons Agent Teams exigem atenção humana constante
- Contexto polui rapidamente
- Agentes "acham" que terminaram quando o resultado está longe do ideal
- Em tarefas complexas, o humano é o bottleneck — checando, dirigindo, reiniciando

### O que é Loop Engineering

1. Definir goal claro + critérios de sucesso
2. Agente (ou time de agentes) começa a trabalhar
3. Após cada iteração: verificação (testes, review agent, métricas)
4. Se não atende critérios: agente recebe contexto atualizado e continua
5. Ciclo repete até critério de conclusão claro

**Diferença chave:** o humano sai do decision-making loop no nível de passo individual. Permanece apenas no nível de desenhar o loop e oversight final.

### Três Propriedades de um Bom Loop

1. **Critérios de conclusão claros** — não "build the feature", mas "all tests pass, coverage ≥ X%, sem comentários críticos do review agent"
2. **Verificação independente** — código checado por agente diferente do que escreveu. Self-assessment é um dos maiores problemas atuais
3. **Constraints e brakes** — hard limits em iterações, tokens, tempo. Sem eles: loop infinito ou queima de dinheiro

### A Realidade de 2026

Boris Cherny indica que porção significativa do código dentro da Anthropic já é escrita através de loops. Engenheiros focam em desenhar e melhorar processos, não em escrever código ou gerenciar agentes individuais.

Implementações existentes: desde simples (Ralph Wiggum Loop — reinicia agente até terminar) até complexas (múltiplos agentes, memória entre iterações, verifiers embutidos).

### Limitações Honestas

- Loop mal desenhado desperdiça tokens massivamente
- Critérios vagos → agente "melhora" algo que já funciona indefinidamente
- Tarefas criativas ou que exigem taste: loops performam pior que human-in-the-loop
- Exige skill diferente: desenhar processos ≠ ser bom em prompting

### Para o Developer Médio

Mudança não está nos modelos, está na forma de pensar:
- A vantagem mudou de "melhor em formular tarefas" para "sabe desenhar processos"
- Comece com: formular critérios de sucesso claros, adicionar verificação independente, usar /loop e /goal do Claude Code, construir loops gradualmente para tarefas repetitivas

## Conceitos

- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]] — padrões de design de loops autônomos
- [[03-RESOURCES/concepts/agent-systems/agent-loop]] — arquitetura do agent loop
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]] — design de loops de agentes
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]] — feedback loops em agentes
- [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]] — quando o humano entra/sai do loop
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]] — padrão verificador independente
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]] — constraints de contexto
- [[03-RESOURCES/concepts/agent-systems/agent-observability]] — observabilidade de loops
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — engenharia de contexto
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] — workflow no Claude Code

## Links

- [[03-RESOURCES/entities/Boris-Cherny]] — criador do Claude Code
- [[03-RESOURCES/entities/anthropic]] — empresa onde Cherny trabalha
- [[03-RESOURCES/entities/Claude-Code]] — ferramenta CLI

## Minha Síntese

A citação de Boris Cherny cristaliza algo que já vinha se formando: o salto de Agent Teams para Loop Engineering é qualitativo, não incremental. O ponto onde o humano para de decidir passo-a-passo e passa a desenhar o sistema que decide é o mesmo ponto onde "usar IA" vira "construir com IA." No vault, isto mapeia diretamente para o pipeline-semanal: não sou eu processando cada Clipping — é o loop de ingest-consolidate-interconnect que processa, e meu papel é desenhar e tunar esse loop. A pergunta prática não é "como promptar melhor" mas "que critérios de sucesso, verificação independente e brakes eu preciso no meu pipeline para que ele termine sozinho?"