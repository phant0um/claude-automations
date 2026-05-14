---
title: "How to Use /goal in Claude Code"
type: source
tags: [goal-command, claude-code, agentic, workflow, autonomous-agents]
ingested: 2026-05-14
source_file: gemini-code-1778767956414.md
---

# How to Use /goal in Claude Code

*Defina um resultado — o agente trabalha por horas — zero checagem manual.*

## O que é o /goal

Um comando nativo no Claude Code que foca no estado final (resultado) em vez de apenas um passo individual. O agente planeja, executa, verifica, depura e continua trabalhando até que cada critério de sucesso seja atingido. Não é preciso "babysitar" a IA.

## O Workflow de 5 Passos

1. **OPEN:** Inicie o Claude Code no diretório do seu projeto.
2. **TYPE:** Digite `/goal` seguido do seu resultado esperado (em uma linha).
3. **FILL:** Preencha as seções de Contexto, Critérios de Sucesso, Regras e Barra de Qualidade.
4. **APPROVE PLAN:** O agente listará as tarefas; você revisa e diz "go".
5. **WALK AWAY:** O agente roda sozinho até terminar.

## Anatomia de um Comando /goal

1. **O Resultado (uma linha):** "Envie um dashboard de cripto funcional como um único arquivo HTML."
2. **Contexto:** Projeto, stack, estado atual, restrições, público-alvo.
3. **Critérios de Sucesso:** Específicos e mensuráveis ("todos devem ser verdadeiros"). O agente se auto-avalia antes de parar.
4. **Regras Operacionais:** Planejar primeiro, trabalhar de forma autônoma, auto-verificação, sem placeholders.
5. **Entregável Final:** O que retornar ao terminar (arquivos alterados, provas de funcionamento, resumo).

## DO THIS (Faça Isso)

- Use **Opus 4.7 + High Effort** para tarefas longas.
- Torne os critérios de sucesso **mensuráveis** (não diga apenas "boa UX").
- Utilize **MCPs** para que o agente puxe dados reais.
- **Exija provas** (screenshots, testes aprovados, URL funcional).
- Deixe-o terminar antes de começar a revisar.

## AVOID THIS (Evite Isso)

- Resultados vagos ("melhore o código").
- Interromper no meio da execução para adicionar escopo.
- Permitir que ele pergunte "devo fazer isso?" — responda "decida você mesmo".
- Pular a etapa de aprovação do plano inicial.
- Usar para tarefas minúsculas e pontuais.

## Melhores Casos de Uso

- Construir e fazer o deploy de um app completo.
- Refatorar um repositório inteiro.
- Corrigir todos os testes que estão falhando.
- Fluxos de Pesquisa → Rascunho → Envio de relatório.

## Relacionado

- [[03-RESOURCES/concepts/goal-command]] — conceito central do /goal
- [[03-RESOURCES/sources/goal-mega-prompt-template]] — template reusável completo
- [[03-RESOURCES/concepts/claude-code-workflow]] — /goal como extensão autônoma do EPCC
- [[03-RESOURCES/concepts/agentic-reasoning]]
