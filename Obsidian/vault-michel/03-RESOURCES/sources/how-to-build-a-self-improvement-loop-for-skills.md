---
title: How to build a self-improvement loop for your Skills
type: source
source: "Clippings/How to build a self-improvement loop for your Skills.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Um agente pode melhorar a qualidade das próprias Skills ao longo do tempo a partir de feedback externo, usando uma arquitetura de dois loops — um loop interno que aplica a Skill e registra interações, e um loop externo que roda em schedule, observa o uso do loop interno e ajusta a Skill (via diff em arquivo) com base na performance observada.

## Argumentos principais
- Define "loop" de forma concreta e prática usando Skills + cloud agents, contrapondo ao debate vago sobre "o que realmente é um loop".
- Exemplo de aplicação: uma Skill de triagem de issues (buckets: ready-to-implement, duplicate, needs-info) — mesmo padrão funcionaria para code review, bug fixing, incident response, etc.
- **Loop interno (inner agent loop):** onde a Skill é de fato aplicada — manualmente ou, mais comumente, via integração com o task tracker que dispara a Skill a cada issue nova. Interações são registradas em arquivo, trace de agente, ou sistema externo (Slack, GitHub).
- **Loop externo (outer agent loop):** agente que roda em schedule e observa o uso do loop interno. Para o exemplo, é um cloud agent que roda diariamente, lê os registros de toda execução do agente de triagem, e ajusta a Skill com base na performance — como Skills são apenas arquivos, isso significa literalmente gerar um diff que melhora a Skill.
- Funciona tanto com feedback humano (como no exemplo) quanto com um grader automatizado, se houver um objetivo claro que não precise de humano.
- Implementação concreta usando GitHub Actions (loop interno, disparado a cada issue nova) e Warp/Oz como plataforma de cloud agent que sincroniza o repo, lê o conteúdo da issue via GitHub e classifica.

## Key insights
- O loop externo só "aprende" porque o humano corrige a label e explica o motivo da correção no comentário — esse texto de justificativa é o sinal que o loop externo usa para gerar o diff de melhoria da Skill.
- Uma vez que o diff do loop externo é mergeado, ele realimenta a Skill que dirige o loop interno — a próxima execução já deveria funcionar melhor; é compounding de feedback codificado em arquivo, não em memória de conversa.
- A empresa (Warp) usa esse mesmo padrão de self-improvement loop para gerenciar seu próprio repositório open-source, e extraiu o framework para outros adotarem.

## Exemplos e evidências
- Repositório de exemplo completo (`warpdotdev-demos/issue-triage-loop`) com a Skill de triagem (`triage-issue/SKILL.md`), a GitHub Action (`triage-new-issues.yml`) e a Skill de melhoria (`improve-triage-skill/SKILL.md`).
- Versão inicial extraída para uso geral: `github.com/warpdotdev/oz-for-oss`.
- Caso ilustrado passo a passo: issue mal classificada como "ready to implement" é reclassificada manualmente para "needs info" com comentário explicando ambiguidade sobre adicionar uma configuração — esse texto vira insumo do loop externo no dia seguinte.

## Implicações para o vault
Este é o padrão F2.9-equivalente em escala de produto: o pipeline de triagem A/B deste próprio vault (com log de aprovação/rejeição em `04-SYSTEM/wiki/errors.md` e logs de ingest) é estruturalmente o mesmo loop interno/externo descrito aqui. Reforça a ideia de que correções no workflow devem ser logadas e usadas para ajustar prompts/Skills do sistema (`extend`, `hill`) — não apenas memorizadas informalmente.

## Links
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-systems]]
- [[03-RESOURCES/concepts/agent-systems/skill-authoring]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/entities/Warp]]
