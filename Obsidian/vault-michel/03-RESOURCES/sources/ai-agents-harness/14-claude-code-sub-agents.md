---
title: "14 Claude Code sub-agents I built in 60 days, 4 survived"
type: source
source: Clippings/14 Claude Code sub-agents I built in 60 days, 4 survived. The other 10 just burned tokens..md
author: "@Mnilax"
published: 2026-05-27
created: 2026-05-29
ingested: 2026-05-29
tags: [ai-agents, sub-agents, claude-code, empirical, production]
---

## Tese central

Sub-agentes Claude Code carregam ~20K tokens de overhead por spawn. Em 60 dias de testes em um repo real de 47K LOC, apenas 4 de 14 sub-agentes provaram ROI positivo. Os 4 sobreviventes compartilham três traços que os 10 mortos não tinham: responsabilidade única, contexto delimitado, e saída observável/estruturada.

## Argumentos principais

- **20K token cold start**: cada sub-agente consome ~20K tokens antes de fazer qualquer trabalho real; esse número está escondido em write-ups da comunidade, não na página de marketing da Anthropic.
- **Critério de sobrevivência**: "sobreviveu" = invocado pelo menos 4 vezes nos últimos 7 dias na marca de 60 dias. Janela de 7 dias intencional — janela de 14 dias deixava passar "móveis" (agentes que existem mas não são usados).
- **Ambiente real importa**: repo de produção messy, não sandbox. Metade dos failure modes só aparece quando o codebase é suficientemente confuso.
- **Regra do verbo único**: se você não consegue descrever o trabalho do sub-agente em uma frase com um verbo, já perdeu.
- **Wrapping de CLIs determinísticos é desperdício puro**: dep-auditor (wrapping npm audit) e type-checker (wrapping tsc) foram os maiores exemplos de ROI negativo.
- **Sub-agentes não podem coordenar**: não há suporte para sub-agentes chamarem outros sub-agentes (Anthropic não suporta); workarounds via sessão principal adicionam mais overhead do que a tarefa original.
- **Trabalho sequencial ≠ trabalho para sub-agentes**: se o passo 4 depende do passo 3, o sub-agente não tem retenção de contexto para lidar com isso.
- **Tarefas triviais são trabalho inline**: commit-formatter morreu porque a sessão principal faz isso em 1 segundo; o overhead de spawn foi 3–5 segundos por chamada.

## Key insights

**Os 4 sobreviventes:**

1. **code-reviewer** — lê diff contra main, retorna checklist markdown pass/fail contra style guide. Ferramentas: Read, Grep, Glob apenas. Modelo: Sonnet. O insight concreto que o converteu: flagrou uma unhandled rejection no dia 11 que teria chegado em produção às 4h da manhã. Após ~50 invocações, o custo de spawn de 20K foi pago. Read-only significa confiança sem verificação.

2. **doc-maintainer** — scan semanal de README, docs/, e inline doc comments; detecta drift entre código e documentação. Modelo: Haiku (barato). Escreve artifact durável em `docs-drift.md`. Mostra o caso onde o modelo é intencionalmente downgrade para economizar — Haiku cobre a tarefa.

3. **security-auditor** — scan por segredos hardcoded, SQL inseguro, CVEs em dependências. Modelo: Opus (reconhecimento de padrões sutis onde Opus supera Sonnet). Read-only, invocação agendada (não ad-hoc). Em 60 dias: 3 catches antes de merge (2 seriam capturados em PR review, o CVE não).

4. **test-runner** — executa suíte de testes, parseia falhas, retorna sumário de 200 tokens. Hard cap de 200 tokens. A matemática: 200 tokens in, 6.000 tokens saved por test run. Após ~10 runs, o overhead de 20K de spawn foi pago; após 50, lucro puro.

**Os 10 que morreram e por quê:**

- **migration-planner**: trabalho sequencial; sub-agentes perdem contexto entre passos. Cada "plano" ignorava constraints que emergiam na execução.
- **dep-auditor**: wrapping de `npm audit` (0.4s). O overhead de 20K sozinho equivale a rodar npm audit 47 vezes em sequência.
- **type-checker**: wrapping de `tsc --noEmit` (2s → 22s, 23K tokens).
- **perf-profiler**: precisava de dados de runtime reais. Sem acesso ao profiler, gerava "storytelling" em vez de análise.
- **commit-formatter**: tarefa trivial; sessão principal faz em 1s.
- **pr-summarizer**: a sessão principal já tem o contexto completo; sub-agente tem zero contexto novo para adicionar. O sumário era previsivelmente pior.
- **branch-renamer**: `git branch -m old new` + push remoto. Shell script de 4 linhas substitui completamente.
- **readme-updater**: conflitou com doc-maintainer — dois sub-agentes escrevendo no mesmo arquivo é um problema estrutural de coordenação que sub-agentes não conseguem resolver.
- **env-validator**: confirmava o que a sessão principal já sabia. 23K tokens de overhead para "parece ok".
- **deploy-checker**: precisava de sandbox para verificar; sem ela, retornava respostas probabilísticas "vibes-based" para decisões binárias de alto risco.

**Três traços dos sobreviventes:**

1. **Single responsibility**: um verbo, uma tarefa. O agente `pr-flow` (combinando code-reviewer + test-runner + pr-summarizer) morreu em 4 dias porque cada trabalho ficou pior ao ser agrupado.
2. **Bounded context**: input específico e finito (o diff, o diretório de docs, o buffer de saída de testes). "Look at the project" como input = delete now.
3. **Observable output**: schema de saída estruturado e finito. Narrativas são inverificáveis. Se você não consegue escrever o schema de output antes de construir, o sub-agente não tem razão de existir.

**Template YAML (o artefato):**
```yaml
name: <one-word>
description: Use this agent when <one sentence, action verb, specific trigger>
model: <haiku | sonnet | opus | inherit>
tools: <comma-separated, scoped tight>
```
Com seções: Role (1 frase), When invoked (3 passos), Input (exato), Output (schema + hard cap + format rules), Never.

**Checklist de 7 perguntas pré-build:**
1. Posso descrever o trabalho em uma frase com um verbo?
2. O input é delimitado?
3. Consigo escrever o schema de output antes de construir?
4. Há uma CLI determinística que já faz 80% disso?
5. A sessão principal já tem o contexto que isso precisa?
6. Esta tarefa é sequencial?
7. Eu ainda construiria isso se custasse 20K tokens por spawn?

Se #4 = sim → use a CLI. Se #5 = sim → faça inline. Se #6 = sim → não sub-agentar.

**O que não foi incluído:**
- Multi-agent orchestration: sub-agentes chamando sub-agentes não é suportado; workarounds adicionam overhead.
- Background sub-agents: sem estado persistente, o contexto do pedido é perdido quando o resultado chega.
- Cross-project agents: agentes user-level (~/.claude/agents/) derivam para genérico e perdem valor; project-level ganha para domínio específico.
- Self-improving agents: o meta-loop de leitura de sumários passados para refinar prompts não produziu melhorias reais e consumiu tokens. Melhoria manual, semanal, lendo os bad outputs é preferível.

## Exemplos e evidências

- **Repo**: TypeScript backend real, 47K LOC
- **Duração**: 60 dias
- **Metodologia**: HTTP proxy logando cada sessão Claude Code; tracking de spawn cost, round-trip latency, output usefulness, e survival
- **Taxa de sobrevivência**: 4/14 (28%)
- **code-reviewer catch day 11**: unhandled rejection 3 frames dentro de async chain — teria chegado em produção
- **security-auditor 60 dias**: 3 catches (2 capturáveis em PR review, 1 CVE que não seria)
- **test-runner ROI**: 200 tokens in vs 6.000 tokens de output bruto de testes; payback em ~10 runs
- **dep-auditor custo**: 20K tokens de overhead = custo de rodar `npm audit` 47 vezes direto
- **type-checker**: 2s (tsc) → 22s + 23K tokens (sub-agente)
- **Equipes auditadas**: deletam 60–70% dos sub-agentes na primeira passagem pelo checklist
- **pr-flow**: morreu em 4 dias; cada trabalho individual ficou pior quando agrupado

## Implicações para o vault

Confirma e aprofunda [[03-RESOURCES/concepts/agent-systems/subagent-pattern-empirical]] com dados empíricos de 60 dias. Adiciona o critério operacional crítico: **overhead de 20K tokens é o denominador de toda decisão de sub-agente**. O template YAML + checklist de 7 perguntas são artefatos diretos para uso no vault.

Contradiz a narrativa de X/Twitter de que "mais sub-agentes = mais poder". A taxa de 28% de sobrevivência com critérios rigorosos contraria o hype.

Complementa [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — habilidades (skills) são diferentes de sub-agentes; o artigo foca especificamente em sub-agentes como contextos separados.

## Links

- [[03-RESOURCES/concepts/agent-systems/subagent-pattern-empirical]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/agent-systems/token-economy]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/entities/Claude Code]]
