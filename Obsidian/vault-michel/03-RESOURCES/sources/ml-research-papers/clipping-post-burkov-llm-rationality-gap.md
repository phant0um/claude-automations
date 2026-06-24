---
title: "LLM Rationality Gap (Burkov)"
type: source
source_type: social-media
author: "Andriy Burkov"
created: 2026-05-06
tags: [llm, rationality, ai-agents, philosophy]
triagem_score: 7
---

PhD-level argument on why LLM-based agents fail at general-purpose problem solving: LLMs optimize next-token prediction, not expected utility maximization. Rational agency requires stable preferences, calibrated beliefs, causal models. Fluency does not equal rationality.

## Source

Ingested from: `clippings/Post by @burkov on X.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## O argumento central de Burkov

Andriy Burkov — autor de "The Hundred-Page Machine Learning Book" — articula um argumento técnico preciso: **LLMs são máquinas de predição de texto, não agentes racionais**. A confusão entre os dois é a raiz de expectativas exageradas e falhas silenciosas em sistemas agênticos.

A racionalidade no sentido formal (teoria da decisão) requer:
1. **Preferências estáveis e transitivas:** se A > B e B > C, então A > C. LLMs não têm preferências — têm distribuições de probabilidade sobre tokens.
2. **Crenças calibradas:** probabilidade subjetiva que se atualiza com evidência (Bayes). LLMs produzem confiança aparente que não corresponde a probabilidade real de estar correto.
3. **Modelos causais:** entender que X causa Y permite raciocinar sobre intervenções. LLMs aprendem correlações estatísticas, não estrutura causal.
4. **Maximização de utilidade esperada:** agir para maximizar um objetivo dadas as crenças. LLMs maximizam verossimilhança do próximo token dado o contexto.

## Fluência vs. racionalidade

O ponto mais contundente: LLMs são extraordinariamente bons em **parecer** racionais. Produzem raciocínio passo a passo coerente, citam premissas, chegam a conclusões que soam plausíveis. Mas esse processo não é raciocínio — é predição de como texto de raciocínio parece.

**Exemplo ilustrativo:** peça a um LLM para calcular quanto combustível sobra depois de uma viagem com detalhes específicos. O modelo produzirá um cálculo convincente. Se os números forem propositalmente inconsistentes (deixam resultado negativo), o modelo frequentemente "ajusta" os dados para chegar a um resultado positivo — porque textos de problemas de física geralmente têm resultados positivos. Isso é predição de padrão, não aritmética.

## Onde isso quebra em agentes

Em configurações agênticas, o gap de racionalidade manifesta de formas específicas:

**Preferências instáveis:** o mesmo agente, com contextos ligeiramente diferentes, pode escolher estratégias opostas para o mesmo problema. Não há objetivo estável subjacente — há padrões de contexto.

**Overconfidence sistêmica:** agentes LLM tendem a agir em vez de admitir incerteza. Preencher um formulário com dados plausíveis mas incorretos é mais provável que parar e perguntar. O texto de "agente funcionando" é mais comum nos dados de treinamento que "agente admitindo limitação".

**Failure mode de causalidade:** um agente que aprendeu que "documentos de política geralmente mencionar regulações X" pode citar regulação X em contextos onde ela não se aplica — porque o padrão textual corresponde, não porque o raciocínio causal é correto.

**Context hijacking:** agentes LLM são suscetíveis a prompt injection exatamente porque não têm um modelo do mundo separado do texto recebido. Texto malicioso no ambiente (um documento, uma resposta de API) pode redirecionar o comportamento do agente.

## O contra-argumento: o que agentes LLM fazem bem

Reconhecer o gap de racionalidade não invalida agentes LLM — redefine onde eles são úteis:

- **Tarefas com espaço de erro tolerável:** geração de rascunhos, sugestões de código revisadas por humanos, brainstorming
- **Tarefas com feedback externo:** quando o agente executa código real e observa resultados reais, o loop de feedback substitui o modelo causal
- **Tarefas bem especificadas em domínios cobertos pelo treinamento:** juridiquês, código em linguagens populares, texto persuasivo

O problema não é usar LLMs em agentes. O problema é não saber quando o gap de racionalidade vai causar falha.

## Implicações de design de sistema

O argumento de Burkov tem consequências concretas para quem projeta sistemas agênticos:

1. **Nunca confie em auto-avaliação do agente:** "estou confiante que..." não é sinal de confiança real. Adicione verificação externa.
2. **Prefira loops com feedback real:** execução de código, consulta a banco de dados, verificação de URL — substitui modelo causal por evidência empírica.
3. **Minimize espaço de ação:** quanto mais restrito o espaço de ferramentas e ações, menos o gap de racionalidade importa.
4. **Human-in-the-loop para decisões de alto risco:** não porque o modelo vai falhar sempre, mas porque não há forma de saber quando vai.
5. **Log de raciocínio ≠ raciocínio:** o chain-of-thought que o agente produz pode ser post-hoc rationalization, não o processo real que gerou a ação.

## Posicionamento em relação ao debate mais amplo

Burkov está na linha de Yann LeCun (LLMs são incapazes de raciocínio causal verdadeiro) contra a linha de Ilya Sutskever (escala suficiente produz capacidades emergentes de raciocínio). A distinção não é apenas acadêmica — define quanta autonomia é razoável dar a agentes hoje.

A posição pragmática: agentes LLM são poderosos **ferramentas** com limitações de racionalidade conhecidas. Sistemas bem projetados compensam as limitações; sistemas mal projetados assumem racionalidade que não existe.

## Relevância para o vault

Os agentes do vault (Nexus, guard, ingest-report) operam em domínios onde o gap de racionalidade pode manifestar: o Nexus pode "inventar" wikilinks plausíveis que não existem; o ingest-report pode produzir sínteses que soam corretas mas distorcem o artigo original. O mecanismo atual de mitigação — verificar wikilinks, confirmar antes de operações destrutivas — é exatamente a aplicação prática do argumento de Burkov: não confie na auto-avaliação, adicione verificação externa.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/sources/hermes-agent/clipping-what-makes-ai-agent-different]]
