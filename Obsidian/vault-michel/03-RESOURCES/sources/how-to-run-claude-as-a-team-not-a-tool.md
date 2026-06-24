---
title: How to Run Claude as a Team, Not a Tool (Copy-Paste Crew Setup)
type: source
source: "Clippings/How to Run Claude as a Team, Not a Tool (Copy-Paste Crew Setup).md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Usar um único Claude generalista para múltiplas funções (pesquisar, redigir, editar, julgar) produz qualidade mediana em tudo porque nenhuma etapa recebe esforço total e a etapa de julgamento nunca é honesta sobre o próprio trabalho do mesmo agente; a solução é separação de papéis — um "crew" de roles especializados com handoffs limpos, escalável em três níveis: copy-paste, Skill, sub-agent.

## Argumentos principais
- O "generalist trap": ninguém contrataria uma única pessoa para pesquisar, redigir, editar E julgar honestamente o próprio trabalho — mas é exatamente isso que um prompt único faz com Claude.
- Um modelo maior ou um prompt mais longo não resolve o problema, porque ainda é "um funil único" recebendo um cano mais largo — a separação de concerns é o que resolve.
- Três níveis de maturidade, sem necessidade de pular etapas: (1) Copy-paste — colar a config de role no topo do chat, sem setup; (2) Skill — salvar como SKILL.md reutilizável, carregado automaticamente quando a tarefa encaixa; (3) Sub-agent — cada role roda em instância isolada do Claude Code com prompt, contexto, tools e modelo próprios.
- Sub-agents trazem três vantagens que o role colado não tem: (a) mantêm a "bagunça" (leituras, buscas) fora da thread principal — você recebe só a conclusão; (b) tools podem ser restringidas por role (editor não roda código, pesquisador não deleta arquivos) — "a cerca é a feature"; (c) roteamento de modelo por dificuldade (Haiku para trabalho bruto, Sonnet para drafts/edição, Opus para julgamento) evita pagar preço premium por tarefas simples.
- O crew de 5 roles: Strategist (julga se vale fazer, roda primeiro, veredito ship/fix/kill sem gentileza), Researcher (só fatos verificados, marca o que não pode confirmar como "unverified", separa marketing de fato independente), Drafter (escreve na voz do usuário, usa só fatos verificados do researcher, nunca adiciona claims), Editor (corta 20% por passagem, nunca muda o sentido), Critic/Red-team (ataca como um cético, aponta a claim mais fraca e a lacuna que falta).
- Um role bom tem um job e um output claro; o segundo que um role começa a fazer três coisas e devolver "mush", deve ser dividido.
- Não automatizar (promover a sub-agent) um role que ainda não foi observado funcionando — "um sub-agent só roda seus erros mais rápido".

## Key insights
- A honestidade do julgamento morre no momento em que o escritor precisa avaliar o próprio trabalho — daí a necessidade estrutural de separar quem escreve de quem critica.
- Handoffs automáticos (sub-agent) exigem Claude Code (terminal); os configs de role em si são no-code e funcionam imediatamente ao colar.
- O ganho real não é "drafts mais limpos" — é a mudança de papel do usuário: de escritor para diretor que aprova handoffs.

## Exemplos e evidências
- Exemplo real ponta a ponta: tarefa de decidir se uma ideia de post vale a pena e escrever a linha de abertura. Strategist retorna veredito "fix" com razão específica (linha genérica, "sinaliza pule-me"); Researcher confirma que é opinião, não fato; Drafter entrega a primeira linha; Editor corta o setup e lidera com a acusação; Critic lista 3 objeções específicas com fix de uma linha cada.
- Configs completos de prompt fornecidos literalmente para cada um dos 5 roles, incluindo o "prompt único que roda o crew inteiro" em sequência com pausa entre Strategist e Researcher.
- Exemplo de SKILL.md (nível 2) e de `.claude/agents/editor.md` (nível 3, com `tools: Read, Edit` e `model: sonnet`) mostrando a progressão concreta entre os três níveis.

## Implicações para o vault
Confirma e operacionaliza o padrão de "subagent por fonte" já adotado neste pipeline de ingest (um subagent paralelo por source). Reforça a prática de restringir tools por role (ex.: agente de triagem só lê, agente de ingest só escreve em pastas específicas) e de rotear modelo por dificuldade — já presente no projeto via ADR-003 (triagem Claude-only) e no sistema de model-routing do vault.

## Links
- [[03-RESOURCES/concepts/agent-systems/subagent-pattern-empirical]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/Claude Code]]
