---
title: "Autoskills — One Command AI Skill Stack Installer"
type: source
created: 2026-04-24
updated: 2026-04-24
tags: [autoskills, claude-code, skills, ai-tooling, dx]
source_url: https://autoskills.sh
raw_file: /Users/michelcsasznik/Downloads/Arquivar2/Autoskills.md
---

# Autoskills

**Autoskills** é uma ferramenta CLI que escaneia um projeto, detecta o tech stack e instala automaticamente as melhores AI agent skills via [[03-RESOURCES/entities/skills-sh|skills.sh]].

## Como funciona

```bash
npx autoskills
```

1. Escaneia `package.json`, Gradle files e configs para detectar tecnologias
2. Instala as skills mais relevantes via [skills.sh](https://skills.sh/)
3. Se Claude Code for detectado (`-a claude-code`), gera um `CLAUDE.md` automaticamente com resumo das skills instaladas em `.claude/skills/`

## Integração com Claude Code

Se `claude-code` é auto-detectado ou passado com `-a`, autoskills escreve um `CLAUDE.md` no root do projeto com um sumário das skills markdown instaladas. Esse comportamento se encaixa diretamente no workflow [[03-RESOURCES/concepts/claude-skills]] — o autoskills é essencialmente um **installer automático** do padrão SKILL.md.

## Opções CLI

| Flag | Comportamento |
|------|--------------|
| `-y, --yes` | Pula prompt de confirmação |
| `--dry-run` | Mostra o que seria instalado sem instalar |
| `-h, --help` | Exibe ajuda |

## Tecnologias suportadas

- **Frameworks & UI:** React, Next.js, Vue, Nuxt, Svelte, Angular, Astro, Tailwind CSS, shadcn/ui, GSAP, Three.js
- **Languages & Runtimes:** TypeScript, Node.js, Go, Bun, Deno, Dart
- **Backend & APIs:** Express, Hono, NestJS, Spring Boot
- **Mobile & Desktop:** Expo, React Native, Flutter, SwiftUI, Android, Kotlin Multiplatform, Tauri, Electron
- **Data & Storage:** Supabase, Neon, Prisma, Drizzle ORM, Zod, React Hook Form
- **Auth & Billing:** Better Auth, Clerk, Stripe
- **Testing:** Vitest, Playwright
- **Cloud & Infrastructure:** Vercel, Vercel AI SDK, Cloudflare, Durable Objects, Cloudflare Agents, Cloudflare AI, AWS, Azure, Terraform
- **Tooling:** Turborepo, Vite, oxlint
- **Media & AI:** Remotion, ElevenLabs

## Relação com o ecossistema

- Autoskills automatiza o que antes era manual no [[03-RESOURCES/concepts/claude-skills]] (procurar, selecionar e instalar SKILL.md individualmente)
- Complementa [[03-RESOURCES/entities/Matt-Pocock]] (repositório de 15k★ de skills) e `skillsmp.com` (66k+ skills)
- O `CLAUDE.md` gerado segue o mesmo padrão do [[03-RESOURCES/concepts/claude-folder-anatomy]]
- Alternativa mais automatizada vs `npx skills@latest add <skill>` manual
