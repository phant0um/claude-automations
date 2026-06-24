---
title: "Better Experiments with LLM Evals — A funnel, not a fork"
type: source
source: "Clippings/Better Experiments with LLM Evals — A funnel, not a fork.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
LLM evals (juízes automatizados que avaliam relevância, coerência e qualidade em escala) e experimentos online (A/B tests) medem coisas diferentes e devem ser combinados como um *funil*, não como alternativas (*fork*): evals vêm ANTES do experimento, elevando a taxa de acerto do que se testa, e depois os resultados do experimento calibram os juízes — criando um loop de feedback que torna ambos mais inteligentes ao longo do tempo. Artigo da equipe de Data Science do Spotify (Spotify Engineering).

## Argumentos principais
- **Contexto Spotify**: apenas ~12% dos A/B tests terminam em resultado positivo "shipado"; ~64% produzem aprendizado válido (regressão capturada, hipótese refutada/refinada). A taxa de vitória subestima o valor da experimentação (referência: Spotify "Experiments with Learning").
- **Conceito de "evaluation funnel"** (Schultzberg & Ottens, 2024, arXiv:2404.08671): evals pertencem ANTES do experimento, não EM VEZ DELE. Um stack de evals forte não elimina o teste — você não testa para descobrir SE a mudança faz o que pretende (evals já disseram isso); você testa para validar que a mudança pretendida impulsiona o resultado de negócio para o qual foi desenhada, e para limitar o risco de prejudicar o negócio.
- **Verificação vs. validação** (distinção central de Schultzberg & Ottens):
  - **Evals verificam**: o output está conforme padrões de qualidade?
  - **Experimentos validam**: usuários reais respondem como previsto?
  - Evals descartam candidatos não promissores antes de consumirem orçamento de experimento — "elevam a taxa de acerto dos experimentos que seguem".
- **Evals também geram hipóteses**: exemplo — um juiz LLM construído para sinalizar conteúdo "trust-breaking" (ex.: recomendação compartilhada com usuário a quem não se encaixa) surfaceia padrões que o time não sabia procurar; esses padrões viram correções de produto; após o fix, o mesmo juiz verifica se funcionou (violações sinalizadas devem cair). O eval faz dois trabalhos: descobrir o que melhorar e confirmar que a melhoria foi realizada.
- **O que o eval NÃO pode dizer**: se usuários que receberam a versão melhorada tiveram outcomes melhores de fato — se o fix preveniu erosão lenta de confiança que leva a churn. Isso requer um experimento.
- **Guardrail metrics**: no Spotify, ~42% dos experimentos lançados são revertidos para prevenir regressão em métricas secundárias (duração de sessão caindo, crash rate subindo, retenção erodindo) — nenhum eval ou avaliação offline sinalizou isso. Eval mede qualidade de implementação em uma dimensão; experimento quantifica impacto em sistemas em produção e usuários finais.

## Key insights
- **Duas camadas de calibração, um loop de feedback**: evals são proxies — substituem um score por um outcome real (mesma dinâmica de "proxy metrics" já discutida no blog do Spotify sobre guardrails). LLM judges adicionam uma SEGUNDA camada de calibração sobre métricas quantitativas tradicionais (ranking scores, precision, recall). Ambas as camadas precisam de validação contra outcomes online; ambas podem "derivar" (drift).
- **Pergunta-chave de calibração**: quando o juiz LLM diz que a Variante A é melhor, ela de fato entrega melhor experiência de usuário, ou o juiz está recompensando padrões de superfície que não impulsionam outcomes?
- **Caso Opus 4.5 (Anthropic)**: os evals de coding da Qodo não mostraram melhoria no lançamento do Opus 4.5, mas o modelo havia melhorado substancialmente em tarefas longas — algo que um experimento controlado teria revelado. Conclusão: "miscalibration roda nos dois sentidos" — sem calibração offline-online, "nossos evals são opiniões, não evidências".
- **Tarefas de longa duração são difíceis de capturar com evals por construção**. O ajuste contínuo dos evals para melhorar o mapeamento com outcomes online os torna progressivamente melhores ferramentas de *verificação*; os autores não descartam que, no futuro, evals possam mapear bem o suficiente para atuar como *validações* — o loop de calibração offline/online dá transparência contínua sobre que papel os evals podem desempenhar conforme a IA evolui.
- **Fechando o loop — receita prática**:
  1. Rodar evals cedo e com frequência para encontrar os melhores tratamentos.
  2. Deixar o experimento validar que usuários/sistemas reais respondem como previsto, monitorando métricas que não foram otimizadas (guardrails).
  3. Nem toda mudança precisa do mesmo nível de evidência: testes direcionais rápidos para iteração/coleta de dados vs. testes rigorosos para decisões de "ship".
  4. Rodar os LLM evals sobre os próprios dados do A/B test: a versão que o juiz preferiu de fato performou melhor com usuários? Quando a lacuna entre scores de eval e outcomes de experimento é grande, isso é "ouro diagnóstico" — calibra o próximo ciclo.

## Exemplos e evidencias
- Spotify: 12% win rate em A/B tests, 64% "valid learning", 42% de rollback por guardrail metrics.
- Caso Opus 4.5 / Qodo: evals de coding não detectaram ganho real em tarefas longas (citando anthropic.com/engineering/demystifying-evals-for-ai-agents).
- Referências: Schultzberg & Ottens (2024, arXiv:2404.08671) sobre evaluation funnel; Ankargren (2025) sobre evidência experimental — "sucesso vem de fazer o básico bem em escala".

## Implicacoes para o vault
- Complementa diretamente `[[03-RESOURCES/concepts/agent-systems/llm-evaluation]]` e `[[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]` com o framework "funnel não fork" — útil para qualquer pipeline do vault que use LLM-as-judge (ex.: skills de revisão, eval de agentes).
- Relaciona-se com `[[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]]` — adiciona o conceito de "calibração offline-online" como requisito para confiar em juízes LLM, e o caso Opus 4.5 como exemplo concreto de miscalibration.
- Conecta-se ao princípio de `[[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]`: o "loop de calibração" descrito aqui é um caso aplicado de feedback loop entre métrica proxy (eval) e outcome real (experimento) — relevante para o autoloop descrito em `[[03-RESOURCES/sources/autoloops-spark-domain-chips]]` (eval como "produto", mas precisa ser calibrado contra outcomes reais para não enganar a si mesmo).
- Para o vault, reforça que skills de auto-revisão (ex.: `verify`, `review`, `hill`) deveriam, quando possível, ter um mecanismo de checagem contra outcomes reais (ex.: o usuário aceitou/rejeitou a sugestão), não apenas score interno do LLM.

## Links
- [[03-RESOURCES/concepts/agent-systems/llm-evaluation]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- [[03-RESOURCES/sources/autoloops-spark-domain-chips]]
