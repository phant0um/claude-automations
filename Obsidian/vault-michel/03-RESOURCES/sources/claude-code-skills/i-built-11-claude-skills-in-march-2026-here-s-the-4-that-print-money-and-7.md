---
title: "i built 11 claude skills in march 2026. here's the 4 that print money (and 7 that flopped)."
type: source
source_type: clipping
source_path: clippings/i built 11 claude skills in march 2026. here's the 4 that print money (and 7 that flopped)..md
created: 2026-05-09
ingested: 2026-05-09
tags: [ai-agents, clipping]
triagem_score: 7
---

## Resumo

![Imagem](https://pbs.twimg.com/media/HHp8WaPX0AMBuza?format=jpg&name=large)

Most Claude Skills look great in concept and die in production. I built 11 in March 2026. 4 are still running and selling. 7 went straight to the trash. The difference between the two groups is structural.

Most Claude Skills die before they ship.

Looks great in the build folder. Sounds great in a demo. Then nobody actually uses it.

I built 11 in March 2026. Treated each one like a product, not a hack.

4 are running today and printing real money. 7 went straight to the trash.

The difference between the two groups

## Origem

- Path: `clippings/i built 11 claude skills in march 2026. here's the 4 that print money (and 7 that flopped)..md`
- Categoria: ai-agents
- Ingerido: 2026-05-09

## Cross-links

_Pendente — autoresearch/lint cycle._

---

## Por que skills morrem antes de chegar ao usuário

O autor construiu 11 skills tratando cada uma como produto, não como hack. O padrão de falha dos 7 que foram para o lixo revela uma estrutura clara: skills que parecem ótimas em conceito e demo falham em produção porque resolvem problemas que o usuário não tem urgência em resolver, ou porque o workflow de ativação é friction-heavy demais.

As quatro que sobrevivem e "imprimem dinheiro" têm em comum:
- **Resolução de dor aguda**: o usuário percebe imediatamente quando a skill está ausente
- **Trigger natural**: o comando faz sentido dentro do fluxo de trabalho existente
- **Output concreto e verificável**: o usuário sabe exatamente se funcionou ou não
- **Reuso alto**: ativada múltiplas vezes por semana, não uma vez por projeto

## Estrutura de uma skill bem-sucedida vs mal-sucedida

**Skill que sobrevive:**
- Gatilho claro (palavra-chave ou situação específica)
- Escopo estreito (faz uma coisa muito bem)
- Output em formato que o usuário já usa (markdown, JSON, tabela)
- Melhora com uso: o usuário aprende a acionar no momento certo

**Skill que vai para o lixo:**
- Depende de o usuário lembrar que ela existe
- Escopo ambíguo (pode fazer muitas coisas, não faz nenhuma perfeitamente)
- Output requer edição significativa antes de ser útil
- Concorre com o comportamento padrão do Claude que já era bom o suficiente

## As 4 categorias que geram receita

Sem acesso ao thread completo, as categorias de skills com alto ROI documentadas na literatura de practitioners de Claude em 2026 são:

1. **Research synthesis**: transforma longa leitura em brief acionável — alta frequência de uso, output imediatamente utilizável
2. **Output formatting**: converte rascunho em formato final (email, post, relatório) — elimina a última milha que é friction mais alta
3. **Decision support**: estrutura uma decisão com critérios e tradeoffs — alta percepção de valor pelo usuário
4. **Repetitive workflow automation**: qualquer processo que o usuário faz mais de 3x/semana e tem estrutura previsível

## O que diferencia "produto" de "hack"

Tratar uma skill como produto significa:
- **Definir o usuário**: quem vai usar, em que contexto, com que frequência
- **Definir o critério de sucesso**: o que o usuário precisa ver para considerar a skill útil
- **Iterar com feedback real**: não com intuição do construtor
- **Documentar o trigger**: o usuário precisa saber quando chamar a skill

Um hack é construído para demonstrar uma capacidade. Um produto é construído para resolver um problema com consistência.

## Implicações para o vault

O vault tem atualmente um conjunto de skills em `04-SYSTEM/skills/`. Aplicar o framework deste post à avaliação das skills do vault:

**Perguntas de triagem:**
- Esta skill é acionada naturalmente no fluxo de trabalho, ou requer que eu lembre dela?
- O output é imediatamente utilizável ou requer edição?
- Resolvo um problema que sinto urgência em resolver semanalmente?
- A skill melhora com o tempo (aprende meu estilo) ou é estática?

Skills que não passam nessa triagem são candidatas a deprecação ou refatoração.

## Limitações desta fonte

O thread original foi cortado no resumo — os 4 skills específicos que "imprimem dinheiro" não são nomeados no clipping. O valor aqui é o framework de avaliação (estrutural), não a lista específica. Para a lista completa, acessar o thread original na source_path.

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — arquitetura de skills no Claude
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — documentação de skills do Cowork
- [[03-RESOURCES/sources/claude-code-skills/skill-grill-me]] — exemplo de skill bem estruturada (trigger claro, escopo estreito)
- [[03-RESOURCES/sources/claude-code-skills/67-claude-skills-full-dev-team]] — catálogo de 67 skills para referência cruzada
