---
title: "The Anatomy of a Claude Prompt — 8 Components"
type: source
tags: [prompt-engineering, claude, opus, workflow, alignment]
ingested: 2026-05-14
source_file: gemini-code-1778768053130.md
---

# The Anatomy of a Claude Prompt

Template desenhado para extrair o máximo de performance de modelos como Opus 4.6+, garantindo que a IA entenda não apenas a tarefa, mas o contexto e o padrão de qualidade esperado.

## Os 8 Componentes

### 1. Task (Tarefa)
```
"Eu quero [TAREFA] para que [CRITÉRIO DE SUCESSO]."
"Primeiro, leia estes arquivos completamente antes de responder:"
```

### 2. Context Files (Arquivos de Contexto)
```
- [filename.md] — [o que ele contém]
- [filename.md] — [o que ele contém]
- [filename.md] — [o que ele contém]
```

### 3. Reference (Referência)
```
"Aqui está uma referência do que eu quero alcançar:"
[Upload do arquivo de referência em markdown ou cole o texto]

"Aqui está o que faz esta referência funcionar:"
[Blueprint de engenharia reversa — padrões, tom, estrutura e regras
extraídos da referência. Formatar cada um como regra começando com
"Sempre" ou "Nunca".]
```

### 4. Success Brief (Briefing de Sucesso)
```
- Tipo de output + tamanho: [Contrato, memo, relatório, proposta, landing page, post?]
- Reação do destinatário: [O que devem pensar/sentir/fazer após a leitura?]
- NÃO deve soar como: [O que evitar — IA genérica, muito casual, jargões?]
- Sucesso significa: [Assinam? Aprovam? Respondem? Tomam uma ação?]
```

### 5. Rules (Regras)
```
"Meu arquivo de contexto contém meus padrões, restrições, armadilhas e
público-alvo. Leia-o totalmente antes de começar. Se você estiver prestes
a quebrar uma das minhas regras, pare e me avise."
```

### 6. Conversation (Conversa)
```
"NÃO comece a executar ainda. Em vez disso, faça-me perguntas de
esclarecimento (use a ferramenta 'AskUserQuestion') para que possamos
refinar a abordagem juntos, passo a passo."
```

### 7. Plan (Plano)
```
"Antes de escrever qualquer coisa, liste as 3 regras do meu arquivo de
contexto que mais importam para esta tarefa."
"Então, me dê seu plano de execução (máximo de 5 passos)."
```

### 8. Alignment (Alinhamento)
```
"Só comece o trabalho quando estivermos alinhados."
```

## Mapa dos 8 Componentes

| # | Componente | Função |
|---|-----------|--------|
| 1 | Task | Define objetivo + critério de sucesso |
| 2 | Context Files | Carrega o conhecimento necessário |
| 3 | Reference | Ancora estilo/padrão com exemplo real |
| 4 | Success Brief | Especifica output esperado e o que evitar |
| 5 | Rules | Injeta restrições e padrões do usuário |
| 6 | Conversation | Força clarificação antes de executar |
| 7 | Plan | Exige plano explícito antes do trabalho |
| 8 | Alignment | Checkpoint de consenso antes da execução |

## Relacionado

- [[03-RESOURCES/concepts/anatomy-claude-prompt]] — página conceitual sintetizando este framework
- [[03-RESOURCES/concepts/prompt-engineering-patterns]] — Pattern #16: este modelo como padrão
- [[03-RESOURCES/concepts/prompt-engineering]] — conceito geral de engenharia de prompts
