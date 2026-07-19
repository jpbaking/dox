---
name: dox-remap
description: Deep-scan the codebase and rebuild or refine every Feature Map in the DOX tree. Reads source code, discovers unmapped features, retires defunct entries, fixes orphaned or mislocated entries, and improves descriptions, Start files, and file lists. Use when the user asks to remap features, refresh the maps, or do a deep scan; after a large refactor; when maps are shallow or outdated; when a stronger model is available; or for a periodic deep refresh. Not for structural repairs — that is dox-fix.
---

# DOX Remap

Re-read the source code and rebuild every Feature Map in the DOX tree. This is the deep, code-aware pass — it goes beyond the mechanical checks in the `dox-audit` and `dox-fix` skills by actually reading source files to understand what they do.

## Step 0 — Preconditions

1. Open the project root doc: check `DOX.md` first, then `AGENTS.md` (legacy name, pre-v3). If neither exists or neither contains `# DOX framework`, STOP and suggest the `dox-init` skill. If the legacy filename is found, suggest `dox-upgrade` first.
2. Read the root doc fully, especially the **Feature Map** section (format, locality rules, "Keep it current"). Inventory descendant roots under both the current `DOX.md` filename and legacy `AGENTS.md`; they are out of scope.

If the user named a specific folder, scope every step below to that subtree only.

## Step 1 — Walk the tree and read the code

For every DOX.md in scope (root included), do the following. Stop traversal at any descendant folder whose `DOX.md` or legacy `AGENTS.md` contains the full root rules.

1. **Read the existing Feature Map** in that doc. Note every feature currently listed.
2. **Read the source files** in that doc's subtree (skip vendored, build, and VCS dirs). For each meaningful source file, note what feature or capability it contributes to.
3. Build a **proposed Feature Map** for that doc based on your code reading.

## Step 2 — Classify every entry

Compare the existing Feature Map against your proposed one. Classify each entry:

- **Current** — the feature exists, the description is accurate, and the Start file and Files list are correct. Keep as-is.
- **Stale description** — the feature exists but the description, Start file, or Files list is inaccurate or incomplete. Update it.
- **Defunct** — the feature no longer exists (code deleted or fully absorbed into another feature). Remove it.
- **Orphaned** — the feature's code has moved to a different subtree. The entry belongs in a different doc. Move it (remove from here, add to the correct doc).
- **Mislocated** — the feature is listed in a parent doc but all its code now lives within a single child's subtree (locality violation). Move it down to the child doc.
- **Promoted** — the feature is listed in a child doc but now spans multiple children or the whole project. Move it up to the parent or root.
- **New** — a feature exists in the code but has no entry anywhere. Add it to the correct doc.
- **Merged** — two or more entries describe what is really one feature. Merge them.
- **Split** — one entry covers what is really two or more distinct features. Split it.

## Step 3 — Apply changes

For each doc in scope:

1. Rewrite the Feature Map section with the updated entries. Follow the format from the framework exactly:
   ```
   - **<Feature name>** — <one line: what it does>. Start: `<entry file>`. Files: `<other files or folders>`.
   ```
2. Respect **locality**: put each feature in the DOX.md closest to its code. If a feature spans multiple children, put it in the lowest common parent and point to the children (`Detail in ./child`).
3. For entries that moved between docs, update both the source and destination docs.
4. Do NOT touch or recurse into nested roots under either filename — list any findings visible at the boundary and note they must be remapped inside their own project.
5. Do NOT change anything outside the Feature Map sections — leave Purpose, Ownership, Local Contracts, Child DOX Index, etc. untouched.

## Step 4 — Quality checks

Before finishing, verify:

- Every feature has exactly one Start file (not zero, not multiple).
- Files lists point to real, existing files or folders.
- No feature is listed in two docs (except a parent pointing to a child with `Detail in ./child`).
- Descriptions are concise but specific — not generic placeholders like "handles X" when a more precise statement is possible.
- Feature names are consistent across the tree (same feature is not called different things in different docs).

## Step 5 — Report

For each doc changed, list:

- Features **added** (new or moved in from another doc).
- Features **removed** (defunct or moved out to another doc).
- Features **updated** (description, Start, or Files changed) — note what changed.
- Features **kept** unchanged.

Separately list any nested-root findings you left untouched.
