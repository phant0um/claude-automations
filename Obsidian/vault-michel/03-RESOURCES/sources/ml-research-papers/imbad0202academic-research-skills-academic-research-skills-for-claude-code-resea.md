---
title: "Imbad0202academic-research-skills Academic Research Skills for Claude Code research → write → review → revise → finalize"
type: source
source: Clippings/Imbad0202academic-research-skills Academic Research Skills for Claude Code research → write → review → revise → finalize.md
source_type: clipping
created: 2026-05-19
ingested: 2026-05-19
triagem_score: 7
triagem_cat: skills
tags: [ai-agents, clipping, skills]
---

## Tese central

Suite de skills para pesquisa acadêmica: plan → write → review → revise

## Key insights

- Seção: Academic Research Skills for Claude Code
- Seção: Why human-in-the-loop, not full automation?
- Seção: Architecture & pipeline

## Links

- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-five-layer-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]

## Fonte

Arquivo original: `Clippings/Imbad0202academic-research-skills Academic Research Skills for Claude Code research → write → review → revise → finalize.md`

---

## O Pipeline de Pesquisa Acadêmica com Claude Code

### Problema que a Suite Resolve

Pesquisa acadêmica tem um pipeline específico que difere do desenvolvimento de software: não é code → test → deploy, mas research → write → review → revise → finalize. Cada fase tem critérios diferentes de qualidade e requer ferramentas diferentes. Uma suite genérica de skills não captura essas nuances.

A suite `imbad0202/academic-research-skills` foi construída especificamente para esse pipeline, com skills dedicadas a cada fase.

### Por Que Human-in-the-Loop e Não Full Automation

O artigo original argumenta explicitamente que pesquisa acadêmica não deve ser totalmente automatizada. As razões:

**1. Julgamento epistêmico:** decidir quais fontes são confiáveis, quais argumentos são mais fortes, e qual é a contribuição original exige julgamento que LLMs não têm de forma confiável. O agente pode agregar e sintetizar, mas o pesquisador deve validar a síntese.

**2. Originalidade:** a contribuição intelectual nova deve vir do pesquisador. O agente é um amplificador de capacidade de pesquisa, não o pesquisador. Se o agente gera a tese central, o trabalho não é original.

**3. Responsabilidade acadêmica:** o pesquisador assina o trabalho. Isso implica entender e validar cada claim. Full automation tornaria impossível defender o trabalho com autoridade.

**4. Alucinação de citações:** LLMs hallucinate referências bibliográficas com frequência alta. Sem verificação humana de cada citação, o risco de referências falsas em trabalho acadêmico é inaceitável.

O HITL não é limitação — é um design choice consciente para manter integridade acadêmica.

---

## Arquitetura do Pipeline

### Fase 1 — Plan

O agente ajuda a estruturar a pesquisa antes de começar:
- Decomposição da questão de pesquisa em sub-questões investigáveis
- Identificação de áreas de literatura relevante
- Sugestão de metodologia adequada ao tipo de questão
- Draft do outline do paper

**Output:** `research-plan.md` com questão central, sub-questões, fontes a consultar, e estrutura proposta do paper.

**HITL:** o pesquisador revisa e aprova o plano antes de prosseguir. Ajustes no plano aqui são baratos; ajustes depois de escrever são caros.

### Fase 2 — Research

O agente executa a fase de coleta e síntese de literatura:
- Busca em bases de dados acadêmicas (via MCPs de search)
- Leitura e sumarização de papers relevantes
- Identificação de lacunas na literatura
- Síntese de posições contraditórias

**Output:** `literature-synthesis.md` com posições identificadas, citações verificadas, e lacunas mapeadas.

**HITL:** o pesquisador valida a síntese, adiciona fontes que o agente não encontrou, e sinaliza interpretações incorretas.

### Fase 3 — Write

O agente gera o primeiro draft baseado no plano aprovado e na síntese revisada:
- Introdução com contextualização e tese
- Revisão de literatura organizada tematicamente
- Metodologia descrita
- Resultados/análise
- Discussão e conclusão
- Referências formatadas (verificadas pelo pesquisador)

**Output:** `draft-v1.md`

**HITL:** o pesquisador lê o draft completo. Esta é a fase mais crítica de intervenção — a voz, os argumentos centrais, e a originalidade devem ser do pesquisador.

### Fase 4 — Review

O agente faz review crítico do draft:
- Consistência interna dos argumentos
- Gaps de lógica ou evidência
- Qualidade das citações (são as mais relevantes?)
- Conformidade com as normas do gênero (artigo, dissertação, etc.)
- Clareza e precisão da linguagem técnica

**Output:** `review-comments.md` com issues por seção, classificados por severidade.

**HITL:** o pesquisador decide quais comentários do agente são válidos. O agente pode estar errado sobre o que constitui um bom argumento em um campo específico.

### Fase 5 — Revise

O agente implementa as revisões aprovadas pelo pesquisador:
- Incorporação dos comentários aceitos
- Reescrita de seções problemáticas
- Ajuste de fluxo e coerência
- Atualização de referências se necessário

**Output:** `draft-v2.md` (e versões subsequentes)

Este ciclo review → revise pode repetir múltiplas vezes até o pesquisador estar satisfeito.

### Fase 6 — Finalize

Preparação do documento final:
- Formatação segundo as normas da conferência/journal alvo
- Verificação final de referências
- Spell check e grammar check
- Geração de versão em formato requerido (PDF, LaTeX, DOCX)
- Checklist de submissão

---

## Comparação com Abordagens Alternativas

| Abordagem | Produtividade | Integridade Acadêmica | Qualidade |
|---|---|---|---|
| Manual (sem IA) | Baixa | Alta | Variável |
| Full automation | Alta | Baixa (risco alto) | Inconsistente |
| Pipeline HITL | Média-Alta | Alta | Alta |
| Chat ad-hoc com LLM | Média | Média (depende do usuário) | Variável |

O pipeline HITL oferece o melhor tradeoff para pesquisa acadêmica séria.

---

## Implementação Prática no Claude Code

A suite usa skills definidas em arquivos `.md` no `.claude/commands/`:
- `research-plan.md` — instancia a fase de planejamento
- `literature-search.md` — orienta a busca de literatura
- `draft-writer.md` — instrui o modo de escrita
- `academic-review.md` — configura o reviewer crítico
- `finalize.md` — prepara a versão final

Cada skill é uma instrução detalhada de como operar em cada fase, com explicitação do que é output esperado e onde o HITL deve acontecer.

---

## Relevância para o Vault-Michel

O padrão de pipeline com HITL em pontos estratégicos (não em cada ação) é exatamente o modelo adotado neste vault: autonomia total para operações de baixo risco, confirmação humana em pontos de alto impacto. A aplicação acadêmica é uma especialização do princípio geral.

Para FIAP (ADS), este pipeline é diretamente aplicável a trabalhos de conclusão de fase, artigos científicos de disciplinas de pesquisa, e qualquer entregável que requeira revisão bibliográfica estruturada.

---

## Limitações

- O pipeline assume acesso a bases de dados acadêmicas via MCP — sem integração com Scopus, Web of Science, ou arXiv, a fase de research fica limitada a fontes abertas
- Alucinação de citações permanece risco mesmo com HITL — a verificação manual de cada referência ainda é necessária
- O pipeline é lento por design — não é adequado para pesquisa exploratória rápida ou brainstorming inicial
- Skills do repo imbad0202 são de terceiro e qualidade varia — auditar antes de usar em trabalho acadêmico sério
