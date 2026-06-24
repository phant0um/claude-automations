---
title: "LLMs 101: A Practical Guide (2026 Edition)"
type: source
source: "Clippings/LLMs 101 A Practical Guide (2026 Edition).md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central

Rodar LLMs localmente em 2026 deixou de ser nicho técnico — é viável para privacidade, custo e controle, mas exige tratar o stack como engenharia real: escolha de modelo, quantização, hardware, formatação, RAG e guardrails de agente são decisões de sistema, não detalhes de configuração. "Local não torna um agente sábio. Só torna o contexto privado, o loop mais barato e a integração mais fácil de controlar."

## Argumentos principais

- **Modelo ≠ commodity escolhida só por benchmark.** Avaliação correta mede qualidade, latência, memória, confiabilidade e fit operacional — não só pontuação de leaderboard em BF16 (sua realidade local rodando Q4 é outra).
- **Quantização é trade-off explícito**, não grátis: menor precisão (Q4/Q8 etc.) reduz VRAM e aumenta velocidade, mas pode degradar qualidade — precisa medir no seu próprio eval set, não confiar em number genérico.
- **Coding é o melhor caso de uso local**: prompts contêm código privado, latência importa, iteração é frequente, custo de API soma rápido. Mas o setup forte não é "chatbot nu" — é modelo instruct code-capable conectado a contexto de repositório, retrieval, test runners e loop de patch.
- **Agentes locais mudam o modelo de segurança.** Tool use (filesystem, shell, browser, DB) transforma hallucination de "irritante" em "perigoso". Quatro camadas de defesa: escopo apertado, execução contida (sandbox/least-privilege), tratar inputs como hostis (prompt injection via documentos/emails), trilha de auditoria.
- **Structured outputs (JSON schema, constrained decoding) não são security boundary.** Facilitam validar a chamada, não provam que o modelo entendeu a intenção ou evitou injection. Policy checks devem ficar fora do modelo.
- **RAG vence prompt gigante**, mas cada estágio (parsing, chunking, embeddings, retrieval, reranking) é ponto de falha. A maioria dos sistemas RAG ruins falha por chunking/retrieval/reranking, não pelo LLM em si. Chunking é "o assassino silencioso": fixed-size sem overlap corta sentenças e perde contexto.
- **Avaliação exige eval set próprio**: 30–100 prompts representativos, com respostas esperadas, métricas de latência/memória, categorias de falha, checks de grounding e revisão humana para casos ambíguos.

## Key insights

- Benchmark de leaderboard mede o modelo em condições que você não vai rodar (BF16 full precision) — decisão de stack real precisa do seu próprio harness de avaliação.
- KV-cache, memória e VRAM headroom sob carga são dimensões de "qualidade" tão centrais quanto correção da resposta.
- Um bom reranker pode salvar retrieval mediano; nenhum reranker recupera informação perdida no chunking.
- Tool use é a linha que separa "chatbot que erra" de "agente que causa dano real" — segurança tem que ser estrutural (sandbox, least privilege), não comportamental (confiar no modelo).

## Exemplos e evidências

- Workflow de coding local recomendado: modelo instruct + retrieval sobre codebase + paths/snippets relevantes + execução de testes + patch loop, com decodificação determinística/baixa temperatura.
- Pipeline RAG completo descrito: ingestão → parsing → chunking → embeddings → índice vetorial → retrieval → reranking → construção de prompt → geração → checagem de grounding → avaliação — cada etapa citada como ponto de falha isolado.
- Quatro camadas de guardrail para agentes locais com tool use: escopo, execução contida, input hostil, audit trail — aplicável a qualquer agente autônomo, não só LLM local.

## Implicações para o vault

Mapeia diretamente para múltiplos conceitos já existentes em `llm-ml-foundations/`: `kv-cache-llms.md`, `inference-optimization.md`, `inference-engines-hardware-first.md`, `context-engineering.md`, `tokenization.md`. Não cria conceito novo — funciona como fonte transversal que reforça/cita esses conceitos com framing prático de deployment local. Relevante também para `agent-systems/` no ponto de guardrails de agentes com tool use (linha de defesa estrutural antes de qualquer ação autônoma).

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-engines-hardware-first]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]

## Minha Síntese

**O que muda:** Tratar avaliação de modelo local como harness próprio (eval set de 30-100 prompts) em vez de confiar em leaderboard — aplica-se também a qualquer escolha de modelo Ollama no vault.

**Conexão pessoal:** Reforça o ADR-003 (model routing) já em uso no vault — a lógica de "benchmark genérico não decide seu stack" é exatamente o motivo de triagem ser Claude-only e roteamento Ollama ser por agente.

**Próximo passo:** Nenhum próximo passo imediato.
