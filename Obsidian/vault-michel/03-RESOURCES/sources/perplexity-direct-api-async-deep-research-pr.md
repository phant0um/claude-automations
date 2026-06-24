---
title: "feat: perplexity: add direct API modes and async Deep Research (PR #629, mvanhorn/last30days-skill)"
type: source
source: "Clippings/feat perplexity add direct API modes and async Deep Research by sk-holmes · Pull Request 629 · mvanhornlast30days-skill.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
PR no skill `last30days` (mvanhorn) adiciona suporte direto à API Perplexity como fonte opt-in, mantendo OpenRouter como fallback do Sonar — agora com 3 modos (sonar/search/both) e Deep Research assíncrono com polling exponential-backoff, idempotência e preservação de metadados de request. Confidence score de review automatizado (Greptile): 4/5, seguro pra merge.

## Argumentos principais
- Mudanças centrais: `perplexity.py` reescrito — `_provider()` escolhe direct vs. OpenRouter, `_search_api()` cobre o caminho de Search API, `_sonar_search()` cobre síntese Sonar (sync e async), `_poll_async_sonar()` gerencia o ciclo de vida do job assíncrono com timeout configurável e preservação de metadados em timeout/falha.
- `pipeline.py`/`resolve.py` atualizados pra reconhecer `PERPLEXITY_API_KEY` como provider válido; `diagnose()` exclui corretamente Perplexity de `reasoning_provider_available` porque é fonte de dado, não planejador/sintetizador — distinção arquitetural explícita entre "fonte de busca" e "modelo de raciocínio".
- `check-config.sh` substitui pipeline `sed`/`tr` por helpers puro-bash (`trim_ws`/`strip_outer_quotes`) — mesma semântica de matching, menos dependência externa.
- 9 testes focados cobrindo seleção de provider, os 3 modos, simulação de timeout, casos FAILED/POLL_ERROR e skip por chave ausente.
- Gap identificado pelo review automatizado: resposta COMPLETED malformada (campo `response` não-dict) levanta `http.HTTPError` simples em vez de `AsyncDeepResearchFailed` — handler externo retorna `[], {}` sem ID de request async, tornando o job irrecuperável a partir do artefato isolado. Edge case, não afeta caminho normal.

## Key insights
- Separar explicitamente "fonte de dado" (Perplexity, busca) de "provider de raciocínio" (modelo que planeja/sintetiza) na função `diagnose()` é um padrão de design limpo que evita o erro comum de tratar toda integração de API como intercambiável no mesmo slot.
- Review automatizado (Greptile) com confidence score numérico + diagrama de sequência + lista de arquivos importantes é um formato de PR review que vale de referência — sinaliza gap específico (não bloqueante) em vez de aprovação binária.

## Exemplos e evidências
- Modos: `LAST30DAYS_PERPLEXITY_MODE=sonar|search|both`.
- `.gitignore` ganha `.env`/`.env.*` preservando `.env.example` — previne commit acidental de secret.
- Diagrama de sequência documentando os 4 caminhos (search, both, sonar sync, sonar async com polling) entre caller, provider resolver, e API.

## Implicações para o vault
Skill `last30days` (mvanhorn) já aparece referenciado indiretamente no ecossistema de skills deste vault (mesmo autor de outras fontes do batch). Padrão de "fonte de dado vs. provider de raciocínio" é aplicável ao próprio `model-router.md` deste vault — vale verificar se a mesma distinção já é explícita lá ou se é um gap de nomenclatura entre tipos de provider.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-orchestration]]
