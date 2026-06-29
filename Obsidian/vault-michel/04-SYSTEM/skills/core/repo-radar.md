---
name: repo-radar
description: "Recebe lista de URLs de repo GitHub → fetch metadata/README → emite tabela comparativa vs inventário do vault (AGENTS.md): JÁ TEM / COMPLEMENTA / OTIMIZA / REFERÊNCIA / FORA + alvo. Use quando o usuário manda repos p/ analisar/comparar."
skill: repo-radar
version: 1.0
trigger: "@repo-radar [urls] · 'analise esses repos' · 'comparativo de repos'"
model: claude-haiku-4-5
tags: [discovery, scout, repos, comparativo, dedupe]
attach: scout
---

# Skill: repo-radar

## Propósito
Transformar análise manual de repos em 1 passo determinístico. Evita re-fazer à
mão o que foi feito nos Lotes 2-4 (50 repos).

## Protocolo
1. **Fetch (batch):** p/ cada URL:
   `gh api repos/<owner>/<repo> --jq '{desc,lang,stars,topics}'`
   README se preciso: `gh api repos/<owner>/<repo>/readme --jq '.content' | base64 -d`
2. **Inventário:** ler `04-SYSTEM/AGENTS.md` (agentes/skills atuais).
3. **Classificar** cada repo:
   - **JÁ TEM** — vault já cobre (citar o quê)
   - **COMPLEMENTA** — lacuna real (citar alvo: agente/skill/rotina)
   - **OTIMIZA** — melhora algo existente (citar o quê)
   - **REFERÊNCIA** — conhecimento → fila `07-QUEUE/sources-pendentes.md`
   - **FORA** — fora de escopo (citar por quê)
4. **Emitir** tabela: Repo | Veredito | Alvo. + síntese acionável (alto valor primeiro).
5. **Dedupe:** marcar repos que duplicam veredito de outro (evitar bloat).

## Saída
Tabela markdown + bloco "Síntese acionável" + sugestão de tarefas (formato
FIND/REPLACE/VERIFY se for editar o vault).

## Anti-pattern
- Importar em massa. Sempre seletivo (alinha dedupe-rule do AGENTS.md).
- Classificar sem ler o inventário → falso "COMPLEMENTA" do que já existe.