---
title: "AI PM OS — now in Claude Cowork too!"
type: source
source: "Clippings/AI PM OS — now in Claude Cowork too!.md"
original_url: "https://x.com/nurijanian/status/2060677632648441912"
author: "@nurijanian"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, claude-cowork, product-management, skills, plugins]
---

## Tese central

AI PM OS 2.1 foi lançado como plugin oficial do Claude Cowork, trazendo um sistema operacional completo para Product Management com 13 skills de sistema, 10 workflows sequenciados, 214 skills reutilizáveis, 10 subagentes e MCPs pré-configurados (Lenny's Transcripts). A versão 2.1 também introduz importação de memória de outras ferramentas de IA (ChatGPT, Claude, Gemini) para onboarding em menos de 5 minutos.

## Argumentos principais

- **Plugin Cowork oficial**: AI PM OS 2.1 passa a ser instalável diretamente no Claude Cowork, não apenas como configuração manual de skills.
- **13 system skills**: incluem `/pm-os:pm-os-start` (setup do Context), `/pm-os:pm-help` (tour do sistema), `/pm-os:pm-os-tidy` (sincronização do Work).
- **10 PM workflows sequenciados**: `/pm-os:strategy`, `/pm-os:research`, `/pm-os:decisions`, `/pm-os:stakeholder`, `/pm-os:meeting` e mais 5.
- **214 skills reutilizáveis**: Claude puxa automaticamente quando relevante. Inclui skills como `find-the-strategic-crux`, `mckinsey-issue-tree`, `verbalized-sampling`.
- **10 subagentes** para review e gerenciamento de contexto.
- **MCPs pré-configurados**: Lenny's Transcripts incluso, mais a caminho.
- **Import de memória**: onboarding acelerado extraindo memórias relevantes de ChatGPT, Claude ou Gemini — setup em menos de 5 minutos.

## Key insights

- A escala de 214 skills reutilizáveis demonstra o poder do modelo just-in-time de carregamento de skills (carregam apenas quando relevantes, sem custo de contexto permanente).
- O import de memória de outras ferramentas é uma feature de onboarding que resolve o cold start problem de sistemas de PM baseados em IA.
- A existência de subagentes dedicados para review e context management sugere que o sistema gerencia ativamente degradação de contexto.
- MCPs pré-configurados (Lenny's Transcripts) indicam integração com knowledge bases específicas de PM.
- O sistema segue a arquitetura de Skills com hierarquia: system skills (framework) + domain skills (214) + workflows (sequências de skills).

## Exemplos e evidências

- 13 system skills documentadas (nomes listados)
- 10 workflows PM documentados (5 nomes explícitos + 5 não especificados)
- 214 skills reutilizáveis com exemplos: find-the-strategic-crux, mckinsey-issue-tree, verbalized-sampling
- 10 subagentes para review e context management
- MCPs: Lenny's Transcripts confirmado, mais em desenvolvimento
- Onboarding: menos de 5 minutos com import de memória

## Implicações para o vault

- Demonstra escala do ecossistema de plugins do Claude Cowork — 214 skills em um único plugin é referência para o vault sobre o que é possível
- O padrão de import de memória entre ferramentas é relevante para o vault ao considerar migração ou integração de contextos
- A estrutura de 3 camadas (system skills / domain skills / workflows) é um padrão de arquitetura de skills a considerar no vault
- Referência para product management com IA — potencialmente útil para projetos do Michel no vault

## Links
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/sources/claude-code-cowork/introduction-to-claude-cowork]]
- [[03-RESOURCES/sources/claude-code-cowork/complete-guide-claude-plugins-cowork]]
