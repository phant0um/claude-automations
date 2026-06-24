---
title: "Mythos (Fable) has big model smell"
type: source
source: "Clippings/Mythos (Fable) has big model smell.md"
url: "https://x.com/seejayhess/status/2064400742220263796"
author: "@seejayhess"
published: 2026-06-09
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central

Relato em primeira pessoa do uso de **Mythos/Fable** (novo modelo Claude) descrevendo que ele tem "big model smell" — a sensação rara de que o modelo do outro lado é genuinamente surpreendente: raciocina sobre o problema e encontra um caminho que o usuário não teria pensado. O autor diz ter sentido isso apenas três vezes antes (o1 no lançamento, GPT-5.5, Opus 4.5), e Fable é a quarta e mais forte ocorrência.

## Argumentos principais

- **"Big model smell" definido**: o modelo é "pesado" mas não desperdiça esse peso — pensa bastante e então faz a versão inteligente da tarefa, não a óbvia.
- **Scripts em vez de edições manuais**: numa migração de Zod 3 → Zod 4, Codex pesquisou e foi arquivo por arquivo fazendo updates. Fable pesquisou por muito tempo (autor quase cancelou) e então produziu um único script Python que atualizou programaticamente toda a base de código — entendeu o problema bem o suficiente para escrever a ferramenta que o resolve, e então a usou. Economizou tokens e foi correto.
- **Planejamento de alto nível mais robusto**: o padrão usual é "o plano parece ótimo, a execução começa, a realidade bate" (passo 4 contradiz passo 7). Com Fable, planos de POC se mantiveram — o modelo reteve contradições e detalhes na "cabeça" em vez de descartá-los ao começar a codificar. Autor relata ter digitado "ok, próximo passo" por uma hora seguida.
- **Orquestração multi-agente em escala**: repo com ~50 planos históricos desatualizados/divergentes (drift). Tarefa: tornar o repo "pristino", anotando cada plano antigo com o que está obsoleto, o que foi substituído, onde a direção real divergiu do escrito.
- **Remoção de duplicação não solicitada**: durante o desenvolvimento de uma feature, Fable identificou sozinho que três implementações de "agent-driver" estavam duplicadas pelo codebase e as unificou — resultando em um diff negativo (líquido removeu código). O autor nota que toda IA que usou antes trata a instrução "caçar duplicação" no CLAUDE.md como ruído de fundo; precisa apontar explicitamente. Fable trouxe isso à tona sozinho, mid-feature.
- **Limitações persistem**: ainda é "um modelo Claude" — autor ainda precisou pedir para remover comentários bobos, ainda há over-explaining, scaffolding solto, flourishes não pedidos. Não é autonomia perfeita.
- **A "smell" não é autonomia, é nitidez**: "the thing you're steering is sharper than what you're used to."

## Key insights

- **Mudanças de workflow do autor por causa disso**:
  1. Trabalho do tipo "migração" agora vira script, não edição manual — já adicionado ao CLAUDE.md global do autor após observar o modelo fazer isso sem ser instruído.
  2. Parou de cancelar runs quando o modelo "pensa por muito tempo" — orçamentos de pesquisa longos estão valendo a pena.
  3. Vai colocar workflows reais na frente do modelo — sente que ele "domina" isso.
- "Big model smell sempre aparece antes dos benchmarks confirmarem" — aprender a notar isso cedo é descrito como o instinto mais útil a desenvolver agora.
- Histórico de "big model smell" sentido pelo autor: o1 (lançamento), GPT-5.5 (meses recentes), Opus 4.5, e agora Fable/Mythos (o mais forte).

## Exemplos e evidencias

- **Caso 1 — migração Zod 3→4**: Codex = file-by-file manual; Fable = pesquisa extensa + script Python único que migra tudo programaticamente.
- **Caso 2 — POC platforms**: planos de alto nível sobreviveram à execução real, ao contrário do padrão usual.
- **Caso 3 — limpeza de 50 planos históricos**: 15 milhões de tokens, 294 subagentes, mais de 100 pontos de edição encontrados e corrigidos em uma passada + run de confirmação que pegou só 2-3 itens residuais. Comparação: versão anterior rodando em Opus precisou de 5-6 passadas para chegar a dígitos únicos de pendências.
- **Caso 4 — deduplicação espontânea**: três implementações de agent-driver unificadas, feature shipada com diff negativo.

## Implicacoes para o vault

- Reforça o conceito **[[03-RESOURCES/concepts/ai-strategy-org/mythos-moment-ai]]** (já existente) — embora aquele concept trate de "mythos moment" para browser agents (memória via skill graduation, Kyle Jeong), este artigo usa "Mythos/Fable" como nome do modelo Claude em si. Vale registrar que "Mythos" aparece tanto como codinome de modelo quanto como termo conceitual de inflexão — checar se há confusão de nomenclatura a resolver numa revisão futura.
- O padrão "escreve um script para resolver a tarefa em vez de editar manualmente" é uma instância concreta do princípio de **harness/agentic engineering**: delegar trabalho repetitivo determinístico a uma ferramenta gerada pelo próprio agente. Relevante para `[[03-RESOURCES/concepts/agent-systems/harness-engineering]]` e para o padrão de scripts do vault SO.
- A observação sobre orquestração multi-agente em escala (294 subagentes, 15M tokens, drift de planos) é um caso real de "self-cleaning repo" — relevante para `[[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]]` e `[[04-SYSTEM/agents/core/hill]]` (melhoria contínua / detecção de drift).
- Complementa `[[03-RESOURCES/sources/designing-loops-with-fable-5]]` — aquele artigo cobre Fable 5 em benchmarks formais (Parameter Golf, Continual Learning Bench); este é um relato qualitativo/anedótico do mesmo modelo em uso real.

## Links

- [[03-RESOURCES/concepts/ai-strategy-org/mythos-moment-ai]]
- [[03-RESOURCES/sources/designing-loops-with-fable-5]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
