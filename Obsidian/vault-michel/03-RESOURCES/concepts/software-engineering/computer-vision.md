---
title: Computer Vision
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, software-engineering, computer-vision, ml, yolo]
---

# Computer Vision

Tecnologia que permite a computers "olharem" fotos/videos e entender o que está neles: quais objetos, onde estão, como se movem, quantos são.

## Stack comercial (no-code friendly)

| Tool | Role |
|------|------|
| [[03-RESOURCES/entities/YOLO\|YOLO]] | O "olho" — detecta objetos com bounding boxes |
| ByteTrack | A "memória" — tracks objects entre frames com IDs |
| Supervision | O "kit" — blocks prontos: boxes, counting lines, zones |
| Roboflow | Plataforma no-code + universe de modelos pré-treinados |
| Google Colab | Computador na nuvem gratuito com GPU |

## Pipeline

```
Video → YOLO (detect) → ByteTrack (track) → Supervision (count) → resultado
```

## 4 tarefas comerciais

1. Counting objects (warehouses, inventory)
2. Tracking people/vehicles (stores, roads)
3. Speed estimation (traffic, safety)
4. Sports analytics (player tracking)

## Mercado

$22B (2024) → $111B forecast (2033). Freelance: $50-200+/hr, turnkey $300-$250k+.

## Evidências

- [[03-RESOURCES/sources/articles/computer-vision-11k-month]] — Guia completo para freelancing internacional com CV

## Links

- [[03-RESOURCES/entities/YOLO]]
- [[03-RESOURCES/concepts/business/freelance-international]]