---
title: "Codex 推出的 Record & Replay，操作一遍就能生成 Skill"
type: source
source: "Clippings/Codex 推出的 Record & Replay.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, claude-code-tooling]
---

## Tese central
OpenAI lança Record & Replay no Codex: demonstrar uma vez uma tarefa repetitiva no Mac (com Computer Use) gera automaticamente um Skill inspecionável/editável, reutilizável na próxima vez que a mesma tarefa aparecer — elimina a necessidade de escrever o Skill manualmente.

## Argumentos principais
- Cálculo de ROI explícito: tarefa de 10min/dia × 240 dias úteis/ano = 40h/ano (~5 dias de trabalho) — justificativa quantitativa para automatizar mesmo tarefas pequenas se repetidas com frequência.
- 4 critérios para saber se uma tarefa é boa candidata a gravação: ocorre semanal/diariamente; passos relativamente fixos; tem convenção própria de nomenclatura/preenchimento; resultado final é claramente verificável.
- Processo recomendado: declarar objetivo + variáveis que mudam a cada execução + limites de execução (pausar se faltar info, não inventar dado, esperar confirmação antes de submit/publish/overwrite) ANTES de gravar — Codex vê a ação mas não sabe necessariamente o porquê.
- Validação obrigatória pós-geração: testar o Skill gerado numa nova thread, trocando os valores variáveis (novo arquivo, nova data) — só then confirma que o fluxo é de fato reutilizável, não apenas uma gravação literal de uma execução específica.
- Aviso de segurança explícito: gravação lê conteúdo de tela e eventos de operação — não incluir senha, dados de cliente, informação financeira ou chat privado na demonstração; usar conta de teste e dados fictícios.

## Key insights
- O processo de "declarar objetivo + variáveis + limites de execução ANTES de gravar" é estruturalmente idêntico ao framework de Intent Engineering (Objective/Constraints/Stop Rules) já ingerido nesta leva — confirmação prática (produto real, não só teoria) do mesmo padrão.
- "Testar o skill gerado trocando as variáveis antes de confiar nele" é o mesmo princípio de "verificador não pode ser editado pelo próprio executor" — aqui aplicado como autoteste de generalização, não só replay literal.

## Exemplos e evidências
- Caso de uso real: publicação de vídeo com upload, título, descrição, tags, capa, visibilidade — fluxo gravado uma vez, reutilizado trocando só arquivo e título.
- Limitação atual: só macOS, requer Computer Use habilitado, ainda não cobre EEE/UK/Suíça.

## Implicações para o vault
Referência de processo (não ferramenta usada aqui) para qualquer fluxo repetitivo deste vault que envolva GUI fora do terminal — caso surja necessidade de automatizar algo fora do alcance de scripts/CLI.

## Links
- [[03-RESOURCES/sources/the-intent-engineering-framework-for-ai-agents]]
- [[03-RESOURCES/sources/ai-claude-code-skill]]
