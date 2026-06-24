---
title: "HeavySkill: Heavy Thinking as the Inner Skill in Agentic Harness"
type: source
source_url: "https://arxiv.org/html/2605.02396v1"
authors: ["Jianing Wang", "Linsen Guo", "Zhengyu Chen", "Qi Guo", "Hongyu Zang", "Wenjie Shi", "Haoxiang Ma", "Xiangyu Xi", "Xiaoyu Li", "Wei Wang", "Xunliang Cai"]
created: 2026-05-13
tags: [agentic-harness, heavy-thinking, parallel-reasoning, sequential-deliberation, test-time-scaling, rlvr, skills]
triagem_score: 9
---

# HeavySkill: Heavy Thinking as the Inner Skill in Agentic Harness

**Claim:** Heavy thinking (parallel reasoning + sequential deliberation) can be encapsulated as a single portable SKILL.md file, making it harness-agnostic inner capability rather than an artifact of orchestration infrastructure.

## Core Framework

Heavy thinking decomposes into two stages:

1. **Parallel Reasoning** — spawn K independent reasoning agents, each solving the same problem without seeing each other's outputs. Diversity of strategy is encouraged (algebraic vs. geometric approaches, etc.).
2. **Sequential Deliberation** — a second LLM reads a serialized memory cache of all K trajectories and synthesizes a final answer. It critically evaluates, can re-derive when all thinkers are wrong, and refuses naive concatenation.

Performance hierarchy observed: `Heavy-Pass@k ≥ Heavy-Mean@K ≥ Vote@K ≥ Mean@k`

## HeavySkill as a Readable Skill

The workflow is distilled into a SKILL.md with four components:
- **Activation Conditions** — triggers on complex reasoning tasks; dormant for factual queries
- **Parallel Reasoning Protocol** — instructs the orchestrator to spawn K subagents in parallel
- **Deliberation Prompt** — classify query, critically evaluate each trajectory, re-derive if all wrong, maintain format consistency
- **Output Constraints** — final answer only (not meta-analysis), domain-appropriate format

**Portability:** The same HeavySkill document tested successfully under both Claude Code and custom harnesses without modification.

## Key Findings

- HeavySkill consistently outperforms Best-of-N (BoN) / majority voting strategies
- Stronger models can approach Pass@N performance via sequential deliberation
- Sequential deliberation can synthesize correct answers not present in any single trajectory (HP@k > P@k in ~50% of frontier model trials)
- RLVR can further optimize both breadth (parallel) and depth (deliberation), improving HM@k and HP@k
- **Iterative deliberation** shows diminishing returns due to context interference from earlier rounds
- **Model selection for deliberation:** general-purpose instruction-following models work well even if weaker at raw reasoning — the deliberation stage needs synthesis ability, not peak reasoning power
- Max-Answer-Num trajectory selection strategy outperforms random, diversity, and length-based selection

## Experiment Benchmarks

STEM: AIME25, BeyondAIME, HMMT25-Feb, GPQA-Diamond  
General: LiveCodeBench, Arena-Hard, IFEval, IMO (Answer Bench)  
Tool use: AIME25 + HMMT25 with Python interpreter

Models tested: GPT-5 Thinking, Claude 4.5 Thinking, Gemini 3 Pro Preview, DeepSeek R1-0528, Kimi K2 Thinking, GLM 4.6, Qwen3-8B/32B, R1-Distill series, GPT-OSS-20B, DeepSeek V3.2 Thinking

## Relationships

- [[03-RESOURCES/concepts/llm-ml-foundations/heavy-thinking]] — core concept formalized here
- [[03-RESOURCES/concepts/parallel-reasoning]] — Stage 1 of HeavySkill
- [[03-RESOURCES/concepts/sequential-deliberation]] — Stage 2 of HeavySkill
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — HeavySkill is a readable skill artifact
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]] — framework context
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — serialized memory cache bridges the two stages
- [[03-RESOURCES/sources/claude-code-skills/skills-verifiable-artifacts-biconditional-correctness]] — companion paper on skill trust

---

## Mecanismo em Profundidade

### Por que Parallel Reasoning Funciona

A intuição por trás do Stage 1 é que raciocínio matemático complexo tem múltiplos caminhos válidos de solução — abordagem algébrica, geométrica, probabilística. Um único modelo, por padrão, escolhe um caminho e o persegue. Se o caminho está errado, não há fallback. K agentes independentes exploram K caminhos distintos; a diversidade de estratégia é o mecanismo, não a redundância.

A instrução explícita "sem ver os outputs dos outros" é crítica. Sem isolamento, os agentes convergem prematuramente — o segundo agente lê que o primeiro escolheu abordagem algébrica e tende a seguir a mesma linhagem. O valor do paralelismo é a diversidade, e a diversidade requer isolamento.

### Por que Sequential Deliberation Supera Voting

Vote@K agrega resultados por maioria — se 7 de 10 agentes concluem X, X vence. O problema: em problemas difíceis onde todos os 10 agentes estão errados de maneiras diferentes, a maioria pode ser a resposta mais frequentemente errada, não a mais correta.

Sequential deliberation não vota — raciocina sobre os raciocínios. O deliberador lê cada trajetória, identifica onde os pensadores concordam (alta confiança nessa etapa), onde divergem (incerteza genuína), e onde todos concordam mas a conclusão ainda parece estranha (sinal de erro sistemático compartilhado). Quando todos os K thinkers estão errados, o deliberador pode re-derivar a solução do zero usando as trajetórias como referência negativa — "todos tentaram essa abordagem e falharam, vou tentar outra".

Isso explica a descoberta `HP@k > P@k em ~50% dos trials`: Pass@k mede se algum dos K thinkers acertou; Heavy-Pass@k mede se o deliberador chegou à resposta correta. Em metade dos casos onde nenhum thinker individual acertou, o deliberador conseguiu sintetizar a resposta correta das trajetórias erradas.

### A Serialized Memory Cache como Protocolo

O mecanismo de transferência entre Stage 1 e Stage 2 é a serialized memory cache — um documento estruturado contendo todas as K trajetórias. O formato importa: não é apenas uma concatenação de outputs, mas uma estrutura que:

- Identifica cada trajetória com seu índice (Thinker 1, 2, ..., K)
- Preserva o raciocínio intermediário, não apenas a conclusão
- Inclui onde cada thinker expressou incerteza ou hesitou
- Sinaliza onde diferentes thinkers convergiram vs. divergiram

O deliberador usa essa estrutura para navegação seletiva — não lê as K trajetórias linearmente, mas consulta seções específicas conforme necessita durante seu próprio raciocínio.

### Por que Deliberação Iterativa Tem Retornos Decrescentes

A descoberta sobre iterative deliberation é contraintuitiva: rodar o deliberador múltiplas vezes sobre os mesmos K outputs deveria melhorar a resposta, mas na prática degrada. A explicação é context interference: na segunda iteração de deliberação, o deliberador tem seu próprio output da primeira iteração no contexto. Isso ancora seu raciocínio — ele tende a refinar e confirmar a resposta anterior em vez de reconsiderá-la criticamente. O contexto de sua própria deliberação anterior é "poluição" para a deliberação atual.

A solução para casos onde uma única passagem de deliberação não é suficiente é aumentar K (mais thinkers), não aumentar as iterações de deliberação.

### RLVR como Otimizador do Framework

Reinforcement Learning from Verifiable Rewards pode otimizar ambos os stages independentemente:

- **Para Stage 1:** RLVR treina os K thinkers para maximizar diversidade de estratégia + taxa de acerto individual. O reward é baseado em se o thinker chegou à resposta correta E se usou uma abordagem distinta dos outros thinkers.
- **Para Stage 2:** RLVR treina o deliberador para maximizar taxa de acerto final. O reward é simplesmente se a resposta final está correta, independente de como o deliberador chegou lá.

Essa separação de objetivos de treinamento (diversity + accuracy para thinkers; accuracy para deliberator) é análoga ao treinamento adversarial GANs: cada componente tem uma função objetivo específica que o leva a melhorar sua parte específica do sistema.

### Implicações Práticas para Design de Harness

**Custo vs. Benefício:** HeavySkill é caro — K vezes o custo de uma chamada única para o Stage 1, mais o custo do deliberador. Para questões que o modelo resolve corretamente em uma tentativa, é desperdício. O activation condition no SKILL.md é o que controla isso: o skill deve ser dormant para questões factuais diretas e ativado apenas para problemas de raciocínio complexo onde a tentativa única tem taxa de erro significativa.

**Seleção de K:** O paper não prescreve K fixo. A heurística prática: começar com K=3 (baixo custo, captura as abordagens mais distintas), aumentar para K=5 se os 3 ainda convergirem muito, raramente ir além de K=7 (retornos decrescentes na diversidade de estratégia).

**Aplicação no vault-michel:** Para tarefas de pesquisa complexas (sintetizar 10+ fontes contraditórias, analisar trade-offs arquiteturais com múltiplas dimensões), o padrão HeavySkill pode ser aplicado manualmente: spawn de múltiplos sub-agents de análise independentes, seguido de um agente deliberador que sintetiza. O SKILL.md portável torna isso reproduzível sem reescrever o protocolo cada vez.
