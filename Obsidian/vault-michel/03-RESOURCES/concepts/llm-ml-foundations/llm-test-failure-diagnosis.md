---
title: LLM-Based Test Failure Diagnosis
type: concept
status: developing
created: 2026-04-19
updated: 2026-04-19
tags: [llm, testing, debugging, devtools, google, auto-diagnose]
---

# LLM-Based Test Failure Diagnosis

Uso de Large Language Models para diagnosticar automaticamente falhas em testes de software, especialmente testes de integração com logs massivos e heterogêneos.

---

## Problema Central

Testes de integração falham gerando logs complexos:
- Múltiplos arquivos de log (mediana: 16 por falha)
- Milhares de linhas (mediana: 2.801 por falha)
- Formato heterogêneo (cada componente tem suas convenções)
- **Baixo signal-to-noise ratio** — erros recuperáveis aparecem em nível ERROR/WARNING

O diagnóstico manual é a atividade mais custosa em tempo: >1 hora na maioria dos casos, às vezes >1 dia. Não escala.

---

## Por Que LLMs Funcionam Aqui

LLMs são naturalmente proficientes em:
1. **Processamento de texto** — leem logs heterogêneos sem parsers específicos
2. **Sumarização** — extraem sinal do ruído
3. **Raciocínio step-by-step** — identificam causalidade em sequências de eventos
4. **Generalização zero-shot** — sem fine-tuning, entendem logs de qualquer sistema

> Contraste com abordagens tradicionais (SBFL, delta debugging): requerem instrumentação específica e parsing rules por componente — overhead contínuo de engenharia.

---

## Auto-Diagnose (Google, 2025)

Implementação de referência desta abordagem em produção.

**Sistema:** [[03-RESOURCES/sources/ml-research-papers/llm-automated-diagnosis-integration-tests-google]]

**Arquitetura:**
- Falha detectada → logs coletados de todos os datacenters
- Logs ordenados por timestamp → stream unificado
- Prompt com template estruturado (8 etapas de raciocínio) + logs + context
- Gemini 2.5 Flash (temp=0.1) → diagnóstico estruturado
- Finding publicado no Critique (code review system) em <56 seg (p50)

**Resultados em produção:**
- 90,14% accuracy (avaliação manual, 71 falhas)
- 5,8% not-helpful-rate (abaixo do limite de 10%)
- #14 em helpfulness entre 370 ferramentas no Critique (top 3,78%)
- 52.635 testes distintos diagnosticados

---

## Padrões de Prompt Engineering

O template do Auto-Diagnose estabelece padrões importantes para este domínio:

1. **Raciocínio step-by-step explícito** — o modelo é instruído a mostrar seu processo
2. **Negative constraints estritas** — "MUST NOT draw conclusions" sem logs suficientes; "MUST NOT speculate"
3. **Output formatado estruturalmente** — Conclusion / Investigation Steps / Most Relevant Log Lines
4. **Log lines como links** — post-processamento converte em links navegáveis
5. **Context injection** — metadata dos componentes SUT no prompt (para entender CLI args)

---

## Princípio de Design: Integração no Workflow

O sucesso do Auto-Diagnose se deve em parte à integração **automática e in-context** no Critique:
- Developer não precisa iniciar a ferramenta — ela roda ao falhar
- O finding aparece no mesmo lugar onde o dev já está (code review)
- Reduce context-switching para zero

> Desenvolvedores são **altamente sensíveis a findings inúteis quando entregues automaticamente no workflow** — o limiar de tolerância é mais baixo que quando eles buscam a ferramenta.

---

## Evolução Esperada

Padrão observado em entrevistas: após adotar diagnóstico automático, devs esperam **fixes automáticos**. A progressão natural é:
1. Diagnóstico de root cause (Auto-Diagnose, 2025)
2. Sugestão de fix (próxima fase)
3. Patch automático com validação

Ver também: [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] para implementações mais avançadas de repair.

---

## Relacionados

- [[03-RESOURCES/concepts/dev-foundations/integration-testing]] — contexto
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — padrões de prompt
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — logs como contexto injetado
- [[03-RESOURCES/entities/Gemini-25-Flash]] — modelo usado pelo Auto-Diagnose
- [[03-RESOURCES/entities/Google-Critique]] — plataforma de integração
