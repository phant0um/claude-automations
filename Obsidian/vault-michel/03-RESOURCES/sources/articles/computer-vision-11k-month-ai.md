---
title: "How to Make $11,000 a Month with Computer Vision Using AI"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://x.com/ridark_eth/status/2069392944252022788"
author: "@ridark_eth"
published: 2026-06-23
grade: A
tags: [articles, computer-vision, business, freelance, yolo, bytetrack, supervision, roboflow, ai-assistants, source]
---

# How to Make $11,000 a Month with Computer Vision Using AI

**Tese central**: Computer vision comercial (counting, tracking, speed estimation, sports analytics) é acessível sem programação prévia usando stack YOLO + ByteTrack + Supervision + Roboflow + AI assistants. Mercado de $22B (2024) → forecast $111B (2033). Renda via freelancing internacional (Upwork) em dólares — money vem mais rápido de clients para finished work que de offer de big corporation.

## Part 1 — O que é e por que pagam

Computer vision: computador "olha" foto/vídeo e entende objetos, posição, movimento, quantidade. Mesmo que olho+cérebro humano, mas automático e across qualquer número de câmeras.

4 tarefas comerciais reais (não toy tutorials):
- **Counting objects** → warehouses, inventory, stock control
- **Tracking people/vehicles** → stores (visitor count), roads (traffic)
- **Speed estimation** → traffic enforcement, road/site safety
- **Sports analytics** → player tracking, match breakdown (huge industry)

Businesses que pagam: retail, security, road traffic, manufacturing (defect control), agriculture, sports, logistics.

Por que alguém sem degree/programação consegue agora:
1. Ready-made tools que já "veem" (não precisa inventar)
2. AI assistants que escrevem e corrigem código

Path B (freelancing + turnkey projects) é o mais rápido. Path A (full-time engineering job) é mais difícil — interviews pedem code live, AI não corta sozinho.

## Part 2 — Stack em plain language

- **YOLO** → o "olho". Modelo pronto que encontra objetos e desenha box com label ("person", "car"). Download com uma linha.
- **ByteTrack** → a "memória". Links objects entre frames, assigna IDs persistentes. Sem isso não dá para count ou measure movement.
- **Supervision** → o "kit de construção". Library de blocks prontos: boxes, counting line, zones, count crossings. Transforma "model sees objects" em "program counts entries/exits".
- **Roboflow** → plataforma quase no-code. Browser: label com mouse, train em clicks, get API. Roboflow Universe: milhares de modelos pré-treinados.
- **Google Colab** → "computador na nuvem" gratuito com GPU. Sem PC poderoso, sem install.
- **AI assistant** (Claude, ChatGPT, Gemini) → "seu programador". Para app real: **Cursor** (editor onde AI escreve quase tudo).

**Pipeline**: Video → YOLO (detect) → ByteTrack (track/ID) → Supervision (count by line/zone) → resultado (annotated video + numbers). Tudo em Colab, código por AI. Objetos non-standard → train em Roboflow.

## Part 3 — Como trabalhar com AI (skill principal)

Skill real não é Python — é **explicar claramente a task para AI e montar as peças**. Golden rule: qualquer erro no Colab → copy in full e hand to AI → fixa para versão atual da library. Versions mudam, code quebra — normal. Nunca lute com erro sozinho.

Prompt templates (90% das tasks):
- Adapt script: "Here's a working Python script [paste]. I'm not a programmer. Change it so it counts only people. Return full, complete code."
- Fix error: "I ran this in Colab [paste] and got this error: [paste full]. Fix for current version, return full corrected version."
- Understand: "Explain in plain words, no jargon, what this script does and what I'll see as output."
- Tune video: "Help me set counting line coordinates for 1280×720 video, horizontal through center."
- Build feature: "Based on this script, add counting separately by type: cars vs trucks. Return full code."
- Write text: "Write short English description of visitor-counting project for GitHub: problem, solution, tech, how to run."

Mistakes comuns: dar snippet em vez de código inteiro, escrever "doesn't work" em vez de error text, editar à mão random. **Sempre checar resultado** — AI pode produzir code que roda mas conta errado.

## Part 4 — Primeiro código em Google Colab (5 min)

1. colab.research.google.com → New notebook
2. Cell vazia = onde code vai. ▶ para run.
3. Paste Script 0 (install) → ▶ → wait 20-60s
4. Get test video: `download_assets(VideoAssets.PEOPLE_WALKING)` ou `files.upload()`
5. Paste script (ex: Script 3), fix input name, ▶
6. Download: `files.download("output_count.mp4")`

Troubleshooting: "No such file" → nome não bate. Slow → Runtime → Change runtime type → GPU. Red error → golden rule.

## Part 5 — Script kit pronto

- **Script 0** (install): `!pip install ultralytics supervision -q`
- **Script 1** (detect + label): YOLO + BoxAnnotator + LabelAnnotator → boxes com labels e confidence
- **Script 2** (tracking com IDs): + ByteTrack → cada objeto ganha #ID persistente
- **Script 3** (counting line crossings — o comercial): LineZone com Point(x,y) → count in/out. Filter por class (0=person). Save counts to txt.

Tasks mais complexas → hand to AI:
- Vehicle speed estimation (YOLO + supervision + perspective setup)
- Counting dentro de área (PolygonZone em vez de line)
- Custom objects → label em Roboflow, train, plug no Script 3

## Part 6 — Portfolio: 3 projetos que vendem

Portfolio > degree no mercado internacional. 3 demos para nichos reais.

Free videos: Supervision sample, Pexels, Pixabay.

3 projetos:
1. **Visitor counting for store** — Script 3 + people filter + line na entrada. Vende para: retail, cafés, malls.
2. **Counting/tracking cars** — Script 3 em road/parking footage. Vende para: parking operators, road services, traffic analytics.
3. **Custom object via Roboflow** — label non-standard (bottles, defects), count. Vende para: manufacturing, warehouses, agriculture.

Packaging: record 10-30s demo video, GitHub com README (AI escreve), optional live demo em Hugging Face Spaces ou Roboflow API.

## Part 7 — Clients e pricing

Plataforma main: **Upwork**. Headline = narrow specialty: "Computer Vision Engineer → Object Detection, Tracking & People/Vehicle Counting".

Overview template (English): "I build computer vision systems that detect, track, and count objects in video → people counting for retail, vehicle counting for traffic, custom detection for manufacturing. Stack: YOLO, ByteTrack, Supervision, Roboflow, Python. Working solutions with annotated video + exportable counts."

Primeiros 3-5 jobs abaixo do market ($30-45/hr vs $60+) para reviews. Depois raise rate.

Proposal structure: "I understand → I've built exactly this → how and for how much." Free test no client's short clip → seals the deal.

Questions up front: o que contar, origem do video (file/camera/RTSP), output (video/table/dashboard/alerts), accuracy, deadline, budget.

Prices:
- **Hourly**: start $30-45 → junior $50-80, middle $80-120, senior $120-200+. Median ML freelance ~$100/hr.
- **Per project**: simple counting $300-1500; serious systems from $5k; market reaches $250k+.
- **Upwork fee**: 0-15%, usual ~10%.

Crescer: Toptal (top-3% screening, higher rates), Fiverr (productized service).

## Part 8 — Plano 90 dias

| Período | O que fazer | Resultado |
|---------|-------------|-----------|
| Semana 1 | Colab + Scripts 1-3 em test video | Code works |
| Semanas 2-3 | 3 demos em vídeos próprios, clips gravados | Demos prontos |
| Semana 4 | GitHub + packaging English (AI) | Portfolio online |
| Semana 5 | Upwork profile + primeiras proposals | Proposals enviadas |
| Semanas 6-10 | 10-20 proposals/semana + free tests | Primeiro job + review |
| Semanas 11-13 | Deliver, collect reviews, raise rate | Primeiro money, rate ↑ |

Normal: primeiro job pode demorar 1-3 meses de effort ativo.

## Part 9 — Money benchmarks (USD, 2026)

| Canal | Junior | Middle | Senior |
|-------|--------|--------|--------|
| Freelance ($/hr) | $50-80 | $80-120 | $120-200+ |
| Turnkey project | from ~$10k | — | up to $250k+ |
| Full-time US ($/yr) | ~$102k | ~$130-165k | $200k-266k+ |

Mercado: $22B (2024) → $111B (2033 forecast). Demand a favor.

## Part 10 — FAQ

- PC poderoso? Não — Colab free com GPU na nuvem.
- Pagar? Tudo free no start: Colab, YOLO/Supervision (open source), Roboflow (free plan), GitHub. Paga só quando projetos crescem.
- Legal? Tools sim. Mas privacy/data laws com cameras reais — não publique footage alheio sem permissão.
- Task diferente dos scripts? AI quebra em partes. Além do alcance → decline honesto.
- Primeiro money? Poucas semanas a meses com effort ativo. Não é "money button".
- Math/theory? Para AI-assisted path: não. Basics ajudam depois para complex projects.
- Real time/live camera? Free Colab basta para demos. RTSP/real-time → mais resources, AI ajuda a setar.

## Part 11 — What NOT to do

- Não ir ao market sem "deliver a result" — "ran on my machine" não basta (video + numbers + report)
- Não clone pure tutorials 1:1 — demos em vídeos próprios para nicho
- Não stuck em low rate — raise após reviews
- Não trust AI code blindly — abra resultado, confira by eye
- Não se espalhe sobre "AI in general" — narrow specialty vende mais

## Part 12 — Glossário

Model, Dataset, Labeling/annotation, Bounding box, Class, Confidence, Inference, Training, Tracking/ID, API, FPS, RTSP, GPU — todos definidos em plain language no artigo.

## Por que importa para o vault

- **Blueprint prático de monetização de AI sem programação profunda** — complementa [[03-RESOURCES/sources/ai-agents/how-frontier-teams-are-reinventing-ai-native-development]] que é mais strategic
- Stack YOLO + ByteTrack + Supervision é production-ready e free — referência técnica concreta
- Model de freelancing internacional em dólares é relevante para independência financeira
- Conecta com tese de AI-assisted development: AI assistant como "seu programador" → mesmo padrão de [[03-RESOURCES/sources/ai-agents/the-problem-is-prompt-debt]]

## Links

- [[03-RESOURCES/sources/ai-agents/how-frontier-teams-are-reinventing-ai-native-development]]
- [[03-RESOURCES/sources/ai-agents/the-problem-is-prompt-debt]]
- [[03-RESOURCES/sources/articles/aws-transform-tech-debt-autonomous]]