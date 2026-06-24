---
title: Node-RED
type: entity
entity_type: tool
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [low-code, iot, integration, ibm, fbp]
---

# Node-RED

Ferramenta low-code de Flow-Based Programming criada pela IBM (Nick O'Leary, Dave Conway-Jones, 2013). Hoje mantida sob OpenJS Foundation. Editor visual baseado em Node.js p/ conectar APIs, hardware e serviços.

## Características

- **Editor visual** browser-based — paleta, área de trabalho, deploy button
- **Nós (nodes)** — black-boxes com input/output
- **Fluxos (flows)** — grafos de nós conectados
- **JSON-based** — flows persistidos como JSON
- **Extensível** — npm packages adicionam nós (`node-red-contrib-*`)
- **Built on Node.js** — usa libs Node nativamente

## Nós comuns

| Nó | Função |
|---|---|
| `inject` | dispara fluxo (manual/cron) |
| `debug` | log no sidebar |
| `function` | JS custom |
| `http in` / `http response` | servidor HTTP |
| `http request` | cliente HTTP |
| `template` | render Mustache (HTML/texto) |
| `switch` | branch por condição |
| `change` | manipula `msg.payload` |

## Instalação

```bash
npm install -g node-red
node-red                 # roda em :1880
```

Também: Docker, Raspberry Pi (preinstalado), AWS, Azure, IBM Cloud.

## Casos de uso

- Automação IoT (MQTT, Zigbee)
- Orquestração de chatbots (canais → Watson)
- Integrações entre SaaS
- Prototipagem de APIs
- Webhooks e ETL leve

## Em chatbot multi-canal (Fase 7)

- Paleta IBM Cloud chama watsonx Assistant
- Integra Telegram (BotFather), Discord (Developer Portal), WhatsApp (SendPulse), Messenger/Instagram (Chatfuel)
- Exposição via LocalXpose p/ webhooks

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 13 (Orquestração com Node-RED)

## Relacionado

- [[03-RESOURCES/concepts/dev-foundations/flow-based-programming|FBP]]
- [[03-RESOURCES/concepts/dev-foundations/low-code|Low-code]]
- [[03-RESOURCES/entities/IBM-Watson-Assistant|IBM watsonx Assistant]]
- [[03-RESOURCES/entities/Node.js|Node.js]]
