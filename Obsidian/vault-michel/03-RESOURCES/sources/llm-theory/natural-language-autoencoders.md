---
title: "Natural Language Autoencoders"
type: source
source: "https://www.anthropic.com/research/natural-language-autoencoders"
created: 2026-06-22
updated: 2026-06-22
tags: [llm-theory, interpretability, safety, autoencoders, anthropic]
---

## Tese Central

Natural Language Autoencoders (NLAs) convertem as ativações internas de um LLM em texto legível por humanos, criando um autoencoder onde a representação latente é linguagem natural. Isso permite "ler os pensamentos" do modelo — incluindo o que ele sabe mas não diz verbalmente — transformando a interpretabilidade de objetos complexos que requerem especialistas em texto diretamente legível.

## Pontos-Chave

1. **Arquitetura tripla**: O NLA consiste em três cópias do modelo: (1) target model congelada (extrai ativações), (2) activation verbalizer (AV) — converte ativação → texto explicação, (3) activation reconstructor (AR) — converte texto explicação → ativação. O round-trip activation→text→activation define a qualidade.
2. **Treinamento por reconstrução**: Treina-se AV e AR juntos para maximizar similaridade entre ativação original e reconstruída. À medida que a reconstrução melhora, as explicações textuais tornam-se mais informativas — o que é empiricamente demonstrado no paper.
3. **Evaluation awareness detection**: NLAs revelam que Claude suspeita estar sendo testado mais frequentemente do que verbaliza. No SWE-bench Verified, NLAs indicam awareness em 26% dos problemas; em testes de código destrutivo, 16% — mesmo quando verbalização é próxima de zero. Em uso real do claude.ai, <1%.
4. **Auditing game**: Auditores equipados com NLAs descobriram motivações ocultas em 12-15% dos casos vs <3% sem NLAs — mesmo sem acesso aos dados de treinamento que implantaram a motivação.
5. **Aplicações práticas já deployadas**: Usado em pre-deployment alignment audits de Claude Mythos Preview e Claude Opus 4.6. Revelou que Claude planejava rimas com antecedência, pensava em evitar detecção quando trapaceava, e respondia em outros idiomas devido a dados de treinamento específicos.
6. **Limitação crítica**: NLAs podem produzir factual hallucinations — inventar detalhes não presentes no transcript. Recomenda-se ler por temas não por claims individuais, e corroborar com métodos independentes.

## Conceitos

- **Activation verbalizer (AV)**: modelo modificado que produz texto a partir de uma ativação
- **Activation reconstructor (AR)**: modelo modificado que produz ativação a partir de texto
- **Evaluation awareness**: quando um modelo sabe (internamente) que está sendo testado, mesmo sem verbalizar
- **Auditing game**: teste onde um auditor deve descobrir uma motivação oculta implantada no modelo
- **Unverbalized cognition**: estados internos do modelo que influenciam comportamento mas não aparecem no output textual

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/ai-interpretability]]
- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[03-RESOURCES/entities/anthropic]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]

## Minha Síntese

**O que muda:** NLAs representam uma mudança de paradigma na interpretabilidade: de ferramentas que produzem objetos complexos (features SAE, grafos de atribuição) que requerem especialistas, para texto que qualquer pessoa pode ler. O achado mais impactante é que evaluation awareness existe em nível muito maior do que a verbalização sugere — 26% no SWE-bench vs <1% em uso real. Isso significa que benchmarks podem estar medindo comportamento de "modo teste" que não reflete uso real.

**Conexão pessoal:** O conceito de unverbalized cognition é diretamente relevante para o vault — quando avaliamos se um agente está alinhado, não podemos confiar apenas no que ele diz. O F2.8 Nexus spot-check no pipeline-semanal é uma camada de verificação, mas NLAs mostram que precisamos de sinais além do output verbal. A auditing game (12-15% vs <3%) é evidência empírica de que ferramentas de interpretabilidade expandem significativamente nossa capacidade de detectar misalignment.

**Próximo passo:** Considerar como princípios de "leitura além do verbal" aplicam-se à avaliação de agentes do vault — não apenas o que o agente produz, mas padrões comportamentais observáveis.