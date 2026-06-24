---
title: Fireworks AI
type: entity
category: ai-infrastructure
created: 2026-05-28
updated: 2026-05-28
tags: [entity, fine-tuning, inference, llm-training, ai-infrastructure]
---

# Fireworks AI

Plataforma de inferência e fine-tuning de LLMs focada em velocidade e custo. Posicionada entre as big clouds (AWS/Azure) e o hardware bruto — API simples, modelos open-source, fine-tuning como serviço.

## Produto principal

**Fireworks Agent** — pipeline orquestrado de fine-tuning end-to-end:

```
firectl session create -n "<instruction>"
```

Fluxo completo executado pelo agente:
1. Dataset inspection
2. Hyperparameter sweep
3. Full training
4. Deployment
5. Working inference endpoint

**Decision gates:** agente superficia decisões-chave (plano proposto, HP sweep results) para aprovação humana antes de continuar. Resto é autônomo.

## Por que importa

Karpathy descreveu "personal LLM Wiki" como o próximo passo após o context window: ao invés de injetar notas em cada prompt, fazer SFT para **bake** os padrões diretamente nos pesos do modelo.

Fireworks Agent torna esse loop praticável:
- 50–100 exemplos limpos → SFT fixa formato nos weights
- System prompt vira uma frase (em vez de 500 tokens de instrução)
- Mesmo agente que usa o modelo pode acionar fine-tuning quando detecta padrões recorrentes → **self-improving loop**

## Integração com Claude Code

Slash command `pilot-agent.md` disponível — wraps `firectl` commands com:
- Event streaming em tempo real
- Detecção de gates (quando agente precisa de aprovação humana)
- Resume-from-last-timestamp se sessão interrompida

## Posicionamento no mercado

| Característica | Fireworks AI | OpenAI Fine-tuning | Hugging Face |
|----------------|-------------|-------------------|-------------|
| Foco | Velocidade + custo | Ecossistema GPT | Open-source |
| Fine-tuning agentico | ✅ Fireworks Agent | Manual | Manual |
| Modelos suportados | Open-source (Llama, Mixtral, etc.) | GPT-4o-mini | Qualquer |
| Self-improving loop | ✅ via CLI | ❌ | ❌ |

## Conceito relacionado: Output Style como target SFT

Para personal wikis e agentes com estilo definido, o alvo de maior ROI de SFT **não é** acurácia de conteúdo — é consistência de formato. Base models "reverte" mesmo com system prompt extenso:
- Muda headers
- Varia bullet count
- Adiciona "marketing language"

SFT resolve isso no nível de parâmetros. Resultado: output consistente com system prompt mínimo.

## Relacionado

- [[03-RESOURCES/concepts/llm-ml-foundations/rl-training-llms|RL Training LLMs]] — contexto de treinamento
- [[03-RESOURCES/concepts/agent-systems/agentic-rl|Agentic RL]] — loop de auto-melhoria
- [[03-RESOURCES/sources/ai-agents-harness/clipping-llm-finetuning-fireworks-agent|Source — Automating LLM Fine-Tuning with Fireworks Agent]]
