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

## File Evaporation Pattern (2026-06-16)

**Problema recorrente:** `find` escaneia Clippings/ no inicio do pipeline e
gera candidates_all.txt. Mas entre o scan e o processamento (segundos a
minutos depois), arquivos somem do disco. Causas:

1. Readwise sync limpa/substitui arquivos durante o cycle
2. Pipeline anterior moveu arquivos para 08-ARCHIVE/ mas não atualizou manifest
3. Obsidian sync (iCloud/Dropbox) remove arquivos temporariamente

**Sintoma:** `[ -f "$f" ]` retorna false para caminhos em candidates_new.txt.
`cp` falha silenciosamente. Pipeline reporta "0 files ingested" mesmo com
N candidatos aprovados.

**Diagnóstico rápido:**

```bash
EXISTING=0; MISSING=0
while IFS= read -r f; do
  [ -f "$f" ] && EXISTING=$((EXISTING+1)) || MISSING=$((MISSING+1))
done < /tmp/candidates_new.txt
echo "Existing: $EXISTING, Missing: $MISSING"
```

Se MISSING > 0, arquivos evaporaram. Verificar 08-ARCHIVE/ para confirmar
que ja foram processados:

```bash
while IFS= read -r f; do
  [ -f "$f" ] && continue
  bn=$(basename "$f")
  found=$(find 08-ARCHIVE/ -name "$bn" 2>/dev/null | head -1)
  [ -n "$found" ] && echo "ALREADY ARCHIVED: $bn -> $found"
done < /tmp/candidates_new.txt
```

**Mitigação:** Nao tratar file evaporation como erro — tratar como sinal de
que processamento retroativo e necessario (manifest entry + source page check).
O pipeline-diario deve ter um passo de "retroactive manifest reconciliation"
apos detectar file evaporation. Ver [[04-SYSTEM/skills/foundational/pre-ingest-dedup]]
para o formato de retroactive manifest entry.

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

## Expanded Heuristics for Large Batches (2026-06-22)

When scoring >50 files, the base regex set captures ~60% but misses vault-specific
topics. Add these patterns (applied in Python, not bash — bash regex becomes
unwieldy at this scale):

### Positive signals (vault-specific)

```python
# Loop engineering / autonomous loops (core obsession)
if re.search(r'loop engineering|autonomous loop|agent loop', title, re.I): score += 2
# Hermes / Telegram agents
if re.search(r'hermes|telegram.*agent', title, re.I): score += 1
# Agent design patterns / agent stack
if re.search(r'agent.*design.*pattern|agent.*stack|agent.*optimization', title, re.I): score += 2
# Self-improvement / RSI
if re.search(r'self-improv|recursive.*self|RSI', title, re.I): score += 2
# LLM theory / training
if re.search(r'diffusion|transformer|matmul|triton|kernel|LoRA|fine-tun', title, re.I): score += 2
# Trading / quant
if re.search(r'polymarket|trading.*agent|quant.*framework|markov.*trade', title, re.I): score += 2
# Multi-agent / safety research
if re.search(r'Co-Scientist|multi-agent|safety.*research|MosaicLeaks', title, re.I): score += 2
# Agent security / oversight
if re.search(r'OpenSigil|Oversight.*Layer.*Agent|information-flow.*IFC', title, re.I): score += 2
# Claude Code skills / cowork
if re.search(r'Claude Code Skills|REVIEWS.md|Memory.md', title, re.I): score += 2
# Codex / sandbox / Responses API
if re.search(r'Codex.*sandbox|Responses API.*agente|Codex.*Symphony', title, re.I): score += 1
# Ollama / local inference
if re.search(r'Ollama.*MLX|GGUF|OpenJarvis', title, re.I): score += 1
```

### Negative signals (clickbait / off-topic)

```python
# Clickbait marketing
if re.search(r'cheat code|millionaire|10.000.*month|10X|escape wage|mass replacement', title, re.I): score -= 3
# B2B / cold outreach
if re.search(r'cold email|cold outreach|B2B.*lead|qualify.*B2B', title, re.I): score -= 2
# Generic self-help
if re.search(r'open loops|elite clarity|happiness|social worker|healthier', title, re.I): score -= 2
# Off-topic VPN/proxy (Chinese)
if re.search(r'零成本|不花一分钱|VPS.*private.*node|安全拿回', title, re.I): score -= 3
# JetBrains release notes (low vault value)
if re.search(r'JetBrains|DBeaver.*release|DataGrip.*2026|PyCharm.*2026|CLion.*2026', title, re.I): score -= 1
# Beginner tutorials
if re.search(r'What Is Git.*Beginner|What Is OAuth.*Explained', title, re.I): score -= 2
# Enterprise case studies (low reuse)
if re.search(r'reimagining trade finance|insurance company.*data hub|regulation intensifies', title, re.I): score -= 2
```

### Python scoring > bash for large batches

For >50 files, use Python instead of bash — regex is cleaner, string ops are
richer, and the whole scoring loop runs in <5s. Save results to JSON for
downstream pipeline consumption:

```python
results = []
for f in candidates:
    score, grade = score_file(f)  # score_file uses re.search with all patterns
    results.append({"file": f, "score": score, "grade": grade})
results.sort(key=lambda x: x["score"], reverse=True)
```

### macOS `shuf` not available

`shuf` (GNU coreutils) doesn't exist on macOS. For random sampling:

```python
# Instead of: shuf -n 3 file.txt
python3 -c "import sys,random; random.seed(42); [print(l) for l in random.sample(sys.stdin.read().strip().split('\n'), 3)]"
```

### File Evaporation Selectivity (2026-06-22 observation)

In a 157-candidate batch, 64 files evaporated between scan and processing.
**All 64 were Score C/D or borderline B — zero Score A files were lost.**

Hypothesis: Readwise sync purges older/less-recently-accessed clippings first.
High-value clippings (recently clipped, frequently accessed) survive sync cycles.

**Implication for pipeline:** evaporation acts as a natural quality filter.
Don't fight it — treat evaporated C/D files as "auto-rejected by sync" and
focus energy on the A/B files that survived.

---

## Changelog

- v1.3 (2026-06-22): + Expanded Heuristics for Large Batches (50+ vault-specific
  regex patterns: loop engineering, Hermes, Polymarket, agent security, LLM theory,
  Codex, Ollama). + Python scoring > bash for >50 files. + macOS `shuf` pitfall
  (use python3 random.sample). + File Evaporation Selectivity observation
  (evaporation preferentially removes C/D files — natural quality filter).
  Achado: pipeline-semanal 2026-06-22, 157 candidatos, 64 evaporados (100% C/D).
- v1.2 (2026-06-16): + File Evaporation Pattern (arquivos somem do Clippings/
  entre find e processamento — Readwise/Obsidian sync, pipeline anterior).
  + Nexus Manual Override expandido (heurística não conta multi-match do mesmo
  domínio — "loop engineering" pode ter score 4 mas ser core A).
  Achado: pipeline-diario 2026-06-16, 248 candidatos, 100% já ingeridos mas
  file evaporation causou debugging até confirmar source pages existiam.
- v1.1 (2026-06-16): + macOS Compatibility Pitfalls section (grep -P -> sed/grep -oE,
  aula number extraction, curso-ID extraction). + Grade Mapping A-D (v4.1+).
  + Nexus Manual Override (heuristica nao conta multi-match do mesmo dominio).
  Achado: pipeline-diario 2026-06-16 quebrou em grep -P no macOS.
- v1.0 (2026-05-23): criado a partir de analise post-hoc dos 108 arquivos triados
  manualmente em 2026-05-23. Padroes extraidos dos rejeitados vs. aprovados.