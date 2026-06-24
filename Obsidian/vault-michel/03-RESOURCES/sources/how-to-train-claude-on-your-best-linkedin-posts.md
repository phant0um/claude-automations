---
title: "How to train Claude on your (best) LinkedIn posts"
type: source
source: "Clippings/How to train Claude on your (best) Linkedin posts.md"
created: 2026-06-21
ingested: 2026-06-21
tags: [ai-agents, claude-code-tooling]
---

## Tese central
Workflow para criar um "skill" pessoal de escrita no Claude: extrair os próprios posts públicos do LinkedIn via ferramenta de scraping legal/pública (Apify, ~$2/1000 posts), subir a planilha ao Claude, gerar um relatório de padrões dos melhores posts, e então criar um `/skill` reutilizável que invoca esse padrão sempre que se quer escrever um novo post.

## Argumentos principais
- O ciclo proposto é: extrair dados públicos próprios → treinar Claude num relatório derivado desses dados → empacotar como skill reutilizável → usar repetidamente, criando um "loop de feedback positivo" (posts melhores → skill mais afiado → próximos posts melhores).
- Recomendação explícita de não automatizar diretamente na própria conta (risco de ToS) — extrair dados via ferramenta separada, depois treinar Claude offline com o export.
- Resultado final: ao invocar o skill, Claude gera múltiplas opções de post (texto + sugestão de imagem) com base apenas nos melhores posts do próprio usuário, não em dados genéricos da internet ("provavelmente desatualizados").

## Key insights
- O padrão "extrair seu próprio histórico de melhor desempenho → derivar skill personalizado → reusar" é generalizável a qualquer domínio de escrita repetitiva — é estruturalmente o mesmo padrão de personal-skill-from-corpus que poderia se aplicar a outros formatos (ex.: gerar prompts de estudo a partir do próprio histórico de notas FIAP/concurso).

## Exemplos e evidências
- Workflow passo-a-passo completo com ferramenta específica (Apify), custo real (~$1 por 489 posts extraídos), e prompt de exemplo para o passo de treino.

## Implicações para o vault
Padrão replicável para o vault: criar um skill pessoal derivado de corpus próprio (ex.: posts, notas, respostas) já documentado e versionado. Não diretamente aplicável hoje (vault não gera conteúdo de LinkedIn), mas o padrão "corpus pessoal → skill" é candidato de design caso o usuário queira automatizar geração de conteúdo a partir de notas do vault.

## Links
- [[03-RESOURCES/concepts/agent-systems/claude-code-agent]]
