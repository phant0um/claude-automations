---
title: "OAuth2 Callback URL and System Browser Support in Bruno"
type: source
source_url: "https://blog.usebruno.com/oauth2-callback-url-and-system-browser-support-in-bruno"
author: "Ganesh Patil"
published: 2026-02-19
created: 2026-06-22
updated: 2026-06-22
score: B
category: guides-courses-howtos
tags: [source, bruno, oauth2, authentication, system-browser, callback-url, security, api-testing]
---

# OAuth2 Callback URL and System Browser Support in Bruno

Bruno oferece opção de System Browser para OAuth 2.0 Authorization Code authentication — usa browser padrão do sistema em vez do embedded Electron browser. Permite saved passwords, 2FA extensions, corporate SSO. Privacy-first: todos dados OAuth ficam na máquina.

## Tese Central

OAuth2 em API clients embedded (Electron) perde funcionalidades que users esperam: saved passwords, 2FA, SSO. Bruno resolve abrindo o system browser default e usando callback URLs (Bruno hosted, local server, ou custom hosted) + deep link trigger (`bruno://app/oauth2/callback`) para trazer Bruno ao front e entregar os parâmetros. Tokens nunca passam por servers do Bruno.

## Pontos-Chave

### Enabling System Browser

- **Global (Preferences → General → Use System Browser for OAuth2)**: aplica a todas coleções
- **Per-request (Auth tab → OAuth 2.0 → Callback URL → Use System Browser)**: mantém inbuilt como default

### Como Funciona (5 steps)

1. **Authorization Request**: Bruno constrói URL (com `state` + PKCE `code_challenge`), abre no system browser
2. **User Authentication**: autentica no system browser (passwords, 2FA, SSO, biometrics)
3. **Callback Redirect**: browser → callback URL configurado, extrai `code` e `state`
4. **Deep Link Trigger**: callback page → `bruno://app/oauth2/callback?code=…&state=…` → OS traz Bruno ao front
5. **Token Exchange**: Bruno valida `state`, faz authorization code + PKCE exchange, stores tokens localmente

### Callback URL Options

| Option | URL | Who runs | Best for |
|---|---|---|---|
| Bruno Hosted | `https://oauth.usebruno.com/callback` | Bruno team | Quick tests, zero setup |
| Local Server | `http://localhost:3000/oauth/callback` | You (one command) | Offline, private, full control |
| Custom Hosted | `https://your-domain.com/oauth/callback` | Your team | Enterprise, custom domains |

- Bruno Hosted: só forwarda query parameters, nunca vê/stores tokens
- `@usebruno/oauth2-callback-server` para self-host

## Conceitos

- [[03-RESOURCES/concepts/dev-foundations/rest-api]] — API authentication
- [[03-RESOURCES/concepts/agent-systems/agent-security]] — security patterns

## Links

- [[03-RESOURCES/entities/MCP]] — Bruno ecosystem