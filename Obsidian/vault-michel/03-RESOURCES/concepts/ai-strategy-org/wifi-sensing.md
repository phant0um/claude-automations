---
title: WiFi Sensing
type: concept
status: developing
tags: [wifi, csi, radio-frequency, pose-detection, privacy, edge-computing, signal-processing, iot, presence-detection]
related: [ruview, edge-computing, privacy-by-design]
introduced_by: "[[03-RESOURCES/sources/open-source-ecosystems/ruview-wifi-pose-detection]]"
ingested: 2026-05-16
updated: 2026-05-19
---

# WiFi Sensing

Técnica que utiliza os sinais de rádio de roteadores WiFi convencionais como sensores passivos para detectar presença humana, estimar movimento e postura, e medir sinais vitais — **sem câmeras, microfones ou wearables**.

## Princípio Físico

Qualquer corpo humano absorve, reflete e dispersa ondas de rádio. Quando uma pessoa se move num campo WiFi, as características do sinal multipath mudam de forma mensurável. O **Channel State Information (CSI)** captura essas mudanças com resolução de subcarrier (OFDM), fornecendo muito mais informação que o simples RSSI.

```
Roteador WiFi emite ondas → corpo humano interfere →
CSI registra perturbação em cada subcarrier →
DSP + ML extrai: presença, pose, vitais, localização
```

## CSI vs RSSI

| | RSSI | CSI |
|--|------|-----|
| Granularidade | 1 valor (potência total) | N valores (por subcarrier OFDM) |
| Informação | Presença grosseira | Pose, vitais, gesto, respiração |
| Hardware | Qualquer WiFi | NIC com driver específico ou ESP32-S3 |
| Custo | $0 (já existe) | $9–$100 por nó |

## Capacidades Extraídas do Sinal CSI

- **Presença** — detecção binária; alta acurácia mesmo through-wall
- **Localização** — triangulação com mesh de 2+ nós (SpotFi, Fresnel zones)
- **Pose corporal** — 17 keypoints COCO via arquiteturas tipo WiFlow (pesquisa CMU *DensePose From WiFi*)
- **Respiração** — bandpass 0.1–0.5 Hz; 6–30 BPM
- **Frequência cardíaca** — bandpass 0.8–2.0 Hz; 40–120 BPM
- **Gesticulação** — reconhecimento de gestos discretos
- **Contagem de pessoas** — diferenciação de múltiplos corpos

## Pipeline de Processamento Típico

1. **Captura** — NIC 802.11n com CSI patch (Atheros/Intel) ou ESP32-S3 via ESP-IDF
2. **Limpeza** — filtros Hampel (outliers), sanitização de phase offset por antena
3. **Fusão multi-banda** — 3 canais × 56 subcarriers = 168 subcarriers virtuais
4. **Feature extraction** — Fresnel zone modeling, BVP (breathing/pulse), espectrograma
5. **Inferência** — rede neural leve (cabe em ESP32: ~55 KB) ou backbone maior em servidor edge
6. **Output** — keypoints de pose, taxa respiratória, BPM, fingerprint do ambiente

## Hardware

| Opção | Custo/nó | Capacidade |
|-------|---------|------------|
| ESP32-S3 | ~$9 | CSI completo; suporta firmware Rust/WASM |
| Intel 5300 / Atheros AR9580 | $50–100 | CSI 3×3 MIMO, pesquisa avançada |
| Laptop/roteador padrão | $0 | RSSI-only; apenas presença grosseira |

ESP32-C3 e ESP32 de núcleo simples NÃO suportam CSI DSP.

## Vantagens sobre Câmeras

| Câmera | WiFi Sensing |
|--------|-------------|
| Captura imagem (GDPR/HIPAA complexo) | Apenas padrões RF — sem pixels |
| Exige iluminação | Funciona no escuro e através de paredes |
| $200–$2.000/zona | $0–$54/zona (infraestrutura já existe) |
| Ponto cego em oclusão | Funciona em multipath e through-wall |
| Inaceitável em cenários sensíveis (saúde, religião) | Neutro em privacidade por design |

## Limitações

- **Acurácia de pose sem supervisão** — com proxy labels auto-supervisionados, PCK@20 fica ~2.5%; com supervisão de câmera em treinamento, target é 35%+ (ainda pesquisa ativa)
- **Resolução espacial** — degradação com nó único; recomendado 2+ nós
- **Interferência** — ambientes com muitos dispositivos WiFi simultâneos degradam SNR
- **Regulação RF** — canais e potências variam por país; ESP32 usa bandas ISM 2.4/5 GHz

## Aplicações Primárias

- Elderly care: fall detection e monitoramento noturno sem wearable
- Healthcare: monitoramento contactless de sinais vitais em leitos
- Smart home: automação de presença sem câmeras (HVAC, iluminação)
- Retail: foot traffic e dwell time GDPR-friendly
- Security: detecção perimetral passiva through-wall
- Search & rescue: localização de sobreviventes via respiração em escombros
- Robótica: zonas de segurança cobot em blind spots de LIDAR

## Implementações de Referência

- **[[03-RESOURCES/entities/RuView]]** — stack completo em Rust + ESP32-S3; 60 módulos WASM edge; MIT
- *DensePose From WiFi* — paper CMU (Geng et al.); origem acadêmica do campo de pose via WiFi
- ESP-IDF CSI API — firmware base para captura em ESP32-S3

## Conexoes

- [[03-RESOURCES/entities/RuView]] — implementacao de referencia
- [[03-RESOURCES/entities/ruvnet]] — autor do stack Rust de referencia
- [[03-RESOURCES/sources/open-source-ecosystems/ruview-wifi-pose-detection]] — fonte primaria desta pagina
- [[03-RESOURCES/concepts/agent-systems/agent-vfs-pattern]] — arquitetura WASM edge usada nos modulos RuView
