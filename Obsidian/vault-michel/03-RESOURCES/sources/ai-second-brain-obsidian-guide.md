---
title: "Your life with an AI Second Brain (Obsidian Guide)"
type: source
source: "Clippings/Your life with an AI Second Brain (Obsidian Guide).md"
created: 2026-06-19
ingested: 2026-06-19
tags: [articles]
---

## Tese central
Em vez de tentar fazer o Claude "lembrar tudo" dentro de uma única conversa (repetindo contexto manualmente), a solução melhor é um vault local em Markdown (Obsidian) lido/escrito pelo Claude via MCP filesystem server com aprovação explícita — Obsidian como cérebro legível por humano, Claude como camada de raciocínio, MCP como ponte entre os dois.

## Argumentos principais
- O setup recomendado tem 3 partes: Obsidian (armazena notas como Markdown puro, arquivos editáveis por qualquer ferramenta), Claude Desktop (raciocina sobre as notas, resume, redige), e um MCP filesystem server (ponte controlada — você escolhe exatamente qual diretório é acessível).
- Regra de ouro: "mantenha chato" — nunca conectar o Claude ao computador inteiro ou à pasta home; nunca incluir segredos/senhas/API keys/dados financeiros privados no vault; começar com um vault novo (menos histórico, menos risco) em vez do vault grande existente.
- Estrutura de pastas proposta: `00-INBOX/` (capturas brutas), `01-SOURCES/` (material-fonte, mantido próximo do original), `02-NOTES/` (notas evergreen — a parte que ganha valor com o tempo), `03-PROJECTS/` (projetos ativos), `04-SOPS/` (procedimentos — "onde o Claude aprende como você faz as coisas"), `05-CLAUDE-OUTPUTS/` (área de escrita do Claude por padrão, mantendo as notas-fonte seguras), e um `CLAUDE.md` raiz com as regras.
- O CLAUDE.md é descrito como "a constituição" do vault: regras de leitura (ler pastas X antes de responder, citar o caminho da nota ao fazer uma afirmação, dizer o que falta se o vault não tiver informação suficiente), regras de escrita (escrever rascunhos só em 05-CLAUDE-OUTPUTS, nunca deletar/renomear/reorganizar sem aprovação explícita, propor mudanças antes de editar notas-fonte), regras de segurança (nunca guardar segredos, nunca inferir fatos privados não escritos no vault), e estilo de output (respostas concisas, citar caminhos, markdown limpo). Meta: menos de 200 linhas.
- O passo a passo técnico cobre: criar a pasta do vault, abrir como vault no Obsidian, configurar o `claude_desktop_config.json` apontando o servidor `@modelcontextprotocol/server-filesystem` exclusivamente para o diretório do vault, reiniciar o Claude Desktop, testar leitura antes de testar escrita.
- Modelo de permissão recomendado explicitamente: Claude pode **ler** todas as pastas de conteúdo; Claude pode **escrever** apenas em `05-CLAUDE-OUTPUTS/`; deletar, renomear, reorganizar, editar notas-fonte ou projeto, ou tocar em qualquer coisa fora do vault exige aprovação explícita. "A forma mais rápida de arruinar uma base de conhecimento local é deixar o assistente reorganizar tudo antes da estrutura estar provada."
- Fluxo de "promoção": capturar no INBOX → guardar fonte em SOURCES → pedir ao Claude para processar em rascunhos em CLAUDE-OUTPUTS → mover manualmente os bons outputs para NOTES/PROJECTS/SOPS. Isso mantém o vault "human-owned": o Claude ajuda a comprimir/sintetizar/redigir, mas o humano decide o que se torna memória permanente.
- A regra de citação de caminho ("cite o note path") é o mecanismo central de honestidade: se o Claude afirma algo sem apontar o arquivo-fonte, deve ser tratado como suposição, não fato.

## Key insights
- A janela de chat é um sistema de memória de longo prazo ruim — ótima para uma conversa única, fraca como base de conhecimento permanente. Um vault Markdown local é "chato da melhor forma": pode ser aberto sem o Claude, editado sem o Obsidian, buscado com ferramentas normais, sincronizado, e sobrevive caso o usuário troque de app de IA.
- A virada de framing é a tese central do artigo: em vez de pedir "lembre de tudo sobre meu trabalho", você pede "leia as notas que eu escolhi, siga as regras que eu escrevi, cite os arquivos que você usou, e redija para esta pasta" — um contrato muito mais verificável.
- Versão "beginner": vault único, 5 pastas, CLAUDE.md com os limites, servidor MCP filesystem apontando só para o vault, e a instrução mínima "leia meu vault antes de responder, escreva rascunhos só em 05-CLAUDE-OUTPUTS, cite os caminhos, peça antes de editar qualquer coisa".

## Exemplos e evidências
- Exemplo de config JSON completo do `claude_desktop_config.json` usando `npx -y @modelcontextprotocol/server-filesystem <path>`.
- Prompts de teste concretos fornecidos para validar leitura (`Read 02-NOTES/test-note.md... Cite the note path`) e escrita segura (`Create a short Markdown draft in 05-CLAUDE-OUTPUTS/test-output.md... Do not edit any other files`).
- Lista de 6 prompts de uso prático pós-setup: project briefing, inbox cleanup (gera plano sem mover nada), source summary, criação de SOP a partir de nota desorganizada, project memory, e escrita de artigo a partir de contexto do vault com citação de fontes.

## Implicações para o vault
- Este artigo descreve essencialmente a arquitetura que o vault-michel **já implementa** (estrutura de pastas numeradas, CLAUDE.md como contrato comportamental, regra de citar caminhos, separação leitura/escrita) — é validação externa e bem alinhada do design existente, não uma novidade a adotar.
- O ponto mais aplicável de fato é a disciplina de "promoção manual": o vault-michel já tem 07-QUEUE/ e 00-INBOX/, mas vale reforçar a prática de o Claude propor planos de limpeza (sem mover/editar) antes de qualquer reorganização de Clippings/ ou 00-INBOX — alinhado ao princípio "Simplicity first" e "Surgical changes" do CLAUDE.md atual.
- Confirma fortemente o conceito já catalogado `pkm-obsidian` e `second-brain`, e a tese central do artigo "a chat window é má memória de longo prazo, markdown plano é boa" é evidência direta para `self-writing-vault` e `llm-wiki-pattern`.

## Links
- [[03-RESOURCES/concepts/pkm-obsidian/pkm-obsidian]]
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/entities/Obsidian]]
- [[03-RESOURCES/entities/Claude]]
