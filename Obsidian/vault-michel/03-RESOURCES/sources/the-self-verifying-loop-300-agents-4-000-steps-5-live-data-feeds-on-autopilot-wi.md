---
title: "The Self-Verifying Loop: 300 agents, 4,000 steps, 5 live data feeds on autopilot with Kimi K2.6"
type: source
source: "Clippings/The Self-Verifying Loop: 300 agents, 4,000 steps, 5 live data feeds on autopilot with Kimi K2.6.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, loop-engineering]
---

## Tese central
Swarms grandes de agentes (300 agentes) sozinhos não resolvem confiabilidade — volume escala output e erro na mesma taxa ("mais mãos, mais erros"). A solução é tornar verificação um estágio de primeira classe num loop fechado: Opus 4.8 planeja e verifica, swarm Kimi K2.6 executa, qualquer output que não confira com a fonte é rejeitado e devolvido à fila — loop só para quando nada mais falha.

## Argumentos principais
- "Um swarm sem verificador tem uma única configuração de qualidade: a do pior agente" — se 97 de 100 agentes acertam e 3 alucinam, o relatório final contém 3 minas terrestres e parece idêntico a um perfeito.
- Arquitetura de 4 estágios em ciclo (não linha): planejar → executar → verificar → re-enfileirar o que falhou — repete até a verificação não ter mais nada a rejeitar.
- O checklist usado na verificação (ex.: "revenue+margin de feed ao vivo, URL de fonte resolvível, valor bate com fonte dentro de tolerância, nenhum campo vazio") é definido no próprio prompt inicial — é a parte mais importante do prompt, porque é o que a etapa de verify usa para rejeitar trabalho depois.

## Key insights
- "Mais agentes escala output E erro na mesma taxa" é um contra-argumento direto e quantificado contra qualquer instinto de "rodar mais subagentes em paralelo" como solução de qualidade — relevante diretamente para o batch ingest deste próprio pipeline, que processa 65 fontes sequencialmente sem swarm, mas se algum dia adotar paralelismo massivo precisa do mesmo estágio de verify.
- Checklist de verificação embutido no prompt original (não inventado depois) é o mesmo princípio do F3.5 deste pipeline (self spot-check com critério definido a priori, não ad hoc).

## Exemplos e evidências
- Teste concreto: análise de 100 empresas do mercado EV, com matriz comparativa e todo dado rastreado a fonte viva; vídeo demonstrando o loop rejeitando e reprocessando itens falhos.

## Implicações para o vault
Confirma (3ª fonte com esse tema na leva, junto com as 3 fontes de "loop engineering") que separar execução de verificação é padrão consolidado — reforça candidato a meta-padrão F3.6 "separar execução de avaliação", agora com evidência adicional de escala (300 agentes).

## Links
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/sources/loop-engineering-build-an-ai-that-codes-while-you-sleep]]
