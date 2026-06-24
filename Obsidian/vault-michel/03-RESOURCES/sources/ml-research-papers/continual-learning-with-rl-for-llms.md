---
title: "Continual Learning with RL for LLMs"
type: source
source: Clippings/Continual Learning with RL for LLMs.md
source_type: clipping
created: 2026-05-19
ingested: 2026-05-19
triagem_score: 9
triagem_cat: ml-research
tags: [clipping, ml-research]
---

## Tese central

Continual learning com RL em LLMs enfrenta três problemas fundamentais: catastrophic forgetting (ganhar nova skill destroí skill antiga), estruturação correta de experimentos (comparação válida requer controles específicos), e quais técnicas realmente funcionam em prática além de laboratório. Paper mapeia cada dimensão com rigor empírico.

## Key insights

- **Why is continual learning difficult:** LLMs atualizados via RL em tarefa nova sofrem catastrophic forgetting — pesos otimizados para nova tarefa sobrescrevem representações da tarefa antiga. Problema é fundamentalmente diferente de fine-tuning porque RL muda distribuição de comportamento de forma mais agressiva que supervised learning
- **How to structure experiments:** comparação válida requer: mesmo modelo base, mesmo compute budget, mesmas tarefas de avaliação (incluindo tarefas anteriores), e separação clara entre performance em tarefa atual vs retenção de tarefa antiga
- **Which techniques are effective:** replay (re-expor model a dados de tarefas antigas durante treino nova), compartmentalization (parâmetros separados por domínio), e elastic weight consolidation (EWC — penalizar mudança em pesos importantes para tarefas anteriores)

## Por que continual learning é difícil em LLMs

### Catastrophic forgetting

Rede neural representa conhecimento em pesos compartilhados. Otimização SGD em tarefa B move pesos para minimizar loss B — mas isso move pesos para longe do mínimo de loss A. Tarefa A é "esquecida" proporcionalmente à sobreposição de representações.

Em LLMs com RL, o problema é amplificado porque:
1. RL é mais instável que supervised learning — gradient steps maiores e mais variáveis
2. Reward shaping em nova tarefa pode contradizer comportamento preferido em tarefa antiga
3. Distribuição de dados implícita em RL (gerada pelo próprio modelo) deriva conforme policy evolui

### Forgetting não é binário

Performance em tarefa antiga não cai de 100% para 0% abruptamente. Degrada gradualmente com cada update. Sem eval contínua em tarefas antigas, degradação passa invisível por semanas.

## Técnicas efetivas

### Replay

Manter buffer de exemplos de tarefas anteriores. Durante treino de nova tarefa, incluir % de replay no batch.

```python
# Pseudocódigo de replay buffer
replay_buffer = ExperienceBuffer(capacity=10000)
# Preencher com exemplos de tarefa A antes de treinar B
replay_buffer.add(task_A_examples)

# Durante treino de B:
for step in training_steps:
    new_batch = sample_task_B()
    replay_batch = replay_buffer.sample(n=50)  # 20-30% de replay
    combined = new_batch + replay_batch
    update(model, combined)
```

Trade-off: tamanho do buffer vs custo de compute. Buffer pequeno → forgetting; Buffer grande → custo de treino alto.

### Elastic Weight Consolidation (EWC)

Penaliza mudanças em pesos que foram importantes para tarefas anteriores. Usa Fisher information matrix como estimativa de importância de cada peso.

```
L_total = L_new_task + λ * Σᵢ Fᵢ(θᵢ - θ*ᵢ)²
```

Onde Fᵢ é Fisher information do peso i (quão importante para tarefa antiga), θ*ᵢ é valor ótimo para tarefa antiga, e λ é trade-off entre aprender nova tarefa e reter antiga.

### Compartmentalization

Parâmetros separados por domínio — cada tarefa tem subset de pesos "owns". Implementações: adapters por tarefa, LoRA layers separadas, heads específicas. Elimina forgetting por isolamento, mas aumenta tamanho do modelo linearmente com número de tarefas.

## Estrutura de experimento válida

### O que NÃO fazer
- Avaliar só na tarefa nova após treino
- Comparar com baseline treinado apenas na tarefa nova
- Ignorar compute budget (replay usa mais compute — comparação deve ser iso-compute)

### O que fazer
```
Baseline: modelo pré-treino
Tarefa A: fine-tune/RL → eval A1 (imediata) + eval B0 (baseline)
Tarefa B: continual RL → eval B1 (imediata) + eval A2 (forgetting)
Comparação: A2 vs A1 = taxa de forgetting; B1 vs B0 = eficiência de aprendizado novo
```

## Aplicação prática

Para agentes do vault que são atualizados periodicamente: verificar se updates de skill nova degradam skills existentes. Manter eval suite por skill como baseline de forgetting detection.

## Relação com memory-skills como harness unificado

Se skills e memória são o mesmo harness (ver memory-skills-same-harness-tricalt), então continual learning tem implicação direta: ao adicionar nova skill (nova memória executável), verificar se habilidades existentes do harness se degradam.

Teste prático: antes de adicionar skill nova ao vault, rodar conjunto de tarefas representativas de skills existentes e comparar performance. Se degradação detectada, investigar conflito de instrução entre SKILL.md files.

## Panorama de pesquisa em 2026

Continual learning em LLMs é área de pesquisa ativa com três subcomunidades:
1. **Teóricos:** formalização matemática de forgetting, bounds de Rademacher para continual learning
2. **Praticistas de ML:** técnicas aplicadas (EWC, replay, LoRA por tarefa) em modelos de escala
3. **Builders de produto:** como atualizar modelos em produção sem degradar usuários existentes — o problema de "model update" em sistemas de IA

Paper captura perspectiva dos praticistas de ML com aplicabilidade alta para builders de produto.

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]

## Fonte

Arquivo original: `Clippings/Continual Learning with RL for LLMs.md`
