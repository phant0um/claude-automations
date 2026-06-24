---
title: OpenJarvis
type: entity
category: framework
tags: [ai-agents, local-ai, ollama, open-source, stanford, personal-ai]
created: 2026-05-29
updated: 2026-05-29
---

# OpenJarvis

Framework open-source para construir agentes de IA pessoais que rodam em hardware local. Desenvolvido pelos labs [Hazy Research](https://hazyresearch.stanford.edu/) e [Scaling Intelligence](https://scalingintelligence.stanford.edu/) da Stanford, como parte da agenda de pesquisa "Intelligence Per Watt".

- GitHub: [open-jarvis/OpenJarvis](https://github.com/open-jarvis/OpenJarvis)
- Docs: [open-jarvis.github.io/OpenJarvis](https://open-jarvis.github.io/OpenJarvis/)
- v1.0 lançado: 2026-05-27

## Filosofia

Local-first como padrão. Cloud é opcional, não obrigatório. Energia, custo e latência são métricas rastreadas junto com acurácia — conceito "Intelligence Per Watt".

## Arquitetura

- Backend de inferência: [[03-RESOURCES/entities/Ollama]] (padrão) + cloud opcional
- Configuração central: `~/.openjarvis/config.toml`
- Memória local: `jarvis memory index <path>` (RAG sobre documentos locais)
- Presets: bundles agente + engines + ferramentas, instaláveis com um comando

## Presets built-in

| Preset | Função |
|--------|--------|
| `morning-digest-mac` | Briefing diário: calendário + email + notícias |
| `deep-research` | RAG web + documentos locais com citações |
| `code-assistant` | Agente de código Python que executa localmente |

## Instalação rápida

```shell
curl -fsSL https://open-jarvis.github.io/OpenJarvis/install.sh | bash
jarvis
```

## Conexoes

- [[03-RESOURCES/entities/Ollama]] — runtime de inferência local
- [[03-RESOURCES/concepts/llm-ml-foundations/local-ai]] — conceito central
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — padrão memory index
- [[03-RESOURCES/sources/ai-agents-harness/openjarvis-local-first-ai-ollama]]
