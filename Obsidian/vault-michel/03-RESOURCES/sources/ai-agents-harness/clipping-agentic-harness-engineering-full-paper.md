---
title: "Agentic Harness Engineering: Observability-Driven Automatic Evolution of Coding-Agent Harnesses"
type: source
source_type: paper
author: "Jiahang Lin et al. (Fudan/Peking)"
created: 2026-05-06
tags: [harness-engineering, observability, coding-agents, evolution]
triagem_score: 9
---

AHE introduces three observability pillars for autonomous harness evolution: component, experience, and decision observability. 10 iterations lift pass@1 on Terminal-Bench 2 from 69.7% to 77.0%, surpassing human-designed Codex-CLI. Frozen harness transfers cross-family with +5.1 to +10.1pp gains. arXiv:2604.25850v3.

## Source

Ingested from: `clippings/Agentic Harness Engineering Observability-Driven Automatic Evolution of Coding-Agent Harnesses.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Mecanismo Detalhado

O harness de um agente de código é o scaffold que envolve o LLM: ferramentas disponíveis, memória operacional, formato de prompt, middlewares, estratégias de retry, e pipeline de observação. Diferente do modelo em si, o harness é editável e versionável — mas historicamente era projetado à mão por engenheiros humanos.

AHE propõe que o harness pode evoluir autonomamente se três tipos de observabilidade forem mantidos:

### Três Pilares de Observabilidade

**1. Component Observability**
Cada componente do harness (ferramenta, prompt, filtro, parser) é instrumentado para emitir métricas de uso e resultado. O sistema pode ver quais ferramentas são chamadas com mais frequência, quais retornam erros, e quais combinações de componentes produzem sucesso. Isso transforma o harness de caixa preta em grafo observável.

**2. Experience Observability**
O sistema mantém um log estruturado de episódios: tarefa → ações tomadas → resultado → análise de falha. Experiências bem-sucedidas e fracassadas são armazenadas como dados de treino para o otimizador. Em vez de jogar fora episódios passados, AHE os usa como sinal de evolução. É análogo ao replay buffer do reinforcement learning, mas aplicado ao harness e não ao modelo.

**3. Decision Observability**
A lógica de roteamento e branching dentro do harness é externalizada e registrada. O sistema pode ver por que escolheu usar a ferramenta A versus B, qual condição ativou qual estratégia, e onde as decisões de controle falharam. Isso fecha o loop: permite auditar não apenas o que aconteceu, mas por quê o harness tomou aquele caminho.

### Loop de Evolução

```
Episódio executado
  → Component Obs. captura métricas de ferramenta
  → Experience Obs. armazena resultado + análise
  → Decision Obs. registra branching logic
  → Otimizador propõe modificações ao harness
  → Modificação aplicada (versão nova)
  → Próximo episódio com harness atualizado
```

Em 10 iterações, o sistema parte de um harness genérico e converge para um harness especializado que supera o Codex-CLI projetado por humanos da Anthropic/Microsoft.

## Resultados Empíricos

- **Terminal-Bench 2**: pass@1 sobe de 69.7% (harness inicial) para 77.0% (harness evoluído em 10 iterações)
- **Superação do baseline humano**: Codex-CLI (harness humano state-of-the-art) fica abaixo do harness evoluído
- **Transferência cross-family**: um harness congelado (frozen) num modelo de família A transfere para modelo de família B com ganhos de +5.1 a +10.1 pontos percentuais — indica que o harness captura heurísticas de tarefa, não overfitting ao modelo específico

## Comparação: Harness Humano vs AHE

| Dimensão | Harness Humano | AHE Evoluído |
|---|---|---|
| Design | Intuição de engenheiro | Dados de episódio |
| Iteração | Semanas por ciclo | Automático por run |
| Observabilidade | Ad hoc / logs | Estruturada e auditável |
| Transferabilidade | Ruim (acoplado ao dev) | Alta (+5–10pp cross-family) |
| Custo | Alto (eng. time) | Compute + storage |

## Limitações

- A evolução requer episódios suficientes para convergir — tarefas raras podem não ter sinal suficiente
- O otimizador propõe mudanças no harness mas precisa de um critério de parada (risco de overfit ao benchmark)
- Decision observability em harnesses complexos pode gerar logs muito grandes, onerando o contexto do otimizador
- O paper não aborda segurança: um harness que evolui autonomamente pode desenvolver comportamentos inesperados se o critério de fitness for mal especificado

## Relevância para o Vault

Este paper é a fundamentação teórica para entender por que os agentes do vault-michel têm CLAUDE.md como camada de configuração editável: o próprio CLAUDE.md é um harness primitivo que pode ser refinado iterativamente conforme o comportamento do agente é observado. A prática de registrar erros em `04-SYSTEM/wiki/errors.md` é uma forma manual de Experience Observability — AHE automatiza exatamente esse loop.

## O que AHE significa para equipes sem recursos de pesquisa

O paper usa 10 iterações de evolução automática em Terminal-Bench 2, o que requer recursos computacionais não triviais. Mas os três pilares de observabilidade são independentemente implementáveis em qualquer escala:

**Component Observability em escala pequena:** um log estruturado de quais ferramentas foram chamadas, com que frequência, e com qual taxa de erro já fornece sinal suficiente para decisões de curadoria manual. Se uma ferramenta tem 40% de taxa de erro mas é chamada em metade das sessões, esse é o componente que mais beneficia de melhorias no harness.

**Experience Observability em escala pequena:** o arquivo `04-SYSTEM/wiki/errors.md` do vault-michel é uma implementação manual deste pilar. A diferença em relação ao AHE é que o AHE automatiza a extração e a análise — o vault faz isso manualmente com max 30 entradas. A disciplina de registrar erros e consolidar similares antes de adicionar novos é a mesma.

**Decision Observability em escala pequena:** adicionar uma linha de log antes de cada decisão de routing — "usando ferramenta X porque condição Y" — cria um audit trail que permite retroativamente entender por que o harness tomou determinado caminho em uma sessão que falhou.

## Frozen harness e transferência cross-model

O resultado de transferência cross-family (+5.1 a +10.1pp) é teoricamente importante: confirma que o harness otimizado captura heurísticas de tarefa (como estruturar o problema, quando verificar, como reportar erros), não overfitting ao modelo específico. Isso significa que investir em harness design tem ROI que não se deprecia quando o modelo base muda — ao contrário de fine-tuning, que precisa ser refeito para cada versão de modelo.

Para o vault-michel, isso valida o investimento em CLAUDE.md e skills especializados: esses artefatos continuarão funcionando conforme os modelos evoluem, com ganho de performance naturalmente, sem necessidade de redesign.

## Relações

- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — conceito central do paper
- [[03-RESOURCES/concepts/coding-agents]] — domínio de aplicação
- [[03-RESOURCES/concepts/observability-driven-evolution]] — padrão de design introduzido
- [[03-RESOURCES/sources/guides-courses-howtos/clipping-how-to-make-a-coding-agent-smarter-without-touching-the-mode]] — paper relacionado (AHE é a versão full desse tema)
