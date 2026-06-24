---
title: "Claude Code + Obsidian 搭建本地 AI 知识库，保姆级教程！"
type: source
source: "Clippings/Claude Code + Obsidian 搭建本地 AI 知识库，保姆级教程！.md"
created: 2026-06-19
ingested: 2026-06-21
tags: [ai-agents, pkm-templates]
---

## Tese central
Tutorial passo-a-passo (em chinês, voltado a leigos) para montar um knowledge base pessoal combinando Obsidian (armazenamento local em Markdown) + Claude Code (curadoria/organização) — propõe estrutura de pastas fixa (Inbox → Raw → Notes → Wiki → Output → Archive) e um CLAUDE.md com regras de manutenção.

## Argumentos principais
- Divisão de responsabilidade clara: Obsidian armazena (local, portável, Markdown puro), Claude Code organiza (resume, indexa, detecta duplicidade, gera outline de estudo), Markdown garante durabilidade (sem lock-in de ferramenta).
- Estrutura de 6 pastas com função única cada: `00_Inbox` (captura bruta sem exigência de organização) → `01_Raw` (material não processado) → `02_Notes` → `03_Wiki` → `04_Output` → `99_Archive`.
- Tarefa de manutenção semanal sugerida ao Claude: escanear Inbox, achar duplicados/temas similares, marcar conteúdo obsoleto, atualizar `00_HOME.md`, sintetizar conhecimento novo da semana, sugerir 10 pautas de output.
- Regra de segurança explícita: nunca deletar arquivos; mover/arquivar só com confirmação prévia do usuário — e dados sensíveis (contratos, dados de clientes, financeiro) não devem ir a ferramentas de IA em nuvem sem anonimização ou backup local antes.
- Versão "mínima viável" para principiante: instalar Obsidian, criar 4 pastas, escrever CLAUDE.md, colocar 10 itens no Inbox, pedir plano antes de qualquer alteração, gerar páginas de wiki só após confirmação.

## Key insights
- O padrão "captura sem fricção → processamento assistido por IA → consolidação em wiki" é estruturalmente idêntico ao próprio pipeline deste vault (Captura → Ingestão → Consolidação → Interconexão), confirmando que a arquitetura adotada aqui não é idiossincrática — é um padrão emergente reconhecido fora do ecossistema Anthropic/Obsidian oficial.
- A ênfase em "sempre pedir plano antes de mover/arquivar" é o mesmo princípio do Karpathy Principle #1 (think before acting) já adotado neste CLAUDE.md.

## Exemplos e evidências
- Estrutura de pastas e prompt de manutenção semanal completo, em chinês, replicável literalmente.

## Implicações para o vault
Validação externa independente da arquitetura de pipeline já em uso (`04-SYSTEM/agents/nexus-agent-system/`) — não introduz técnica nova, mas confirma que a separação Inbox/Raw/Wiki/Archive e a regra "não deletar, só mover com confirmação" são práticas convergentes na comunidade de PKM+IA.

## Links
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
- [[04-SYSTEM/agents/nexus-agent-system/ingest-agent]]
