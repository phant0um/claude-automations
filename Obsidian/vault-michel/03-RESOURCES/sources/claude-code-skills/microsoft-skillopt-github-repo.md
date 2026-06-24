---
title: "SkillOpt — Microsoft GitHub Repo: Text-Space Optimizer for LLM Agent Skills"
type: source
source: "Clippings/microsoftSkillOpt SkillOpt is a text-space optimizer that trains reusable natural-language skills for frozen LLM agents through trajectory-driven edits, validation-gated updates, and deployable best_skill.md artifacts..md"
origin: "https://github.com/microsoft/SkillOpt"
author: "Yifan Yang et al. (Microsoft)"
published: 2026-05-31
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, skillopt, skill-optimization, microsoft, self-evolving-agents, validation-gate, text-space-optimizer, frozen-llm]
---

## Tese central

SkillOpt (Microsoft Research) é um otimizador em espaço de texto que treina skills em linguagem natural reutilizáveis para agentes LLM frozen, usando edições guiadas por trajetória, atualizações validadas por gating, e artefatos deployáveis `best_skill.md` — análogo a treinar redes neurais (epochs, batch size, learning rate, validation gates) sem tocar nos pesos do modelo. Publicado como paper arXiv 2605.23904 (2026).

## Argumentos principais

- **Frozen model + trained context**: skills são o veículo de adaptação sem fine-tuning — mais barato, portátil, inspecionável.
- **Benchmarks suportados**: SearchQA, ALFWorld (embodied agent), DocVQA, LiveMathematicianBench, SpreadsheetBench, OfficeQA — cobrindo QA, embodied, document QA, math, code generation, tool-augmented QA.
- **Hiperparâmetros de treinamento reais**: `--num_epochs`, `--batch_size`, `--workers` (parallel rollout workers) — convergência terminológica entre ML e otimização de skills.
- **Validation gate**: atualização de skill só aceita se melhora estritamente no validation set — empates rejeitados.
- **Output estruturado**: cada run produz `best_skill.md`, `skills/skill_vXXXX.md` (snapshot por step), `history.json`, `runtime_state.json` (checkpoint para resume).
- **Multi-model support**: Azure OpenAI (GPT-5.5), OpenAI-compatible endpoints, Anthropic Claude (`ANTHROPIC_API_KEY`), Qwen (local vLLM).
- **Soft gate community config** (PR #25): para validation sets pequenos (≤~10 items) com reward contínuo onde o hard gate rejeita tudo e o treinamento trava — alternativa via partial-credit.
- **WebUI opcional**: dashboard Gradio em `skillopt_webui.app` para monitorar training.
- **Slow update / meta skill**: `slow_update/epoch_XX/` e `meta_skill/epoch_XX/` — dois níveis de atualização análogos a learning rates diferentes.

## Key insights

1. **SkillOpt como "gradient descent para SKILL.md"**: a terminologia de epochs/batch/learning rate é intencional — mapeia diretamente a intuição de ML para otimização de contexto.
2. **best_skill.md como artefato deployável**: o output final é um único arquivo markdown que pode ser dropado em qualquer runtime compatível — portabilidade confirmada (Codex→Claude Code +59.7pp no SpreadsheetBench, per koylanai).
3. **Validation gate = barreira anti-regressão**: sem ele, otimização aceita lixo. 1–4 edições aceitas por run completo é o resultado esperado de um processo bem calibrado.
4. **Auto-resume de checkpoint**: `re-running the same command auto-resumes from the last completed step` — resiliente a falhas.
5. **Diferença do koylanai post**: o post de @koylanai analisa o paper; este é o **repositório oficial Microsoft** com código completo, configs para 6 benchmarks, e instruções de instalação — fonte primária vs. análise secundária.

## Exemplos e evidências

- SpreadsheetBench: skill treinada no Codex portada para Claude Code (via koylanai): +59.7 pontos
- ALFWorld suportado com `pip install -e ".[alfworld]"` + `alfworld-download`
- Training command mínimo: `python scripts/train.py --config configs/searchqa/default.yaml --optimizer_model gpt-5.5 --target_model gpt-5.5`
- Eval-only: `python scripts/eval_only.py --skill ckpt/searchqa/gpt5.5_skill.md --split valid_unseen`
- Soft gate config: para validation sets pequenos onde hard gate stalls

## Implicações para o vault

- **Código-fonte disponível**: pode-se rodar SkillOpt localmente para treinar skills do vault (`04-SYSTEM/skills/`) em tarefas de ingestão, revisão, etc.
- **Integração com hill agent**: SkillOpt é a versão formal e validada do que o hill agent tenta fazer manualmente — considerar integração ou inspiração de protocolo.
- **`best_skill.md` como padrão de output de treinamento**: o vault poderia adotar convenção de versionar skills com sufixo `_vXXXX.md` durante otimização.
- **Checkpoint para skills críticas**: `runtime_state.json` sugere que treinos longos de skills podem ser interrompidos e retomados.

## Links

- [[03-RESOURCES/entities/Microsoft-Research-Asia]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- [[03-RESOURCES/sources/claude-code-skills/koylanai-skillopt-gradient-descent-skills]]
- [[03-RESOURCES/sources/claude-code-skills/skillos-google-self-evolving-skill-curation]]
- [[03-RESOURCES/sources/claude-code-skills/anthropic-how-we-use-skills]]

## Relações
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]] — conceito síntese deste paper
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] — skill otimização como gradient descent convergem
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — complementar: RL para comportamento, SkillOpt para conhecimento
