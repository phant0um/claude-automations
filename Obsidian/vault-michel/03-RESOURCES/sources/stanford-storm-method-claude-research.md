---
title: "The Stanford STORM Method: How to Make Claude Research Like a PhD in Minutes"
type: source
source: "Clippings/The Stanford STORM Method How to Make Claude Research Like a PhD in Minutes.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
STORM (Synthesis of Topic Outlines through Retrieval and Multi-perspective Question Asking), método de pesquisa publicado pela Stanford OVAL Lab no NAACL 2024, pode ser replicado dentro do Claude com apenas 4 prompts copy-paste, sem nenhuma ferramenta externa — comprimindo um trabalho de pesquisa de 40-60 horas de leitura humana em cerca de 5 minutos.

## Argumentos principais
- Um único prompt ("me conte sobre X") retorna apenas a visão majoritária/superfície do tópico — perde o praticante, o cético, o economista, o historiador e o acadêmico, cada um vendo algo diferente.
- O paper de Stanford comprovou numericamente: artigos construídos a partir de múltiplas perspectivas são **25% mais organizados e 10% mais amplos em cobertura** do que artigos de pesquisa convencional de prompt único — essa é a tese central do método.
- O método tem 4 fases via prompt:
  1. **Multi Perspective Scan** — simula 5 perspectivas de especialista (praticante, acadêmico, cético, economista, historiador), cada um respondendo: posição central, evidência mais forte, e o que diria que nenhuma outra perspectiva diria.
  2. **Contradiction Map** — identifica onde as 5 vozes se contradizem, qual perspectiva tem evidência mais forte/fraca, qual pergunta resolveria a maior contradição, o que todas concordam (provavelmente verdadeiro), e que tópico nenhuma abordou (o blind spot do campo, achado mais valioso).
  3. **Synthesis** — sintetiza tudo em um briefing: resumo de um parágrafo nível CEO, 5 principais findings ranqueados por confiabilidade, a conexão oculta entre achados, o insight acionável, e a pergunta de fronteira que mudaria tudo.
  4. **Peer Review** — Claude avalia seu próprio trabalho: scores de confiança 1-10 por finding, o elo mais fraco, checagem de viés (qual perspectiva dominou a síntese), perspectiva ausente, e nota final como se um professor de Stanford revisasse.
- STORM tem uma fraqueza conhecida apontada pelos próprios pesquisadores de Stanford: não se autocritica — viés de fonte e má associação de fatos se infiltram. O Prompt 4 (Peer Review) existe especificamente para corrigir isso.
- O workflow completo dura 5 minutos: minuto 1 (5 perspectivas), minutos 2-3 (mapa de contradições), minutos 3-4 (briefing de síntese), minuto 5 (peer review com score de confiabilidade).

## Key insights
- "Se todas as 5 perspectivas concordam, é provavelmente verdade. Se nenhuma abordou um tópico, você acabou de achar a lacuna do campo todo."
- A contradição entre perspectivas é onde a compreensão real vive — a maioria das pessoas pula a etapa de mapeamento de contradições, e é exatamente essa etapa que separa entendimento superficial de expertise real.
- O ferramental aberto existe (storm.genie.stanford.edu, github.com/stanford-oval/storm, MIT license) mas o "prêmio real" é que você não precisa de nenhuma ferramenta: o método é apenas uma forma de pensar replicável dentro de qualquer chat do Claude.
- Estamos numa "janela de 18 meses": quem aprender a pesquisar com IA corretamente vai pensar muito melhor do que quem não aprender — não por serem mais inteligentes, mas por rodarem 5 perspectivas, mapa de contradições, síntese e peer review enquanto o resto lê o primeiro resultado do Google. Em 18 meses esse workflow estará embutido em toda ferramenta e a vantagem desaparece.

## Exemplos e evidências
- Publicado no NAACL 2024 pela Stanford OVAL Lab.
- Resultado quantitativo do paper: +25% organização, +10% amplitude de cobertura vs. método de pesquisa padrão de prompt único.
- 7 casos de uso sugeridos: antes de escrever artigo/relatório, antes de decisão de negócio importante, antes de entrevista de emprego, antes de investir, antes de aprender nova skill, antes de negociação, antes de apresentação.
- Comparação de tempo: 40-60 horas de leitura humana (PhD) vs. 5 minutos com os 4 prompts.

## Implicações para o vault
- É um padrão de **prompt engineering estruturado em múltiplas perspectivas** que complementa diretamente conceitos já existentes de `prompt-chaining` e `prompt-engineering-patterns` — aqui especificamente como técnica de pesquisa, não de geração de código/conteúdo.
- A etapa de "Peer Review" (Claude avalia o próprio output) é uma instância concreta de `llm-as-a-judge` / `llm-as-a-verifier` aplicada à própria saída do mesmo modelo, sem segundo modelo — vale registrar como variante "self-judge" desses conceitos.
- Conecta-se à filosofia de "spec drives quality" presente no artigo sobre swarms (self-improving-loop-300-agent-swarm-kimi): ambos defendem que estruturar o prompt em fases definidas supera o prompt único genérico.

## Links
- [[03-RESOURCES/concepts/learning-cognition/prompt-chaining]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]]
- [[03-RESOURCES/entities/Claude]]

## Minha Síntese

**O que muda:** Posso aplicar o método STORM (4 prompts: scan multi-perspectiva, mapa de contradições, síntese, peer review) diretamente em pesquisas para FIAP ou decisões de concurso, em vez de usar prompts únicos que só retornam a visão de superfície.

**Conexão pessoal:** Aplicável tanto em pesquisa técnica (ADS @ FIAP) quanto em decisões estratégicas sobre o vault/sistema de agentes — qualquer pergunta onde vale o custo de uma resposta mais cara e mais checada.

**Próximo passo:** Testar o método completo (4 prompts em sequência) na próxima pesquisa de tópico complexo do FIAP ou de arquitetura de agentes, salvando o resultado como template reutilizável.
