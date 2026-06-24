---
title: "Post @brunobertolini — Deixei de revisar código para desenhar o sistema que revisa por mim"
type: source
source_file: Clippings/Post by @brunobertolini on X.md
origin: post no X (@brunobertolini)
ingested: 2026-05-14
tags: [code-review, agent-system, pre-commit, quality-gate, memory-persistente]
triagem_score: 8
---

# Post @brunobertolini — Deixei de revisar código para desenhar o sistema que revisa por mim

> [!tip] Insight central
> Em vez de revisar código manualmente, construir um sistema que revisa automaticamente: o trabalho sobe uma camada — de revisor para arquiteto do sistema de revisão.

## Componentes do sistema

- **Testes automatizados:** garantem qualidade do produto (não necessariamente do código)
- **Rules em `.claude/rules/`** auto-carregadas por path — convenção vira trilho que o agent não consegue sair
- **Agentes especializados em paralelo no `/pr-review`:** bugs, security, arquitetura, estilo
- **Quality-gate:** lint + build + checks customizados bloqueando commit no pre-commit hook
- **Memory persistente entre sessões:** cada feedback vira regra, o erro não se repete
- **E2E automático no browser:** build verde não prova que feature funciona; gera issues automaticamente

## Princípio

> "Deixei de revisar código para desenhar o sistema que revisa por mim. O trabalho subiu uma camada."

## Como cada componente funciona na prática

### Rules em `.claude/rules/`

O carregamento automático por path é a parte mais subestimada. Colocar uma regra em `.claude/rules/api/` faz com que ela seja carregada automaticamente quando Claude trabalha em arquivos dentro de `api/`. Isso é diferente de um CLAUDE.md monolítico onde todas as regras competem pela atenção do modelo. A granularidade por diretório significa que a "convenção vira trilho" — o agente literalmente não tem como não ver a regra relevante para o contexto onde está trabalhando.

### Agentes especializados em paralelo no `/pr-review`

Em vez de pedir a um único agente "revise este PR", o sistema lança 4–5 subagentes em paralelo, cada um com um papel fixo:
- **Bug hunter:** foca em lógica e edge cases
- **Security reviewer:** SQL injection, XSS, segredos expostos
- **Architecture reviewer:** violações de padrões do projeto, coupling desnecessário
- **Style reviewer:** convenções de naming, estrutura de código

Cada subagente tem contexto menor e mais focado. O resultado é que bugs de segurança não "competem" com bugs de estilo pelo espaço de atenção do modelo — cada tipo de problema tem um especialista dedicado.

### Quality-gate no pre-commit hook

O hook bloqueia o commit antes de chegar ao repositório remoto. Isso cria um feedback loop curto: o desenvolvedor descobre o problema antes de sair da linha de trabalho, antes de abrir um PR, antes de acionar um CI remoto. Custo de correção mínimo. A combinação lint + build + checks customizados garante que "commit verde" seja um sinal confiável, não uma esperança.

### Memory persistente entre sessões

O mecanismo é simples: todo feedback que o agente recebe (de revisões, de erros, de correções manuais) é convertido em uma regra explícita e adicionada ao CLAUDE.md ou à pasta `.claude/rules/`. Na próxima sessão, a regra já está lá. O erro específico não pode se repetir porque o agente foi explicitamente instruído a não cometê-lo. Isso é o oposto de treinar um modelo — é engenharia de contexto aplicada a aprendizado incremental.

### E2E automático no browser

Build verde não prova que a feature funciona do ponto de vista do usuário. O agente abre o browser, navega pelos fluxos críticos, e se detectar regressão, gera uma issue automaticamente com screenshot, URL, e descrição do problema. Isso fecha o loop entre "o código compila" e "o produto funciona".

## O princípio de subir uma camada

O insight central de Bruno Bertolini é sobre onde você aloca seu tempo como engenheiro. Revisar código é trabalho de nível 1: você olha, analisa, comenta. Construir o sistema que revisa é trabalho de nível 2: você define critérios, arquiteta fluxos, escreve regras. A mesma quantidade de tempo investida em nível 2 produz mais valor porque o sistema escala — cada PR futuro é revisado gratuitamente, pela mesma arquitetura.

Isso é análogo ao que Garry Tan chama de "cogwheel" no gstack: o desenvolvedor se torna o arquiteto do sistema de desenvolvimento, não o executor das tarefas de desenvolvimento.

## Limitações e trade-offs

- **Custo de setup:** construir o sistema de revisão leva mais tempo do que revisar os primeiros 5–10 PRs manualmente. O break-even depende da cadência de PRs do time.
- **Manutenção das regras:** regras acumulam e podem conflitar. CLAUDE.md precisa de curadoria regular — senão o agente recebe instruções contraditórias.
- **E2E frágil:** testes de browser são notoriamente frágeis contra mudanças de UI. O sistema que gera issues pode gerar falsos positivos durante refatorações visuais.
- **Feedback do agente pode ser genérico:** subagentes especializados ainda podem dar feedback de baixa qualidade se o rubric não for específico o suficiente para o domínio do projeto.

## Relação com o vault-michel

O princípio se aplica diretamente: em vez de revisar manualmente cada nota ingerida, o vault tem `.claude/rules/` com convenções de ingest, o `wiki-lint` skill para auditoria, e o `errors.md` que funciona como memory persistente. Cada erro corrigido manualmente deveria virar uma entrada no errors.md — o mesmo padrão de "feedback vira regra".

## Conexões

- [[03-RESOURCES/entities/brunobertolini]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/claude-code-tooling/claudemd-self-improvement-loop]]
