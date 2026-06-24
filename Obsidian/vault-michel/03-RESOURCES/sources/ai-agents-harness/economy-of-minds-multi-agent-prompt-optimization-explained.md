---
title: "Economy of Minds: Multi-Agent Prompt Optimization explained"
type: source
source: "Clippings/Economy of Minds Multi-Agent Prompt Optimization explained.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

O paper de Harvard "Economy of Minds" (EOM, arXiv:2606.02859) propõe um sistema multi-agent decentralizado onde agentes (LLMs com prompts como políticas) competem em leilões para agir em ambientes-alvo, com riqueza acumulada determinando quais políticas sobrevivem e se reproduzem. O resultado é um método de otimização automática de prompts multi-agent que produz comportamentos emergentes e raciocínio multi-step sem orquestração centralizada codificada manualmente.

## Argumentos principais

- **O problema que EOM resolve**: stacks multi-agent ainda dependem de orquestração hand-designed — o desenvolvedor escreve prompts explícitos e grafos de máquina de estados para definir "quem faz o quê e quando". Tarefas longas requerem diferentes switches de papel conforme o estado e progresso. EOM automatiza isso.
- **Um agente em EOM não é uma rede neural separada**: é um LLM policy com prompt (instrução de papel/procedimento), trigger/wake-up condition (quando é elegível para licitar), bid value (fixo na inicialização), e wealth (variável que muda e drive selection).
- **Dois loops acoplados**:
  - **Loop 1 — Planning (dentro de um episódio)**: agentes licitam pelo direito de agir em cada step. O vencedor gasta seu bid, executa uma ação no ambiente, o ambiente transiciona e produz reward. Transferência de riqueza via regra bucket-brigade: novo vencedor paga seu bid ao vencedor anterior + coleta o reward do ambiente.
  - **Loop 2 — Adaptation (entre episódios)**: a população evolui prompts usando seleção econômica + mutação. Agentes pobres são eliminados; agentes ricos geram descendentes com prompts levemente mutados (exploitation) ou exploram variantes para corrigir failure modes (exploration).
- **Rotas**: para MATH, papéis: planner, executor, verifier. Para accelerator design: historian, planner, executor. Para scientific research: roles emergentes via seleção.
- **O que se "treina" e o que se "ship"**: não um único agente vencedor — uma sociedade/população de agentes, cada um com seus próprios prompts e lógica de "quando agir". Na avaliação, usa-se uma cópia thread-local da população treinada. As mecânicas de mercado (wallets, wealth transfer) são apenas train-time.
- **Credit assignment como sinal de mercado**: se sua ação habilita ações futuras valiosas, agentes posteriores "compram" a continuação de você via bids — crédito descentralizado através da trajetória, mesmo sem rewards intermediários.
- **Agentes em falência**: agente que fica passivo tem seu wallet degradado até falir; agente que participa mas leva o sistema a estados ruins também falirá. Urgência econômica força participação e qualidade.

## Key insights

- **Emergência de comportamentos sem templates**: o sistema não codifica um workflow — estabelece regras econômicas, e a população se auto-organiza em comportamentos que se assemelham a "algoritmos aprendidos." No hardest accelerator kernels, a sociedade converge em um motif específico de tiling/dataflow (output-stationary) sem que esse motif fosse dado como template, apenas com reward de "EDP record-breaks."
- **Curvas de aprendizado não-monotônicas**: em Finance-Agent-Bench, EOM dip early (exploração de especialistas alternativos) e só depois recupera e supera a baseline. Similar ao Grokking em neural net training — caos produtivo inicial como exploração do espaço de especialistas.
- **Unidade de aprendizado é uma linhagem de prompts, não um agente**: em accelerator design, você vê literalmente linhagens úteis persistindo, gerando offspring e dominando leilões, enquanto variantes fracassadas vão à falência. A família de prompts sob pressão de riqueza é o que evolui.
- **Disciplina de ação emergente (CloudCast)**: perto de um high score → loops curtos "read-edit-evaluate-commit"; estado incerto/regressado → loops longos "edit-build-evaluate". Policy emergente de quando agir cautelosamente vs. agressivamente, sem controle central.
- **Prompts evoluem para rotinas de raciocínio multi-step**: em scientific research, prompts evoluem para incluir self-checks explícitos (principle-first, symmetry checks, feasibility checks, substitution to falsify) — o agente torna-se um módulo procedimental que executa uma rotina de derivação científica aprendida.
- **O sinal de crédito substitui reward intermediário ausente**: ambientes sem rewards intermediários são o "credit assignment problem" clássico de RL. EOM resolve via backward flow of value — se seu passo habilitou passos valiosos futuros, os bid payments posteriores criam sinal mesmo sem reward direto no seu step.

## Exemplos e evidências

- **MATH benchmark**: papéis — planner, executor, verifier.
- **Accelerator design (GEMMINI ResNet-50)**: papéis — historian, planner, executor. Objetivo: minimizar EDP (energy-delay product). Emergência do motif output-stationary sem template explícito.
- **Finance-Agent-Bench**: dip precoce seguido de superação da baseline — padrão documentado explicitamente no paper.
- **Scientific research**: evolução de prompts do executor internalizando papéis de outros roles + checklists auto-auditados emergentes.
- **CloudCast**: society-level policy emergente de quando agir cautelosamente vs. agressivamente baseada no estado do workspace.
- **Referência ao OpenAI Hide and Seek paper**: precedente de comportamentos emergentes complexos em cenários multi-agent simples (pré-LLM).
- Paper completo: http://arxiv.org/abs/2606.02859.

## Implicações para o vault

- EOM representa uma alternativa ao design manual de orquestração multi-agent — em vez de definir quem faz o quê, definir regras econômicas e deixar emergir. Isso é uma abordagem fundamentalmente diferente dos outros sources desta ingestão (que focam em orquestração explícita e hierárquica).
- A ideia de "linhagens de prompts" evoluindo via seleção econômica é relevante para pensar sobre como o vault-michel poderia evoluir skills automaticamente — em vez de escrevê-las manualmente, usar feedback de execução para selecionar e mutar.
- A técnica de bucket-brigade credit assignment pode ser útil em pipelines de agentes do vault onde há steps longos sem signal intermediário (ex: ingestão de documentos longos).
- O conceito de "wake-up condition" (trigger de quando licitar) é análogo ao sistema de triggers de skills do vault-michel.
- Candidato a novo conceito: [[03-RESOURCES/concepts/ai-agents/evolutionary-prompt-optimization]] ou seção em [[03-RESOURCES/concepts/ai-agents/multi-agent-orchestration]].

## Links

- [[03-RESOURCES/concepts/ai-agents/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/ai-agents/agent-skills]]
- [[03-RESOURCES/sources/how-to-run-100-agents-in-parallel-in-claude-code-full-playbook]]
- [[03-RESOURCES/sources/stop-asking-whether-the-agent-worked-ask-what-the-harness-observed]]
