---
title: LiteParse
type: entity
category: product
tags: [pdf-parsing, document-processing, rust, wasm, llamaindex, open-source, agent-tooling]
created: 2026-05-29
updated: 2026-05-29
---

# LiteParse

Parser de PDFs e documentos office sem LLM, desenvolvido pela [[03-RESOURCES/entities/LlamaIndex]]. Extrai texto estruturado projetado conforme o layout do documento. **Versão 2.0** (maio 2026) reescrita completamente em Rust.

## Versoes

### v1.0
- Apenas Node/TypeScript
- Runtime dominado pelo overhead de inicialização do processo Node
- Dependência hard de Node instalado no sistema

### v2.0 (2026-05-29)
- Reescrito inteiramente em Rust
- **Speedup:** 5–100× para documentos pequenos; ~3× para documentos grandes
- **Portabilidade:** Rust nativo, Node, Python, WASM (browser + edge)
- **Benchmark:** 0.777s para 457 páginas / 100MB
- Stack: fork customizado do PDFium + `tesseract-rs` como OCR padrão
- WASM: OCR via callback (ex: `tesseract-js`) em vez de built-in

## Instalacao

```bash
npm i @llamaindex/liteparse        # Node + CLI
pip install liteparse               # Python + CLI
cargo install liteparse             # Rust + CLI
npm i @llamaindex/liteparse-wasm   # WASM (browser + edge)
```

## Skill para coding agents

```bash
npx skills add run-llama/llamaparse-agent-skills --skill liteparse
```

Compatível com Claude Code, Codex, OpenCode.

## Links

- https://github.com/run-llama/liteparse
- https://developers.llamaindex.ai/liteparse/getting_started/
- Demo WASM: https://run-llama.github.io/liteparse/

## Fontes no vault

- [[03-RESOURCES/sources/open-source-ecosystems/liteparse-v2-rust-100x-parsing]]

## Conexoes

- [[03-RESOURCES/concepts/dev-foundations/rust-systems]]
- [[03-RESOURCES/entities/LlamaIndex]]
