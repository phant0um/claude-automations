---
title: 7 skills for any serious Hermes agent
type: source
source: "Clippings/7 skills for any serious Hermes agent.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Um agente Hermes "sério" precisa de mais que um prompt grande e ferramentas — precisa de hábitos de trabalho operacionalizados como skills: design antes de implementação, identidade antes de autonomia, memória de repo antes de redescoberta, memória de sessão antes de resets de contexto, acesso seguro ao workspace antes de cliques livres do modelo, diagramas antes de sistemas mal explicados, e criação de skills antes de repetir o mesmo workflow para sempre.

## Argumentos principais
- A lição central de Hermes do autor: "se eu tenho que lembrar um agente como trabalhar mais de duas vezes, esse comportamento provavelmente pertence a uma skill" — transforma "por favor faça isso sempre" em parte permanente do ambiente do agente.
- A lista de 7 skills cobre falhas diferentes, não se sobrepõem: design, identidade, memória de repo, memória de operador/wiki, acesso a ferramentas externas (Google Workspace), comunicação visual (diagramas), e meta-aprendizado (skill factory).
- Princípio de seleção: não instalar toda skill que existe — observar onde o agente continua falhando e adicionar skills ali.

## Key insights
1. **superpowers - brainstorming**: dá ao agente um "gate" de design antes de agir — entende o projeto, faz uma pergunta por vez, propõe abordagens, escreve o design, espera aprovação, só então planeja. Resolve o failure mode de "output limpo construído sobre uma leitura raquítica da tarefa". Regra: "muito simples para precisar de design" é geralmente onde o erro começa. Usar quando o custo de estar confiantemente errado é maior que o custo de fazer mais uma pergunta.
2. **soul-grader-skill**: avalia o soul.md (arquivo de identidade) do agente com rubrica de 100 pontos. Sintomas de soul.md fraco: agente esquece para que serve, aceita trabalho que deveria recusar, inventa autoridade que não tem, mistura limites de projeto, escreve frases bonitas em vez de aplicar regras. Frame: soul.md deve ser uma "constituição compacta" — sem lore, sem trabalho de "costume", sem runbooks gigantes. Checa mission, role boundaries, hard constraints, authority + escalation, truthfulness, success artifacts, runtime hygiene. Condições de falha úteis: segredos expostos, claims falsas de acesso, publicação/gasto/ações destrutivas sem gate, contaminação cross-client, contradições com docs companheiros, lixo de runtime no lugar errado. Rodar antes do agente ganhar tools, memória, cron jobs, acesso a repo, ou autoridade de postagem.
3. **project-memory-skill**: cria convenção de memória append-only dentro do projeto (`docs/memory/yyyy-mm-dd/descriptive-slug-memory-yyyy-mm-dd.md`). Antes do trabalho, o agente checa a memória do projeto; depois de trabalho significativo, escreve o que mudou, o que foi aprendido, decisões tomadas, decisões abertas, arquivos tocados, docs-fonte, verificação, constraints, gotchas e próximos passos. Não é "dump de transcript" — boa memória de projeto é pequena, datada, pesquisável e útil para a próxima execução.
4. **agent-memory-wiki**: memória/wiki backed by Obsidian para a camada de operador (não o repo). Três peças: obsidian (acesso seguro ao vault, notas markdown, wikilinks, limites de escrita), prepforreset (logs diários e de sessão antes de resets ou fins de sessão), wikijanitor (limpeza conservadora, relatórios de zelador, gaps, candidatos a revisão). Útil para agentes pessoais, de conteúdo, pesquisa, ops, PM — qualquer coisa com continuidade entre dias. A versão útil de memória é curada (decisões, racional, alternativas, artefatos, open loops) — não dump de transcript.
5. **gogcli**: não é tecnicamente uma skill Hermes, mas uma CLI script-friendly para Google Workspace (Gmail, Calendar, Drive, Docs, Sheets, Slides, Tasks, YouTube, admin). Suporta `--json`/`--plain`, hints/progresso em stderr, múltiplas contas, allowlists/denylists em runtime, binários safety-profile, dry-run, MCP típado com comportamento read-only por padrão. A skill define o comportamento em torno do "handle" que a ferramenta dá: quando buscar, o que exige aprovação, o que pode ser rascunhado, o que nunca pode ser enviado/deletado, e qual audit trail fica.
6. **hermeshub diagram maker**: gera diagramas mermaid "render-ready" a partir de linguagem natural — o ponto não é "diagrama bonito", é sintaxe válida e estrutura visível. LLMs quebram mermaid de formas bobas (labels, brackets, arrows, subgraphs, palavras reservadas, tags html, ponto-e-vírgula, diagramas grandes demais); uma skill que conhece esses failure modes evita o loop de corrigir um label e quebrar o próximo. Já foi incorporado nativamente ao Hermes (`/architecture-diagram <prompt>`). Princípio: "se o agente não consegue diagramar o workflow claramente, provavelmente ainda não entende o workflow".
7. **hermeshub skill factory**: a skill meta — transforma trabalho repetido em novas skills. Observa ações repetidas, correções recorrentes, combinações de ferramentas, workflows de domínio, sinais de frustração, momentos "we keep doing this", e tarefas complexas que deveriam se tornar repetíveis. Propõe ou gera um skill.md com triggers, steps, examples, pitfalls, e às vezes interface de plugin/slash-command. Tem restrição: ignora one-offs, passos triviais, workflows já cobertos por outra skill, e coisas muito específicas de contexto para reutilizar.

## Exemplos e evidências
- Citação original: "i keep coming back to the same Hermes lesson: if i have to remind an agent how to work more than twice, that behavior probably belongs in a skill."
- Sequência de prioridade citada pelo autor: design before implementation > identity before autonomy > repo memory before rediscovery > session memory before context resets > safe workspace access before "let the model click around" > diagrams before hand-wavy systems > skill creation before repeating the same workflow forever.
- Caso da skill factory: "i've built 60+ agents and learned the annoying lesson the hard way: memory is everything... the boring project memory that keeps the next [run from re-deriving everything]."

## Implicações para o vault
Confirma e reforça o padrão já presente no vault sobre `loop-engineering-patterns` e `agentic-harness`: skills existem para encapsular workflows repetidos, e a progressão "design → identidade → memória → ferramentas externas → comunicação → meta-skill" é compatível com a arquitetura de cinco camadas já documentada (`claude-code-five-layer-architecture`). O conceito de soul.md como "constituição compacta" reforça o limite de tamanho de CLAUDE.md já registrado em `feedback-claudemd-limits` (200 linhas, regras > exemplos).

## Links
- [[03-RESOURCES/concepts/agent-systems/agentic-harness]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/entities/hermes]]

## Minha Síntese

**O que muda:** Reforça a prática já adotada no vault (skills como `michel-skills:*`) de transformar correções repetidas em skills, e sugere considerar um "soul.md grader" informal para os agentes do `04-SYSTEM/agents/`.

**Conexão pessoal:** Direto — a regra "lembrar mais de duas vezes = skill" já é o princípio implícito atrás dos skills pessoais do usuário (ingest-source, batch-ingest, etc).

**Próximo passo:** Avaliar se algum agente em `04-SYSTEM/agents/core/` carece de um "soul.md" claro com mission/role boundaries/hard constraints explícitos, seguindo a rubrica de 7 pontos descrita aqui.
