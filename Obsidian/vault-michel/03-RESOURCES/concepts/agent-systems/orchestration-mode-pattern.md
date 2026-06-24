---
title: Orchestration Mode Pattern
type: concept
created: 2026-06-06
updated: 2026-06-06
tags: [agent-systems, orchestration, multi-agent-systems, claude-api, harness-engineering, prompt-caching]
---

# Orchestration Mode Pattern

Padrão oficial documentado pela Anthropic em [[03-RESOURCES/sources/build-an-orchestration-mode]]: um **interruptor de nível de sessão** que, ligado, faz o modelo aplicar máxima minúcia em toda solicitação substantiva — explora a tarefa sozinho e distribui (fan out) o trabalho para subagentes paralelos *por padrão*; desligado, a mesma ferramenta volta a exigir opt-in por solicitação. Não é parâmetro de API — é construído inteiramente com peças já documentadas e públicas.

## As 3 peças que montam o modo

1. **Effort `xhigh`** — nível de esforço documentado, sem nível oculto acima dos publicados.
2. **Mode reminder (mensagem de sistema mid-conversation)** — avisa o modelo que o modo está ativo, com refresco curto a cada N rodadas e aviso de saída ao desligar. Crucialmente, **vem DEPOIS do turno do usuário** — preserva o prefixo cacheado intacto (ver [[03-RESOURCES/concepts/agent-systems/prompt-caching]]). É deliberadamente curto: só "vira a chave" e aponta para a descrição da ferramenta, onde vivem as instruções pesadas — fonte única da verdade comportamental, eco do "trim ruthlessly" de [[03-RESOURCES/concepts/agent-systems/compound-engineering]].
3. **Standing consent na descrição da ferramenta** — a tool `Workflow` carrega o "contrato comportamental": enquanto o modo está ligado, o modelo deve "autorar e rodar um workflow para toda tarefa substantiva sem perguntar antes. Trabalhe sozinho só em turnos conversacionais ou edições mecânicas triviais."

## Fluxo de execução: scout → fan out → verify

- **Padrão híbrido default**: explorar inline primeiro (descobre a lista de trabalho), depois distribuir sobre ela — instância concreta do [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]].
- **Granularidade**: cada subtarefa = uma preocupação/componente/questão distinta (não linha ou seção de arquivo). Revisão de módulo de poucas centenas de linhas raramente passa de ~10 subtarefas; auditoria de codebase grande pode justificar mais.
- **Subagentes** devolvem resultado estruturado via `report_findings` (JSON, não prosa), rodando `bash_20250124` localmente.
- **Segunda onda — verificação adversarial**: reusa o mesmo caminho de subagente para tentar REFUTAR cada resultado da primeira leva. Cada verificador re-deriva a alegação a partir da fonte por conta própria, "default to refuted if uncertain", citando arquivo:linha ou saída de comando que decidiu o veredito. Resultado original + veredito voltam ao orquestrador, que pesa os dois juntos.
- **Journal idempotente por hash de conteúdo (SHA-256)**: antes de despachar, busca o hash do prompt; se já existe, devolve o resultado gravado. Torna o fan-out resumível — interromper e re-rodar recomputa só o que nunca terminou. Deduplica entre runs, não dentro de uma onda.

## Padrões de design reutilizáveis

- **`MAX_CONCURRENT` ≠ `MAX_TOTAL_SUBTASKS`**: separar "quantos rodam ao mesmo tempo" de "quantos o modelo pode enfileirar" — permite planejar backlog grande sem disparar tudo de uma vez.
- **Isolamento de falhas**: subagente que falha degrada para string de erro, não encerra a corrida inteira.
- **Custo é explícito**: "o fan-out multiplica uso de tokens — reserve o modo para trabalho que justifique o custo." ROI condicional, não é grátis.

## Caminho para produção (3 adições recomendadas além do exemplo)

1. **Scripts de orquestração sandboxed** — modelo emite programa pequeno (branching/loops/redução) rodado em interpretador isolado, em vez de lista plana de strings.
2. **Journaling durável** — substituir JSON local por storage que sobrevive a reinícios e é seguro sob escritores concorrentes multi-máquina.
3. **Budget enforcement** — rastrear total de subagentes lançados na SESSÃO inteira (não só por chamada), com teto rígido.

O texto enfatiza: **os padrões carregam-se inalterados** (mode reminder, standing consent, journaling, onda de verificação) — só o substrato de execução fica mais robusto. Aviso de risco explícito: o exemplo roda comandos escritos pelo modelo direto na máquina, **sem sandbox**.

## Por que importa

- Implementação oficial e documentada do mesmo padrão que [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] e [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]] descrevem em alto nível — referência canônica para essas páginas.
- Replicável no setup atual do vault: candidato a padrão para os agentes `00-core` (toggle de modo + standing consent documentado na descrição da tool + segunda onda adversarial).
- Contraste instrutivo com [[03-RESOURCES/concepts/agent-systems/compound-engineering]]: lá o "consentimento" é decisão manual do usuário (invocar sub-agente quando quiser); aqui é codificado de uma vez na ferramenta — duas filosofias de onde colocar o "interruptor" de autonomia.
- Técnica de cache-preservation (mensagem de sistema após turno do usuário) é detalhe pouco discutido em fontes anteriores do vault — relevante para qualquer rotina que precise mudar comportamento mid-sessão sem invalidar cache (ex.: pipeline-diario, rotinas longas).

## Related
- [[03-RESOURCES/sources/build-an-orchestration-mode]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/prompt-caching]]
- [[03-RESOURCES/concepts/agent-systems/compound-engineering]]
