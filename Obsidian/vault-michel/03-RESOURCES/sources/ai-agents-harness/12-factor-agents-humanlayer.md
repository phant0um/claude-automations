---
title: "12-Factor Agents — Principles for Building Reliable LLM Applications"
type: source
created: 2026-05-18
updated: 2026-05-18
tags: [ai-agents, agent-architecture, production-agents, context-engineering]
source_url: "https://github.com/humanlayer/12-factor-agents"
author: "Dex (humanlayer)"
category: ai-agents
triagem_score: 10
---

## Tese central

As melhores aplicações LLM em produção são fundamentalmente software determinístico com passos de LLM inseridos cirurgicamente — não loops "bag-of-tools". Os 12 fatores estabelecem princípios de engenharia para tornar agentes confiáveis, escaláveis e manuteníveis independentemente de quão poderosos os LLMs se tornem.

## Key insights

1. **Agentes bons não são loops ingênuos.** O padrão "prompt + bag of tools + loop until done" não funciona em produção. Agentes reais são majoritariamente código determinístico com LLM nos pontos certos.
2. **Os 12 fatores:**
   - F1: Natural Language → Tool Calls (LLM como tradutor de intenção)
   - F2: Own your prompts (não delegar prompts a frameworks)
   - F3: Own your context window ([[03-RESOURCES/concepts/llm-ml-foundations/context-window]])
   - F4: Tools are just structured outputs
   - F5: Unify execution state and business state
   - F6: Launch/Pause/Resume with simple APIs
   - F7: Contact humans with tool calls ([[03-RESOURCES/concepts/human-in-the-loop]])
   - F8: Own your control flow
   - F9: Compact errors into context window
   - F10: Small, focused agents
   - F11: Trigger from anywhere
   - F12: Make your agent a stateless reducer
3. **Frameworks não sobrevivem à produção.** Fundadores fortes constroem a stack eles mesmos. LangChain, LangGraph, etc. somem quando o produto enfrenta clientes reais.
4. **Agente como reducer stateless** é o padrão mais robusto: `(state, event) → new_state + actions`.
5. **Context engineering** (F3) é o diferencial mais crítico — o que entra no contexto determina tudo.

## Detalhamento dos fatores críticos

### F2 — Own your prompts
Frameworks como LangChain abstraem prompts em templates que o desenvolvedor não controla. Quando o modelo se comporta de forma inesperada, não há como inspecionar o prompt real que foi enviado. A diretriz é manter prompts como strings literais no código — version-controlled, testáveis, inspecionáveis.

### F3 — Own your context window
Context engineering é o diferencial mais crítico na prática. Cada token no contexto tem custo (dinheiro, latência, atenção do modelo). Um agente que injeta todo o histórico de sessão em cada turn desperdiça recursos e degrada qualidade. Gerenciar o contexto ativamente — o que entra, em que ordem, o que é descartado — é a habilidade mais escassa em equipes de produto.

### F4 — Tools are just structured outputs
Desmistifica o "tool calling" dos frameworks: ferramentas são simplesmente outputs estruturados (JSON) que o código determinístico interpreta e executa. Não há magia — o LLM produz `{"tool": "search", "query": "..."}` e código Python/Go/Rust chama a função real. Essa clareza permite inspecionar, testar e mockar cada passo.

### F8 — Own your control flow
O pattern "bag of tools + loop" passa o controle de fluxo inteiramente para o modelo. Em produção, isso cria comportamentos não-determinísticos difíceis de debugar. Agentes confiáveis têm grafos de controle explícitos: o código determina quais estados são possíveis, o LLM decide dentro de cada estado.

### F12 — Make your agent a stateless reducer
O padrão `(state, event) → new_state + actions` é o mais testável e escalável. O agente não mantém estado interno — todo o estado está no input. Isso torna cada step independente: replayável, testável em isolamento, tolerante a falhas (restart do step sem perda).

## Por que frameworks não sobrevivem à produção

O argumento do 12-Factor não é que frameworks são ruins — é que eles otimizam para início rápido, não para manutenção. Quando um agente enfrenta um cliente real com edge cases reais, as abstrações do framework se tornam camadas opacas que dificultam debugging. Fundadores que constroem a stack eles mesmos entendem cada camada e podem corrigir problemas sem esperar o mantenedor do framework.

## Comparação com 12-Factor App (2011)

O 12-Factor App de Heroku (2011) estabeleceu princípios para apps web escaláveis (codebase, dependencies, config, processes, etc.). O 12-Factor Agents segue a mesma filosofia de tornar sistemas previsíveis e manuteníveis, mas adapta para o contexto de LLMs: contexto como recurso gerenciado, tools como contratos, estado como redutor, humans como ferramenta (F7).

## Aplicação no vault-michel

O vault opera com múltiplos agentes especializados (guard, hill, review, spec, extend, verify, ingest-report). Os fatores F10 (small, focused agents) e F12 (stateless reducer) são os mais diretamente aplicáveis: cada agente do vault deve ter escopo estritamente delimitado no CLAUDE.md do agente, e o estado deve estar em arquivos do vault, não na memória implícita do agente.

F7 (Contact humans with tool calls) mapeia para o padrão confirm-before do CLAUDE.md do vault: operações destrutivas ou fora de escopo devem expor a decisão ao operador humano via output explícito, não executar silenciosamente.

## Links

- GitHub: https://github.com/humanlayer/12-factor-agents
- Talk: https://www.youtube.com/watch?v=8kMaTybvDUw
- Relacionado: [[03-RESOURCES/concepts/agent-systems/agent-architecture]], [[03-RESOURCES/concepts/llm-ml-foundations/context-window]], [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
