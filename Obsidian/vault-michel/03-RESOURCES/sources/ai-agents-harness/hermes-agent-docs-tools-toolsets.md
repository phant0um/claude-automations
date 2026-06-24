---
title: "Hermes Agent Docs: Tools & Toolsets"
type: source
source: "Hermes Agent official docs — Tools & Toolsets"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

# Hermes Agent Docs: Tools & Toolsets

## Tese central

Tools são funções que estendem as capacidades do agente, organizadas em **toolsets** habilitáveis/desabilitáveis por plataforma. O terminal, em particular, suporta múltiplos backends (local, Docker, SSH, Singularity, Modal, Daytona) que trocam isolamento/segurança por conveniência, com gestão de processos em background e hardening de container documentados explicitamente.

## Argumentos principais

### Categorias de alto nível

| Categoria | Exemplos | Descrição |
| --- | --- | --- |
| Web | `web_search`, `web_extract` | busca e extração de páginas |
| X Search | `x_search` | busca em X/Twitter via xAI Responses tool — gated em credenciais xAI (SuperGrok OAuth ou `XAI_API_KEY`), off por default |
| Terminal & Files | `terminal`, `process`, `read_file`, `patch` | execução de comandos e manipulação de arquivos |
| Browser | `browser_navigate`, `browser_snapshot`, `browser_vision` | automação interativa com texto e visão |
| Media | `vision_analyze`, `image_generate`, `text_to_speech` | análise e geração multimodal |
| Agent orchestration | `todo`, `clarify`, `execute_code`, `delegate_task` | planejamento, clarificação, execução de código, subagentes |
| Memory & recall | `memory`, `session_search` | memória persistente e busca em sessões |
| Automation & delivery | `cronjob`, `send_message` | tarefas agendadas (create/list/update/pause/resume/run/remove) + mensageria outbound |
| Integrations | `ha_*`, MCP server tools | Home Assistant, MCP, etc |

Nota: **Honcho cross-session memory** é plugin de memória (`plugins/memory/honcho/`), não toolset built-in.

### Nous Tool Gateway

Assinantes pagos do [Nous Portal](https://portal.nousresearch.com/) acessam web search, image generation, TTS e browser automation via **Tool Gateway** sem API keys separadas. `hermes model` habilita; `hermes tools` configura individualmente.

### Comandos

```bash
hermes chat --toolsets "web,terminal"
hermes tools    # lista tools disponíveis / configura por plataforma
```

Toolsets comuns: `web`, `search`, `terminal`, `file`, `browser`, `vision`, `image_gen`, `moa`, `skills`, `tts`, `todo`, `memory`, `session_search`, `cronjob`, `code_execution`, `delegation`, `clarify`, `homeassistant`, `messaging`, `spotify`, `discord`, `discord_admin`, `debugging`, `safe`. Presets de plataforma: `hermes-cli`, `hermes-telegram`. MCP toolsets dinâmicos: `mcp-<server>`.

### Terminal backends

| Backend | Descrição | Uso |
| --- | --- | --- |
| `local` | máquina local (default) | dev, tarefas confiáveis |
| `docker` | containers isolados | segurança, reprodutibilidade |
| `ssh` | servidor remoto | sandboxing, agente longe do próprio código |
| `singularity` | containers HPC | cluster computing, rootless |
| `modal` | execução cloud | serverless, escala |
| `daytona` | cloud sandbox workspace | dev environments persistentes |

```yaml
# ~/.hermes/config.yaml
terminal:
  backend: local    # ou: docker, ssh, singularity, modal, daytona
  cwd: "."
  timeout: 180
```

### Docker backend — container persistente único

```yaml
terminal:
  backend: docker
  docker_image: python:3.11-slim
```

Hermes inicia **um único container long-lived** no primeiro uso (`docker run -d ... sleep 2h`), roteando todo terminal/file/`execute_code` via `docker exec` nesse mesmo container. Mudanças de cwd, pacotes instalados, env tweaks e arquivos em `/workspace` persistem entre tool calls, `/new`, `/reset` e subagentes `delegate_task`, durante toda a vida do processo Hermes. Container é parado/removido no shutdown — comporta-se como sandbox VM persistente, não container fresco por comando.

### SSH backend (recomendado para segurança)

```yaml
terminal:
  backend: ssh
```
```bash
# ~/.hermes/.env
TERMINAL_SSH_HOST=my-server.example.com
TERMINAL_SSH_USER=myuser
TERMINAL_SSH_KEY=~/.ssh/id_rsa
```

Agente não pode modificar o próprio código.

### Singularity / Modal

```bash
apptainer build ~/python.sif docker://python:3.11-slim
hermes config set terminal.backend singularity
hermes config set terminal.singularity_image ~/python.sif

uv pip install modal && modal setup
hermes config set terminal.backend modal
```

### Container resources

```yaml
terminal:
  backend: docker  # ou singularity, modal, daytona
  container_cpu: 1
  container_memory: 5120        # MB, default 5GB
  container_disk: 51200         # MB, default 50GB
  container_persistent: true    # default true — sobrevive entre sessões
```

### Container security

Read-only root filesystem (Docker), todas as Linux capabilities dropped, sem privilege escalation, PID limit 256, full namespace isolation, workspace persistente via volumes (não writable root layer). `terminal.docker_forward_env` permite allowlist explícita de env vars (visíveis dentro do container).

### Background process management

```python
terminal(command="pytest -v tests/", background=true)
# → {"session_id": "proc_abc123", "pid": 12345}

process(action="list")
process(action="poll", session_id="proc_abc123")
process(action="wait", session_id="proc_abc123")
process(action="log", session_id="proc_abc123")
process(action="kill", session_id="proc_abc123")
process(action="write", session_id="proc_abc123", data="y")
```

PTY mode (`pty=true`) habilita CLIs interativas como Codex e Claude Code.

### Sudo support

Comandos com sudo prompt por senha (cached na sessão) ou `SUDO_PASSWORD` em `~/.hermes/.env`. Em mensageria, falha de sudo inclui dica para configurar `SUDO_PASSWORD`.

## Key insights

- O container Docker persistente (um único container long-lived, não fresh-per-command) é uma escolha de design deliberada para preservar estado entre tool calls — trade-off explícito entre isolamento por comando e continuidade de ambiente.
- Hardening de container documentado em detalhe (read-only root FS, capabilities dropped, PID limit, namespace isolation) torna o backend Docker auditável, não apenas "mais seguro" genericamente.
- O backend SSH é o único que estruturalmente impede o agente de modificar o próprio código (execução acontece em máquina remota separada) — útil como modelo de "agente não pode autoeditar seu runtime".
- Background process management via `process(action=...)` com PTY mode permite rodar CLIs interativas (Codex, Claude Code) dentro do próprio Hermes — orquestração de agente sobre agente.

## Exemplos e evidências

Ver blocos de código YAML/bash/python acima — preservados integralmente (todos os configs de terminal backend, comandos de process management, env vars).

## Implicações para o vault

Não há um equivalente documentado no setup atual deste vault para múltiplos terminal backends (Docker/SSH/Singularity/Modal/Daytona) — Claude Code roda tipicamente local. O padrão de container persistente único + `docker_forward_env` allowlist pode ser referência útil caso o vault evolua para rodar agentes em sandbox isolado. A tabela de toolsets é um bom ponto de comparação para mapear quais toolsets equivalentes (web, terminal, memory, delegation) já existem via MCP servers neste ambiente.

## Links

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/tool-use-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]]
