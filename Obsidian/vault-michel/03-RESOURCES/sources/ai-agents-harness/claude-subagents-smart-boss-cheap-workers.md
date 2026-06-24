---
title: How to Build Claude Subagents Better Than 99% of People
type: source
source: "Clippings/How to Build Claude Subagents Better Than 99% of People.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
Subagents do Claude Code são markdown files com YAML front matter (igual a skills, nome diferente) que rodam em contexto isolado e fresco — o mental model que faz o padrão funcionar é "um boss inteligente (Opus) delega para um time de workers baratos (Haiku/Sonnet)". Usados certo, mantêm o contexto principal limpo e cortam custo; usados errado (de menos, de mais, ou no caso errado), pioram o resultado.

## Argumentos principais
- **Estrutura orquestrador → especialistas**: a sessão principal é o "boss" que conversa com o usuário e distribui tarefas ("vai ler estes arquivos", "pesquisa isso", "conserta aquilo"). Subagentes só reportam de volta ao boss, nunca ao usuário diretamente.
- **Três motivos para usar subagents**:
  1. **Contexto limpo** — trabalho pesado (research, leitura de muitos arquivos) roda em chat totalmente novo, sem poluir a janela de contexto principal (degradação de qualidade ocorre quando contexto "polui").
  2. **Economia** — sessão principal pode ficar em Opus (caro), mas o subagent faz a mesma pesquisa em Haiku/Sonnet e só o resumo volta.
  3. **Especialização** — em vez de um mega-assistente faz-tudo, cada agente é ótimo em UMA coisa (security auditor, test writer, doc writer, DB architecture expert). É uma "linha de montagem" de agentes.
- **É só um markdown file**: subagent customizado vive em `.claude/agents/` — mesmo formato físico de um `skill.md`, YAML front matter em cima, instruções embaixo.
- **Progressive disclosure via front matter**: Claude Code lê só `name` + `description` para decidir se o agente se aplica ao prompt. Se não aplicar, o resto nunca é carregado — não desperdiça tokens. Por isso `description` é a linha mais importante (é o "trigger").
- **Tuning por uso**: quando um agent não dispara e deveria, pergunte por quê e ajuste a `description`. Iteração baseada em misfires (dois tipos: deveria disparar e não disparou, ou disparou quando não devia).
- **Levers do front matter**: tools permitidas, tools desabilitadas (read-only explícito), MCP servers permitidos, skills que pode invocar. Subagents podem invocar skills e vice-versa — trabalham juntos, não em oposição.
- **Project-level vs global**: agentes de projeto vivem em `.claude/` do repo (vão com o push); agentes globais vivem a nível de usuário, funcionam em todos os projetos da máquina, e NÃO são compartilhados no git. Migrar entre os dois é trivial (é só mover o markdown).
- **Comando `/agents`**: builder interativo — escolhe personal/global/project, "generate with Claude" ou config manual. Passos: (1) tools (read-only é uma opção segura), (2) modelo (Haiku ou inherit do parent), (3) cor (aparece tintado quando o agente roda — visibilidade), (4) memory (project/none/user/local — "none" = agente acorda completamente cego).
- **Trim a description gerada**: quando o Claude gera o agente, a description sai enorme — cortar é necessário, porque progressive disclosure só funciona se a description for enxuta.
- **Quando usar um subagent**:
  - Vai ler muitos arquivos
  - Vai gerar uma "parede" de output
  - É um job repetido (vira agente custom)
  - Trabalho independente e paralelo (ex: revisar 15 capítulos de um livro de uma vez)
  - Quer um revisor sem viés, sem memória, sem contexto prévio
- **Quando NÃO usar**:
  - Edição rápida
  - Passos dependentes entre si (1 → 2 → 3)
  - Agentes precisam conversar entre si (isso é "agent team", não subagents — custa mais)
  - Agente precisa do contexto completo da conversa ou precisa perguntar algo ao usuário
- **Subagents são 1:1 com a sessão principal, não 1:N** — cinco rodando em paralelo não conversam entre si. Coordenação compartilhada = agent team (custo maior).
- **Permission mindset**: se uma IA PODE ler/tocar dados, assuma que vai. "Por favor não faça isso" no prompt não é uma camada real de segurança — restrição de tools/MCP é. Pode limitar com `max_turns` (ex: 10) para evitar loop de pesquisa descontrolado.
- **Math do dinheiro**: relatório de 300 páginas onde você só quer 3 fatos não precisa de Opus, nem de Sonnet — manda para um subagent Haiku, recebe o resumo.

## Key insights
- Repo "Awesome Claude Code Subagents" no GitHub tem centenas de agentes pré-construídos (API designers, backend devs, GraphQL architects, TypeScript/SQL specialists) — pode ser "emprestado"/baixado direto.
- **Caveat de segurança**: arquivos open source podem conter prompt injection ou algo malicioso. Solução: construir um subagent verificador read-only cujo único job é escanear o repo em busca de algo malicioso, sem capacidade de enviar dados a lugar nenhum.
- **Erro mecânico comum**: aspas não fechadas no YAML front matter quebram o parsing inteiro — o agent simplesmente não dispara. Dica: sempre fechar as aspas.
- **Conflito entre skill e subagent**: no exemplo do autor, um "plan roaster" subagent não disparou porque uma skill de "roast" (que já spawna 5 subagentes) pegou o job primeiro. Solução: ser explícito ("usa o subagent plan roaster, não a skill roast").
- **Copiar/colar do terminal é ruim** — melhor ter o agente escrever para um arquivo de texto, ou usar o app desktop.
- **Workflows dinâmicos** ("ultracode" — antigo "workflow"): spawnam de 3 a 40+ subagentes em paralelo a partir da sessão principal. Autor já viu 41 simultâneos, e em teste chegou a 210 — funcionou, mas consumiu o limite de sessão rapidamente. O termo trigger mudou de "workflow" para "ultracode" justamente para evitar disparos acidentais de fan-out gigante.

## Exemplos e evidencias
- Caso de uso real: autor pediu 5 subagents com personas diferentes (beginner Linda 58 anos retired teacher, software engineer, COO de empresa de 12.000 pessoas, publisher) para revisar seu livro em paralelo — cada um em sessão separada, retornaram um review combinado, nota ~8/10.
- Caso "Fireflies.ai": researcher agent fez a pesquisa web em modelo mais barato enquanto a sessão principal ficou em Opus — só o resumo voltou.
- Caso "plan roaster": agent custom configurado como read-only + Haiku + cor pink + memory=project. Testado com plano ruim (barraca de sorvete na praia sem geladeira, vendendo porções minúsculas a $20) — consumiu 22.8K tokens de subagent, zero poluição na sessão principal.

## Implicacoes para o vault
Confirma e detalha o padrão já documentado em [[03-RESOURCES/concepts/claude-code-subagents]] (Receipt Protocol, 10 papéis especializados, restrição estrutural de tools). Pontos novos/complementares para esse concept:
- O critério prático "vai gerar parede de output que você nunca vai reler de novo → delegate" é uma heurística simples e direta para decidir subagent vs inline, complementar ao critério de "passos > 5" já registrado.
- Reforça "permission mindset": restrição de tools é a camada real, prompt não é — alinhado com "restrição estrutural > instrucional" já no concept.
- Detalhe novo: erro de YAML mal-fechado quebra o agente silenciosamente (debug tip a ser lembrado ao criar/editar agents do vault em `04-SYSTEM/agents/`).
- "ultracode" como trigger renomeado para workflows fan-out massivos é um dado novo sobre nomenclatura de comandos — não crítico para o vault-michel hoje, mas relevante se Nexus evoluir para dynamic workflows.

## Links
- [[03-RESOURCES/concepts/claude-code-subagents]]
- [[03-RESOURCES/concepts/agent-systems/parallel-agent-code-review]]
- [[03-RESOURCES/entities/Claude Code]]
