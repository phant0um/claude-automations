---
title: "How to Stop Claude Code From Reading Your API Keys, SSH Keys, and Passwords (Exact Deny Rules)"
type: source
source: "Clippings/How to Stop Claude Code From Reading Your API Keys, SSH Keys, and Passwords (Exact Deny Rules).md"
source_url: "https://x.com/0x_rody/status/2059930796488524061"
author: "@0x_rody"
published: 2026-05-28
created: 2026-05-29
ingested: 2026-05-29
tags: [ai-agents, claude-code, security, deny-rules, secrets, api-keys, ssh-keys, permissions]
---

## Tese central

A maioria dos usuários do Claude Code não tem regras de negação — e os que têm usam regras básicas que bloqueiam apenas 1 dos 3 mecanismos de vazamento de segredos. Um sistema de defesa em profundidade de 5 tiers (leitura direta, diretório home, exfiltração de rede, escrita de segredos, comandos destrutivos) mais 6 camadas de defesa adicionais cobre todos os vetores. Deny rules são controle soft, não hard boundary — a defesa deve ser em camadas.

## Argumentos principais

- **Os 3 mecanismos de vazamento de segredos (a maioria conhece apenas 1):**
  1. **Leak 1 — Leitura direta de arquivo:** Claude abre `.env` e lê. Óbvio. Um `Read(**/.env*)` deny rule bloqueia.
  2. **Leak 2 — Grep/busca:** Claude roda `grep -r "STRIPE" .` para encontrar nome de função. A busca acessa seu arquivo `.env`. Sua Stripe key aparece no output do grep. A deny rule para Read nunca disparou porque Claude usou Grep, não Read.
  3. **Leak 3 — Captura de runtime output:** Claude roda seus testes. Um HTTP request falho loga o header `Authorization: Bearer sk-live-abc123...`. Claude captura todo output de comando. Seus segredos agora estão na conversa sem Claude nunca ter aberto arquivo de segredo.
- **Vulnerabilidade crítica (Adversa AI, abril 2026):** Deny rules são silenciosamente bypassed quando um comando contém mais de 50 subcomandos. Um CLAUDE.md atacante com 50+ build steps (normal para monorepo) pode esconder um `curl` no passo 51 que exfiltra suas SSH keys. A deny rule para `Bash(curl *)` nunca dispara. Sem aviso, sem log. Anthropic corrigiu em versões mais novas, mas a lição é clara: deny rules são controle soft, não hard boundary.
- **Configuração — onde ficam as regras:** `~/.claude/settings.json` (global, protege todos os projetos) ou `.claude/settings.json` (específico do projeto, compartilhável via git).
- **Tier 1 — Bloqueio de leitura direta de arquivos (mínimo obrigatório):**
  ```json
  "deny": ["Read(**/.env*)", "Read(**/.dev.vars*)", "Read(**/*.pem)", 
           "Read(**/*.key)", "Read(**/*.p12)", "Read(**/secrets/**)",
           "Read(**/credentials/**)", "Read(**/config/database.yml)",
           "Read(**/config/credentials.json)", "Read(**/.npmrc)", "Read(**/.pypirc)"]
  ```
- **Tier 2 — Bloqueio de segredos no diretório home:** Claude herda permissões do usuário e pode ler fora do projeto:
  ```json
  "deny": ["Read(**/.ssh/**)", "Read(**/.aws/**)", "Read(**/.azure/**)",
           "Read(**/.gcloud/**)", "Read(**/.docker/config.json)",
           "Read(**/.kube/config)", "Read(**/.gnupg/**)", "Read(**/.netrc)"]
  ```
  "One leaked SSH key = full access to your servers, GitHub repos, and CI/CD pipelines."
- **Tier 3 — Bloqueio de exfiltração de rede:**
  ```json
  "deny": ["Bash(curl *)", "Bash(wget *)", "Bash(nc *)", "Bash(ssh *)",
           "Bash(scp *)", "Bash(rsync *)", "Bash(ftp *)"]
  ```
  Para permitir curl só para seu domínio: `allow: ["Bash(curl https://api.your-app.com/*)"]` + deny geral. Allow dispara primeiro para o domínio específico, deny pega todo o resto.
- **Tier 4 — Bloqueio de comandos destrutivos:**
  ```json
  "deny": ["Bash(rm -rf *)", "Bash(sudo *)", "Bash(chmod *)", "Bash(chown *)",
           "Bash(git push --force*)", "Bash(git reset --hard*)",
           "Bash(npm publish*)", "Bash(docker *)"]
  ```
- **Tier 5 — Bloqueio de escrita de segredos:** Claude não deveria só não ler segredos — não deveria escrevê-los também:
  ```json
  "deny": ["Write(**/.env*)", "Write(**/secrets/**)", "Write(**/.ssh/**)",
           "Write(**/.aws/**)", "Write(.github/workflows/*)", "Write(package-lock.json)"]
  ```
  Bloqueia: criar arquivos .env, modificar CI/CD workflows (vetor de ataque de supply chain), alterar package-lock.json (confusão de dependências).
- **Checklist de defesa em profundidade (6 camadas):**
  ```
  Layer 1: Deny rules em settings.json → bloqueia acesso direto
  Layer 2: .env.test com valores dummy → testes com credenciais falsas
  Layer 3: Pre-commit hook scanning → detecta credenciais antes do git
  Layer 4: Environment variables via secret manager → Vault/1Password, não plaintext
  Layer 5: Short transcript retention → CLAUDE_CODE_SKIP_PROMPT_HISTORY=1
  Layer 6: Container isolation → montar /dev/null sobre .env (sensitive projects)
  ```
- **settings.json completo (copy-paste pronto):** Inclui allow rules para leitura geral, escrita em src/tests/docs, comandos npm/git comuns, mais o conjunto completo de deny rules dos 5 tiers.

## Key insights

- Grep e output de runtime são vetores de vazamento que bypass as deny rules mais comuns — maioria dos setups só bloqueia leitura direta.
- "Deny rules are a soft control, not a hard boundary. Layer your defenses." — a vulnerabilidade dos 50+ subcomandos prova isso empiricamente.
- O tier home directory é frequentemente esquecido: Claude herda permissões do usuário e pode ler ~/.ssh, ~/.aws etc. a menos que explicitamente bloqueado.
- Tier 5 (block secret writes) é especialmente crítico para CI/CD: impede Claude de modificar `.github/workflows/` (supply chain attack vector) e `package-lock.json` (dependency confusion).
- `CLAUDE_CODE_SKIP_PROMPT_HISTORY=1` garante que segredos que entram na conversa não persistam em transcripts.
- Container isolation (montar /dev/null sobre .env) é hard boundary — o arquivo fisicamente não existe para Claude.
- Allow + deny: allow dispara primeiro para domínios específicos, deny pega o resto — permite curl seletivo sem expor rede toda.

## Exemplos e evidências

- Vulnerabilidade Adversa AI (abril 2026): bypass silencioso de deny rules em comandos com 50+ subcomandos. Corrigido em versões mais novas do Claude Code.
- Exemplo de ataque real: CLAUDE.md malicioso com 50+ build steps escondendo curl no passo 51 para exfiltrar SSH keys.
- Diferença before/after: de "Claude lê ~/.ssh/id_rsa sem você saber" para "Claude pode ler código, escrever código, rodar testes — não pode ler segredos, enviar dados externamente ou deletar arquivos."

## Implicações para o vault

- O vault-michel opera com Claude Code com acesso à pasta do vault. As deny rules do Tier 1 e 2 são diretamente aplicáveis ao `~/.claude/settings.json` global.
- Tier 3 (bloqueio de rede) é particularmente relevante: o vault contém CLAUDE.md files de terceiros (ingested sources) que poderiam conter instruções maliciosas.
- Pre-commit hook scanning (Layer 3) é relevante dado que o vault está em git.
- A vulnerabilidade de 50+ subcomandos sugere cautela com scripts de build complexos no vault (pipelines de ingestão bulk).
- `CLAUDE_CODE_SKIP_PROMPT_HISTORY=1` é opção relevante para sessões que processam material confidencial (FIAP, concurso).

## Links

- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-security]]
- [[03-RESOURCES/concepts/ai-strategy-org/privacy-first-ai]]
- [[03-RESOURCES/sources/guides-courses-howtos/claude-code-investment-research-analyst]]
