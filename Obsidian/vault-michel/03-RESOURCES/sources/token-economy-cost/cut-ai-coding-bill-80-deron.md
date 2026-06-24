---
title: "How To Cut Your AI Coding Bill by 80% (FULL GUIDE)"
type: source
source_file: Clippings/How To Cut Your AI Coding Bill by 80% (FULL GUIDE).md
origin: artigo
author: "@DeRonin_"
published: 2026-05-12
ingested: 2026-05-14
tags: [token-economics, cost-optimization, model-routing, prompt-caching, kimi, ai-coding]
triagem_score: 8
---

# How To Cut Your AI Coding Bill by 80% (FULL GUIDE)

> [!key-insight] Core insight
> O problema não é o preço dos modelos — é contexto desnecessário. O fix real é context discipline + routing multi-model, com Kimi 2.6 como workhorse diário no lugar de Sonnet (6x mais barato, qualidade equivalente em 90% das tarefas).

## Os 4 Tipos de Tokens

| Tipo | Custo relativo | Nota |
|---|---|---|
| Input | Base | O que você envia |
| Output | 3–5x mais caro | O que o modelo retorna |
| Cached | ~10% do input | Prefixo imutável cacheado |
| Reasoning | Igual output | Invisível mas cobrado |

## As 5 Armadilhas de Token

1. **Re-sending entire repo** — auto-context carrega 50 arquivos a cada turno; fix: grep before fetch, turn off auto-context for stable files
2. **Tool call loops que espiralam** — cada "let me check" paga contexto completo novamente; fix: batch tool calls, deterministic helpers
3. **Premium model para tasks triviais** — Opus para "fix this typo"; fix: routing por task type
4. **Streaming vs batching errado** — streaming derrota prompt caching em alguns workflows; fix: batch para background agents
5. **Context bloat "just in case"** — incluir arquivos que talvez sejam necessários; fix: grep first, agent requests files it needs

## Routing Decision Tree

```
Task de arquitetura/segurança? → Opus 4.6 / GPT-5 (10% do trabalho)
Implementação seria / refactor / debug? → Kimi 2.6 (90% do trabalho)
Lint / format / edits triviais? → Haiku 4.5
Boilerplate / autocomplete? → Ollama local (gratuito)
```

## Kimi 2.6 como Workhorse

- Preço: ~$0.50/$2 por M tokens (vs Sonnet $3/$15 = 6x mais barato)
- Qualidade: match com Sonnet em refactors, debugging, implementação, loops longos
- Contexto: 256k window, coerência equivalente ao Sonnet em long-context
- Rate limits: mais generosos que Sonnet
- Benchmark: Refactor 500 linhas → Kimi $0.04 / qualidade 9.2 vs Sonnet $0.12 / qualidade 9.0

## 7 Técnicas Práticas

1. Enable prompt caching everywhere (90% de redução em tokens estáveis)
2. Grep before fetching (`rg "symbol" --type ts -B 5 -A 20`)
3. Profile tool calls (`--verbose-tools`, analisar top 3 loops)
4. Graduated skill pattern (salvar workflows como SKILL.md elimina fase de discovery)
5. Local models (Ollama + Qwen3 para autocomplete = $0)
6. Summarize aggressively (200k tokens → 5k summary a cada 10–15 turns)
7. Batch small requests (10 perguntas em 1 prompt = 70–90% de saving em input)

## Plano de 30 Dias

- Semana 1: caching + desligar auto-context + instalar ripgrep → −30–40%
- Semana 2: switch default para Kimi 2.6 → −40–55% adicional
- Semana 3: profile + fix top 3 tool loops → −10–20% adicional
- Semana 4: SKILL.md + Ollama local → −5–10% adicional

Resultado: $4.200/mês → $312/mês (7.5% do custo original)

## Conexões

- [[03-RESOURCES/entities/Kimi-K2.6]] — modelo workhorse recomendado; atualizar com dados de preço
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — técnica #1 de saving
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — SKILL.md pattern para graduação de workflows
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — context discipline é o lever real
- [[03-RESOURCES/entities/DeRonin]] — autor; @DeRonin_ no X
- [[03-RESOURCES/concepts/model-routing]] — novo conceito; ver abaixo

---

## Por que "contexto desnecessário" é o problema real

A framing do artigo — "o problema não é o preço dos modelos, é contexto desnecessário" — tem uma base técnica concreta.

O custo de uma sessão de AI coding segue aproximadamente: `custo = tokens_input × preço_input + tokens_output × preço_output`. Os tokens de output são fixos para uma qualidade dada de solução. Os tokens de input são onde a disciplina de contexto atua.

**Por que context bloat acontece:**
- Auto-context tools carregam o repositório completo por default — "segurança" que vira custo
- Cada tool call reenvía o contexto acumulado, não apenas o delta
- Streaming em vez de batching pode multiplicar o número de requests para a mesma quantidade de trabalho
- "Just in case" context — incluir arquivos que talvez sejam necessários vs. apenas os que definitivamente são

O modelo mais caro + contexto disciplinado é invariavelmente mais barato do que o modelo mais barato + contexto inflado.

---

## O argumento econômico para model routing

O routing decision tree do artigo é baseado em uma observação simples: a distribuição de dificuldade de tasks em dev work não é uniforme.

Aproximadamente:
- 10% das tasks realmente exigem raciocínio de nível frontier (arquitetura, segurança, algoritmos não-triviais)
- 90% são execução bem especificada onde qualquer modelo competente produz o mesmo resultado

Pagar preço de frontier para 100% das tasks quando 90% delas teriam o mesmo resultado com um modelo 6x mais barato é um subsídio implícito de qualidade desnecessária. O routing elimina esse subsídio sem sacrificar qualidade onde ela importa.

**Cálculo simples:** 
- Sem routing: 100 tasks × $0.12 = $12.00
- Com routing (10% frontier, 90% Kimi): 10 × $0.12 + 90 × $0.04 = $4.80
- Economia: 60% sem perda de qualidade nas tasks difíceis

---

## As 5 armadilhas em profundidade

**Armadilha 1 — Re-sending entire repo:** o auto-context de editores como Cursor envia arquivos "relacionados" automaticamente. O algoritmo de relacionamento é baseado em proximidade de diretório e importações — não em relevância para a task atual. Fix: usar `grep` primeiro para identificar os 2-3 arquivos realmente relevantes, depois carregá-los explicitamente.

**Armadilha 2 — Tool call loops:** quando o agente não consegue resolver o problema com uma tool call, a reação default é tentar outra. E outra. E outra. Cada iteração no loop custa o contexto completo acumulado até aquele ponto. Fix: batch tool calls em um único request, usar helpers determinísticos para operações de filesystem.

**Armadilha 3 — Premium model para tasks triviais:** a maioria das sessões de dev tem ~70% de tasks que são execução mecânica (formatar, renomear, mover, gerar boilerplate). Usar Opus para essas tasks é como usar um carro de corrida para ir ao mercado.

**Armadilha 4 — Streaming vs batching:** streaming envia tokens à medida que são gerados — ótimo para UX interativo mas prejudicial para prompt caching em alguns backends. Para background agents que não precisam de resposta em tempo real, batching permite que o servidor complete a resposta antes de enviar, o que é mais compatível com caching.

**Armadilha 5 — Context bloat "just in case":** a tentação de incluir um arquivo porque "pode ser relevante" ignora que cada arquivo incluído dilui a atenção do modelo para o que é definitivamente relevante. Um contexto com 5 arquivos certos é melhor do que um contexto com 20 arquivos onde 5 são certos e 15 são ruído.

---

## SKILL.md como graduated context

A técnica "Graduated Skill Pattern" do artigo é uma das mais sub-utilizadas. Um SKILL.md funciona como contexto graduado: o agente aprende o workflow uma vez (durante discovery), codifica ele num SKILL.md, e nas runs futuras usa o SKILL.md em vez de redescobrir o workflow do zero.

Para tasks repetitivas como "rodar os testes de integração e interpretar o output", sem SKILL.md:
- Run 1: explorar a estrutura de testes, descobrir o comando correto, aprender os padrões de output → 50k tokens
- Run 2: repetir o mesmo processo → 50k tokens
- Run N: mesmos 50k tokens repetidos

Com SKILL.md:
- Run 1: explorar + criar SKILL.md → 50k tokens + 2k tokens de escrita
- Run 2+: ler SKILL.md e executar → 2k tokens
- Economia a partir da Run 2: 96%

---

## Plano de 30 dias: por que essa ordem

A sequência do plano importa:

**Semana 1 (caching + auto-context):** mudanças de configuração puras — zero risco, impacto imediato. O saving de 30-40% motiva o investimento nas semanas seguintes.

**Semana 2 (routing para Kimi):** requer confiança de que Kimi é adequado para o seu workflow específico. A semana 1 libera budget para testar — você pode gastar mais com Kimi na semana de teste porque está economizando nos outros vetores.

**Semana 3 (profiling de tool loops):** requer observação de sessões reais para identificar onde os loops ocorrem. Não dá para abstrair — precisa de dados do seu próprio workflow.

**Semana 4 (SKILL.md + Ollama):** requer que as semanas anteriores estejam estabilizadas, porque você vai codificar workflows em SKILL.md — se os workflows ainda estão mudando por causa dos ajustes das semanas 1-3, os SKILL.mds ficam desatualizados rapidamente.

A sequência é: **eliminar desperdício estrutural → trocar provider onde adequado → otimizar loops específicos → codificar o que sobrou**.
