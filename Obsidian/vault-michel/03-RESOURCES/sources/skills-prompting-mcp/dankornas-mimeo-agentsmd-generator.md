---
title: "@DanKornas — Mimeo: AGENTS.md Generator from Expert Body of Work"
type: source
source_url: "https://x.com/DanKornas/status/2058239276169539655"
author: "@DanKornas"
published: 2026-05-23
ingested: 2026-05-28
tags: [agents-md, skill-md, tooling, python, content-extraction, agent-configuration, open-source]
---

# @DanKornas — Mimeo: AGENTS.md Generator from Expert Body of Work

## Tese central

Mimeo é uma ferramenta Python open-source (MIT) que transforma o corpo de trabalho de um especialista (ensaios, palestras, podcasts, artigos) em um AGENTS.md ou SKILL.md pronto para uso — com pipeline de descoberta, extração, destilação, agrupamento e crítica adversarial.

## Key insights

- **Dois outputs:** `SKILL.md` com referências ou `AGENTS.md` — ambos ou individual.
- **Pipeline de descoberta:** busca ensaios, palestras, entrevistas, podcasts, livros, artigos acadêmicos e mais. Extração via web scraping, legendas YouTube e transcrição Whisper (local).
- **Verificação de citações:** verifica citações agrupadas contra o texto da fonte e gera rastro de auditoria.
- **Passo de crítica:** revisão adversarial de editor com relatório pontuado antes de publicar o artefato final.
- **Caso de uso:** criar CLAUDE.md ou AGENTS.md inspirado no estilo de um especialista específico sem semanas de pesquisa manual.
- Licença MIT — pode ser integrado em pipelines existentes.

## Implicações para o vault

- Complementa [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] como forma de criar skills baseadas em especialistas específicos.
- A verificação de citações + crítica adversarial é o mesmo padrão de qualidade que o vault usa para ingestão (Gate 2 + contradictions).
- Candidato a ferramenta no pipeline de ingestão do vault para gerar skills a partir de pensadores específicos.

## Links

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/anatomy-claude-prompt]]
