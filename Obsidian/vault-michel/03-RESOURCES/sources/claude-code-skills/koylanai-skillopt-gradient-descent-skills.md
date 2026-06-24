---
title: "SkillOpt: Gradient Descent for SKILL.md Files (Post by @koylanai)"
type: source
source: "Clippings/Post by @koylanai on X.md"
author: "@koylanai"
origin: "https://x.com/koylanai/status/2059113412278227328"
created: 2026-05-25
ingested: 2026-05-28
tags: [ai-agents, source, skills, skillopt, skill-optimization, gradient-descent, trainable-parameters, self-evolving]
---

## Tese central

SkillOpt trata arquivos SKILL.md como **parâmetros treináveis** e aplica maquinaria de otimização adequada — analogamente à descida de gradiente — para melhorá-los. É um dos primeiros papers a formalizar esse approach. Skill de alta qualidade não é aquela mais longa, mas a de maior sinal: ~920 tokens, compacta, com proteções estruturais para slow-state.

## Argumentos principais

**Conceito central:** arquivos markdown não são documentação estática — são substrato de primeira classe para estado do agente. SkillOpt é a versão em forma de otimizador desse argumento: não "armazene memória em arquivos" mas "**trate arquivos como parâmetros treináveis com maquinaria de otimização adequada ao redor deles**." Mudança de estático para medido.

**6 lições do paper + experiência do autor:**

### 1. Validation gate = a única coisa que importa no loop de auto-edição
- Hold-out set + melhoria estrita + empates rejeitados
- End-to-end, melhores skills deles: **1–4 edições aceitas no total**
- Se seu "agente auto-melhorador" aceita a maioria das propostas → está enviando lixo

### 2. Edições limitadas > reescritas completas
- **4–8 edições por passo = ponto ideal**
- Análogo textual da taxa de aprendizado (learning rate)
- Remover orçamento de edições → performance colapsa
- Transfere para qualquer loop de LLM como autor de docs/prompts/skills: **limite o tamanho da diff**

### 3. Compactação vence
- Skill final mediana: **~920 tokens**
- Skills não precisam ser longas — precisam ser de alto sinal
- "A maioria dos arquivos de skills que vejo está inchada porque comprimento parece esforço. Não é."

### 4. Skill portável > runtime específico
- Skill treinada no Codex portada para Claude Code: **+59.7 pontos no SpreadsheetBench**
- Conhecimento procedural é mais geral que o runtime que o produziu
- O harness está se tornando menos importante; **a skill está se tornando mais importante**

### 5. Frozen model + trained context = adaptação prática
- GPT-5.4-nano + skill SkillOpt'd ≈ comportamento de fronteira em benchmarks procedurais
- Mais barato, portátil, inspecionável, custo zero em tempo de inferência
- Resposta para "como adaptar modelo de fronteira ao domínio" para quem não treina modelos próprios

### 6. Verificação é o gargalo
- Todo validation gate depende de um auto-grader
- Funciona para benchmarks. **Falha para escrita, design e estratégia** — exatamente o trabalho aberto que queremos automatizar
- "Quem construir o verificador para tarefas abertas possui a próxima etapa"

## Key insights

1. **fast/slow state em skills:** `voice-guide` e `tone-of-voice.md` = slow-state (raramente tocados). `posts.jsonl` e `bookmarks.jsonl` = fast-state. SkillOpt adiciona **seção protegida invariante** — garantia estrutural de que edições rápidas não podem sobrescrever lições lentas. Remover esse mecanismo custou 22 pontos no SpreadsheetBench.

2. **Descrição e corpo são duas superfícies diferentes.** O router só vê a description. O agente vê o corpo uma vez ativado. Podem discordar silenciosamente. Só testes end-to-end pegam isso.

3. **Acurácia agregada é a unidade errada.** Reescrever 3 descriptions: média do corpus moveu ~1pp. Skills individuais se moveram 23–25pp. "O tamanho do efeito por skill é onde está a ação."

4. **Personal Brain OS como predecessor:** post de fev 2026 do autor argumentou que arquivo markdown é substrato de primeira classe para estado do agente. SkillOpt é a versão em forma de otimizador do mesmo argumento.

5. **Contexto versionado como harness.md:** `docs/THE_HARNESS.md` do Nimbalyst é exatamente o tipo de arquivo que SkillOpt otimizaria — contexto treinado, não modelo treinado.

## Exemplos e evidências

- SpreadsheetBench: skill portada Codex→Claude Code: +59.7 pontos
- SpreadsheetBench: remover seção protegida invariante: -22 pontos
- Corpus com 3 descriptions reescritas: média moveu ~1pp; skills individuais: 23–25pp
- Skill final mediana: ~920 tokens (vs. skills inchadas comuns)
- 1–4 edições aceitas = resultado típico de processo de otimização bem calibrado

## Implicações para o vault

- **Skills do vault como parâmetros treináveis:** cada skill em `04-SYSTEM/skills/` pode ser tratada como objeto de otimização. Medir por efeito de skill, não por média.
- **Seção protegida invariante:** adicionar a skills críticas do vault para proteger lições slow-state de edições de auto-melhoria.
- **Orçamento de diff para hill agent:** quando `hill` (melhoria contínua) edita skills, limitar a 4–8 mudanças por passo — exatamente o que SkillOpt sugere.
- **Skill de ~920 tokens:** muitas skills do vault são longas demais. Auditoria de compactação usando este benchmark.
- **Validation gate para skills do vault:** implementar hold-out set de tarefas para testar efeito de mudanças em skills antes de aceitar.
- **Dois lados da description:** auditar que description triggers funcionam como routing surface e corpo como conteúdo de execução — podem divergir sem testes end-to-end.

## Links

- [[03-RESOURCES/entities/koylanai]] — autor
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — conceito base de skills
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — auto-melhoria de skills
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — anatomia oficial de SKILL.md
- [[03-RESOURCES/sources/claude-code-skills/skillos-google-self-evolving-skill-curation]] — SkillOS: curação auto-evolutiva de skills
- [[03-RESOURCES/sources/ai-agents-harness/wirthkarl-eight-pillars-coding-harness]] — harness como segundo produto; skills como primeiro
- [[03-RESOURCES/sources/claude-code-skills/anthropic-how-we-use-skills]] — tipos canônicos de skills; gotchas section

## Relações
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]] — conceito síntese deste paper
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] — skill otimização como gradient descent convergem
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — complementar: RL para comportamento, SkillOpt para conhecimento
