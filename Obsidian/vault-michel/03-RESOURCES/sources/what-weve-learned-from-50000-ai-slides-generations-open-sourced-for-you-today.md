---
title: "What we've learned from 50,000+ AI slides generations… open sourced for you today"
type: source
source: "Clippings/What we've learned from 50,000+ AI slides generations… open sourced for you today.md"
created: 2026-06-23
ingested: 2026-06-23
score: D
tags: [ai-agents, source-page]
---

## Tese central
---
title: "What we've learned from 50,000+ AI slides generations… open sourced for you today"
source: "
author:
  - "[[@Designarena]]"
published: 2026-06-23
created: 2026-06-23
description: "We've seen a massive uptick in demand for AI-generated slides at DesignArena - it’s become one of our fastest-growing creation categories.Th..."
tags:
  - "clippings"
---


We've seen a massive uptick in demand for AI-generated slides at DesignArena - it’s become one of our fastest-growing creation categori

## Argumentos principais
### There have been two main harness-level approaches to generating Slides
1. Generating Python code directly through the python-pptx library
2. Generating HTML/CSS code, rendering it in the browser, and mapping the layout to python-pptx via DOM traversal

### Approach 1: Direct Python-pptx code generation
The model writes Python code that calls the python-pptx API directly through add\_slide(), add\_textbox(), add\_picture(), etc. The code is executed, and the output is a .pptx file.
**Pros:**
- Full control over every PPTX primitive (charts, tables, animations)

### Approach 2: HTML/CSS generation + browser-based conversion
The model writes a self-contained HTML file with \<section class="slide"> elements. A headless browser renders it, and a converter maps the rendered DOM to python-pptx shapes.
**Pros:**
- Every frontier model has been trained on billions of web pages specifically for layout, typography, and color.

### The main problem: conversion is hard
The HTML approach has one hard dependency: something that turns rendered HTML into an editable PPTX.
Nothing we found does this cleanly:
- **Slidev, Marp, Reveal.js** export slides as images.

### Our HTML-to-PPTX library
Our lightweight library has 2 steps:
1. **Measure**: Load the HTML in headless Chromium. For each slide, inject JS that recursively walks the DOM and records every visible element's position, size, colors, fonts, text, and images.
2. **Render**: Walk the measurement tree and map each element to the closest python-pptx shape. Text becomes text boxes. Images become picture shapes. Backgrounds become filled rectangles. Gradients, rounded corners, and alpha transparency go through direct OOXML manipulation.

### Limitations
Here are some known limitations - we’d love your help with contributions here!
- Fonts aren't embedded. If the viewer doesn't have the CSS font installed, PowerPoint substitutes. This can cause some text to overflow.
- CSS background-image: url(...) isn't converted, only \ tags and inline SVGs.

### Github
[github.com/Design-Arena/html-to-pptx]() (MIT license)

### Code
```bash
pip install html-to-pptx
```

### Try it yourself
The HTML-to-PPTX library is part of our Slides Arena at [)


## Key insights
- Full control over every PPTX primitive (charts, tables, animations)
- No browser dependency
- The model can reference the Python-PPTX docs directly and iterate on the code
- Models struggle with spatial reasoning in code. Positioning elements at Inches(2.3) from the left and Inches(1.8) from the top is a guess. The model has no visual feedback loop
- Text overflow is invisible. A text box that's too small will clip silently in PowerPoint, and the model has no way to know.
- Complex layouts (multi-column, cards, grids) require tedious coordinate math that models get wrong regularly.
- Styling is limited to what python-pptx exposes. CSS gradients, border-radius, translucent overlays require manual OOXML XML manipulation.
- Every frontier model has been trained on billions of web pages specifically for layout, typography, and color.
- The browser handles spatial layout with flexbox, grid, gap, border-radius, linear-gradient instead.
- Styling is virtually unlimited since anything CSS can do, the HTML can express.

## Exemplos e evidências
See original source at `Clippings/What we've learned from 50,000+ AI slides generations… open sourced for you today.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/harness]]
- [[03-RESOURCES/concepts/software-engineering/code-generation]]
- [[03-RESOURCES/entities/Python]]
