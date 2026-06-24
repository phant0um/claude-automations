---
title: "Bootstrap"
type: concept
status: developing
tags: [frontend, css-framework, design-responsivo, fiap-fase-4]
source: ".raw/fiap/Fase 4 - View/1TDS - Fase 04 - 09 - Muito estilo sem sofrimento.docx_RevFinal.pdf"
created: 2026-04-14
updated: 2026-05-19
---

# Bootstrap

Framework CSS open-source para desenvolvimento de interfaces web responsivas e com aparência consistente. Versão ensinada: **Bootstrap 5**. Coberto na Fase 4 (apostila 09 — "Muito estilo sem sofrimento").

## Instalação

```html
<!-- Via CDN (mais simples) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js"></script>
```

Também disponível via download direto (pasta com `css/` e `js/`).

## Sistema de Grid

Bootstrap usa um grid de **12 colunas** com 6 breakpoints:

| Classe | Breakpoint | Tamanho mínimo |
|--------|-----------|----------------|
| `col-` | xs (padrão) | < 576px |
| `col-sm-` | Small | ≥ 576px |
| `col-md-` | Medium | ≥ 768px |
| `col-lg-` | Large | ≥ 992px |
| `col-xl-` | X-Large | ≥ 1200px |
| `col-xxl-` | XX-Large | ≥ 1400px |

```html
<div class="container">
  <div class="row">
    <div class="col-md-6">Metade em telas médias+</div>
    <div class="col-md-6">Outra metade</div>
  </div>
</div>
```

- `container` — largura máxima centralizada
- `container-fluid` — largura total da tela

## Utilitários de uso frequente

```html
<!-- Cores de texto e fundo -->
<p class="text-primary">Azul</p>
<div class="bg-success text-white">Verde com texto branco</div>

<!-- Tipografia -->
<p class="lead">Parágrafo em destaque</p>
<p class="fs-1">Tamanho de fonte 1 (maior)</p>
<p class="text-center">Centralizado</p>

<!-- Espaçamento (m=margin, p=padding; t/b/s/e/x/y; 0-5) -->
<div class="mt-3 mb-2 px-4">...</div>

<!-- Display -->
<div class="d-flex justify-content-between align-items-center">...</div>
<div class="d-none d-md-block">Visível só em md+</div>

<!-- Bordas -->
<div class="border border-primary rounded">...</div>

<!-- Imagens responsivas -->
<img src="foto.jpg" class="img-fluid" alt="...">
```

## Componentes principais

### Botões
```html
<button class="btn btn-primary">Primário</button>
<button class="btn btn-outline-danger btn-sm">Perigo pequeno</button>
<div class="btn-group">...</div>
```

### Navbar
```html
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">...</nav>
```

### Tabelas
```html
<table class="table table-striped table-hover table-responsive">...</table>
```

### Cards
```html
<div class="card">
  <div class="card-body">
    <h5 class="card-title">Título</h5>
    <p class="card-text">Conteúdo</p>
  </div>
</div>
```

### Modal
```html
<!-- Botão trigger -->
<button data-bs-toggle="modal" data-bs-target="#meuModal">Abrir</button>
<!-- Modal -->
<div class="modal fade" id="meuModal">...</div>
```

### Outros
- **Accordion** — painéis colapsáveis
- **Carousel** — slideshow de imagens
- **Dropdown** — menus suspensos
- **Forms** — classes para inputs, labels, validação visual

## Integração com YouTube
```html
<div class="ratio ratio-16x9">
  <iframe src="https://www.youtube.com/embed/VIDEO_ID"></iframe>
</div>
```

## Relacionado

- [[02-AREAS/fiap/fase-4/fase-4-index|Fase 4 — View]]
- [[03-RESOURCES/concepts/dev-foundations/git-github|Git e GitHub]] — versionamento dos projetos frontend

## Evidências
- **[2026-06-24]** ## Cybersecurity Skills Router / Reverse-Engineering Skill Routing Pack. — [[authorized-penetration-testing-security-research-skill-router-pack-ai-powered-routing-on-demand-toolchain-bootstrapping-self-evolving-knowledge-base-supports-claude-code-kiro-cursor-cline-and-other-ai-coding-clients-ai]]
