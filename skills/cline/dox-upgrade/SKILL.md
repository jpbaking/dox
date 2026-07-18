---
name: dox-upgrade
description: Upgrade this project's DOX framework rules (the root DOX.md) to the latest released version while preserving all project content — User Preferences, Feature Map, Child DOX Index, and imported project rules. Also migrates legacy AGENTS.md filenames to DOX.md (v3+). Use when the user asks to upgrade or update DOX, refresh the framework, or when dox-audit reports the framework version is outdated or legacy filenames. Not for repairing the doc tree — that is dox-fix.
---

# DOX Upgrade

Replace the framework rules in the root DOX.md with the latest version, keep every piece of project content, then reconcile the tree. Only the framework text changes — project knowledge is never lost. If the project still uses the legacy `AGENTS.md` filename, this upgrade also renames every doc in the tree to `DOX.md`.

## Step 0 — Preconditions

1. Look for the project root doc: check `DOX.md` first, then `AGENTS.md` (legacy name, pre-v3).
2. If neither exists or neither contains `# DOX framework`, STOP and suggest `/dox-init`.
3. If the root doc is named `AGENTS.md`, note that a **filename migration** is required (Step 4 below).

## Step 1 — Fetch the latest framework

Download `https://raw.githubusercontent.com/jpbaking/dox/main/DOX.md` to a temporary file (do NOT overwrite the root doc yet). If the download fails, STOP and tell the user — never upgrade from memory.

## Step 2 — Compare versions

The framework version is the line starting `DOX v` directly under the `# DOX framework` heading.

- Same version in both files **and** the root doc is already named `DOX.md`: report "already on the latest version", delete the temp file, STOP.
- Same version but the root doc is still named `AGENTS.md`: skip the framework text merge (Step 3) but still run the filename migration (Step 4).
- The project file has no `DOX v` line: it predates versioning — continue.
- Different versions: continue.

## Step 3 — Merge (never lose project content)

1. In the CURRENT root doc, collect the project's content: the bodies of `## User Preferences`, `## Feature Map`, and `## Child DOX Index`, plus every section that does not exist in the new framework text (for example `## Project rules (imported)`).
2. Start from the NEW framework text in full.
3. In the new text, replace the placeholder body of each live section (`## User Preferences`, `## Feature Map`, `## Child DOX Index`) with the project's existing body — but keep the new placeholder wherever the project's section was itself still a placeholder or missing.
4. Append the project-only sections from step 1 at the end, unchanged and in their original order.
5. Write the result as `DOX.md` in the project root (even if the old file was named `AGENTS.md` — the new name takes effect here). Delete the temp file.
6. If the old file was `AGENTS.md`, delete it now (its content has been written to `DOX.md`).
7. If any piece of the old file does not clearly belong to either the framework or a project section, KEEP it and list it for the user — never silently drop text.

## Step 4 — Migrate filenames (AGENTS.md → DOX.md)

Run this step when the root doc was `AGENTS.md` or when any doc in the tree is still named `AGENTS.md`. Skip it if every doc in the tree is already `DOX.md`.

1. **Walk the entire DOX tree** from the root down. Find every `AGENTS.md` at every depth.
2. For each `AGENTS.md` found (excluding nested roots — see Step 5):
   a. Rename the file from `AGENTS.md` to `DOX.md` in the same folder.
   b. Inside the renamed file, replace every occurrence of `AGENTS.md` (as a doc-filename reference) with `DOX.md`.
   c. Fix the article "an DOX.md" → "a DOX.md" wherever it appears (the article changed because DOX starts with a consonant sound).
3. After all renames, scan every `DOX.md` in the tree (including the root) for any remaining `AGENTS.md` references in their text and update them to `DOX.md`.
4. Update every Child DOX Index that referenced `AGENTS.md` by name to say `DOX.md` instead.

## Step 5 — Ensure AGENTS.md shim

Create or update `AGENTS.md` in the project root to ensure other AI harnesses automatically follow DOX.
- If `AGENTS.md` does not exist (e.g. after it was renamed in Step 4), create it with this text:
  `This project uses the DOX framework. Do not add rules here. Read DOX.md in this directory and follow its instructions.`
- If it exists but does not point to DOX, prepend that text to the top of the file.

## Step 6 — Nested roots stay untouched

Never upgrade a nested root (a folder whose own DOX.md or AGENTS.md carries the full DOX rules) — its framework belongs to its own repository. Do NOT rename its files or edit its content. If its `DOX v` line is older than the new version or it still uses the `AGENTS.md` filename, list it and note that the upgrade (including the filename migration) must be run inside that project.

## Step 7 — Reconcile the tree

New rules usually create new mechanical debt (new required sections, new placeholders). Run the `/dox-fix` procedure now to bring the doc tree up to the new rules.

## Step 8 — Report

State: old version → new version, which live sections were carried over, which project-only sections were kept, any text you kept because you could not classify it. If a filename migration ran, list every file renamed. Note that the `AGENTS.md` shim was created or updated. List nested roots left on older versions or still using `AGENTS.md`, and summarize what the `/dox-fix` pass changed.
