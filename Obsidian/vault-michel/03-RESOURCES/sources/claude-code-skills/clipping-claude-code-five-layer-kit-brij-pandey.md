---
title: "Claude Code: 5 Architectural Layers — Post by @LearnWithBrij"
type: source
source_type: social-media
platform: X/Twitter
author: "@LearnWithBrij"
source_url: "https://x.com/LearnWithBrij/status/2050803172793372769"
published: 2026-05-03
hash: 0ae9f55735145bb1df4b069ec2a51cb8
ingested: 2026-05-05
tags: [claude-code, agent-architecture, five-layers, CLAUDE.md, hooks, subagents, plugins, skills, social-media]
triagem_score: 9
---

# Claude Code: 5 Architectural Layers — @LearnWithBrij

**Author:** [[03-RESOURCES/entities/Brij-Pandey]] (@LearnWithBrij)
**Source:** [X post, 2026-05-03](https://x.com/LearnWithBrij/status/2050803172793372769)

## Summary

O Claude Code possui 5 camadas arquiteturais que a maioria dos engenheiros ignora. Cada camada resolve um problema distinto que LLMs sozinhos não conseguem resolver. Quatro das cinco não têm nada a ver com prompting.

## The 5 Layers

| # | Layer | Role | Key Point |
|---|-------|------|-----------|
| 1 | **CLAUDE.md** | Memory Layer | Regras, convenções, mapa do repo — sempre carregado. A "constituição do agente". |
| 2 | **Skills** | Knowledge Layer | Cada SKILL.md carrega uma descrição; o Claude bifurca em subagente isolado sob demanda. Modular. |
| 3 | **Hooks** | Guardrails Layer | PreToolUse / PostToolUse / SessionStart / Stop — comandos de shell determinísticos e orientados a evento. |
| 4 | **Subagents** | Delegation Layer | Cada subagente tem sua própria janela de contexto, modelo, ferramentas e permissões. Sem recursão. |
| 5 | **Plugins** | Distribution Layer | Empacota habilidades + agentes + hooks + comandos. Uma instalação; toda a equipe herda o comportamento. |

**Envelope externo:**
- MCP Servers à esquerda (GitHub, DBs, APIs)
- Agent Teams à direita (execução paralela, passagem de mensagens, permissões compartilhadas)

## One-liner stack

> CLAUDE.md define regras → Skills fornecem expertise → Hooks aplicam qualidade → Subagentes delegam trabalho → Plugins distribuem para a equipe

## Key Insight

> "A maioria das falhas em produção em sistemas agênticos remete a uma camada ausente."

---

## Cada camada em detalhe

### Layer 1: CLAUDE.md (Memory Layer)

CLAUDE.md é carregado automaticamente em toda sessão. É a "constituição do agente" — o conjunto de regras, convenções, e contexto que o agente deve ter sempre presente. A maioria dos projetos usa CLAUDE.md apenas para regras básicas, mas o poder real está em usá-lo para:
- Mapa do repositório (onde está o quê)
- Decisões arquiteturais que não são óbvias pelo código
- Convenções do time que não estão em linters
- Lista de ferramentas disponíveis

O problema mais comum: CLAUDE.md inchado. Quanto mais regras, menos atenção por regra. Manter "brutalmente enxuto" (como recomenda @Blum_OG) é um princípio de design, não apenas de estilo.

### Layer 2: Skills (Knowledge Layer)

Skills são arquivos SKILL.md que o Claude bifurca em subagente isolado sob demanda. A arquitetura modular tem uma consequência importante: skills não poluem o contexto principal. Quando você invoca `/frontend-design`, um subagente com toda a expertise de design roda em isolamento e retorna o resultado — sem injetar todo o conteúdo do SKILL.md no contexto da sessão principal.

A palavra-chave é "sob demanda": o skill só existe (em termos de consumo de contexto) quando está sendo usado. Isso é radicalmente diferente de colocar toda a expertise de design no CLAUDE.md — que a injeta em toda sessão, seja relevante ou não.

### Layer 3: Hooks (Guardrails Layer)

Hooks são a única camada verdadeiramente determinística. CLAUDE.md pode ser mal interpretado. Skills podem fazer escolhas inesperadas. Hooks executam comandos de shell independentemente do que o agente decide — antes ou depois de ações específicas, no início ou fim de sessão.

Casos de uso práticos:
- **PreToolUse:** validar que o arquivo a ser editado existe antes de tentar editar
- **PostToolUse:** rodar lint automaticamente após qualquer edição de código
- **SessionStart:** carregar estado de sessão anterior, verificar dependências
- **Stop:** gerar relatório de sessão, atualizar memória

A distinção crucial: hooks são cidadãos de primeira classe para qualidade — não workarounds. Um pipeline de qualidade que depende apenas de instruções no CLAUDE.md é frágil; um que usa hooks é robusto.

### Layer 4: Subagents (Delegation Layer)

Cada subagente tem sua própria janela de contexto, modelo, ferramentas, e permissões. "Sem recursão" significa que subagentes não podem criar sub-subagentes por padrão — isso é uma proteção contra hierarquias de agentes incontroláveis.

A propriedade mais valiosa: isolamento de contexto. Quando o agente principal delega pesquisa ao subagente, o subagente consome tokens de pesquisa em seu próprio contexto — não no do agente principal. O principal recebe apenas o resumo. Isso mantém o contexto do orquestrador limpo enquanto permite exploração profunda em paralelo.

### Layer 5: Plugins (Distribution Layer)

Plugins empacotam skills + agentes + hooks + comandos em uma unidade instalável. "Uma instalação; toda a equipe herda o comportamento" é a propriedade que diferencia plugins de outros mecanismos: eles resolvem o problema de distribuição de comportamento em equipes.

Sem plugins, cada desenvolvedor do time precisa configurar manualmente seu próprio CLAUDE.md, instalar seus próprios skills, e configurar seus próprios hooks. Com plugins, o tech lead publica um plugin que estabelece as práticas do time, e todos os membros herdam automaticamente.

## "A maioria das falhas em produção remete a uma camada ausente"

O insight central é que cada camada resolve um problema que as outras não resolvem:

| Problema | Camada correta |
|---|---|
| Agente não sabe as convenções do projeto | CLAUDE.md |
| Agente não tem expertise de domínio | Skills |
| Comportamento inconsistente entre sessões | Hooks |
| Contexto do orquestrador explodindo | Subagents |
| Time não adota as mesmas práticas | Plugins |

Usar apenas CLAUDE.md e subagentes (o caso mais comum) deixa guardrails e distribuição desprotegidos. Um sistema sem hooks pode ter comportamento correto em média mas com outliers destrutivos. Um sistema sem plugins tem as práticas do time fragmentadas por desenvolvedor.

## O envelope externo: MCP Servers e Agent Teams

Brij Pandey menciona dois sistemas além das 5 camadas:
- **MCP Servers à esquerda:** GitHub, bancos de dados, APIs externas — ferramentas que vivem fora do agente mas são acessíveis por ele
- **Agent Teams à direita:** execução paralela, passagem de mensagens entre agentes, permissões compartilhadas — o que existe acima do nível de subagente único

Agent Teams é a camada mais nova e menos estabelecida. Requer modelos frontier para todos os participantes e tem desafios não resolvidos de coordenação (deadlocks, ciclos de mensagem, resolução de conflitos).

## Relação com o vault-michel

O vault-michel implementa 4 das 5 camadas:
- **CLAUDE.md** — o arquivo raiz do vault com convenções e estrutura
- **Skills** — claude-obsidian skills (wiki-ingest, wiki-lint, autoresearch, etc.)
- **Hooks** — session startup, relatório de sessão
- **Subagents** — batch ingest usa subagentes paralelos por fonte

A camada ausente é **Plugins** — o vault não tem distribuição de comportamento porque é um projeto de uma pessoa. Se o vault fosse operado por um time, plugins seriam o mecanismo de garantir que todos usem os mesmos workflows de ingest.

**See Also:**
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-five-layer-architecture]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]]
