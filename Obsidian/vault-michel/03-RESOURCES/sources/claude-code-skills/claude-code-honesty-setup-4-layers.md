---
title: "How to Make Claude Code Stop Making Stuff Up When It Doesn't Know"
type: source
source: "Clippings/How to Make Claude Code Stop Making Stuff Up When It Doesn't Know (Exact Setup Inside).md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central

Claude Code "mente" (fabrica funções, imports, resultados de teste) não porque o modelo é ruim, mas porque é um preditor de texto: quando não sabe algo, gera texto que *parece* certo, e nada no setup padrão torna essa fabricação verificável ou cara. A correção não é um modelo mais inteligente — é um setup de 4 camadas que torna a saída checável em tempo real e torna "eu não sei" mais barato que adivinhar.

## Argumentos principais

- O problema central é a ausência de uma "licença para dizer 'não sei'": Claude foi treinado para parecer útil, e admitir incerteza parece o oposto disso, então ele adivinha — e a adivinhação tem a mesma confiança aparente que a verdade.
- A solução não é um único fix, é uma pilha de 4 camadas independentes que juntas reduzem a fabricação a quase zero: regras explícitas (CLAUDE.md), protocolo de verificação antes de escrever, hooks que rodam type-checker/linter/testes em tempo real, e um subagente fact-checker que audita claims antes de commits/entregas.
- A última camada (subagente) só funciona se for de fato invocada — um subagente que existe mas nunca é chamado não ajuda.
- O hábito do usuário é "metade do fix": recompensar "não verifiquei isso" com paciência mantém o comportamento honesto; punir com frustração faz o modelo voltar a adivinhar. Isso não é configuração, é hábito de interação.

## Key insights

**Layer 1 — Honesty rules no CLAUDE.md** (primeiras ~50 linhas, porque Claude tende a skimar o resto):
- Antes de afirmar que uma função/classe/import existe, verificar lendo o arquivo ou rodando grep. Nunca fabricar símbolos.
- Se não puder verificar, dizer explicitamente "I haven't verified this" e não escrever código que dependa dessa claim não verificada.
- Se uma tarefa pede uma lib nunca referenciada no projeto, perguntar antes de adicionar.
- Não afirmar sucesso de testes/build a menos que tenha rodado o comando *nesta sessão*.
- Nunca inventar mensagens de erro, respostas de API, ou stack traces.
- A regra mais importante: quando genuinamente não souber, a resposta correta é "eu não sei" ou "preciso checar primeiro" — ambas melhores que um chute confiante.

**Layer 2 — Protocolo de verificação antes de escrever**:
- Antes de usar um símbolo (função/classe/tipo/constante) em código novo: (1) ler o arquivo onde é definido e confirmar a assinatura, (2) rodar `grep -r "symbolName" .` ou usar Glob, ou (3) checar package.json/requirements.txt/Cargo.toml para a dependência.
- Se pular a verificação, prefixar o código com `// UNVERIFIED: I have not confirmed this symbol exists`.
- Plan mode (Shift+Tab) é preferido para qualquer tarefa que toque mais de um arquivo.

**Layer 3 — Hooks que pegam mentiras em tempo real**:
- `PostToolUse` hooks rodando `tsc --noEmit`, `ruff check` + `pyright`, ou `cargo check` a cada Write/Edit em arquivos do tipo correspondente — output volta para o contexto do Claude, que precisa corrigir antes de declarar "done".
- `Stop` hook rodando a suite de testes (`npm test`) antes da sessão poder ser declarada concluída — Claude não pode dizer "done, tests pass" sem que o hook efetivamente os rode.
- Requisito crítico: output dos hooks precisa voltar ao stdout/contexto da sessão, senão Claude "mente sem saber que mentiu".

**Layer 4 — Subagente fact-checker** (`.claude/agents/fact-checker.md`):
- Tools: Read, Grep, Glob, Bash. Model: sonnet. Função única: revisar claims, nunca escrever código.
- Processo: (1) identificar toda claim factual na conversa recente ("a função X faz Y", "os testes passaram", "a lib Z suporta W", "este import está correto"); (2) verificar cada uma independentemente — código lendo o arquivo, testes rodando-os, libs checando o pacote/docs, imports checando o manifest de dependências; (3) produzir relatório com três categorias: VERIFIED (claim + evidência file:line ou output de comando), WRONG (claim + o que é verdade), UNVERIFIABLE (claim + por que não dá pra checar).
- Regra: nunca aceitar claims "trust me", nunca fazer claims próprias — se não der pra verificar, o output correto é UNVERIFIABLE.
- Deve ser invocado antes de commits ou de compartilhar resultados com o time.

## Exemplos e evidências

**3 sinais de que o setup está funcionando**:
1. Claude pergunta antes de adicionar dependências ("devo adicionar X ou usar a stdlib?") em vez de `npm install` silencioso.
2. Claude referencia file:line ao falar de código existente ("`validateToken` em `src/auth/middleware.ts:47` faz Y") em vez de "a função validateToken faz Y".
3. `tsc` e o linter param de gritar — hooks pegam fabricações raras instantaneamente e Claude se autocorrige.

**Erros comuns que mantêm Claude mentindo**:
- CLAUDE.md longo demais — Claude lê o início e skima o resto; regras de honestidade precisam estar nas primeiras 50 linhas.
- Hooks que logam silenciosamente — se o output não chega ao stdout, Claude não sabe que mentiu.
- Pular plan mode — é o momento mais barato para expor suposições erradas antes de escrever código.
- Não chamar o fact-checker — um subagente só funciona se for de fato invocado no fluxo de commit.
- Reagir mal a "eu não sei" — punir a honestidade uma vez derruba as outras 3 camadas.

**Audit de 5 minutos** (setup completo): 1 min copiar honesty rules + verification protocol pro CLAUDE.md do projeto; 1 min copiar o bloco de hooks pro `settings.json` (global ou de projeto); 2 min criar `.claude/agents/fact-checker.md`; 1 min rodar uma tarefa que normalmente seria double-checada e confirmar que Claude diz "verified" ou "I haven't verified this" explicitamente.

## Implicações para o vault

- O vault-michel já tem um agente `verify` (`04-SYSTEM/agents/verify`) e um conceito de receipt protocol (ready/blocked) vindo de [[03-RESOURCES/sources/10-claude-code-subagents-kept]] — esta fonte **confirma e complementa** essa direção, com foco específico em fabricação de fatos/símbolos em vez de escopo de edição.
- O fact-checker desta fonte é um subagente diferente (mas compatível) do `done-checker`/Merge Gate da outra fonte: este foca em verificar *claims factuais* (símbolos, testes, libs), aquele agrega *receipts* de outros agentes para decisão go/no-go. Poderiam coexistir na mesma cadeia.
- A regra "honesty rules nas primeiras 50 linhas do CLAUDE.md" é um dado prático aplicável diretamente ao `CLAUDE.md` do vault — vale considerar se as regras de verificação (já presentes via Karpathy principles) estão posicionadas cedo o suficiente.
- O hook pattern (`PostToolUse` com tsc/ruff/cargo) não se aplica diretamente ao vault (não é um projeto de código compilado), mas o princípio — "checagem automática que retorna ao contexto" — é análogo a hooks de hot-cache/manifest já existentes.

## Links
- [[03-RESOURCES/sources/10-claude-code-subagents-kept]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-subagents]]
- [[04-SYSTEM/agents/core/verify]]
- [[04-SYSTEM/agents/core/guard]]
