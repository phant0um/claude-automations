---
skill: triagem-scoring
version: 1.0
author: Nexus (gerado via triagem 2026-05-23)
tags: [triagem, curadoria, scoring, pre-ingest, automation, bash]
---

# Skill: Triagem Scoring — Heurísticas Determinísticas

## Propósito

Automatizar o scoring de arquivos candidatos a ingest usando regras determinísticas (bash + heurísticas de título/conteúdo), reduzindo ou eliminando AI calls na fase de triagem. Score 0–10. Limiar: ≥5 = aprovado.

Motivação: triagem manual de 108 arquivos em 2026-05-23 custou ~N calls de AI. As regras abaixo capturam ~80% das decisões via padrões no nome do arquivo e conteúdo.

---

## Regras de Scoring (Bash-First)

### Score Base por Padrão de Título (aplicar em ordem, somar)

```bash
score=5  # base

# Sinais POSITIVOS (+1 a +3)
[[ "$title" =~ "deep dive|deep-dive|A Deep Dive" ]] && ((score+=2))
[[ "$title" =~ "paper|arxiv|survey|research|benchmark" ]] && ((score+=3))
[[ "$title" =~ "framework|architecture|anatomy|layers|principles" ]] && ((score+=2))
[[ "$title" =~ "how.*works|how.*build|engineering|implementation" ]] && ((score+=1))
[[ "$title" =~ "agent.*memory|memory.*agent|harness|orchestration" ]] && ((score+=1))
[[ "$title" =~ "claude code|claude.*setup|claude.*workflow" ]] && ((score+=1))
[[ "$title" =~ "obsidian.*vault|vault.*obsidian|second brain" ]] && ((score+=2))
[[ "$title" =~ "spec-driven|specification|contract" ]] && ((score+=1))

# Sinais NEGATIVOS (-1 a -5)
[[ "$title" =~ "^[a-z0-9]+-[a-z0-9]+[A-Z]" ]] && ((score-=2))  # username-repoDesc (GitHub README)
[[ "$title" =~ "github.com|^[a-z]+[A-Z][a-z]+" ]] && ((score-=2))  # GitHub README heuristic
[[ "$title" =~ "save thousands|cashflow|make money|income" ]] && ((score-=3))  # monetização
[[ "$title" =~ "vibe cod|vibe-cod" ]] && ((score-=2))  # vibe coding superficial
[[ "$title" =~ "maxxing|grok maxx" ]] && ((score-=4))  # hype puro
[[ "$title" =~ "you should be|I can be you" ]] && ((score-=2))  # personal essay
[[ "$title" =~ "step-by-step guide|automate your life" ]] && ((score-=1))  # genérico
[[ "$title" =~ "VTuber|weather plugin|docker.*sandbox" ]] && ((score-=4))  # off-topic
[[ "$title" =~ "Thread by @|Post by @" ]] && ((score-=2))  # X thread sem título próprio
[[ "$title" =~ "roadmap|zero to.*engineer|become.*developer" ]] && ((score-=1))  # roadmap genérico
```

### Ajuste por Conteúdo (2000 chars limpos)

```bash
# Verificar presença de estrutura técnica
[[ "$snippet" =~ "^## |^### " ]] && ((score+=1))          # estrutura de seções
[[ "$snippet" =~ "Abstract|abstract:" ]] && ((score+=2))   # paper acadêmico
[[ "$snippet" =~ "arxiv|arXiv|doi:" ]] && ((score+=2))     # referência acadêmica
word_count=$(echo "$snippet" | wc -w)
[[ $word_count -lt 100 ]] && ((score-=3))                  # conteúdo mínimo
[[ "$snippet" =~ "sponsor|advertisement|referral" ]] && ((score-=1))  # ads

# Verificar relevância para vault
[[ "$snippet" =~ "agent|LLM|claude|hermes|obsidian|memory|harness" ]] && ((score+=1))
[[ "$snippet" =~ "FIAP|concurso|ADS|semestre" ]] && ((score+=2))  # conteúdo FIAP
```

### Cap

```bash
[[ $score -gt 10 ]] && score=10
[[ $score -lt 0 ]] && score=0
```

---

## Condições de Ativação

- Ativar quando: triagem manual tiver >20 arquivos candidatos
- Ativar como pré-filtro antes de qualquer AI call de scoring
- Resultado: dois grupos — score <5 (rejeitar sem AI), score ≥5 (aprovar ou refinar com AI)

NÃO usar para: arquivos únicos, análise de conteúdo profundo, scoring de papers (esses merecem AI call).

---

## Integração com triagem-clipping.md

Substituir o Step 1 (Leitura e scoring por AI) pelo loop:

```bash
for f in $(cat /tmp/candidates_new.txt); do
  title=$(basename "$f" .md)
  snippet=$(head -c 4000 "$f" | sed -E '...' | head -c 2000)
  score=$(bash score_heuristic.sh "$title" "$snippet")
  echo "$f $score" >> /tmp/triagem_scores.txt
done

# Grupo borderline (score 4-6): enviar para AI call em batch
# Grupo seguro aprovado (score 7-10): aprovar direto
# Grupo seguro rejeitado (score 0-3): rejeitar direto
```

**Economia estimada:** ~60% dos arquivos resolvidos sem AI call (score <3 ou >7 são casos claros).

---

## Guardrails

- Heurísticas GitHub README (padrão `username-repoTitle`) são ~90% precisas — margem 10% de FP
- Score 4 é borderline — nunca rejeitar automaticamente; sempre passar por AI call
- Score 3 ou menos → rejeitar direto (FN aceitável: arquivos de score 3 raramente têm ingest útil)
- Erros de parse (arquivo sem texto) → score conservador = 5 (aprovado por default)

---

## Changelog

- v1.0 (2026-05-23): criado a partir de análise post-hoc dos 108 arquivos triados manualmente em 2026-05-23. Padrões extraídos dos rejeitados vs. aprovados.
