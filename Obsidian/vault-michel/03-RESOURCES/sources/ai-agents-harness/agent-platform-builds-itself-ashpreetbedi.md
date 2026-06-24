---
title: "Agent Platform That Builds Itself"
type: source
source_file: Clippings/Agent Platform That Builds Itself.md
origin: thread X
author: "@ashpreetbedi"
ingested: 2026-05-14
tags: [agent-platform, auto-improvement, agno, claude-code, devops, self-improving-software]
triagem_score: 8
---

# Agent Platform That Builds Itself

> [!key-insight] Insight principal
> Uma plataforma de agents que o próprio Claude Code constrói, gerencia e melhora — 5 prompts cobrem todo o ciclo de vida do desenvolvimento de agents (Create/Improve/Extend/Hill Climb/Review).

## Content summary

### O que é uma agent platform

A plataforma de agents é o "OS" que roda seus agents: recebe requests, executa o loop do agent, faz streaming de respostas, gera logs, gerencia auth e isolamento entre agents.

### 5 partes da plataforma

| Parte | Responsabilidade |
|-------|-----------------|
| **Runtime** | loop do agent, streaming, storage, auth |
| **Storage** | sessões, memória, conhecimento, traces, histórico de evals (Postgres) |
| **Connectors** | ferramentas de conexão com sistemas externos via MCP/API/CLI |
| **Interfaces** | Slack, Discord, Telegram, UIs customizadas |
| **Infrastructure** | Docker local, Railway produção |

### 5 prompts do ciclo de vida

| Prompt | O que faz |
|--------|-----------|
| **Create** (`create-new-agent.md`) | Scaffolda novo agent: perguntas → busca Agno docs MCP → gera arquivo → registra em app/main.py → smoke-test. 5-10 min. |
| **Improve** (`improve-agent.md`) | Lê INSTRUCTIONS, deriva 8-12 probes (golden-path, edge cases, adversariais), testa via cURL, PASS/FAIL, edita, hot-reload, roda novamente. Zero input humano. |
| **Extend** (`extend-agent.md`) | Adiciona capability com guia humano; Agno docs MCP garante que toolkit research é grounded. |
| **Hill Climb** (`eval-and-improve.md`) | Roda suite de evals, diagnostica cada falha, corrige o que está no scope. Loop de 5 rounds max. |
| **Review** (`review-and-improve.md`) | Varre repo por drift docs/code/config. Corrige mecanicamente o que pode; flags o resto. |

### Por que agent platforms funcionam para auto-improvement

1. Cada ação é exposta como API (cURL/bash)
2. Dados colocalizados — sessões e traces no mesmo Postgres
3. Logs em tempo real via Docker — loop de feedback ~5s

### Infraestrutura

```bash
git clone https://github.com/agno-agi/agent-platform-railway.git
docker compose up -d --build
# UI: os.agno.com conectado a localhost:8000
# Deploy produção: ./scripts/railway/up.sh
```

## Por que a plataforma como loop fechado muda tudo

Em sistemas de software convencionais, o ciclo de iteração envolve humanos em múltiplos pontos: dev escreve código → testa manualmente ou em CI → interpreta resultado → decide o que mudar. A plataforma de agents colapsa esse ciclo porque:

1. O "dev" (Claude Code) pode chamar a API que roda o agent diretamente
2. O resultado do test (PASS/FAIL + trace) está no mesmo Postgres que o agent pode ler
3. O log em tempo real está disponível via Docker sem ferramentas externas

O loop `test → ler resultado → editar → hot-reload → testar novamente` corre em ~5 segundos. Nenhum humano em nenhum passo.

## O prompt Improve em detalhe

O prompt `improve-agent.md` segue uma sequência não-óbvia:

1. **Lê INSTRUCTIONS** do agente atual — não assume que sabe o que o agente faz
2. **Deriva 8-12 probes** de três categorias:
   - Golden-path: o caso de uso principal que deve sempre funcionar
   - Edge cases: inputs que o agente pode não ter sido projetado para lidar
   - Adversariais: inputs que tentam fazer o agente sair do escopo
3. **Testa via cURL** — cada probe como request HTTP ao agent endpoint
4. **Classifica PASS/FAIL com raciocínio** — não apenas o resultado, mas por que falhou
5. **Edita o arquivo do agente** — modifica INSTRUCTIONS ou prompt diretamente
6. **Hot-reload** — sem restart da plataforma
7. **Re-roda os probes** — confirma que os que passavam ainda passam (regressão) e os que falhavam agora passam

Zero input humano do passo 2 ao 7.

## Hill Climb vs Improve: a diferença operacional

| Dimensão | Improve | Hill Climb |
|---|---|---|
| Foco | Falhas out-of-distribution (novos casos) | Falhas in-distribution (regressões) |
| Input | Comportamento observado em produção | Suite de evals existente |
| Trigger | Após identificar novo edge case | Após qualquer mudança no agente |
| Rounds | Ilimitado (capped 5 para evitar drift) | 5 rounds max |

Os dois trabalham melhor em alternância: Improve descobre novos casos que entram no eval suite do Hill Climb, que garante que os casos antigos não regridem enquanto Improve adiciona capabilities.

## Limitações da abordagem

**Dependência de testabilidade via API**: agentes cujos outputs são difíceis de avaliar programaticamente (respostas criativas, análises qualitativas) são mais difíceis de incluir no loop automático. O loop funciona melhor quando há critério de PASS/FAIL determinístico.

**Risco de otimização métrica**: Hill Climb em 5 rounds com critério específico pode fazer o agente otimizar para o critério em detrimento de comportamentos que o critério não cobre. Análogo ao Goodhart's Law — quando uma medida se torna objetivo, deixa de ser boa medida.

**Escopo do Improve**: o prompt limita mudanças ao que está "no scope" (INSTRUCTIONS e prompt do agente). Mudanças arquiteturais — adicionar nova ferramenta, mudar o modelo base, dividir o agente em dois — requerem intervenção humana.

## Conexões

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — especialização de roles (runtime, QA, reviewer)
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — pattern de auto-improvement via Hill Climb
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] — evals como feedback loop
- [[03-RESOURCES/entities/Agno]] — framework subjacente (ver também Auto-Improving Software)
- [[03-RESOURCES/sources/ai-agents-harness/auto-improving-software-ashpreetbedi]] — artigo companion com mais detalhe de design
