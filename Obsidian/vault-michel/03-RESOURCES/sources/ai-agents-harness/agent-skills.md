---
title: "Agent Skills — Anthropic Official Docs"
type: source
source: "Clippings/Agent Skills.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Agent Skills são capacidades modulares e reutilizáveis baseadas em sistema de arquivos que estendem Claude com expertise de domínio, sem consumir contexto constantemente. O mecanismo de "progressive disclosure" carrega informação em estágios conforme necessário, permitindo instalar muitas Skills sem penalidade de contexto.

## Argumentos principais

- Skills são superiores a prompts de conversa para tarefas recorrentes: criadas uma vez, usadas automaticamente, compostas em workflows complexos
- Arquitetura de três níveis: (1) metadata YAML ~100 tokens sempre no contexto, (2) SKILL.md carregado quando triggered (<5K tokens), (3) recursos adicionais carregados on-demand via bash — custo de contexto efetivamente ilimitado para conteúdo não acessado
- Claude roda em VM com acesso ao filesystem: Skills existem como diretórios, Claude as navega como um onboarding guide
- Scripts executados via bash nunca entram no contexto — apenas o output consome tokens
- Skills de fontes não confiáveis são risco de segurança real: podem executar código arbitrário, exfiltrar dados

## Key insights

- A distinção entre Skills (como fazer algo), Plugins (acesso a ferramentas) e Dynamic Workflows (coordenar workforce inteira) — Skills são o layer de expertise especializada
- Disponibilidade diferenciada: claude.ai (individual, não compartilhável org-wide), API Claude (workspace-wide), Claude Code (filesystem-based, pessoal ou projeto)
- Claude Code: Skills são filesystem-based, sem upload via API; descoberta automática
- Sem sincronização cross-surface: skill no claude.ai não está disponível na API e vice-versa
- Campos obrigatórios SKILL.md: `name` (max 64 chars, kebab-case, sem "anthropic"/"claude") e `description` (max 1024 chars, incluir QUANDO usar)

## Exemplos e evidências

- Pre-built Skills oficiais: PowerPoint, Excel, Word, PDF
- Open-source: Claude API Skill (referência atualizada da API, SDKs em 8 linguagens — bundled no Claude Code)
- API requer 3 beta headers: `code-execution-2025-08-25`, `skills-2025-10-02`, `files-api-2025-04-14`
- Restrição importante: API sem acesso a rede; Claude Code com acesso total à rede local

## Implicações para o vault

Documentação oficial que fundamenta o sistema de skills deste vault em `04-SYSTEM/skills/`. A arquitetura de três níveis (metadata → SKILL.md → recursos) é o padrão a seguir ao criar novas skills. A regra "scripts via bash não consomem contexto" tem implicação direta para design de skills pesadas.

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]]
- [[03-RESOURCES/concepts/agent-security]]
