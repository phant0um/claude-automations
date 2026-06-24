---
title: Node.js
type: entity
entity_type: runtime
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [javascript, runtime, backend]
---

# Node.js

Runtime JavaScript construído sobre o V8 (Chrome). Criado por Ryan Dahl em 2009. Atualmente mantido pela OpenJS Foundation.

## Características

- **Single-threaded** com event loop
- **Async não-bloqueante** (libuv)
- **Módulos** CommonJS (`require`) e ES Modules (`import`)
- **NPM** como gerenciador de pacotes (maior registry do mundo)
- **Ecossistema massivo** — Express, NestJS, Next.js, Vite
- **Versões LTS** a cada ano par; current a cada ano

## Instalação

- **Windows/macOS direto** — instalador oficial LTS
- **NVM** (Node Version Manager) — múltiplas versões side-by-side
- **macOS Homebrew**: `brew install node`

## Comandos essenciais

```bash
node -v
node app.js
npm init
npm install <pkg>
npm install -g <pkg>     # global
npm install --save-dev   # devDependency
npx <pkg>                # exec sem instalar
nvm use 20
```

## Casos de uso

- APIs REST e GraphQL
- Microsserviços
- CLI tools
- Build tools (Webpack, Vite, esbuild)
- SSR (Next.js, Nuxt)
- IoT (Node-RED)

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 03 (Node.js + TypeScript)

## Relacionado

- [[03-RESOURCES/entities/TypeScript|TypeScript]]
- [[03-RESOURCES/entities/Next.js|Next.js]]
- [[03-RESOURCES/entities/Node-RED|Node-RED]]
