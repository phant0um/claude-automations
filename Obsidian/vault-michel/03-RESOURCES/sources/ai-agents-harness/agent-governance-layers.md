---
title: Agent Governance Layers
type: source
source: Clippings/Agent Governance Layers.md
created: 2026-05-15
ingested: 2026-05-15
tags: [ai-agents]
triagem_score: 8
---

## Tese central
Governança por camadas (Intent Boundary + Policy + Audit) cria o sistema de controle ao redor do agente — capacidade sem governança = caos caro.

## Key insights
- Falhas em produção raramente são por modelo ruim; são por fronteiras de autoridade indefinidas (delete prod, push .env).
- Layer 1 = Intent Boundary: documento separado define mandato, fora-de-escopo e gatilhos de escalonamento — referenciado pelas demais camadas.
- Smarter agents tornam governança mais crítica, não menos: ambiguidade vira dano proporcional à capacidade.

## As três camadas em detalhe

### Layer 1 — Intent Boundary
Documento separado (não embutido no system prompt) que define três coisas:
1. **Mandato**: o que o agente está autorizado a fazer
2. **Fora de escopo**: o que explicitamente não faz, mesmo que tecnicamente possível
3. **Gatilhos de escalonamento**: condições que exigem intervenção humana antes de prosseguir

O fato de ser documento separado — não inline no prompt — é intencional: permite atualização sem tocar no prompt principal, permite auditoria independente, e é referenciado pelas camadas 2 e 3 como autoridade.

### Layer 2 — Policy Layer
Regras operacionais que implementam o Intent Boundary em termos concretos. Exemplos:
- "Nunca escrever em produção sem aprovação explícita do operador"
- "Notificar via Slack antes de qualquer delete que afete > 10 arquivos"
- "Rate limit: máximo 5 chamadas de API externa por minuto"

A policy layer é onde hooks e permissões são configurados. Cada regra da policy deveria mapear para uma regra específica no Intent Boundary — se não mapeia, provavelmente não deveria existir.

### Layer 3 — Audit Layer
Logging de todas as ações com contexto suficiente para reconstruir a cadeia de decisão:
- Qual input levou à ação
- Qual ferramenta foi chamada com quais argumentos
- Qual foi o resultado
- Se houve deviation do comportamento esperado

Sem audit layer, análise post-mortem de falhas em produção depende de memória humana ou recriação do cenário.

## Por que agentes mais capazes exigem mais governança

Um agente que só consegue ler arquivos e responder perguntas tem superfície de risco baixa — o pior que pode fazer é responder errado. Um agente que pode escrever em produção, chamar APIs externas, criar usuários, ou modificar permissões tem superfície de risco proporcional à sua capacidade. A relação é direta: capability × ambiguidade = potencial de dano.

O erro mais comum em times de produto é copiar o Intent Boundary de um agente de baixo risco para um agente de alto risco sem revisar os gatilhos de escalonamento. O agente de baixo risco pode ter "pergunte ao usuário quando incerto" como gatilho — o agente de alto risco precisa de "pergunte ao operador antes de qualquer ação irreversível."

## Falhas reais por ausência de governança

Os dois exemplos mencionados — "delete prod" e "push .env" — representam classes de erro diferentes:
- **delete prod**: ação irreversível em escopo não autorizado (ausência de boundary no mandato)
- **push .env**: exfiltração de dados sensíveis via canal não monitorado (ausência de política de output)

Ambos acontecem não porque o modelo é impreciso, mas porque a fronteira de autoridade não foi definida explicitamente. O agente estava tecnicamente "seguindo as instruções" — as instruções simplesmente não cobriam o caso.

## Aplicação no vault-michel

O vault-michel opera com um Intent Boundary implícito no CLAUDE.md: operações destrutivas requerem confirmação, edições fora do escopo da task devem ser reportadas não executadas, git push requer confirmação explícita. A formalização dessas regras como Layer 1 documentado (separado do CLAUDE.md de instruções) seria a próxima evolução de maturidade do sistema.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-md-cost-optimization]]

---

## Por Que Governança é uma Questão de Engenharia, Não de Confiança

O erro mais comum ao pensar sobre governança de agentes é enquadrá-la como "quanto confio no agente". Isso é a pergunta errada. A pergunta correta é: "qual é a superfície de risco das ações que o agente pode executar, e as fronteiras de autoridade cobrem todos os casos nessa superfície?"

Um agente perfeitamente "confiável" — que sempre segue instruções corretamente — ainda pode causar dano se as instruções não cobrirem casos extremos. O agente que faz push de um `.env` não está sendo desonesto: está executando o que foi instruído (compartilhar o arquivo) sem saber que aquele arquivo específico é sensível. A falha é da governança (ausência de política de output), não do modelo.

### A Separação Intent Boundary / Policy é Estrutural

Por que o Intent Boundary deve ser um documento separado e não parte do system prompt? Três razões:

1. **Ciclos de atualização diferentes:** O system prompt muda a cada iteração de produto. O Intent Boundary muda quando o mandato do agente muda — muito mais raramente. Misturar os dois significa que o Intent Boundary é involuntariamente alterado quando o produto evolui.

2. **Auditoria independente:** Um advogado, auditor de segurança, ou stakeholder não-técnico pode revisar o Intent Boundary sem entender o system prompt. A separação habilita revisão por pessoas com expertise diferente.

3. **Referência cruzada explícita:** Cada regra na Policy Layer deveria poder apontar para o item do Intent Boundary que a justifica. Se uma regra de policy não tem justificativa no Intent Boundary, provavelmente não deveria existir.

### Modelando Falhas com a Taxonomia de 3 Camadas

A taxonomia de 3 camadas permite diagnóstico sistemático de falhas:

**Falha de Layer 1 (Intent Boundary ausente ou incompleto):** O agente age em escopo não coberto. Sintoma: "o agente fez X, que nunca pedimos que fizesse, mas em algum sentido foi uma extensão lógica do que pedimos." Exemplo: agente de análise de dados que começa a fazer modificações no banco porque "isso tornaria a análise mais precisa."

**Falha de Layer 2 (Policy inadequada):** O Intent Boundary cobre o caso mas as regras operacionais não o endereçam concretamente. Sintoma: "sabíamos que o agente não deveria fazer isso, mas não escrevemos uma regra que o impedisse." Exemplo: Intent Boundary diz "não modificar produção sem aprovação", mas a Policy não define o que conta como "produção" vs. "staging".

**Falha de Layer 3 (Audit ausente):** A ação aconteceu, a política foi violada, mas não temos como reconstruir o que aconteceu. Sintoma: "algo deu errado mas não sabemos como reproduzir ou exatamente o que o agente fez." Isso transforma cada falha em mistério em vez de aprendizado.

### Gatilhos de Escalonamento: Onde Mais Sistemas Falham

O elemento mais frequentemente negligenciado do Intent Boundary é a lista de gatilhos de escalonamento — condições que exigem intervenção humana antes de prosseguir. Times tendem a ser específicos sobre o mandato ("o agente pode fazer X, Y, Z") e vagos sobre escalation ("pergunte ao usuário quando incerto").

"Quando incerto" é inútil como gatilho. Incerteza não é binária e o agente não tem calibração perfeita sobre sua própria incerteza. Gatilhos efetivos são concretos e observáveis:

- "Quando o conjunto de arquivos afetados excede 50"
- "Quando a ação requer criar ou deletar uma entidade em produção"
- "Quando o estado resultante da ação não é facilmente reversível"
- "Quando o custo estimado da operação excede $X"

Esses gatilhos podem ser verificados por código (não apenas por raciocínio do agente), o que os torna mais confiáveis.

### Audit Layer: Requisitos Mínimos

Um Audit Layer que suporte análise de post-mortem real precisa de pelo menos:

- **Input completo:** exatamente o que o usuário ou sistema enviou ao agente
- **Chain de raciocínio:** os passos de pensamento que levaram à decisão (se acessível)
- **Ferramenta chamada:** nome, argumentos exatos, resultado
- **Resultado para o usuário:** o que o agente devolveu ou fez
- **Timestamp:** quando cada ação ocorreu (para correlacionar com outros sistemas)
- **Session ID:** para agrupar ações relacionadas numa análise

Sem esses campos, o log existe mas não habilita reconstrução. "O agente chamou uma ferramenta às 14:32" sem os argumentos da ferramenta é arqueologia incompleta.

### Governança Progressiva: Começar Simples

Para times começando com governança de agentes, a sequência correta não é implementar as 3 camadas completamente desde o início. A sequência de maturidade:

1. **Nível 0:** Nenhuma governança formal — agente roda livre
2. **Nível 1:** Intent Boundary simples — lista de "nunca faça isso" (5-10 itens)
3. **Nível 2:** Policy básica — regras concretas para as ações de mais alto risco
4. **Nível 3:** Audit básico — log de todas as ferramentas chamadas com argumentos
5. **Nível 4:** Sistema completo — Intent Boundary formal, Policy completa, Audit com rastreabilidade total

Pular de Nível 0 para Nível 4 é tentador mas arriscado — o custo de implementar governança que ninguém usa é igual ao custo de governança efetiva, mas sem o benefício. Governança progressiva alinha custo com risco real observado.
