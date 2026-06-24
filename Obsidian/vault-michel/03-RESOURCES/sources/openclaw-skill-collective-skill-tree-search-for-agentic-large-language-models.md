---
title: "OpenClaw-Skill: Collective Skill Tree Search for Agentic Large Language Models"
type: source
source: "Clippings/OpenClaw-Skill Collective Skill Tree Search for Agentic Large Language Models.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central

Skills reutilizáveis para agentes LLM podem ser construídas e refinadas automaticamente via busca em árvore coletiva (Collective Skill Tree Search, CSTS) combinada com reforço (Collective Skill Reinforcement Learning, CSRL baseado em GRPO) — substituindo autoria manual de SKILL.md por um processo de geração, avaliação e seleção guiado por desempenho em trajetórias reais.

## Argumentos principais

- **CSTS opera em 2 fases**: CSN-Gen (geração de candidatos de skill como nós de uma árvore, a partir de trajetórias de execução do agente) e CSN-Assess (avaliação dos candidatos por utilidade medida, não por julgamento subjetivo) — árvore permite explorar múltiplas variações de uma skill em paralelo antes de promover a melhor.
- **CSRL (GRPO-based)** trata a otimização de skills como problema de reinforcement learning coletivo — múltiplos agentes/trajetórias contribuem sinal de recompensa para refinar o conjunto de skills, em vez de uma única trajetória linear de tentativa-erro.
- O objetivo é fechar o gap entre "skill escrita manualmente por um humano que acerta na primeira tentativa" e "skill que emerge e se prova via uso real medido em múltiplas tentativas e agentes".
- Skills construídas assim carregam evidência de desempenho (trajetórias que validaram a skill), diferente de SKILL.md autoral onde a justificativa é só a intenção de quem escreveu.

## Key insights

- O framework trata "qual skill funciona" como pergunta empírica resolvida por busca + RL, não como pergunta de design resolvida por boas práticas de autoria (frontmatter, description, etc.) — são camadas complementares: uma decide o *quê* funciona, a outra decide *como documentar* o que funciona.
- A abordagem coletiva (múltiplos agentes contribuindo para a mesma árvore de skills) é estruturalmente próxima de SkillOpt (Microsoft, 2026) já catalogado no vault — ambos tratam skill-texto como artefato otimizável por trajetória de execução, não como documento estático.

## Exemplos e evidências

- Paper acadêmico completo (384 linhas, bibliografia extensa) descrevendo a arquitetura CSTS/CSRL para LLMs agentic, incluindo formalização de geração e avaliação de nós da árvore de skills.

## Implicações para o vault

F2.5 Concept Absorption em `[[03-RESOURCES/concepts/agent-systems/agentic-skills]]` — concept já cobre "Skill Lifecycle" (Discovery → Definition → Usage → Evolution → Consolidation) e "Autogeneration" via extração de padrões; CSTS/CSRL é uma instância mais formal/acadêmica do mesmo estágio de "Evolution"/"Autogeneration", com método de busca em árvore + RL coletivo que o concept ainda não detalhava. Não cria concept novo — nem `skill-authoring.md` (foco em "como escrever bem" manualmente) nem `interpreter-skills.md` (padrão SKILL.md+TS determinístico) cobrem o eixo de geração automática via busca/RL; `agentic-skills.md` é o lugar correto por já hospedar SkillOpt, tema mais próximo.

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/skill-authoring]]
