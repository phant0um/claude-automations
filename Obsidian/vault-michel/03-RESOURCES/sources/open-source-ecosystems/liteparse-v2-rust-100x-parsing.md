---
title: "Up to 100x Fast Parsing with LiteParse v2.0 and Rust"
type: source
source: "Clippings/Up to 100x Fast Parsing with LiteParse v2.0 and Rust.md"
original_url: "https://www.llamaindex.ai/blog/liteparse-v2-0-runs-everywhere"
author: "Logan Markewich"
published: 2026-05-29
created: 2026-05-29
ingested: 2026-05-29
tags: [articles, liteparse, rust, pdf-parsing, llamaindex, wasm, performance, document-processing]
---

## Tese central

LiteParse v2.0 reescreveu completamente o parser de PDFs e documentos em Rust, alcançando speedup de 5–100× para documentos pequenos e ~3× para documentos grandes, e tornando a ferramenta verdadeiramente portável: Rust nativo, Node/JS, Python, WASM (browser + edge runtimes). A mudança de TypeScript para Rust eliminou a dependência de instalação Node e abriu targets impossíveis anteriormente.

## Argumentos principais

- **Problema da v1:** runtime dominado pelo overhead de inicialização de processo Node. Documentos pequenos sofriam desproporcionalmente. Distribuição limitada a ambientes com Node instalado.
- **Por que Rust e não compilar TypeScript para binário:** dependências de sistema complexas tornaram a compilação TS→binário inviável. Rust resolveu isso com um único codebase compilável para múltiplos targets.
- **Propagação automática de mudanças:** alterações no core Rust se propagam automaticamente para todos os language bindings (Node, Python, WASM). Um único codebase, múltiplos destinos.
- **Stack técnica da performance:** fork customizado do PDFium + build do `tesseract-rs` como OCR padrão. Resultado: 0.777s para documento de 457 páginas / 100MB.
- **WASM para browser e edge:** o target WASM (`@llamaindex/liteparse-wasm`) roda no browser e em edge runtimes. Para WASM, OCR é fornecido via callback (ex: `tesseract-js`) em vez de built-in — necessário para remover dependências de sistema incompatíveis com WASM sandbox.
- **Skill para coding agents:** disponível como skill para Claude Code, Codex, OpenCode via `npx skills add run-llama/llamaparse-agent-skills --skill liteparse`.
- **PDFium fork customizado:** não é o PDFium padrão — é um fork compilado especificamente para extrair todo o desempenho possível.

## Key insights

- **"Small docs see a 5–100x speedup"** — o range enorme (5–100×) reflete que o overhead anterior era quase inteiramente o tempo de spin-up do Node process, não o parsing em si. Para 1-2 página docs, o speedup é dramático.
- **"For larger docs, we observed around a 3x speedup"** — para documentos grandes, o trabalho de parsing domina e o ganho de Rust vs. Node é mais modesto mas ainda significativo.
- **LLM-free approach preservado:** LiteParse extrai texto estruturado de PDFs e documentos office sem LLMs. O texto é projetado de acordo com o layout do documento. A reescrita em Rust não mudou essa filosofia — apenas a infraestrutura.
- **Simon Willison como early community contributor:** community efforts de Simon Willison mostraram que era possível rodar LiteParse no browser antes do WASM oficial — o time tomou esse trabalho como base para o suporte oficial.
- **Real-time agents use case:** "If you are running real-time agents and applications that need to read docs fast, LiteParse is the tool for it." — posicionamento explícito para agentic workloads.
- **Packages disponíveis hoje:**
  - `npm i @llamaindex/liteparse` — Node + CLI
  - `pip install liteparse` — Python + CLI
  - `cargo install liteparse` — Rust + CLI
  - `npm i @llamaindex/liteparse-wasm` — WASM (browser + edge)
- **Demo ao vivo no browser:** https://run-llama.github.io/liteparse/ — parsing rodando localmente no browser via WASM.

## Exemplos e evidências

- **Benchmark concreto:** 0.777s para documento de 457 páginas / 100MB.
- **Speedup range:** 5–100× para documentos pequenos (overhead era o Node process). ~3× para documentos grandes.
- **Simon Willison:** demonstrou browser support antes do WASM oficial (publicado em abril 2026).
- **Comparação com outros PDF parsers:** "blazing fast on most documents" — sem números relativos específicos publicados no artigo além do benchmark absoluto de 0.777s/457p.

## Implicações para o vault

- **Rust como escolha arquitetural validada:** este caso confirma o padrão documentado em `[[03-RESOURCES/concepts/dev-foundations/rust-systems]]` — Rust como camada de sistemas para performance determinística e portabilidade. LiteParse é mais um exemplo concreto, específico para document processing.
- **LlamaIndex como produtor de ferramentas para agentes:** LiteParse não é apenas um utilitário — é posicionado explicitamente para "real-time agents". Fortalece o padrão de tooling especializado para agentic workloads.
- **WASM como target de portabilidade máxima:** o padrão Rust → WASM → browser/edge é relevante para qualquer ferramenta que precise de portabilidade máxima sem instalar runtime. Pode ser documentado como conceito separado.
- **Skill para Claude Code:** o fato de LiteParse ser disponível como skill (`npx skills add`) é relevante para o vault — potencial adição ao arsenal de skills do vault-michel.
- **Open-source ecosystem:** projeto em https://github.com/run-llama/liteparse — monitorável para updates.

## Links

- [[03-RESOURCES/concepts/dev-foundations/rust-systems]]
- [[03-RESOURCES/entities/LlamaIndex]]
- [[03-RESOURCES/entities/LiteParse]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
