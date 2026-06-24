---
title: "The 5 Principles Every AI Research Stack Now Has to Solve"
type: source
author: "@AlphaSignalAI"
published: 2026-05-22
ingested: 2026-05-28
tags: [source, ai-research, automation, verification, governance, multi-agent, reliability]
source_url: "https://x.com/AlphaSignalAI/status/2057867718632550782"
---

# The 5 Principles Every AI Research Stack Now Has to Solve

## Tese central

O campo da pesquisa científica com AI deixou de ser limitado por capacidade e passou a ser limitado por confiabilidade. O problema não é mais geração — é verificação, proveniência e handoffs humanos. A survey "AI for Auto-Research" (Lingdong Kong et al., 20 autores, arXiv mai/2026) mapeia 250+ ferramentas, 52 benchmarks, 33 sistemas end-to-end em 4 fases e 8 estágios.

## Key insights

### Os 5 Princípios

1. **Tarefas estruturadas funcionam; julgamento aberto não:** SWE-bench 76%+ vs. ResearchCodeBench 37-39% (semantic error rate 58.6%) — mesmos modelos, tetos diferentes
2. **Geração supera verificação em todos os estágios:** os artefatos parecem validados porque parecem completos — o risco não é inutilidade, é tratá-los como verdade
3. **Colaboração humano-governada vence autonomia total:** 89% de melhoria em reviews quando LLM dá feedback em draft humano (22.467 reviews, ICLR 2025); mesmo modelo avaliando sozinho: 95.8% de falso-positivo
4. **Sistemas que funcionam convergem em 3 camadas: explore, execute, verify:** sweet spot empírico de 3-4 agentes coordenados; swarms maiores acumulam overhead de comunicação mais rápido que ganham qualidade
5. **AI em pesquisa é problema de governança, não de detecção:** 17.5% de abstracts de CS com modificação AI detectável; watermarking falha sob paráfrase; política deve seguir disclosure + accountability

### Dados adicionais
- AI Scientist v2: $25/paper, nota 6.33 (threshold ICLR: 5.69)
- FARS: $1.000/paper (40x mais caro), nota 5.05 (abaixo do threshold)
- Track autônomo MLR-Bench: 80% dos resultados fabricados
- 3 problemas em aberto: phase-boundary faithfulness, citation provenance, cognitive ownership

## Implicações para o vault

- Reforça a arquitetura de verificação humana nos fluxos do vault
- O padrão explore-execute-verify aparece em [[03-RESOURCES/concepts/agent-systems/agent-harness]] como camadas fundamentais
- Sweet spot 3-4 agentes coordenados é dado empírico valioso para design de multi-agent systems

## Links

- Paper: "AI for Auto-Research: Roadmap & User Guide" (arXiv, mai/2026)
- Repo: worldbench/awesome-ai-auto-research (MIT)
- Relacionado: [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]]
- Relacionado: [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
