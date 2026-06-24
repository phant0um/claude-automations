---
title: "WebXSkill: Skill Learning for Autonomous Web Agents"
type: source
created: 2026-04-19
tags: [web-agents, skill-learning, llm, benchmark, microsoft, unc]
source_file: .raw/articles/WebXSkill Skill Learning for Autonomous Web Agents.md
arxiv: https://arxiv.org/abs/2604.13318
repo: https://github.com/aiming-lab/WebXSkill
authors:
  - Zhaoyang Wang (UNC Chapel Hill)
  - Qianhui Wu (Microsoft)
  - Xuchao Zhang (Microsoft)
  - Chaoyun Zhang (Microsoft)
  - Huaxiu Yao (UNC Chapel Hill)
  - Jianfeng Gao (Microsoft)
triagem_score: 9
---

# WebXSkill: Skill Learning for Autonomous Web Agents

**Autores:** Zhaoyang Wang et al. — UNC Chapel Hill + Microsoft  
**Repo:** [github.com/aiming-lab/WebXSkill](https://github.com/aiming-lab/WebXSkill)

## Problema

Agentes web baseados em LLMs sofrem com long-horizon workflows por não reutilizarem conhecimento procedimental entre execuções. Toda vez que encontram um padrão recorrente (checkout flow, formulário de busca, navegação de menu), re-derivam a sequência do zero — desperdiçando steps e aumentando risco de erros.

O gap central é o **grounding gap**: skills textuais guiam mas não executam; skills em código executam mas são opacas (black-box) — o agente não consegue se adaptar quando a execução falha.

## Solução: Executable Skills

WebXSkill introduz **executable skills** que combinam:
1. **Action program** — sequência parametrizada de ações de browser (click, type, navigate)
2. **Step-level natural language guidance** — anotação semântica de cada passo

Isso permite dois modos de deployment:
- **Grounded mode** — skill chamada como tool; runtime executa automaticamente a sequência
- **Guided mode** — skill fornece instruções passo-a-passo; agente executa com suas próprias ações nativas

## Framework: 3 Estágios

### 1. Skill Extraction
- **Input:** corpus de trajetórias sintéticas de agentes (2.500 tasks no WebArena; 600 no WebVoyager)
- **Processo:** LLM identifica subsequências reutilizáveis, abstrai valores concretos em parâmetros tipados (ex: `query: str`), anota cada ação com guidance
- **Curation:** deduplicação 3 níveis (exact name → Jaccard similarity → embedding similarity com `text-embedding-3-small`); validação no ambiente de teste para filtrar skills com erros de browser

### 2. Skill Organization — Skill Graph
- Organiza skills num grafo `G = {(url_pattern, skills)}`
- Nós são URL patterns generalizados (ex: `shopping/catalogsearch/*`)
- Retrieval context-aware: match pelo URL atual → filtra por presença de elementos no DOM → até 20 skills surfaced por página
- Vantagem sobre flat libraries: menos ruído, retrieval mais preciso

### 3. Skill Deployment
- **Grounded mode:** skills registradas como tools (`fg_*`) no action space; guidance visível como planning aid; execução automática multi-step
- **Guided mode:** injeta `<available_skills>` e `<activated_skill_guidance>` no prompt; agente age passo a passo podendo adaptar quando o estado muda
- Regra prática: **stronger models → grounded; weaker models → guided**

## Resultados

### WebArena (154 tasks, 5 sites: Shopping, CMS, Reddit, GitLab, Map)

| Model | Vanilla | WebXSkill (Grounded) | WebXSkill (Guided) | Melhoria |
|-------|---------|----------------------|--------------------|----------|
| GPT-5 | 59.7% | **69.5%** | 68.8% | +9.8pp |
| Qwen-3.5-122B | 45.5% | 48.7% | **53.9%** | +8.4pp |

### WebVoyager (11 sites reais, GPT-5)

| Method | Overall |
|--------|---------|
| Vanilla | 71.9% |
| Vanilla + MAP | 74.4% |
| **WebXSkill (Grounded)** | **86.1%** |
| WebXSkill (Guided) | 82.7% |
| WebXSkill (Guided + WA transfer) | 85.1% |

**Melhoria sobre baseline: +14.2pp (grounded) / +8.3pp (guided)**

## Análise de Componentes (Ablation)

| Componente removido | Drop de accuracy |
|--------------------|-----------------|
| Skill validation | -14.3pp (mais crítico) |
| Skill graph → flat retrieval | -10.4pp |
| Step-level guidance | -9.1pp |

## Design vs. Competidores

| Método | Executável | Guidance | Aquisição | Context-aware |
|--------|-----------|---------|-----------|---------------|
| AWM | ✗ | ✓ | Test | ✗ |
| SkillWeaver | ✓ | ✗ | Exploração | ✗ |
| ASI | ✓ | ✗ | Test | ✗ |
| WALT | ✓ | ✗ | Exploração | ✗ |
| **WebXSkill** | **✓** | **✓** | **Trajetórias sintéticas** | **✓** |

## Falhas mais comuns (Grounded mode, GPT-5)
1. Wrong answer extraction (agente completa o workflow mas reporta resultado errado)
2. No skill invoked (36%) — agente ignorou skills disponíveis
3. Post-skill reasoning failure (38%) — skill executou OK mas agente falhou nos steps seguintes
4. Wrong skill selected (13%)
5. Skill execution broken (9%)

## O Skill Graph como avanço arquitetural

A inovação mais sub-notada do WebXSkill é o Skill Graph, não as executable skills em si. Flat skill libraries têm um problema de retrieval que piora com escala: com 50+ skills, a similaridade de embedding frequentemente retorna múltiplas skills parcialmente relevantes, forçando o agente a inferir qual usar — com custo de raciocínio e risco de seleção errada.

O Skill Graph resolve isso com indexação contextual: skills são armazenadas por URL pattern, não em pool flat. Quando o agente está em `shopping/cart/*`, o espaço de busca já foi reduzido a skills relevantes para páginas de carrinho. O ablation confirma isso: trocar Skill Graph por flat retrieval custa 10.4pp — mais do que remover step-level guidance (9.1pp).

A implicação para o vault-michel é que organizar skills em `04-SYSTEM/agents/` por domínio (não em lista plana) não é apenas organização visual — é uma estratégia de retrieval. Agents que têm um `04-SYSTEM/agents/finance/` separado de `04-SYSTEM/agents/fiap/` podem ser invocados com contexto de routing mais preciso.

## Grounded vs Guided: a regra prática

A regra "stronger models → grounded; weaker models → guided" tem uma implicação econômica clara: grounded mode é mais eficiente (menos steps, menos tokens) mas requer que o modelo seja capaz de executar a sequência sem desviar. Guided mode tem overhead de steps mas o agente pode adaptar quando o estado da página muda inesperadamente.

Em produção real, sites mudam: botões são renomeados, formulários ganham campos, modais aparecem. Grounded mode quebra silenciosamente nesses casos — o action program executa mas em um estado diferente do esperado. Guided mode, ao fornecer guidance semântico por step, permite que o agente adapte a ação concreta mantendo a intenção.

Para workflows críticos (pagamentos, submissão de dados) onde quebra silenciosa é inaceitável, guided mode é o padrão mais defensivo mesmo com modelos fortes.

## Conexões no vault

- [[03-RESOURCES/concepts/agent-systems/web-agent-skill-learning]] — conceito central deste paper
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — arquitetura de agentes
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — skills como memória procedimental
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — análogo em Claude Code (SKILL.md)
- [[03-RESOURCES/entities/WebArena]] — benchmark principal
- [[03-RESOURCES/entities/WebVoyager]] — benchmark secundário
- [[03-RESOURCES/entities/SkillWeaver]] — método competidor
- [[03-RESOURCES/entities/WALT]] — método competidor
