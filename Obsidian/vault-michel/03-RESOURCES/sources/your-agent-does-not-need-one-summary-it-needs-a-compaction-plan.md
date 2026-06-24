---
title: "your agent does not need one summary. it needs a compaction plan."
type: source
source: "Clippings/your agent does not need one summary. it needs a compaction plan..md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central

Sumarização genérica de contexto é o primitivo errado para agentes que possuem estado real (faturas, consentimento, paths de arquivo, chamadas de ferramenta falhas, limites de reembolso, valores de slot, restrições de política). Uma sumarização pergunta "o que aconteceu?"; compaction deveria perguntar "o que precisa sobreviver para o próximo turno funcionar?". O projeto `compaction-orchestrator` propõe tratar compaction como uma camada de controle explícita e inspecionável — não "resumos melhores", mas uma política por segmento sobre o que pode ser comprimido, extraído, externalizado ou mantido exatamente.

## Argumentos principais

- **Distinção central**: compaction default é otimizada para continuidade geral de um agente genérico, não para a correção específica do seu agente. A diferença só importa quando o agente possui estado real de runtime, não apenas histórico de conversa.
- **ACCS (Agent Continuity under Compaction Score)**: métrica do repositório que recompensa recall de fatos críticos, exatidão, prontidão para o próximo turno (downstream readiness), recuperabilidade, inspecionabilidade e redução de tokens; penaliza contexto retido alucinado ou irrelevante.
- **O problema ainda não tem nome claro**: falhas que parecem "burrice do modelo" são frequentemente o modelo trabalhando a partir de uma visão de contexto corrompida — reler um arquivo já inspecionado, esquecer uma instrução explícita do usuário ("não cancele, só reagende"), lembrar que o build falhou mas perder o path exato do módulo faltante, escrever um handoff que parece razoável mas larga o único campo que o próximo turno precisava.
- **Em produtos finalizados (ChatGPT, Cursor, Claude Code) a compaction é invisível** — embutida no produto. Quem constrói agente customizado possui a fronteira da chamada de modelo e decide o que entra na próxima chamada — e na prática já reinventa sua própria versão de compaction de forma ad-hoc: manter últimas mensagens, manter primeiras mensagens, fixar instruções de sistema, cortar tool outputs, guardar artefatos grandes em outro lugar, criar regras especiais para suporte/código/voz/workflows internos. `compaction-orchestrator` é proposto como nome e interface formal para essa camada que todo mundo já constrói informalmente.
- **Teste com traces reais**: o repositório permite converter sessões reais (Claude Code via `~/.claude/projects/.../*.jsonl`, Codex via `~/.codex/sessions/.../rollout-*.jsonl`) em fixtures importáveis na UI — o teste real é definir os fatos que o próximo turno precisa preservar e verificar se o plano de compaction ainda permite continuidade, em vez de usar só exemplos enlatados.
- **Compaction não é o vilão por padrão**: funciona bem para chat geral, produtos de código, conversas longas casuais. O problema começa quando a context window se torna estado de runtime (agente de suporte com identidade de cliente, IDs de fatura, política de reembolso, regras de escalonamento; agente de voz com pressão de latência, ruído de ferramenta, erros de ASR, valores de slot, estado de consentimento; agente de código com erros exatos, paths de arquivo, abordagens rejeitadas, comandos de teste, restrições do usuário).
- **A mudança de modelo mental**: uma sessão de agente não é um documento único — é estado de trabalho feito de materiais diferentes. Parte do contexto deve permanecer verbatim, parte deve se tornar erro ativo, parte deve ser sumarizada, parte deve sair da janela de runtime mas permanecer recuperável (retrieval), parte deve ser mascarada, parte deve simplesmente morrer.
- **Mix de estratégias num único turno** (exemplo do artigo): restrição do usuário → keep_verbatim; falha ativa → extract_active_error; output grande de ferramenta → externalize_for_retrieval; trabalho completo → structured_summary; handoff de suporte → preserve policy/escalation/next action; turno de voz → preserve intent/consent/slot/latency target.
- **Caso de suporte ao cliente**: um resumo genérico ("cliente tem problema de cobrança duplicada e precisa de ajuda com entitlement") parece bom, mas o próximo turno pode precisar de IDs de fatura duplicada exatos, política de reembolso específica, código de erro do serviço de entitlement, e a instrução exata do que o agente pode/não pode prometer. Perder um desses campos faz o próximo turno do agente "parecer confiante enquanto está errado".
- **Caso de agente de voz**: turnos curtos não eliminam a necessidade de compaction cuidadosa — agentes de voz reais reservam slots, cancelam compromissos, chamam ferramentas, recuperam de chamadas malsucedidas, lidam com ruído de ASR e mantêm pressão de latência. Descartar a resposta completa do scheduler pode prejudicar o próximo turno; mantê-la completa também pode prejudicar por causa do orçamento de latência — a decisão é específica do runtime, difícil de expressar como regra universal.
- **Caso de agente de código**: frequentemente não precisa de um resumo bonito — precisa de strings exatas (path de arquivo, nome de rota, comando de teste, erro de tipo, restrição do tipo "use este framework, não adicione outro"). Paráfrase faz o modelo entender a tarefa em linhas gerais mas perder o detalhe que tornaria a próxima ação correta.
- **Baselines comparados no repositório**: raw_full_context, last_n_messages, recent_token_window, front_truncation, generic_summary, rolling_summary_recent, compaction_orchestrator. O resultado relevante não é que o orchestrator vence sempre — é que resumos genéricos falham de formas previsíveis, e rolling summaries retêm mais fatos mas gastam mais contexto e ainda não oferecem nenhum "plano" inspecionável.
- **Para quem é**: builders que possuem o contexto enviado ao modelo — agentes de suporte customizados, agentes de voz, harnesses de coding agent, agentes de workflow interno, plataformas de agente que precisam de políticas de compaction diferentes por cliente/caso de uso. Não é para quem usa ChatGPT como produto, nem tenta substituir o comportamento de memória de produtos finalizados como Cursor ou Claude Code.

## Key insights

- A pergunta certa para avaliar compaction não é "a qualidade do resumo é boa?" — é "o próximo turno do agente consegue continuar corretamente depois da compaction?". Tratar "qualidade de resumo" como alvo de avaliação é descrito como "vago demais".
- O argumento não é "resumos são ruins" — é que, quando compaction afeta correção, você precisa saber o que sobreviveu, o que foi reescrito, e por quê. Compaction invisível (seja a default do framework, seja a sua própria implementação ad-hoc) já é uma admissão implícita de que essa camada de controle é necessária.
- Diferentes tipos de agente (suporte, voz, código) têm modos de falha de compaction estruturalmente diferentes — não existe uma regra universal de compaction; existe a necessidade de uma política por segmento de contexto.

## Exemplos e evidências

- Repositório: `github.com/anshulluhsna/compaction-orchestrator`.
- Implementação inclui: SDK para loops de agente, CLI para fixtures JSON, API HTTP para uso sidecar, persistência SQLite (sessões, eventos, planos, context views, conteúdo externalizado), UI web para demos/inspeção, fixtures de coding/suporte/voz, scripts de avaliação ACCS.
- Exemplo verbatim de estado de suporte que o próximo turno precisa preservar: identidade do cliente, IDs de fatura duplicada (`inv_001921`, `inv_001922`), política de reembolso, erro ativo (`entitlement_sync_failed`), próxima ação ("explicar escalonamento, não prometer reembolso instantâneo").
- Exemplo verbatim de estado de voz: ruído de ASR → remover ou sumarizar; slot selecionado → manter exatamente; estado de consentimento → manter exatamente; resposta completa do scheduler → externalizar; próximo prompt falado → manter enxuto; meta de latência → preservar como restrição.

## Implicações para o vault

Esta fonte adiciona uma camada de vocabulário e framework explícito (per-segment compaction policy, ACCS como métrica de continuidade) ao que o vault já trata implicitamente em [[03-RESOURCES/concepts/agent-systems/context-management]] e [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — especialmente relevante porque o próprio pipeline Nexus/Hermes do vault já lida com handoffs entre fases (triagem → ingest → report) onde perder o campo certo (ex. slug, score, categoria) entre fases tem o mesmo risco descrito no caso de suporte ao cliente. O argumento de "compaction por segmento, não resumo único" é diretamente aplicável ao design do `handoff-file-pattern` já catalogado no vault.

## Links

- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
