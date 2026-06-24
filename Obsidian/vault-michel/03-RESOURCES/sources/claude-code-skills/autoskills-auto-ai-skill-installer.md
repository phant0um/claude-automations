---
title: "Autoskills — One Command AI Skill Stack Installer"
type: source
created: 2026-04-24
updated: 2026-04-24
tags: [autoskills, claude-code, skills, ai-tooling, dx]
source_url: https://autoskills.sh
raw_file: /Users/michelcsasznik/Downloads/Arquivar2/Autoskills.md
triagem_score: 7
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

Se `claude-code` é auto-detectado ou passado com `-a`, autoskills escreve um `CLAUDE.md` no root do projeto com um sumário das skills markdown instaladas. Esse comportamento se encaixa diretamente no workflow [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — o autoskills é essencialmente um **installer automático** do padrão SKILL.md.

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

- Autoskills automatiza o que antes era manual no [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] (procurar, selecionar e instalar SKILL.md individualmente)
- Complementa [[03-RESOURCES/entities/Matt-Pocock]] (repositório de 15k★ de skills) e `skillsmp.com` (66k+ skills)
- O `CLAUDE.md` gerado segue o mesmo padrão do [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]]
- Alternativa mais automatizada vs `npx skills@latest add <skill>` manual

## Mecanismo de detecção de tech stack

O scanner do autoskills funciona em múltiplas camadas, na seguinte ordem:

1. **`package.json` / `package-lock.json`:** extrai `dependencies` e `devDependencies`, mapeia para o catálogo de skills conhecidas.
2. **Gradle / Maven / `pom.xml`:** detecta projetos JVM, identifica Spring Boot, Kotlin, Android.
3. **Arquivos de config específicos:** `tailwind.config.js` → Tailwind; `next.config.js` → Next.js; `vite.config.ts` → Vite; `svelte.config.js` → Svelte.
4. **Diretórios especiais:** presença de `android/` → Android; `ios/` → SwiftUI/React Native.
5. **Extensões de arquivo no diretório raiz:** `.dart` → Flutter; `.go` → Go; `.tf` → Terraform.

A detecção é conservadora por design: prefere falsos negativos (skill não instalada) a falsos positivos (skill errada instalada). O `--dry-run` permite auditar o que seria instalado antes de confirmar.

## O CLAUDE.md gerado automaticamente

Quando autoskills detecta Claude Code (via `claude` binário no PATH ou flag `-a claude-code`), escreve um `CLAUDE.md` no root com:

- Seção `## Skills instaladas` listando cada skill com link para o arquivo em `.claude/skills/`
- Sumário de qual tecnologia ativou cada skill
- Instruções de invocação por skill (ex: "Para review de código React, use a skill `react-code-review`")

Este CLAUDE.md gerado não substitui um CLAUDE.md de projeto existente — ele é mergeado como uma seção adicional, preservando customizações do desenvolvedor.

## Limitações conhecidas

**Monorepos:** em repositórios com múltiplos `package.json` (ex: `apps/web/package.json` + `apps/api/package.json`), autoskills analisa apenas o root. Skills para o backend podem não ser detectadas se o `package.json` raiz não listar as dependências. Workaround: rodar `npx autoskills` separadamente em cada subdiretório.

**Skills customizadas não cobertas:** o catálogo cobre frameworks populares, mas bibliotecas de nicho (ex: Deno KV, Hono JSX) podem não ter skill correspondente. Nesses casos, o `--dry-run` mostrará lista vazia — sinal para criar a skill manualmente.

**Versões major diferentes:** a skill instalada pode ser calibrada para React 18 mas o projeto usa React 19. O arquivo `.md` da skill pode conter patterns deprecados. Recomendação: verificar data de última atualização da skill em skills.sh antes de confiar nos exemplos.

## Comparação com instalação manual via skills.sh

| Critério | `npx autoskills` | `npx skills@latest add <skill>` |
|---|---|---|
| Tempo de setup | ~30 segundos | 2–5 min (descobrir nome, instalar uma a uma) |
| Cobertura | Tudo detectado automaticamente | Apenas o que o dev lembra de instalar |
| Risco de skill irrelevante | Baixo (baseado em código real) | Baixo (dev decide) |
| Customização | Pós-instalação | Pré-instalação |
| CLAUDE.md automático | Sim (se claude-code detectado) | Não |

Para projetos com stacks simples e bem conhecidas, autoskills é claramente superior. Para setups muito específicos ou times com hábitos de curadoria manual, a instalação individual mantém mais controle.

## Relevância para o vault e fluxo de trabalho

O autoskills codifica um princípio importante: **convenção sobre configuração aplicada a AI tooling**. Em vez de o desenvolvedor precisar saber quais skills existem e qual usar, o scanner detecta o contexto e instala o que é provável ser útil. É o mesmo princípio do `CLAUDE.md` do vault: reduzir fricção de configuração para que a energia cognitiva vá para o trabalho, não para o setup.

Para projetos FIAP (Java + Spring Boot, por exemplo), autoskills instalaria automaticamente as skills de Spring, Java, e potencialmente Gradle — reduzindo o tempo de onboarding de Claude Code em cada novo projeto de horas para segundos.
