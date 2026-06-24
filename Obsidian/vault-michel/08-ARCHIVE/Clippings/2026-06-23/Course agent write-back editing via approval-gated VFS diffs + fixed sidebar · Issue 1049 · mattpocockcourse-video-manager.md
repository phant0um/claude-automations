---
title: "Course agent: write-back editing via approval-gated VFS diffs + fixed sidebar · Issue #1049 · mattpocock/course-video-manager"
source: "https://github.com/mattpocock/course-video-manager/issues/1049"
author:
  - "[[mattpocock]]"
published: 2026-06-19
created: 2026-06-22
description: "Problem Statement The course agent (api.courses.$courseId.agent.ts) is read-only: it can ls/tree/cat/grep a course through the VFS metaphor,"
tags:
  - "clippings"
---
## Problem Statement

The course agent (`api.courses.$courseId.agent.ts`) is **read-only**: it can `ls`/`tree`/`cat`/`grep` a course through the VFS metaphor, but it cannot change anything. Course authors who want to reorder lessons, rename a section, fix a clip transcript, add a ghost lesson, or move a lesson between sections must do every edit by hand in the UI — even when they've just asked the agent to reason about the change. There is no safe write path: no tool surface, no human approval gate, no engine that turns an agent's proposed change into validated database operations.

Separately, the agent panel is a floating overlay (`fixed right-4 … w-[400px] z-40`) that **covers** the course content instead of sitting beside it, so authors can't watch the SectionGrid while they work with the agent.

## Solution

Let the agent **edit** course content through the same VFS metaphor, with **every edit gated by an AI-SDK-v6 tool approval** on the frontend (accept/reject with a click-through breakdown of exactly what changes), and reshape the agent panel into a fixed full-height sidebar that reflows the content.

The edit model is **whole-file-diff**: the agent emits a complete new file (via `write`) or a targeted patch (via `edit`); a server-side engine diffs it against the current version to derive operations, validates them against a capability matrix, and — only on user approval — applies them transactionally. The agent never issues granular per-op commands; structural changes (reorder, add, delete, move) all fall out of editing membership-manifest files.

## User Stories

1. As a course author, I want the agent panel to sit in a fixed right sidebar that reflows the course content, so I can watch the SectionGrid while I work with the agent.
2. As a course author, I want to drag the sidebar's left edge to resize it (clamped 320–640px), so I can balance content and conversation width.
3. As a course author, I want a persistent vertical "Course Agent" edge tab on the top-right while the panel is closed, so opening the agent is always discoverable.
4. As a course author, I want the agent to propose an edit and have it **pause for my approval** before anything changes, so I stay in control of every mutation.
5. As a course author, I want each pending edit shown as a **breakdown card** that lists the derived operations spatially (before→after), so I can see exactly what will change before I approve.
6. As a course author, I want adds, deletes, reorders, edits, unarchives (moves), and clip-copies visually distinguished by icon (delete in red, everything else monochrome), so I can read a diff at a glance.
7. As a course author, I want to **approve** an edit and have it applied to the database and reflected on the course page immediately, so the UI never goes stale.
8. As a course author, I want to **reject** an edit and have the agent see my rejection and respond, so I can redirect it conversationally.
9. As a course author, I want a rejected edit to leave the course completely unchanged, so a bad proposal is never partially applied.
10. As a course author, I want the agent to **reorder** sections, lessons, videos, clips, chapters, and segments by moving lines in a membership manifest, so ordering is just position.
11. As a course author, I want the agent to **edit fields** (e.g. lesson title/slug/description/icon/priority, section description/slug, clip text, chapter name, segment kind/title/description, video name) within the capability matrix.
12. As a course author, I want the agent to **add** ghost sections and ghost lessons, segments, chapters, and clips (clips by verbatim-footage copy only), so it can build out structure.
13. As a course author, I want the agent to **soft-delete (archive)** entities, with section deletes allowed only when the section is empty of non-archived lessons.
14. As a course author, I want the agent to **move a lesson between sections** as a two-step protocol (remove the line in section A, re-add the same id in section B), where the re-add unarchives + reparents, so moves are explicit and reviewable.
15. As a course author, I want a move shown with a **two-step banner** ("Step 2 of 2 … rejecting leaves the lesson archived"), so a lone unarchive card is never ambiguous.
16. As a course author, I want the agent to **move a video** between lessons the same way (manifest-backed unarchive+reparent).
17. As a course author, I want the agent to "move" a clip across videos as **copy-into-B + delete-from-A** (two approvals), since footage is reused by copy, not relocation.
18. As a course author, I want the agent **refused atomically** when it proposes any operation outside the capability matrix, with a correction message it can act on, so illegal edits never reach my approval card.
19. As a course author, I want the agent **refused** if it tries to write a file it hasn't read this thread, or that changed beneath it since it read it, so edits are always against fresh state.
20. As a course author, I want the agent **refused** if it invents, changes, or duplicates an id, so identity stays stable and edits map to the right entities.
21. As a course author, I want a server-side refusal (forbidden-op / stale / identity) to render as a **muted "agent proposed an invalid edit → retrying" line** — distinct from an approval card and from my own rejection — so I can tell self-correction apart from a decision I need to make.
22. As a course author, I want an approved edit that fails to apply because the file went stale between render and approval to surface the same muted "couldn't apply, file changed" line, so concurrent recording never silently clobbers.
23. As a course author, I want a genuine system error (executor bug / DB failure) to render as a **real error**, distinct from a validation refusal.
24. As a course author, I want the agent to use `write` for tiny files (manifests, `section.json`, `lesson.json`) and `edit` for big leaves, so it never re-emits hundreds of transcripts it didn't mean to touch.
25. As a course author, I want a pending approval to **survive a page reload** (the card and its breakdown rehydrate from the persisted thread), so I don't lose an in-flight proposal.
26. As a course author, I want the agent to be told (in its system prompt) all the rules it must self-enforce — capability matrix, id discipline, read-before-write, move protocol — so engine rejections are rare rather than routine.
27. As a course author, I want `materialize`/`dematerialize` (`fsStatus` edits) gated: blocked under a ghost course with a legible correction, and a dematerialize approval card must surface the same destructive-delete warning the existing convert-to-ghost modal shows.
28. As a course author, I want `cat <video>/timeline/_members.json` to give me the ordered structure of a whole video without pulling a single transcript, so the token cost of reasoning about a video stays low.

## Implementation Decisions

This PRD is the expansion of write-back for the course agent. The following decisions are firm (resolved during decision-mapping). Where a snippet encodes a decision more precisely than prose, it is inlined and marked.

### Spine (non-negotiable rules)

- **R1 — Whole-file-diff edit model.** The agent emits a complete file (or a patch that reconstructs one); the engine diffs it. One uniform write path, no granular per-op tools.
- **R2 — One file-write ⇒ one approval.** A single write may change several things; it is approved/rejected as a bundle. The breakdown lists the derived ops inside that one approval.
- **R3 — Forbidden op ⇒ atomic reject.** If a write's diff contains any op outside the capability matrix, reject the entire write before the approval card and return a correction to the agent. Never apply-legal-drop-illegal.
- **R5 — Order is position, not a field.** Where an entity sits in its parent's `_members.json` *is* its order. Drop the stored `order` from VFS leaves; listings obey manifest position.
- **R6 — Identity = stable, read-only ids.** The diff engine keys off `id`: same id moved ⇒ reorder; same id, fields changed ⇒ edit; id gone ⇒ delete; null/omitted id ⇒ add (mint on apply). Inventing, changing, or duplicating an id ⇒ hard atomic reject.
- **R7 — Read-before-write + staleness guard.** A write is auto-rejected (tool error, pre-approval) if the agent hasn't `cat`\-ed that file this thread, or the file changed beneath it since. Implemented by stamping each `cat` output with `{path, hash}` and scanning message history backward on write — no server-side read-set.
- **R8 — Cross-parent move = two approvals via the archive exception.** Removing an id from a manifest archives the entity. Writing an *existing-but-archived* id into a manifest unarchives + reparents it (the one exception to R6). Generalizes to lessons and videos; does NOT apply to clips/chapters (those move by copy).

### Capability matrix (R4)

All deletes are soft (archive). Ordering is always manifest position.

| Entity | Add | Delete | Reorder | Editable fields |
| --- | --- | --- | --- | --- |
| Course | ❌ | ❌ | — | none |
| Section | ✅ ghost | ✅ (empty-only) | ✅ | description, slug/name |
| Lesson | ✅ ghost | ✅ | ✅ (+ move between sections) | title, slug, description, icon, priority, dependencies, authoringStatus, fsStatus |
| Video | ✅ | ✅ | ✅ (manifest pos) | name |
| Segment | ✅ | ✅ | ✅ | kind, title, description |
| Chapter | ✅ | ✅ | ✅ | name |
| Clip | ✅ copy-only | ✅ | ✅ | text only |

- Clip `scene`/`profile`/`beatType` ❌; clip Add is **copy-only** (a null-id clip whose `videoFilename`/`sourceStartTime`/`sourceEndTime` verbatim-match an existing non-archived clip; free-form add ❌).
- Video `originalFootagePath`/`warnings` ❌. Course `memory`, version block, and publishing are hidden/out of scope.
- Section delete is empty-only (reuses today's `archiveSection` guard): rejected while any non-archived lesson remains.
- Lesson `fsStatus` edit *is* materialize/dematerialize (touches the real FS) — see Execution.

### Module: VFS read-projection restructure (`app/services/vfs/`)

Unify the projection so **every parent with children has a `_members.json`** (membership + order) and **every item is its own leaf file** — no array blobs.

```
/courses/<slug>/
  course.json
  sections/
    _members.json                  [{ id, slug }]            ← position = order
    <NN-slug>/
      section.json                 (loses \`order\` field)
      lessons/
        _members.json              [{ id, slug }]
        <NN.M-slug>/
          lesson.json              (loses \`order\` field)
          videos/
            _members.json          [{ id, name }]            ← reorderable
            <video-path>/
              video.json
              timeline/
                _members.json      [{ id, type, label }]     ← clips+chapters interleaved
                <NN>-<slug(name)>.chapter.json   { id, name }
                <NN>.clip.json                   { id, text, sourceStartTime, sourceEndTime, videoFilename, beatType, scene, profile }
              segments/
                _members.json      [{ id, label }]
                <NN>-<slug(title)>.json          { id, kind, title, description }
```

- Leaf filename `<NN>-` prefix is **derived from manifest position at projection time, never stored** (so reorder moves a line, no renumber cascade). Clips get a terse `<NN>.clip.json` (transcript too long for a path). The `.clip.json`/`.chapter.json` suffix disambiguates the two kinds sharing `timeline/`.
- `_members.json` carries a read-only echo (`slug`/`name`/`label`) as a cheap table of contents. For `timeline/`, `label` = chapter name or clip text-snippet, so the manifest gives the whole video's structure without pulling transcripts. The engine **ignores the echo on existing entries** (keys only on `id`).
- Order = manifest insertion position everywhere; drop `VfsDirNode.order` and the order-aware comparator. Build children into the Map in manifest order (insertion-ordered); `ls`/`tree`/`grep` iterate insertion order — no sort. Ghosts inline naturally at their manifest position. `_members.json` is inserted first so it heads the listing.
- `cat` filters: retire `.text`/`.names` (+ the `isTimeline` helper). Keep generic array filters (`.[i]`/`.[i:j]`/`.count`) pointed at `_members.json`; `.count` special-cases the timeline manifest → `{clips, chapters}` by reading each entry's `type`. `.field` unchanged for object leaves.
- New write-parse schemas make `id` `.nullish()` (read projection keeps it required). A new item = id omitted/null.
- Blast radius: `vfs-schemas.ts` (add manifest + `ClipLeaf`/`ChapterLeaf`/`SegmentLeaf`; remove `SegmentsLeaf`/`TimelineLeaf`/`TimelineItem`; drop `order`), `vfs-leaves.ts`, `vfs-tree.ts`, `vfs-tree-tool.ts`, `vfs-ls.ts`, `vfs-cat.ts`, `vfs-grep.ts`, `vfs-loader.server.ts`, `index.ts`.

### Module: diff engine — `deriveDiff` (pure, server-side)

A single pure function called in two places (decide+emit, and apply) so they can't drift:

```ts
deriveDiff(input, messages, root) =>
  | { ok: true, ops: Op[], note?: string }
  | { ok: false, rejection: { kind, message } }
```
- Reconstructs the after-file (`write` = literal content; `edit` = `applyEdits(beforeFile, edits)`), where the before-file is the most-recent `cat` of that path from the message-history scan ([Should be able to click "Export" on a video from the course page. #3](https://github.com/mattpocock/course-video-manager/issues/3) mechanism — same content R7 hashes).
- Pipeline per file: **R7 read/staleness guard first** (history hash-scan: not-previously-`cat`\-ed or hash-mismatch ⇒ pre-approval reject) → parse before/after → key by id → classify into the four ops → validate each against the R4 matrix → **any forbidden op ⇒ atomic reject** with a correction.
- **Four ops, id-keyed:**
	- **Add** — `id: null` ⇒ mint on apply. Two guarded sub-cases: **Unarchive** (non-null id resolving to an archived entity in a manifest ⇒ unarchive+reparent; lessons + videos only); **Clip copy** (null-id clip verbatim-matching an existing clip's footage triple).
		- **Delete** — id in before, absent in after ⇒ soft-archive.
		- **EditField** — same id both sides, scalar differs ⇒ one op per changed field, each checked editable.
		- **Reorder** — same id-set, order differs ⇒ `Reorder { finalIdsInOrder }`. Engine is **index-space only**; executor full-reindexes.
- **Identity errors (hard reject):** unknown id, duplicated id, or a non-null id resolving to an *active* entity in the wrong parent.
- **Render contract** (the op shape the UI and transport carry — derived state the client can't recompute):  
	`edit | delete | add{sub: create|unarchive|copy} | reorder{order:[{label, fromIndex, toIndex}]}`, each op carrying a human `target` label + before/after detail (reorder→moved-from index per line; unarchive→source parent; copy→footage echo). Payload: `{ toolCallId, path, tool: "write"|"edit", ops: Op[], note? }` (`note` = R8 two-step banner).

### Module: write/edit tool surface

Two tools, both `tool({ inputSchema, execute, needsApproval })`:

- **`write`** — `{ path, content }`, whole-file. For tiny files and full rewrites.
- **`edit`** — `{ path, edits: [...] }`, an array applied in sequence (batch). Reuses `app/features/article-writer/document-editing-engine.ts` edit types (`replace` with exact→whitespace-insensitive fallback that errors on ambiguity; `insert_after`; `rewrite` dropped as redundant with `write`). For big array leaves.
- Reorder via `edit` falls out of the id-keyed diff: a move = `replace(block, "")` + `insert_after(anchor, block)` within the one `edits` array, now operating on tiny manifest lines. No special reorder op at the tool surface.
- `edit`'s `old_string` match is partial staleness self-enforcement but does **not** replace the R7 hash guard — keep both.
- Agent model bumped haiku → Sonnet (`claude-sonnet-4-5`) — already applied at `api.courses.$courseId.agent.ts:179`.

### Module: AgentDiffExecutor (ops → DB, policy-centralized)

A new server-side Effect program that owns the op→service mapping. **All R3/R4 capability checks, FS-op detection, and the ghost-course guard live here — the matrix is enforced in exactly one place; the ops services stay dumb primitives.**

- Routing: `CourseWriteService` for FS-touching lesson/section structural ops (its existing `withPreAndPostValidation`); the low-level ops services (`LessonSectionOperationsService`, `ClipOperationsService`, `SegmentOperationsService`, `VideoOperationsService`) for clip/chapter/segment/video and ghost/DB-only ops.
- **Atomicity:**
	- Pure-DB multi-op write ⇒ all-or-nothing in one `db.transaction` (see transaction module).
		- FS-touching write ⇒ **rule (b): at most one FS-touching op per write; ≥2 ⇒ atomic-reject** with a "split this into separate edits" correction. One FS op = inherently atomic at the op level.
- **`fsStatus` materialize/dematerialize (v1, guarded):** materializing under a **ghost course ⇒ atomic-reject** ("materialize the course manually first" — it needs a user-only course `filePath`). Real course ⇒ free. **Dematerialize is destructive**; the approval card must surface the same warning as `app/components/convert-to-ghost-modal.tsx` (the on-disk `filesOnDisk` list), computed in the preview path — reuse the modal content, don't invent a new warning.
- **VFS refresh after apply:** rebuild the whole-course VFS from the DB (existing per-request path). The write/edit tool result returns the **post-apply re-projected** content + R7 hash of the written file (NOT the agent's submitted after-file — minted ids, normalized fields, derived numbering differ, and the hash must match what the next `cat` produces). Return only the written file's content+hash, plus a small notice listing any sibling FS renames the write triggered.
- **E5 (follows from [Videos exported with the same name should remove the previous instance from the queue. #4](https://github.com/mattpocock/course-video-manager/issues/4), no new decision):** segment `archived` migration; soft-delete does NOT cascade; clip-copy ⇒ `appendClips` with the matched footage triple + new text; unarchive+reparent ⇒ `moveToSection` (lessons) / `updateVideoLesson` + clear `archived` (videos); full-reindex on reorder (sequential ints via `batchUpdate{Lesson,Section}Orders` for sections/lessons; regenerated `generateNKeysBetween` fractional keys for clips/chapters/segments; timeline reorder regenerates across the interleaved set and writes both tables).

### Module: shared transaction boundary

- **Pattern = executor-owned `db.transaction`, factories rebuilt over `tx`.** The ops factories already take a bare `db` handle (`createLessonSectionOperations(db)` etc.) and close over it — that arg *is* the seam. The executor opens one transaction per write, constructs tx-scoped instances, runs the per-write Effect sequence, and lets a reject roll back. **No method-signature changes, no implicit context.**
- **Effect/Promise boundary:** tx-scoped ops are `R = never`; run the sequence with `runPromiseExit` *inside* the drizzle callback and **rethrow on `Exit.failure`** (preserving the typed error to re-surface as the R3 correction) so a failed Effect rejects the Promise → drizzle rolls back. Two impl notes: (i) widen the factory param to a shared `Database = DrizzleDB | PgTransaction<…>` alias (one-line param widening per factory); (ii) `createVideoOperations` needs its `getCourseNavigationData` dep — if touched, capture a runtime via `Effect.runtime()` + `Runtime.runPromiseExit`, else pass a throwing stub.
- **FS composition:** the tx wraps DB only. A write partitions into (pure-DB set, atomic in the tx) + (≤1 FS op, run through `CourseWriteService` **outside and after** commit). Ordering = DB-tx-first, FS-last.
- Factor the boundary into a tiny `withDbTransaction(db, (tx) => Effect): Effect` helper.
- **Scope (v1):** pure-DB multi-op atomicity only. FS+DB cross-boundary atomicity and the `materializeGhost` internal FS-cascade are **deferred to a hardening pass (saga/compensating action) — out of scope.**

### Module: approval-flow wiring (agent route)

Move the route off `agent.stream().toUIMessageStreamResponse()` (no writer) to `createUIMessageStream`, capturing the `writer` by closure so the tools can emit data parts:

```ts
const stream = createUIMessageStream<CourseAgentUIMessage>({
  originalMessages: messages,                  // required for resume
  execute: ({ writer }) => {
    const writeTool = tool({
      inputSchema, outputSchema,               // outputSchema = WriteResult
      needsApproval: async (input, { toolCallId, messages }) => {
        const res = deriveDiff(input, messages, root);   // pure
        if (!res.ok) return false;             // → execute returns {applied:false}, no card
        writer.write({ type: "data-proposed-ops", id: toolCallId, data: res });
        return true;
      },
      execute: async (input, { toolCallId, messages }) =>
        applyOrReject(input, messages, root),  // re-derive + R7 re-check + apply
    });
    const agent = new ToolLoopAgent({ /* … */ tools: { /* … */ write: writeTool, edit: editTool } });
    writer.merge(agent.stream({ messages }).toUIMessageStream({ originalMessages: messages, messageMetadata }));
  },
});
return createUIMessageStreamResponse({ stream });
```
- **`needsApproval` must never throw** (uncaught → crashes the stream). All correction paths run through `execute`.
- **Three failure surfaces, distinct states (`execute` *returns* a structured result, does NOT throw for validation rejects):**

| v6 state / output | Cause | Render | Revalidate |
| --- | --- | --- | --- |
| `approval-requested` + `data-proposed-ops` | valid write, awaiting user | breakdown card | no |
| `output-available` `{applied:true}` | approved → applied | "applied" confirmation | **yes** |
| `output-available` `{applied:false, rejection}` | R3 forbidden / R7 stale-or-unread / R6 identity | muted "agent proposed an invalid edit → retrying" line | no |
| `output-denied` | user clicked Reject | user-reject card | no |
| `output-error` | genuine exception (bug/infra) | real error appearance | no |

- `output-error` is reserved for genuine exceptions only. R3/R7/identity rejects need no human round-trip: `needsApproval`→false → `execute` returns the rejection same request → model self-corrects in-loop. TOCTOU: an approved write can still return `{applied:false}` if the file went stale (R7 re-checked in `execute`).
- **Type safety (one shared module imported by route + client):** `CourseAgentDataParts = { "proposed-ops": ProposedOps }`; `CourseAgentTools = InferUITools<typeof courseAgentTools>`; `CourseAgentUIMessage = UIMessage<UsageMetadata, CourseAgentDataParts, CourseAgentTools>`. `WriteResult` is a discriminated union `{applied:true,…} | {applied:false, rejection:{kind,message}}` — the table keys off it, no stringly-typed `errorText` parsing.
- **Transport = persisted, id-keyed `data-proposed-ops`** (not transient), keyed by `toolCallId`, so a reloaded thread re-renders the breakdown from `UIMessage.parts`. Client correlates the data part to the `approval-requested` tool part on `toolCallId`. `messageMetadata` stays for usage only.
- **Denial-resume bug fix:** `lastAssistantMessageIsCompleteWithApprovalResponses` omits `output-denied` ([Bug: `sendAutomaticallyWhen` never fires when any tool approval is denied vercel/ai#13670](https://github.com/vercel/ai/issues/13670)), so a user reject hangs the stream. Ship a **custom `sendAutomaticallyWhen` predicate** = the upstream one-liner + `output-denied` treated as terminal. Drop the override if/when upstream fixes it.
- **Apply path:** `execute` runs in a fresh request — rebuild VFS, re-derive, re-apply R7 freshness guard, apply via AgentDiffExecutor inside the `db.transaction` boundary, return post-apply re-projected file + hash.

### Module: approval breakdown UI (the card)

- **Variant C — spatial before/after, monochrome.** Card renders the **derived op-list, not raw tool input**. Each op renders as a shape: edits → before→after chips; reorder → two-column before/after of the ordered list; add → the new item (unarchive shows source parent struck-through → here); delete → struck-through target.
- **Monochrome; icons carry the op distinction; red reserved for delete.** Six icons: Edit (pencil), Archive (trash, **the only red op**), Reorder (list-ordered), Add-create (file-plus), Unarchive/"Move in" (archive-restore), Clip-copy (copy). All non-delete tones `text-muted-foreground`; chips `bg-muted`.
- Chrome: neutral "Proposed edit" header with `write|edit` tool chip + target file path; an optional **two-step-move banner** (R8: "Step 2 of 2 … rejecting leaves the lesson archived" — load-bearing); op-list body; **primary Approve-all + secondary text Reject** footer.
- R3/R7 server-side rejects render with the **distinct muted "invalid edit → retrying" appearance** (not an approval card, not a user-reject) per the W3 table.

### Module: sidebar layout (floating → reflow)

- Route root (`_app.courses.$courseId._index.tsx`) changes from one column to a **flex row**: content column (`flex flex-1 min-w-0 flex-col`, holds the existing course view unchanged) + a right `<aside>`. `min-w-0` lets content shrink instead of overflowing.
- Sidebar is `sticky top-0 h-screen`, `border-l`, with its own internal conversation scroll. No change to `_app.tsx`.
- `course-agent-panel.tsx` gains a real `embedded` prop: swaps `fixed … rounded-xl border shadow-2xl` overlay chrome for `h-full w-full` so the shell owns the frame.
- **Drag-resizable** (user-chosen): 2px drag handle on the left border, width clamps **320–640px**; persist to a cookie/localStorage (like `view-mode`) when folding in.
- **Edge-tab open affordance** (user-chosen): vertical "Course Agent" handle docked top-right (`fixed right-0 top-8`) while closed; click sets `?agentPanel`. Actions-dropdown entry stays as a secondary path.
- Open/close drives off the `?agentPanel` search param (close → `closeAgentPanel`).
- Fold the winning prototype (`course-agent-sidebar.prototype.tsx`) in and delete it; keep `embedded`.

### Module: revalidation

- **Explicit `useRevalidator().revalidate()` — revalidate-to-truth, no optimistic layer.** The agent panel is mounted inside the course route, so a `useRevalidator()` from the panel hits the loader behind `SectionGrid` (no cross-route plumbing). RR doesn't auto-revalidate because `useChat`'s transport POSTs as a plain fetch, not an RR action.
- Trigger: watch message parts; when an agent `write`/`edit` tool part transitions to **`output-available` with `applied === true`**, call `revalidate()`. Fire **only on successful apply** — never on `approval-requested`, R3/R7/`output-error`/`output-denied` (they mutate nothing). RR coalesces concurrent calls; no debounce. `useFocusRevalidate` stays as the slow backstop.
- The optimistic applier (`optimistic-applier.ts`) is **not** extended to agent writes (wrong transport, no optimism window — human-gated + server-applied, client can't predict minted ids/renumbering).

### Module: system-prompt rewrite

- **Reframe, don't append:** opener changes "read-only course explorer" → **course editor**, stating the safety model up front (every write human-approved; engine rejection is a backstop the agent should aim to never hit). Existing read/navigation sections stay.
- New sections: *Editing* (the two tools + when to use each + read-before-write), *Capabilities* (R4 table verbatim), *The rules you must follow* (R5/R6/R7 + atomic-reject R3), *Moving and copying* (R8 as named recipes), *When a write is rejected* (the 3 rejection classes + user-reject vs engine-reject).
- **Id discipline (R6) gets the most ink** (highest-risk, least-intuitive). R8 taught as recipes, not theory. Tool heuristic per the surface module. `fsStatus` flagged as the heavyweight FS exception.
- The prompt's literal VFS-structure ascii + example paths must use the unified `_members.json`\-everywhere layout and exact leaf suffixes (`.clip.json`/`.chapter.json`). Lands during the wiring session (the tools don't exist in the route yet).

## Testing Decisions

Good tests here exercise **external behavior** — given an input file/diff, the right ops/rejection come out; given an applied op set, the DB/VFS lands in the right state — not internal wiring.

- **`deriveDiff` (highest-value, pure):** unit-test (before, after, message-history) → `{ok, ops}` / `{ok:false, rejection}` across every matrix cell and every rejection class: each of the four ops, both guarded Add sub-cases (unarchive, clip-copy verbatim-match + its fabrication reject), the three identity errors, forbidden-field edits, empty-only section-delete guard, R7 not-read and hash-mismatch rejects, R8 two-step move. This is a pure function with no I/O — the easiest deep module to pin.
- **VFS read-projection:** extend existing `vfs-leaves.test`, `vfs-tree-tool`, `vfs-cat`, `vfs-grep`, `vfs-ls`, `vfs-tree` for the unified manifest+leaf layout: `_members.json` at every parent, per-item leaves, order = insertion position (ghost-inline now via insertion order not comparator), retired `.text`/`.names` filters, `.count` reading timeline `type`, dropped `order` field.
- **AgentDiffExecutor:** integration-test op→DB mapping and atomicity — a multi-op pure-DB write commits all-or-nothing (rollback on a forced failure leaves no partial state); soft-delete does not cascade; clip-copy appends the matched footage; unarchive+reparent. Prior art: existing ops-service tests.
- **`edit` reconstruction:** reuse `document-editing-engine.ts`'s existing tested `applyEdits` behavior (exact/whitespace-insensitive match, ambiguity error); add coverage that the reconstructed after-file feeds the diff identically to a `write`.
- Confirm with the team which of these to write first; `deriveDiff` is the recommended primary target.

## Out of Scope

- **Course-level edits:** Course add/delete/reorder, and editing `course.memory` (hidden from the agent), the version block, and publishing — all explicitly excluded.
- **Free-form clip Add:** clips are add-by-verbatim-copy only; no fabricating new footage references. Clip `scene`/`profile`/`beatType` editing. Video `originalFootagePath`/`warnings` editing.
- **FS+DB cross-boundary atomicity** and the `materializeGhost` internal FS-cascade rollback — deferred to a later hardening pass (saga/compensating action). v1 ships pure-DB transactional atomicity only.
- **Real-lesson reorder as a single approval:** rule (b) (≤1 FS op per write) makes it N approvals; judged rare, tagged revisit-later, not fixed here.
- **Extending the optimistic applier** to agent writes — we use revalidate-to-truth instead.
- **Soft-delete cascade:** archiving a parent leaves children active-but-orphaned; "try it and see", revisit only if weird states appear.
- **Deep responsive/mobile design** of the sidebar (desktop-first tool); below ~md, fall back to overlay (`embedded={false}`) is a noted non-blocking follow-up.
- **Standalone file-write page changes** (`standalone-file-management-modal.tsx`) — unrelated whole-file textarea, not touched.

## Further Notes

- **Sequencing:** the VFS read-projection restructure (unified manifests) and the transaction boundary are foundational — `deriveDiff`, the executor, and the system-prompt ascii all assume them. The diff engine is pure and can be built/tested independently of the route wiring. The route wiring (`createUIMessageStream`) is the integration point that depends on engine + executor + transaction boundary all landing.
- **Version pin:** verified against installed `ai@6.0.116` / `@ai-sdk/react@3.0.118` (types + source). The denial-resume bug ([Bug: `sendAutomaticallyWhen` never fires when any tool approval is denied vercel/ai#13670](https://github.com/vercel/ai/issues/13670)) and the `originalMessages` requirement (["no tool invocation found" error after approving tool with `needsApproval: true` in `createAgentUIStream` vercel/ai#10196](https://github.com/vercel/ai/issues/10196)) are both live and handled above.
- **Assets (design references, in `docs/decision-maps/`):** `assets/ai-sdk-v6-tool-approval.md` (full v6 HITL reference), `assets/08-edit-system-prompt.md` (drop-in prompt draft + line-level impl notes), `app/routes/prototype.agent-approval.tsx` (the chosen breakdown card, variant C, against 4 fixture diffs), `course-agent-sidebar.prototype.tsx` (the reflow shell). The full decision map is `docs/decision-maps/course-agent-editing.md`.
- **Concurrency:** recording and the agent don't run simultaneously, so the full-reindex-on-reorder concurrency tension is moot; R7 remains as cheap insurance against stale reads.
- **Open follow-up handed across tickets, none blocking:** real-lesson-reorder multi-approval UX; FS-cascade saga; soft-delete cascade behavior — all deferred and recorded above.