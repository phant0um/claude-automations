---
title: How To Use Loop Engineering To Build A Self-Improving Quant Trading System
type: source
source: Clippings/How To Use Loop Engineering To Build A Self-Improving Quant Trading System.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Loop engineering — escrever sistemas que disparam, verificam e re-disparam chamadas a um LLM sem intervenção humana contínua — é o que separa quants solo de funds com centenas de PhDs. Trading quantitativo já é, por natureza, um loop (pull data → sinal → backtest → executar → monitorar risco); a diferença entre uma fund institucional e um builder solo não é o capital, é se existe um humano dentro do loop decidindo cada passo ou um sistema que decide por si.

## Argumentos principais
- **Prompting ≠ Loop Engineering**: prompting é você dentro do loop (digita, lê, decide, repete). Loop engineering é você arquitetando o loop que faz isso por você. Boris Cherny (head Claude Code, Anthropic): "I don't prompt Claude anymore. I have loops running that prompt Claude and figuring out what to do. My job is to write loops."
- **Seis peças universais de todo loop funcional em produção** (faltar uma quebra o loop silenciosamente):
  1. **Automação** — heartbeat: cron, webhook, `/loop` (cadência fixa) ou `/goal` (continua até condição verificável ser verdadeira, com modelo pequeno separado julgando se terminou)
  2. **Skill** — arquivo `SKILL.md` com convenções e regras; sem skills, todo run começa do zero; com skills, intenção compõe (compounding)
  3. **State file** — markdown (`STATE.md`/`PROGRESS.md`) que sobrevive entre runs; o agente esquece, o arquivo não
  4. **Verifier** — agente separado, idealmente modelo diferente, cujo único trabalho é validar o output do agente gerador (maker-checker pattern, usado em toda prop shop de Wall Street: quem propõe não aprova)
  5. **Worktrees** — git worktrees isolam múltiplos agentes rodando contra os mesmos arquivos em branches próprios, evitando colisão
  6. **Connectors (MCP)** — sem eles o loop só lê arquivos; com eles o loop atinge broker API, banco de dados, Slack, ordens de exchange — diferença entre um loop que sugere trades e um que executa
- **Sistema de trading com 5 estágios, cada um seu próprio sub-loop** com skill, state file e verifier dedicados: (1) ingestão de dados, (2) geração de sinal (alpha research via skill), (3) verificação (modelo/instruções diferentes, sem exposição ao raciocínio original), (4) execução (implícito), (5) memória/aprendizado.
- **O que torna o sistema "self-improving"**: cada perda real escreve uma nova lição na skill (`alpha_research_skill.md`), que se torna uma nova regra para o próximo run. O skill cresce com o tempo; o sistema não repete o mesmo erro.

## Key insights
- O menor capital é exatamente quem mais precisa de loop engineering — é a única forma de um builder solo fechar o gap com uma fund de 100 PhDs.
- O agente que gerou o sinal é o pior juiz possível de se o sinal é alpha real ou ruído — paralelo direto ao código: quem escreveu não deve validar.
- O `/loop` é cadência fixa (rerun independente de estado); o `/goal` é condição-driven (continua até critério mensurável ser satisfeito, julgado por modelo separado). Mapeamento direto: `/loop` = data pull a cada minuto; `/goal` = "continue iterando no sinal até Sharpe do backtest > 1.5".
- Regras de verificação de backtest citadas como exemplo concreto: Sharpe > 1.5, drawdown máximo < 10%, Newey-West t-stat > 2.0, período out-of-sample de pelo menos 2 anos.

## Exemplos e evidências
- Código Python ilustrativo de 3 estágios: `ingest_data()` (loop a cada hora, escreve em `state.write`), `generate_signal()` (trigger por `data_updated`, chama `claude.run_skill("alpha_research", data)`), `verify_signal()` (decorator `@checker`, modelo/instruções diferentes).
- Exemplo de skill que aprende com perdas reais (`alpha_research_skill.md`): regra "skip signals on FOMC announcement days" nasceu de perda de 4.2% em earnings week (2026-02-14); cap de exposição setorial em 30% nasceu de drawdown de 6% por breach setorial (2026-03-08); kill de sinais momentum em dias FOMC nasceu de blowup em 2026-04-22.
- Comparação institucional: Renaissance roda esse ciclo desde 1988; Citadel roda com equipes monitorando cada estágio; Two Sigma e Jane Street operam de forma equivalente — só que com centenas de humanos dentro do loop, não um sistema autônomo.

## Implicações para o vault
Confirma e aprofunda o padrão já mapeado em `agent-loop-design`, `agent-loop`, `the-agent-loop-architecture` (sources existentes em loop engineering) com aplicação concreta a trading quantitativo — domínio ainda fraco no vault (`03-RESOURCES/concepts/finance-trading/` tem só 6 conceitos). O padrão maker-checker (verifier dedicado, modelo diferente) reforça `[[03-RESOURCES/concepts/agent-systems/agent-trust-layer]]` e a lógica de generator-verifier já presente em `llm-ml-foundations/generator-verifier-loop.md` e `agent-systems/generator-verifier-loop.md` — esta source aplica o padrão especificamente ao domínio financeiro, fechando uma lacuna.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-loop]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/llm-ml-foundations/generator-verifier-loop]]
- [[03-RESOURCES/concepts/dev-foundations/git-worktrees-agent-parallelism]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/finance-trading/algorithmic-trading]]
