---
title: "10T tokens. 10× lower token costs."
type: source
source: "Clippings/10T tokens. 10× lower token costs..md"
created: 2026-06-21
ingested: 2026-06-22
tags: [articles]
---

## Tese central
A Rox (empresa de IA aplicada) tratou custo por ação (DOPA — Dollar Per Action) como métrica de produção de primeira classe, no mesmo nível de latência e error rate, e conseguiu reduzir o gasto de tokens em 10× enquanto escalava o volume de uso em 10×. O argumento central é que tratar custo de inferência como sinal de engenharia contínuo (não como número financeiro isolado) é o que permite escalar IA aplicada com margens saudáveis enquanto a maioria das empresas "tokenmaxxes" em modelos de fronteira.

## Argumentos principais
- **DOPA = token cost ÷ work delivered.** Uma "ação" é uma unidade de valor real para o cliente (ex: e-mail redigido pelo agente, conta enriquecida). Reduzir tokens por ação é "o jogo todo".
- Tratar custo como SLO operacional, não como métrica financeira que só aparece quando a margem já foi destruída — engenharia tem de ter visibilidade e responsabilidade contínua sobre DOPA.
- Camadas de defesa para evitar regressão de custo/qualidade:
  - **CI gates** capturam regressões de custo/qualidade nas próprias mudanças antes do deploy.
  - **Runtime alerts** capturam choques externos (provider muda preço, cliente faz spike de uso).
  - **Evals contínuos** avaliam todo modelo em price-for-performance; um request só migra para modelo menor depois que o downgrade passa na mesma barra de qualidade do modelo maior.
- Os dois maiores "unlocks" de redução de custo:
  1. Reconstruir o stack de busca agêntica internamente — busca era o maior sumidouro de tokens; ao internalizar (owning search), cortaram esse custo na fonte.
  2. Mudança de unidade econômica: ao rodar modelos open-source na própria frota, o custo deixa de ser tokens/segundo e passa a ser GPU-hours — então a otimização vira utilização de GPU, não throughput de tokens.
- Resto da redução veio de manutenção incremental: troca de harnesses, controle de "agent sprawl" (proliferação descontrolada de agentes), pré-processamento de contexto em modelos mais baratos antes de qualquer chamada a modelo de fronteira.
- O custo por ação muda constantemente — toda vez que um provider muda preço, um modelo novo sai, uma mudança de roteamento acontece, ou a unidade de deployment muda. Por isso DOPA precisa de tratamento de "production signal", não de revisão financeira pontual.

## Key insights
- **Owning the bottleneck > otimizar em torno dele**: ao perceberem que busca era o maior sumidouro de tokens, a solução não foi otimizar prompts de busca, foi reconstruir o componente inteiro internamente.
- **Mudança de unidade de custo é uma ferramenta de otimização**: rodar modelo próprio muda a métrica relevante de "tokens/seg" para "GPU-hours" — isso reorienta toda a engenharia de otimização para o eixo certo.
- Downgrade de modelo só é seguro quando gated por eval que garante paridade de qualidade — "downgrade" sem essa guarda é dívida técnica de qualidade disfarçada de economia.
- "Agent sprawl" (proliferação não controlada de agentes/sub-agentes) é citado explicitamente como fonte de desperdício de tokens — reforça necessidade de governança de agentes em sistemas multiagente.

## Exemplos e evidências
- DOPA caiu ~10× do pico enquanto o volume de ações (uso) subiu 10× — relação multiplicativa de 100× em eficiência relativa.
- Equipe "Applied AI Research" da Rox citada nominalmente (vários colaboradores), reforçando que a iniciativa foi tratada como disciplina de engenharia dedicada, não como corte de custos ad-hoc.

## Implicações para o vault
Confirma e dá um nome operacional (DOPA) ao conceito já presente em [[03-RESOURCES/concepts/agent-systems/token-economy]] — token economy não é só prompt caching ou context engineering, é uma métrica de produto com CI gates e runtime alerts dedicados. Também reforça [[03-RESOURCES/concepts/agent-systems/agent-model-routing]] (roteamento de modelo condicionado por eval de qualidade, não só custo) e conecta com a ideia de "agent sprawl" como anti-padrão de escala em [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]].

## Links
- [[03-RESOURCES/concepts/agent-systems/token-economy]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
