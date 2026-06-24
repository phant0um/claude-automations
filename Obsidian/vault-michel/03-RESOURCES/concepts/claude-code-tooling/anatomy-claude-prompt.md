---
title: Anatomy of a Claude Prompt
type: concept
status: developing
tags: [prompt-engineering, claude, opus, workflow, alignment, structure]
created: 2026-05-14
updated: 2026-05-14
---

# Anatomy of a Claude Prompt

Framework de 8 componentes para estruturar prompts que extraem performance máxima de modelos Claude (Opus 4.6+). A premissa central: a IA precisa entender a tarefa, o contexto, o padrão de qualidade e estar alinhada antes de começar — não durante.

> [!key-insight] Princípio central
> Os 8 componentes são sequenciais e têm propósitos distintos. Pular qualquer um cria ambiguidade que se manifesta como saída genérica ou re-trabalho.

## Os 8 Componentes

### 1. Task
O que fazer e por que isso importa. Formato recomendado:
`"Eu quero [TAREFA] para que [CRITÉRIO DE SUCESSO]."`
Seguido de: `"Primeiro, leia estes arquivos completamente antes de responder."`

### 2. Context Files
Lista de arquivos de contexto com descrição do que cada um contém. Dá ao Claude o conhecimento necessário sem depender de seu treinamento genérico.

### 3. Reference
Dois sub-passos:
1. Upload ou colagem do arquivo de referência (o padrão de qualidade desejado)
2. Blueprint de engenharia reversa da referência — regras extraídas no formato "Sempre X" / "Nunca Y"

### 4. Success Brief
Quatro dimensões de output esperado:
- Tipo de output + tamanho (contrato, memo, proposta, post...)
- Reação do destinatário (o que devem pensar/sentir/fazer)
- O que NÃO deve soar como (IA genérica, jargão, tom errado)
- O que "sucesso" significa (assinam? aprovam? respondem?)

### 5. Rules
Injeta as restrições e padrões do usuário via arquivo de contexto. Instrução explícita: "Se estiver prestes a quebrar uma regra, pare e avise."

### 6. Conversation
Pausa antes da execução. Claude deve fazer perguntas de clarificação antes de começar. Instrução: `"NÃO comece ainda. Faça perguntas de esclarecimento."`

### 7. Plan
Dois sub-passos sequenciais:
1. Listar as 3 regras mais relevantes do arquivo de contexto para esta tarefa
2. Dar o plano de execução (máximo 5 passos)

### 8. Alignment
Checkpoint de consenso: `"Só comece o trabalho quando estivermos alinhados."`

## Mapa Completo

| # | Componente | Propósito | Anti-padrão evitado |
|---|-----------|-----------|---------------------|
| 1 | Task | Objetivo + critério | "Faça algo bom" sem especificidade |
| 2 | Context Files | Conhecimento necessário | Depender do treinamento genérico |
| 3 | Reference | Âncora de qualidade | Output abstrato sem exemplo real |
| 4 | Success Brief | Expectativa de output | Surpresa com o formato entregue |
| 5 | Rules | Restrições do usuário | Regras esquecidas mid-execução |
| 6 | Conversation | Clarificação prévia | Execução com premissas erradas |
| 7 | Plan | Plano explícito | Código sem arquitetura prévia |
| 8 | Alignment | Consenso antes de agir | Divergência descoberta após trabalho |

## Relação com /goal

O `/goal` (Claude Code/Codex) segue estrutura similar mas para tarefas longas autônomas:
- Task → `/goal [resultado final]`
- Context Files → `— CONTEXT —`
- Success Brief → `— SUCCESS CRITERIA —`
- Rules → `— OPERATING RULES —`
- Plan → `PLAN FIRST` (Operating Rule #1)
- Alignment → `APPROVE PLAN` (passo 4 do workflow)

A diferença: o `/goal` remove os componentes 6 (Conversation) e 8 (Alignment) explícitos porque o agente trabalha autonomamente. O alinhamento acontece na aprovação do plano inicial.

## Fontes

- [[03-RESOURCES/sources/skills-prompting-mcp/anatomy-claude-prompt-eight-components]] — fonte primária (template verbatim)
- [[03-RESOURCES/sources/guides-courses-howtos/goal-mega-prompt-template]] — template /goal que espelha esta estrutura

## Relacionado

- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — Pattern #16: este framework como padrão reutilizável
- [[03-RESOURCES/concepts/claude-code-tooling/goal-command]] — /goal como instância autônoma desta estrutura
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — Context Files como manifestação de context engineering
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — conceito geral
