---
title: How to Build an AI GTM Brain using Claude Code
type: source
source: "Clippings/How to Build an AI GTM Brain using Claude Code.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
Um "GTM brain" é um sistema agentic que substitui o trabalho de julgamento (quem contatar, por quê, agora, e o que dizer) que o "envio em massa" tradicional não resolve. O sistema roda como um loop de cinco partes — Sense, Remember, Judge, Act, Learn — construído incrementalmente via prompts no Claude Code, com uma camada de "contrato" (boundary layer) desacoplada de vendors específicos.

## Argumentos principais
- **O problema real não é volume, é julgamento**: "send mais rápido" parou de funcionar; o que importa é decidir QUAL empresa contatar, POR QUE AGORA, e O QUE dizer que prove que você notou algo específico sobre ela.
- **Modelo mental**: pessoas recebem UX, software recebe API, agente recebe linha de comando — o sistema roda via CLI agendado (cron).
- **Passo 1 — Contrato/boundary layer primeiro**: escrever a fronteira ANTES de qualquer código de agente. Código nunca deve hardcodar nome de vendor (intent tool, email tool). Define só duas formas: `Signal` (dataclass: account, bucket, summary, contact — bucket ∈ {job, social, company, funding}) e dois adapters (`SignalSource.fetch() -> list[Signal]`, `Delivery.send(draft, dry_run=True) -> str`), com versões "stub" que retornam dados fake — loop roda fim-a-fim antes de qualquer integração real.
  - Erro comum: deixar o código chamar `apollo_search` ou `instantly_send` diretamente — solda tudo a um vendor; trocar de ferramenta vira reescrever as 5 partes. Manter os 2 shapes = troca custa 1 adapter novo.
- **Passo 2 — Sense (sentir o mercado)**: monitora 4 tipos de "movimento" que carregam peso real: **Job** (vaga aberta/repostada, alguém assume cargo com orçamento), **Social** (empresa engaja concorrente ou posta sobre o problema que você resolve), **Company** (lançamento, expansão, mudança de stack), **Funding** (rodada/aquisição com mandato e orçamento novo). `sense()` valida buckets e grava na memória ANTES de qualquer julgamento; `cluster_by_account()` agrupa sinais por conta no mesmo run — duas ocorrências na mesma conta = sinal mais forte que cada uma isolada.
  - Erro comum: sentir tudo e não ranquear nada — tratar um like esporádico igual a uma rodada de funding. Cluster na entrada, não empurrar a bagunça para o judge.
- **Passo 3 — Remember (memória por conta)**: SQLite único, zero setup. Tabelas: accounts, signals, touches, outcomes. Métodos-chave: `record_signal`, `record_touch() -> touch_id`, `record_outcome(account, touch_id, result)` (replied | meeting | no_reply | bounced), `history(account) -> dict` (retorna tudo: sinais + touches + outcomes em uma chamada), `last_touch_age_days(account)`.
  - Por que importa: uma 3ª rodada de funding significa coisa completamente diferente se você já mandou 2 emails e levou silêncio — sem histórico, trata conta quente igual fria.
  - Erro comum: maioria dos times pula essa parte, julga o sistema pelo output "cold start" genérico, e desliga na semana 3 — uma semana antes do histórico tornar o sistema afiado.
- **Passo 4 — Judge (decidir quem e por quê agora)**: aqui o Claude faz o trabalho real — lê o sinal novo, puxa o histórico completo da conta, considera o ICP, e decide: vale a pena contatar agora? por quê? qual "play" rodar? Implementação: `judge(account, new_signals, icp, memory)` monta payload JSON `{icp, new_signals, history, days_since_last_touch}`, chama Claude (modelo `claude-sonnet-4-6`, temperature 0) com system prompt carregado de `prompts/judge.md` (não hardcoded no código — fica editável), parseia em `Verdict(score, why_now, play, rationale)`. Em falha de chamada/JSON malformado, fallback para heurística de pesos por bucket — run nunca quebra no meio.
  - Erro comum: pontuar um sinal sem a memória — modelo não distingue conta já perseguida 2x de conta nunca tocada, repete a mesma abordagem e soa como stalker.
- **Passo 5 — Act (agir no gatilho)**: só escreve depois que o judge decidiu quem e por quê. Regra central: **"quote the trigger back"** — "Vi que você abriu uma vaga de Head of RevOps, segunda contratação de ops este trimestre" em vez de "Hi {{firstName}}". Se a mensagem pudesse ter saído sem alteração mês passado, o gatilho foi ignorado. `act(verdict, trigger, sequences, delivery, memory, dry_run=True)`: em veredito "skip" não faz nada; senão manda trigger + play + guardrails (de `config/sequences.yaml`) ao Claude com system prompt de `prompts/draft.md`, parseia `{subject, body}`, chama `delivery.send(draft, dry_run)`, registra o touch.
  - `dry_run=True` é o default até flag `--live` — imprime o draft, não envia nada.
  - Erro comum: ligar delivery ao vivo antes de revisar o output — sistema autônomo manda um opener confiante e errado para toda a lista antes de humano ver. dry-run é default; `--live` é decisão explícita.
- **Passo 6 — Learn (aprender com o retorno)**: agente que nunca aprende é só um script mais rápido. `record_result()` loga outcome; `adjust_weights()` reponderá os 4 buckets por win rate (vitórias/touches) com piso para nenhum bucket zerar; `best_variant(min_sample=10)` retorna o prompt de draft com melhor reply rate quando há amostra real, senão o default. Roda semanalmente; orquestrador lê os novos pesos no próximo run.
  - Erro comum: logar envios mas nunca outcomes — sem dado de resultado os pesos nunca mudam, você comprou um scheduler caro.
- **Wiring final**: `run.py` carrega configs + adapters stub, e a cada run: sense → cluster → judge cada conta → act nos não-skip → registra tudo na memória. Imprime uma linha ranqueada por conta. Suporta `--offline` (heurística, sem API key) e `--live`. Default = dry run. Cron diário roda tudo.

## Key insights
- Os dois prompts (`judge.md` e `draft.md`) são os ÚNICOS componentes usados em TODO run — todo o resto é construído uma vez e esquecido. São os que vale a pena manter editáveis e tunar continuamente.
- **Prompt do judge**: scoring explícito — 80-100 (ICP forte + sinal de alta intenção, ex: funding ou 2 sinais clusterizados no mesmo run); 50-79 (boa fit, 1 sinal sólido); 20-49 (fit fraco ou sinal único de baixa intenção); 0-19 (fora do ICP ou ruído). Regras: se `days_since_last_touch < 7`, preferir "nurture"/"skip", nunca "first_touch"; sinal fraco/conta fora do ICP → score baixo + "skip" ("dizer não faz parte do trabalho"); `why_now` deve citar o gatilho real, nunca proposta de valor genérica. Output: JSON puro `{score, why_now, play, rationale}`.
- **Prompt de draft**: subject (6-9 palavras) + body (3-5 frases). Regras: abrir com o gatilho (primeira frase nomeia o que a conta acabou de fazer — nunca "Hi {{firstName}}"); conectar gatilho a UM problema que você resolve, em uma frase; fechar com um pedido de baixo atrito (15min ou one-pager); frases humanas de tamanho variado, sem urgência falsa, sem "circling back", sem em-dashes, sem buzzwords.
- "Comece com dois": não precisa dos 5 de uma vez — construa Memory primeiro, depois Judge em cima dela. Aponte para dados stub, rode dry por uma semana, depois conecte UMA fonte real de sinal.

## Exemplos e evidencias
- Autor roda uma "frota" desse tipo de sistema na Sortlist por ~$400/mês em tokens; cancelaram 5 contratações planejadas para o ano porque o trabalho roda no orçamento de tokens.
- Cron de exemplo: `0 8 * * * cd ~/gtm-brain && .venv/bin/python run.py`.
- Coverage de sinais real vem de "Signals" (ferramenta de intent própria da Sortlist), mas o princípio vale comprando ou raspando por conta própria.

## Implicacoes para o vault
Não é um agente de PKM, mas é um exemplo concreto e replicável de **arquitetura agentic em camadas com dry-run default + memória estruturada + loop de aprendizado por pesos** — padrão aplicável a outros pipelines do vault (ex: pipeline-ads, ingest). Reforça princípios já presentes em [[03-RESOURCES/concepts/agent-systems/agent-loop-design]] e [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]:
- "Boundary layer antes do código" = aplicação prática do princípio de desacoplamento de vendor — relevante para qualquer integração futura do vault com APIs externas.
- "history() retorna tudo em uma chamada" e "Compiled Truth vs append-only log" (ver fonte do gbrain) são variações do mesmo padrão de estado central consultável.
- Estrutura de scoring numérico + fallback heurístico é um modelo replicável para qualquer "judge" agentic no vault (ex: triagem de Clippings por relevância).

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]]
- [[03-RESOURCES/entities/Claude Code]]
