---
title: "30 Powerful LLMs You Can Run for Free in 2026"
type: source
created: 2026-06-23
updated: 2026-06-23
tags:
  - ai-agents
  - llm
  - open-source
  - open-weight
  - self-hosting
  - source
---

# 30 Powerful LLMs You Can Run for Free in 2026

**Source:** [X post by @exploraX_](https://x.com/exploraX_/status/2069352534280376665) · Published 2026-06-23

## Central Thesis

Every "free LLM" list collapses two completely different things into one word. There's **free as in someone else runs the model** (Google, Groq, OpenRouter hand you an API key at no cost) and **free as in the weights cost nothing and you bring the hardware** (you download Qwen or Llama and run it on your own machine). These aren't variations — they're opposites. The hosted route bills you in your data (most free tiers train on what you send). The self-host route is fully private but costs VRAM and electricity.

The useful question is never "what's free" — it's "free in which sense, and what's the hidden cost."

## Critical Distinctions

### Open-Weight vs Open-Source

- **Open-weight**: weights are downloadable. You can run, fine-tune, deploy. That's it.
- **Open-source**: weights + training code + data + recipe are all public. You could rebuild the model from scratch.

Almost everything called "open-source AI" is actually just open-weight. Of the 20 model families listed, **only OLMo (Allen AI)** is fully open-source by that strict definition. Maybe two if generous about Granite.

### License Traps

- **Llama**: open-weight but 700M-monthly-active-user cap
- **Command R**: downloadable but non-commercial — free to tinker, not free to build a business on
- **Gemma**: license restricts using it to train competing models

### Self-Hosting Hardware Reality

Rule of thumb: **~0.6 GB VRAM per 1B parameters at Q4_K_M** (4-bit quantization, ~95% quality preserved).

- 8B model → 8GB card (cheap)
- 32B model → 24GB card (used 3090 is the value pick)
- 70B model → two 24GB cards or 64GB Mac
- **MoE trap**: memory tracks total params, not "active" count. A model advertising "17B active" can still demand 55GB.

Apple Silicon counts unified memory as VRAM (32GB Mac ≈ 24GB GPU).

## Open-Weight Families — Free to Self-Host (20)

### Chinese-Origin

1. **Qwen (Alibaba)** — Apache 2.0. Most versatile family; 0.6B edge to 200B+ MoE flagships. Strong multilingual, toggleable thinking mode. Note: newest Qwen3.7 Plus/Max went closed/API-only. Pick: Qwen3 8B (entry, ~5.5GB) or 27B/32B (power, ~18GB).

2. **DeepSeek** — MIT. Reasoning-heavy, returns chain-of-thought. Real R1 is 671B MoE (datacenter only, ~370GB). Small "r1:7b/14b" are distillations. Pick: R1 distill 14B or 32B.

3. **GLM / ChatGLM (Z.ai/Zhipu)** — MIT. GLM-5.x leads open coding rankings. Large MoE (744B class) at top, smaller GLM-Edge for consumer hardware. Pick: GLM-Edge (entry/mid).

4. **Kimi K2 (Moonshot)** — Modified MIT. Frontier coding, trillion-param MoE (~32B active). Needs ~550GB+. Datacenter/multi-GPU only.

5. **MiniMax M3** — Open-weight. Multimodal (text+image+video), 1M context, MSA architecture. Datacenter-class.

6. **Yi (01.AI)** — Apache 2.0. Bilingual Chinese/English, 6B/9B/34B, 200K context. Development has slowed. Pick: Yi 9B or 34B.

7. **Baichuan** — Chinese open-weight, enterprise focus. Mixed licensing. Pick: 7B-13B.

8. **InternLM (Shanghai AI Lab)** — Open releases, strong reasoning/long-context. Pick: 7B-20B.

9. **Ernie (Baidu)** — Some open releases, mixed licensing. Verify per-model.

10. **Hunyuan (Tencent)** — Open releases exist, mixed licensing. Verify per-model.

### Western / Other

11. **Llama (Meta)** — Open-weight, not OSI open-source. 700M MAU cap. Most downloaded family. Llama 4 Scout offers 10M-token context. Pick: Llama 3.x 8B (entry) to 70B (workstation).

12. **Gemma (Google)** — Runs on modest hardware. Gemma 3/4 add vision and tool calling. Gemma 4 12B fits 16GB; 26B MoE ~85 tok/s on consumer hardware. License restricts fine-tuning for competing models.

13. **gpt-oss (OpenAI)** — Apache 2.0. Not served through OpenAI API. 20B is the "16GB sweet spot"; 120B needs ~60-65GB.

14. **Mistral / Devstral** — Apache 2.0 (shift from earlier restrictive licensing). Small 4 packs Devstral agentic coding into ~6B-active. Mistral Small 24B owns function-calling/JSON niche.

15. **Phi (Microsoft)** — MIT. Small reasoning models (~1.5B-14B). Phi-4-mini runs on a mini PC without discrete GPU.

16. **Nemotron (NVIDIA)** — Open-weight, efficient inference. Hybrid architectures (Mamba layers).

17. **OLMo (Allen AI)** — Apache 2.0. One of only two truly open-source families (weights + training code + data + checkpoints). Research-grade. Largest ~32B. Pick: OLMo 2 7B/13B.

18. **Falcon (TII, UAE)** — Falcon license (based on Apache 2.0). Free under $1M revenue, 10% royalty above. Falcon-H1: hybrid SSM+attention, 256K context, 1B-34B.

19. **Granite (IBM)** — Apache 2.0, enterprise/RAG-focused. Small long-context MoE (1B-3B) plus 8B-70B. Runs on Apple Silicon down to 16GB.

20. **Command R (Cohere)** — Open weights, non-commercial license. Free for personal/research; needs commercial license otherwise. Tiny Aya 3.35B is also CC-BY-NC, 70+ languages.

## Free Hosted Platforms — No Hardware Needed (10)

**Catch: most train on your data unless stated otherwise; only self-hosting is fully private.**

21. **Google AI Studio (Gemini)** — Best free access to frontier closed model. ~1,500 requests/day on Gemini Flash, no credit card, no expiry. 1M context. Free-tier prompts may train Google's models.

22. **Groq** — Fastest free option. Runs open-weight models on LPU at 300+ tok/s. ~30 req/min, 1,000/day on 70B. Clearer no-training policy.

23. **Cerebras** — Very fast open-weight inference on wafer-scale chips. Generous free tier, no-training policy.

24. **OpenRouter** — Widest variety through one key. 25+ permanently free models (filter with `:free` suffix). No credit card. Failover routing. Clear no-training option.

25. **GitHub Models** — Free for development inside rate limits. Mixed catalog (OpenAI, Llama, Mistral, DeepSeek). Good for GitHub/Copilot workflow.

26. **Cloudflare Workers AI** — Edge inference, 10,000 neurons/day free. Good for serverless apps.

27. **Mistral (La Plateforme)** — Free developer/experiment tier. Catch: Experiment tier requires opting into training for 1B-tokens/month quota.

28. **Hugging Face Inference** — Thousands of models; serverless limited to models under ~10GB. Best for trying unusual or brand-new models.

29. **NVIDIA NIM** — Hosted open models with free tier, but generally requires billing setup. Treat as trial, not permanent-free.

30. **Together AI** — Free models plus ~$1-25 signup credits. Credits are a trial, not permanent free tier.

## Key Insight

> "Sort the whole landscape by 'free in which sense, and what's the hidden cost' and it stops being a wall of names and starts being a decision."

Canonical living list of current quotas: GitHub repo `cheahjs/free-llm-api-resources` — limits shift weekly, verify before building.