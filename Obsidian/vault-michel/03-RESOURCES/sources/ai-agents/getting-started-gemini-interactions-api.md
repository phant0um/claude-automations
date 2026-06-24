---
title: "Getting started with the Gemini Interactions API"
type: source
source: "Clippings/Getting started with the Gemini Interactions API.md"
created: 2026-06-23
updated: 2026-06-23
score: A
tags: [ai-agents, source-page, gemini, google, interactions-api, multimodal, function-calling, managed-agents, structured-output]
---

## Tese Central

A Interactions API é a interface primária do Google para Gemini models e agents. Um único endpoint cobre text generation, streaming, multi-turn chat, multimodal inputs, image generation, structured output, tool use, function calling, managed agents, e background execution. É uma API unificada que consolida o que antes exigia múltiplos endpoints.

## Setup

```bash
export GEMINI_API_KEY="YOUR_API_KEY"
npm install @google/genai
```

```javascript
import { GoogleGenAI } from "@google/genai";
const ai = new GoogleGenAI({});

const interaction = await ai.interactions.create({
  model: "gemini-3.5-flash",
  input: "Explain how AI works in a few words",
});
console.log(interaction.output_text);
```

**Skill para coding agents:**
```bash
npx skills add google-gemini/gemini-skills --skill gemini-interactions-api
```

## Capabilities por endpoint único

### Streaming
```javascript
const stream = await ai.interactions.create({
  model: "gemini-3.5-flash",
  input: "Explain how AI works",
  stream: true,
});
for await (const event of stream) {
  if (event.event_type === "step.delta") {
    if (event.delta.type === "text") {
      process.stdout.write(event.delta.text);
    }
  }
}
```

### Multi-turn Conversations
Chain via `previous_interaction_id` — o servidor gerencia o histórico.
```javascript
const interaction2 = await ai.interactions.create({
  model: "gemini-3.5-flash",
  input: "How many paws are in my house?",
  previous_interaction_id: interaction1.id,
});
```
Para client-side history: `store: false`.

### Multimodal Understanding
Gemini entende nativamente images, audio, video, documentos. Upload + pass alongside text.
```javascript
const uploadedFile = await ai.files.upload({ file: "photo.jpg" });
const interaction = await ai.interactions.create({
  model: "gemini-3.5-flash",
  input: [
    { type: "text", text: "What is in this image?" },
    { type: "image", uri: uploadedFile.uri, mime_type: uploadedFile.mimeType },
  ],
});
```

### Image Generation
Nano Banana 2 usando `gemini-3.1-flash-image`. Speech generation (multi-speaker TTS) e music generation (Lyria 3) usam o mesmo pattern.

### Structured Output
JSON que match um schema definido. Funciona com Zod.
```javascript
const interaction = await ai.interactions.create({
  model: "gemini-3.5-flash",
  input: "Give me a recipe for banana bread",
  response_format: {
    type: "text",
    mime_type: "application/json",
    schema: recipeJsonSchema
  },
});
const recipe = recipeSchema.parse(JSON.parse(interaction.output_text));
```

### Tools (Google Search)
Ground responses em real-time data: `tools: [{ type: "google_search" }]`. Outros built-in tools: Code Execution, URL Context, File Search, Google Maps, Computer Use. Múltiplos tools em uma request.

### Function Calling
Declare functions, modelo decide quando chamar, execute localmente, retorne results. Modelo retorna `status: "requires_action"` com `function_call` steps. Você executa e submete `function_result` steps de volta. Loop continua até não haver mais function calls.

### Managed Agents
Run agent em remote sandbox com code execution, web browsing, file management.
```javascript
const interaction = await ai.interactions.create({
  agent: "antigravity-preview-05-2026",
  input: "Write a script that generates the first 20 Fibonacci numbers...",
  environment: "remote",
});
```
Custom agents com suas próprias instructions, skills, e data sources.

### Background Execution
`background: true` para long-running tasks. Retorna imediatamente, você polla por results.
```javascript
const interaction = await ai.interactions.create({
  model: "gemini-3.5-flash",
  input: "Write a detailed analysis of AI in healthcare.",
  background: true,
});
const poll = setInterval(async () => {
  const result = await ai.interactions.get(interaction.id);
  if (result.status === "completed") {
    console.log(result.output_text);
    clearInterval(poll);
  }
}, 5000);
```

## Key Insights

- Um único endpoint unifica 10+ capabilities que antes exigiam APIs separadas
- `previous_interaction_id` permite multi-turn com server-side history management
- Multimodal é nativo (image, audio, video, documents) com mesmo pattern de upload
- Structured output com Zod schemas — JSON garantido conforme schema
- Function calling com loop automático: modelo → requires_action → local exec → function_result → modelo
- Managed agents rodam em remote sandbox com code execution, web browsing, file management
- Background execution para tasks longas: fire-and-poll pattern
- Skills instaláveis via `npx skills add` para manter agents atualizados com API patterns
- Built-in tools: Google Search, Code Execution, URL Context, File Search, Google Maps, Computer Use

## Links

- [[03-RESOURCES/concepts/agent-systems/tool-use-agents]]
- [[03-RESOURCES/concepts/agent-systems/managed-agents-harness]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]

## Minha Síntese

**O que muda:** Google consolidou múltiplas APIs de Gemini em uma única Interactions API que cobre desde text generation até managed agents com remote sandbox. A unificação reduz friction: um endpoint, um SDK, um pattern para 10+ capabilities. O `npx skills add` para manter coding agents atualizados com API patterns é uma idea elegante — a documentação vira skill instalável.

**Conexão pessoal:** O vault pode usar a Interactions API como referência para patterns de agent design. Function calling com loop automático é o mesmo pattern que Hermes Agent implementa. Managed agents com remote sandbox conecta com o conceito de agent-sandbox-pattern já no vault. Background execution é relevante para tasks longas de ingest no vault (batch processing de Clippings).

**Próximo passo:** Avaliar se o pattern `npx skills add` pode ser adotado no vault para manter skills de agentes sincronizadas com APIs em evolução. Testar background execution para batches de ingest grandes.