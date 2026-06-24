---
title: How to Build an AI Second Brain With Claude and Obsidian (Full Guide)
type: source
source: Clippings/How to Build an AI Second Brain With Claude and Obsidian (Full Guide) He's getting smarter every da.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Um "Second Brain" funcional é a combinação de Obsidian (vault local, plain text, dados do usuário) com Claude Code agindo como camada cognitiva sobre esse vault — lendo, conectando e expandindo notas. É a implementação prática do padrão "LLM Wiki" popularizado por Andrej Karpathy (abril 2026): ao contrário de histórico de chat que decai em ruído, o vault melhora a cada uso porque o conhecimento é persistido em arquivos versionáveis, não em contexto efêmero.

## Argumentos principais
- **Separação de responsabilidades**: Obsidian é o Vault (armazenamento local, plain text, grafo de links); Claude é o Brain (leitura, classificação, síntese). Por serem arquivos de texto puro, o usuário nunca fica vendor-locked — troca de modelo no futuro é apenas redirecionar o ponteiro para a mesma pasta.
- **Bridge via MCP**: a conexão Claude↔Obsidian usa o protocolo MCP (Model Context Protocol) através do plugin "Local REST API" do Obsidian, que expõe uma API key local consumida via `claude mcp add-json` apontando para `127.0.0.1:27124`.
- **Identidade via entrevista, não escrita manual**: em vez do usuário escrever a própria bio, o Claude conduz uma entrevista pergunta-a-pergunta (quem é, objetivos do ano, tom de comunicação preferido, forças/fraquezas, projetos atuais) e consolida tudo em um `CLAUDE.md` na raiz do vault — carregado automaticamente toda sessão.
- **Estrutura de projeto em 4 pastas**: cada projeto ativo recebe `Inputs/ Process/ Outputs/ Feedback/` mais um `CLAUDE.md` local descrevendo objetivo e papel do agente — criando um pipeline limpo e replicável por projeto.
- **Scoping de contexto (vault macro vs. micro)**: para manter o Claude "no pico de afiação", o usuário deve abrir a pasta do projeto específico como sub-vault (Obsidian → Manage vaults → Open folder as a vault), de forma que o Claude leia só o `CLAUDE.md` daquele projeto, não o vault inteiro. O vault macro fica reservado para planejamento de alto nível.
- **Skills como workflows reutilizáveis**: tarefas repetidas devem ser convertidas em arquivo skill (markdown) com nome claro e descrição de quando disparar — eliminando a necessidade de re-explicar o processo a cada execução.

## Key insights
- O padrão "LLM Wiki" inverte a curva normal de degradação de contexto: em vez de decair, o sistema fica mais afiado com o uso porque conhecimento é persistido como arquivo, não como conversa.
- A arquitetura plain-text é, em si, uma forma de governance/portabilidade: dados não pertencem a uma plataforma específica.
- O "Bike Method" implícito aqui (delegação gradual de autonomia) aparece via scoping: vault macro = estratégia (lido raramente), vault micro = execução (lido constantemente).
- O setup completo é descrito como executável "em uma noite", mesmo por quem nunca usou Obsidian ou Claude Code — friction de entrada é deliberadamente baixa.

## Exemplos e evidências
- Comando exato de bridge MCP: `claude mcp add-json obsidian-vault '{ "type": "stdio", "command": "uvx", "args": ["mcp-obsidian"], "env": { "OBSIDIAN_API_KEY": "...", "OBSIDIAN_HOST": "127.0.0.1", "OBSIDIAN_PORT": "27124" } }'`.
- Teste de conexão recomendado: pedir ao Claude "List every file in my Obsidian vault" — se retornar as notas de teste, a integração está ativa.
- Prompt de entrevista de identidade fornecido literalmente no artigo, estruturado para perguntar um item por vez e aguardar resposta antes de avançar.
- Prompt de scaffold de projeto fornecido literalmente, parametrizável por nome de projeto (ex.: `youtube-channel`).

## Implicações para o vault
Este é o blueprint que o próprio vault-michel já implementa (Obsidian + Claude Code + CLAUDE.md + MCP), confirmando que a arquitetura adotada está alinhada com o padrão emergente "LLM Wiki" descrito por Karpathy. O artigo não introduz nada estruturalmente novo frente ao que já está em produção aqui, mas serve como validação externa do desenho e como checklist de onboarding para replicar o setup em outro contexto (ex.: ensinar terceiros).

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/pkm-obsidian/self-writing-vault]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]

## Minha Síntese

**O que muda:** Nada estrutural — o artigo descreve exatamente a arquitetura que o vault-michel já roda (Obsidian + Claude Code + CLAUDE.md + MCP via Local REST API), funcionando como validação externa do desenho já adotado.

**Conexão pessoal:** É literalmente o blueprint do projeto vault-michel; serve como material de referência caso eu precise explicar ou replicar o setup para outra pessoa do zero.

**Próximo passo:** Nenhum próximo passo imediato — vault já implementa todos os passos descritos.
