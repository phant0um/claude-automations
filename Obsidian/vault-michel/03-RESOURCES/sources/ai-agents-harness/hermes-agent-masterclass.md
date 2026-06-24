---
title: "How to Read This"
type: source
source: Clippings/Hermes Agent Masterclass.md
source_type: clipping
created: 2026-05-19
ingested: 2026-05-19
triagem_score: 7
triagem_cat: ai-agents
tags: [ai-agents, clipping, hermes-agent]
---

## Tese central

Sistema agêntico self-improving: o Hermes Agent memoriza entre sessões, escreve suas próprias skills reutilizáveis, e as poda em background — formando um flywheel de melhoria contínua sem intervenção humana constante.

## Key insights

- Remembers across sessions — memória persistente via HNSW vectors, não apenas in-context
- Writes its own reusable skills — ao detectar padrão recorrente, gera um skill file automaticamente
- Prunes them in the background — avalia skills existentes por uso e qualidade, remove as obsoletas

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]]
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]]

## Fonte

Arquivo original: `Clippings/Hermes Agent Masterclass.md`

---

## O que torna o Hermes diferente

A maioria dos agentes LLM começa cada sessão do zero. Hermes Agent inverte esse padrão: o agente se lembra de sessões anteriores, aprende padrões recorrentes, e gera suas próprias ferramentas para lidar com esses padrões de forma mais eficiente.

É a diferença entre um assistente que você precisa re-treinar toda vez e um assistente que fica mais capaz com o uso — sem fine-tuning do modelo base.

## Os três mecanismos centrais

### 1. Memória entre sessões

Hermes usa HNSW vector memory para persistir contexto além do context window de uma sessão. Ao final de cada sessão, informações relevantes são embedadas e armazenadas. No início da próxima sessão, o agente recupera memórias relevantes ao contexto atual.

**Tipos de memória persistida:**
- Preferências e padrões do usuário
- Decisões tomadas e seus raciocínios
- Erros cometidos e como foram corrigidos
- Patterns de tarefas recorrentes

Isso resolve o problema fundamental de amnésia de agentes: o assistente não precisa que o usuário re-explique o contexto do projeto a cada sessão.

### 2. Auto-geração de skills

Quando o agente detecta que realizou a mesma sequência de ações 3+ vezes, gera automaticamente um arquivo de skill (`.md`) que captura aquela sequência como um slash command reutilizável.

**Processo:**
1. Agente monitora padrões nos seus próprios action logs
2. Ao detectar recorrência, extrai a sequência de steps
3. Gera um skill file com: trigger, steps, expected output, edge cases conhecidos
4. Skill fica disponível como `/nome-da-skill` imediatamente

Isso é análogo a um desenvolvedor que, depois de fazer a mesma coisa 3 vezes manualmente, escreve um script. O Hermes faz isso autonomamente.

### 3. Pruning em background

Skills acumulam. Sem curadoria, o sistema fica poluído com skills obsoletas, redundantes, ou de baixa qualidade. Hermes roda um processo de pruning periódico que:

- Avalia cada skill por taxa de uso (skills nunca invocadas são candidatas a remoção)
- Verifica se o comportamento da skill ainda é correto (regride contra golden examples)
- Identifica skills redundantes e as consolida
- Remove skills cuja funcionalidade foi incorporada em skills mais gerais

O resultado: o portfólio de skills fica enxuto e relevante, sem intervenção manual.

## Flywheel de melhoria contínua

Os três mecanismos formam um ciclo:

```
Memória entre sessões
    ↓
Contexto rico → melhor detecção de padrões
    ↓
Padrões detectados → skills geradas
    ↓
Skills usadas → feedback de qualidade → pruning
    ↓
Skills refinadas → tarefas executadas mais eficientemente
    ↓
Mais contexto → ciclo continua
```

Com o tempo, o agente fica progressivamente mais capaz no domínio específico de uso do usuário — sem retreinamento do modelo base.

## Comparação com abordagens manuais

| Dimensão | Abordagem manual | Hermes |
|---|---|---|
| Memória | Usuário re-explica contexto | Recuperação automática por relevância |
| Skills | Usuário escreve e mantém | Agente gera e poda automaticamente |
| Melhoria | Depende de intervenção consciente | Contínua, em background |
| Overhead | Alto (curadoria constante) | Baixo (supervisão ocasional) |
| Personalização | Limitada pela disponibilidade do usuário | Escala com uso |

## Casos de uso ideais

**Desenvolvimento de software:** o agente aprende o stack específico, convenções de código, processos de deploy. Skills geradas cobrem workflows recorrentes do projeto.

**Research e análise:** o agente lembra o histórico de pesquisa, aprende os tipos de fontes preferidas, gera skills para formatos de análise recorrentes.

**Gestão de projetos:** memória de decisões e contexto de projetos. Skills para reportes, updates, e formatos de comunicação estabelecidos.

## Limitações e riscos

**Skills de baixa qualidade:** se o padrão detectado for baseado em comportamento incorreto (agente cometeu erros de forma consistente), a skill gerada captura o erro. O pruning por qualidade depende de golden examples corretos.

**Memória como viés:** memórias do passado podem ser inadequadas para contextos novos. "Na última semana usamos X" não significa que X é correto para este novo projeto. Requer mecanismo de decay ou invalidação.

**Custo de storage:** embeddings de todas as memórias acumulam. Em uso intensivo, o custo de armazenar e recuperar memórias pode ser significativo.

**Privacidade:** memórias persistentes de sessões contêm informação potencialmente sensível. Onde ficam armazenadas, quem tem acesso, e como expiram são questões críticas em contextos profissionais.

## Relevância para o vault

O vault-michel tem um equivalente manual ao Hermes: skills em `~/.claude/skills/` são geradas e curadas por Michel, não pelo agente. O errors.md captura aprendizados mas o processo de incorporar esses aprendizados em behavior change é manual. A implementação do modelo Hermes no vault seria: agente que monitora padrões nas interações com o Nexus, propõe novas skills baseadas em padrões detectados, e alerta quando skills existentes parecem obsoletas — reduzindo overhead de curadoria sem eliminar controle humano.

## Links relacionados

- [[03-RESOURCES/sources/hermes-agent/clipping-release-hermes-agent-v0120-2026430]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-ruflo-multi-agent-platform]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]]
