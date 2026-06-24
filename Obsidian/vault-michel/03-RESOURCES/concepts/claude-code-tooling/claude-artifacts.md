---
title: Claude Artifacts
type: concept
status: developing
tags: [claude, artifacts, outputs, html, react, mermaid, svg]
created: 2026-04-19
updated: 2026-04-19
---

# Claude Artifacts

Outputs standalone e interativos que Claude cria numa janela dedicada ao lado da conversa — em vez de bloco de texto no chat. Renderizados e prontos para uso imediato.

Claude cria um artifact automaticamente quando o conteúdo é:
- Significativo e auto-contido (tipicamente >15 linhas)
- Algo que você provavelmente vai editar, iterar, ou reusar
- Conteúdo complexo que existe por si mesmo sem a conversa ao redor
- Algo que você vai referenciar mais tarde

## Tipos de artifacts

| Tipo | Para que serve |
|---|---|
| **Documents** (markdown, txt, Word, PDF, PPT, Excel) | Conteúdo textual para exportar ou continuar editando — meeting notes, reports, blog posts |
| **Code snippets** | Código em qualquer linguagem — Python, JS, C++, etc. Pronto para copiar ou baixar |
| **HTML pages** | Páginas web completas (HTML+CSS+JS) — landing pages, forms, demos, protótipos |
| **SVG images** | Logos, ícones, ilustrações — renderizam direto na janela |
| **Mermaid diagrams** | Flowcharts, sequence diagrams, Gantt, org charts — descreve relações em texto |
| **React components** | UI interativa com lógica real — calculadoras, dashboards, jogos, visualizações |

## Como usar

Criar um artifact é só conversar. Claude decide automaticamente. Exemplos de prompts:
- *"Create a flowchart showing our customer onboarding process"*
- *"Build an interactive dashboard that lets me input monthly expenses and see a breakdown"*
- *"Design a landing page for a productivity app"*
- *"Write a project brief template I can reuse"*

Se Claude não criar um artifact quando você espera: *"Please create that as an artifact."*

## Controles na janela do artifact

- **Preview ↔ Code** — alterna entre visualização e código subjacente
- **Copy** — copia o conteúdo
- **Download** — salva como arquivo
- **Share/Publish** — publica publicamente ou compartilha na organização

## Compartilhamento

- **Copy/Download** — uso pessoal ou via outros canais
- **Share interno (Team/Enterprise)** — requer autenticação da organização
- **Publish público** — qualquer pessoa com o link pode ver e interagir; não aparece no Google; pode ser "remixado" por outros usuários

> [!note] Privacidade ao publicar
> Apenas o artifact fica público — o chat continua privado. Unpublish disponível a qualquer momento.

## Dicas de uso

- **Seja específico**: "budget tracker where I can input expenses by category, see a pie chart, and get a warning when I'm over budget" > "build a budget tracker"
- **Descreva o usuário final**: quem vai usar o artifact muda as escolhas de design
- **Itere incrementalmente**: uma feature por vez
- **Force quando necessário**: "Create this as an artifact"

## HTML como formato preferencial

Membros da equipe Claude Code (notadamente [[03-RESOURCES/entities/trq212-tariq]]) argumentam que HTML é o tipo de artifact mais poderoso — substitui Markdown para specs, reports, code reviews e interfaces throwaway. Ver [[03-RESOURCES/concepts/dev-foundations/html-as-llm-artifact]] e [[03-RESOURCES/concepts/dev-foundations/single-file-html-pattern]].

## Workflow consumer: 9 passos de ideia a app publicado

Para usuários não-técnicos: escolher app pequeno (1 screen, 1 job) → escrever spec como "substantivos = o que vê, verbos = o que faz" → nomear o deliverable explicitamente ("interactive app", não "make me X") → iterar uma mudança por vez → adicionar interatividade real (state, charts) → alimentar com dados reais (CSV/upload) → pedir persistência entre sessões (localStorage não funciona em artifacts — usar storage nativo) → debugar descrevendo sintomas, não código → polir design e Publish. Ver [[03-RESOURCES/sources/claude-artifacts-9-steps-app]].

## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/claude-101-anthropic-course]]
- [[03-RESOURCES/sources/guides-courses-howtos/ultimate-guide-master-claude-tools]] — casos de uso avançados com artifacts
- [[03-RESOURCES/sources/skills-prompting-mcp/claude-code-unreasonable-effectiveness-of-html]] — tese HTML > Markdown; use cases detalhados
- [[03-RESOURCES/sources/claude-artifacts-9-steps-app]] — guia 9-passos para usuários consumer (no-code)
