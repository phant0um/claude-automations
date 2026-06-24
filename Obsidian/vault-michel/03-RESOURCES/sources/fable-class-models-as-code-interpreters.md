---
title: "Fable-class models as English-to-code interpreters (rahul, X thread)"
type: source
source: "Clippings/rahul on X \"1. as a mental model it is more correct to think of fable+ class models as english -> code interpreters - converts your idea into code into \"correct\" code regardless of problem complexity and output complexity (diff size). Fable 5 wi.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Modelos de classe Fable devem ser entendidos como "interpretadores de inglês para código" — convertem ideias em código "correto" independentemente da complexidade do problema ou do tamanho do diff de saída. Isso muda fundamentalmente onde o trabalho humano de valor está: não em escrever código, mas em gerenciar risco e revisar em escala, e o tempo de "ship" de software se desacopla completamente do tempo de produzir o PR.

## Argumentos principais
- Mental model central: pense em modelos classe Fable+ como interpretadores inglês→código, que convertem a ideia em código correto independente de complexidade de problema/output. O autor prevê que o Fable 5 será o **pior** modelo dessa nova classe (ou seja, a classe só vai melhorar a partir daqui).
- O tamanho/complexidade do diff deve ser gerenciado puramente para fins de revisão: diffs pequenos em áreas de alto risco (auth/identidade/acesso a dados/acesso a rede/movimentação de dinheiro); diffs grandes aceitáveis em código que pode ser verificado empiricamente (frontend, plumbing de backend, código sem acesso a rede/banco, código de performance verificável empiricamente).
- O tempo para "shippar" software está completamente desacoplado do tempo para produzir o PR — quanto tempo o trabalho leva depende inteiramente da capacidade de revisar/mergear código gerenciando risco em escala, não da velocidade de geração.
- Resolver os bottlenecks de revisão importa enormemente: linters, testes, CI, verificação em shadow mode, verificação empírica — são esses sistemas que determinam a velocidade real do loop, não a geração de código em si.
- Agência importa enormemente: quais são os maiores bottlenecks para acelerar o loop e eliminá-los, quais problemas precisam ser resolvidos e quando, o que é necessário para resolver tudo isso hoje.
- Entendimento profundo do full-stack importa enormemente para decisões de delegação: que problemas vale perseguir, se há um nível de abstração mais alto a endereçar primeiro, se deve-se dar ao modelo a subtarefa, a tarefa, ou a tarefa completa; quais são os maiores riscos de um PR em ordem de importância (falha de segurança > falha de correção > falha de performance); se existe uma forma mais rápida de produzir dados que permita merge; se deve rodar em shadow, sandbox, ou atrás de uma flag.
- O custo da complexidade está mudando: pode valer a pena "manter" 50% mais código por um ganho de performance de 5%; abstrações corretas importam menos porque refatorações grandes ficam menos tediosas com agentes; "nits" de qualidade de código se tornam um grande arrasto desnecessário; é provável que um modelo muito mais inteligente vá manter seu código no futuro, então vale acumular mais dívida técnica agora — reconstruir/arquitetar sistemas manualmente hoje tem um custo enorme de velocidade.
- Para casos de baixo risco, pode ser mais sensato tratar pedaços de código (serviços/funções) como caixa-preta — como se faz com redes neurais — e fazer só verificação empírica: o código produziu output correto nas últimas 10/100/1000/10k entradas? pode-se colocar esse código em quarentena (sem acesso de saída a rede/banco)? o que acontece se estiver errado — hack, crash, inconveniência? é interno ou externo?
- Eventualmente, a verificação lógica (revisão linha a linha) virá a um custo enorme — deve ser reservada para onde realmente importa, construindo sistemas tolerantes à verificação empírica. Bugs de correção são significativamente mais fáceis de corrigir que bugs de acesso/permissão.
- "Rails" para iteração mais rápida: permissões de código podem ser opt-in (escrita em banco, leitura em banco, egress de rede para onde, acesso a PII); quanto tempo leva para obter dados de shadow mode; quantos PRs podem ser testados; quais são as categorias de diff.

## Key insights
- A reação mais citada no thread (de Boris Cherny) resume o consenso: "estamos entrando na próxima era do código, onde o modelo consegue gerar código correto para uma porcentagem cada vez maior de tarefas — nosso trabalho é garantir que o modelo e nossos sistemas tenham os guardrails certos."
- Um adendo importante de outro respondente: "traces provam comportamento observado, não intenção" — documentar a solução primeiro (com agentes) e apontar revisões automatizadas para essa documentação; não se pode revisar permissões sem uma fonte de verdade (ex: um `permissions.md`).
- Discordância registrada no thread: nem todo mundo concorda com "não se preocupar com dívida técnica" — um respondente argumenta que é fácil colocar loops de limpeza no workflow para sempre estar "capinando o jardim", o que facilita o trabalho de agentes no código depois.
- Outra discordância: alguém questiona se isso é verdade apenas "se você quer manter humanos no loop" — para quem não espera isso permanecer verdadeiro conforme os modelos melhoram, a pergunta "por que ter revisão humana se o LLM é melhor que você eventualmente" é levantada como contraponto extremo.

## Exemplos e evidências
- Thread original no X por @rahulgs, 17/06/2026, com respostas de Boris Cherny e outros membros da comunidade de engenharia de IA.
- Citação cruzada a um artigo de Paweł Huryn ("Agentic Engineering for PMs: Review Artifacts, Not Code") descrevendo um PM que shippou 3 projetos sem ler código, revisando artefatos em vez disso — citado como evidência paralela de que revisão de artefato/documentação substitui revisão linha a linha em alguns contextos.

## Implicações para o vault
- Esta fonte é a articulação mais densa e específica do vault sobre o tema "verificação empírica vs. lógica" em código gerado por agente — conecta-se fortemente a `verification-driven-development` e `llm-as-a-verifier`, mas adiciona a dimensão de **gestão de risco por categoria de diff** (alto risco = diff pequeno + revisão linha a linha; baixo risco = diff grande + verificação empírica de caixa-preta), que parece nova e vale uma nota dedicada.
- O ponto sobre dívida técnica intencional ("vale manter 50% mais código por 5% de performance, porque um modelo mais inteligente vai mantê-lo") é uma tese contrária a práticas de engenharia de software tradicionais — vale registrar como contraponto explícito em `clean-code` ou criar nota própria sobre "técnica debt economics in the agent era", já que há discordância documentada no próprio thread.
- Conecta-se a `agent-governance` e `claude-code-security`: o framework de "rails" (permissões opt-in por categoria de acesso) é uma instância prática de design de guardrails para agentes autônomos.

## Links
- [[03-RESOURCES/concepts/learning-cognition/verification-driven-development]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-security]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance]]
- [[03-RESOURCES/concepts/dev-foundations/clean-code]]
