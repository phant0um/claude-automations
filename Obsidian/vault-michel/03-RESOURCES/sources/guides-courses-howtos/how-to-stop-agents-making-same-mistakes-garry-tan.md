---
title: "How to Really Stop Your Agents from Making the Same Mistakes"
type: source
author: Garry Tan (@garrytan)
source_url: https://x.com/garrytan
created: 2026-04-24
tags: [agent-systems, skillify, gbrain, openclaw, hermes-agent, thin-harness-fat-skills, agent-reliability, evals, deterministic-code]
updated: 2026-05-02
triagem_score: 9
---

# How to Really Stop Your Agents from Making the Same Mistakes

**Autor:** [[03-RESOURCES/entities/Garry-Tan]] (@garrytan)  
**Contexto:** Artigo descrevendo a prática "Skillify" como solução permanente para falhas recorrentes em agentes IA.

---

## Tese central

Frameworks como LangChain (captura $160M, LangSmith) entregam ferramentas de teste mas **não entregam o workflow**. Sem um processo opinionado de como converter falhas em estrutura permanente, a "confiabilidade" de agentes é baseada em vibes — ajustes de prompt que decaem.

A solução de Garry: **Skillify** — transformar cada falha em uma skill com testes que rodam diariamente, para sempre.

---

## As duas falhas concretas

### Falha 1: "A viagem que já estava no banco"
- Agente consultou API de calendário ao vivo → bloqueada (evento de 10 anos atrás)
- Tentou busca por email → resultados ruidosos
- Repetiu API com params diferentes → ainda bloqueada
- 5 minutos depois: encontrou no knowledge base local com grep instantâneo
- **Root cause:** trabalho **determinístico** (grep em 3.146 arquivos locais) foi executado em espaço latente
- **Fix:** skill `calendar-recall` com regra "Live API ONLY para eventos futuros ou últimas 48h; histórico vai ao knowledge base local primeiro"

### Falha 2: "28 minutos"
- Agente disse "sua próxima reunião em 28 minutos"; realidade: 88 minutos
- Fez conversão UTC→PT na cabeça, errou 1 hora (horário de verão)
- Já existia `context-now.mjs` com o dado correto — o agente simplesmente não rodou
- **Fix:** skill `context-now` com regra "ALWAYS-ON: rodar context-now.mjs antes de qualquer afirmação sensível a tempo"

---

## O padrão central: Latent vs Deterministic

| Tipo | Definição | Quando usar |
|------|-----------|-------------|
| **Latent** | Requer julgamento; output varia | Síntese, decisão, escrita |
| **Deterministic** | Mesma entrada → mesma saída; nenhum modelo necessário | Grep, timestamp math, API lookup |

> **Bug real:** não é uma resposta errada — é o trabalho no lado errado da linha.  
> O espaço latente constrói a ferramenta determinística; a ferramenta determinística constrainge o espaço latente.

---

## Skillify como checklist de 10 passos

```
□ 1.  SKILL.md           — o contrato (name, triggers, rules)
□ 2.  Código determinístico — scripts/*.mjs (sem LLM para o que código faz)
□ 3.  Unit tests          — vitest
□ 4.  Integration tests   — endpoints reais
□ 5.  LLM evals           — qualidade + corretude
□ 6.  Resolver trigger    — entrada em AGENTS.md
□ 7.  Resolver eval       — verificar que o trigger realmente roteia
□ 8.  Check-resolvable + DRY audit
□ 9.  E2E smoke test
□ 10. Brain filing rules
```

Uma feature que não passa pelos 10 itens **não é uma skill**. É código que funciona hoje.

---

## Skillify como verbo (uso diário)

Garry usa "skillify" como comando natural na conversa com seu agente:

> "hot damn it worked. can you remember this as a webhook skill and skillify it?"

O agente lê o comando, produz SKILL.md + scripts + testes + resolver entry. O conhecimento ganho numa sessão de 1 hora se torna infraestrutura permanente.

---

## Passos em detalhe

**Step 3 (Unit tests):** vitest; funções puras com fixture data; 179 testes em 5 suites, <2s.

**Step 4 (Integration tests):** dados reais, não fixtures; calendários com Windows line endings, eventos que cruzam meia-noite.

**Step 5 (LLM evals):** LLM-as-judge; 35 evals diários; avalia **processo** (o agente rodou o script?) além do resultado correto. Heurística: busque histórico onde você disse "fucking shit" — esses são os test cases faltantes.

**Step 6 (Resolver trigger):** entrada em AGENTS.md (tabela markdown). Skill sem trigger = cirurgião sem cadastro no hospital.

**Step 7 (Resolver eval):** 50+ test cases `{ intent, expectedSkill }`; testa falso negativo E falso positivo (dois triggers que se sobrepõem).

**Step 8 (check-resolvable + DRY audit):** primeira rodada encontrou **6 skills inalcançáveis em 40** (15% das capacidades eram "dark"). Agora roda semanalmente via `gbrain doctor`.

**Step 9 (E2E smoke test):** última linha de defesa — tudo pode passar e o agente ainda ignorar tudo e improvisar.

**Step 10 (Brain filing rules):** 10/13 skills de escrita estavam arquivando no diretório errado; doc de regras de filing eliminou misfilings.

---

## GBrain e Hermes Agent

- **[[03-RESOURCES/entities/GBrain]]** (open source): gerencia brain repo, roda evals, enforça quality gates. `gbrain doctor --fix` auto-repara DRY violations. Skillify checklist = o que `gbrain doctor` verifica.
- **[[03-RESOURCES/entities/Hermes-Agent]]** (Nous Research): `skill_manage` tool — agente cria/patcha/deleta skills autonomamente. Progressive disclosure, bounded memory (MEMORY.md ≤ 2.200 chars). Problema: **não testa suas skills**. GBrain = verificação; Hermes = criação. Você precisa dos dois.

---

## Analogia com Software Engineering

> "Em um time saudável, cada bug ganha um teste. Esse teste vive para sempre. O bug se torna estruturalmente impossível de recorrer. Agentes de IA deveriam funcionar da mesma forma."

---

## Conexão com o vault

- [[03-RESOURCES/concepts/claude-code-tooling/skillify]] — conceito central extraído deste artigo
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — padrão SKILL.md análogo (Anthropic); Skillify é a camada de qualidade ausente nele
- [[03-RESOURCES/concepts/agent-systems/resolver-pattern]] — steps 6 e 7 dependem diretamente de resolvers
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] — evals diários; LLM-as-judge em Step 5
- [[03-RESOURCES/entities/Garry-Tan]] — autor; GBrain, GStack, OpenClaw
- [[03-RESOURCES/entities/OpenClaw]] — harness onde Skillify foi desenvolvido
