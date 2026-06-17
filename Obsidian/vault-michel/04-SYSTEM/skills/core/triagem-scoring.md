---
name: triagem-scoring
description: "Automatizar o scoring de arquivos candidatos a ingest usando regras deterministicas (bash + heuristica de titulo/conteudo), reduzindo ou eliminando AI calls na fase de triagem. Score 0-10. Limiar: >=5 = aprovado."
skill: triagem-scoring
version: 1.1
author: "Nexus (gerado via triagem 2026-05-23, atualizado 2026-06-16)"
tags: [triagem, curadoria, scoring, pre-ingest, automation, bash, macos-compat]
---

# Skill: Triagem Scoring — Heuristicas Deterministicas

## Proposito

Automatizar o scoring de arquivos candidatos a ingest usando regras deterministicas (bash + heuristicas de titulo/conteudo), reduzindo ou eliminando AI calls na fase de triagem. Score 0-10. Limiar: >=5 = aprovado.

Motivacao: triagem manual de 108 arquivos em 2026-05-23 custou ~N calls de AI. As regras abaixo capturam ~80% das decisoess via padroes no nome do arquivo e conteudo.

---

## Regras de Scoring (Bash-First)

### Score Base por Padrao de Titulo (aplicar em ordem, somar)

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
[[ "$title" =~ "save thousands|cashflow|make money|income" ]] && ((score-=3))  # monetizacao
[[ "$title" =~ "vibe cod|vibe-cod" ]] && ((score-=2))  # vibe coding superficial
[[ "$title" =~ "maxxing|grok maxx" ]] && ((score-=4))  # hype puro
[[ "$title" =~ "you should be|I can be you" ]] && ((score-=2))  # personal essay
[[ "$title" =~ "step-by-step guide|automate your life" ]] && ((score-=1))  # generico
[[ "$title" =~ "VTuber|weather plugin|docker.*sandbox" ]] && ((score-=4))  # off-topic
[[ "$title" =~ "Thread by @|Post by @" ]] && ((score-=2))  # X thread sem titulo proprio
[[ "$title" =~ "roadmap|zero to.*engineer|become.*developer" ]] && ((score-=1))  # roadmap generico
```

### Ajuste por Conteudo (2000 chars limpos)

```bash
# Verificar presenca de estrutura tecnica
[[ "$snippet" =~ "^## |^### " ]] && ((score+=1))          # estrutura de secoes
[[ "$snippet" =~ "Abstract|abstract:" ]] && ((score+=2))   # paper academico
[[ "$snippet" =~ "arxiv|arXiv|doi:" ]] && ((score+=2))     # referencia academica
word_count=$(echo "$snippet" | wc -w)
[[ $word_count -lt 100 ]] && ((score-=3))                  # conteudo minimo
[[ "$snippet" =~ "sponsor|advertisement|referral" ]] && ((score-=1))  # ads

# Verificar relevancia para vault
[[ "$snippet" =~ "agent|LLM|claude|hermes|obsidian|memory|harness" ]] && ((score+=1))
[[ "$snippet" =~ "FIAP|concurso|ADS|semestre" ]] && ((score+=2))  # conteudo FIAP
```

### Cap

```bash
[[ $score -gt 10 ]] && score=10
[[ $score -lt 0 ]] && score=0
```

---

## macOS Compatibility Pitfalls (2026-06-16)

### `grep -P` (Perl regex) nao existe no macOS

macOS usa BSD grep, nao GNU grep. `-P` (Perl-compatible regex) gera erro:

```
grep: invalid option -- P
usage: grep [-abcdDEFGHhIjJlLmMnOoPpRSsUVvwXxZz] ...
```

**Fix:** Substituir todas as extracoes `grep -oP` por `sed` ou `grep -o` com BRE/ERE:

```bash
# ANTES (Linux-only, quebra no macOS):
echo "$f" | grep -oP 'curso-\d+' | sort -u

# DEPOIS (macOS-compatible):
echo "$f" | sed -n 's/.*\(curso-[0-9]*\).*/\1/p' | sort -u
# ou
echo "$f" | grep -oE 'curso-[0-9]+' | sort -u
```

### Extracao de aula number

```bash
# ANTES (Linux):
aula_num=$(echo "$bn" | grep -oP 'aula-\K[0-9]+')

# DEPOIS (macOS):
aula_num=$(echo "$bn" | sed -n 's/.*aula-\([0-9]*\).*/\1/p')
```

### Extracao de curso-ID

```bash
# ANTES (Linux):
curso_id=$(echo "$bn" | grep -oP 'curso-\K[0-9]+')

# DEPOIS (macOS):
curso_id=$(echo "$bn" | sed -n 's/.*curso-\([0-9]*\).*/\1/p')
# ou
curso_id=$(echo "$bn" | grep -oE 'curso-[0-9]+' | head -1 | sed 's/curso-//')
```

---

## Grade Mapping (A-D scale, v4.1+)

A partir do pipeline-diario v3+, scoring e A-D, nao 0-10:

```bash
# Converter score numerico -> grade
if [[ $score -ge 8 ]]; then grade="A"
elif [[ $score -ge 5 ]]; then grade="B"
elif [[ $score -ge 3 ]]; then grade="C"
else grade="D"
fi
```

**Aprovados:** A + B -> ingest
**Rejeitados:** C + D -> `08-ARCHIVE/[C|D]/$(date -I)/`

---

## Nexus Manual Override

Heuristica bash captura ~60-80% dos casos. O resto precisa de julgamento Nexus
(manual). Quando aplicar:

1. **AI agent articles scored C:** Se o artigo cobre um core obsession do vault
   (agent systems, Claude, skills, loops, Obsidian/PKM), bump para A/B mesmo se
   a heuristica pontuou baixo. A heuristica nao conta multiplas matches do mesmo
   dominio - um artigo sobre "loop engineering" pode ter score 4 porque so
   matchou "loop" uma vez, mas e core A.

2. **Concurso aulas:** Seguem padrao estabelecido. 736+ entries similares no
   manifest. Todas A por default - material de estudo RFB e core obsession.

3. **Borderline (score 4-6):** 1 batch AI call (Haiku), nunca loop per-file.
   Abaixo do cache floor 4096 tokens.

---

## Condicoes de Ativacao

- Ativar quando: triagem manual tiver >20 arquivos candidatos
- Ativar como pre-filtro antes de qualquer AI call de scoring
- Resultado: dois grupos - score <5 (rejeitar sem AI), score >=5 (aprovar ou refinar com AI)

## Quando NAO Usar
- Arquivos unicos (overhead do script nao compensa)
- Analise de conteudo profundo - heuristicas de titulo nao capturam qualidade
- Scoring de papers academicos (abstracts densos merecem AI call)
- Corpus <20 arquivos (triagem manual e mais rapida)

---

## Integracao com triagem-clipping.md

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

**Economia estimada:** ~60% dos arquivos resolvidos sem AI call (score <3 ou >7 sao casos claros).

---

## Guardrails

- Heuristicas GitHub README (padrao `username-repoTitle`) sao ~90% precisas - margem 10% de FP
- Score 4 e borderline - nunca rejeitar automaticamente; sempre passar por AI call
- Score 3 ou menos -> rejeitar direto (FN aceitavel: arquivos de score 3 raramente tem ingest util)
- Erros de parse (arquivo sem texto) -> score conservador = 5 (aprovado por default)

---

## Changelog

- v1.1 (2026-06-16): + macOS Compatibility Pitfalls section (grep -P -> sed/grep -oE,
  aula number extraction, curso-ID extraction). + Grade Mapping A-D (v4.1+).
  + Nexus Manual Override (heuristica nao conta multi-match do mesmo dominio).
  Achado: pipeline-diario 2026-06-16 quebrou em grep -P no macOS.
- v1.0 (2026-05-23): criado a partir de analise post-hoc dos 108 arquivos triados
  manualmente em 2026-05-23. Padroes extraidos dos rejeitados vs. aprovados.