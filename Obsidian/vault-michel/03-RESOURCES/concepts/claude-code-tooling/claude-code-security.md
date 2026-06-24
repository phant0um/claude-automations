---
title: Claude Code Security — Deny Rules
type: concept
created: 2026-05-29
updated: 2026-05-29
tags: [claude-code, security, deny-rules, api-keys, ssh-keys, permissions, defense-in-depth]
---

# Claude Code Security — Deny Rules

Claude Code herda permissões do usuário e pode ler qualquer arquivo acessível. A maioria dos setups não tem regras de negação, ou tem regras básicas que bloqueiam apenas 1 dos 3 mecanismos de vazamento de segredos. Sistema completo requer 5 tiers de deny rules + 6 camadas adicionais.

## Os 3 mecanismos de vazamento (maioria só bloqueia o 1)

1. **Leitura direta:** Claude abre `.env`. `Read(**/.env*)` bloqueia.
2. **Grep/busca:** Claude roda `grep -r "STRIPE" .` → sua key aparece no output. Deny de Read não dispara porque foi Grep, não Read.
3. **Runtime output capture:** teste falho loga `Authorization: Bearer sk-live-abc123...`. Claude captura todo output. Segredo na conversa sem abrir arquivo.

## Vulnerabilidade crítica (Adversa AI, abril 2026)

Deny rules bypass silencioso em comandos com 50+ subcomandos. CLAUDE.md malicioso com 50+ build steps pode esconder `curl` no passo 51. Deny rule para `Bash(curl *)` nunca dispara. Sem aviso, sem log. Anthropic corrigiu em versões mais novas. Lição: **deny rules são controle soft, não hard boundary**.

## Os 5 Tiers de deny rules (`~/.claude/settings.json`)

**Tier 1 — Leitura direta de arquivos:**
`Read(**/.env*)`, `Read(**/*.pem)`, `Read(**/*.key)`, `Read(**/secrets/**)`, `Read(**/credentials/**)`, `Read(**/.npmrc)`

**Tier 2 — Home directory (fora do projeto):**
`Read(**/.ssh/**)`, `Read(**/.aws/**)`, `Read(**/.azure/**)`, `Read(**/.gcloud/**)`, `Read(**/.docker/config.json)`, `Read(**/.kube/config)`, `Read(**/.gnupg/**)`, `Read(**/.netrc)`

**Tier 3 — Exfiltração de rede:**
`Bash(curl *)`, `Bash(wget *)`, `Bash(nc *)`, `Bash(ssh *)`, `Bash(scp *)`, `Bash(rsync *)`
- Para curl seletivo: `allow: ["Bash(curl https://api.sua-app.com/*)"]` + deny geral

**Tier 4 — Comandos destrutivos:**
`Bash(rm -rf *)`, `Bash(sudo *)`, `Bash(chmod *)`, `Bash(git push --force*)`, `Bash(npm publish*)`, `Bash(docker *)`

**Tier 5 — Escrita de segredos:**
`Write(**/.env*)`, `Write(**/secrets/**)`, `Write(**/.ssh/**)`, `Write(.github/workflows/*)` (supply chain attack vector)

## 6 camadas de defesa em profundidade

```
Layer 1: Deny rules em settings.json
Layer 2: .env.test com valores dummy
Layer 3: Pre-commit hook scanning
Layer 4: Secrets via manager (Vault/1Password), não plaintext
Layer 5: CLAUDE_CODE_SKIP_PROMPT_HISTORY=1
Layer 6: Container isolation (montar /dev/null sobre .env)
```

## Configuração

- **Global:** `~/.claude/settings.json` — protege todos os projetos
- **Projeto:** `.claude/settings.json` — compartilhável via git com o time

## Relacionado

- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/concepts/ai-strategy-org/privacy-first-ai]]
- [[03-RESOURCES/sources/guides-courses-howtos/claude-code-security-deny-rules]]

## Evidências
- **[2026-06-19]** Princípio comunitário: comece com skills, depois tools — skills definem o que o agente sabe fazer, tools definem o que pode tocar; "default should be off" defendido por usuários avançados — [[hermes-users-are-turning-agents-into-chores-side-businesses-and-security-debates]]
- **[2026-06-19]** Gestão de risco por diff: pequeno em áreas de alto risco (auth/dados/dinheiro), grande aceitável onde verificável empiricamente; permissões opt-in por categoria de acesso como "rails" para iteração mais rápida — [[03-RESOURCES/sources/fable-class-models-as-code-interpreters]]
