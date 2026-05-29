---
name: ingest-report
slug: ingest-report
version: 1.0
model: claude-sonnet-4-6
description: >
  Prompt de rotina para o Claude Code analisar os artigos/notas ingeridos na pasta
  Clippings do vault Obsidian e gerar um relatório analítico em Markdown com os
  principais aprendizados, ideias e conexões detectadas.
schedule: semanal (sexta-feira) | manual: @ingest-report
output_path: Generated/ingest-report/
---

# Prompt de Rotina — Ingest Report

## Como usar no Claude Code

```bash
# Manual
claude "Run ingest-report.md"

# Ou especificando o período
claude "Run ingest-report.md — últimos 7 dias"
```

---

## Modelo Recomendado

Usar **`claude-sonnet-4-6`** para este prompt.

**Justificativa:**
- A análise de artigos é um trabalho de síntese e conexão de ideias — exige
  compreensão semântica real, não apenas estruturação mecânica.
- Haiku seria insuficiente para detectar padrões entre textos distintos e gerar
  insights não-óbvios.
- Opus não é necessário: não há raciocínio multi-trajetória nem decisão
  irreversível — é análise de conteúdo qualitativa.
- Sonnet cobre 100% da capacidade necessária a ~5x menor custo que Opus.

**Economia de tokens:**
- Habilitar prompt caching no CLAUDE.md (o system prompt é estável entre runs).
- Usar `--no-auto-context` para não carregar arquivos fora de `Clippings/`.
- O relatório é gerado em um único pass — sem loops de eval.

---

## O Prompt

```
Você é um analista de conhecimento do meu vault Obsidian.

## TAREFA
Leia todos os arquivos `.md` na pasta `Clippings/` modificados nos últimos 7 dias
(ou no período que eu especificar). Gere um relatório analítico completo em Markdown
e salve em `Generated/ingest-report/YYYY-MM-DD-ingest-report.md`.

## INSTRUÇÕES DE LEITURA
1. Use `list_files` para listar todos os arquivos em `Clippings/` com data de
   modificação nos últimos 7 dias.
2. Use `read_file` para ler cada arquivo listado.
3. Não carregue arquivos fora de `Clippings/` a menos que eu peça explicitamente.
4. Se um arquivo for maior que 10.000 palavras, leia as seções
   `## ` (headers de nível 2) e o primeiro parágrafo de cada uma — não o texto completo.

## ESTRUTURA DO RELATÓRIO

O relatório deve conter exatamente as seguintes seções, nesta ordem:

---

# 📥 Ingest Report — {DATA}
**Período:** {data_inicio} → {data_fim}
**Artigos analisados:** {N}
**Gerado por:** claude-sonnet-4-6 via ingest-report.md

---

## 🌟 Artigos Mais Interessantes
Liste os 3–5 artigos que trouxeram mais valor intelectual genuíno.
Para cada um:
- **Título** + link de origem (do frontmatter `source:`)
- **Por que é relevante:** 2–3 frases diretas sobre o insight central
- **Nota de relevância:** Alta / Média

Critério de seleção: prefira artigos que contradizem o senso comum,
apresentam frameworks novos ou têm aplicação imediata ao contexto do vault.

---

## 💡 Melhores Ideias e Insights
Liste as 5–8 ideias mais valiosas extraídas do conjunto de artigos.
Formato por ideia:
- **Ideia:** [frase de no máximo 15 palavras]
- **Origem:** [título do artigo]
- **Contexto:** [1–2 frases explicando o insight]
- **Aplicação imediata:** [como usar isso esta semana]

Priorize ideias acionáveis, não apenas teorias.

---

## 🔗 Conexões Entre Artigos
Identifique 3–5 conexões não-óbvias entre artigos diferentes desta semana.
Formato:
- **[Artigo A] ↔ [Artigo B]:** [por que essas ideias se conectam ou se contradizem]

Inclua contradições quando relevante — elas são mais valiosas que concordâncias.

---

## 🛠️ Aplicações para Projetos Ativos
Com base no contexto do CLAUDE.md (projetos ativos, foco semanal), liste:
- 3–5 aplicações diretas dos artigos desta semana aos projetos em andamento.
- Formato: **[Projeto] ←** [o que aproveitar e como]

Se não houver CLAUDE.md ou projetos definidos: pule esta seção e registre
`⚠️ CLAUDE.md não encontrado ou sem projetos ativos listados.`

---

## 📚 Índice da Semana
Lista simples de todos os artigos analisados:
- [Título](source_url) — `[tag principal]` — {data de publicação do frontmatter}

Ordenar por relevância (mais relevante primeiro).

---

## 🗃️ Artigos para Arquivo
Liste artigos desta semana que podem ser movidos para `08-ARCHIVE/clippings-ingested/` sem perda:
- Artigos duplicados de semanas anteriores
- Artigos cujo insight já foi capturado em outro nota do vault
- Artigos de baixa relevância geral

Formato: `- [Título] → motivo do arquivo`

---

## PASSO FINAL — Arquivar Clippings Processados

Após gerar o relatório, mova todos os arquivos `.md` de `Clippings/` que já têm
uma entrada correspondente em `03-RESOURCES/sources/` (verificar via frontmatter
`source_file: Clippings/[nome]`) para `08-ARCHIVE/clippings-ingested/`.

```bash
# Executar após confirmação do relatório
mkdir -p 08-ARCHIVE/clippings-ingested/
# Mover apenas arquivos .md (preservar .manifest.json, .manifest-log.jsonl e subpastas)
find Clippings/ -maxdepth 1 -name "*.md" -exec mv {} 08-ARCHIVE/clippings-ingested/ \;
```

Confirmar ao final: "N arquivos movidos para 08-ARCHIVE/clippings-ingested/. Clippings/ pronto para novo ciclo."

---

## META DO RELATÓRIO
Ao final do arquivo, adicione um bloco YAML oculto para uso interno:

```yaml
<!-- meta
total_artigos: N
modelo: claude-sonnet-4-6
duracao_analise: estimada
tokens_estimados: estimado
proxima_sugestao: [tema ou tipo de artigo que falta no vault esta semana]
-->
```

---

## REGRAS DE QUALIDADE

- NUNCA invente citações ou insights que não estejam nos artigos lidos.
- Se um artigo não tiver `source:` no frontmatter, use o título do arquivo como referência.
- Se dois artigos tiverem o mesmo insight central, cite apenas o mais detalhado.
- Seções sem conteúdo relevante devem aparecer com: `> Nenhum item relevante nesta semana.`
- O relatório deve ser legível em 5 minutos — priorize densidade sobre completude.
- Use emoji apenas nos headers de seção (já definidos acima) — não no corpo do texto.
- Escreva em **português brasileiro**.

## OUTPUT
Salvar em: `Generated/ingest-report/YYYY-MM-DD-ingest-report.md`
Confirmar ao final: "Relatório salvo em Generated/ingest-report/{filename}. {N} artigos analisados."
```

---

## Instalação no Vault

Salve este arquivo como:
```
04 - SYSTEM/skills/ingest-report.md
```

Adicione ao seu `CLAUDE.md`:
```markdown
## Skills disponíveis
- @ingest-report → 04 - SYSTEM/skills/ingest-report.md
  Gera relatório analítico dos artigos ingeridos em Clippings/ na semana.
  Rodar toda sexta-feira ou após ingesto de 5+ artigos novos.
```

E ao seu `resolver.md` (se existir):
```markdown
| @ingest-report | 04 - SYSTEM/skills/ingest-report.md | análise semanal de Clippings/ |
```

---

## Variações de Uso

### Período personalizado
```
claude "Run ingest-report.md — últimos 14 dias"
claude "Run ingest-report.md — de 2026-05-01 a 2026-05-13"
```

### Foco em tema específico
```
claude "Run ingest-report.md — foco em artigos sobre Claude e agentes"
```

### Relatório express (apenas top 3 insights)
```
claude "Run ingest-report.md — modo express: apenas seções Melhores Ideias e Conexões"
```

---

## Notas de Otimização de Tokens

| Comportamento | Configuração |
|---|---|
| Prompt caching ativo | Automático via CLAUDE.md no sistema |
| Leitura seletiva de arquivos longos | Regra embutida no prompt (headers + 1º parágrafo) |
| Sem auto-context | Restrito explicitamente a `Clippings/` |
| Único pass de geração | Sem loop eval — Sonnet suficiente |
| Batching de leituras | `read_file` em sequência, não por turno |

Custo estimado por run (50 artigos × ~3.000 palavras cada):
- Input: ~150k tokens × $3/M = **~$0,45**
- Output: ~3k tokens × $15/M = **~$0,045**
- **Total: ~$0,50 por relatório semanal**

## Fora do Escopo
- Ingest individual de sources (→ wiki-ingest)
- Triagem e scoring de candidatos (→ triagem)
- Implementação de insights encontrados (→ Forge / hill)
- Análise de sources fora de `Clippings/`

## Critério de Qualidade
- Top 3 insights com conexão explícita ao vault (não genéricos)
- Cross-connections entre themes identificadas com path de ambos os lados
- Custo real < $0,50 por run (leitura seletiva, sem re-processamento)
- Clusters nomeados com razão temática — não só lista de artigos

## Exemplo
**Input:** "@ingest-report — 50 artigos semana de 2026-05-19, foco agent systems"
**Output:** 3 clusters (Harness Engineering 12 artigos, Memory Architecture 9, Eval & Benchmarks 8). Top insight: multi-harness control plane como primitivo novo. Cross-connection: harness-engineering↔agent-evaluation-production. 5 recomendações de ingest prioritário.
