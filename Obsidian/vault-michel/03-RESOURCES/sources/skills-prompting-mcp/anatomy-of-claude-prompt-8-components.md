---
title: The Anatomy of a Claude Prompt (8 Components)
type: source
source: Clippings/gemini-code-1778768053130.md
created: 2026-05-15
ingested: 2026-05-15
tags: [ai-agents]
triagem_score: 7
---

## Tese central
Template de 8 componentes para prompts Claude Opus 4.6+: Task, Context Files, Reference, Success Brief, Rules, Conversation, Plan, Alignment.

## Key insights
- Reference = exemplo + blueprint engenharia-reversa (regras "Sempre/Nunca" extraídas do exemplo).
- Success Brief define: tipo+tamanho do output, reação do destinatário, NÃO deve soar como, sucesso=ação concreta.
- Alignment: "só comece quando estivermos alinhados" — força conversation/plan antes de execução.

## Os 8 Componentes em Detalhe

### 1. Task

A tarefa em si — o que você quer que Claude faça. Deve ser específica e orientada a verbo de ação: "Escreva", "Analise", "Refatore", "Diagnostique". Evite tarefas compostas ("escreva e revise e formate") — separe em prompts distintos ou deixe claro a ordem de prioridade.

**Bom exemplo:** "Refatore a função `processPayment` em `payments.service.ts` para separar validação de persistência."

**Fraco:** "Melhore o código de pagamentos."

### 2. Context Files

Arquivos, trechos de código, ou documentos que Claude precisa para executar a tarefa. O princípio é: inclua apenas o que for diretamente relevante — contexto irrelevante dilui a atenção e consome tokens de KV cache.

**Padrão recomendado:**
```
Context Files:
- [payments.service.ts] — arquivo a refatorar
- [payments.interface.ts] — contratos de tipo relevantes
- [docs/adr/004-payment-validation.md] — decisão arquitetural de referência
```

### 3. Reference

Um exemplo do output desejado **mais** o "blueprint" extraído por engenharia reversa desse exemplo. O Reference não é apenas "aqui está um exemplo" — é "aqui está um exemplo e aqui estão as regras implícitas que ele demonstra".

**Estrutura:**
1. Exemplo concreto do output esperado
2. Lista de regras inferidas: "Sempre...", "Nunca...", "Quando X, faça Y"

Isso é mais eficiente que descrever o output abstratamente — Claude aprende o padrão do exemplo e as regras explicitam edge cases que o exemplo não cobre.

### 4. Success Brief

Define como reconhecer que a tarefa foi bem executada. Quatro dimensões:

- **Tipo e tamanho**: "um parágrafo", "função de <50 linhas", "tabela com 3 colunas"
- **Reação do destinatário**: o que o leitor/usuário fará ou sentirá ao receber o output
- **NÃO deve soar como**: anti-exemplos de tom, formato ou abordagem
- **Sucesso = ação concreta**: qual ação concreta o output deve possibilitar

**Exemplo:** "Sucesso = desenvolvedor júnior consegue adicionar um novo método de pagamento sem ler mais do que 2 arquivos. NÃO deve soar como documentação acadêmica."

### 5. Rules

Restrições explícitas que se aplicam à tarefa. Diferente do Reference (que mostra), Rules declara. Usar formato numerado ou lista — sem prosa.

**Exemplos:**
- Não modificar a assinatura pública de nenhuma função existente
- Manter compatibilidade com Node 20 LTS (sem `using` declaration)
- Não adicionar dependências externas

### 6. Conversation

O histórico relevante da conversa que levou a esta tarefa — decisões já tomadas, alternativas descartadas, contexto que não está nos arquivos. Isso evita que Claude "reinvente a roda" ou proponha algo já rejeitado.

**Quando usar:** sempre que a tarefa atual deriva de uma discussão prévia. Sem esta seção, Claude começa do zero em cada prompt.

### 7. Plan

Um esboço do plano de execução que você (ou o Claude em turno anterior) já elaborou. Incluir o plan serve dois propósitos:

1. **Verificação de alinhamento**: Claude pode corrigir o plano antes de executar
2. **Ancoragem**: evita que Claude tome desvios não solicitados durante a execução

Se Claude criou o plano, inclua-o aqui antes de pedir execução. Isso é o padrão "plan then execute" em vez de "execute and hope".

### 8. Alignment

A instrução final que força sincronização antes de ação: "Só comece quando estivermos alinhados." Esta linha é o mecanismo anti-hallucination mais simples do framework — Claude deve confirmar entendimento, não assumir e executar.

**Variações:**
- "Confirme sua compreensão da tarefa antes de começar."
- "Se tiver dúvidas sobre o escopo, pergunte antes de escrever código."
- "Apresente o plano de refatoração para aprovação antes de modificar arquivos."

## Por que a Ordem Importa

A ordem dos 8 componentes segue a lógica de carregamento de contexto do KV cache: itens no início do prompt (Task, Context Files, Reference) são lidos antes e têm maior influência na direção geral da resposta. Rules e Alignment no final funcionam como constraintss finais que refinam sem redirecionar.

## Comparação com Outros Frameworks de Prompt

| Framework | Componentes | Foco |
|-----------|-------------|------|
| Claude 8-components | 8 | Output definido + alinhamento |
| COSTAR (GPT) | 6 | Contexto + formato |
| ReAct | 3 | Raciocínio + ação + observação |
| Chain-of-Thought | 1 | Raciocínio passo a passo |

O diferencial do framework de 8 componentes é o **Success Brief** (raro em outros frameworks) e o **Alignment** explícito — ambos reduzem o retrabalho em tarefas complexas.

## Limitações

- Para tarefas simples (1-2 passos), o overhead de 8 componentes é desnecessário — use apenas Task + Rules
- O Reference requer que você já saiba como é um bom output — difícil para domínios novos
- O Alignment cria um turno extra de conversa — custo em latência e tokens

## Aplicação no Vault

Este framework é aplicável aos agentes do `04-SYSTEM/agents/`:
- O CLAUDE.md de cada agente é essencialmente um prompt de sistema com esses 8 componentes
- O "Success Brief" corresponde ao critério de qualidade em `04-SYSTEM/wiki/errors.md`
- O "Alignment" mapeia para a instrução "confirmar antes de ações destrutivas" no CLAUDE.md do vault

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/sources/claude-code-skills/top-13-skills-et-plugins-claude-code-en-2026]]
