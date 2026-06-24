---
title: "shanraisshanclaude-code-best-practice from vibe coding to agentic engineering - "
type: source
source: clipping
created: 2026-05-01
updated: 2026-05-01
tags: [clipping, ai-agents, tools]
triagem_score: 7
---

# shanraisshanclaude-code-best-practice from vibe coding to agentic engineering - 

**Source File:** shanraisshanclaude-code-best-practice from vibe coding to agentic engineering - practice makes claude perfect.md  
**Size:** 50253 bytes

## Summary

--- title: "shanraisshan/claude-code-best-practice: from vibe coding to agentic engineering - practice makes claude perfect" source: "https://github.com/shanraisshan/claude-code-best-practice" author: published: created: 2026-05-01 description: "from vibe coding to agentic engineering - practice makes claude perfect - shanraisshan/claude-code-best-practice" tags: - "clippings" --- ## claude-code

---

**Original Location:** `Clippings/shanraisshanclaude-code-best-practice from vibe coding to agentic engineering - practice makes claude perfect.md`

---

## Tese Central

O repositório `shanraisshan/claude-code-best-practice` (50KB de conteúdo) documenta a transição de "vibe coding" — usar Claude como autocomplete glorificado — para "agentic engineering" — delegar problemas completos com critérios de sucesso explícitos. A diferença não é o modelo, é o nível de estrutura que o operador aplica.

## Framework de Progressão

### Nível 1 — Vibe Coding
Uso ad-hoc: o desenvolvedor escreve um prompt vago, Claude gera código, o desenvolvedor aceita ou rejeita. Sem contexto persistente, sem verificação, sem loops. Produtividade marginalmente maior que autocompletar.

**Problema:** Claude não sabe o que você quer dizer quando diz "funciona". Sem critério de sucesso, qualquer output satisfaz o pedido.

### Nível 2 — Prompt Engineering Básico
Adicionar contexto ao prompt: "faça X usando tecnologia Y, considerando restrição Z". Melhora a qualidade da primeira geração mas ainda é single-shot — sem verificação, sem iteração estruturada.

### Nível 3 — CLAUDE.md + Contexto Persistente
O CLAUDE.md como arquivo de configuração transforma Claude de "assistente stateless" em "desenvolvedor que conhece o projeto". O arquivo define: stack tecnológico, convenções de código, comandos disponíveis, o que o agente pode e não pode fazer.

Prática canônica:
- Stack e versões explícitas
- Comandos de build, test, lint (para que Claude possa verificar seu próprio trabalho)
- Convenções de nomenclatura e estrutura de arquivos
- Restrições operacionais (não deletar, não refatorar sem aprovação)

### Nível 4 — Plan Mode + Verificação
Antes de qualquer edit não-trivial: entrar em plan mode, listar passos, confirmar com o desenvolvedor. Após edição: rodar testes, lint, build — verificar que o código funciona antes de declarar sucesso.

Este nível elimina a categoria mais custosa de erros: código que parece certo mas quebra algo não relacionado.

### Nível 5 — Agentic Engineering
Claude como delegatário de problemas completos: "implemente autenticação JWT com refresh token rotation, testes incluídos, seguindo as convenções do CLAUDE.md". O agente planeja, executa, verifica, itera. O desenvolvedor revisa o resultado final.

---

## Práticas Específicas Documentadas no Repo

### CLAUDE.md Eficiente
O repositório demonstra que CLAUDE.md mínimo (20-30 linhas focadas) supera CLAUDE.md exaustivo (200+ linhas). Quanto maior o arquivo, menor a taxa de compliance — o modelo perde o fio. Regra: se uma instrução não mudaria o comportamento do agente em 80% das situações, remova-a.

### MCPs Curados
A recomendação é 3-5 MCPs máximo na stack ativa. Cada MCP adicional aumenta o espaço de ação do agente, aumentando a probabilidade de ações não-intencionais. MCPs essenciais:
- Filesystem: leitura e escrita de arquivos
- Git: commits e histórico
- Browser/search: documentação e referências externas

### Hooks de Validação
Pre-commit hooks que rodam automaticamente após cada edit do agente: lint, type check, testes unitários. O agente recebe o output do hook como feedback e corrige antes do commit. Isso fecha o loop de validação sem requerer intervenção humana em cada ciclo.

### Slash Commands Customizados
Comandos recorrentes viram slash commands no `.claude/commands/`:
- `/review` — code review estruturado seguindo convenções do projeto
- `/commit` — commit com mensagem formatada e verificação pré-commit
- `/plan` — entrar em plan mode e listar passos antes de executar

---

## Métricas de Eficácia

O repositório documenta melhorias observadas ao aplicar o framework:
- Redução de 60-70% em re-trabalho por falta de contexto
- Hooks de validação eliminam ~80% dos bugs que passariam direto para review
- Plan mode reduz grandes refactors não-intencionais em >90% dos casos

---

## Relevância para o Vault-Michel

O CLAUDE.md deste vault já implementa os princípios do nível 4-5: Karpathy 4P como guardrails, confirmação antes de ops destrutivas, autonomia explícita para ops de baixo risco. A progressão documentada no repo confirma que a abordagem atual é a correta para o regime de uso do vault.

O próximo nível natural seria formalizar slash commands para workflows recorrentes do vault: `/ingest`, `/lint`, `/report`. Isso reduziria o prompt de entrada de cada operação e padronizaria o comportamento.

---

## Limitações

- 50KB de conteúdo sugere abrangência, mas a qualidade de práticas varia — algumas recomendações são genéricas e não testadas em larga escala
- O repositório foi criado por um único autor; práticas refletem um perfil específico de desenvolvedor (provavelmente TypeScript/Node)
- "Agentic engineering" como termo ainda é fluido no campo — o que o repo chama de agentic pode ser apenas automação avançada sem loops autônomos reais
