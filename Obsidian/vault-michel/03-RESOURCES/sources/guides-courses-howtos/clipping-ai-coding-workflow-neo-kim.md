---
title: "I Struggled to Code with AI Until I Learned This Workflow"
type: source
source_type: clipping
category: articles
ingested: 2026-05-05
author: "Neo Kim / Louis-François Bouchard"
source_url: "https://newsletter.systemdesign.one/p/ai-coding-workflow"
tags: [ai-coding, workflow, iterative-loop, code-review, prompt-engineering]
triagem_score: 7
---

# I Struggled to Code with AI Until I Learned This Workflow

**Author:** Neo Kim (newsletter) + Louis-François Bouchard (guest) | **Published:** 2026-02-02

## Summary

Practical AI coding workflow for engineers new to AI-assisted development. Core insight: AI works as an iterative loop, not one-shot requests. The model fills gaps while you steer — reducing confident-but-wrong outputs. Key habits: treat AI output as a draft not an answer, keep the model on a short leash, verify before running, iterate in small steps rather than asking for complete solutions.

## Key Takeaways
- AI coding = iterative loop, not vending machine (paste problem → get solution)
- Models "confidently suggest code that calls functions that don't exist"
- Stop trying to "prompt better" — work differently instead
- Keep model on short leash: small tasks, verify each step, iterate
- Treat output like a draft requiring review, not a final answer
- Works for any AI coding tool, not tool-specific

## Concepts Linked
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]

## Entities Linked
- [[03-RESOURCES/entities/Claude Code]]

---

## O problema raiz: expectativa errada de como usar AI

A maioria dos desenvolvedores que "luta com AI coding" está usando o modelo como uma vending machine: cola o problema, espera a solução completa, frustra quando o output não funciona. O insight central deste artigo é que esse modelo mental é a raiz do fracasso — não a qualidade do modelo.

AI coding funciona como um **par de programação sênior que conhece muitas tecnologias mas não o seu sistema específico**. Ele precisa de contexto, precisa de iteração, precisa de direção. Tratá-lo como oracle que responde uma vez é subotimizar sistematicamente.

## O workflow correto: loop iterativo curto

O processo que funciona tem cinco etapas cíclicas:

1. **Defina a tarefa pequena**: não "construa o módulo de autenticação" — "escreva a função que valida o formato do token JWT"
2. **Forneça contexto específico**: mostre o código existente, explique a convenção do projeto, cite as limitações
3. **Receba o draft**: trate como proposta, não como resposta final
4. **Verifique antes de rodar**: leia o código, entenda o que ele faz, cheque se faz sentido no contexto do projeto
5. **Itere com feedback específico**: "essa função quebra quando X é null" é melhor que "não funcionou"

O loop é curto por design: tarefas pequenas produzem outputs verificáveis, erros aparecem cedo, correções são cirúrgicas.

## O anti-padrão do "prompt melhor"

O artigo critica a crença de que o segredo é encontrar o prompt perfeito. Isso é uma busca pela pergunta certa para a vending machine. O problema não é o prompt — é o modelo mental de interação.

Mudar o modelo mental significa aceitar que:
- O modelo vai errar em detalhes específicos do projeto
- Funções inventadas (hallucination) são comuns — `startsWith` aplicado em API que não existe
- Verificação antes de rodar **não é opcional**, é parte do workflow
- Cada iteração é informação, não falha

## Comparação com padrões documentados

| Padrão | Neo Kim / Bouchard | @nicos_ai (worktrees) |
|---|---|---|
| Unidade de trabalho | Tarefa pequena e verificável | Feature completa em branch isolada |
| Modelo de controle | Usuário verifica cada step | Agentes paralelos com revisor |
| Paralelismo | Sequencial, um step de cada vez | 4-8 sessões simultâneas |
| Adequado para | Iniciantes em AI coding | Senior com múltiplos projetos |

Os dois workflows são compatíveis: o loop iterativo curto é o padrão para tarefas simples; worktrees + agentes paralelos é a escala para projetos grandes.

## Aplicação prática por tipo de tarefa

**Nova feature (desconhecida):**
- Descreva o objetivo + constraints técnicas
- Peça um plano antes da implementação
- Valide o plano, então implemente passo a passo

**Bug fix:**
- Forneça o erro exato + stack trace completo
- Mostre o contexto do código relevante (não o arquivo inteiro)
- Verifique se o fix faz sentido antes de aplicar

**Refatoração:**
- Defina o critério de sucesso (o que "refatorado" significa)
- Peça para o AI listar o que vai mudar antes de mudar
- Aplique em partes verificáveis, não tudo de uma vez

**Code review:**
- Forneça o diff, não o arquivo completo
- Peça análise por categoria (segurança, performance, legibilidade)
- Itere sobre pontos específicos levantados

## Por que "short leash" é a metáfora certa

O artigo usa "keep the model on a short leash" como princípio. A metáfora captura algo importante: autonomia sem supervisão em tarefas que o modelo não conhece o contexto específico leva a desvios que são caros de corrigir. Uma função inventada que parece plausível pode ser copiada e espalhada por dez arquivos antes de alguém perceber.

Short leash não é desconfiança — é reconhecer o limite do que o modelo sabe (o sistema geral) vs o que só o desenvolvedor sabe (o sistema específico do projeto).

## Relevância para o vault

O vault usa Claude Code para operações de ingestão, edição e interligação. O princípio do loop iterativo curto se traduz em: uma fonte por vez, verificar wikilinks após criação, confirmar hot.md atualizado antes de marcar tarefa completa. A autonomia do vault (operações simples sem confirmação) segue exatamente a lógica de "short leash" para tarefas onde o contexto é claro.

## Referências adicionais

- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] — workflow completo de Claude Code
- [[03-RESOURCES/sources/skills-prompting-mcp/post-nicos-ai-senior-engineer-claude-workflow]] — extensão para senior engineers com worktrees
- [[03-RESOURCES/sources/open-source-ecosystems/guillecasaus-github-spec-kit]] — spec-first como alternativa ao loop iterativo
