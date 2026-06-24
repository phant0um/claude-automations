---
title: "Design Automation"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, ai-strategy-org]
status: developing
---

# Design Automation

Uso de IA para automatizar tarefas de design que antes exigiam trabalho manual especializado — da geração de layouts à criação de sistemas de design responsivos.

## O que é

Design automation é a aplicação de modelos generativos e regras programáticas para produzir ou adaptar artefatos visuais: layouts, paletas de cores, ícones, variações responsivas e até animações. O objetivo é eliminar trabalho repetitivo e permitir que designers foquem em decisões de alto nível.

## Como funciona / Detalhes

**Camadas de automação:**

| Nível | Exemplo | Ferramenta |
|-------|---------|-----------|
| Geração de layout | Grade automática, composição | Figma AI, Adobe Firefly |
| Tokens de design | Paleta, tipografia, espaçamento | Style Dictionary + LLM |
| Componentes | Variantes automáticas de botões | Figma Variables |
| Animação / Vídeo | Geração frame-a-frame via código | [[03-RESOURCES/concepts/hyperframes-skill]] |
| Design responsivo | Adaptação automática por breakpoint | HyperFrames pattern |

**Figma AI (2025):**
- "Make design" — gera UI a partir de prompt de texto
- Rename layers, gerar ícones, sugerir variantes de componente

**Claude Design System (Anthropic):**
- Skill interna que gera HTML/CSS/JS visualmente correto a partir de briefing, respeitando tokens de design

**Generative UI (tendência 2025-2026):**
- Interfaces geradas dinamicamente por LLM em runtime, não apenas em tempo de design
- Ex: Claude retorna componente React customizado baseado no contexto do usuário

**HyperFrames pattern:**
- Gerar vídeo como sequência de frames HTML/CSS renderizados programaticamente
- Evita custo de APIs de vídeo por difusão; adequado para conteúdo de dados / motion graphics

## Por que importa

Para Michel: design automation conecta ADS-FIAP (desenvolvimento web) com IA generativa — área de alta empregabilidade. Skills como `hyperframes` no vault já implementam esse padrão. Concursos de TI ainda não cobram diretamente, mas análise de viabilidade de automação é tópico emergente.

## Related
- [[03-RESOURCES/concepts/ux-ui-design]]
- [[03-RESOURCES/concepts/hyperframes-skill]]
- [[03-RESOURCES/concepts/ai-strategy-org/_index]]
