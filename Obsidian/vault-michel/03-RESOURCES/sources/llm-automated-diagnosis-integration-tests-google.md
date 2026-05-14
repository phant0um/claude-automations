---
title: "LLM-Based Automated Diagnosis Of Integration Test Failures At Google"
type: source
created: 2026-04-19
updated: 2026-04-19
tags: [google, llm, testing, integration-tests, auto-diagnose, gemini, devtools]
---

# LLM-Based Automated Diagnosis Of Integration Test Failures At Google

**Autores:** Celal Ziftci, Ray Liu, Spencer Greene, Livio Dalloro (Google, New York)
**Venue:** IEEE/ACM ICSE 2026 (preprint arXiv:2604.12108v1)
**Acesso:** https://arxiv.org/html/2604.12108v1

---

## Resumo

O paper apresenta **Auto-Diagnose**, ferramenta interna do Google que usa LLMs (Gemini 2.5 Flash) para diagnosticar automaticamente falhas em testes de integração. O sistema analisa logs de falhas, produz sumários concisos com as linhas mais relevantes, e é integrado ao **Critique** (sistema interno de code review do Google).

---

## Problema

- Testes de integração geram logs massivos, heterogêneos, com baixo signal-to-noise ratio
- Mediana de 16 arquivos de log e 2.801 linhas por teste com falha
- Em survey com 6.059 devs (EngSat), diagnóstico de falhas de integração = top 5 de reclamações
- Desenvolvedores gastam >1 hora (às vezes >1 dia) diagnosticando falhas de integração vs minutos em unit tests

---

## Arquitetura do Sistema

### Foco: Hermetic Functional Integration Tests
- **Hermética**: ambientes isolados, sem dependências externas
- **Funcional**: exercita lógica de negócio (não performance, segurança, reliability)
- Composição típica: **Test Driver** + **System Under Test (SUT)** com múltiplos componentes/servidores

### Pipeline Auto-Diagnose
1. Falha detectada → Auto-Diagnose notificado automaticamente
2. Logs coletados (test driver + todos os componentes SUT), em níveis INFO e acima, de múltiplos datacenters
3. Logs ordenados por timestamp em stream único
4. Prompt construído com template estruturado + logs + metadata de componentes
5. Enviado ao **Gemini 2.5 Flash** (temperature=0.1, top_p=0.8)
6. Resposta post-processada → finding publicado no Critique em markdown

### Parâmetros LLM
- **Modelo:** Gemini 2.5 Flash (velocidade + custo-eficiência)
- **Temperature:** 0.1 (respostas quasi-determinísticas)
- **Top-p:** 0.8 (alguma criatividade, sem tokens extremamente improváveis)
- Sem fine-tuning nos logs de teste — modelo puro

### Prompt Engineering
O template guia o modelo em 8 etapas com raciocínio step-by-step:
1. Escanear seções de log
2. Ler contexto (CONTEXT=) sobre componentes
3. Inspecionar seção de test failures
4. Sumarizar erros por componente
5. Inspecionar outras seções, considerar args de linha de comando
6. Conclusão sobre root cause
7. Verificar se tem informação suficiente (regras hard: não especular sem logs do componente falhante)
8. Se insuficiente: declarar o que falta

**Output estruturado:**
- `==Conclusion==` — o mais importante
- `==Investigation Steps==` — raciocínio
- `==Most Relevant Log Lines==` — com file, timestamp, callsite, conteúdo relevante

---

## Resultados

### Avaliação Manual (71 falhas reais, 39 times)
- **90.14% accuracy** (64/71 falhas corretamente diagnosticadas)
- 7 falhas incorretas: 4 por bug de infra (logs do test driver não salvos ao crash), 3 por bug similar em componentes SUT

### Produção (desde maio 2025)
| Métrica | Valor |
|---|---|
| Code changes analisados | 91.130 |
| Autores distintos | 22.962 |
| Testes distintos analisados | 52.635 |
| Execuções totais | 224.782 |
| p50 tempo para postar finding | 56 seg |
| p90 tempo para postar finding | 346 seg |
| Not-helpful-rate | **5,8%** (limite guideline: <10%) |
| Helpfulness-rate (H/H+N) | 62,96% |
| Rank helpfulness entre 370 tools | **#14 (top 3,78%)** |

### Tokens por execução
- Média input: 110.617 tokens
- Média output: 5.962 tokens

### User Interviews (11 participantes)
- Diagnóstico automático no workflow bem-recebido
- Experiência de usuário em Critique (in-context) é diferencial
- Desenvolvedores já esperam **fixes automáticos** (não só diagnóstico) — apetite por mais
- Sensibilidade alta a findings inúteis ("Not helpful" dentro do workflow irrita mais do que se o dev tivesse que procurar)

---

## Discrepância helpfulness: 90,14% vs 62,96%

Explicada pelo **negativity bias** (Rozin & Royzman, 2001): usuários reportam experiências negativas mais do que positivas. Feedback voluntário é disproportionalmente negativo. A avaliação manual (90,14%) é mais próxima da realidade.

---

## Trabalho Futuro

1. **Filtro de logs de passagem anterior:** remover log lines que aparecem em execuções bem-sucedidas (reduz ruído para LLM e devs)
2. **Auto-fix:** além de diagnóstico, produzir patches automáticos

---

## Referências Relacionadas

- [[03-RESOURCES/entities/Gemini-25-Flash]] — LLM usado
- [[03-RESOURCES/entities/Google-Critique]] — sistema de code review onde os findings são publicados
- [[03-RESOURCES/concepts/llm-test-failure-diagnosis]] — conceito central
- [[03-RESOURCES/concepts/integration-testing]] — contexto de testes
- [[03-RESOURCES/concepts/prompt-engineering-patterns]] — template estruturado em 8 etapas
