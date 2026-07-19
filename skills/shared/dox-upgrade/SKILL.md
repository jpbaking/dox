---
name: dox-upgrade
description: Upgrade this project's DOX framework rules (the root DOX.md) to the latest released version while preserving all project content — User Preferences, Feature Map, Child DOX Index, and imported project rules. Also migrates legacy AGENTS.md filenames to DOX.md (v3+). Use when the user asks to upgrade or update DOX, refresh the framework, or when dox-audit reports the framework version is outdated or legacy filenames. Not for repairing the doc tree — that is dox-fix.
---

# DOX Upgrade

Replace the framework rules in the root DOX.md with the latest version, preserve every piece of project content, safely migrate confirmed legacy DOX filenames, ensure the agent-harness bridges, then reconcile the tree. Nested roots, unrelated harness instructions, ambiguous files, and existing destination files are never overwritten.

## Step 0 — Preconditions

1. Look for the project root doc: check `DOX.md` first, then `AGENTS.md` (legacy name, pre-v3).
2. If neither exists or neither contains `# DOX framework`, STOP and suggest the `dox-init` skill.
3. Inventory the project before editing:
   - whether the root framework doc is `DOX.md` or legacy `AGENTS.md`;
   - whether the root `AGENTS.md` is already a shim pointing to `DOX.md`;
   - whether root `CLAUDE.md` imports `AGENTS.md` or directly points to `DOX.md`;
   - recognizable legacy child DOX docs named `AGENTS.md`;
   - descendant `DOX.md` or legacy `AGENTS.md` files with full root rules (nested roots — off-limits, and stop inventory traversal there);
   - unrelated or ambiguous `AGENTS.md` harness instruction files (preserve them; they are not migration candidates).

## Step 1 — Fetch the latest framework

Download `https://raw.githubusercontent.com/jpbaking/dox/main/DOX.md` to a temporary file (do NOT overwrite the root doc yet). If the download fails, STOP and tell the user — never upgrade from memory.

## Step 2 — Compare versions

The framework version is the line starting `DOX v` directly under the `# DOX framework` heading. Decide independently whether a framework merge, filename migration, or harness-bridge repair is needed.

- Same version with pending filename or harness-bridge work: delete the temporary framework file, skip the framework text merge, and continue to Step 4.
- Same version with no pending filename or harness-bridge work: delete the temporary framework file, report "already on the latest version," and STOP.
- The project file has no `DOX v` line: it predates versioning — continue.
- Different versions: continue.

Pending work exists when the root or a recognizable child doc still uses the legacy filename, when the root `AGENTS.md` shim is missing/incomplete, or when `CLAUDE.md` does not reach the DOX instructions. Nested roots and unrelated/ambiguous `AGENTS.md` files do not count as pending work in the parent project.

## Step 3 — Merge (never lose project content)

Run this step only when the framework text differs or the current root has no version marker. If the versions match, leave the root framework text unchanged and continue to Step 4.

1. In the CURRENT root doc, collect the project's content: the bodies of `## User Preferences`, `## Feature Map`, and `## Child DOX Index`, plus every section that does not exist in the new framework text (for example `## Project rules (imported)`).
2. Start from the NEW framework text in full.
3. In the new text, replace the placeholder body of each live section (`## User Preferences`, `## Feature Map`, `## Child DOX Index`) with the project's existing body — but keep the new placeholder wherever the project's section was itself still a placeholder or missing.
4. Append the project-only sections from step 1 at the end, unchanged and in their original order.
5. Write the result as `DOX.md` in the project root (even if the old file was named `AGENTS.md` — the new name takes effect here). Delete the temp file.
6. If the old file was the legacy root `AGENTS.md`, delete it now only after confirming `DOX.md` contains the merged content, then remove that root file from the Step 4 migration inventory. Do not delete a shim or unrelated harness instruction file.
7. If any piece of the old file does not clearly belong to either the framework or a project section, KEEP it and list it for the user — never silently drop text.

## Step 4 — Migrate filenames (AGENTS.md → DOX.md)

Run this step when the root framework doc or any recognizable child DOX doc still uses `AGENTS.md`. The filename alone is never sufficient evidence that a file is a DOX doc.

1. Use the Step 0 inventory. Stop traversal at every nested root, whether its full root rules are in `DOX.md` or legacy `AGENTS.md`; never inspect or change files beneath it from the parent project.
2. Classify each remaining `AGENTS.md`:
   - **Root shim:** points to the sibling `DOX.md`; never rename it.
   - **Recognizable legacy DOX doc:** the project root with `# DOX framework`, or a child using Child Doc Shape (including `## Child DOX Index`); eligible to migrate.
   - **Unrelated or ambiguous harness file:** preserve it and report ambiguity; never rename it automatically.
3. Before each rename, confirm the destination `DOX.md` does not exist. If it does, leave both files unchanged and report the conflict — never overwrite either file.
4. Rename only confirmed legacy DOX docs. Within each doc actually migrated, update doc-filename references to `DOX.md` and fix "an DOX.md" → "a DOX.md".
5. Update explicit legacy doc-filename references in affected Child DOX Index entries. Do **not** blanket-replace `AGENTS.md` across current v3 docs: references to the root shim are intentional.

## Step 5 — Ensure agent-harness bridges

Create or update `AGENTS.md` in the project root to ensure other AI harnesses automatically follow DOX.
- If `AGENTS.md` does not exist (e.g. after it was renamed in Step 4), create it with this text:
  `This project uses the DOX framework. Do not add DOX rules here. Read DOX.md in this directory and follow its instructions.`
- If it already points to `DOX.md`, leave it unchanged; do not duplicate the direction.
- If it contains unrelated harness instructions, prepend the direction once and preserve the existing text.
- If it still contains a full legacy DOX framework because Step 4 reported a destination conflict, do not overwrite it; report the unresolved conflict and STOP before reconciliation.

Then ensure Claude Code reaches the same instructions:
- If `CLAUDE.md` does not exist, create it with `@AGENTS.md`.
- If it already imports `AGENTS.md` or directly points to `DOX.md`, preserve it unchanged.
- Otherwise prepend `@AGENTS.md` and preserve all existing Claude-specific instructions.

## Step 6 — Nested roots stay untouched

Never upgrade a nested root (a descendant folder whose own DOX.md or legacy AGENTS.md carries the full DOX rules) — its framework belongs to its own repository. Do NOT rename its files, edit its content, or recurse beneath it. If its `DOX v` line is older than the new version or it still uses the `AGENTS.md` filename, list it and note that the upgrade (including the filename migration) must be run inside that project.

## Step 7 — Reconcile the tree

New rules usually create new mechanical debt (new required sections, new placeholders). Run the `dox-fix` procedure now to bring the doc tree up to the new rules.

## Step 8 — Report

State: old version → new version, which live sections were carried over, which project-only sections were kept, any text you kept because you could not classify it. If a filename migration ran, list every file renamed. Note whether the `AGENTS.md` and `CLAUDE.md` bridges were created, updated, or already valid. List nested roots left on older versions or still using `AGENTS.md`, and summarize what the `dox-fix` pass changed.
