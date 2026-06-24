---
title: "The Real Difference Between Claude Opus, Sonnet and Haiku"
type: source
source: "Clippings/The Real Difference Between Claude Opus, Sonnet and Haiku.md"
origin_url: "https://x.com/0xMortyx/status/2060689609097359468"
author: "@0xMortyx"
published: 2026-05-30
created: 2026-05-31
ingested: 2026-05-31
tags: [source, claude, anthropic, model-selection, opus, sonnet, haiku, cost-optimization, agents]
---

## Tese central

A maioria das pessoas usa um modelo Claude para tudo — ou não sabe a diferença. Isso é o equivalente a usar uma marreta para pendurar um quadro. Cada modelo tem um domínio de uso correto, e usar o modelo errado na tarefa errada é a causa de resultados inconsistentes.

## Argumentos principais

1. **Resumo em uma linha:** Opus pensa fundo. Sonnet faz o trabalho. Haiku move rápido. A maioria das tarefas precisa de Sonnet. Muito poucas precisam de Opus. Mais do que você imagina podem usar Haiku.

2. **Opus — use quando a tarefa genuinamente requer o melhor raciocínio possível.** Como contratar um consultor: não para escrever emails, mas quando a decisão importa. A qualidade do raciocínio deve impactar diretamente um resultado importante.

3. **Sonnet — seu padrão para 80% de tudo.** Genuinamente inteligente, não versão diluída de Opus. Para a maioria de escrita, código, análise, e pesquisa, você *não vai notar diferença* entre Sonnet e Opus — mas vai notar a velocidade.

4. **Haiku — mais subutilizado do que parece.** Perde para Opus em tarefas difíceis, mas ganha por larga margem em tarefas simples e de alto volume. Mental model: **Haiku é para tudo que não requer raciocínio**.

5. **Realidade de custo relativo (API/automação):** Se você executa uma tarefa 1.000 vezes, a diferença entre Opus e Haiku pode ser $60 vs. $1 para tarefas simples. Para qualquer automação/pipeline/loop de agente, sempre perguntar: isto realmente precisa de Opus?

6. **Erros mais comuns:**
   - Usar Opus para tudo (sente "seguro" mas desperdiça tempo e dinheiro; a maioria não precisa)
   - Usar Haiku para escrita complexa (corta nuances; você vai notar na qualidade)
   - Não trocar modelo no meio do projeto (draft com Sonnet → Opus se bater em parede de raciocínio → Haiku para limpeza)
   - Assumir que Sonnet é "pior" (para 80% das tarefas o output é indistinguível de Opus)
   - Usar o mesmo modelo em agentes e em chat (loops de agente que chamam Claude 50 vezes devem usar Haiku ou Sonnet, não Opus)

7. **Framework de decisão cobrindo 95% dos casos:**
   - Haiku: tarefa simples, repetitiva, ou alto volume
   - Sonnet: default para todo o resto
   - Opus: apenas quando a qualidade do raciocínio impacta diretamente um resultado de alto stakes
   - Se não sabe → comece com Sonnet; suba para Opus apenas se o output decepcionar
   - Em pipelines automatizados: default Haiku, suba etapas específicas para Sonnet onde qualidade importa

## Key insights

- **O erro mais caro não é usar Opus demais** — é usar o modelo errado para a tarefa errada e não saber por que seus resultados são inconsistentes.
- **Sonnet output é indistinguível de Opus em 80% das tarefas** — testar antes de assumir que precisa de Opus.
- **Em agent loops** — trocar de modelo entre chat e automação é esperado e correto. Loops de 50 chamadas = Haiku ou Sonnet.
- **Estratégia de cascata** — iniciar com modelo mais leve, escalar para mais pesado apenas quando encontrar parede.

## Exemplos e evidências

- Custo relativo por tarefa (aproximado): se Haiku = $0.001, Sonnet ~$0.003–0.005, Opus pode ser $0.06+.
- 1.000 chamadas de automação: Opus = ~$60; Haiku = ~$1 (para tarefas simples).
- Agentes que chamam Claude 50 vezes devem usar Haiku ou Sonnet, nunca Opus como padrão.

## Implicações para o vault

- Guia prático de seleção de modelo para Michel ao usar Claude Code, automações, e pipelines de agentes.
- Confirma estratégia do vault de usar Sonnet (este modelo) como default para tarefas de ingestão e documentação.
- Relevante para arquitetura de agentes em `04-SYSTEM/agents/` — decisão de qual modelo usa cada agente.
- Candidato a wikilink em `[[03-RESOURCES/entities/Claude Code]]` e `[[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]]`.

## Links

- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/Claude-Haiku-45]]
- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]]
- [[03-RESOURCES/concepts/ai-strategy-org/inference-optimization]]
