---
title: RuView
type: entity
subtype: tool
tags: [rust, wifi, pose-detection, csi, esp32, edge-computing, vital-signs, privacy, iot, smart-home]
created: 2026-05-31
github: https://github.com/ruvnet/RuView
crate: wifi-densepose-ruvector
docker: ruvnet/wifi-densepose
license: MIT
stars: 1715+
ingested: 2026-05-16
updated: 2026-05-19
---

# RuView

Plataforma de WiFi sensing que transforma sinais de rádio em inteligência espacial. Detecta presença humana, estima pose corporal (17 keypoints COCO), mede breathing rate e heart rate — **sem câmeras, sem wearables**. Implementado em Rust. Baseia-se na pesquisa *DensePose From WiFi* (Carnegie Mellon University).

Autor: [[03-RESOURCES/entities/ruvnet]] | Fonte: [[03-RESOURCES/sources/open-source-ecosystems/ruview-wifi-pose-detection]]

## Capacidades Principais

- **Pose estimation** — 17 keypoints COCO via WiFlow; câmera-livre (PCK@20 ~2.5% atual; target 35%+ com supervisão ADR-079)
- **Vital signs** — breathing 6–30 BPM; heart rate 40–120 BPM; contactless
- **Presença** — 100% accuracy; 0.012 ms latência; through-wall até 5m
- **Edge intelligence** — 60 módulos WASM no_std Rust em 13 categorias; <10 ms/módulo no ESP32
- **Self-learning** — adapta ao ambiente em <30s; modelo ~55 KB cabe no ESP32 (520 KB disponíveis)

## Arquitetura

```
ESP32-S3 mesh → CSI capture → Multi-Band Fusion (168 virtual subcarriers)
  → Signal Processing (Hampel, SpotFi, Fresnel, BVP)
  → RuVector backbone → CRV Signal-Line Protocol (6 stages)
  → Output: pose + vitals + room fingerprint
```

Suporta criptografia de cadeia de testemunhas Ed25519. Sem cloud obrigatório.

## Hardware

| Opção | Hardware | Custo | Capacidades |
|-------|---------|-------|-------------|
| Recomendada | ESP32-S3 + Cognitum Seed | ~$140 | Pose, breathing, heartbeat + vector store + kNN + witness chain |
| Mesh | 3–6x ESP32-S3 | ~$54 | Pose, breathing, heartbeat, motion, presence |
| Research NIC | Intel 5300 / Atheros AR9580 | ~$50–100 | Full CSI 3x3 MIMO |
| Qualquer WiFi | Laptop | $0 | RSSI-only: presença grosseira |

ESP32-C3 e ESP32 original NÃO suportados (single-core).

## Quick Start

```bash
# Docker (sem hardware)
docker pull ruvnet/wifi-densepose:latest
docker run -p 3000:3000 ruvnet/wifi-densepose:latest
# Abrir http://localhost:3000

# Live demo (verificação sem hardware)
python archive/v1/data/proof/verify.py
```

## Plugin Claude Code

```bash
/plugin marketplace add ruvnet/RuView
/plugin install ruview@ruview
# /ruview-start /ruview-flash /ruview-provision /ruview-app /ruview-train /ruview-advanced /ruview-verify
```

## Status (2026-05-16)

- Beta ativo — APIs e firmware podem mudar
- 1.463 testes passando
- 60 módulos WASM implementados (609 testes)
- Trending GitHub: +1.715 stars em 2026-05-16
- PCK@20 de câmera-supervisionada pendente (pipeline implementado, fases P7–P9 ADR-079 a fazer)

## Casos de Uso Primários

Elderly monitoring, smart home automation, healthcare contactless monitoring, retail analytics (GDPR-friendly), security/perimeter detection, search & rescue, cobot safety zones.

## Privacidade by Design

Sem captura de pixels. Evita GDPR video e HIPAA imaging por design — os dados são padrões de sinal RF, não imagens. Adequado para ambientes sensíveis (minors, healthcare, espaços religiosos).

## Conexões

- Autor: [[03-RESOURCES/entities/ruvnet]]
- Fonte detalhada: [[03-RESOURCES/sources/open-source-ecosystems/ruview-wifi-pose-detection]]
- Stack Rust → relaciona com [[03-RESOURCES/entities/pdf-inspector]]
- Modelo edge local → filosofia local-first de [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
