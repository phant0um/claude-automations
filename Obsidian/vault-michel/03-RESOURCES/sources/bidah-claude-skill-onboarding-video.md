---
title: "bidah — Claude skill create-onboarding-video para apps mobile"
type: source
source_file: "Clippings/Drop your screenshots and this Claude skill turns them into animated onboarding.md"
origin: artigo no X (@bidah)
ingested: 2026-05-14
tags: [claude-skill, onboarding, mobile, conversion, ux, video]
---
# bidah — Claude skill create-onboarding-video para apps mobile

> [!key-insight] Core point
> A skill `create-onboarding-video` recebe screenshots de uma feature e gera um vídeo de onboarding animado com pointer animations — o maior lever de conversão antes do paywall.

## Conteúdo

### Problema: onboarding videos convertem, mas são difíceis de produzir
- Mostrar o app funcionando **antes** do paywall = maior lever de conversão mobile
- Motivos: constrói confiança, clarifica o core loop para usuários novos
- Problema: produzir vídeos didáticos de qualidade requer taste de design, motion skills, ferramentas certas

### Distinção "show vs teach"
- Screen recording mostra **que** a feature funciona
- Vídeo didático **ensina** o que o app faz: pointer animations exagerados, pauses nos screens importantes, tap targets destacados **antes** da ação

### A skill
- Repo: [github.com/bidah/skill-set/blob/main/skills/create-onboarding-video/SKILL.md](https://github.com/bidah/skill-set/blob/main/skills/create-onboarding-video/SKILL.md)
- Input: sequência de screenshots da feature em ordem
- Output:
  - Pointer animations para movimentos de dedo/toque
  - UI interativa regenerada (não flat screen capture)
  - Vídeo polished pronto para o onboarding

### Contexto de conversão
- Estatística citada: onboarding + paywall → 75-80% de todas as conversões
- Posicionamento ideal: ANTES do paywall, não na tela do paywall

## Conexões
- [[03-RESOURCES/entities/bidah]]
- [[03-RESOURCES/concepts/claude-skills]]
- [[03-RESOURCES/concepts/agentic-skills]]
- [[03-RESOURCES/concepts/progressive-disclosure]]
