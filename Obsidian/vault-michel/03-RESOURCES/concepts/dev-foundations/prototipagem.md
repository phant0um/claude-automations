---
title: "Prototipagem"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# Prototipagem

Validar uma ideia antes de construir o produto — mais barato falhar em papel do que em código.

## O que é

Prototipagem é o processo de criar representações do produto em diferentes graus de fidelidade para validar conceitos, testar fluxos e coletar feedback antes de investir tempo em desenvolvimento. A sequência típica é: **wireframe → mockup → protótipo → produto**.

**Baixa fidelidade** inclui wireframes em papel ou ferramentas simples (Balsamiq, draw.io) — blocos cinzas, sem cores, sem estética. O objetivo é estrutura e fluxo, não aparência. São rápidos de criar e modificar; ótimos para brainstorming inicial e validação de arquitetura de informação.

**Alta fidelidade** inclui mockups e protótipos interativos (Figma, Adobe XD) — cores reais, tipografia, componentes visuais, interações simuladas. Permitem testes de usabilidade mais realistas e aprovação de stakeholders antes de codificar. Um protótipo Figma interativo pode simular 80% da experiência do produto final sem uma linha de código.

A distinção mockup × protótipo: mockup é estático (imagem do produto), protótipo é interativo (você clica e navega).

## Como funciona

Fluxo em projeto FIAP:
1. **Brainstorming** → esboços em papel (10 min)
2. **Wireframe digital** → draw.io ou Figma (sem cores) — valida fluxos de telas
3. **Mockup** → Figma com identidade visual (cores, fontes, ícones)
4. **Protótipo interativo** → links entre telas no Figma — simula navegação
5. **Review com professor/cliente** → ajustes antes de codificar
6. **Implementação** → HTML/CSS/Java seguindo o protótipo aprovado

Ferramentas por fidelidade:
| Fidelidade | Ferramenta | Quando usar |
|---|---|---|
| Baixíssima | Papel + caneta | Brainstorming, 5 min |
| Baixa | Balsamiq, Whimsical | Wireframes rápidos |
| Média/Alta | Figma, Adobe XD | Mockup + protótipo interativo |

## Por que importa

Na FIAP, projetos integradores exigem entrega de protótipos (geralmente Figma) antes da implementação. Aprender a prototipar reduz drasticamente o retrabalho — é muito mais fácil mover um bloco no Figma do que refatorar 3 telas de HTML. Para concursos de TI com banca CESGRANRIO/FGV, prototipagem aparece em questões de Engenharia de Software e IHC (Interação Humano-Computador).

## Exemplo

Sem prototipagem: o dev passa 3 dias implementando a tela de cadastro exatamente como imaginou, o cliente vê e diz "mas eu queria o formulário na direita". Com wireframe (30 min), essa conversa acontece antes do código.

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/user-stories]]
- [[03-RESOURCES/concepts/responsive-design]]
- [[03-RESOURCES/concepts/engenharia-de-software]]
