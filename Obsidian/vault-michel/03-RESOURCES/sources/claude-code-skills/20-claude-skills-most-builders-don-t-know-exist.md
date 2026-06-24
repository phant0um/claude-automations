---
title: "20 Claude Skills Most Builders Don't Know Exist"
type: source
source: Clippings/20 Claude Skills Most Builders Don't Know Exist.md
source_type: clipping
created: 2026-05-19
ingested: 2026-05-19
triagem_score: 7
triagem_cat: claude-code
tags: [ai-agents, claude-code, clipping]
---

## Tese central

Taxonomia de 20 skills por categoria — job description vs. prompt. A distinção central: uma skill não é um prompt longo, é uma "job description" que define papel, contexto de ativação, protocolo de trabalho e critérios de qualidade.

## Key insights

- Seção: What a Skill Actually Is
- Seção: How to Install Any Skill in This List
- Seção: Category 1: Content & Writing

## O que é uma Skill (Definição Operacional)

Uma skill Claude Code é um arquivo de texto (`.md`) que, quando injetado no contexto de uma sessão, transforma o comportamento do agente para um domínio específico. A metáfora é uma "job description":

- **Prompt comum**: "Escreva um blog post sobre X"
- **Skill**: "Você é um editor de conteúdo técnico com 10 anos de experiência. Quando receber pedidos de escrita, siga este processo: [pesquisa → outline → draft → revisão SEO → checklist de qualidade]"

A diferença é o **protocolo implícito** que a skill carrega — o agente não apenas executa uma instrução, ele adota um modo de trabalho.

## As 20 Skills por Categoria

### Category 1: Content & Writing (4 skills)

**1. technical-blogger**
Transforma Claude em editor técnico que segue um processo de publicação: pesquisa de keywords, estrutura SEO, exemplos de código testados, meta-description. Ativação: "escreva um post sobre X".

**2. newsletter-writer**
Especializada em newsletters com alto engajamento — sujeito que provoca curiosidade, corpo com 3 insights práticos, CTA claro. Inclui checklist de qualidade antes de enviar.

**3. thread-composer**
Cria threads para X/Twitter com estrutura provada: hook no tweet 1, desenvolvimento com exemplos, tweet de conclusão com CTA. Formata automaticamente com numeração e quebras de linha otimizadas.

**4. doc-writer**
Gera documentação técnica (README, API docs, tutoriais) seguindo o padrão Diátaxis (tutoriais vs how-tos vs reference vs explanation).

### Category 2: Code Quality (5 skills)

**5. security-reviewer**
Revisão focada exclusivamente em vulnerabilidades de segurança — não style, não performance. Segue o OWASP Top 10 e CWE list. Output: lista de issues com severidade, exploitability e fix sugerido.

**6. test-writer**
Gera testes unitários e de integração que cobrem happy path, edge cases e casos de falha. Detecta o framework de teste usado (Jest, Pytest, JUnit) e segue convenções existentes.

**7. refactor-advisor**
Não refatora — avalia e recomenda. Identifica code smells, propõe abordagem, estima impacto. A execução fica com o desenvolvedor ou com outra skill.

**8. code-reviewer**
Revisão completa de PR: correctness, maintainability, testability, security. Separa findings em: bloqueantes, sugestões e observações opcionais.

**9. performance-profiler**
Identifica gargalos de performance sem executar código — análise estática de padrões conhecidos (N+1 queries, loops desnecessários, re-renders em React, etc).

### Category 3: Architecture & Design (4 skills)

**10. system-designer**
Conduz um processo de design de sistema: requisitos → componentes → interfaces → trade-offs → ADR draft. Baseado no padrão "Design It Twice" de John Ousterhout.

**11. api-designer**
Especializada em design de APIs REST e GraphQL — naming conventions, versionamento, error handling, paginação, idempotência. Output: spec OpenAPI + ADR.

**12. database-modeler**
Design de schema relacional e de documentos — normalização, índices, estratégias de sharding, trade-offs NoSQL vs SQL para o caso de uso específico.

**13. dependency-analyzer**
Mapeia dependências entre módulos e identifica violações de arquitetura (coupling indesejado, ciclos de dependência).

### Category 4: Research & Analysis (4 skills)

**14. paper-summarizer**
Lê papers científicos e extrai: tese central, metodologia, resultados chave, limitações, implicações práticas. Formato padronizado para facilitar comparação entre papers.

**15. competitive-analyst**
Analisa produtos, repositórios ou artigos competidores — identifica diferenciais, gaps, posicionamento. Útil para product managers e fundadores.

**16. data-interpreter**
Recebe dados brutos (CSV, JSON, tabelas) e produz insights narrativos — não visualizações, mas explicações em linguagem natural do que os dados mostram.

**17. trend-watcher**
Monitora um domínio ao longo do tempo — dado um conjunto de fontes, identifica padrões emergentes, tecnologias em ascensão e conceitos em declínio.

### Category 5: Productivity & Workflow (3 skills)

**18. meeting-facilitator**
Prepara agendas, facilita discussões via perguntas estruturadas, produz ata com decisões e action items.

**19. project-planner**
Decompõe projetos em milestones, tasks e dependências. Output: arquivo de projeto estruturado com estimativas e riscos identificados.

**20. knowledge-curator**
Ingere fontes (artigos, papers, clippings) e organiza em um sistema de notas interconectado. Esta é a skill mais próxima do workflow do vault-michel.

## Como Instalar Qualquer Skill desta Lista

```bash
# Opção 1: via skill hub
claude /install-skill <nome-da-skill>

# Opção 2: manual
# 1. Criar arquivo ~/.claude/skills/<nome>.md com o conteúdo da skill
# 2. Adicionar ao CLAUDE.md do projeto:
echo "@~/.claude/skills/<nome>.md" >> .claude/CLAUDE.md

# Verificar que está ativa:
claude "quais skills estão ativas nessa sessão?"
```

## Por que "Builders Don't Know"

O título reflete um problema real: a maioria dos usuários Claude Code usa o modelo como "prompt avançado" — não como agente configurável. Skills são o mecanismo que transforma o uso reativo (perguntar e receber) em uso proativo (agente com protocolo de trabalho).

A falta de descoberta tem causas:
1. Não há store oficial de skills — circulam via GitHub, X e newsletters
2. A documentação oficial não enfatiza skills — foca em features do CLI
3. O benefício só fica claro após usar — difícil demonstrar em screenshot

## Limitações

- Skills mal especificadas ativam aleatoriamente — triggers vagos causam ruído
- Muitas skills sobrepostas criam conflito — o agente não sabe qual protocolo seguir
- Skills sem atualização ficam desalinhadas com versões novas do Claude

## Relevância para o Vault

O vault-michel já implementa várias dessas skills em `04-SYSTEM/skills/`:
- `wiki-ingest` ≈ knowledge-curator
- `relatorio-artigos` ≈ paper-summarizer
- `handoff` ≈ meeting-facilitator (para sessões)
- `grill-me` ≈ system-designer (fase de requirements)

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]]
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]]
- [[03-RESOURCES/sources/claude-code-skills/top-13-skills-et-plugins-claude-code-en-2026]]

## Fonte

Arquivo original: `Clippings/20 Claude Skills Most Builders Don't Know Exist.md`
