---
title: Skill Optimization via Gradient Descent (SkillOpt)
type: concept
area: agent-systems
created: 2026-05-31
updated: 2026-05-31
score: 9
tags: [concept, agent-systems, skill-optimization, gradient-descent, text-space, frozen-llm, validation-gate, skillopt, self-evolving-agents]
---

# Skill Optimization via Gradient Descent

## Tese central

Skills (arquivos SKILL.md/markdown) são **parâmetros treináveis em espaço textual** — não documentação estática. SkillOpt (Microsoft, arXiv 2605.23904) formaliza esse argumento: aplica maquinaria análoga à descida de gradiente para otimizar skills sem tocar nos pesos do modelo. Frozen model + trained context = adaptação barata, portátil e inspecionável.

## Princípios fundamentais

### 1. Text-space gradient descent
- **Gradiente** → edição guiada por trajetória (trajectory-driven edits)
- **Loss function** → validation gate: só aceita edição que melhora estritamente o val set
- **Learning rate** → tamanho de diff: 4–8 edições por passo (ponto ótimo)
- **Epochs** → iterações sobre o batch de tarefas
- **Convergência** → 1–4 edições aceitas por run completo em processo bem calibrado

> "Se seu agente auto-melhorador aceita a maioria das propostas, está enviando lixo." — @koylanai

### 2. Validation gate = barreira anti-regressão
- Update de skill só aceito se melhora estritamente no hold-out set
- Empates rejeitados — não apenas "não piorou"
- Sem validation gate: otimização colapsa para ruído
- Soft gate (PR #25): para val sets ≤10 itens com reward contínuo onde hard gate stalls

### 3. Compactação vence comprimento
- Skill mediana ótima: **~920 tokens**
- Comprimento ≠ qualidade; sinal por token é a métrica correta
- Skills longas = inchadas porque "comprimento parece esforço"
- Progressive disclosure (filesystem) resolve o tradeoff: skill core compacta + arquivos referenciados sob demanda

### 4. Slow-state vs fast-state
- **Slow-state** (invariante): `voice-guide.md`, `tone-of-voice.md` — raramente muda, alta penalidade por erro
- **Fast-state** (dinâmico): `posts.jsonl`, `bookmarks.jsonl` — muda com frequência
- SkillOpt adiciona **seção protegida invariante**: edições rápidas não sobrescrevem lições lentas
- Remover proteção slow-state custou 22 pontos no SpreadsheetBench

### 5. Portabilidade cross-runtime
- Skill treinada no Codex → portada para Claude Code: **+59.7pp no SpreadsheetBench**
- Conhecimento procedural em texto é mais geral que o runtime que o produziu
- `best_skill.md` como artefato deployável: drop em qualquer runtime compatível

## Arquitetura SkillOpt

```
Trajetórias de rollout
       ↓
Editor LLM (propõe edições; max 4-8 por step)
       ↓
Validation gate (hold-out set, melhoria estrita)
  ├── ACEITA → skill_vXXXX.md + best_skill.md atualizado
  └── REJEITA → descarta edição
       ↓
Próximo epoch
```

Outputs por run:
- `best_skill.md` — artefato deployável final
- `skills/skill_vXXXX.md` — snapshot por step (versioning)
- `history.json` — log de todas as tentativas
- `runtime_state.json` — checkpoint para resume

## Convergência com Anthropic (não-paper)

Enquanto SkillOpt é formal (Microsoft Research), as fontes Anthropic convergem independentemente:

| SkillOpt | Anthropic "how we use skills" | Anthropic "seeing like an agent" |
|----------|-------------------------------|----------------------------------|
| Validation gate | Gotchas section = falhas reais | Tool design = experimental |
| ~920 tokens | "Skills começam com poucas linhas + 1 gotcha" | "~20 tools, bar alto para adicionar" |
| Slow/fast state | `${CLAUDE_PLUGIN_DATA}` para dados estáveis | Filesystem como context engineering |
| Progressive disclosure | Estrutura de pasta referenciada | RAG → Grep → navegação recursiva |
| Frozen LLM + context | Skill portável > runtime específico | Tools evoluem com capacidades do modelo |

**Insight cross-domain:** as três fontes chegaram ao mesmo lugar por caminhos diferentes — otimização formal (MS), engenharia pragmática (Anthropic interna) e análise crítica (@koylanai). Padrão 3+ = alta confiança.

## Implicações práticas para o vault

1. **hill agent** é uma versão informal do SkillOpt — sem validation gate formal. Considerar adoptar protocolo: proposta → teste em hold-out → aceita só se melhora.

2. **wiki-ingest, pipeline-diario, relatorio-artigos** são candidatas a SkillOpt (mais usadas, benchmarks claros).

3. **Limite diff size** em qualquer skill que edita a si mesma: max 4-8 edições por rodada.

4. **Slow-state protection**: nas skills do vault, seções marcadas `<!-- [INVARIANT] -->` mapeiam exatamente para o mecanismo slow-state do SkillOpt.

5. **Verificação é o gargalo** para tarefas abertas (redação, design, estratégia) — sem auto-grader, SkillOpt falha. Reconhecer o limite.

## Relacionado

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — skills como padrões reutilizáveis (1ª ordem)
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] — skill learning progressivo, currículo
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — complementar: RL para comportamento; SkillOpt para conhecimento declarativo
- [[03-RESOURCES/sources/claude-code-skills/koylanai-skillopt-gradient-descent-skills]] — análise do paper
- [[03-RESOURCES/sources/claude-code-skills/microsoft-skillopt-github-repo]] — código fonte (arXiv 2605.23904)
- [[03-RESOURCES/sources/claude-code-skills/anthropic-how-we-use-skills]] — perspectiva Anthropic
- [[03-RESOURCES/sources/claude-code-skills/anthropic-seeing-like-an-agent]] — progressive disclosure + tool design
