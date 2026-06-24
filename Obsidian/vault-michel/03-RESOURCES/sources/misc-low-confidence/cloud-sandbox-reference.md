---
title: Cloud sandbox reference
type: source
source: "Clippings/Cloud sandbox reference.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, managed-agents, sandboxes, infrastructure]
---

## Tese central
Página de referência técnica que documenta exatamente o que vem **pré-instalado** dentro de um sandbox `cloud` do sistema Claude Managed Agents (`managed-agents-2026-04-01` beta) — linguagens, bancos de dados, utilitários e especificações de hardware/SO. É o complemento factual de [[03-RESOURCES/sources/cloud-environment-setup]]: enquanto aquela define *como configurar* o environment, esta define *o que já está lá* sem nenhum passo de instalação.

## Argumentos principais
- **Natureza do sandbox:** containers Linux isolados rodando em infraestrutura gerenciada pela Anthropic; vêm com um conjunto abrangente de linguagens, bancos e utilitários — o agente pode usá-los **imediatamente, sem instalação**.
- **Escopo da especificação:** aplica-se apenas a environments `type: cloud`. Sandboxes self-hosted rodam na infraestrutura do próprio usuário "com o que o worker fornecer" — ou seja, sem garantias de pré-instalação.
- **Linguagens de programação pré-instaladas (com versão mínima e gerenciador):**
  - Python 3.12+ (pip, uv)
  - Node.js 20+ (npm, yarn, pnpm)
  - Go 1.22+ (go modules)
  - Rust 1.77+ (cargo)
  - Java 21+ (maven, gradle)
  - Ruby 3.3+ (bundler, gem)
  - PHP 8.3+ (composer)
  - C/C++ GCC 13+ (make, cmake)
- **Bancos de dados:** SQLite (totalmente disponível para uso local, pré-instalado), cliente PostgreSQL (`psql` — apenas cliente, para conectar a instâncias externas), cliente Redis (`redis-cli` — idem). **Servidores de banco não rodam no sandbox por padrão**; apenas clientes para conexão externa.
- **Utilitários de sistema:** `git`, `curl`/`wget`, `jq`, `tar`/`zip`/`unzip`, `ssh`/`scp` (requer rede habilitada), `tmux`/`screen`.
- **Ferramentas de desenvolvimento:** `make`/`cmake`, `docker` (disponibilidade limitada), `ripgrep` (`rg`), `tree`, `htop`.
- **Processamento de texto:** `sed`/`awk`/`grep`, `vim`/`nano`, `diff`/`patch`.
- **Especificações de hardware/SO do sandbox:**
  | Propriedade | Valor |
  |---|---|
  | Sistema operacional | Ubuntu 22.04 LTS |
  | Arquitetura | x86_64 (amd64) |
  | Memória | até 8 GB |
  | Disco | até 10 GB |
  | Rede | desabilitada por padrão (habilitar via config do environment) |

## Key insights
- "Rede desabilitada por padrão" aqui é a contraparte runtime do parâmetro `networking` documentado em [[03-RESOURCES/sources/cloud-environment-setup]] — confirma que o estado de fábrica do sandbox é hermético, e que `unrestricted`/`limited` são opt-ins explícitos no nível do environment.
- A presença de clientes de banco (psql, redis-cli) mas não de servidores revela um padrão de design: o sandbox é pensado como *cliente leve que se conecta a infraestrutura externa*, não como um ambiente de hospedagem completo — exceto SQLite, que é o único banco "full local".
- Limites de hardware modestos (8 GB RAM / 10 GB disco) implicam que workloads de dados pesados (ex. datasets grandes, builds massivos) provavelmente exigem self-hosted sandboxes ou ferramentas externas via Files API.
- A disponibilidade "limitada" do Docker dentro de um container já isolado sugere alguma forma de aninhamento controlado (provavelmente rootless ou sysbox-style), mas a doc não detalha — ponto de atenção para quem planeja workflows de containerização dentro do agente.
- O conjunto de ferramentas (ripgrep, tmux, vim, jq, git) espelha de perto o toolkit que um desenvolvedor humano experiente usaria em um terminal — reforça que o design do sandbox visa paridade com um ambiente de dev humano, não um runtime de execução minimalista.

## Exemplos e evidências
- Tabela de linguagens com versões mínimas concretas: Python 3.12+, Node 20+, Go 1.22+, Rust 1.77+, Java 21+, Ruby 3.3+, PHP 8.3+, GCC 13+.
- Especificação de hardware explícita: até 8 GB de memória, até 10 GB de disco, Ubuntu 22.04 LTS, x86_64.
- Lista nominal de utilitários por categoria (sistema, desenvolvimento, processamento de texto) com binários exatos (`git`, `curl`, `wget`, `jq`, `tar`, `zip`, `unzip`, `ssh`, `scp`, `tmux`, `screen`, `make`, `cmake`, `docker`, `rg`, `tree`, `htop`, `sed`, `awk`, `grep`, `vim`, `nano`, `diff`, `patch`).

## Implicações para o vault
Funciona como o "manual de bordo" do runtime configurado em [[03-RESOURCES/sources/cloud-environment-setup]] — as duas páginas descrevem o mesmo sandbox de ângulos complementares (configuração vs. conteúdo pré-instalado) e devem ser lidas em conjunto. Conecta-se a [[03-RESOURCES/sources/claude-platform-on-aws]], que cita "code execution in Anthropic's managed sandbox" como recurso disponível via AWS — provavelmente o mesmo runtime aqui descrito. As limitações de hardware (8GB/10GB) e a ausência de servidores de banco tornam relevante o fluxo de injeção de dados externos via [[03-RESOURCES/sources/adding-files]] e [[03-RESOURCES/sources/files-api]]. Alimenta o conceito [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] (o sandbox como camada de execução isolada e padronizada) e é candidato a fonte do novo conceito `managed-agents-harness` — ver relatório.

## Links
- [[03-RESOURCES/sources/cloud-environment-setup]]
- [[03-RESOURCES/sources/claude-platform-on-aws]]
- [[03-RESOURCES/sources/adding-files]]
- [[03-RESOURCES/sources/files-api]]
- [[03-RESOURCES/sources/accessing-github]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
- [[03-RESOURCES/sources/ai-agents-harness/claude-managed-agents-beginners-guide]]
