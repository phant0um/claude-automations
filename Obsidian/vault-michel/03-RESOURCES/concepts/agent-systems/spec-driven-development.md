---
title: "Spec-Driven Development (SDD)"
type: concept
status: developing
created: 2026-05-23
updated: 2026-05-23
tags: [concept, ai-agents, sdd, specs, documentation, ai-coding, harness]
---

# Spec-Driven Development (SDD)

**Definição:** Paradigma de desenvolvimento onde a spec (especificação em linguagem natural/pseudocódigo) é o artefato primário — não o código. O agente de coding gera, valida e itera sobre código a partir da spec. Reversa do processo tradicional.

> "The spec is the source of truth. Code is the output, not the artifact."

---

## Por Que SDD Como Default (2026)

**Shift de paradigma:** Antes — humano escreve código, LLM sugere. Agora — LLM escreve código, humano valida spec.

**Evidência:**
- Karpathy (março/2026): "não digitei uma linha de código desde dezembro"
- Garry Tan: 810× produtividade via SDD + AI coding (810× vs 2013, normalizado para logical changes)
- OpenAI/Codex: ~1M LOC, ~1.500 PRs, 3 pessoas em 5 meses — spec-first workflow

**O custo real sem SDD:**
- LLM escreve código sem spec → contexto ambíguo → retrabalho alto
- Revisão humana de código (não de spec) → debugging de saída não de intenção
- Custo de manutenção sem spec: 10-50× custo de construção

---

## Anatomia de uma Spec Eficaz (SDD)

```
spec/[feature-name].md
├── ## Context         — problema e por que existe
├── ## Requirements    — o que deve fazer (linguagem natural + critérios)  
├── ## Constraints     — o que não pode fazer (limites, non-goals)
├── ## Interface       — API pública, CLI, inputs/outputs
├── ## Implementation  — notas de abordagem (opcional — LLM preenche)
└── ## Verification    — como saber se funcionou (cases concretos)
```

**Propriedades de spec boa:**
- **Executável:** seção Verification tem casos concretos que o agente pode rodar
- **Atômica:** uma spec = um componente/feature coerente
- **Estável:** spec não muda enquanto agente executa
- **Rastreável:** código referencia spec (comments ou commits)

---

## SDD Prospectivo vs. Reversa (Retroativo)

| Modo | Quando | Produto |
|------|--------|---------|
| **Prospectivo** | Feature nova | Spec escrita antes do código |
| **Reversa (Reverse Doc Engineering)** | Legacy code sem docs | Spec extraída do código existente |

**Reversa (framework Reversa):** Agente lê código, entende comportamento, gera spec retroativamente. Torna legacy system apto para modificação SDD-first.

---

## SDD no Vault-Michel

O vault implementa SDD de forma implícita:
- **Skills em markdown** = specs de comportamento do agente (40-line skill = spec executável)
- **CLAUDE.md** = spec de todo o sistema (meta-spec)
- **Agents/*.md** = spec de cada agente especializado
- **Concepts + entities** = spec de conhecimento reutilizável

Gap: specs de features técnicas do vault (como pipeline-diario) ainda não usam template SDD explícito.

---

## Relação com Harness Engineering

SDD é a forma de codificar harness engineering como **prática de desenvolvimento**:

```
SDD → spec clara → LLM gera código
Harness Eng → infraestrutura confiável → LLM age com segurança
```

Ambos atacam o mesmo problema pelo outro lado: SDD torna o input preciso; harness torna o ambiente seguro para output.

---

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — SDD como prática de harness engineering
- [[03-RESOURCES/sources/ai-agents-harness/spec-driven-development-ai-coding]] — source principal (SDD como novo default)
- [[03-RESOURCES/sources/ai-agents-harness/reversa-reverse-documentation-engineering]] — SDD retroativo em legacy systems
- [[03-RESOURCES/entities/Garry-Tan]] — gstack/gbrain implementam SDD
- [[04-SYSTEM/skills/]] — skills como specs executáveis no vault
