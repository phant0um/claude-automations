---
title: "Post @dunik_7 — Regra no CLAUDE.md que cortou 30% dos gastos"
type: source
source_file: Clippings/Post by @dunik_7 on X.md
origin: post no X (@dunik_7)
ingested: 2026-05-14
tags: [claude-md, token-efficiency, cost-reduction, ai-workflow]
triagem_score: 7
---

# Post @dunik_7 — Regra no CLAUDE.md que cortou 30% dos gastos

> [!tip] Insight central
> Uma única regra de 5 palavras no CLAUDE.md — "quando incerto, pare e pergunte" — cortou 30% da conta do Claude ao eliminar o modo padrão de "vou descobrir" que gasta 8.000 tokens iterando.

## A regra

```
"quando incerto, pare e pergunte. nunca gaste tokens adivinhando."
```

**Efeito:** o modelo para de iterar autonomamente sobre incertezas e pede clarificação em 2 linhas de conversa em vez de 8.000 tokens de tentativa-e-erro.

## Insight complementar

> "O token mais barato é aquele que o Claude não escreveu porque perguntou primeiro."

Contexto: @dunik_7 menciona que 40% do código que o Claude escreve é desperdiçado (reescrita), citando um arquivo markdown de 65 linhas com 120.000 stars no GitHub que resolve isso.

## Conexões

- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]]
- [[03-RESOURCES/concepts/claude-code-tooling/claudemd-self-improvement-loop]]
- [[03-RESOURCES/entities/dunik-7]]

---

## Por que funciona: o mecanismo cognitivo

O comportamento padrão de um LLM sem instrução explícita é preencher lacunas autonomamente — é o que o treinamento por RLHF incentiva: respostas completas e úteis, mesmo quando o contexto é ambíguo. Isso é ótimo para produtividade em tarefas claras, mas catastrófico quando há ambiguidade real de requisito.

A regra "quando incerto, pare e pergunte" reescreve o incentivo: torna o comportamento de clarificação explicitamente recompensado no contexto da sessão. O modelo passa de "tente resolver" para "sinalize incerteza primeiro".

O efeito de 8.000 tokens → 2 linhas de conversa se explica porque:
1. Sem clarificação, o modelo explora múltiplos caminhos possíveis (tentativa-e-erro)
2. Com clarificação, o espaço de busca colapsa para a solução correta antes da geração

## O arquivos de 65 linhas com 120k stars

O @dunik_7 referencia um arquivo markdown de 65 linhas que teria resolvido o problema de 40% de código desperdiçado (reescrita). Embora não seja nomeado explicitamente no post, trata-se provavelmente do padrão de CLAUDE.md com regras de comportamento explícitas — formato que o próprio vault usa.

O que torna um CLAUDE.md de 65 linhas eficaz é a densidade de regras acionáveis por linha. Regras vagas ("seja cuidadoso") não têm efeito. Regras com critério concreto ("quando incerto, pare e pergunte. nunca gaste tokens adivinhando") mudam comportamento porque o modelo pode verificar sua aplicabilidade.

## Impacto no custo real

A economia de 30% mencionada traduz-se em termos concretos:

- Usuário Pro ($20/mês): economiza energia cognitiva e tempo, não dinheiro direto — mas evita o limite de mensagens
- Usuário API (pay-per-token): 30% de redução de tokens = 30% de redução de custo. Em $100/mês de gastos, economiza $30/mês = $360/ano
- Empresa com $10k/mês em Claude API: $3k/mês de economia com uma regra de 10 palavras

A regra tem ROI infinito: custo de implementação = 10 palavras no CLAUDE.md.

## Generalização do princípio

A regra "pare e pergunte" é um caso especial de um princípio mais amplo: **explicit uncertainty signaling**. Outras variações eficazes:

```
"Se não tiver certeza do escopo, liste suas suposições antes de implementar."
"Se houver mais de uma interpretação possível, apresente as opções antes de escolher."
"Nunca apague código existente sem confirmar que é desnecessário."
```

Cada uma dessas regras elimina uma categoria específica de retrabalho caro.

## Aplicação no vault (CLAUDE.md deste vault)

O vault já implementa a versão deste princípio: "Se ambíguo: declare sua suposição explicitamente e pergunte antes de agir." A regra do @dunik_7 é mais agressiva — "nunca gaste tokens adivinhando" — e pode ser incorporada como regra explícita para tarefas de ingestão em lote onde o escopo é frequentemente ambíguo.

## Anti-padrão: excesso de clarificação

A regra pode ser aplicada de forma disfuncional: o modelo para para pedir confirmação em tarefas triviais, adicionando fricção sem reduzir erros. O equilíbrio correto é: perguntar sobre **incerteza de requisito**, não sobre **incerteza de implementação**. O modelo deve decidir como fazer; deve perguntar sobre o quê fazer quando ambíguo.

## Evidência empírica: o que acontece sem a regra

Sem instrução explícita, o comportamento padrão de Claude em ambiguidade de requisito é documentável:

1. **Escolhe a interpretação mais plausível** — baseada em padrões do treinamento, não no contexto específico do usuário
2. **Executa completamente** — não interrompe no meio para confirmar; entrega um output completo baseado na interpretação escolhida
3. **Reporta no final** — às vezes indica qual interpretação foi usada, às vezes não
4. **Usuário descobre a discrepância** — lê o output, percebe que estava errado, solicita correção
5. **Ciclo de retrabalho** — Claude regera baseado na correção, frequentemente com novos equívocos de detalhes

Cada iteração desse ciclo consome tokens, tempo do usuário, e gera frustração crescente. A regra do @dunik_7 corta o ciclo no ponto de custo mínimo: **antes da primeira geração**.

## Variações de implementação

A regra "quando incerto, pare e pergunte" pode ser ajustada para diferentes contextos:

**Para desenvolvimento de software:**
```
Antes de implementar: se houver mais de uma abordagem válida, 
liste as 2-3 principais com prós/contras e espere escolha.
Nunca inicie implementação com arquitetura assumida em tarefas >30 minutos.
```

**Para análise e pesquisa:**
```
Se o escopo da análise for ambíguo, declare os limites que você 
está assumindo antes de analisar. Pause se os limites forem substanciais.
```

**Para ingestão de fontes (vault):**
```
Se a categorização ou destino de uma fonte for ambíguo, 
pergunte antes de criar páginas ou modificar estrutura existente.
```

Cada variação adapta o princípio ao domínio específico, tornando-o mais acionável.

## Interação com o comportamento de Opus 4.7

A regra ganha importância adicional com Opus 4.7. O modelo 4.7, mais literal que 4.6, tende a seguir a primeira instrução plausível sem inferência adicional de intenção. Isso significa que ambiguidades no prompt são agora **mais** problemáticas — o modelo vai executar o que foi pedido literalmente, mesmo que a intenção fosse diferente.

A combinação "quando incerto, pare e pergunte" + comportamento literal do 4.7 cria um sistema robusto: o modelo não infere incorretamente nem executa cegamente — pergunta antes. Ver [[03-RESOURCES/sources/skills-prompting-mcp/you-prompt-claude-wrong-rubenhassid]] para o contexto completo das mudanças de 4.7.

## Referências internas adicionais

- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — gerenciamento de contexto como disciplina
- [[03-RESOURCES/sources/token-economy-cost/arceyul-10-trucos-tokens-claude]] — 10 técnicas complementares de economia de tokens
- [[03-RESOURCES/sources/guides-courses-howtos/claude-code-context-commands-2026-04-17]] — comandos de contexto como versão operacional deste princípio
- [[03-RESOURCES/sources/skills-prompting-mcp/you-prompt-claude-wrong-rubenhassid]] — mudanças de 4.7 que amplificam a importância desta regra
