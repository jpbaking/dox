---
name: dox-fix
description: Audit AND auto-repair this project's DOX tree (the hierarchy of DOX.md files). Edits docs only — never source code. Use when the user asks to fix, repair, heal, or clean up the DOX docs, DOX.md tree, stale indexes, or broken Feature Maps. For a report without any edits, use dox-audit instead. For deep Feature Map refinement, use dox-remap.
---

# DOX Fix (auto-repair)

Run the DOX health audit, fix the safe mechanical problems, and leave judgment calls to the user. Edit docs only — NEVER change source code.

## Step 0 — Precondition

Open the project root doc: check `DOX.md` first, then `AGENTS.md` (legacy name, pre-v3). If neither exists or neither contains `# DOX framework`, STOP and suggest the `dox-init` skill. If the framework root is the legacy `AGENTS.md`, STOP and suggest `dox-upgrade`; a repair must not perform a partial framework migration. Otherwise read `DOX.md` fully before changing anything.

If the user named a specific folder, scope every step below to that folder only.

## Step 1 — Audit first

Run the full audit from the `dox-audit` skill (Steps 1–2 there): boundary coverage at every depth, Child DOX Index, Feature Map checks (file references, orphaned entries, locality, unmapped features), Child Doc Shape, and parent/child contract conflicts. Keep the findings list — it drives the fixes.

## Step 2 — NESTED ROOTS ARE OFF-LIMITS

Never edit any file inside a descendant folder that carries the full root rules in `DOX.md` **or legacy `AGENTS.md`** (a git submodule, SVN external, Perforce mapped path, or other independently versioned subproject). Stop traversal at that boundary. Do not rewrite its doc into Child Doc Shape, rename it, or strip its DOX rules — that root shape is correct there. List its problems for the user instead; fixes there must be committed in that project's own repository.

## Step 3 — Fix the safe, mechanical problems

- Create a missing DOX.md at every uncovered boundary using Child Doc Shape (write a submodule or subproject as a sub-root).
- **Rename legacy filenames safely:** inventory `AGENTS.md` files outside nested roots, then classify them before editing. Never rename the project-root shim, an unrelated harness instruction file, or any ambiguous file. Rename only a recognizable legacy child DOX doc (for example, one using Child Doc Shape and `## Child DOX Index`) when no `DOX.md` already exists in that folder. If the destination exists, leave both files unchanged and report the conflict. Within a doc actually migrated, update doc-filename references to `DOX.md` and fix "an DOX.md" → "a DOX.md"; do not run a blanket replacement across current v3 docs because their references to the `AGENTS.md` shim are intentional.
- Repair every Child DOX Index: add missing children, drop entries for docs that no longer exist, mark leaves `(none)`, and replace any "Not yet indexed" placeholder.
- **Feature Map — dead references:** correct paths to moved files, remove entries whose files are gone, and replace any "Not yet mapped" placeholder.
- **Feature Map — orphaned entries:** if a feature's Start file has moved to a different subtree, move the entry to the doc that now owns that subtree. Update both the source and destination docs.
- **Feature Map — locality:** if all of a feature's code lives within a single child's subtree but the entry is in the parent, move it down to the child. If a feature in a child doc now spans multiple sibling subtrees, move it up to the parent.
- Fix Child Doc Shape: restore missing sections and their order; convert a submodule/subproject doc into a sub-root where it should be one (but never a nested root — Step 2).
- Repair agent bridges: ensure root `AGENTS.md` points to `DOX.md`; ensure root `CLAUDE.md` imports `AGENTS.md` or directly points to `DOX.md`. Create missing files with the standard minimal content, or prepend the missing direction once while preserving unrelated instructions. Never overwrite a full legacy DOX framework as a shim.
- Delete text describing files or behavior that no longer exist.

## Step 4 — Do NOT guess on judgment calls

For contract conflicts (a child weakening a parent), ambiguous ownership, or a rule you cannot tell is intentional, leave it unchanged and list it for the user instead.

**Feature Map refinement** — adding unmapped features, improving descriptions, or restructuring entries requires reading source code and making subjective choices. Do NOT attempt this here — list these as suggestions for the user and recommend `dox-remap` for a deep code-reading pass.

## Step 5 — Close out

Follow the **Closeout** procedure in the root DOX.md to finish.

## Step 6 — Report

List every file you created or changed (one line each). Then, separately, list the judgment calls and nested-root fixes you left for the user to decide. If Feature Map improvements were flagged but not applied, note them and suggest `dox-remap`.
