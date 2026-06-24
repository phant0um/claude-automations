---
title: "feat: read-only virtual-filesystem explorer for courses (PR #1048, mattpocock/course-video-manager)"
type: source
source: "Clippings/feat read-only virtual-filesystem explorer for courses by github-actionsbot · Pull Request 1048 · mattpocockcourse-video-manager.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [articles]
---

## Tese central
Um PR de produção implementa um agente de IA somente-leitura embutido como painel lateral em uma plataforma de gestão de cursos, que explora o conteúdo via uma metáfora de **filesystem virtual** (VFS): cursos, seções, lições e vídeos mapeados como diretórios, com metadados e conteúdo expostos como arquivos JSON folha — navegáveis por quatro ferramentas no estilo bash (`ls`, `tree`, `cat`, `grep`).

## Argumentos principais
- O VFS é enraizado no catálogo de todos os cursos não-arquivados, com o curso atualmente aberto funcionando como uma "âncora imutável" para escopo padrão — ou seja, o agente sabe contextualmente em que curso o autor está trabalhando sem precisar perguntar.
- Quatro ferramentas com sabor Unix dão ao agente navegação familiar: `ls` e `tree` para explorar a árvore, `cat` para ler arquivos-folha com um **vocabulário de filtro fechado** (closed filter vocabulary) — restringindo o que pode ser projetado, para eficiência de tokens — e `grep` para busca de conteúdo via regex do Postgres.
- Migrações de unicidade foram aplicadas nos quatro níveis de entidade (curso, seção, lição, vídeo) para garantir que os caminhos do VFS sejam estáveis e round-trippable (uma busca por caminho sempre resolve para a mesma entidade).
- Os schemas Zod dos arquivos-folha já são desenhados como **futuros contratos de escrita** — a v1 é estritamente somente-leitura, mas a arquitetura já antecipa uma v2 com capacidade de escrita usando o mesmo modelo de endereçamento.
- O PR foi decomposto em 6 sub-issues sequenciais: migração de unicidade de nome de curso, migração de unicidade de caminho (seção/lição/vídeo), modelo VFS (endereçamento + geradores de folha + schemas Zod), rota do loop do agente + ferramenta `ls` + conexão do painel ao backend real, ferramentas `tree`+`cat` com vocabulário de filtro, e ferramenta `grep` (regex Postgres, locators, modos).
- Processo de revisão automatizada (`github-actions[bot]`) identificou e o autor corrigiu antes do merge: (1) condição de corrida de path duplicado dentro do mesmo batch de criação (`createSections`/`createLessons` checavam contra o banco mas não entre itens do próprio batch — corrigido com dedup via `Set` antes do guard loop), retornando erro tagueado 409 em vez de uma violação de constraint bruta (500); (2) uma classe de erro anônima (`class extends Error`) substituída por `UnknownDBServiceError` para manter o padrão `_tag` discriminador usado em todo o resto do código; (3) escritas excessivas em localStorage durante streaming (a cada token recebido, o efeito reescrevia a lista completa de threads) — corrigido com debounce de 500ms e um efeito de cleanup que garante flush ao desmontar o componente.
- Observação não-bloqueante registrada mas não resolvida no PR: downgrade do pacote `@ai-hero/sandcastle` de `^0.10.0` para `^0.5.12`, com o bot sinalizando que, se intencional (quebra de API na 0.10), merece nota na descrição do PR; se acidental, deveria ser revertido.

## Key insights
- O padrão "VFS metaphor" para dar a um agente acesso estruturado e auditável a uma hierarquia de dados de domínio (em vez de um endpoint de busca genérico ou RAG vetorial) é uma alternativa deliberada e mais previsível para agentes que precisam navegar dados estruturados com profundidade variável.
- O vocabulário de filtro fechado no `cat` é uma decisão explícita de engenharia de contexto: restringir o que pode ser pedido evita que o agente desperdiçe tokens projetando campos irrelevantes.
- O fato de a v1 ser estritamente read-only, mas já ter os schemas desenhados como "contratos de escrita futuros", reflete uma estratégia de rollout deliberadamente conservadora para agentes em produção que tocam dados de autores reais.

## Exemplos e evidências
- Todos os 1989 testes passam, typecheck limpo, conforme o relatório de revisão automatizada.
- O fix de debounce foi commitado especificamente (`a7d585c`), mantendo o estado em memória (`threads`) atualizado imediatamente para consistência de UI, mas isolando a escrita cara em localStorage com debounce de 500ms — só o `onFinish` (uma vez por resposta) ainda escreve imediatamente.
- Duas novas suites de teste de integração cobrem o fix de path duplicado intra-batch.

## Implicações para o vault
- Esse PR é o exemplo de produção mais concreto que o vault tem do conceito `virtual-filesystem-llm` e `agent-vfs-pattern` já catalogados — vale linkar como evidência prática (caso real em codebase de produção, não apenas teoria) desses conceitos.
- Reforça a importância de testes de regressão e revisão automatizada (`github-actions[bot]` agindo como reviewer de PR) como camada de verificação antes de agentes read/write tocarem produção — conecta-se a `generator-verifier-loop` aplicado ao próprio processo de desenvolvimento de agentes, não só às respostas deles.

## Links
- [[03-RESOURCES/concepts/pkm-obsidian/virtual-filesystem-llm]]
- [[03-RESOURCES/concepts/agent-systems/agent-vfs-pattern]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/entities/Matt-Pocock]]
