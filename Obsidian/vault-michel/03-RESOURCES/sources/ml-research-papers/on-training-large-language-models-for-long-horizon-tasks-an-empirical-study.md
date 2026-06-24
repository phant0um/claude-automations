---
title: "On Training Large Language Models for Long-Horizon Tasks An Empirical Study of Horizon Length"
type: source
source_type: clipping
source_path: clippings/On Training Large Language Models for Long-Horizon Tasks An Empirical Study of Horizon Length.md
created: 2026-05-09
ingested: 2026-05-09
tags: [articles, clipping]
triagem_score: 8
---

## Resumo

Sunghwan Kim    Junhee Cho    Beong-woo Kwak    Taeyoon Kwon    Liang Wang    Nan Yang    Xingxing Zhang    Furu Wei    Jinyoung Yeo

###### Abstract

Large language models (LLMs) have shown promise as interactive agents that solve tasks through extended sequences of environment interactions. While prior work has primarily focused on system-level optimizations or algorithmic improvements, the role of task horizon length in shaping training dynamics remains poorly understood. In this work, we present a systematic empirical study that examines horizon length throu

## Origem

- Path: `clippings/On Training Large Language Models for Long-Horizon Tasks An Empirical Study of Horizon Length.md`
- Categoria: articles
- Ingerido: 2026-05-09

## Cross-links

- [[03-RESOURCES/concepts/long-horizon-agents]]
- [[03-RESOURCES/concepts/reinforcement-learning]]
- [[03-RESOURCES/sources/ml-research-papers/clipping-21-reinforcement-learning-concepts]]

---

## A Questão Central: Qual é o Efeito do Comprimento de Horizonte no Treinamento?

Trabalhos anteriores assumiam que "mais é mais" — tarefas mais longas durante o treinamento sempre produzem agentes mais capazes. Este paper questiona essa assunção com estudo empírico sistemático.

**Definição de horizonte:** O número de passos de interação com o ambiente em uma trajetória de treinamento. Horizonte curto = tarefa que resolve em 5-10 ações. Horizonte longo = tarefa que requer 50-200+ ações.

---

## Descobertas Principais

### 1. Trade-off Bias-Variância no Horizonte

Horizontes curtos introduzem **bias de treinamento** — o modelo aprende a resolver subtarefas mas não a integrar múltiplos subtarefas numa solução de longo prazo. Analogia: treinar num sprinter de 100m não produz maratonista.

Horizontes longos introduzem **variância de treinamento** — o sinal de recompensa é esparso (vem apenas no final de trajetórias longas) e ruidoso. O agente recebe feedback muito tardio para aprender eficientemente.

**O sweet spot:** Existe horizonte ótimo por domínio. O paper estuda como encontrá-lo sistematicamente.

### 2. Curriculum de Horizonte

Agentes treinados com curriculum progressivo de horizonte (começa curto, aumenta gradualmente) superam agentes treinados com horizonte fixo — seja curto, seja longo.

**Mecanismo:** Curriculum permite ao agente construir competência em subtarefas curtas antes de integrá-las em tarefas longas. Semelhante a como humanos aprendem: habilidades básicas primeiro, depois combinação em tarefas complexas.

### 3. Credit Assignment Problem se Agrava com Horizonte

Em RL, o credit assignment problem é a dificuldade de atribuir recompensas a ações específicas quando recompensas vêm tarde. Com horizon longo, uma ação na etapa 1 pode determinar o sucesso na etapa 100 — mas o sinal de gradiente que chega na etapa 1 está extremamente diluído.

**Soluções que funcionam:**
- Dense reward shaping: adicionar recompensas intermediárias por progresso parcial
- GAE (Generalized Advantage Estimation) com λ alto: mantém mais do sinal de longo prazo
- Hierarquical learning: subproblemas com recompensas próprias

### 4. Context Length vs. Horizon Length

Distinção importante: context length é capacidade da janela de contexto do modelo (quantos tokens ele pode processar). Horizon length é comprimento da tarefa (quantos steps de ação). São independentes — o paper controla as duas variáveis independentemente.

---

## Implicações para Design de Agentes Autônomos

### Para Treinamento (Fine-tuning)
Se você está fine-tuning um agente para tarefas longas (ex: coding agent para refactors grandes):
- Use curriculum: comece com tasks de 5-10 steps, aumente gradualmente para 50-100
- Adicione recompensas intermediárias (dense reward shaping)
- Não espere que treinar em tasks longas desde o início funcione bem

### Para Inferência (Runtime)
Mesmo sem fine-tuning, as descobertas informam design de harness:
- Decomponha tarefas longas em subtarefas com critérios de sucesso próprios (cria "horizonte curto artificial" para cada etapa)
- Forneça feedback intermediário explícito ao agente (ex: "etapa 1 de 5 concluída com sucesso")
- Use planning explícito antes de execução — reduz efetivamente o horizonte de cada decisão individual

---

## Comparação com RLHF

RLHF (usado para treinar Claude, GPT-4) usa episódios muito curtos — geralmente uma única conversa de alguns turnos. As descobertas deste paper sugerem que para agentes de longo horizonte (coding agents, research agents), RLHF padrão é subótimo: o horizonte é muito curto para capturar competências de planejamento de longo prazo.

**Implicação:** Modelos especializados para agentic tasks precisam de regime de treinamento diferente de modelos de chat — com episódios mais longos, recompensas intermediárias, e curriculum progressivo.

---

## Domínios Testados

O paper conduz experimentos em:
- **ALFWorld** (navegação doméstica em linguagem natural)
- **WebArena** (navegação web com objetivos)
- **SWE-bench lite** (coding tasks com horizon médio)

Em todos, o padrão curriculum + dense reward supera treinamento com horizonte fixo. A diferença é maior em WebArena (tarefas mais longas) que em SWE-bench lite (tarefas mais curtas).

---

## Limitações

- Experimentos usam modelos de tamanho médio (7B-13B) — resultados podem não escalar linearmente para modelos maiores.
- Curriculum ótimo é domínio-específico — descobrir o schedule certo requer experimentos adicionais por domínio.
- Dense reward shaping requer design manual — não há método geral para definir recompensas intermediárias automaticamente.

---

## Links

- [[03-RESOURCES/concepts/long-horizon-agents]]
- [[03-RESOURCES/concepts/reinforcement-learning]]
- [[03-RESOURCES/concepts/rlhf-pipeline]]
- [[03-RESOURCES/sources/ml-research-papers/clipping-21-reinforcement-learning-concepts]]
- [[03-RESOURCES/sources/ml-research-papers/halo-rlm-self-improving-agents]]
