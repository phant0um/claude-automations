---
title: "Rubric-Based Rewards for RL"
type: source
source: Clippings/Rubric-Based Rewards for RL.md
source_type: clipping
created: 2026-05-19
ingested: 2026-05-19
triagem_score: 8
triagem_cat: ml-research
tags: [clipping, ml-research]
---

## Tese central

RLVR (RL with Verifiable Rewards) funciona perfeitamente em matemática e código onde reward é binário. Para domínios não-verificáveis (escrita, análise, raciocínio aberto), paper propõe rubric-based rewards via LLM-as-judge — substituindo reward binário por rubrica estruturada que LLM avalia de forma consistente.

## Key insights

- **From LLM-as-a-Judge to Rubrics:** LLM-as-judge sem rubrica é inconsistente — mesmo modelo avalia o mesmo output diferente em momentos diferentes. Rubrica explícita com critérios, pesos e exemplos reduz variância de ~40% para ~10% em experimentos controlados
- **LLM-as-a-Judge como reward model:** usar LLM separado (geralmente maior e mais capaz) para avaliar output do LLM treinado — reward signal derivado da avaliação. Loop: treinar → avaliar via judge → usar avaliação como reward → iterar
- **"We always require a reference answer in order to perform evaluation":** constraint importante — mesmo com rubrica, judge precisa de algum âncora. Para RL em domínios abertos, referência pode ser output humano, output de modelo frontier, ou output de iteração anterior melhor

## Por que RLVR não funciona sozinho em domínios abertos

### O problema do reward binário

RLVR em matemática: resposta correta = reward 1, incorreta = reward 0. Gradiente de aprendizado claro.

RLVR em escrita de análise: o que é "resposta correta"? Não existe. Reward binário é impossível.

Alternativas sem rubrica:
- **Reward humano:** caro, lento, não escala para RL iterativo
- **LLM-as-judge sem rubrica:** inconsistente, viés de posição, viés de comprimento

Rubrica resolve ao tornar julgamento explícito e estruturado.

## Estrutura de rubrica eficaz

### Componentes

```markdown
# Rubrica de Avaliação: Análise de Argumento

## Dimensões (100 pontos total)

### 1. Clareza de Tese (0-25 pontos)
- 25: Tese explícita na abertura, contestável, específica
- 15-24: Tese presente mas vaga ou implícita
- 5-14: Tese emerge apenas no desenvolvimento
- 0-4: Sem tese identificável

### 2. Qualidade de Evidência (0-30 pontos)
- 25-30: Evidências concretas, específicas, de fontes confiáveis
- 15-24: Evidências presentes mas genéricas
- 5-14: Evidências fracas ou irrelevantes
- 0-4: Sem evidências

### 3. Rigor Lógico (0-25 pontos)
[...]

### 4. Clareza de Linguagem (0-20 pontos)
[...]

## Exemplos âncora

### Output nota 90:
[exemplo concreto]

### Output nota 50:
[exemplo concreto]

### Output nota 20:
[exemplo concreto]
```

### Por que exemplos âncora são críticos

LLM-as-judge sem âncoras tende a inflacionar scores (viés de positividade) ou a usar escala completa inconsistentemente. Exemplos âncora calibram o judge — "nota 50 parece com isso", tornando avaliações comparáveis entre sessões.

## Pipeline de RL com rubric reward

```
[1] Definir rubrica com dimensões, pesos, exemplos âncora
[2] Calibrar judge: humano avalia 50 exemplos → comparar com judge → ajustar rubrica até concordância > 0.7 Kappa
[3] Loop de RL:
    a. Modelo treino gera N outputs para tarefa
    b. Judge aplica rubrica a cada output → score 0-100
    c. Score usado como reward signal
    d. Update de política via PPO/GRPO/DPO
    e. Avaliar em held-out set
[4] Monitorar judge drift: re-calibrar com humano a cada X iterações
```

## Limitações e riscos

### Goodhart's Law

"When a measure becomes a target, it ceases to be a good measure." — Modelo pode aprender a maximizar score de rubrica sem melhorar na tarefa real. Cheating the rubric é risco quando modelo treina contra o judge por muitas iterações.

Mitigação: rotacionar juízes, adicionar dimensões de rubrica conforme modelo demonstra exploits, manter avaliação humana periódica.

### Judge como bottleneck de qualidade

Rubric reward é limitado pelo teto do judge. Modelo treinado nunca supera consistentemente o judge — aprende a satisfazer critérios do judge, não necessariamente a ser melhor.

Solução: usar modelo frontier (GPT-4o, Claude Opus) como judge, mesmo que modelo treino seja menor.

### Custo de judge em scale

RL requer muitas iterações. Se judge é modelo frontier caro, custo de evaluate explode em escala. Soluções: usar judge menor calibrado, batch evaluation, ou judge esparso (avaliar sample, não tudo).

## Aplicação concreta

Para treinar agente de ingestão de wiki com rubrica:
1. Rubrica: wikilinks válidos (30), categorização correta (25), síntese não-redundante (25), hot.md atualizado (20)
2. Judge: Claude verificando cada dimensão com exemplos âncora de ingestões passadas
3. RL loop: ingerir → avaliar → reward → update

## Rubric vs RLHF

RLHF (RL with Human Feedback) coleta preferências humanas diretamente (A > B ou rating numérico). Rubric-based rewards é formalização estruturada que permite LLM substituir humano como avaliador.

Trade-offs:
- RLHF captura nuance humana que rubrica pode perder, mas escala mal (human bottleneck)
- Rubric é escalável mas limitada à qualidade da rubrica definida — garbage rubric, garbage reward
- Combinação ideal: RLHF para calibrar rubrica inicial + rubric-based rewards para scaling

## Rubrica como especificação de comportamento

Insight derivado: rubrica de reward é, funcionalmente, especificação do comportamento desejado. Escrever rubrica boa força clareza sobre o que "bom output" significa — exercício valioso independentemente do RL.

Para qualquer sistema de produção: criar rubrica de qualidade antes de avaliar outputs ad-hoc. A rubrica serve como alinhamento interno de equipe sobre critérios, base de eval sistemática, e potencialmente como reward para RL futuro.

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/claude-code-tooling/anatomy-claude-prompt]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]

## Fonte

Arquivo original: `Clippings/Rubric-Based Rewards for RL.md`
