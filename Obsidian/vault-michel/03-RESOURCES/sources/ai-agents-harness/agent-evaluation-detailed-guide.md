---
title: "Agent Evaluation: A Detailed Guide"
type: source
created: 2026-05-18
updated: 2026-05-18
source_url: https://cameronrwolfe.substack.com/p/agent-evals
author: Cameron R. Wolfe, Ph.D.
published: 2026-05-17
category: ai-agents
tags: [ai-agents]
triagem_score: 8
---

# Agent Evaluation: A Detailed Guide

## Tese central

Avaliar agentes de IA requer harnesses realistas que testem o sistema como ele é usado em produção — benchmarks de perguntas estáticas não são suficientes para capturar capacidades sobre horizontes longos e interações com o ambiente.

## Key insights

- **Por que é difícil:** agentes operam em loops longos, interagem com o ambiente e têm complexidade/autonomia que benchmarks estáticos não capturam.
- **Definição operacional:** o agente mais simples é um LLM que usa ferramentas autonomamente dentro de um agentic loop — reasoning + tool calling + recuperação de erros + ação em nome do usuário.
- **Framework de avaliação:** harnesses de eval devem ser realistas (mesmo setup de produção), cobrir o loop completo (não apenas outputs individuais) e medir performance de forma rigorosa, não anedótica.
- **Multi-agent systems:** avaliação precisa ser componencial — cada agente individualmente e o sistema completo.
- **High-stakes domains:** coding e medicina são os dois casos de uso com maior adoção de agentes e maior necessidade de evals robustos.
- **Roadmap prático:** case studies de benchmarks recentes (SWE-bench, etc.) + guia para construir próprio harness de eval.
- Medir performance rigorosamente é o que permite melhorar rapidamente — evals substituem verificação anedótica.

## Por que benchmarks estáticos falham para agentes

Benchmarks tradicionais de ML (MMLU, HumanEval) medem resposta a uma pergunta em isolamento. Agentes operam em loops: a saída do passo 3 depende da ação tomada no passo 2, que dependeu de como o passo 1 interpretou o ambiente. Pequenos erros compostos se amplificam ao longo do horizonte. Um agente que pontua 90% em cada passo individual pode falhar em 70% dos tasks completos se os erros não são independentes.

## Harness realista: o que torna um eval válido

Um harness de eval para agentes deve:
1. **Replicar o ambiente de produção exato** — mesmo filesystem, mesmas APIs, mesmas ferramentas disponíveis
2. **Medir o loop completo** — não o output de um passo, mas se o objetivo foi alcançado
3. **Incluir recuperação de erros** — agentes que parecem bons podem estar mascarando falhas via retry excessivo
4. **Usar métricas determinísticas onde possível** — teste unitário passou/falhou é mais confiável que LLM-as-judge para outputs de código

## SWE-bench como referência de design de harness

O SWE-bench (e variantes SWE-bench Verified, SWE-bench Pro) demonstra as propriedades de um bom harness de eval para agentes de coding:
- Task definida por issue de GitHub real (ambígua, como produção)
- Solução medida por test suite existente (determinístico)
- Ambiente de execução isolado por task (sem contaminação entre runs)
- Métricas publicadas: pass@1, custo médio por task, tokens usados

O percentual de sucesso no SWE-bench correlaciona melhor com performance real em coding do que qualquer benchmark de pergunta-resposta.

## Avaliação de sistemas multi-agente

Quando múltiplos agentes colaboram, a avaliação precisa de dois níveis:
- **Componencial:** cada agente funciona corretamente quando chamado isolado?
- **Sistêmico:** o sistema completo completa o objetivo com a qualidade esperada?

Falhas sistêmicas que não aparecem nos testes componenciais geralmente são falhas de interface: o output do agente A não tem o formato que o agente B espera, ou o agente orchestrator toma decisões de delegação incorretas que nenhum agente individual causaria.

## Evals como substituto de verificação anedótica

O argumento central de Wolfe é que "parece funcionar nos meus testes" não é evidência de qualidade — é ausência de evidência negativa. Equipes sem harness de eval formal dependem de intuição e feedback de usuários (lento, custoso, não-replicável). Equipes com harness formal têm:
- Ciclo de feedback em minutos, não semanas
- Capacidade de detectar regressões antes de deploy
- Base objetiva para comparar versões de prompt ou modelo

## Limitações do framework

A abordagem de harness realista tem custos: cada task em ambiente real consome tokens reais, tempo real, e potencialmente tem efeitos colaterais reais (chamadas de API, writes em banco). Para tasks de alto custo por run (pesquisa extensiva, geração de documentos longos), é necessário balancear cobertura do harness com custo de execução. Uma estratégia comum é manter um conjunto pequeno de "golden tests" que rodam a cada mudança e uma suite completa que roda periodicamente.

## Como construir um harness de eval mínimo viável

Wolfe não provê um template de código, mas o argumento do artigo implica uma estrutura de cinco elementos que qualquer equipe pode implementar sem ferramentas especializadas:

1. **Task definitions em arquivos versionados.** Cada task é um diretório: `task.md` (enunciado), `setup.sh` (prepara o ambiente), `eval.sh` (verifica o resultado), `expected/` (outputs de referência quando aplicável). Versionar significa poder reexecutar exatamente a mesma eval depois de mudar o modelo ou o prompt.

2. **Ambiente isolado por task.** Cada task roda em seu próprio contexto — sem resíduo de tasks anteriores. Para coding agents, isso geralmente significa um container Docker por task. Para web agents, uma instância de browser fresh.

3. **Critérios de success determinísticos onde possível.** `eval.sh` retorna 0 (pass) ou 1 (fail). Quando o critério é inevitavelmente subjetivo (qualidade de escrita, completude de análise), LLM-as-judge com rubrica explícita como fallback — não como padrão.

4. **Logging estruturado de tokens, custo e tempo.** Sem isso, você não consegue detectar regressões de custo: um novo prompt pode manter a taxa de sucesso mas triplicar o uso de tokens.

5. **Golden test suite pequena para CI.** Um subconjunto de 10-20 tasks que roda em minutos, executa a cada mudança de prompt ou modelo. Suite completa roda semanalmente ou antes de releases.

## Evals como ferramenta de comunicação com stakeholders

Um uso sub-explorado de harnesses de eval é a comunicação com partes não-técnicas. Quando um manager pergunta "o agente está funcionando?", "parece funcionar nos meus testes" e "64% nas tasks de benchmark" são respostas com credibilidades fundamentalmente diferentes. O harness formal transforma a pergunta de qualitativa para quantitativa — e permite mostrar progresso ao longo do tempo em vez de apenas o estado atual.

Isso é particularmente relevante para o contexto do vault-michel onde agentes como Nexus executam tarefas que impactam toda a organização do knowledge base: ter um conjunto de tasks de referência (ingest correto, wikilinks válidos, hot.md atualizado) tornaria a qualidade auditável em vez de assumida.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
