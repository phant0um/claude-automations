---
title: How to Set Up Claude Loops That Keep Working While You Sleep (Step by Step)
type: source
source: "Clippings/How to Set Up Claude Loops That Keep Working While You Sleep (Step by Step).md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
O salto de produtividade não vem de um modelo melhor, mas de mudar o modo de uso: de "um prompt por vez" para loops — Claude executando em cron, repetidamente, sem precisar ser iniciado manualmente — e depois para "routines" no servidor, que continuam rodando mesmo com o laptop fechado.

## Argumentos principais
- Um prompt único roda uma vez e morre; um loop roda por conta própria, repetidamente, sem o usuário reiniciar cada vez — mecanismo é deliberadamente simples: Claude usa cron, intervalo definido pelo usuário (a cada minuto, 30 min, todas as noites).
- O intervalo deve casar com a natureza da tarefa: coisas que mudam rápido (CI) recebem loops apertados; coisas lentas (resumo diário) recebem uma passada noturna.
- O poder real está em rodar muitos loops em paralelo, cada um responsável por um único job (um cuida de PRs e CI, outro mantém a suíte de testes, outro agrega feedback) — assim uma pessoa atinge o volume de um time.
- A mudança mental central: parar de pensar "o que eu prompto a seguir" e passar a pensar "que job deveria rodar por conta própria a partir de agora". Qualquer coisa feita mais de duas vezes, checada manualmente, ou que quebra às 3h da manhã é candidata a loop.
- Loops locais morrem quando o laptop fecha; a correção são "routines" no servidor — mesma ideia, mas configurada uma vez e disparada por schedule, webhook ou API call, independente da máquina do usuário estar ligada.
- Comece com um loop, não dez — sistemas com dez loops e dashboard no dia 1 colapsam no fim de semana porque não dá para saber qual loop fez o quê. Um bom primeiro loop tem três propriedades: schedule claro, job estreito que não pode ser mal-interpretado, output que se verifica em segundos.
- Loops vagos falham ("melhorar a base de código" não é um loop, é um desejo); loops específicos funcionam ("achar funções com mais de 50 linhas e abrir uma issue para cada").
- Humano no loop, não em todo loop: cada loop tem uma "lane" e passos arriscados ainda esperam aprovação — um bot de PR pode rebase e corrigir CI sozinho, mas merge para main ainda pinga o usuário; o objetivo é zero humanos nos 95% chatos e atenção total nos 5% que carregam risco real.

## Key insights
- A pessoa que criou o Claude Code não escreve uma linha de código este ano, roda a maior parte do celular, e tem milhares de agentes trabalhando à noite — citado como prova de conceito do modelo "loops, não prompts".
- O gargalo nunca foi o modelo — é decidir quais partes do trabalho nunca mais deveriam precisar de você.
- Definir as fronteiras de risco uma vez, nas instruções do loop, e elas valem para toda execução seguinte — "você não está cuidando do trabalho, está cuidando das regras, e as regras estão escritas".
- A primeira semana parece overhead (escrever schedules, loops falhando, ajustar instruções); ao fim da semana a matemática se inverte e o usuário para de abrir o Claude para perguntar coisas e passa a abrir para checar o que já foi feito — a janela de chat se torna painel de status, não workspace.

## Exemplos e evidências
- Exemplos concretos de loops citados: babysitter de PR que corrige CI falhando, mantenedor de suíte de testes que conserta testes flaky, cluster de feedback que processa um feed a cada 30 minutos.
- Caso de uso de migração: um loop pode abrir cem pull requests, mas um humano aprova o primeiro antes do resto sair.

## Implicações para o vault
Reforça diretamente o padrão de scheduled-ingest-routine e weekly-knowledge-routine já presentes no vault (ingest-report semanal, hot cache). Sugere considerar versão "routine" (servidor) para o pipeline de triagem A/B → ingest, hoje disparado manualmente — candidato a próxima evolução do sistema Nexus se o volume de Clippings continuar a crescer.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-loop]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]]
- [[03-RESOURCES/concepts/pkm-obsidian/scheduled-ingest-routine]]
- [[03-RESOURCES/concepts/pkm-obsidian/weekly-knowledge-routine]]
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/Boris-Cherny]]
