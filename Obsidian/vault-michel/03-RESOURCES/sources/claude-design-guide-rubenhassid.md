---
title: "How to Quickly Use the New Claude Design"
type: source
created: 2026-04-24
updated: 2026-04-24
tags: [claude-design, anthropic, ai-design, ruben-hassid]
author: Ruben Hassid (@rubenhassid)
url: https://x.com/rubenhassid
---

# How to Quickly Use the New Claude Design

**Autor:** [[03-RESOURCES/entities/Ruben-Hassid]] (@rubenhassid)
**Produto:** [[03-RESOURCES/concepts/claude-design]] — produto separado em [claude.ai/design](https://claude.ai/design)

## Contexto

Claude Design foi lançado como **produto separado** (não dentro do app Claude). Roda em **Opus 4.7** (melhor modelo de visão da Anthropic). Impacto imediato: Figma perdeu $730M de valuation após o anúncio. 55 milhões de views em 2 dias.

## Acesso

- URL: `claude.ai/design`
- Requer plano **Pro ou Max** (pago)
- **Team/Enterprise:** desligado por padrão → admin deve habilitar em *Organization Settings → Capabilities → Anthropic Labs → toggle on*
- É um **research preview** — rollout gradual. Se redirecionar para home, tentar em alguns dias
- Usa os mesmos limites de tokens do plano. Consome tokens **extremamente rápido**
- Exporta para **Canva, PPTX, PDF, HTML standalone, bundle para Claude Code**

## 3 Modos de Criação

| Modo | Descrição |
|------|-----------|
| **Wireframe → High Fidelity** | Cria landing pages a partir de prompt de 2 linhas |
| **Slide Deck** | Claude faz perguntas, então gera slides com speaker notes |
| **From Template** | Vídeo animado 45s a partir de prompt ou sketch |

## Prompts Testados

### Landing page (funding pitch)
```
Create a high-fidelity landing page designed to raise $[AMOUNT] from [TARGET INVESTORS] for "[PRODUCT NAME]" — [short description].
Target audience: [audience]. Tone should feel [tone] — think a mix of [site A] + [site B] + [ecosystem].
```

### Slide deck para time de vendas
```
Create a pitch deck for my sales team. [Descrição do produto/empresa.]
```
Claude faz perguntas → responder → clicar Continue.

### Vídeo animado
Estruturar o prompt com timeline (0-5s, 5-15s, etc.), paleta de cores, estilo visual, tipografia.

## Video Hack → Slides

1. Gerar markdown via **Claude Research** (13 min)
2. No Claude Design, subir o `.md` com prompt: *"Make a 30-second animated video that summarizes this blog for a first-time viewer."*
3. No mesmo chat: *"Now convert that video into a slide pitch deck."*
4. Resultado: slides **melhores** do que se pedisse o deck diretamente — vídeo força pensamento visual antes de comprometer com frames estáticos

## Workflow Avançado: 0 to 1 (Cowork + Claude Design)

### Step 1 — Extrair sistema de design com [[03-RESOURCES/entities/Claude-Cowork]]
Soltar todos os assets de marca numa pasta → no Cowork, prompt:
```
Analyze this folder and produce a full design system write-up. Fonts, colors, graphical styles, component patterns, tone, layout conventions. Flag anything that's missing. Save it as DESIGN.md in my folder.
```
Output: `DESIGN.md` = brand guidelines e instruções.

### Step 2 — Subir DESIGN.md no Claude Design
Cada prompt futuro aplica o design system automaticamente.

### Step 3 — Gerar com prompt estruturado
4 inputs obrigatórios: **goal, layout, content, constraints**
```
Build a pricing page for [product]. 3 tiers, annual/monthly toggle, sticky CTA on mobile. Mobile-first responsive. Use our Primary Button component. Match the tone of our existing homepage.
```

### Step 4 — Iterar
- **Mudanças estruturais:** chat → *"Show me 3 alternative layouts."* → clicar "Tweaks"
- **Mudanças pixel-level:** canvas → botão edit → selecionar o elemento
- **Antes de experimento arriscado:** *"Save what we have, and try a completely different approach."* (salva branch)

### Step 5 — Validar (3 prompts)
```
Review this for contrast and accessibility. List any WCAG 2.1 AA violations with exact fixes.
Generate desktop, tablet, and mobile versions.
Suggest 2 A/B test variations of the hero section, each with a different angle.
```

### Step 6 — Exportar
Opções: Send to Canva (não funcionava no momento do artigo), PPTX, PDF, HTML standalone, bundle para Claude Code.

Tempo estimado: **1 hora para single page** | **2-3 horas para full website multi-tab**

## Copiar Qualquer Design (getdesign.md)

Site gratuito: [getdesign.md](https://getdesign.md/)
- Baixa `DESIGN.md` de marcas conhecidas (Mastercard, Airbnb, Ferrari, etc.)
- Subir esse arquivo no Claude Design → Claude cria designs **no estilo da marca escolhida**
- Sem afiliação do autor — uso gratuito

## Insight Principal: Taste is All You Need

Claude Design pode criar 10 dashboards em 10 minutos, mas não sabe **qual dos 10 enviar** para os seus usuários, no seu momento específico.

> "Taste is the ability to say no to 9 versions and yes to 1."

Designers com taste estão prestes a ter a melhor década de carreira. Ferramentas ficaram baratas; taste ficou mais caro.

## Conexões

- [[03-RESOURCES/concepts/claude-design]] — conceito central
- [[03-RESOURCES/entities/Ruben-Hassid]] — autor
- [[03-RESOURCES/entities/Claude-Cowork]] — usado no Step 1 do workflow avançado
- [[03-RESOURCES/concepts/claude-research-mode]] — usado no Video Hack (gera markdown)
- [[03-RESOURCES/entities/Claude-Opus-47]] — modelo que roda o Claude Design (Opus 4.7)
- [[03-RESOURCES/concepts/agentic-video]] — Claude Design cria vídeos animados via template
