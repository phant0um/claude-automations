---
title: "I looked at 1,680 Anthropic resumes. Here's who they actually hire."
type: source
source: "[@hiiinternet](https://x.com/hiiinternet/status/2065117819948437765)"
created: 2026-06-14
ingested: 2026-06-14
tags: [articles]
---

## Tese central

Análise de dados de 1.680 currículos do LinkedIn mostra quem a Anthropic de
fato contrata — spoiler: não é o estereótipo de "lab cheio de PhDs
pesquisando RL", e sim majoritariamente engenheiros sêniores de infra.

## Argumentos principais

Análise de 5.306 perfis de LinkedIn com "Anthropic" como empregador atual,
filtrados para 1.680 engenheiros, com 7.986 cargos anteriores analisados.

- **Crescimento explosivo recente**: só 15 engenheiros atuais estavam na
  empresa antes de 2021. 686 contratações em 2025, 455 já em 2026 (no
  ritmo). 53% do time de engenharia entrou nos últimos 12 meses. Mediana
  de tenure: 10 meses. Org gigante construída em ~18 meses.
- **Quase só sênior**: mediana de 12,2 anos de experiência pré-Anthropic
  (50% entre 8,8–16,5 anos). Apenas 50 dos 1.680 têm <3 anos. Contratação
  de new-grad é praticamente inexistente.
- **Infra > pesquisa**: infraestrutura aparece em 40% dos backgrounds;
  backend, distributed systems, databases e security em ~20% cada. RL
  (o "RL" de RLHF) aparece em só 3,3%. Skills: Python 585, Java 566,
  C++ 443, JS 376, SQL 302, Linux 230, Distributed Systems 189, AWS 154.
- **Maior feeder é o Google, não outros labs**: Google 405, Meta 273,
  Amazon 197, Microsoft 171, Stripe 124, Apple 87, Stanford 68,
  DeepMind 62, Airbnb 51, OpenAI 48. 50% do time tem FAANG no currículo.
  Anthropic também recebe diretamente de OpenAI (top-5 feeder direto) e
  DeepMind (top-6) — ~94 engenheiros migraram direto de outro lab
  fronteira.
- **O mito do PhD**: só 13,7% têm doutorado (1 em 7). Mediana é
  engenheiro sênior com bacharelado/mestrado, não pesquisador. Formação:
  CS 819, Matemática 78, Física 70, Eng. Computação 69. Filosofia entra
  no top-20 (13) — possível sinal de safety hires.
- **Universidades**: Stanford 144, Berkeley 118, MIT 80, CMU 73,
  Harvard 42, Cambridge 39, UW 36, Waterloo/Cornell 35 cada, Oxford 33,
  Princeton 32. As 4 primeiras = 1/4 da org.
- **Título único**: 80% têm o cargo "Member of Technical Staff" — desde
  ex-CTO do Instagram a fundadores da Adept e faculty de Stanford. Título
  é deliberadamente achatado para esconder senioridade/função.
- **A única porta para "júniores"**: 172 engenheiros com <6 anos de
  experiência, 50 com <3. Dois arquétipos, quase sem mid-level comum:
  - Pipeline de estágios (50% fizeram internship em Meta, Google,
    DeepMind, Microsoft, Amazon, Jane Street, Two Sigma, HRT, Optiver,
    Nvidia).
  - "Quant to lab": 9% vieram de trading shops de elite (Jane Street,
    Two Sigma, Five Rings, HRT, Optiver, Citadel) — perfis de
    matemática/CS de competição vindos de HFT.
  - Alignment fellowships (MATS, SERI, Redwood, ARC): 6%, quase exclusivo
    de júniores.
  - Arquétipo "limpo": MIT + medalha de prata na IOI + 2900+ no
    Codeforces direto para RL/safety com 4 anos de experiência —
    selecionados por ranking de competição e papers, não tenure.

## Key insights

"If you want to join Anthropic as an engineer, stop writing your resume
for a research lab and write it for an infra company." A imagem pública
de "lab cheio de PhDs" é majoritariamente falsa no nível de engenharia —
o perfil real é engenheiro sênior de infra de hyperscaler/empresa
infra-heavy (Stripe, Databricks, Snowflake, Palantir), com 12 anos de
experiência e <1 ano na empresa.

## Implicações para o vault

Útil para calibrar expectativas sobre o que labs como a
[[03-RESOURCES/entities/anthropic|Anthropic]] valorizam (infra/sistemas >
credenciais de pesquisa pura) — relevante para contexto de carreira/mercado
de trabalho em IA.

Ver também [[03-RESOURCES/sources/32-principles-of-a-viral-product]] —
ambos são ensaios de 2026-06 sobre "como o mercado realmente funciona vs.
o que se assume", um sobre hiring em IA, outro sobre produto/growth.

## Links

- [I looked at 1,680 Anthropic resumes (@hiiinternet)](https://x.com/hiiinternet/status/2065117819948437765)
