---
title: "Building Effective AI Agents: Architecture Patterns and Implementation Frameworks"
type: source
source: "Clippings/Building Effective AI Agents- Architecture Patterns and Implementation Frameworks.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
Whitepaper da Anthropic (estratégias de clientes/equipes internas): "GenAI responde perguntas, agentes resolvem problemas." A escolha de arquitetura — single-agent, hierárquico, colaborativo, sequencial, paralelo, evaluator-optimizer — deve ser guiada por três perguntas (controle necessário, complexidade do domínio, restrições de recursos), e a recomendação geral é "comece simples, meça tudo, adicione complexidade só quando ela entrega valor mensurável."

## Argumentos principais
- **Caso de negócio**: agentes representam evolução de LLMs que dirigem autonomamente seus próprios processos e uso de tools, ao contrário de automação tradicional com scripts rígidos. Um agente avalia a tarefa, escolhe tools, tenta abordagens, avalia resultados e ajusta estratégia — como um funcionário qualificado em projeto desconhecido.
- **Boas práticas de design de agentes**:
  - **Comece simples, escale com inteligência**: agentes single-purpose que fazem uma coisa bem, evoluindo gradualmente. Sistemas simples são mais baratos (menos tokens/compute), mais fáceis de debugar, e dão métricas que de fato ligam a outcomes de negócio.
  - **Escolha o modelo certo**: balancear capacidade, velocidade e custo — "não use marreta para pendurar quadro, nem martelo de unha para demolir parede". Rodar tarefa simples em modelo premium é desperdício que se acumula em escala.
  - **Design modular**: prompts em arquivos/bibliotecas centralizados, tools como módulos reutilizáveis discretos, agentes definidos sob demanda usando só os recursos necessários. Permite integrar novas capacidades sem refatoração system-wide.
  - **Agent Skills**: forma estruturada de equipar agentes com expertise, workflows e integrações especializadas além das capacidades base. Skills são *composable* — podem invocar outras skills (ex.: skill de compliance chama skill de análise de documento, que usa skill de extração especializada), construindo hierarquias de capacidade sem implementações monolíticas. Quando usar: expertise de domínio, workflows padronizados, integrações especializadas, requisitos regulatórios/best-practices de indústria. Em sistemas multi-agent, agentes diferentes podem ter skills diferentes conforme especialização.
  - **Observabilidade**: sistemas de IA são não-determinísticos com raciocínio opaco — debugar requer visibilidade sobre cadeias de prompt, caminhos de decisão do modelo, contextos de retrieval, consumo de tokens, e o workflow de raciocínio inteiro, não apenas stack traces.

## Key insights — Padrões arquiteturais

### Single-agent systems
- Loop contínuo: percebe ambiente, decide próximos passos, age. Componentes: modelo (motor de raciocínio), prompt (papel/capacidades), toolkit de integrações, e Skills (camada extra de capacidade especializada).
- **Quando usar**: problemas abertos onde o caminho não é claro de início (não dá para predeterminar quantos passos serão necessários).
- **Quando evitar**: quando você precisa da resposta perfeita de primeira, 100% das vezes — aí considere multi-agent, mas primeiro avalie se adicionar Skills especializadas resolve de forma mais eficiente.
- Exemplo detalhado (research agent com MCP): decompõe query em buscas paralelas (web search via MCP + SQL query interna), usa "think tool" para análise iterativa entre rodadas, refina buscas, sintetiza resultado final.

### Multi-agent systems
- Decompõe, distribui e executa tarefas entre múltiplos agentes especializados; resultados sintetizados em resposta coerente.
- **Dado-chave da Anthropic**: para tarefas complexas que exigem perseguir múltiplas direções independentes simultaneamente, sistemas multi-agent superam sistemas single-agent em **90.2%**. Inteligência atinge um patamar onde "sistemas multi-agent tornam-se forma vital de escalar performance" — "grupos de agentes conseguem realizar muito mais" do que indivíduos, como organizações humanas.
- **Quando usar**: (1) problemas abertos difíceis de prever em avanço, exigindo flexibilidade para pivotar/explorar conexões tangenciais — pesquisa mostra que single agents caem de performance drasticamente com 2+ "domínios distratores"; (2) expertise especializada que sobrecarregaria um agente generalista; (3) queries amplas que exigem perseguir múltiplas direções independentes em paralelo (ganhos substanciais de processamento paralelo).
- **Custo**: multi-agent consome **10-15x mais tokens** que single-agent — exige que valor de negócio justifique o custo.
- **Context management — desafio chave**: orchestrator pode ter contexto complexo demais para gerenciar; manifesta-se como overflow de context window, raciocínio degradado, falhas de coordenação. Estratégias: *context editing* (limpa automaticamente tool calls/resultados obsoletos perto do limite de tokens, mantendo fluxo de conversa), *memory tools* (armazenamento/recuperação fora do context window, persistente entre sessões via sistemas baseados em arquivo), e tools com paginação/range selection/filtering/truncation com defaults sensatos (cap em ~25.000 tokens por resposta).

### Padrões centralizados (hierárquicos/supervisory)
- Supervisor analisa requests, delega para especialistas (tratados como "tools" via tool-calling), sintetiza respostas — cadeia clara de responsabilidade. Subagentes podem ter seus próprios subagentes, abstraídos do supervisor (que só interage com o "team leader" do subagente).
- Variações: full orchestration (controle supervisório completo), routing-focused (foco em decisões de delegação, possivelmente passando comunicação direta ao especialista), hybrid coordination (envolve supervisor seletivamente conforme complexidade).
- **Exemplo**: agência de marketing — Marketing Director (supervisor) → Market Research, Creative Design, Copywriting, Media Planning agents → integração final pelo supervisor.

### Padrões descentralizados (colaborativos)
- Agentes peer-to-peer, comunicação direta, negociação dinâmica de papéis, inteligência distribuída — coordenação emerge das interações, não é imposta.
- Variações: **group chat orchestration** (thread compartilhado, colaboração via discussão), **event-driven coordination** (eventos como linguagem compartilhada), **blackboard architectures** (repositório de conhecimento compartilhado = memória coletiva).
- **Desafio chave**: complexidade de comunicação e imprevisibilidade de comportamento emergente — comunicação frequente aumenta custo computacional; pequenas mudanças podem afetar comportamento de forma imprevisível. Requer frameworks definindo divisão de trabalho, abordagens de resolução de problema, orçamentos de esforço (não instruções estritas); e mecanismos de resolução de conflito + prevenção de tasks "ricocheteando" indefinidamente.
- **Exemplo**: consultoria estratégica — agentes de pricing, produto, marketing, financeiro, social media e estratégico compartilham achados em tempo real, cross-referenciam, sintetizam relatório de inteligência competitiva.

### Agentic workflows (predefinidos/estáticos)

**Sequential workflows**: fluxo de controle predeterminado, transições previsíveis — ideal para processos repetíveis (cadeias de aprovação, compliance). Pode usar pontos de decisão software-defined (lógica condicional) ou AI-driven routing (modelo decide o fluxo baseado em resultados intermediários) — abordagem híbrida combina confiabilidade de caminhos predeterminados com flexibilidade.
- **Vantagem**: previsibilidade operacional — mapear fluxo inteiro, estimar custos, debugar por estágio. Trade-off: menos flexibilidade para edge cases.
- **Quando usar**: tarefas decompostas em subtasks fixas; objetivo é trocar latência por maior acurácia (cada chamada IA = tarefa mais focada/fácil). Cenários: processos multi-estágio com dependências lineares claras, pipelines de transformação de dados, estágios que não podem ser paralelizados, refinamento progressivo (draft-review-polish).
- **Quando evitar**: poucos estágios que um único agente resolve bem; agentes precisam colaborar (não apenas handoff); workflow exige backtracking/iteração.
- **Exemplo**: pipeline data science — Scoping agent → Data Engineering agent → Analysis agent → Review/escalation (humano se complexo) → Deliver insights.

**Parallel workflows**: tarefas independentes distribuídas simultaneamente entre agentes, resultados mesclados/processados concorrentemente — padrão "fan-out/fan-in" de cloud design. Agentes operam independentemente, sem handoff entre si (mas um agente pode invocar outros agentes via sua própria orquestração).
- **Quando usar**: subtasks divididos podem rodar simultaneamente para velocidade, ou múltiplas perspectivas são necessárias para resultados de maior confiança. Para tarefas complexas multi-consideração, modelos performam melhor quando cada consideração vai numa chamada separada.
- Exemplos: sectioning (um modelo processa query, outro screena conteúdo inapropriado — guardrails), avaliações automatizadas (cada chamada avalia um aspecto diferente), voting patterns (revisão de vulnerabilidades de código com vários prompts diferentes, ou avaliação de adequação de conteúdo com múltiplos prompts e thresholds de voto para balancear falsos positivos/negativos).
- **Quando evitar**: agentes precisam construir sobre o trabalho uns dos outros / contexto cumulativo sequencial; ordem específica de operações exigida; quotas de modelo tornam paralelo ineficiente; agentes não conseguem coordenar mudanças em estado compartilhado/sistemas externos sem estratégia de resolução de conflito clara; lógica de agregação de resultado complexa demais ou degrada qualidade.
- **Exemplo**: avaliação de risco financeiro — Data Aggregation agent → 4 agentes paralelos (Credit Risk, Market Risk, Operational Risk, Regulatory Compliance) → Risk Aggregation/Decision Engine.

**Evaluator-optimizer**: dois sistemas IA em ciclos iterativos — um gera conteúdo, outro avalia e dá feedback, repetindo até atender padrões de qualidade. Resembra colaboração escritor-editor.
- **Quando usar**: critérios de avaliação claros existem e refinamento iterativo entrega valor demonstrável. Excelente para criação de conteúdo que exige nuance (tradução literária), geração de código com requisitos de segurança, comunicações profissionais onde tom importa, tarefas de pesquisa que exigem raciocínio multi-step com validação.
- **Quando evitar**: qualidade de primeira tentativa já atende requisitos; critérios de avaliação subjetivos/pouco claros; restrições de tempo/custo superam ganhos de qualidade; aplicações real-time; tarefas rotineiras simples (classificação básica); ambientes com orçamento de tokens estrito; soluções determinísticas existem; workflow avaliador carece de expertise de domínio para feedback significativo.
- **Exemplo**: gerador de documentação de API — Generator agent cria docs iniciais → Technical evaluator agent valida acurácia contra implementação real → ciclo de refinamento (tipicamente 2-4 ciclos) → documentação publicada.

## Exemplos e evidencias

### Padrões emergentes
- **Dynamic agent generation**: agentes criados em runtime, montados a partir de bibliotecas de prompts/tools/configurações, dissolvidos após conclusão da tarefa. Nenhum sistema de produção implementa criação verdadeiramente dinâmica ainda, mas fundações técnicas existem (AutoGen, Semantic Kernel). Vantagens: otimização de recursos, performance task-specific. Desafios: complexidade de gestão de contexto, riscos de comportamento emergente, overhead de criação dinâmica — território experimental.
- **Network/peer-to-peer (swarm) architectures**: comunicação many-to-many sem gargalos hierárquicos — qualquer agente fala com qualquer agente diretamente. Benchmarking inicial mostra "arquitetura swarm supera ligeiramente arquitetura supervisor de forma geral" porque agentes colaboram diretamente sem camadas de tradução supervisória.

### Decision framework — três perguntas críticas
1. **Que nível de controle você precisa?**
   - Alto (compliance regulatório, transações financeiras, operações safety-critical) → single agents ou sequential workflows (comportamento previsível/auditável — comparar auditar agente único de aprovação de empréstimo vs. 3 modelos colaborando).
   - Moderado (suporte ao cliente, criação de conteúdo, análise de dados) → hierárquicos (supervisor aplica regras de negócio, especialistas lidam com complexidade).
   - Baixo (pesquisa, brainstorming, análise complexa) → colaborativos (imprevisibilidade vira feature).
2. **Quão complexo é o domínio do problema?**
   - Domínio único (responder perguntas de produto, processar devoluções, gerar relatórios) → single agent.
   - Multi-domínio mas previsível (onboarding de funcionários, workflows de compliance, análises padrão) → sequential/parallel workflows.
   - Aberto e complexo (análise estratégica, pesquisa, troubleshooting de sistema) → multi-agent.
3. **Quais são suas restrições de recursos?**
   - Orçamento/tokens limitado → single agents ou parallel workflows cuidadosamente desenhados (lembrar do fator 10-15x).
   - Pressão de time-to-market → começar single agent, planejar caminho de evolução (single agent em semanas; multi-agent leva meses).
   - Iniciativa estratégica de longo prazo → desenhar para evolução modular desde o início (interfaces que suportam adicionar agentes depois).

### Pergunta adicional: precisa de expertise de domínio profunda?
- Domínio único com workflows estabelecidos → single agent com Skills especializadas (antes de saltar para multi-agent, considerar se Skills resolvem).
- Múltiplos domínios distintos exigindo coordenação (ex.: revisão jurídica coordenando com análise financeira) → multi-agent com Skills especializadas por agente.
- Exemplo de evolução: revisão de contratos começa com single agent + skills jurídicas → evolui para multi-agent (contract analysis, risk assessment, compliance checking), cada um com suas próprias Skills.

### Caso real: evolução de plataforma e-commerce (5 fases)
1. Single agent para perguntas de clientes (provando valor)
2. Padrão de routing separando status de pedido, perguntas de produto, reclamações
3. Agentes especializados por categoria com contexto compartilhado
4. Sistema multi-agent com coordenação de inventário, pagamento e envio
5. Agentes avaliadores para garantia de qualidade e melhoria contínua

### Hybrid architecture strategies
- **Hierárquico + paralelo**: supervisor delega a especialistas que coordenam workflows paralelos (ex.: supervisor de risco financeiro delega a agentes de crédito/mercado/operacional, cada um rodando análises paralelas no seu domínio).
- **Sequential + dynamic routing**: processo linear que invoca tipos de agente diferentes conforme resultados intermediários (ex.: classificação inicial → roteia para resolução simples ou time multi-agent de pesquisa complexa).
- **Single agent + multi-agent escalation**: agentes simples lidam com rotina, mas disparam automaticamente sistemas multi-agent sofisticados ao encontrar edge cases — otimiza custo mantendo capacidade para cenários complexos.

### Casos de uso citados (Capítulo 2)
- **Coding**: Augment Code (Claude + Vertex AI) — projeto de 2 semanas que CTO estimava em 4-8 meses; onboarding de devs de semanas para 1-2 dias.
- **Data analysis**: Grafana usa Claude para assistente conversacional sobre dados de observabilidade (gera PromQL/LogQL a partir de linguagem natural).
- **Customer support**: Intercom Fin AI (Claude) — até 86% resolution rate, 51% out-of-the-box, 25.000+ clientes, 45+ idiomas, resposta de 30min para segundos. Assembled (Claude) — +20% CSAT, -50% escalações, +30% casos resolvidos/hora.
- **Legal**: Thomson Reuters CoCounsel (Claude via Bedrock) — 3.000+ especialistas/150+ anos de conteúdo. Legora (Claude) — +18% performance em eval jurídico proprietário.
- **Marketing**: Advolve (Claude) — orquestra aquisição digital em milhões de anúncios, -90% tempo operacional, +15% ROAS, gerencia budgets de $100M+.
- **Financial services**: Coinbase (Claude) — suporte a clientes 99.99% disponibilidade, 35-50 apps internas de IA. Tines (Claude) — 100x melhoria time-to-value em operações de segurança. Gradient Labs (Claude) — 80-90% resolution rate. Inscribe (Claude) — fraud review de 30min para 90s (20x mais rápido), +70x output.
- Banco de varejo: memos de risco de crédito — 20-60% ganho de produtividade, -30% turnaround. Manufaturadora europeia (€10bi+ revenue) mapeou estratégia agêntica.

## Implicacoes para o vault
- Este documento é a referência canônica de arquitetura de agentes da Anthropic — confirma e fundamenta diversos conceitos já presentes em `[[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]`, `[[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]`, `[[03-RESOURCES/concepts/agent-systems/evaluator-optimizer-workflow]]`, `[[03-RESOURCES/concepts/agent-systems/agent-architecture]]`.
- O dado **90.2% de superioridade multi-agent** e o custo **10-15x em tokens** são números de referência importantes — vale conferir se já estão registrados em `[[03-RESOURCES/concepts/agent-systems/mas-scaling-laws]]` ou `[[03-RESOURCES/concepts/agent-systems/multi-agent-systems]]`.
- O **decision framework de 3 perguntas** (controle / complexidade / recursos) é diretamente aplicável ao design de `04-SYSTEM/agents/` no vault — Nexus já opera como orquestrador hierárquico (supervisor) com agentes especializados como "tools", alinhado ao padrão "Hierarchical/supervisory systems" descrito aqui.
- **Context management** (context editing, memory tools, paginação/cap de ~25k tokens) conecta-se a `[[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]` e `[[03-RESOURCES/concepts/llm-ml-foundations/context-rot]]` — relevante para o princípio de token-economy do vault.
- **Agent Skills como composable, hierárquicas** confirma a arquitetura de skills do vault (`~/.claude/skills/`) e `[[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]`/`[[03-RESOURCES/concepts/agent-systems/skill-authoring]]`.
- O padrão "single agent + multi-agent escalation" é um modelo direto para o fluxo Nexus → subagentes especializados sob demanda, já praticado no vault.

## Links
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/evaluator-optimizer-workflow]]
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/agent-systems/skill-authoring]]
- [[04-SYSTEM/AGENTS.md]]
- [[03-RESOURCES/concepts/agent-systems/agentic-patterns]]
- [[03-RESOURCES/concepts/agent-systems/agent-design-decision-framework]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
