---
title: "Latent Agents: A Post-Training Procedure for Internalized Multi-Agent Debate"
type: source
source_type: paper
author: "John Seon Keun Yi et al. (Boston U)"
created: 2026-05-06
tags: [multi-agent, distillation, debate, mechanistic]
triagem_score: 9
---

IMAD: distills multi-agent debate into single LLM via two-stage fine-tuning. Matches/exceeds explicit debate with up to 93% fewer tokens. Creates agent-specific activation subspaces. Malicious agent traits can be suppressed via negative steering. arXiv:2604.24881v1.

## Source

Ingested from: `clippings/Latent Agents A Post-Training Procedure for Internalized Multi-Agent Debate.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Problema: Multi-Agent Debate é Caro

Multi-agent debate (MAD) é um padrão bem estabelecido para melhorar raciocínio de LLMs: múltiplos agentes geram respostas independentes, debatem, e convergem para uma resposta mais confiável do que qualquer agente sozinho produziria. O problema é o custo: para N agentes e R rodadas de debate, o custo de inferência cresce como O(N × R). Em produção, isso se torna proibitivo rapidamente.

**IMAD** (Internalized Multi-Agent Debate) resolve isso com uma pergunta diferente: e se um único LLM pudesse simular todo o debate internamente, sem gerar múltiplas completions?

## Mecanismo: Two-Stage Fine-Tuning

### Estágio 1 — Coleta de Trajetórias de Debate

Um sistema MAD real é executado em lote sobre um conjunto de problemas de treino. Cada debate gera uma trajetória: sequência de argumentos, contra-argumentos, e resposta final. Essas trajetórias são armazenadas como dados de supervisão.

Crucialmente, as trajetórias incluem não apenas os debates que convergiram para a resposta correta, mas também debates onde agentes discordaram e um agente minoritário estava certo. Isso captura o valor real do debate: a capacidade de detectar quando a maioria está errada.

### Estágio 2 — Fine-Tuning com Identidades Latentes

O LLM base é fine-tuned nas trajetórias de debate com um mecanismo especial: tokens de identidade de agente são inseridos no contexto para separar as "vozes" dentro do modelo. O modelo aprende que quando o token `[AGENT_A]` está ativo, deve simular o ponto de vista do Agente A; quando `[AGENT_B]` está ativo, deve simular o Agente B.

Após o fine-tuning, o modelo pode simular um debate completo usando uma única passagem forward, alternando entre identidades de agente via tokens de controle.

## Espaços de Ativação por Agente

Um achado mecanístico notável: o fine-tuning cria **subspaces de ativação** separados para cada identidade de agente. Análise de representação interna mostra que:
- As ativações das camadas médias divergem significativamente dependendo do token de identidade ativo
- Cada agente tem um "perfil de ativação" consistente que persiste ao longo da geração
- Os subspaces são suficientemente separados para permitir steering por interpolação

Isso indica que o modelo não está simplesmente memorizando respostas por identidade — está internalizando perspectivas distintas que se expressam em representações diferentes.

## Supressão de Agentes Maliciosos

O aspecto mais relevante para segurança: se um agente debatedor for treinado com trajetórias maliciosas (ex: um agente que sistematicamente defende ações não-éticas), suas ativações específicas podem ser identificadas e suprimidas via **negative activation steering** sem afetar os outros agentes.

Isso contrasta com o problema clássico de fine-tuning adversarial: remover comportamento ruim de um modelo monolítico frequentemente degrada outras capacidades. No IMAD, os subspaces separados permitem remoção cirúrgica de um agente específico.

## Resultados Empíricos

- **Qualidade de resposta**: IMAD iguala ou supera MAD explícito em benchmarks de raciocínio (MATH, BBH, ARC)
- **Redução de tokens**: até 93% menos tokens de inferência comparado ao MAD real (N=4 agentes, R=3 rodadas)
- **Latência**: redução proporcional à economia de tokens — debates que levavam segundos agora levam milissegundos
- **Robustez**: o modelo IMAD é mais estável que o ensemble MAD em inputs fora de distribuição (o debate interno é mais controlado do que o debate entre modelos separados)

## Comparação de Abordagens de Debate

| Abordagem | Custo | Qualidade | Controllability |
|---|---|---|---|
| **Single LLM** | 1× | baseline | alta |
| **MAD explícito** (N=4, R=3) | ~12× | +15-20% | baixa (multi-model) |
| **IMAD** | ~1.2× | +12-18% | alta (subspace steering) |
| **Self-consistency** | N× (paralelo) | +5-10% | média |

## Limitações

- Requer dataset de debates de alta qualidade para o fine-tuning — coletar trajetórias MAD tem custo inicial
- O número de identidades de agente que um único modelo pode internalizar tem um limite empírico (o paper testa até 4)
- Debates que requerem agentes com conhecimento de domínio radicalmente diferente podem não ser bem internalizados por um modelo único
- O mecanismo de steering de subspace requer acesso às ativações internas — não aplicável a APIs sem acesso a logits

## Relevância para o Vault

IMAD representa uma direção importante: a fronteira entre "um modelo" e "múltiplos agentes" está se tornando porosa. Para o vault-michel, isso tem implicações práticas: tarefas que hoje requerem multi-agent debate (ex: revisão de raciocínio por um segundo agente) podem eventualmente ser feitas por um modelo IMAD com custo próximo a um único modelo. Isso muda o cálculo de quando usar subagentes vs um único agente com raciocínio mais rico.

## Relações

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — MAD é um padrão de orquestração
- [[03-RESOURCES/concepts/mechanistic-interpretability]] — análise de subspaces de ativação
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-rational-agency-gap]] — relacionado (capacidades vs limitações de LLMs)
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — fine-tuning como melhoria pós-treino
