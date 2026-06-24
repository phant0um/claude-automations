---
title: "I Made GPT-5.5, GLM 5.2, and Gemini 3.5 Flash Build the Same Game. The Winner Surprised Me."
type: source
source: "Clippings/I Made GPT-5.5, GLM 5.2, and Gemini 3.5 Flash Build the Same Game. The Winner Surprised Me..md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Comparar coding agents não é comparar só modelo — é comparar modelo + harness, porque o harness (Codex App, OpenCode CLI, Antigravity CLI) muda velocidade, confiabilidade, manuseio de arquivo, recuperação de erro e se o agente trava. Num teste idêntico (construir o mesmo jogo browser completo a partir de um prompt detalhado), GLM 5.2 via OpenCode CLI venceu em qualidade de artefato final (92.5/100), mas Gemini 3.5 Flash via Antigravity CLI, apesar de terceiro lugar em qualidade (88.5/100), construiu um jogo jogável em 3min07s contra 12min47s (GPT-5.5) e ~17min51s (GLM) — revelando que "melhor resultado" e "melhor experiência de operador" são rankings diferentes e ambos importam no trabalho real.

## Argumentos principais
- **Setup do teste**: três combinações modelo+harness — Codex App (Windows) com GPT-5.5; OpenCode CLI (Windows) com GLM 5.2; Antigravity CLI (Windows) com Gemini 3.5 Flash — mesmo prompt extremamente detalhado (jogo "Moon Bouncer: Oxygen Panic", React+TypeScript+Vite, sem ativos externos, requisitos de gameplay/visual/áudio/UX/qualidade de código todos explicitados), mesmo sistema de scoring (100 pontos), sem edição manual antes do julgamento.
- **Critérios de score (100 pontos)**: roda sem erros (15), game loop jogável (15), movimento/controles (10), hazards/oxigênio/colisão/win-loss (20), polish visual (15), game feel (10), qualidade de código (10), suporte mobile/responsivo (5) — mais um "video wow score" separado e não-científico para avaliar se o resultado é apresentável em vídeo.
- **Resultado 1 — Codex/GPT-5.5** (12min47s, score 90.5): melhor charme visual e apresentação geral mais forte, execução mais limpa, boa organização de código (estrutura separada: components/game com audio/config/input/renderer/simulation/types), TypeScript e lint passando. Fraquezas: som básico, estado de game-over não visível no vídeo, trecho inicial um pouco fácil.
- **Resultado 2 — OpenCode/GLM 5.2** (~17min51s, com um hiccup de hang/resume no meio, score 92.5): melhor artefato final — UI mais limpa do grupo (barras de oxigênio/escudo legíveis, feedback de perigo vermelho quando escudo baixo), melhor sound design de longe (efeitos separados para jump/boost/collect/damage/game-over/victory/wave-changes/low-oxygen usando noise bursts, oscillator ramps, filtros, envelopes de gain), arquitetura excelente (componentes separados por tela: GameOverScreen/HUD/PauseOverlay/StartScreen/TouchControls/VictoryScreen). Fraquezas: build mais lento, hiccup operacional, sem script de lint, charme visual levemente inferior ao GPT-5.5.
- **Resultado 3 — Antigravity/Gemini 3.5 Flash** (3min07s, score 88.5): graficamente o mais fraco dos três (mundo com menos personalidade, visual mais escuro/simples), mas controles possivelmente os melhores do grupo (astronauta rápido, responsivo, fácil de pilotar) e construído numa fração do tempo dos outros. Código mais monolítico (`GameEngine.ts` com ~1700 linhas) e lint falhou (erros de switch-case, variável não usada, warning de hook React).
- **Dois rankings finais, diferentes**:
  - **Qualidade de artefato**: 1º GLM 5.2 (92.5), 2º GPT-5.5 (90.5), 3º Gemini 3.5 Flash (88.5).
  - **Experiência de operador (tempo de build)**: 1º Gemini 3.5 Flash (3:07), 2º GPT-5.5 (12:47), 3º GLM 5.2 (~17:51).
- **Vencedores por categoria**: melhor jogo finalizado = GLM 5.2; melhor apresentação visual = GPT-5.5; melhor sound design = GLM 5.2; melhores controles = Gemini 3.5 Flash; melhor estrutura de código = GLM 5.2 (GPT-5.5 muito próximo); execução mais limpa = GPT-5.5.

## Key insights
- "A model can produce the best result and still be less pleasant to use all day" — a métrica que mais importa no trabalho real recorrente pode não ser a de maior score absoluto, e sim a combinação de velocidade + confiabilidade de execução (sem stop/resume) + qualidade aceitável.
- Velocidade extrema (Gemini, 3min07s) trocou diretamente por dívida de qualidade de código (arquivo monolítico de 1700 linhas, lint falhando) — uma trade explícita entre tempo de prototipagem e manutenibilidade.
- Harness importa tanto quanto modelo: o hiccup de hang/resume do OpenCode CLI com GLM 5.2 afetou a "experiência de operador" mesmo com o melhor artefato final — reforça que avaliação de coding agent não pode isolar o modelo do invólucro que o executa.

## Exemplos e evidências
- Prompt completo e extremamente detalhado fornecido aos três setups (requisitos de tech stack, gameplay, visual, áudio, UX, qualidade de código, testagem, formato de resposta final) — usado como controle experimental para igualar a tarefa.
- Estruturas de pastas comparadas lado a lado (GPT-5.5: `game/audio.ts,config.ts,input.ts,renderer.ts,simulation.ts,types.ts`; GLM 5.2: `components/` por tela + `game/engine.ts,entities.ts,hazards.ts,particles.ts,render.ts` + `hooks/useGameEngine.ts`; Gemini: estrutura simples de 6 arquivos com `GameEngine.ts` monolítico).
- Scores numéricos exatos: GPT-5.5 90.5, GLM 5.2 92.5, Gemini 3.5 Flash 88.5; tempos de build 12:47, ~17:51, 3:07 respectivamente.

## Implicações para o vault
Dado empírico atual (junho 2026) para `[[03-RESOURCES/concepts/llm-ml-foundations/model-selection-patterns]]` e `[[03-RESOURCES/concepts/llm-ml-foundations/model-routing]]` — confirma que escolha de modelo para coding deve ser condicionada ao harness e ao trade-off velocidade-vs-qualidade-de-código explícito, não a um ranking único de "melhor modelo". Relevante também para `[[03-RESOURCES/concepts/agent-systems/agent-eval-framework]]` como exemplo de comparação multi-dimensional (artefato vs. operador) em vez de score único.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/model-selection-patterns]]
- [[03-RESOURCES/concepts/llm-ml-foundations/model-routing]]
- [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]]
- [[03-RESOURCES/concepts/agent-systems/coding-agents]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
