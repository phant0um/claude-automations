---
title: "Beyond Individual Intelligence: Survey on Multi-Agent Systems"
type: source
source: Clippings/Beyond Individual Intelligence- Survey- ing Collaboration, Failure Attribution, and Self- Evolution in LLM-based Multi-Agent Systems.md
created: 2026-05-17
ingested: 2026-05-17
tags: [ai-agents, research, multi-agent, survey]
triagem_score: 10
---

## Tese central
Inteligência multi-agente em LLMs emerge de três eixos: colaboração estruturada (como agentes comunicam e coordenam), failure attribution (identificar qual agente causou falha em cadeia), e self-evolution (sistemas que reconfiguram suas próprias topologias baseado em performance). Survey cobre state-of-art 2024-2026.

## Key insights
- **Failure attribution é gargalo crítico:** em pipeline de N agentes, quando output final é errado, identificar o agente responsável requer rastreabilidade de decisão end-to-end. Sem isso, debug é heurístico e caro
- **Self-evolution de topologia:** sistemas que monitoram performance por subtarefa e dinamicamente realocam agentes (adicionar, remover, reconfigurar) — topologia adaptativa vs topologia fixa
- **Colaboração estruturada ≠ comunicação livre:** agentes com protocolo explícito de handoff superam agentes com comunicação em linguagem natural livre — estrutura reduz ruído e ambiguidade inter-agente
- **Survey completo:** taxonomia de 50+ papers em LLM-based MAS, com categorização por paradigma de comunicação, estrutura topológica, e mecanismo de aprendizado coletivo

## Eixo 1: Colaboração estruturada

### Paradigmas de comunicação
- **Message-passing:** agentes trocam mensagens estruturadas com schema definido — baixo acoplamento, alta rastreabilidade
- **Shared memory:** agentes leem/escrevem em estado compartilhado (blackboard pattern) — alto throughput, risco de conflito
- **Role-based:** cada agente tem papel fixo com interface explícita — simplicidade, mas rigidez

### Topologias
- **Pipeline linear:** A → B → C — simples, mas falha se qualquer elo falha
- **Hierárquica:** orquestrador → workers — boa para delegação, bottleneck no orquestrador
- **Mesh/peer:** todos comunicam com todos — resiliência máxima, custo de coordenação máximo
- **Híbrida:** hierárquica com comunicação lateral entre workers — equilíbrio prático

## Eixo 2: Failure Attribution

### Por que é difícil

Em pipeline de 5 agentes, output errado pode originar de:
- Agente 1 produziu dado incorreto
- Agente 3 interpretou dado correto errado
- Agente 5 formatou resultado certo errado

Sem logging estruturado de decisões intermediárias, rastrear causa raiz requer re-executar com instrumentação — caro e nem sempre possível (inputs não-determinísticos).

### Abordagens no survey

1. **Causal tracing:** instrumentar cada agente para logar decisão + justificativa + confiança. Post-hoc análise identifica ponto de divergência
2. **Contrafactual probing:** injetar perturbações em outputs intermediários e medir impacto no final — identifica agentes com alta influência causal
3. **LLM-based attribution:** usar modelo separado para analisar trace completo e apontar falha — escalável, mas adiciona custo

## Eixo 3: Self-Evolution

### Topologia adaptativa

Sistema monitora taxa de sucesso por subtarefa por agente. Quando agente X falha consistentemente em tipo Y de tarefa, sistema pode:
- Substituir X por agente especializado em Y
- Adicionar agente de revisão antes de X
- Dividir tarefa Y em sub-tarefas menores

### Otimização de prompt coletivo

Variante evolutiva: múltiplos agentes com prompts diferentes competem na mesma tarefa, melhores prompts são selecionados e combinados — evolução de "genoma de prompt" coletivo.

## Gaps identificados pelo survey

- Maioria dos sistemas MAS testados em benchmarks sintéticos — poucos em produção com carga real
- Failure attribution ainda não tem padrão estabelecido — cada paper implementa do zero
- Self-evolution documentada em laboratório, não testada em longevidade (meses de operação)

## Implicações para design de agentes

Para construir MAS robusto baseado neste survey: usar topologia hierárquica com comunicação lateral, implementar logging de decisão obrigatório em cada agente, e medir taxa de sucesso por tipo de tarefa desde o início para informar evolução da topologia.

## Conexão com trabalhos específicos do vault

Dois papers do vault se conectam diretamente com este survey:

**Memory Curse (memory-curse-expanded-recall-cooperative-intent):** demonstra empiricamente que memória longa degrada cooperação em MAS — contribuição ao eixo de colaboração estruturada com implicação específica de design de memória.

**Beyond RAG (is-grep-all-you-need):** demonstra que harnesses simples superam RAG em retrieval agêntico — contribuição ao eixo de colaboração ao mostrar que ferramenta de busca compartilhada funciona melhor como harness simples do que como sistema complexo.

Os três trabalhos juntos (survey + memory curse + is-grep) formam perspectiva coerente sobre como simplificar MAS sem sacrificar capacidade.

## Taxonomia de papers no survey

Survey organiza trabalhos em:
- **Comunicação:** linguagem natural vs estruturada, síncrona vs assíncrona, broadcast vs peer-to-peer
- **Coordenação:** centralizada (orquestrador) vs descentralizada (emergente), com ou sem memória compartilhada
- **Evolução:** auto-melhoria de prompt, reconfiguração de topologia, meta-learning coletivo
- **Avaliação:** benchmarks específicos para MAS (não apenas métricas de agente single — tarefa requer que múltiplos agentes colaborem)

Taxonomia é útil para classificar qualquer novo sistema MAS e identificar qual literatura é mais relevante.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-error-correction]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
