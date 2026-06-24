---
title: "Guillermo Casaus — GitHub Spec Kit para Vibe Coding"
type: source
source_file: "Clippings/Thread by @_guillecasaus on Thread Reader App.md"
origin: thread no X (@_guillecasaus)
ingested: 2026-05-14
tags: [spec-kit, github, vibe-coding, spec-driven-development, ai-coding]
triagem_score: 7
---
# Guillermo Casaus — GitHub Spec Kit para Vibe Coding

> [!key-insight] Core point
> GitHub lançou o Spec Kit (92k+ stars), sistema de 6 comandos que transforma ideias em especificações estruturadas antes de deixar o agente codificar — resolve o maior problema do vibe coding.

## Conteúdo

### O que é o Spec Kit
- Sistema open-source do GitHub para Spec-Driven Development
- Em vez de pedir ao agente que programe diretamente, primeiro converte a ideia em especificação clara

### 6 comandos
| Comando | Função |
|---|---|
| `/speckit.constitution` | Define regras do projeto |
| `/speckit.specify` | Concretiza o que construir |
| `/speckit.clarify` | Elimina dúvidas e ambiguidades |
| `/speckit.plan` | Define stack técnico |
| `/speckit.tasks` | Cria tarefas ordenadas |
| `/speckit.implement` | Agente constrói |

### Resultado
- Entregável = especificação que a IA pode ler, discutir e executar
- Mais clareza, menos improvisação, melhor controle
- Compatível: Claude Code, Copilot, Cursor, Codex, Gemini, 25+ agentes
- Repo: [github.com/github/spec-kit](https://github.com/github/spec-kit)

## Conexões
- [[03-RESOURCES/entities/Guillermo-Casaus]]
- [[03-RESOURCES/concepts/learning-cognition/spec-driven-development]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]

---

## Por que o Spec Kit resolve o maior problema do vibe coding

"Vibe coding" — deixar o agente codificar a partir de descrições informais — produz código que funciona na demo mas quebra em produção. O problema não é o modelo: é a ausência de especificação formal que o modelo possa raciocinar e executar de forma consistente.

O Spec Kit resolve isso criando uma **camada de especificação intermediária** entre a ideia do humano e a implementação do agente. O fluxo passa de:

```
Ideia (informal) → Agente → Código (imprevisível)
```

Para:

```
Ideia → Spec (estruturada, revisável) → Agente → Código (consistente)
```

A spec é um artefato que o humano pode revisar antes de deixar o agente implementar — ponto de controle que elimina o loop de retrabalho.

## Detalhamento dos 6 comandos

### `/speckit.constitution`
Define as regras imutáveis do projeto: stack obrigatória, convenções de código, princípios de arquitetura, o que nunca fazer. É o equivalente de um CLAUDE.md para projetos de software — instalado uma vez, referenciado por todos os outros comandos.

### `/speckit.specify`
Transforma a ideia em especificação estruturada: O QUE construir (features), COMO deve se comportar (user stories), O QUE não deve fazer (negative requirements). Output: documento de especificação que o agente pode ler e executar.

### `/speckit.clarify`
Identifica ambiguidades na spec e gera perguntas específicas antes de avançar. Equivalente ao princípio do @dunik_7: "quando incerto, pare e pergunte" — mas aplicado sistematicamente a toda a spec, não apenas a incertezas pontuais.

### `/speckit.plan`
Define a stack técnica e a arquitetura de implementação: linguagens, frameworks, patterns, estrutura de diretórios. Separar decisão de stack de decisão de feature previne o anti-padrão de escolher tecnologia no meio da implementação.

### `/speckit.tasks`
Decompõe a spec em tarefas ordenadas com dependências explícitas. Cada tarefa é atômica, verificável e tem critério de done definido. O agente pode executar tarefa por tarefa sem perder contexto do objetivo geral.

### `/speckit.implement`
Finalmente, o agente constrói — com spec completa, stack definida, e tarefas ordenadas como contexto. A implementação neste ponto é mecanicamente mais simples porque todas as decisões difíceis já foram tomadas.

## Compatibilidade com 25+ agentes

O Spec Kit foi desenhado para ser agnóstico de agente. O output de cada comando é um documento markdown que qualquer agente (Claude Code, Copilot, Cursor, Codex, Gemini CLI) pode ler e executar. Isso é uma decisão de design importante: a spec não está acoplada a nenhuma ferramenta específica — é portável.

## Comparação: Spec Kit vs CLAUDE.md simples

| Dimensão | CLAUDE.md simples | Spec Kit |
|---|---|---|
| Escopo | Regras de comportamento do agente | Especificação do que construir |
| Granularidade | Project-level | Feature-level |
| Criado por | Desenvolvedor uma vez | Desenvolvedor por feature |
| Referenciado por | Todas as sessões | Sessão de implementação específica |
| Output | Guia de comportamento | Plano de implementação executável |

Os dois são complementares: CLAUDE.md define como o agente age; Spec Kit define o que o agente vai construir.

## Aplicação no vault

O vault usa spec-driven development de forma informal: o CLAUDE.md define o processo de ingestão e interligação, mas cada operação de ingestão não tem uma spec formal. Para projetos maiores (como SEI Automation Agent ou Award Flight Optimizer), o Spec Kit seria o processo correto: `constitution` define as regras do agente, `specify` define as features, `tasks` cria o plano de implementação.

Para o vault em si, o equivalente do Spec Kit é o fluxo de ingestão documentado no CLAUDE.md: cada etapa (source em .raw/, wiki-ingest, hot.md update, interlink) corresponde a uma fase do Spec Kit.

## Limitações

- Adiciona overhead no início: para features simples, o Spec Kit pode ser overkill — o tempo de especificação supera o ganho em qualidade
- Requer disciplina do usuário: pular para `/speckit.implement` sem passar pelos outros comandos derrota o propósito
- A spec pode ficar desatualizada: mudanças de requisito durante implementação precisam ser refletidas na spec manualmente

## Referências adicionais

- [[03-RESOURCES/concepts/learning-cognition/spec-driven-development]] — conceito completo
- [[03-RESOURCES/sources/skills-prompting-mcp/post-dunik-7-claudemd-stop-and-ask]] — princípio de clarificação antes de implementar
- [[03-RESOURCES/sources/guides-courses-howtos/clipping-ai-coding-workflow-neo-kim]] — loop iterativo como alternativa ao spec-first
