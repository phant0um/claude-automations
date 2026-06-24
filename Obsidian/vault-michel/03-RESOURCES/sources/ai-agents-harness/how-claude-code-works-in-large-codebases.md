---
title: How Claude Code Works in Large Codebases: Best Practices
type: source
source: Clippings/How Claude Code works in large codebases Best practices and where to start.md
created: 2026-05-15
ingested: 2026-05-15
tags: [ai-agents]
triagem_score: 9
---

## Tese central
Claude Code navega codebases como engenheiro humano: file traversal + grep + follow references — SEM índice/embeddings pré-construídos.

## Key insights
- RAG falha em escala: embeddings desatualizam (renames, deletions), retorna referências mortas.
- Agentic search só falha quando contexto inicial é fraco — qualidade de navegação = qualidade de CLAUDE.md + skills layered.
- Harness importa tanto quanto o modelo — "harness matters as much as the model".

## Links
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-md-cost-optimization]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]

---

## Como Claude Code Navega um Codebase Grande

A abordagem de Claude Code é deliberadamente similar à de um engenheiro humano novo num projeto: começa pelo README/CLAUDE.md para entender o projeto, depois navega por estrutura de diretórios, segue imports para entender dependências, e usa grep para encontrar símbolos específicos.

### Fase 1: Orientação (Context Bootstrap)
Ao iniciar uma sessão, Claude Code lê automaticamente:
1. `CLAUDE.md` (projeto e globais) — instruções, convenções, comandos
2. `README.md` se CLAUDE.md ausente
3. Estrutura de diretórios top-level via `ls`

Este bootstrap determina a qualidade de toda a navegação subsequente. Um CLAUDE.md rico reduz drasticamente o número de tool calls necessários para entender onde as coisas estão.

### Fase 2: Navegação Agentica (Agentic Search)
Claude Code não usa índice pré-construído. Cada query de informação gera tool calls reais:

```
ls src/          → mapear estrutura
cat src/index.ts → ler entry point
grep -r "UserAuth" src/ → encontrar onde UserAuth é definido
cat src/auth/user.ts → ler definição
grep -r "import UserAuth" → encontrar todos os usos
```

Esta sequência é similar ao que um humano faria com um editor + terminal. A diferença: Claude Code pode fazer 10-20 dessas sequências em paralelo, não uma por vez.

### Fase 3: Follow References
Uma vez encontrado um símbolo, Claude Code segue a cadeia de referências:
- Definição → implementação → testes → usos
- Import → arquivo importado → dependências do arquivo importado
- Erro → stack trace → arquivo/linha → função ao redor → contexto completo

Esta navegação incremental garante contexto correto e atual — sem depender de índice que pode estar desatualizado.

---

## Por Que RAG Pre-construído Falha em Codebases Grandes

### O Problema de Atualização
Em codebases ativos, código muda constantemente. Um índice de embeddings construído ontem pode já estar desatualizado:
- Arquivo renomeado → embedding aponta para path antigo
- Função deletada → embedding retorna referência para código que não existe
- Refactoring de interface → embedding retorna implementação antiga incompatível com interface atual

Claude Code evita isso completamente: como navega o filesystem diretamente, sempre vê o estado atual.

### O Problema de Fragmentação
RAG recupera fragmentos de código por similaridade semântica. Mas código raramente é entendido por fragmento — você precisa da função inteira, do contexto de onde ela é chamada, e das interfaces que ela implementa. RAG frequentemente retorna o fragmento relevante mas sem o contexto circundante necessário.

Claude Code lê arquivos completos quando necessário, não fragmentos.

### O Problema de Tamanho de Contexto
Em codebases >100k LOC, RAG retorna dezenas de fragmentos potencialmente relevantes. Todos entram no contexto, inflando o prompt e aumentando custo. Claude Code é cirúrgico: lê apenas o que é necessário para a tarefa específica.

---

## O Papel do CLAUDE.md na Qualidade de Navegação

A descoberta principal do artigo: quando o contexto inicial (CLAUDE.md) é fraco, a busca agentica falha — não porque a busca seja ruim, mas porque o agente não sabe onde começar, faz assumptions erradas sobre estrutura, e perde tempo em navegação improdutiva.

**CLAUDE.md de alta qualidade para large codebases inclui:**
- Mapa de módulos: "A lógica de autenticação está em `src/auth/`, a API em `src/api/`, o banco em `src/db/`"
- Comandos frequentes: como rodar testes para um módulo específico, como fazer build parcial
- Convenções críticas: padrão de naming, como injetar dependências, onde ficam as configurações
- Anti-patterns conhecidos: o que não fazer e por que

Com este mapa, o agente vai diretamente ao módulo correto em vez de fazer file traversal cego.

---

## Skills como Camada de Navegação Especializada

Skills (arquivos Markdown que ensinam o agente a fazer tarefas) complementam o CLAUDE.md com conhecimento procedural:

- Skill `/find-tests` → ensina o agente a encontrar testes de um arquivo específico (padrão de naming, estrutura de diretórios de testes)
- Skill `/trace-bug` → ensina o processo de debug: stack trace → arquivo → função → contexto → hipótese → fix → teste

Skills especializam a navegação para domínios específicos do projeto, sem sobrecarregar o CLAUDE.md principal.

---

## Implicações Práticas

**Para projetos novos:** Invista tempo num CLAUDE.md rico antes de usar Claude Code — retorno composto em cada sessão subsequente.

**Para projetos legados:** CLAUDE.md pode ser gerado automaticamente com `claude --bootstrap` (analisa estrutura e gera CLAUDE.md inicial para revisão humana).

**Para monorepos:** CLAUDE.md por workspace (sub-projeto) além do CLAUDE.md raiz. Cada workspace tem seu próprio mapa de módulos.

---

## Conexões

- [[03-RESOURCES/sources/memory-context-rag/grep-vs-embeddings-coding-agents]] — grep como ferramenta central de navegação
- [[03-RESOURCES/sources/ai-agents-harness/clipping-components-of-a-coding-agent]] — componentes que habilitam essa navegação
- [[03-RESOURCES/sources/claude-code-skills/claude-code-5-layer-architecture-2026]] — CLAUDE.md como camada 1 da arquitetura
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-md-cost-optimization]]
