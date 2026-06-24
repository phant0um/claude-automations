---
title: How to Build a Claude Code Agent That Fixes Its Own Bugs in a Loop (Exact Setup Inside)
type: source
source: "Clippings/How to Build a Claude Code Agent That Fixes Its Own Bugs in a Loop (Exact Setup Inside).md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Por padrão, Claude roda uma tarefa uma vez: um teste falha, ele reporta o erro e espera você colar de volta e pedir para tentar de novo — você está fazendo o debug, ele só está digitando. Um agente auto-corretivo inverte isso: lê sua própria falha, classifica o tipo de erro, corrige a causa, e roda de novo até passar, com setup de três arquivos descrito em 5 minutos.

## Argumentos principais
- **Arquivo 1 — comando `/fix`** (`.claude/commands/fix.md`): define um loop explícito — implementar a tarefa, rodar a suite de testes, se passar parar e mostrar, se falhar classificar o tipo de erro/nomear a causa raiz/corrigir essa causa e voltar ao passo 2, com cap de 5 tentativas anunciando o número da tentativa a cada rodada. A regra central: "classify-then-fix" — diagnóstico antes de edição, toda rodada; nunca enfraquecer um teste para passar, corrigir o código.
- **Arquivo 2 — hook de auto-checagem** (`.claude/settings.json`, `PostToolUse` matching `Write|Edit`): roda os testes automaticamente após cada edição e devolve o resultado à visão do agente, fazendo a checagem automática em vez de sob demanda — uma falha aparece imediatamente, então o agente a corrige no mesmo fluxo em vez de empilhar mudanças sobre código quebrado.
- **Arquivo 3 — protocolo de leitura de erro** (em `CLAUDE.md`): o arquivo que separa um debugger real de um "adivinhador". A maioria dos agentes vê "teste falhou" e começa a editar aleatoriamente; um bom agente lê o tipo de erro primeiro porque cada tipo aponta para uma causa diferente:
  - Assertion failure (esperado X, obteve Y): lógica errada — rastrear de volta da asserção até onde o valor foi construído, corrigir o cálculo, não a expectativa do teste.
  - Type error / undefined is not a function: descompasso de forma — algo é nulo ou do tipo errado chegou nessa linha; achar onde o valor se origina, proteger ou corrigir ali.
  - Timeout / hang: um `await` faltando, ou uma promise que nunca resolve — procurar chamadas async sem await, ou condição que nunca vira.
  - Import / module not found: problema de caminho/dependência, não de lógica — corrigir o caminho ou instalar, não tocar no código que o usa.
  - Flaky (passa às vezes): estado compartilhado ou timing, nunca aleatório de fato — procurar testes dependentes de ordem ou tempo/rede não mockados.
  - Regra explícita: nomear o tipo e a causa raiz em uma frase, em voz alta, antes de editar; se não consegue nomear a causa, está adivinhando — pare.

## Key insights
- Erro mais comum identificado: "fixing before diagnosing" — um agente que edita antes de nomear o tipo de erro está adivinhando, e adivinhar transforma vermelho em verde por sorte, não por correção real.
- "Patching the symptom" (envolver uma chamada que lança erro em try/catch faz o teste passar e deixa o bug) é proibido explicitamente pelo protocolo, pela mesma razão estrutural.
- "Letting it weaken tests": um agente com permissão para editar testes eventualmente vai deletar o teste que falha para chegar a verde — uma suite passando que não prova nada é o pior resultado possível, então essa regra é não-negociável.
- Frase de encerramento do autor: "o agente não ficou mais inteligente, ele só parou de devolver o problema para você."

## Exemplos e evidências
- Exemplo de output real mostrado passo a passo: tentativa 1 (assertion failure, causa = paginação não aplicada à query, corrigida a cláusula LIMIT) → tentativa 2 (type error, offset undefined, causa = página 1 não envia offset, default errado, corrigido com `offset = (page-1)*size`) → tentativa 3 (todos os 7 testes verdes) — "Fixed in 3 attempts. Review the diff?"
- Setup completo cronometrado em 5 minutos: 2 min para criar `fix.md`, 1 min para o hook em `settings.json`, 1 min para o protocolo em `CLAUDE.md`, 1 min para rodar `/fix` num bug conhecido.
- Código YAML/JSON/Markdown completo e literal fornecido para os três arquivos, prontos para copiar.

## Implicações para o vault
Este artigo e "How to Build a Claude Code Agent That Optimizes Code in a Loop" (mesmo batch, mesma estrutura de "3 arquivos + 5/10 min") formam um par de receitas práticas e imediatamente aplicáveis para `[[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]` e `[[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]` — aqui especificamente no domínio de correção de bugs via testes, complementando o domínio de otimização de performance do artigo irmão. O conceito "classify before fix" é uma instância concreta e nomeável do estágio Reason/Observe do ciclo perceive-reason-act-observe já documentado em outras sources deste batch (loop engineering em quant research) — vale cross-referenciar como o mesmo padrão aplicado a debugging de software em vez de pesquisa de fatores financeiros.

## Links
- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/agent-systems/agent-error-correction]]
- [[03-RESOURCES/entities/Claude Code]]
