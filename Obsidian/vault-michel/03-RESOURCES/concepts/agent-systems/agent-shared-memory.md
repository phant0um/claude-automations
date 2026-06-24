---
title: Agent Shared Memory
type: concept
created: 2026-05-31
updated: 2026-05-31
tags: [agent-systems, multi-agent, memory, shared-state]
---

# Agent Shared Memory

Arquitetura em que múltiplos agentes acessam um estado de conhecimento compartilhado em vez de manter skulls (contextos) isolados por agente. Resolve o "knowledge tax" de sistemas multi-agente: fragmentação de contexto que faz agentes especializados operarem com visão parcial do usuário e seu trabalho.

## O problema dos skulls isolados

Cada agente com seu próprio contexto isolado reproduz a principal limitação dos humanos: knowledge em skulls que não sincronizam. Em workflow multi-agente (ex: assistant → builder → writer), o raciocínio que gerou uma decisão não acompanha o artefato para o próximo agente.

Resultado: output contextualmente cego — tecnicamente correto mas sem o contexto que o tornaria realmente útil.

## Camadas de memória compartilhável

1. **User knowledge** — quem é o usuário, projetos, preferências, ritmo de trabalho
2. **Project state** — o que está sendo construído, por que, estado atual
3. **Decision reasoning** — por que determinada abordagem foi escolhida, o que foi rejeitado e por que
4. **Failure memory** — direções exploradas e descartadas; evita re-exploração redundante
5. **Current champion** — melhor solução encontrada até agora (padrão AutoScientists)

## Implementações

**AutoScientists** (Harvard): shared experimental state (proposals, experiments, results, failures, current champion) como núcleo de coordenação entre agents descentralizados. Agents se auto-organizam ao redor do shared state sem orquestrador central.

**Hermes profile** (OpenClaw): profile portátil que encapsula contexto do usuário e pode ser copiado/movido entre agentes e máquinas.

**Vault (atual)**:
- `04-SYSTEM/wiki/hot.md` = compressed shared state (conhecimento recente + contexto operacional)
- `~/.claude/projects/.../memory/` = user knowledge persistido
- Ausência: reasoning log (por que decisões foram tomadas), failure memory sistemática

## Próximos passos no vault

- Criar `04-SYSTEM/wiki/reasoning-log.md` para registrar raciocínio de decisões importantes do Nexus
- Expandir errors.md ou criar arquivo separado para "direções exploradas e descartadas"

## Detalhe do schema gbrain (Compiled Truth + Timeline)

Cada página gbrain divide em duas metades por uma linha `---`: acima fica **Compiled Truth** (estado atual, reescrito quando evidência nova muda a conclusão — seções State/Open Threads/Operating Notes), abaixo fica **Timeline** (append-only, `data | source | o que aconteceu | impacto na conclusão`). Regra central: reescrever o topo só quando a conclusão muda; caso contrário, só anexar à timeline. Memória sensível-a-ação precisa carregar action boundary + expiry + scope. Um "RESOLVER" decide o destino (pessoa/empresa/projeto/conceito/inbox) antes de qualquer escrita, e um "Memory Candidate card" (source, what changed, layer, confidence, expiry) força a pergunta "isso muda comportamento futuro?" antes de promover algo a memória de longo prazo.

## Fontes

- [[03-RESOURCES/sources/stop-giving-agents-own-skull]]
- [[03-RESOURCES/sources/autoscientists-self-organizing-teams]]
- [[03-RESOURCES/sources/gbrain-shared-second-brain-hermes-openclaw]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
