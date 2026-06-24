---
title: "Company Brain, Part 4: Action Memory"
type: source
source_type: clipping
category: ai-agents
author: Ashwin Gopinath (@ashwingop)
url: "https://x.com/ashwingop/status/2051317871750558077"
published: 2026-05-04
ingested: 2026-05-05
tags: [company-brain, action-memory, enterprise-ai, agentic, workflow, memory]
triagem_score: 8
---

# Company Brain, Part 4: Action Memory

## Summary

Part 4 of Ashwin Gopinath's Company Brain series introduces **action memory** — the layer that remembers how work actually gets done inside a company, not just what happened or why decisions were made. Unlike factual or interaction memory, action memory is partly agentic: it must notice conditions, decide when workflows should trigger, respect guardrails, and either act or escalate to a human. The key insight is that "doing nothing on purpose" is a first-class action — a trustworthy system must know when NOT to act. Action memory bridges the gap between knowing a process exists and knowing when, with whom, and under what conditions it should actually execute.

## Key Takeaways

- **Four components of action memory**: procedural (how a process works), trigger (when it should wake up), execution (what actually happened in a specific case), and outcome (what resulted after the action)
- **Most workflow diagrams are fiction**: they show the official process, not the real one; action memory must capture both the documented path and the tribal knowledge routing that happens in practice
- **Doing nothing is a first-class action**: a system that cannot deliberately do nothing cannot be trusted to do anything
- **Timing is critical**: much important work starts when a condition changes, not when someone asks a question — trigger memory is what makes conditions actionable
- **Actions close the loop**: a successful action becomes precedent; a failed one becomes risk memory; a human correction becomes a signal; the loop is what makes action memory compound
- **Role-specific views**: IC needs next step + context; manager needs to see failing handoffs; CEO needs a map of where the company repeatedly loses momentum after deciding what matters

## Concepts Linked

- [[03-RESOURCES/concepts/pkm-obsidian/company-brain]]
- [[03-RESOURCES/concepts/action-memory]]
- [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]

## Os quatro componentes de action memory em detalhe

### 1. Procedural Memory — o "como" documentado

Procedural memory armazena como um processo funciona: os passos, as responsabilidades, as ferramentas usadas, as exceções conhecidas. É o equivalente de um SOP (Standard Operating Procedure), mas dinâmico — atualizado quando o processo real diverge do documentado.

O insight crítico de Gopinath: "a maioria dos workflow diagrams são ficção". Eles mostram o processo oficial, não o real. O processo real inclui:
- A pessoa que sempre bypass o passo 3 porque "é mais rápido assim"
- O sistema legado que quebra em todo fim de mês e requer intervenção manual
- As exceções de clientes VIP que ninguém documentou

Procedural memory de qualidade captura o processo real, não o aspiracional.

### 2. Trigger Memory — quando o processo deve acordar

Trigger memory é o componente mais frequentemente ausente em sistemas de workflow. Saber como fazer algo é inútil sem saber quando fazer. Triggers podem ser:
- **Temporais:** "toda segunda-feira às 9h", "no último dia do mês"
- **Baseados em condição:** "quando o pipeline de vendas for maior que $500K", "quando um cliente fica 30 dias sem atividade"
- **Baseados em evento:** "quando um novo contrato é assinado", "quando a satisfação do cliente cai abaixo de 4.0"

A frase "muito trabalho importante começa quando uma condição muda, não quando alguém faz uma pergunta" é a distinção entre sistemas reativos (respondem a perguntas) e proativos (monitoram condições). Action memory com trigger bem definida é o que permite sistemas proativos.

### 3. Execution Memory — o que realmente aconteceu

Distinct de procedural memory (o que deveria acontecer), execution memory registra o que realmente aconteceu em cada instância: quem fez o quê, quando, quanto tempo levou, onde houve desvios do processo documentado, quais decisões foram tomadas e por quem.

Execution memory é o que permite aprendizado real: comparando múltiplas execuções, é possível identificar quais variações no processo produzem melhores outcomes, quais passos regularmente tomam mais tempo do que o planejado, e quais handoffs são os pontos mais frequentes de falha.

### 4. Outcome Memory — o que resultou da ação

Outcome memory fecha o loop: o que aconteceu depois que a ação foi executada? Isso inclui resultados diretos (o cliente renovou, a proposta foi aceita, o bug foi corrigido) e resultados indiretos (o cliente que renovou aumentou o contrato 6 meses depois, o bug que foi corrigido revelou um problema arquitetural maior).

Outcome memory conecta ações a consequências de forma que o sistema pode aprender quais ações em quais condições produzem quais outcomes — a base para melhorar o processo ao longo do tempo.

## "Fazer nada intencionalmente" como ação de primeira classe

O insight de que "fazer nada" deve ser uma ação explícita é mais profundo do que parece. Um sistema que só pode agir não pode ser confiado com decisões que às vezes têm a resposta correta de "aguardar".

Exemplos onde "não agir" é a decisão correta:
- Um cliente reclamou? Às vezes a resposta correta é aguardar 24 horas para ver se o problema se resolve
- Uma métrica caiu? Às vezes é flutuação normal, não crise
- Um contrato está para expirar? Às vezes o cliente já decidiu não renovar e uma pressão de vendas prejudicaria a relação

Um sistema de action memory que só executa ações ativas não pode aprender quando a não-ação é a escolha certa. Registro de "decidi não agir porque X" é tão valioso para aprendizado quanto registro de ações executadas.

## O compounding de ações precedentes

"Uma ação bem-sucedida se torna precedente; uma que falhou se torna risk memory; uma correção humana se torna sinal" — esta sequência descreve como action memory composta ao longo do tempo.

### Precedente

Quando uma ação produz um bom outcome em condição C, ela se torna um precedente: em condições similares a C no futuro, esta ação é um candidato forte. O sistema não precisa "reinventar" a abordagem — consulta o precedente.

### Risk memory

Quando uma ação falha em condição D, ela se torna risk memory: em condições similares a D, esta ação é um risco. O sistema pode usar isso para filtrar candidatos de ação ou para escalate para aprovação humana.

### Sinal de correção humana

Quando um humano corrige o sistema (faz diferente do que o sistema faria), isso é um sinal de alta qualidade: o humano tinha informação ou julgamento que o sistema não tinha. Esses sinais, capturados como execution memory, são os dados de treino mais valiosos para melhorar o sistema ao longo do tempo.

## Visões específicas por papel

A discussão sobre "role-specific views" é relevante para design de interfaces de sistemas de knowledge management:

- **IC (Individual Contributor):** precisa de próximo passo + contexto suficiente para executar sem hesitar. View focada em ação imediata.
- **Manager:** precisa ver onde handoffs estão falhando — as transições entre responsabilidades são onde trabalho se perde. View focada em fluxo entre pessoas.
- **CEO:** precisa de mapa de onde a empresa repetidamente perde momentum depois de decidir o que importa. View focada em padrões sistêmicos.

As três views usam os mesmos dados de action memory mas enfatizam dimensões diferentes. Isso é design de produto, não de dados.

## Relevância para o vault-michel

O vault implementa action memory de forma rudimentar:
- **Procedural:** o CLAUDE.md e os arquivos de regras definem "como fazer"
- **Trigger:** hooks de sessão startup/stop como triggers temporais
- **Execution:** `errors.md` captura execuções problemáticas
- **Outcome:** ausente — o vault não rastreia sistematicamente o que aconteceu depois de cada ingest ou edição

A lacuna mais importante para o vault é outcome memory: saber quais páginas geradas por ingest foram úteis (referenciadas, expandidas, corrigidas) vs. quais ficaram como stubs nunca revisitados. Esse dado existiria implicitamente nos commits do git e nos acessos de leitura — mas não está sendo coletado ou analisado.

## Concepts Linked

- [[03-RESOURCES/concepts/pkm-obsidian/company-brain]]
- [[03-RESOURCES/concepts/action-memory]]
- [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]

## Entities Linked

- [[03-RESOURCES/entities/Ashwin-Gopinath]]
- [[03-RESOURCES/entities/Sentra-AI]]
