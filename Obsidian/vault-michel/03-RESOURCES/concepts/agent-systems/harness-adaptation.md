---
title: Harness Adaptation
type: concept
created: 2026-05-31
updated: 2026-05-31
tags: [agent-systems, harness, adaptation, runtime]
---

# Harness Adaptation

Prática de adaptar o runtime harness de um agente — sem alterar os pesos do modelo — para melhorar performance em domínios específicos. Posiciona o harness como objeto de otimização separado e complementar ao model training.

## Distinção fundamental

- **Model adaptation**: atualiza pesos via fine-tuning ou RL; absorve comportamento domain-specific nos parâmetros do modelo
- **Harness adaptation**: evolui o runtime interface; captura estrutura do ambiente em artefatos externos (environment contracts, procedural skills, action templates, trajectory regulators)
- **Ambos se complementam**: model training + harness adaptation > apenas model training

## Componentes adaptáveis no harness

1. **Environment contracts** — como o ambiente expõe observações ao modelo; o que é visível, em que formato
2. **Procedural skills** — sequências de ação para tarefas recorrentes no domínio; evitam que o modelo reinvente sequências de tool use
3. **Action realization** — mapeamento de intenções do modelo em ações executáveis pelo executor
4. **Trajectory regulation** — detecção e recuperação de trajetórias degeneradas (loops, regressões, estados terminais incorretos)

## Propriedade de transferência

Harnesses evoluídos de trajetórias de um modelo transferem para outros modelos (evidenciado em 17/18 modelos no Life-Harness). Isso indica que harness adaptation captura estrutura do ambiente, não idiossincrasias do modelo específico.

## Quando harnesses parciais são melhores

Harnesses totalmente estruturados (especificando cada step) podem ser superados por harnesses parciais (especificando apenas passos iniciais) quando:
- A tarefa requer adaptação a evidências emergentes
- O agente tem capacidade suficiente para completar steps não especificados
- Over-decomposition reduziria flexibilidade sem ganho de confiabilidade

## Failure modes

- **Over-decomposition**: muitos sub-goais → agente perde capacidade de integração
- **Over-pruning**: guidance elimina ações válidas do espaço de busca
- **Hallucinated execution**: guidance que favorece seguir instrução em vez de evidências da tarefa

## Vault

O pipeline diário é um harness parcial — não especifica cada micro-step do ingest, deixando espaço para adaptação. O `guard` agent e `nexus` gates são trajectory regulators.

## Portabilidade Multi-Provider (jun/2026)

Fonte: [[03-RESOURCES/sources/managed-agents-have-a-portability-problem-i-ran-one-agent-folder-on-anthropic-google-and-open-ai]]

Harnesses evoluídos em um provider **não rodam sem ajuste** em outros providers. Problemas documentados ao mover o mesmo agent folder entre Anthropic, Google e OpenAI:

| Dependência | Anthropic | Google | OpenAI |
|-------------|-----------|--------|--------|
| Tool definition schema | sim | parcial | parcial |
| System prompt behavior | sim | diferente | diferente |
| MCP servers | sim | não | não |
| Skills/CLAUDE.md | sim | não | não |

**Implicação para vault-michel:** Agentes do vault têm lock-in significativo em Anthropic (CLAUDE.md, MCP, skills). Risco: médio. Mitigação: documentar dependências Anthropic-específicas neste ADR.

**Lição cross-provider:** A lógica de negócio (o que o agente faz) é portável; o scaffolding (como o agente é invocado) não é. Separar as duas camadas desde o design.

**omarsar0 case:** Primeiro caso documentado de Dynamic Workflows fora de Claude Code — implementado em orquestrador próprio. Evidência que o *padrão* DW é portável, mas a *implementação* específica de Claude Code não é. Ver [[03-RESOURCES/entities/omarsar0]].

## Primitivos formais de harness na API (Anthropic, jun/2026)

A doc de referência de Managed Agents expõe primitivos de "environment contract" como flags de CLI: `--workdir`, `--unrestricted-paths`, `--on-work` (script custom em vez de tools in-process), `--max-idle` (default 60s) — controles diretos de como o ambiente expõe observações e capacidades ao agente self-hosted. Ver [[03-RESOURCES/sources/reference]]. Mid-conversation system messages (Opus 4.8) formalizam outro primitivo — "placement after tool results" como canal autoritativo para absorver input assíncrono em loops agênticos sem reiniciar o turno, um trajectory-regulation nativo da API. Ver [[03-RESOURCES/sources/mid-conversation-system-messages]].

## Desacoplamento Evolver vs Agente (Lin et al., 2026)

Análise empírica controlada revela que adaptar o harness (produzir updates úteis) é **ortogonal** a beneficiar-se da adaptação. Dois novos failure modes documentados para modelos weak-tier:
- **Activation failure:** modelo não invoca o harness mesmo quando disponível (SLR 25% vs 96% strong).
- **Adherence failure:** modelo carrega o harness mas perde aderência ao longo da trajetória (-0,39 drift vs -0,09 strong).

Implicação: harness adaptation bem-sucedida requer que o agente seja treinado explicitamente em harness invocation e long-horizon instruction following. Ver [[03-RESOURCES/sources/harness-updating-not-harness-benefit]].

## Fontes

- [[03-RESOURCES/sources/life-harness-runtime-adaptation]] — Life-Harness (Peking University): +88.5% avg improvement
- [[03-RESOURCES/sources/harnesses-inference-time-alignment]] — teoria formal: harnesses parciais > totalmente estruturados
- [[03-RESOURCES/sources/ecc-agent-harness-system]] — ECC: implementação production de harness adaptation cross-harness
- [[03-RESOURCES/sources/managed-agents-have-a-portability-problem-i-ran-one-agent-folder-on-anthropic-google-and-open-ai]] — portabilidade multi-provider
- [[03-RESOURCES/sources/thread-by-omarsar0-on-thread-reader-app]] — DW portável fora do Claude Code
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — conceito raiz
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
