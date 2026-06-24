---
title: "Acessibilidade Web"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# Acessibilidade Web

Projetar e desenvolver sites/apps para que pessoas com deficiências possam usá-los com a mesma eficiência que qualquer outro usuário.

## O que é

Acessibilidade web (a11y) é o conjunto de práticas, padrões e tecnologias que tornam conteúdo digital utilizável por pessoas com deficiências visuais, motoras, auditivas ou cognitivas. O padrão internacional é o **WCAG 2.1** (Web Content Accessibility Guidelines), mantido pelo W3C.

**Níveis de conformidade WCAG:**
- **A** — mínimo obrigatório (ex: texto alternativo em imagens)
- **AA** — padrão de mercado e exigido pela maioria das legislações
- **AAA** — excelência (difícil de alcançar globalmente)

## Como funciona / Detalhes

**Critérios principais WCAG 2.1:**
- Texto alternativo (`alt`) em todas as imagens informativas
- Contraste mínimo 4.5:1 (texto normal) e 3:1 (texto grande)
- Navegação completa por teclado (sem dependência de mouse)
- Legendas em vídeos; transcrições em áudios
- Estrutura semântica de headings (H1 > H2 > H3)
- Formulários com labels associados via `for`/`id`

**ARIA (Accessible Rich Internet Applications):**
- Atributos HTML que adicionam semântica extra: `role`, `aria-label`, `aria-describedby`, `aria-live`
- Usados quando HTML semântico nativo não é suficiente (ex: componentes customizados)

**Ferramentas de teste:**
- **axe DevTools** — extensão de browser, detecta ~57% dos problemas automaticamente
- **Lighthouse** — audit integrado no Chrome DevTools
- **NVDA / VoiceOver** — leitores de tela para teste manual

**Obrigação legal no Brasil:**
- **LBI art. 63** (Lei nº 13.146/2015 — Lei Brasileira de Inclusão): sites e aplicativos de empresas com sede ou filial no Brasil devem ser acessíveis
- Órgãos públicos: decreto 5.296/2004 e e-MAG (padrão governamental brasileiro)

## Por que importa

Para Michel: projetos FIAP são avaliados por usabilidade e boas práticas — implementar a11y demonstra senioridade técnica. Em concursos de TI, WCAG e LBI são tópicos recorrentes em questões de engenharia de software e legislação digital.

## Related
- [[03-RESOURCES/concepts/accessibility]]
- [[03-RESOURCES/concepts/ux-ui-design]]
- [[03-RESOURCES/concepts/governing-law-regimes]]
- [[03-RESOURCES/concepts/dev-foundations/_index]]
