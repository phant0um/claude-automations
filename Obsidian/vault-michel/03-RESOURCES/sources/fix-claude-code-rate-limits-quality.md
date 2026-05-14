---
title: "How To Fix Claude Code's Rate Limits + Quality Issues"
type: source
source_file: ".raw/articles/How To Fix Claude Code's Rate Limits + Quality Issues.md"
author: WorldofAI (@intheworldofai)
ingested: 2026-04-17
tags: [claude-code, rate-limits, opus-46, benchmark, ollama, openrouter, tokens, qualidade]
---

# How To Fix Claude Code's Rate Limits + Quality Issues

**Autor:** WorldofAI — [@intheworldofai](https://x.com/intheworldofai)

Artigo técnico sobre degradação de performance do Opus 4.6 e estratégias práticas para contornar o problema. Contexto: BridgeBench detectou queda de 83.3% → 68.3% de acurácia do Opus 4.6 entre 8 e 12 de abril de 2026.

> [!warning] Dados de benchmark (BridgeBench, 12/04/2026)
> - Grok 4.20 Reasoning: 91.8% (topo)
> - Claude Opus 4.6 (nova versão): 68.3% — caiu de #2 para #10
> - Claude Sonnet 4.6 e Gemini 3 Pro passaram a superar Opus 4.6 em alguns casos

## O "Claude Code Tax" invisível

Testes com HTTP proxy em 4 versões do Claude Code revelaram:

| Versão | Tokens faturados |
|---|---|
| v2.1.98 | 49.726 tokens |
| v2.1.100+ | **69.922 tokens** (+20.196 "invisíveis") |

- Os ~20.000 tokens extras são 100% server-side
- Não aparecem em `/context`, mas consomem a janela real
- Resultado: instruções do CLAUDE.md ficam diluídas; qualidade cai mais rápido em sessões longas; limits são atingidos ~40% mais cedo

## Fixes práticos

### 1. Downgrade do Claude Code (maior impacto imediato)

```bash
npx claude-code@2.1.98
```

Pinnar no shell profile para evitar auto-update. Remove o bloat de 20K tokens; muitos usuários relatam que "o modelo voltou a parecer Opus".

### 2. Rodar localmente via Ollama + Gemma 4

Para hardware adequado — elimina restrições cloud completamente.

```bash
# Instalar Ollama: ollama.com
ollama pull gemma4

export ANTHROPIC_BASE_URL=http://localhost:11434
export ANTHROPIC_AUTH_TOKEN=ollama
claude --model gemma4
```

Verificar hardware antes: **whatmodelscanirun.com** — selecionar GPU/VRAM, mostra o maior modelo que roda confortavelmente.

### 3. OpenRouter como fallback

Para quem não tem hardware forte:

```bash
export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
export ANTHROPIC_AUTH_TOKEN="seu-openrouter-key"
export ANTHROPIC_API_KEY=""   # deve estar vazio
```

Modelos open-source gratuitos com failover e compatibilidade total com Claude Code.

### 4. Dicas de estabilidade extra

- Evitar `/fast` mode em versões novas (quirks de roteamento interno)
- Manter CLAUDE.md curto e de alto sinal
- Usar memória persistente / LLM Wiki patterns para context entre sessões (reduz dependência da sessão atual)

## Hipótese da "distilação intencional"

> [!contradiction] Hipótese vs fato
> Hipótese circulante: Anthropic estaria degradando Opus 4.6 intencionalmente para criar hype para Opus 4.7 / "Mythos" (rumor Q3 2026). Autor ressalva: "These observations are based solely on public BridgeBench data. I'm not claiming Anthropic is deliberately downgrading the model."

Independente da causa, o artigo argumento que **em 2026, o cloud model não é a única opção** — downgrade de cliente, local com Gemma 4, ou OpenRouter devolvem a experiência original.

## Conexões no vault

- [[03-RESOURCES/entities/Claude-Opus-47]] — o modelo que substituiu o Opus 4.6 problemático
- [[03-RESOURCES/entities/Claude Code]] — objeto de análise técnica deste artigo
- [[03-RESOURCES/entities/WorldofAI]] — autor
- [[03-RESOURCES/concepts/claude-agent-harness-architecture]] — context window e tokens invisíveis são parte da camada de infraestrutura
- [[03-RESOURCES/concepts/context-rot]] — conceito relacionado: degradação por contexto cheio
