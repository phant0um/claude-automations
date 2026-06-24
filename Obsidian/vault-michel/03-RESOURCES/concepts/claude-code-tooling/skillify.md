---
title: Skillify
type: concept
status: developing
tags: [agent-systems, agent-reliability, skills, testing, deterministic-code, gbrain]
created: 2026-04-24
updated: 2026-04-24
---

# Skillify

**Skillify** é uma prática de engenharia de agentes criada por [[03-RESOURCES/entities/Garry-Tan]] que converte cada falha de agente em uma **skill permanente com testes automatizados**, tornando estruturalmente impossível a repetição do erro.

> "Every failure becomes a skill. Every skill has evals. Every eval runs daily."

---

## Problema que resolve

A "confiabilidade" padrão de agentes é baseada em:
- Ajustes de prompt que decaem
- System prompts maiores com "please don't hallucinate"
- O agente pedindo desculpa e prometendo melhorar

Resultado: a mesma falha reaparece duas semanas depois com query ou contexto diferente. O agente não tem memória do bug, nenhum teste para o bug, nada que impeça a recorrência.

---

## Distinção central: Latent vs Deterministic

| Espaço | Definição | Quando usar |
|--------|-----------|-------------|
| **Latent** | Requer julgamento; output varia por contexto | Síntese, decisão, escrita criativa |
| **Deterministic** | Mesma entrada → mesma saída; zero LLM necessário | Grep, timestamp math, API lookup com schema fixo |

**O bug mais comum:** trabalho determinístico sendo feito em espaço latente (mental math de timezone quando um script já tem a resposta; API ao vivo quando local knowledge base tem o dado).

> O espaço latente constrói a ferramenta determinística. A ferramenta determinística constrainge o espaço latente. O erro se torna estruturalmente inalcançável.

---

## Checklist de 10 passos

```
□ 1.  SKILL.md           — contrato: name, triggers, regras hard
□ 2.  Código determinístico — scripts/*.mjs (sem LLM para o que código faz)
□ 3.  Unit tests          — vitest; funções puras com fixtures
□ 4.  Integration tests   — dados reais (não apenas fixtures limpas)
□ 5.  LLM evals           — qualidade + processo correto (não apenas resultado)
□ 6.  Resolver trigger    — entrada em AGENTS.md
□ 7.  Resolver eval       — verifica que o trigger roteia corretamente
□ 8.  Check-resolvable + DRY audit — detecta skills "dark" e duplicatas
□ 9.  E2E smoke test      — pipeline completo end-to-end
□ 10. Brain filing rules  — onde o output vai no knowledge base
```

Uma feature que não passa pelos 10 = código que funciona hoje, não uma skill.

---

## Skillify como verbo

Garry usa "skillify" como comando verbal para seu agente após prototipar em conversa:

```
"hot damn it worked. skillify it"
"make a skill that says whenever you send me a link you have to curl it first. skillify it!"
```

O agente produz SKILL.md + deterministic scripts + testes + resolver entry em uma mensagem. A sessão ad-hoc vira infraestrutura permanente.

---

## Failure modes sem Skillify

- **Drift de API:** skill funciona perfeitamente quando criada; 6 semanas depois a API muda shape; skill retorna lixo silenciosamente
- **Duplicate skills:** agente cria `deploy-k8s` segunda; cria `kubernetes-deploy` quinta de outra conversa. Ambos existem, ambos disparam em frases similares. Routing ambíguo.
- **Dark skills:** skill criada mas sem trigger em AGENTS.md. Consome tokens do índice, nunca roda. Garry encontrou 6/40 skills nesta situação (15% das capacidades).

---

## Ferramentas de suporte

- **GBrain** (`gbrain doctor`, `gbrain doctor --fix`): enforça o checklist de 10 passos; detecta DRY violations; auto-repara com git working-tree checks. [[03-RESOURCES/entities/Garry-Tan]] é o autor.
- **Hermes Agent** (Nous Research): cria/patcha skills autonomamente (`skill_manage`), mas não testa. Skillify + GBrain = a camada de verificação que Hermes não tem.
- **check-resolvable:** meta-teste que percorre AGENTS.md → SKILL.md → script, detectando skills inalcançáveis.

---

## Relação com o vault

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — padrão SKILL.md da Anthropic; Skillify é a disciplina de qualidade (testes + resolver evals) que o padrão oficial não prescreve
- [[03-RESOURCES/concepts/agent-systems/resolver-pattern]] — steps 6 e 7 do checklist; trigger tables em AGENTS.md
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] — Step 5 (LLM evals diários) usa LLM-as-judge
- [[03-RESOURCES/concepts/agent-systems/autonomous-learning]] — Skillify é a versão human-in-the-loop de self-improvement de agentes
- [[03-RESOURCES/sources/guides-courses-howtos/how-to-stop-agents-making-same-mistakes-garry-tan]] — fonte primária
