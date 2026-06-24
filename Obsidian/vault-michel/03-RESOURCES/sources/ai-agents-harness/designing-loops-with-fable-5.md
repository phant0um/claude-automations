---
title: "Designing loops with Fable 5"
type: source
source: "Clippings/Designing loops with Fable 5.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
Modelos classe "Mythos" como Claude Fable 5 são especialmente bons em duas coisas: (1) self-correction loops — rodar, coletar feedback de um goal/rubric, se autocorrigir e prosseguir até satisfazer o critério; e (2) memória entre sessões, completando uma progressão de "fail → investigate → verify → distill → consult" que modelos anteriores não completam. A recomendação prática é parar de "diretamente prompt-ar e dirigir" Fable 5 e em vez disso desenhar loops que deixem o modelo se autocorrigir via feedback do ambiente (/goal, Outcomes) e gerenciar sua própria memória.

## Argumentos principais
- **Self-correction loops**: há interesse crescente em "loops" — @bcherny (Anthropic) descreveu seu trabalho como "escrever loops". Deixar modelos fazerem hillclimbing sobre uma avaliação é a receita comum para melhorar performance em tarefas.
- Primitivas que aplicam essa receita: `/goal` no Claude Code e `Outcomes` no Claude Managed Agent (CMA).
- Fable 5 é "good at self-correcting in a loop" segundo o prompting guide oficial — um goal/rubric bem desenhado adiciona feedback ao ambiente onde Claude roda, permitindo o ciclo: rodar → coletar feedback via goal/rubric → autocorrigir → prosseguir até satisfazer o critério.
- **Ponto sutil sobre julgamento ("judging")**: o que faz a avaliação importa muito. Modelos têm problemas de auto-crítica sobre seus próprios outputs (referência: Prithvi Rajasekaran, blog de engenharia da Anthropic, "harness design for long-running apps").
- **Verificador como sub-agente > self-critique**: um sub-agente verificador tende a superar self-critique com Fable 5, porque a avaliação roda numa janela de contexto independente. `Outcomes` no CMA resolve isso automaticamente, gerando um sub-agente "grader".
- **Memória como "outer loop" entre sessões**: Claude escreve à memória durante uma sessão e essas memórias podem ser recuperadas em sessões futuras — CMA com memory dá a cada agente acesso a um filesystem montado compartilhável entre sessões.

## Key insights
1. **Experimento Parameter Golf** (desafio open source de ML engineering: treinar o melhor modelo que cabe em 16MB em <10min em 8xH100s, similar ao projeto "autoresearch" do Karpathy — editar train_gpt.py, lançar treino, ler log/score, decidir próximo experimento):
   - Comparação Fable 5 vs Opus 4.7 usando CMA com sandbox self-hosted de 8xH100.
   - Para cada teste, foi fornecida uma rubrica (arquivo) com 9 critérios checáveis (ex.: rodar baseline, rodar 20 experimentos).
   - Cada run rodou até 8h; o "Outcomes grader" confirmou que todos os critérios experimentais foram atendidos antes de permitir que Claude parasse.
   - **Resultado**: Fable 5 melhorou o pipeline de treino ~6x mais que Opus 4.7.
   - Diferença qualitativa: Fable 5 apostou em mudanças estruturais maiores (ex. mudanças de arquitetura) e mostrou resiliência (ex. atravessou uma regressão de quantização até chegar à sua maior vitória). Opus 4.7's primeiro experimento produziu uma vitória pequena, e quase tudo depois seguiu o mesmo template: ajustar um escalar, medir, manter se positivo.
2. **Continual Learning Bench 1.0** (publicado por @pgasawa e equipe — primeiro benchmark realista para medir como sistemas de IA melhoram em settings online; benchmarks tradicionais assumem modelos stateless, cada exemplo independente):
   - Comparação de Fable 5, Opus 4.7 e Sonnet 4.6 numa tarefa: agente responde perguntas sequenciais com acesso a um banco SQL, cada pergunta = sessão separada, memória é fornecida via CMA com mounted filesystem.
   - Progressão de uso eficaz de memória: **fail** (errar e documentar) → **investigate** (antes de seguir, descobrir o porquê) → **verify** (transformar diagnóstico em fato checado) → **distill** (transformar verificação em regra geral) → **consult** (ler a regra em vez de re-derivar).
   - **Sonnet 4.6**: sai por volta do passo 1 — seu "store" é uma lista de notas de falha e palpites em aberto (ex.: "maybe prc instead of prc_usd?"). Raramente consulta notas anteriores. Para melhorar, são necessárias instruções de memória específicas da tarefa.
   - **Opus 4.7**: sai por volta do passo 3 — cria uma referência de schema com incerteza sinalizada (ex.: "possibly prc in cents? Verify."), mas cobertura de verificação é baixa: 7-33% das perguntas (mediana ~17%).
   - **Fable 5**: tende a completar a progressão — nas runs mais fortes, cobertura de verificação chega a 73% (22 de 30) e ele destila aprendizados em regras gerais que ajudam tarefas futuras.

## Exemplos e evidencias
- Parameter Golf: https://github.com/openai/parameter-golf — desafio de fitting em 16MB, <10min, 8xH100s.
- Analogia explícita ao projeto "autoresearch" do Karpathy: https://github.com/karpathy/autoresearch.
- CMA = Claude Managed Agents, que fornece "the agent harness as well as a hosted sandbox" — referência ao post "harness design for long-running apps" da Anthropic.
- Self-hosted sandboxes documentados em platform.claude.com/docs/en/managed-agents/self-hosted-sandboxes.
- Continual Learning Bench 1.0 anunciado publicamente por @pgasawa.
- Recursos para começar: prompting guide para Fable 5, `/goal`, Claude Managed Agents, e o skill `/claude-api` embutido no Claude Code.

## Implicacoes para o vault
- Introduz **Fable 5** (nome de classe "Mythos") como modelo Claude relevante para o vault — ainda não documentado em `03-RESOURCES/entities/`. Dado que é claramente recorrente (modelo novo citado com benchmarks específicos vs Opus 4.7 e Sonnet 4.6), mas a tarefa pede para não criar concept/entity novo a menos que claramente ausente E recorrente — este artigo é o primeiro encontro registrado; recomendo revisão futura para criar entity `Fable-5` quando houver mais fontes confirmando.
- A progressão "fail → investigate → verify → distill → consult" para uso de memória entre sessões é um framework direto e aplicável ao próprio vault como segundo cérebro: hot.md / errors.md / memory MEMORY.md já implementam parcialmente "distill" e "consult"; o vault tende a parar perto do nível "Opus 4.7" (schema de referência com incerteza, baixa verificação) — oportunidade de melhorar a etapa "verify" antes de promover algo a memória de longo prazo.
- Reforça `[[03-RESOURCES/sources/define-outcomes]]` e `[[03-RESOURCES/sources/claude-managed-agents-overview]]` (CMA, /goal, Outcomes) como primitivas centrais para qualquer rotina de hillclimbing/self-correction futura no vault.
- "Verificador como sub-agente independente > self-critique" é diretamente aplicável ao padrão `verify` do vault SO (`04-SYSTEM/agents/verify`) — confirma que separar o agente que executa do agente que valida (contexto independente) é prática validada pela própria Anthropic.

## Links
- [[03-RESOURCES/sources/define-outcomes]]
- [[03-RESOURCES/sources/claude-managed-agents-overview]]
- [[03-RESOURCES/sources/anthropic-ant-cli-managed-agents-guide]]
- [[04-SYSTEM/agents/core/verify]]

## Ver tambem (loop engineering cluster)

- [[03-RESOURCES/sources/wtf-is-a-loop-steinberger-cherny]]
- [[03-RESOURCES/sources/loop-engineering-14-step-roadmap]]
- [[03-RESOURCES/sources/what-are-agent-loops-tutorial]]
- [[03-RESOURCES/sources/design-loop-prompts-agent]]
- [[03-RESOURCES/sources/most-devs-dont-need-agent-loops-yet]]
