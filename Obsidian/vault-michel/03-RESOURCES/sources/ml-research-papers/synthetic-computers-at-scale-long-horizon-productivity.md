---
title: "Synthetic Computers at Scale for Long-Horizon Productivity Simulation"
type: source
source_type: paper
arxiv: "2604.28181"
authors: [Tao Ge, Baolin Peng, Hao Cheng, Jianfeng Gao]
institution: Microsoft
url: "https://arxiv.org/html/2604.28181v1"
dataset: "https://huggingface.co/datasets/microsoft/synthetic-computers-at-scale"
created: 2026-05-13
ingested: 2026-05-13
tags: [paper, long-horizon-agents, synthetic-data, productivity-agents, microsoft, agentic-rl]
triagem_score: 9
---

## Resumo

Paper da Microsoft que apresenta **Synthetic Computers at Scale** — metodologia escalável para criar ambientes computacionais sintéticos, realistas e específicos para cada usuário, e rodar sobre eles **simulações de produtividade de longo horizonte** para gerar dados de treinamento para agentes.

## Problema Central

Agentes de produtividade precisam de contexto rico e específico do usuário para funcionar bem em cenários reais. Coletar trajetórias reais é inviável em escala (privacidade, custo). Dados sintéticos genéricos ficam aquém da realidade porque carecem do contexto acumulado de um computador de verdade.

**Três princípios guia:**
1. Trabalho de produtividade é condicionado por contexto denso (arquivos, histórico, decisões anteriores).
2. O desafio-chave é usar esse contexto ao longo de horizontes longos.
3. Dados sintéticos precisam sintetizar o *contexto*, não apenas a *tarefa*.

## Metodologia

### 1. Criação do Computador Sintético

**Fluxo:** Persona → User Profile → Filesystem Policy → Filesystem Planning → Instantiação

- **Persona** (abundantes em escala de bilhões) → expandida em **User Profile** detalhado: identidade, ocupação, responsabilidades, histórico de trabalho, projetos em curso, colaboradores, produtos, hábitos de documento e organização.
- **Filesystem Policy**: define layout de drives, caminhos padrão, padrões de armazenamento, estilo de nomeação, nível de organização.
- **Filesystem Planning**: lista completa de arquivos com paths lógicos, tipos, timestamps, origens e dependências inter-artefato.
- **Instantiação**: gera conteúdo real dos artefatos (docs, planilhas, apresentações) condicionado ao plano.

Exemplo de persona: Margaret Elaine Forsythe, Senior Financial Advisor na Meridian Wealth Partners, 16+ anos de experiência, usa Excel/Word/PowerPoint, altamente organizada.

### 2. Simulação de Longo Horizonte

**Dois agentes:**
- **Setup Agent**: lê o perfil do usuário e o computador, cria objetivos de produtividade personalizados (~1 mês de trabalho humano, múltiplas entregas profissionais).
- **Work Agent**: age como o usuário, navega o filesystem, coordena com colaboradores simulados, incorpora feedback, cria/revisa entregáveis.

**Escala dos experimentos preliminares:**
- 1.000 computadores sintéticos
- Cada simulação: >8 horas de runtime de agente, >2.000 turnos em média
- Sinaliza de aprendizagem: trajetórias intermediárias (como o agente busca, planeja, revisa, coordena, recupera de falhas) + entregáveis finais

### 3. Validação

Melhorias significativas no desempenho do agente tanto em tarefas **in-domain** quanto **out-of-domain** de produtividade.

## Recursos Publicados

- 100 computadores sintéticos (50 Windows, 50 macOS)
- Relatórios de análise retrospectiva de 500 simulações de longo horizonte
- Dataset: [huggingface.co/datasets/microsoft/synthetic-computers-at-scale](https://huggingface.co/datasets/microsoft/synthetic-computers-at-scale)

## Escalabilidade

Personas existem em escala de bilhões → metodologia pode escalar para **milhões ou bilhões de mundos sintéticos de usuário** com compute suficiente. Cobertura potencial: diversas profissões, papéis, contextos, ambientes e necessidades de produtividade.

## Importância Estratégica

> "Scalable synthetic computer creation, together with at-scale simulations, is highly promising as a foundational substrate for **agent self-improvement and agentic reinforcement learning** in long-horizon productivity scenarios."

## Conceitos Relacionados

- [[03-RESOURCES/concepts/long-horizon-agent-training]]
- [[03-RESOURCES/concepts/synthetic-training-data]]
- [[03-RESOURCES/concepts/persona-driven-environment-generation]]
- [[03-RESOURCES/concepts/agentic-reinforcement-learning]]

## Entidades Relacionadas

- [[03-RESOURCES/entities/Microsoft-Research]]
- [[03-RESOURCES/entities/Tao-Ge]]

## Cross-links

- [[03-RESOURCES/sources/on-training-large-language-models-for-long-horizon-tasks-an-empirical-study-of-horizon-length]] — estudo empírico sobre horizon length em treinamento; contexto complementar
- [[03-RESOURCES/sources/coordination-as-an-architectural-layer-for-llm-based-multi-agent-systems-an-information-controlled-empirical-study-on-prediction-markets]] — coordenação como camada arquitetural; relacionado a multi-agent productivity
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]

---

## Por que sintetizar contexto é mais difícil que sintetizar tarefas

A maioria das abordagens de dados sintéticos para agentes gera tarefas artificiais em ambientes limpos — "abra o arquivo X, edite a linha Y, salve". O problema é que trabalho real de produtividade não funciona assim. Um financial advisor real não abre um arquivo aleatório — ele abre o arquivo de um cliente específico por uma razão específica que conecta a uma reunião de ontem, a um email de amanhã e a um objetivo de Q3 que está em uma planilha diferente.

O passo crítico da metodologia é o **User Profile** — não apenas a persona ("financial advisor") mas o historial acumulado: projetos em curso, colaboradores frequentes, histórico de documentos, padrões de organização, produtos habituais. É esse contexto acumulado que cria a *especificidade* que torna a tarefa sintetizada realista.

Sem esse contexto, o agente treinado aprende a executar ações corretas em ambientes neutros — mas falha quando o ambiente tem "bagagem histórica" que condiciona o que a ação correta significa.

---

## O Work Agent como modelo de agente de produtividade

O **Work Agent** descrito no paper não é simplesmente um agente que executa tarefas. Ele modela o ciclo completo de trabalho de um knowledge worker:

1. **Navegação com propósito**: lê o filesystem para entender estado atual antes de agir
2. **Coordenação simulada**: interage com colaboradores simulados (outro agente que joga o papel de colega)
3. **Incorporação de feedback**: revisa entregas com base em feedback do colaborador
4. **Revisão e iteração**: não entrega na primeira versão — produz, revisa, melhora
5. **Recuperação de falhas**: quando uma etapa falha (arquivo não encontrado, formato inesperado), não para — tenta caminhos alternativos

Cada uma dessas etapas gera **trajetórias intermediárias** que são os dados de treinamento mais valiosos. Não apenas o entregável final, mas o processo de chegar lá — as buscas, os planos, os ajustes, as recuperações de falha.

---

## Escala e implicações econômicas

Os números do paper são intencionalmente preliminares (1.000 computadores, 500 simulações) mas a estrutura de escalabilidade é o argumento principal:

- **Personas** existem em bilhões (cada combinação de profissão × senioridade × setor × localização × estilo de trabalho é uma persona diferente)
- **Custo por computador sintético**: depende de compute para gerar os artefatos, mas não de trabalho humano além da configuração inicial
- **Custo de anotação**: zero — as trajetórias do Work Agent são os dados de treinamento, sem necessidade de annotation humano

Compare com coleta de dados reais: privacidade (usuários não consentem com rastreamento de produtividade), viés de coleta (só usuários que instalam telemetria), e custo de anotação (cada trajetória precisa ser revisada para qualidade). Dados sintéticos eliminam os três problemas.

---

## Limitações e riscos da abordagem

**Distribution shift**: mesmo com User Profiles detalhados, há diferença entre o computador sintético de Margaret Forsythe e o computador real de uma financial advisor real. O filesystem sintético não tem 16 anos de arquivos com naming inconsistente, emails com anexos corrompidos e folders criados em pânico às 23h. A questão é se o agente treinado em sintético generaliza para o real.

**Custo de compute**: ">8 horas de runtime de agente" por simulação × 1.000 computadores = 8.000+ horas de runtime. Em escala de 1 milhão de computadores isso requer infraestrutura de compute massiva — a metodologia é escalável em princípio, mas com barreiras de custo reais.

**Viés de persona**: as personas são geradas por LLMs, que têm seus próprios vieses sobre "o que um financial advisor típico faz". Se as personas são enviesadas, os dados de treinamento são enviesados — e o agente resultante tem blind spots para usuários que não se encaixam nos padrões do LLM gerador.

**Colaboradores simulados**: o Work Agent coordena com outros agentes que simulam colaboradores. A qualidade dessas simulações afeta diretamente a qualidade das trajetórias geradas — um colaborador simulado que nunca dá feedback negativo cria dados que não ensinam o agente a lidar com revisões reais.

---

## Relevância para o paradigma de agentes do vault

O vault-michel como "computador sintético pessoal" tem uma estrutura análoga ao que o paper descreve:

- O **User Profile** do vault é o CLAUDE.md — persona, responsabilidades, projetos em curso, padrões de organização
- O **Filesystem** do vault é o sistema de diretórios com hierarquia prescrita (00-INBOX/ até 08-ARCHIVE/)
- As **trajetórias de Work Agent** são as sessões reais de Claude Code operando no vault

A diferença: o vault de Michel é um computador real (não sintético) com contexto real acumulado. As trajetórias geradas por Claude Code operando sobre ele são dados de treinamento de alta qualidade para um agente especializado em operação de segundo-cérebro — se fossem coletadas.
