---
title: YOLO (You Only Look Once)
type: entity
created: 2026-06-23
updated: 2026-06-23
tags: [entity, computer-vision, object-detection, ml-model]
---

# YOLO — You Only Look Once

Modelo de detecção de objetos em tempo real. "O olho" — encontra objetos em imagem/video e desenha bounding boxes com labels ("person", "car"). Downloads com uma linha, usable imediatamente.

## Características

- Single forward pass detecta todos os objetos na imagem (não sliding window)
- Trade-off: velocidade vs precisão (variantes: n, s, m, l, x)
- YOLOv8: versão atual, `yolov8n.pt` (nano) é o mais leve
- Ultralytics mantém a implementação de referência

## Stack CV comercial

```
Video → YOLO (detect) → ByteTrack (track/ID) → Supervision (count) → resultado
```

## Uso

```python
from ultralytics import YOLO
model = YOLO("yolov8n.pt")  # downloads automatically
```

## Evidências

- [[03-RESOURCES/sources/articles/computer-vision-11k-month]] — Guia completo: YOLO + ByteTrack + Supervision para freelancing internacional

## Links

- [[03-RESOURCES/concepts/software-engineering/computer-vision]]