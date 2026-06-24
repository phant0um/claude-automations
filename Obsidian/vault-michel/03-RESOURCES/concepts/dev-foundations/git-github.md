---
title: "Git e GitHub"
type: concept
status: developing
tags: [controle-de-versao, vcs, colaboracao, fiap-fase-4]
source: ".raw/fiap/Fase 4 - View/1TDS - Fase 04 - 12 - A rede social dos desenvolvedores.docx_RevFinal.pdf"
created: 2026-04-14
updated: 2026-05-19
---

# Git e GitHub

**Git** é um sistema de controle de versão distribuído (DVCS). **GitHub** é a plataforma de hospedagem de repositórios Git com funcionalidades de colaboração. Coberto na Fase 4 (apostila 12 — "A rede social dos desenvolvedores").

## VCS Centralizado vs. Distribuído

| Centralizado (ex: SVN) | Distribuído (Git) |
|------------------------|-------------------|
| Um repositório central | Cada dev tem cópia completa |
| Perde acesso sem rede | Trabalha offline |
| Histórico no servidor | Histórico local + remoto |

## Áreas do Git

```
Working Directory  →  Staging Area (Index)  →  Repository (.git)
     (edit)              (git add)              (git commit)
```

## Comandos essenciais

```bash
# Configuração inicial
git config --global user.name "Nome"
git config --global user.email "email@example.com"

# Iniciar repositório
git init

# Ciclo básico
git status                    # ver estado atual
git add arquivo.txt           # adicionar ao stage
git commit -m "mensagem"      # commitar

# Branches
git branch                    # listar branches
git branch nome-branch        # criar branch
git checkout nome-branch      # mudar de branch
git merge nome-branch         # fazer merge na branch atual

# Diff
git diff                      # diferenças no working directory
git diff --cached             # diferenças no stage
git diff HEAD                 # comparar com último commit

# Repositório remoto
git remote add origin URL
git push -u origin main
git pull origin main
git clone URL
```

## Branches

O Git incentiva criar branches para cada funcionalidade ou correção. Fluxo típico:

1. `git checkout -b funcionalidade-x` — criar e mudar para nova branch
2. Desenvolver, `add`, `commit`
3. Voltar para `main`: `git checkout main`
4. `git merge funcionalidade-x` — incorporar o trabalho
5. `git branch -d funcionalidade-x` — apagar branch usada

## Autenticação no GitHub

- **Token pessoal clássico** — gerado em Settings > Developer Settings > Personal Access Tokens; usado como senha no lugar da senha da conta
- **Chave SSH** — par de chaves pública/privada; chave pública adicionada ao perfil do GitHub; autenticação via `ssh -T git@github.com`

## Colaboração no GitHub

- **Repositório remoto** — cópia do projeto no GitHub
- **Fork** — cópia de um repositório para sua conta
- **Pull Request** — proposta de merge de uma branch para outra; revisão de código
- **Issues** — rastreamento de bugs e tarefas
- Upload direto de arquivos via interface web do GitHub

## Relacionado

- [[02-AREAS/fiap/fase-4/fase-4-index|Fase 4 — View]]
- [[03-RESOURCES/concepts/dev-foundations/bootstrap|Bootstrap]] — mesmo módulo (frontend) da Fase 4

## Evidências
- **[2026-06-24]** Skills for Real Engineers. Straight from my .claude directory. - skills/skills/in-progress/loop-me/SKILL.md at main · ma — [[skillsskillsin-progressloop-meskill-md-at-main-4]]

- **[2026-06-24]** 所有人都在比谁的 Deep Research AI 找得更多、更快、更全。但 2026 年的 benchmark 数据告诉你一件令人意外的事：头部产品在“找信息”上已经几乎打平，真正把系统拉开的，是另一件事：谁能在推理过程中，不积累错误。一 — [[]]