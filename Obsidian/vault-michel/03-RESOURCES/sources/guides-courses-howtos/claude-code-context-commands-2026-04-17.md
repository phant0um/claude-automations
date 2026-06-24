---
title: "Claude Code Context Management Commands"
type: source
created: 2026-05-18
updated: 2026-05-18
source_file: .raw/images/claude-code-context-commands-2026-04-17.md
source_type: diagram
origin: visual card (author unknown)
category: ai-agents
tags: [ai-agents, diagram, claude-code, context-management]
triagem_score: 7
---

# Claude Code — Context Management Commands

## Tese central

Card visual com 5 situações de gerenciamento de contexto no Claude Code e o comando certo para cada uma — framework operacional para minimizar rot de contexto sem perder informação útil.

## Key insights

- **Continue** — mesma tarefa, contexto ainda relevante: não pague para reconstruir o que já está na janela.
- **Rewind (double-Esc)** — Claude tomou caminho errado: mantém leituras de arquivo úteis, descarta a tentativa falha.
- **/compact \<hint\>** — sessão inchada com debugging/exploração obsoleta: Claude decide o que importou; hint guia a compactação.
- **/clear** — nova tarefa genuína: zero rot, controle total do que carrega.
- **Subagent** — próximo passo gera muito output mas só a conclusão importa: ruído intermediário fica no contexto filho, só o resultado volta.
- Padrão de subagents confirma arquitetura de agentes isolados: contextos filhos não poluem o principal.

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/hot-cache]]
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]

---

## Detalhamento de cada comando

### Continue
Usado quando a mesma tarefa prossegue e o contexto atual ainda é relevante. O erro comum é reiniciar (`/clear`) quando não era necessário — pagando o custo de reconstrução de contexto sem ganhar nada em return. Use `continue` como padrão; mude apenas quando houver razão explícita.

### Rewind (double-Esc)
Desfaz a última resposta do Claude mantendo as leituras de arquivo e o estado do projeto. É o equivalente de um `git reset --soft HEAD~1`: os artefatos úteis (arquivos lidos, contexto de codebase) permanecem, mas a tentativa falha é descartada. Especialmente útil quando o Claude tomou uma decisão de implementação errada mas explorou o problema corretamente antes disso.

### /compact \<hint\>
Compacta a sessão atual mantendo o que o modelo considera relevante, guiado pelo hint fornecido. A diferença de `/clear` é semântica: compact preserva contexto útil; clear descarta tudo. O hint é crítico — sem ele, o modelo decide sozinho o que preservar, o que pode manter debugging obsoleto e descartar descobertas importantes. Exemplo de hint eficaz: `/compact foco na decisão de arquitetura para o módulo X`.

### /clear
Zero-state. Útil quando há uma mudança genuína de tarefa: nova feature, novo projeto, novo problema sem relação com o anterior. O custo de `/clear` é o custo de reconstrução — qualquer contexto que o Claude precisar vai ter que ser reintroduzido. A regra prática: se você precisaria re-explicar mais de 3 coisas ao reiniciar, `/clear` não é a escolha certa.

### Subagent
Delega a próxima etapa a um contexto filho isolado. O subagente pode gerar muito output intermediário (debugging, exploração, tentativas), mas apenas seu resultado final volta ao contexto pai. Isso é equivalente a uma chamada de função com resultado: o caller não vê a stack de execução interna, apenas o retorno.

## Quando cada comando falha

| Comando | Erro comum | Consequência |
|---|---|---|
| Continue | Usar quando contexto está contaminado | Rot acumula, qualidade cai |
| Rewind | Usar para desfazer leituras corretas | Perde contexto de codebase |
| /compact | Não dar hint | Preserva lixo, descarta insights |
| /clear | Usar quando só parte do contexto é ruim | Paga reconstrução desnecessária |
| Subagent | Não isolar tarefas de alto output | Contexto pai fica poluído |

## Princípio unificador: context budget

Todos os 5 comandos são estratégias de **gerenciamento de orçamento de contexto**. O contexto tem custo duplo: custo financeiro (tokens processados por turno) e custo de qualidade (rot degradando a relevância das instruções). A heurística operacional:

- Se o contexto ainda é relevante → `continue`
- Se uma tentativa foi errada mas o estado anterior era bom → `rewind`
- Se o contexto inchando mas parcialmente útil → `/compact` com hint
- Se nova tarefa genuína → `/clear`
- Se próximo passo gera muito ruído → `subagent`

## Relevância para o vault

Este card documenta o framework operacional que o vault usa. O hot.md funciona como memória compactada entre sessões — equivalente ao hint do `/compact` passado para a próxima sessão. A arquitetura de subagents do vault (`04-SYSTEM/agents/`) segue exatamente o padrão documentado: subagentes isolados que retornam apenas resultado para o Nexus.

## Detalhamento do Rewind: casos de uso e anti-casos

O Rewind (double-Esc) é o comando menos utilizado e mais subestimado do conjunto. Seu valor específico está no intervalo entre "a exploração foi boa" e "a implementação foi ruim" — que é o padrão mais comum de divergência em sessões de coding com Claude.

**Caso de uso ideal:** Claude leu 6 arquivos para entender o contexto do bug, então propôs uma solução que modifica a camada errada da arquitetura. Rewind descarta a proposta incorreta e mantém as leituras. A próxima tentativa já tem o contexto dos 6 arquivos sem repagar o custo de leitura.

**Anti-caso:** Claude fez uma pergunta errada no início que levou toda a exploração em direção errada. Rewind desfaz apenas a última resposta — se o erro foi 3 turnos atrás, Rewind não corrige o problema. Nesse caso, `/clear` + reinício direcionado é mais eficaz.

**Anti-caso 2:** usar Rewind para "voltar atrás" em decisões de design que o usuário mudou de ideia. Rewind não é um sistema de undo de decisões — é um undo de execução. Se a decisão mudou, o contexto inteiro precisa refletir isso, o que Rewind não garante.

## Custo de contexto por comando: tabela de decisão rápida

| Cenário | Contexto atual | Custo de reconstrução | Comando certo |
|---|---|---|---|
| Tarefa continua, contexto OK | Relevante | Alto | continue |
| Última resposta errada, exploração OK | Parcialmente útil | Médio | rewind |
| Sessão longa, debugging obsoleto | Inchado | Baixo (hint guia) | /compact |
| Nova tarefa, zero overlap | Irrelevante | Baixo | /clear |
| Próximo passo gera muito ruído | Relevante | N/A | subagent |

## A regra dos 3 para /clear

A heurística prática mencionada — "se você precisaria re-explicar mais de 3 coisas ao reiniciar, /clear não é a escolha certa" — pode ser operacionalizada:

Antes de digitar `/clear`, liste mentalmente o que você precisaria dizer ao Claude em um contexto limpo para continuar a tarefa. Se a lista tem 4+ itens, o custo de reconstrução é alto. Prefira `/compact` com hint cobrindo esses itens, ou continue aceitando o contexto atual.

Se a lista tem 0-2 itens, `/clear` é mais limpo que carregar contexto parcialmente relevante. A reconstrução é rápida e o contexto resultante é mais focado.

## Subagents como padrão de isolamento de ruído

A regra de usar subagents para "próximo passo gera muito output mas só a conclusão importa" generaliza para qualquer operação cujo processo intermediário tem valor zero para o contexto pai:

- **Pesquisa exploratória:** o subagente vasculha documentação e web, retorna apenas as descobertas relevantes — o processo de busca não polui o contexto de desenvolvimento
- **Geração de dados de teste:** o subagente gera 100 casos de teste, retorna apenas a lista — o raciocínio de cada caso não precisa existir no contexto
- **Análise de logs:** o subagente lê 2.000 linhas de log, retorna apenas o root cause — idêntico ao Auto-Diagnose do Google ([[03-RESOURCES/sources/ml-research-papers/llm-automated-diagnosis-integration-tests-google]])
- **Compilação de código:** em projetos com build systems, o subagente pode executar o build e retornar apenas erros relevantes

Em todos os casos, o contexto pai permanece cirúrgico — apenas informação de alta densidade, sem rastro de processo.

## Integração com o princípio de context budget

O conjunto de 5 comandos forma um sistema completo de gerenciamento de orçamento de contexto. A ordem de preferência deve ser:

1. Continue (zero custo, máxima continuidade)
2. Rewind (custo mínimo, desfaz apenas o erro)
3. /compact com hint (custo médio, preserva sinal)
4. Subagent (custo de infraestrutura, máximo isolamento)
5. /clear (custo de reconstrução, contexto limpo)

`/clear` é o último recurso — não o padrão de conveniência. O erro mais comum é usar `/clear` como "reiniciar de um lugar limpo" quando o contexto atual ainda tinha informação útil que poderia ter sido preservada com `/compact`.

## Referências internas adicionais

- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — contexto como recurso gerenciável
- [[03-RESOURCES/sources/guides-courses-howtos/clipping-ai-coding-workflow-neo-kim]] — workflow complementar de coding com AI
- [[03-RESOURCES/sources/skills-prompting-mcp/post-nicos-ai-senior-engineer-claude-workflow]] — worktrees como extensão de contexto paralelo
- [[03-RESOURCES/sources/token-economy-cost/fix-claude-code-rate-limits-quality]] — tokens invisíveis que tornam o gerenciamento de contexto ainda mais crítico
