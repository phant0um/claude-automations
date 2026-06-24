---
title: "From Skills to Talent: Organising Heterogeneous Agents as a Real-World Company"
type: source
source_type: paper
author: "Zhengxu Yu et al. (HK/UCL)"
created: 2026-05-06
tags: [multi-agent, organization, talent-market, coordination]
triagem_score: 8
---

OneManCompany (OMC): organizational-level framework for multi-agent systems. Portable agent identities (Talents), Talent Market for on-demand recruitment, E2R tree search for planning/execution/review. 84.67% on PRDBench (+15.48pp SOTA). arXiv:2604.22446v1.

## Source

Ingested from: `clippings/From Skills to Talent Organising Heterogeneous Agents as a Real-World Company.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Framework OneManCompany (OMC)

O insight central do OMC é que sistemas multi-agentes falham não por falta de capacidade individual dos agentes, mas por falta de estrutura organizacional. Assim como uma empresa real tem divisões, hierarquias, mercados de trabalho interno, e processos de revisão, um sistema multi-agente precisa das mesmas abstrações para coordenar agentes heterogêneos em tarefas complexas.

### Talents: Identidades Portáveis de Agente

Um **Talent** é mais do que um prompt especializado — é uma identidade portável que encapsula:
- Domínio de especialização (ex: "Python backend", "segurança de código", "documentação técnica")
- Histórico de performance (quais tarefas executou bem, quais falharam)
- Preferências declaradas (como quer receber tarefas, formatos preferidos de output)
- Credenciais (quais ferramentas tem acesso, quais permissões)

A portabilidade é a propriedade-chave: o mesmo Talent pode ser recrutado para diferentes projetos sem re-configuração. Isso contrasta com agentes tradicionais que são hardcoded para um único fluxo.

### Talent Market: Recrutamento On-Demand

O Talent Market é um mecanismo de matching entre demanda de tarefa e oferta de competência:

```
Tarefa chega com requisitos (skill_X, skill_Y)
  → Talent Market consulta pool de Talents disponíveis
  → Matching por competência + disponibilidade + histórico
  → Talent selecionado é alocado para a tarefa
  → Após conclusão, Talent retorna ao pool com registro de performance atualizado
```

Este modelo resolve um problema clássico de sistemas multi-agentes: como distribuir dinamicamente trabalho entre agentes especializados sem hardcodar dependências entre eles. Um Talent que falha em tarefas de tipo X pode ser gradualmente depriorizado pelo market sem intervenção manual.

### E2R Tree Search: Explore, Execute, Review

O planejamento no OMC usa uma estrutura de árvore com três fases:

**Explore**: dado o objetivo, o orquestrador gera hipóteses de decomposição em sub-tarefas. Múltiplas decomposições são geradas e avaliadas antes de comprometer com uma.

**Execute**: a decomposição escolhida é atribuída aos Talents apropriados via Talent Market. Cada Talent executa sua sub-tarefa com ferramentas e contexto específicos.

**Review**: outputs são avaliados por um Talent de revisão (ou pelo próprio orquestrador). Se qualidade insuficiente, a sub-tarefa é reenviada (com feedback) ou uma decomposição alternativa é tentada.

O E2R é análogo ao MCTS (Monte Carlo Tree Search) mas aplicado a decomposição de tarefas de software, não a jogos.

## Resultados em PRDBench

PRDBench (Product Requirements to Development Benchmark) é um benchmark que avalia sistemas multi-agentes na capacidade de converter requisitos de produto em código funcional — um proxy para o fluxo real de desenvolvimento de software.

- **OMC**: 84.67%
- **Estado da arte anterior**: 69.19% (+15.48pp de melhoria)
- **Fator principal de ganho**: o Talent Market permitiu especialização dinâmica sem perda de cobertura — tarefas que antes ficavam com agentes generalistas passaram para especialistas quando disponíveis

## Comparação com Outros Frameworks Multi-Agentes

| Framework | Estrutura | Especialização | Recrutamento | Revisão |
|---|---|---|---|---|
| **AutoGen** | graph de conversa | por role fixo | estático | não estruturado |
| **MetaGPT** | roles SOP | fixo por workflow | estático | sim (QA role) |
| **CrewAI** | crews fixas | por role declarado | estático | limitado |
| **OMC/OneManCompany** | Talent Market | dinâmica por demanda | on-demand | E2R formal |

A diferença-chave do OMC: especialização e recrutamento são dinâmicos, não declarados estaticamente no design do sistema.

## Limitações

- O Talent Market requer um modelo de embedding ou outro mecanismo de matching — adiciona latência e custo de infraestrutura
- O histórico de performance de Talents precisa de um critério de avaliação claro — métricas mal definidas fazem o market recrutar errado
- O E2R pode entrar em loops se o critério de revisão nunca é satisfeito — precisa de limite de tentativas com fallback
- O paper usa PRDBench como proxy — não há validação em tarefas de produção real com usuários

## Relevância para o Vault

O modelo Talent Market é próximo à estrutura de agentes especializados do vault-michel: Nexus como orquestrador, agentes especializados (guard, hill, review, spec, extend) como Talents com domínios declarados. A diferença é que o vault usa alocação manual (usuário chama o agente certo) enquanto o OMC propõe alocação automática por matching.

## Relações

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — arquitetura central
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]] — mecanismo de alocação
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]] — OMC usa hierarquia E2R
- [[03-RESOURCES/sources/ai-agents-harness/clipping-four-subagent-patterns-2026]] — padrões complementares de subagente
