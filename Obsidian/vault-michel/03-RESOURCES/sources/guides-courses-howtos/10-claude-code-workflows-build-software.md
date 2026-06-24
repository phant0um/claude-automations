---
title: "10 Claude Code Workflows That Honestly Changed How I Build Software"
type: source
source: Clippings/10 Claude Code Workflows That Honestly Changed How I Build Software.md
created: 2026-05-17
ingested: 2026-05-17
tags: [claude-code, workflows, productivity]
triagem_score: 7
author: "@NainsiDwiv50980"
---

## Tese central
10 workflows práticos do Claude Code (plan mode + verify, hooks pré-commit, MCP curado, etc) mudam o ciclo dev de "perguntar IA" para "delegar a IA com guardrails".

## Key insights
- Plan mode antes de edit não-trivial — reduz refactor cego
- Hooks fecham loops de validação automaticamente
- Curadoria > quantidade: 3 MCPs bons > 20 mediocres

## Links
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-server-curation]]

---

## Os 10 Workflows em Detalhe

### 1. Plan Mode Antes de Qualquer Edit Não-Trivial

O erro mais comum com LLM coding: pedir uma mudança complexa e aceitar o primeiro diff gerado. Plan mode força o agente a explicitar sua lógica antes de tocar no código. O desenvolvedor aprova o plano, então o agente executa.

**Como ativar:** `Shift+Tab` no Claude Code entra em plan mode. O agente lista os arquivos que pretende modificar, o que vai mudar em cada um, e por quê. Qualquer surpresa no plano é sinalizada antes de acontecer.

**Por que funciona:** o modelo é melhor em planejamento do que em execução perfeita de primeira. Separar as fases reduz o custo de correções tardias.

### 2. Hooks de Pré-Commit Automáticos

Hooks que rodam lint, type check, e testes antes de qualquer commit — e cujo output é devolvido ao agente como feedback. O agente corrige o que quebrou antes de declarar o trabalho completo.

**Implementação em `.claude/settings.json`:**
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{"type": "command", "command": "npm run lint && npm run test"}]
    }]
  }
}
```

### 3. Curadoria de MCPs — Menos é Mais

Três MCPs bem escolhidos superam vinte MCPs medíocres. Cada MCP adicional expande o espaço de ação do agente, aumentando a probabilidade de side effects não intencionais. A curadoria é uma decisão de risco, não de features.

Stack mínima recomendada: filesystem + git + um MCP de contexto (docs ou DB). Todo o resto é opcional e deve ser justificado por um workflow específico.

### 4. CLAUDE.md como Contrato de Comportamento

CLAUDE.md não é documentação — é um contrato de comportamento que o agente cumpre em cada sessão. Deve ser curto (idealmente <50 linhas úteis) e focado em comportamentos que mudam: o que pode ser feito sem aprovação, o que requer confirmação, quais comandos usar para verificação.

**Anti-padrão:** CLAUDE.md com explicações longas do projeto que o agente não precisa para operar. Isso dilui a densidade de instruções e reduz compliance.

### 5. Slash Commands para Workflows Recorrentes

Qualquer operação que você faz mais de uma vez por semana merece um slash command. Exemplos de alta utilidade:
- `/review` — code review seguindo as convenções do projeto
- `/commit` — mensagem de commit padronizada + verificação
- `/explain` — explicação do código selecionado para documentação

Slash commands ficam em `.claude/commands/*.md`. O arquivo é o prompt do comando.

### 6. Verificação Pós-Edit Automatizada

Não confiar no diff visual. Após cada conjunto de edits, rodar o suite de verificação: build, lint, testes. Registrar o output e passar para o agente como contexto da próxima instrução.

Fluxo: `edit → verify → [se falhar: feedback ao agente → re-edit] → [se passar: commit]`

### 7. Context Checkpointing

Para sessões longas, criar checkpoints de contexto antes de mudanças grandes. Se o agente vai refatorar um módulo inteiro, salvar o estado atual (via git commit ou snapshot) antes de começar. Permite reverter sem perder trabalho anterior.

### 8. Paralelização de Sub-Tarefas Independentes

Quando múltiplas mudanças são independentes, usar worktrees ou sessões paralelas do Claude Code em vez de fazer sequencialmente. Exemplo: atualizar documentação enquanto o agente roda testes em outra sessão.

### 9. MCP de Documentação Externa

Adicionar um MCP de busca/leitura de documentação (Brave Search, Context7, ou similar) permite ao agente consultar docs de bibliotecas em tempo real. Elimina hallucinations de API e reduz o ciclo "agente gera código com API errada → falha → correção manual".

### 10. Sessões Focadas com Escopo Explícito

Cada sessão começa com escopo explícito: "nesta sessão vamos fazer X e apenas X". Isso previne que o agente "melhore" coisas fora do escopo — uma fonte comum de bugs introduzidos inadvertidamente.

---

## Por Que Esses 10 e Não Outros

O que une os 10 workflows é a filosofia de **fechar loops de validação automaticamente**. A diferença entre usar Claude como chat-com-IDE e como par-programmer real é que, no segundo caso, o agente sabe que foi ou não bem-sucedido — sem precisar de confirmação humana em cada passo. Hooks, plan mode, e slash commands são todos mecanismos de fechamento de loop.

---

## Aplicação no Vault-Michel

Este vault já implementa os workflows 3 (MCPs curados), 4 (CLAUDE.md como contrato), e 5 (slash commands via skills). Os mais impactantes a adicionar seriam:
- Workflow 2 (hooks pós-edit para verificar wikilinks válidos)
- Workflow 6 (verificação automática do manifest após ingest)
- Workflow 10 (escopo explícito no início de cada sessão de reestruturação)

---

## Limitações

- Os workflows assumem stack TypeScript/Node por default — alguns precisam de adaptação para outros contextos
- Plan mode adiciona latência perceptível em tasks simples; deve ser reservado para edits de múltiplos arquivos ou refactors
- Hooks de validação com suite de testes lenta podem tornar o ciclo edit→verify muito longo; priorize testes unitários rápidos no loop interno
