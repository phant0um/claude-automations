---
title: "SpatialClaw: Rethinking Action Interface for Agentic Spatial Reasoning"
type: source
source: "Clippings/SpatialClaw Rethinking Action Interface for Agentic Spatial Reasoning.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
SpatialClaw é um framework training-free que usa código Python rodando num kernel persistente como interface de ação para raciocínio espacial agêntico — composto, inspecionável e revisável a cada passo — e supera um agente prior recente em +11.2 pontos em 20 benchmarks, melhorando de forma consistente em seis backbones de VLM diferentes, sem nenhuma adaptação específica de modelo ou benchmark.

## Argumentos principais
- A tese central do paper: a capacidade de um agente com ferramentas não é limitada por quais ferramentas estão disponíveis, mas por como elas podem ser compostas — "a interface de ação é o gargalo, não o toolset".
- Três interfaces de ação comparadas: (a) single-pass code — escreve um programa Python completo de uma vez, não pode revisar depois que a execução começa, então qualquer assumption errada propaga direto para a resposta; (b) structured tool-call — despacha tools tipadas via interface JSON fixa, não pode combinar livremente outputs de percepção com primitivas NumPy/SciPy; (c) SpatialClaw — código como interface de ação, com kernel Python persistente — outputs de percepção são variáveis comuns: composáveis, inspecionáveis e reusáveis entre passos.
- Resultados principais: melhora em 19 de 20 benchmarks; ganho médio de +6.5pp sobre baseline sem ferramentas; +11.2pp sobre o agente espacial prior mais recente (SpaceTools-Toolshed).
- Tabela comparativa direta de interfaces de ação no mesmo toolset/prompt (Gemma 4-31B): no-tool baseline 53.4, single-pass code 55.2 (+1.8), structured tool-call 56.7 (+3.3), SpatialClaw 59.9 (+6.5) — isola o efeito da interface de ação, mantendo toolset e prompt constantes.
- Quatro achados sobre por que código funciona:
  1. SpatialClaw generaliza mesmo sem utility tools predefinidas — ablação removendo wrappers de utilidade (Mask, Geometry) mantém performance quase intacta (56.4 vs 56.9); removendo ferramentas de percepção inteiramente (SAM 3, DA 3) ainda supera baseline em +2.7pp, isolando a contribuição da própria interface de ação.
  2. O agente adapta espontaneamente a composição de ferramentas ao tipo de pergunta, sem prompt ou roteamento específico por categoria (perguntas de distância invocam KDTree e normas vetoriais; perguntas de direção usam produtos escalares; movimento de câmera usa composição de pose) — comportamento que interfaces de tool-call estruturado têm dificuldade de produzir.
  3. Ganhos são maiores onde é necessário encadear computação geométrica através de múltiplos frames/viewpoints — vantagem líquida em 11 de 13 meta-categorias, com os maiores lifts (+6 a +9pp) em movimento de câmera, raciocínio multi-view e direção relativa.
  4. Composição é o principal driver da vantagem sobre tool-call estruturado: um juiz LLM (Gemini 3 Pro) atribuiu 52.2% das vitórias a "composição de código" (encadear múltiplas chamadas num único programa coerente), 19.5% a "control flow" (if/for sobre resultados intermediários), e 28.3% a tarefas onde qualquer interface resolveria — mais de 70% das vitórias rastreiam a capacidades que uma API fixa não provê facilmente.

## Key insights
- A conclusão central reforça uma tese mais ampla do campo de agentic coding: código é a abstração certa para problemas que exigem composição livre e revisão de estado intermediário — não é exclusivo de raciocínio espacial.
- O design "training-free" significa que os ganhos vêm puramente da interface (mais o kernel persistente), não de fine-tuning — qualquer VLM backbone testado (Qwen 3.5/3.6, Gemma 4, 26B a 397B de parâmetros) se beneficia sem adaptação.
- A persistência do kernel (poder inspecionar variáveis intermediárias via `show()`) é o que permite revisão de estratégia em andamento — diferencia de single-pass code, que comete tudo de uma vez sem poder observar.

## Exemplos e evidências
- Trajetória completa mostrada passo a passo: pergunta multi-view sobre posição relativa porta/pia, resolvida com segmentação SAM 3, reconstrução 3D, ajuste de plano via RANSAC, e projeção vetorial num sistema de coordenadas customizado — resposta correta (Nordeste) com cálculo auditável em cada passo.
- Tabela completa de resultados em 6 backbones (Qwen 3.5-397B-A17B, Qwen 3.5-122B-A10B, Qwen 3.6-35B-A3B, Qwen 3.6-27B, Gemma 4-31B, Gemma 4-26B-A4B) × 20 benchmarks, com ganhos consistentes entre +3.1pp e +7.7pp.
- Comparação com agentes espaciais prior usando o mesmo backbone Gemma 4-31B: VADAR 40.5 (−19.4), pySpatial 47.8 (−12.1), SpaceTools-Toolshed 48.7 (−11.2), SpatialClaw 59.9 (melhor).
- Maiores ganhos por benchmark individual: DSI-Bench +17.6pp (4D), MindCube +15.3pp (multi-view), MMSI +13.4pp.
- Repositório de amostras de trajetórias reais navegável publicamente (spatialclaw.github.io/samples).

## Implicações para o vault
Reforça empiricamente a tese já presente no vault sobre `tool-use-agents` e arquiteturas de agente: interfaces de ação expressivas (código com estado persistente) superam tool-calling rígido para tarefas que exigem composição e revisão — paralelo direto ao motivo pelo qual Claude Code prioriza ferramentas de shell/código sobre APIs JSON fixas. Boa referência para discussões futuras sobre design de tools em agentes deste vault.

## Links
- [[03-RESOURCES/concepts/agent-systems/tool-use-agents]]
- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]]
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
