---
title: "OpenJarvis: a local-first personal AI is now available to run with Ollama"
type: source
category: ai-agents
grade: B
created: 2026-05-29
ingested: 2026-05-29
source_url: https://ollama.com/blog/openjarvis
tags: [ai-agents, local-ai, ollama, open-source, stanford]
---

# OpenJarvis: a local-first personal AI is now available to run with Ollama

## Tese central

OpenJarvis v1.0 é um framework open-source para construir agentes pessoais que rodam inteiramente em hardware local, com suporte nativo ao [[03-RESOURCES/entities/Ollama]]. Desenvolvido pelos labs Stanford Hazy Research e Scaling Intelligence como parte da agenda "Intelligence Per Watt" — eficiência energética como métrica de primeira classe ao lado de acurácia.

## Argumentos principais

- Modelos locais já lidam com a maioria das tarefas cotidianas de chat e raciocínio; ainda assim, a maioria dos agentes pessoais envia tudo para a nuvem
- OpenJarvis torna local-first o padrão: cloud é opcional, não obrigatório
- Energia, custo e latência são rastreados junto com acurácia (não apenas performance)
- Inclui presets prontos para uso (morning briefing, deep research, code assistant) que combinam agente + engines + ferramentas necessárias

## Key insights

1. **"Intelligence Per Watt" como métrica** — Stanford enquadra eficiência energética como critério de avaliação, não apenas tokens/s ou benchmark score. Isso muda o que "melhor modelo" significa para uso pessoal.
2. **Preset bundling** — cada preset é um agente com suas dependências já empacotadas; reduz fricção de setup drásticamente vs. configurar stack do zero.
3. **Arquitetura híbrida implícita** — cloud é opcional mas suportado; o framework não força purismo local, apenas inverte o default.
4. **Memory indexing local** — `jarvis memory index ./docs/` indexa documentos locais para RAG sem enviar dados para fora; composição direta com pesquisa web.

## Exemplos e evidências

### Setup completo

```shell
# 1. Instalar Ollama
# Download em ollama.com/download

# 2. Instalar OpenJarvis
curl -fsSL https://open-jarvis.github.io/OpenJarvis/install.sh | bash

# 3. Iniciar
jarvis
```

### Escolha de modelo

```shell
jarvis model pull qwen3.5:35b
jarvis ask -m qwen3.5:35b "Seu prompt aqui"
```

Configuração permanente em `~/.openjarvis/config.toml`:

```toml
[intelligence]
default_model = "qwen3.5:35b"
preferred_engine = "ollama"
```

### Presets built-in

```shell
# Morning briefing (calendário + email + notícias)
jarvis init --preset morning-digest-mac
jarvis connect gdrive
jarvis digest --fresh

# Research + RAG local
jarvis init --preset deep-research
jarvis memory index ./docs/
jarvis ask "Summarize all emails about Project X"

# Coding agent
jarvis init --preset code-assistant
```

## Implicações para o vault

- Candidato direto para integrar ao sistema de agentes local do vault: presets de `morning-digest` e `deep-research` se alinham com fluxos existentes
- O conceito "Intelligence Per Watt" expande [[03-RESOURCES/concepts/llm-ml-foundations/local-ai]] com uma métrica nova: custo energético como critério de escolha de modelo
- `jarvis memory index` + pesquisa web = padrão RAG híbrido relevante para [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- Stanford Hazy Research / Scaling Intelligence = novos atores acadêmicos no espaço de agentes open-source; contrapeso ao ecossistema Anthropic/OpenAI

## Links

- [GitHub — open-jarvis/OpenJarvis](https://github.com/open-jarvis/OpenJarvis)
- [Documentação oficial](https://open-jarvis.github.io/OpenJarvis/)
- [Release notes v1.0.0](https://github.com/open-jarvis/OpenJarvis/releases/tag/v1.0.0)
- [[03-RESOURCES/entities/OpenJarvis]]
- [[03-RESOURCES/entities/Ollama]]
- [[03-RESOURCES/concepts/llm-ml-foundations/local-ai]]
