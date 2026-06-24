---
title: "I Connected Hermes Agent to My Obsidian Vault. My Research Operation Changed Overnight."
type: source
source: "Clippings/I Connected Hermes Agent to My Obsidian Vault. My Research Operation Changed Overnight..md"
original_url: "https://x.com/DamiDefi/status/2060653619116974089"
author: "@DamiDefi"
published: 2026-05-30
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, hermes-agent, obsidian, pkm, memory, soul-md, automation]
---

## Tese central

Conectar o Hermes Agent diretamente ao vault Obsidian transforma a ferramenta de um "chatbot mais esperto" em um sistema de pesquisa radicalmente diferente — a memória do vault atualiza-se automaticamente e o agente lê, escreve e conecta notas em sessões autônomas sem intervenção manual.

## Argumentos principais

1. **Claude tem teto estrutural**: cada sessão começa do zero. Claude Projects mitiga isso, mas é um sistema de contexto *manual* — você decide o que entra e quando atualizar. Hermes + Obsidian cria um sistema de contexto *vivo*.

2. **Hermes v0.14 (16 mai 2026) tem provider Obsidian nativo**: um único comando conecta:
   ```
   hermes memory setup --provider obsidian --path ~/vault
   hermes memory status
   ```
   O plugin Obsidian Local REST API (localhost:27123) dá acesso programático de leitura e escrita durante execução do agente.

3. **Scoped access é recomendado**: começar com pasta `04-Claude/hermes/` e só expandir para o vault completo após 3 dias de comportamento verificado.

4. **SOUL.md governa como o agente interpreta o vault**, não apenas sua "personalidade". Sem SOUL.md bem escrito, Hermes lê notas como biblioteca de conteúdo. Com SOUL.md específico, lê através da lente de quem você é e o que está tentando fazer. Conteúdo essencial: obsessões atuais, como quer ser desafiado, o que nunca quer.

5. **O morning brief com Hermes é cross-month, não cross-week**: o cron job lê o vault completo e gera conexões não-óbvias entre capturas recentes e notas antigas, sinais narrativos emergentes, e contradições com a tese ativa.

6. **Skill files acumulam competência**: após 6 semanas, o agente acumulou 23 skill files — cada workflow executado ≥2 vezes foi codificado como procedimento reutilizável. O agente melhora porque o procedimento melhora.

7. **Multi-model routing automático**: Claude Opus para raciocínio profundo/escrita; modelos mais baratos via OpenRouter para pesquisa em massa. Cada perfil tem config, memória, skills, sessões e SOUL.md independentes.

## Key insights

- **"The gap between a manually curated context system and a live-reading agent changes what the tool can actually do."** — a diferença não é de grau, é categórica.
- SOUL.md é a camada de instrução que governa como Hermes *interpreta* tudo o que lê no vault. "Your persona lives in a markdown file. Your facts live in another markdown file. Your conversation history lives in a SQLite database." — sistema completamente debuggável via ferramentas padrão.
- **Capture-to-intelligence gap collapsed**: ideia enviada por Telegram ao bot → Hermes verifica conexão com notas existentes em tempo real.
- Compounding acontece mais rápido porque Hermes *escreve* no vault além de ler — cada sessão adiciona à camada de contexto.
- Semanas 1–2: setup e calibração. Semana 4: morning brief começa a surpreender. Semana 6: biblioteca de skills com 23 entradas.

## Exemplos e evidências

**Exemplo 1 — Pesquisa vault-aware:** "What narrative themes have been building in my research notes over the last two weeks?" → Hermes abriu o vault, leu 23 arquivos, retornou 3 padrões não nomeados conscientemente pelo autor. Um virou ângulo de artigo na mesma semana.

**Exemplo 2 — Morning brief cross-month:** seção "narrative signals" detecta padrões formando-se em semanas de capturas antes de emergirem no CT (Crypto Twitter).

**Exemplo 3 — Contradição automática:** query sobre posicionamento narrativo no setor RWA → Hermes encontrou 2 contradições entre a tese atual e algo salvo 6 semanas antes, sem instrução explícita.

**Cron template:**
```
/cron "Every weekday at 6am, read my full Obsidian vault.
Produce a morning brief with four sections:
1. Connections: two non-obvious links between recent captures and older notes.
2. Narrative signals: any pattern pointing to something building before CT notices it.
3. Contradiction: any recent capture that conflicts with a belief in my active thesis notes.
4. One action: single highest-leverage thing to focus on today.
Save the brief to 00-Inbox/brief-{{date}}.md"
```

**Backup GitHub cron:**
```
/cron "Every day at midnight, commit and push all files in ~/.hermes/ to my private GitHub repository"
```

## Implicações para o vault

- O vault-michel já opera com lógica similar via Claude Code + hot.md + CLAUDE.md. Hermes + Obsidian é a versão com agente autônomo agendado.
- **SOUL.md ↔ CLAUDE.md**: SOUL.md para camada de agente (Hermes) = CLAUDE.md para Claude Code. O vault já tem o equivalente funcional.
- Morning brief pattern (cron 6am → síntese vault → conexões cross-week) é implementável com agente agendado ou N8N.
- Skill files = conceito já presente no vault como `03-RESOURCES/concepts/agent-systems/agent-skill-graduation`.
- O autor é [[03-RESOURCES/entities/DamiDefi]] que tem artigo anterior sobre JARVIS Obsidian.

## Links

- [[03-RESOURCES/entities/Hermes-Agent]] — entidade do agente
- [[03-RESOURCES/entities/DamiDefi]] — autor
- [[03-RESOURCES/entities/Obsidian]] — PKM target
- [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]] — conceito relacionado
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] — skill files compounding
- [[03-RESOURCES/concepts/pkm-obsidian/scheduled-ingest-routine]] — morning brief pattern
- [[03-RESOURCES/sources/hermes-agent/soulmd-170-line-hermes-operating-contract]] — SOUL.md detalhado
