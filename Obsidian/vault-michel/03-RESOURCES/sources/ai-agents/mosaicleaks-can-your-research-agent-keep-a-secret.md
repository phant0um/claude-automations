---
title: "MosaicLeaks — Can Your Research Agent Keep a Secret?"
type: source
source: Clippings/MosaicLeaks Can your research agent keep a secret?.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, privacy, security, leakage, deep-research]
---

## Tese central

Deep research agents que combinam documentos privados com web retrieval vazam informação sensível via queries externas. Mosaic effect: nenhuma query individual revela o segredo, mas observador que monitora outbound traffic reúne fragmentos. Privacy-Aware Deep Research (PA-DR) training reduz leakage de 34% → 9.9% mantendo performance.

## Argumentos principais

1. **Mosaic effect**: agent faz queries web ordinárias que individualmente não revelam nada, mas em conjunto permitem reassemblar informação privada
2. **Exemplo**: healthcare agent — queries sobre cloud-migration milestone, security disclosure, vendor → revela que MediConn migrou 70% para cloud (info privada)
3. **MosaicLeaks benchmark**: multi-hop questions intercalando public e private info. Models frequentemente vazam.
4. **Piora com task performance training**: treinar só para performance aumenta leakage
5. **PA-DR**: RL training mosaic-leakage-aware. Strict chain success: 48.7% → 58.7%. Leakage: 34.0% → 9.9%

## Key insights

- Web queries são canal de leakage — adversário nunca vê documentos privados, só outbound traffic
- Treinar para performance piora privacy — trade-off real que precisa ser addressado explicitamente
- Mosaic effect é cumulativo: fragmentos individuais são innocuous, conjunto revela
- Privacy-aware RL training funciona: melhora performance E reduz leakage

## Links

- [[03-RESOURCES/concepts/agent-systems]]
- [[03-RESOURCES/sources/towards-secure-autonomous-agents-with-information-flow-control-ifc]]