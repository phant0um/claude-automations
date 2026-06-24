---
title: "Codex + Excalidraw Canvas Annotation: Point-and-Shoot Image Editing"
type: source
created: 2026-06-23
updated: 2026-06-23
tags:
  - source
  - ai-agents
  - image-editing
  - codex
  - excalidraw
  - visual-context
---

author: [[@cgnot996]]
source: https://x.com/cgnot996/status/2069250107732848707
published: 2026-06-22

original_title: "Codex + Excalidraw 画布标注：指哪打哪，图片编辑告别盲盒抽卡"

## Central Thesis

The most frustrating part of AI image editing isn't the first generation — it's trying to make small changes. When you say "move the button up a bit" or "replace that decoration," the model has to guess which button, which decoration. The solution is to put modification intent directly into the visual context: generate the image, place it in Excalidraw, annotate with arrows and text, screenshot, and send back to Codex. The annotation image carries most of the information, so the text prompt can be minimal.

## Workflow

### 1. Generate the Target Image

Used Xhx Media Gen (API-based gpt-image-2 skill) to generate a 4:5 Xiaohongshu cover image. First version had the right red-white color scheme, title, and atmosphere, but the subject was a robot instead of the creator's IP character. This was actually useful — it provided the base for canvas annotation to fix.

### 2. Open Excalidraw Inside Codex

No need to switch to an external browser. Click the sidebar icon in Codex's top-right, select "Browser." Enter `excalidraw.com` in the address bar. Right-click the generated image in the Codex conversation → Copy Image → paste into Excalidraw canvas. This is smoother than download/find-file/upload. Left side is Codex conversation, right side is canvas — generation, copy, and annotation all in one window.

### 3. Annotate What to Change

Placed the original image on the left, the target IP reference image on the right, then drew red arrows with short annotations:
- Top-left: add Xiaohongshu logo
- Replace robot with the 3D cartoon character from the reference image
- Bottom: add "铁柱AGI" text watermark

Annotations don't need to be a manual — the key is letting Codex see the original image, reference image, and arrow directions simultaneously. Especially for subject replacement, putting the reference image in the same screenshot is far clearer than saying "replace with my IP character."

### 4. Send Back to Codex

Pasted the annotated screenshot back into Codex with a short prompt. The annotation image carries most of the information; the text only needs to tell Codex to execute according to the image.

### 5. Results

Results matched expectations: Xiaohongshu logo added top-left, robot replaced with 3D cartoon male character, watermark added bottom-right. Critically, red arrows and annotation text were **not** carried into the final image. Positions were more natural than mechanical arrow-copying — logo landed naturally in the corner, character fused well with the original red-white aesthetic, watermark was harmonious.

## Key Insights

- **Visual context > verbal description for spatial edits.** "Move up a bit" is ambiguous in text but precise in an annotated screenshot.
- **The annotation is a layer of instruction, not part of the final image.** If artifacts remain (arrows, red text, boxes), add a follow-up prompt: "These red arrows and text are only modification annotations, not part of the final image. Please preserve the current modifications and only remove all annotation marks."
- **Reference images belong in the same screenshot.** For subject replacement, seeing the original + reference + arrows together is clearer than any text description.
- **Keep annotations short.** Arrows should point to specific positions, text should be short phrases, and the screenshot should include original + annotation + reference — don't crop to just a section, don't include irrelevant UI.
- **This method reduces AI randomness.** Previously: "I describe, you guess." Now: "I circle it, you change it." The randomness is compressed into a smaller range.
- **Not suitable for:** Strict brand VI, complex Chinese typography, or pixel-level commercial design. AI still has randomness, but canvas annotation constrains it.

## Applicable Scenarios

Already have an image that's directionally correct and only need local edits: posters, covers, product images, event graphics, character IP images, UI sketches.

## Related Concepts

- [[03-RESOURCES/concepts/ai-agents/agent-copilot-pattern]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]