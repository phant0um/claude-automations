---
title: "Background Coding Agents: Predictable Results Through Strong Feedback Loops (Honk, Part 3)"
type: source
source: "Clippings/Background Coding Agents Predictable Results Through Strong Feedback Loops (Honk, Part 3).md"
url: "https://engineering.atspotify.com/2025/12/feedback-loops-background-coding-agents-part-3"
authors:
  - Max Charas (Senior Staff Engineer)
  - Marc Bruggmann (Principal Engineer)
org: Spotify
series: Honk
part: 3
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, feedback-loops, spotify, honk, coding-agents, reliability, verification, harness-engineering]
---

## Tese central

Agentes de codificação autônomos produzem resultados corretos e confiáveis quando o ambiente em torno deles implementa **strong feedback loops** — ciclos de verificação que guiam o agente iterativamente antes de qualquer PR ser aberto, sem que o agente precise entender os detalhes internos de cada verificador.

## Argumentos principais

### 1. Três modos primários de falha

| # | Falha | Gravidade | Impacto |
|---|-------|-----------|---------|
| 1 | Agente não produz PR | Baixa | Annoying; pode ser feito manualmente |
| 2 | PR produzido mas quebra CI | Média | Frustrante; engenheiro decide se conserta |
| 3 | PR passa CI mas é funcionalmente incorreto | Alta | **Corrói a confiança**; difícil de detectar em review de escala |

O modo 3 é o mais crítico: em milhares de componentes, PRs sutilmente incorretos que passam CI podem chegar a produção sem serem detectados.

### 2. Verification loops — como funcionam

Spotify implementou um ciclo de verificação composto por **verificadores independentes** ativados automaticamente conforme o conteúdo do repositório (ex: Maven verifier ativa se encontra `pom.xml`).

**Design key:** O agente *não sabe o que os verificadores fazem*, só sabe que pode (e em alguns casos deve) chamá-los. A abstração acontece na camada MCP — o agente recebe um único tool de verificação.

Benefícios:
- **Feedback incremental:** agente confirma que está no caminho certo antes de commitar
- **Context window preservation:** o agente não precisa parsear saídas brutas de build systems — os verificadores filtram o ruído via regex e retornam mensagens curtas e relevantes

Os verificadores rodam também como **stop hook** (no caso de Claude Code), impedindo que um PR seja aberto se qualquer verificador falhar.

### 3. LLM-as-judge — camada adicional

Além dos verificadores determinísticos (build, test, format), Spotify adicionou um **LLM judge** para controlar ambição excessiva do agente:

- Input: diff da mudança proposta + prompt original
- Função: avaliar se o agente saiu do escopo (refactoring não solicitado, desabilitar testes flaky, etc.)
- Resultado: ~25% das sessões são vetadas pelo judge; em metade desses casos o agente consegue se corrigir

> Sem evals formais para o judge ainda, mas métricas internas mostram que o trigger mais comum é o agente ultrapassando o escopo do prompt.

### 4. Sandboxing e foco do agente

O agente Honk é intencionalmente restrito:
- Acesso limitado: codebase relevante + file editing tools + verifiers
- Ações externas (push, Slack, authoring de prompts) são gerenciadas pela infraestrutura externa
- Executa em container com permissões mínimas, poucos binários, sem acesso a sistemas adjacentes

**Princípio:** reduced flexibility = more predictability. O sandboxing tem efeito secundário positivo em segurança.

## Key insights

1. **Abstração no nível do MCP tool é fundamental.** O agente nunca vê um "Maven verifier" — vê apenas `verify_changes`. Isso mantém o contexto limpo e o agente agnóstico ao stack do componente.

2. **Output parsing dos verificadores é impactante mas tedioso.** Muitos verificadores usam regex para extrair só as mensagens de erro mais relevantes. Esse detalhe operacional faz diferença enorme na qualidade do feedback.

3. **Inner loop vs outer loop.** Os verifiers são o *inner loop* (fast feedback local). A próxima etapa planejada é integrar CI/CD do GitHub como *outer loop* complementar — mais lento mas com cobertura mais ampla.

4. **Sem feedback loops, agentes frequentemente produzem código que simplesmente não funciona.** A citação direta da equipe: *"Without these feedback loops, the agents often produce code that simply doesn't work."*

5. **Evals estruturadas são a próxima lacuna.** A equipe ainda não tem evals robustas para o judge nem para mudanças de system prompt — identificado como próxima área de investimento.

## Exemplos e evidências

- Fleet Management da Spotify roda agentes sobre **milhares de componentes** de software
- O LLM judge veta ~**25%** das sessões; o agente se corrige em ~**50%** desses casos
- Verifiers atuais rodam apenas em Linux x86; roadmap inclui macOS (iOS apps) e ARM64

## Implicações para o vault

- Reforça e adiciona profundidade ao conceito [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]: a implementação Honk é um caso concreto de produção com LLM judge + deterministic verifiers em camadas
- Apoia [[03-RESOURCES/concepts/agent-systems/harness-engineering]]: o sandboxing e a abstração MCP são padrões de harness engineering em escala real
- O stop hook pattern (Claude Code hooks para bloquear PR) é aplicação concreta de [[03-RESOURCES/concepts/agent-systems/agent-hooks-deterministic-control]] — se existir
- O "inner loop vs outer loop" de CI/CD sugere extensão para [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]

## Links

- Série Honk: [[03-RESOURCES/sources/spotify-honk-part2-context-engineering]] (Part 2)
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
