---
title: "You Prompt (the New) Claude Wrong. Do This Instead."
type: source
source_type: clipping
source_file: "Clippings/You prompt (the new) Claude wrong. Do this instead.md"
source_url: "https://x.com/rubenhassid/status/2053324202321834073"
author: "Ruben Hassid (@rubenhassid)"
created: 2026-05-14
tags: [claude-opus-47, prompting, adaptive-thinking, prompt-engineering, claude-skills, rubenhassid]
triagem_score: 7
---

# You Prompt (the New) Claude Wrong. Do This Instead.

**Author:** Ruben Hassid — @rubenhassid  
**Based on:** Anthropic's 31-page Opus 4.7 prompting guide

## Old vs. New Claude Behavior Changes

| Dimension | Claude 4.6 | Claude 4.7 |
|---|---|---|
| Instruction following | Infers intent, interprets loosely | Does exactly what you typed |
| Response length | Roughly consistent regardless of input | Sizes to perceived task size |
| Tone | Warmer, validation-forward, "Great question!" | More direct, minimal emojis |
| Tool calls | Called frequently | Calls fewer; reasons more between calls |

## 7 Prompting Fixes for Opus 4.7

**1. Replace vague verbs with explicit scope**
- Old: "Review this contract."
- New: "Review this contract. Flag risks per clause. Rate severity 1–5. Suggest one rewrite per risky clause. Return as a table."

**2. Define length explicitly**
- Old: "Summarize this report."
- New: "Summarize this report in exactly 5 bullet points. Each bullet under 15 words. First word: an action verb."

**3. Use positive instructions only — negatives stick literally**
- Old: "Don't use jargon."
- New: "Write in plain English a 16-year-old could read aloud. Replace 'leverage' with 'use'."

**4. Use action verbs only — 4.7 ships specifics**
- Old: "Can you help me with the email?"
- New: "Go to my Gmail. Find [contact] and read our last conversation. Write the answer email. Final draft. Send-ready. Goal: book a meeting with the CRO of Snowflake by Friday. Length: under 90 words. Tone: confident, casual, specific."

**5. For tool use — prompt explicitly if you want more**
- Default: 4.7 reasons more, calls fewer tools
- Force: "Use web search aggressively. Verify every claim with at least 2 sources."

**6. To restore warmth if desired**
- "Use a warm, conversational tone. Acknowledge the user's framing before answering."
- Or: paste 2–3 sentences in the voice you want, tell Claude to match the rhythm.

**7. "Go beyond the basics" on creative tasks**
- From Anthropic's own 4.7 doc
- Pushes 4.7 past the literal minimum on open-ended work

## Trick: Force Maximum Reasoning

Adaptive Thinking does not reason by default. Add to any prompt:

> **"Think before answering (maximum reasoning)"**

Combined with selecting xhigh thinking mode in the UI.

## Skill Strategy: Use a Skill to Optimize Prompts

Author created a `/47` skill that takes any lazy prompt and rewrites it as an Opus 4.7-optimized prompt. Pattern:
1. User types `/47 [lazy prompt]`
2. Claude uses the skill, reasons about the prompt
3. Outputs a polished, structured Opus 4.7 prompt
4. User pastes into new chat

## Key Entities

- [[03-RESOURCES/entities/Ruben-Hassid]] — author
- [[03-RESOURCES/entities/Claude-Opus-47]] — the model being addressed

## Mecanismo: por que Opus 4.7 é mais literal

A mudança de comportamento de 4.6 → 4.7 reflete uma escolha deliberada de treinamento: aumentar instruction following fidelity à custa de inferência de intenção. O modelo 4.6 tinha um viés de "ajudar além do pedido" — inferia o que você provavelmente queria. O 4.7 tem um viés de "fazer exatamente o que foi pedido" — interpreta literalmente.

Isso é mais previsível para usuários experientes (que sabem escrever prompts precisos), mais frustrante para novatos (que esperavam que o modelo "entendesse"). A mudança também reduz alucinações por extrapolação — o modelo que inventa menos sobre sua intenção erra menos quando a intenção é clara.

## O problema das instruções negativas

A Fix 3 ("use positive instructions only") tem base em como os modelos processam negações. Instruções negativas ("não use jargão") requerem que o modelo gere o output e verifique contra a restrição — um processo de dois passos. Instruções positivas ("escreva para um leitor de 16 anos") definem diretamente o espaço de output desejado — um processo de um passo.

Com Opus 4.7 e sua literalidade aumentada, "não use jargão" pode ser interpretado de forma excessivamente restrita — eliminando terminologia técnica necessária em vez de apenas jargão desnecessário. A instrução positiva é mais robusta: "use palavras que um estudante de ensino médio conhece" define o critério sem criar edge cases ambíguos.

## Adaptive Thinking: opt-in vs default

O Adaptive Thinking do Opus 4.7 não raciocina por padrão para preservar velocidade e custo. Quando ativado (via "Think before answering — maximum reasoning" + modo xhigh no UI), o modelo usa uma janela de "pensamento" separada que não aparece no output final mas influencia a qualidade da resposta.

Casos onde vale ativar:
- Problemas de raciocínio multi-step com dependências
- Análise de documentos longos com contradições internas
- Planejamento de arquitetura de software
- Revisão de contratos com cláusulas interdependentes

Casos onde não vale:
- Tasks de geração direta (escrever email, reformatar dado)
- Tarefas com critério de sucesso binário claro
- Situações onde velocidade importa mais que profundidade

## A skill /47 como padrão de meta-prompt

O padrão da skill `/47` — pegar um prompt vago e reescrever como prompt Opus 4.7-otimizado — é um caso de meta-prompting: usar o modelo para otimizar inputs para o próprio modelo. É conceitualmente similar ao Prompt Master (ver [[03-RESOURCES/sources/skills-prompting-mcp/prompt-master-claude-skill]]) mas focado exclusivamente em Opus 4.7 e invocado como skill de slash command.

A diferença prática: `/47` é uma transformação de prompt em uma etapa; o Prompt Master é um pipeline de 7 etapas com roteamento de ferramenta. Para otimização rápida de um único prompt para Claude, `/47` é mais leve; para geração de prompts para ferramentas diversas, Prompt Master é mais abrangente.

## Implicações para workflows de equipe

As mudanças de comportamento do 4.7 têm implicações além do uso individual. Equipes que têm prompts padronizados escritos para 4.6 precisam revisá-los:

- Prompts com linguagem de polidez ("se possível, por favor, poderia...") agora produzem outputs diferentes — o modelo pode interpretar o condicional literalmente
- Prompts que dependiam do modelo "inferir o contexto" agora requerem contexto explícito
- Sistemas de prompt em produção (chatbots, automações) podem ter comportamento inesperado após upgrade de modelo

A recomendação prática: manter um conjunto de prompts de teste de regressão para qualquer sistema crítico ao fazer upgrade de versão de modelo.

## Conexões

- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — update: Opus 4.7 literal behavior changes patterns
- [[03-RESOURCES/concepts/learning-cognition/adaptive-thinking]] — Adaptive Thinking behavior explained
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — /47 skill as a prompt-optimization skill
- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]] — positive instructions reduce wasted tokens
- [[03-RESOURCES/sources/skills-prompting-mcp/prompt-master-claude-skill]] — alternativa mais abrangente para otimização de prompts
- [[03-RESOURCES/entities/Claude-Opus-47]] — o modelo com novo comportamento literal
