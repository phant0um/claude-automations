---
title: "Meta-Meta-Prompting: The Secret to Making AI Agents Work"
type: source
source_file: "Clippings/Meta-Meta-Prompting The Secret to Making AI Agents Work.md"
origin: artigo / ensaio pessoal
author: "@garrytan (Garry Tan, CEO Y Combinator)"
published: 2026-05-09
ingested: 2026-05-14
tags: [garry-tan, gbrain, gstack, skillify, meta-prompting, agent-systems, fat-skills-thin-harness]
triagem_score: 9
---

# Meta-Meta-Prompting: The Secret to Making AI Agents Work

> [!key-insight] Core finding
> Skills que criam skills: Skillify é uma meta-skill que converte qualquer workflow em skill permanente e testada. O compounding real não está em nenhum agente individual — está em rodar agentes em sequência, todo dia, no mesmo sistema. O sistema aprende. Você aprende. A curva de compounding é real.

## O que é Book Mirror

Garry leu "When Things Fall Apart" (Pema Chödrön). Pediu ao AI um **book mirror**:
- 22 capítulos do livro processados em paralelo por sub-agents
- Cada capítulo: resumo das ideias + mapeamento para a vida real de Garry (família, YC, contexto profissional)
- Output: 30.000 palavras em dois colunas: "o que Pema diz" | "como mapeia para o que estou vivendo"
- Tempo total: ~40 minutos

Um terapeuta a $300/h não consegue em 40 horas o que o sistema fez em 40 minutos — porque não tem o grafo completo de contexto profissional, histórico de leituras, notas de reuniões e relações de founders todos carregados e cross-referenciáveis.

## Skills That Build Skills — A Recursividade

**Skillify** é uma meta-skill que:
1. Examina o workflow que acabou de acontecer
2. Extrai o padrão repetível
3. Escreve um skill file testado com triggers e edge cases
4. Registra no resolver

Book-mirror foi skillificado da primeira vez que foi feito manualmente. Meeting-prep foi skillificado depois de notar os mesmos passos antes de cada call.

**Skills compose:** book-mirror chama brain-ops, enrich, cross-modal-eval, pdf-generation. Cada skill focada em uma coisa. Quando uma skill melhora, todos os workflows que a usam melhoram automaticamente.

## O Grafo de 100.000 Páginas

Schema de cada página:
- **Compiled truth** no topo (melhor entendimento atual)
- **Timeline append-only** abaixo (eventos cronológicos)
- **Raw data sidecars** (material fonte)

Cada pessoa que Garry conhece ganha uma página com: timeline, state section (o que é verdade agora), open threads, score.

Após cada reunião: entity propagation — o sistema percorre todos as pessoas e empresas mencionadas e atualiza suas brain pages.

## A Arquitetura

| Camada | Princípio | Implementação |
|---|---|---|
| Harness | Fino | OpenClaw/Hermes Agent — rota, não pensa |
| Skills | Gordas | 100+ skills, cada uma em markdown autocontido |
| Dados | Gordos | 100.000 páginas; compounding value |
| Código | Gordo | 100+ crons/dia; scripts de ingestão |
| Modelos | Intercambiáveis | Opus 4.7 1M (precisão), GPT-5.5 (recall), DeepSeek V4-Pro (criatividade), Groq/Llamma (velocidade) |

## Skills Listadas como Exemplo

- **meeting-ingestion:** transcrição → summary estruturado → entity propagation
- **enrich:** nome de pessoa → 5 fontes mergeadas → brain page citada
- **media-ingest:** vídeo, áudio, PDF, screenshots, repos → transcreve, extrai entidades, arquiva
- **perplexity-research:** web search brain-augmented — compara com o que o brain já sabe antes de sintetizar

## Como Começar

1. Escolher harness fino (OpenClaw, Hermes Agent, ou Pi)
2. Iniciar brain com GBrain (97.6% recall em LongMemEval)
3. Fazer algo interessante — não planejar a arquitetura de skills
4. Usar, ler o output, corrigir → rodar Skillify para extrair pattern
5. Meses depois: algo que nenhum chatbot replica, porque o valor está no que você ensinou ao sistema sobre sua vida, trabalho e julgamento

## A Tese

> "O futuro pertence a indivíduos que constroem sistemas de AI de compounding, não a indivíduos que usam ferramentas de AI centralizadas corporativas. A diferença é a diferença entre manter um diário e ter um sistema nervoso."

## Conexões

- [[03-RESOURCES/entities/Garry-Tan]] — criador do sistema
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — thin harness philosophy
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — skills e skillify
- [[03-RESOURCES/sources/ai-agent-complexity-ratchet-garry-tan]] — artigo seguinte da série

## Por que o harness fino e as skills gordas é a arquitetura certa

A tensão entre thin harness e fat skills não é estética — é uma decisão de onde colocar a lógica de domínio. Um harness gordo (que toma decisões sobre o que fazer) cria dependência de manutenção: cada nova capacidade ou domínio requer mudança no harness central. Um harness fino (que apenas roteia e orquestra) é estável — as skills mudam sem tocar o harness.

O efeito composto das skills compostas é o argumento mais forte para essa arquitetura. Quando `book-mirror` chama `brain-ops`, `enrich`, e `cross-modal-eval`, cada melhoria em qualquer uma dessas skills beneficia automaticamente todos os workflows que as usam. Em um harness gordo, o mesmo workflow seria hardcoded — uma melhoria exigiria refatoração manual de múltiplos pontos.

## O grafo de 100.000 páginas como diferencial competitivo

A arquitetura de brain pages (compiled truth + timeline append-only + raw data sidecars) não é apenas sobre armazenar informação — é sobre manter a distinção entre "o que sabemos agora" e "como chegamos a saber". O campo "compiled truth" no topo de cada página força uma decisão editorial: qual é o melhor entendimento atual, incorporando tudo na timeline? Essa distinção entre estado atual e histórico de atualizações é o que separa um grafo de conhecimento funcional de um arquivo de log.

A entity propagation após cada reunião — percorrer todas as pessoas e empresas mencionadas e atualizar suas páginas — é o equivalente automatizado do que um analista de inteligência faz manualmente. A diferença de escala é que um sistema manual consegue atualizar algumas entidades; a propagação automatizada garante que *toda* entidade mencionada receba contexto novo, criando uma coerência global que seria impossível manualmente.

## Meta-meta-prompting: o que o nome captura

"Meta-prompting" é usar um prompt para criar prompts melhores. "Meta-meta-prompting" é usar um agente para criar a *infraestrutura* de prompting — o sistema que gerará prompts para todas as situações futuras. Skillify é o mecanismo: observa um workflow, extrai o padrão, escreve a skill que codifica esse padrão, testa, registra. O resultado é um sistema que melhora sua própria capacidade de prompting sem intervenção humana constante.
