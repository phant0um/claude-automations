---
title: "RuView — WiFi Human Pose Detection"
type: source
tags: [rust, wifi, pose-detection, privacy, iot, smart-home, computer-vision, edge-computing, esp32, vital-signs, csi]
source: https://github.com/ruvnet/RuView
author: ruvnet
ingested: 2026-05-16
stars: 1715+
triagem_score: 4
---

# RuView — WiFi Human Pose Detection

GitHub: https://github.com/ruvnet/RuView | Trending 2026-05-16 (+1,715 stars)

Autor: [[03-RESOURCES/entities/ruvnet]] | Ferramenta: [[03-RESOURCES/entities/RuView]]

## O que é

RuView transforma sinais WiFi em inteligência espacial. Usando Channel State Information (CSI) capturado por sensores ESP32-S3 (~$9/nó), detecta presença humana, estima pose corporal (17 keypoints COCO via arquitetura WiFlow), mede breathing rate (6–30 BPM) e heart rate (40–120 BPM) — tudo **sem câmeras, sem wearables, no escuro, através de paredes**. Implementado em Rust. MIT license.

Baseado na pesquisa original *DensePose From WiFi* da Carnegie Mellon University.

## Como Funciona

```
WiFi Router → radio waves → pessoa interfere → ESP32 mesh captura CSI
  → Multi-Band Fusion (3 ch × 56 subcarriers = 168 virtual subcarriers)
  → Signal Processing (Hampel, SpotFi, Fresnel, BVP, spectrogram)
  → AI Backbone (RuVector) + Signal-Line Protocol (CRV)
  → 17 keypoints de pose + breathing rate + heart rate + room fingerprint
```

Aprendizado auto-supervisionado — sem câmeras de treinamento. O modelo se adapta a qualquer ambiente em < 30 segundos via spiking neural networks. Modelo cabe em 55 KB (ESP32 tem 520 KB disponíveis).

## Capacidades

| Capacidade | Detalhe |
|-----------|---------|
| Pose estimation | 17 keypoints COCO; PCK@20 ~2.5% (câmera-livre); target 35%+ com supervisão (ADR-079, pendente) |
| Breathing | Bandpass 0.1–0.5 Hz; 6–30 BPM |
| Heart rate | Bandpass 0.8–2.0 Hz; 40–120 BPM |
| Presença | 100% accuracy; 0.012 ms latência |
| Through-wall | Fresnel zone + multipath; até 5m de profundidade |
| Edge intelligence | 60 módulos WASM em 13 categorias; no_std Rust; <10 ms por módulo |

## Stack Técnico

- **Linguagem:** Rust 1.85+ (todo o stack, incluindo módulos WASM edge)
- **Hardware:** ESP32-S3 ($9/nó) via ESP-IDF; ESP32-C3 e ESP32 original NÃO suportados
- **Framework:** Docker (amd64 + arm64); crate `wifi-densepose-ruvector` no crates.io
- **Testes:** 1.463 testes passando
- **Custo BOM:** $9 por nó; $54 mesh 3–6 nós; $140 com Cognitum Seed
- **Dependências:** RuVector (AI backbone), Cognitum Seed (memória persistente, kNN, witness chain Ed25519)

## 60 Módulos WASM Edge (ADR-041)

13 categorias, todas implementadas, no_std Rust, executam no ESP32 via WASM3:

- **Medical & Health:** sleep apnea, cardiac arrhythmia, respiratory distress, gait analysis, seizure detection
- **Security & Safety:** perimeter breach, weapon detection, tailgating, loitering, panic motion
- **Smart Building:** HVAC presence, lighting zones, elevator count, meeting room, energy audit
- **Retail & Hospitality:** queue length, dwell heatmap, customer flow, table turnover, shelf engagement
- **Industrial:** forklift proximity, confined space, clean room, livestock monitor, structural vibration
- **Exotic & Research:** dream stage, emotion detection, gesture language, rain detection, breathing sync
- **Signal Intelligence, Adaptive Learning, Spatial Reasoning, Temporal Analysis, AI Security, Quantum-Inspired, Autonomous**

## Casos de Uso

| Setor | Aplicação | Vantagem |
|-------|-----------|---------|
| Elderly care | Fall detection, breathing noturno sem wearable | Sem compliance issues |
| Healthcare | Breathing + heart rate contactless em leitos | Sem sensores físicos |
| Retail | Foot traffic, dwell time, queue — sem câmeras | GDPR-friendly |
| Smart home | Presença através de paredes (lights, HVAC) | Zero dead zones |
| Security | Detecção através de paredes, without active illumination | Passivo/covert |
| Search & rescue | Detecta sobreviventes através de escombros via breathing | Works in zero visibility |
| Robotics/cobot | Presença humana em blind spots onde LIDAR falha | Through-shelf detection |

**Por que WiFi sensing ganha:** sem vídeo (GDPR/HIPAA by design), funciona no escuro e através de paredes, $0–$8/zona vs $200–$2.000 para câmeras, infraestrutura já existe.

## Plugin Claude Code

RuView ships um plugin nativo para Claude Code (`plugins/ruview/`):

```bash
/plugin marketplace add ruvnet/RuView
/plugin install ruview@ruview
# Comandos: /ruview-start /ruview-flash /ruview-provision /ruview-app /ruview-train /ruview-advanced /ruview-verify
```

9 skills, 7 comandos `/ruview-*`, 3 agentes. Mirror para Codex (OpenAI CLI) disponível.

## Limitações Atuais (Beta)

- PCK@20 de pose com câmera-livre é ~2.5% (proxy labels) — o target 35%+ via supervisão de câmera (ADR-079) está implementado em pipeline mas pendente de coleta de dados e avaliação
- ESP32-C3 e ESP32 original não suportados (single-core, insuficiente para CSI DSP)
- Resolução espacial limitada com nó único — recomendado 2+ nós ou Cognitum Seed

## Conexões

- [[03-RESOURCES/entities/ruvnet]] — autor
- [[03-RESOURCES/entities/RuView]] — entidade da ferramenta
- Edge computing sem cloud → relaciona com filosofia local-first de [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- Implementação Rust → relaciona com stack de [[03-RESOURCES/entities/pdf-inspector]] (também Rust, edge)
- Privacidade by design (sem pixel) → contrasta com computer vision tradicional; complementa GDPR concerns
- Self-supervised learning sem labels → relaciona com [[03-RESOURCES/concepts/agent-systems/autonomous-learning]]
- Arquitetura edge WASM → relaciona com [[03-RESOURCES/concepts/agent-systems/agent-vfs-pattern]]
