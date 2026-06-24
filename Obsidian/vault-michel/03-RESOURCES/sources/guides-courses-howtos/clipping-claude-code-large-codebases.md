---
title: "How Claude Code Works in Large Codebases — Best Practices"
type: source
source: "Clippings/How Claude Code works in large codebases Best practices and where to start.md"
author: "Anthropic Applied AI Team"
published: 2026-05-22
created: 2026-05-23
ingested: 2026-05-23
tags: [ai-agents, clippings, claude-code, enterprise, large-codebases]
---

## Tese central

Claude Code navega codebases grandes como um engenheiro de software — traversa o filesystem, lê arquivos, usa grep para encontrar o que precisa, segue referências. Não requer embedding pipeline ou índice centralizado. Adoção em escala tem padrões reconhecíveis de configuração, tooling e estrutura organizacional.

## Argumentos principais

- **Agentic search vs RAG**: RAG falha em codebases grandes porque embedding pipeline não acompanha commits ativos. Claude Code usa agentic search — cada instância trabalha com o codebase live, sem pipeline de indexação para manter.
- **Tradeoff**: agentic search funciona melhor quando Claude tem contexto inicial suficiente para saber onde começar. Configuração de CLAUDE.md e project docs é crítica.
- **Padrões de sucesso comuns**: configuração explícita de CLAUDE.md, tooling padronizado, estrutura organizacional que inclui engineering + infosec + governance desde o início.
- **Funciona bem em linguagens "inesperadas"**: C, C++, C#, Java, PHP — melhor do que a maioria dos times espera, especialmente com releases recentes.

## Key insights

### Navegação em codebases grandes
- **Monorepos com milhões de linhas**: Claude traversa localmente; sem upload de código a servidor.
- **Legacy systems**: código distribuído por pastas sem root compartilhado. Requer configuração de paths em CLAUDE.md.
- **Múltiplos microservices**: dezenas de repos separados. Cross-repo references requerem configuração explícita.

### Por que RAG falha em escala
- Embedding pipelines ficam desatualizados conforme engenheiros fazem commits. Claude pode referenciar função renomeada 2 semanas atrás, módulo deletado no último sprint.
- Sem indicação de que resultado está desatualizado.
- Claude Code evita esse failure mode — busca ativa no codebase live.

### Melhores práticas organizacionais
- **Cross-functional working group** early: engineering + information security + governance juntos para definir requirements e roadmap de rollout.
- **Configuração de contexto inicial**: CLAUDE.md bem escrito é o que permite ao Claude saber onde começar em codebases grandes.
- Organizações com "conventional setups" (Git, standard directory structures, engenheiros como contribuidores principais) têm adoção mais suave.

### Ambientes não-convencionais
- Game engines com large binary assets, unconventional version control, non-engineers contribuindo → requer configuração adicional.
- Anthropic Applied AI team trabalha diretamente com engineering teams para casos complexos.

## Exemplos e evidências

- Zoox (Amit Navindgi) forneceu feedback — uso em automotive/safety-critical engineering.
- Equipe Applied AI: Alon Krifcher, Charmaine Lee, Chris Concannon, Harsh Patel, Henrique Savelli, Jason Schwartz, Jonah Dueck, Kirby Kohlmorgen.
- "Claude Code at scale" — série nova da Anthropic sobre enterprise deployments.

## Implicações para o vault

- Confirma importância de CLAUDE.md bem configurado — [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] aplica aqui: vault é um "large codebase" para Claude
- Conecta com [[03-RESOURCES/sources/pkm-obsidian-second-brain/i-connected-claude-obsidian-vault-damidefi]] — mesmos princípios de context engineering
- Referência para melhorar CLAUDE.md do vault com base nas melhores práticas enterprise

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[03-RESOURCES/entities/Anthropic]]
