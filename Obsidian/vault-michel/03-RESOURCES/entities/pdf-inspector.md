---
title: pdf-inspector
type: entity
category: tool
updated: 2026-04-16
tags: [firecrawl, rust, pdf, ocr, pipeline]
created: 2026-05-31
---

# pdf-inspector

Biblioteca Rust da Firecrawl para classificação e extração de texto de PDFs — local, sem OCR, sem serviços externos.

## Pipeline de roteamento inteligente

```
PDF chega → classifica em ~20ms
→ TextBased + alta confiança? → extrai localmente (~150ms)
→ Não?                        → envia para OCR (2-10s)
```

## Relevância para SEI Agent

TJAM processa volumes grandes de PDFs. pdf-inspector como pré-processamento economiza custo e latência: **~54% dos PDFs já têm texto extraível** e podem ser processados localmente sem OCR.

Ver: [[03-RESOURCES/entities/SEI-Automation-Agent]]

## Disponível em

- Python: `pip install maturin` + `maturin develop`
- Node.js: `npm install firecrawl-pdf-inspector`
- Rust (nativo)
- CLI

## Fontes

- [[03-RESOURCES/sources/misc-low-confidence/claude-knowledge-digest-abril-2026]]
