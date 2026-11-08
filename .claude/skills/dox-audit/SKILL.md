---
name: dox-audit
description: Audit / lint the health of this project's DOX tree (the hierarchy of DOX.md files). READ-ONLY — reports problems, never edits. Use when the user asks to audit DOX, lint the docs, check DOX health, find stale or missing DOX.md files, or verify doc coverage. To actually fix the findings, use the dox-fix skill instead.
---

# DOX Audit (read-only)

Check the DOX tree for drift and report findings. This skill NEVER changes any file — if the user wants repairs, point them to the `dox-fix` skill.

## Step 0 — Precondition

Open the project root doc: check `DOX.md` first, then `AGENTS.md` (legacy name, pre-v3). If neither exists or neither contains `# DOX framework`, STOP and suggest the `dox-init` skill. Otherwise read it fully — especially "Where a doc goes: boundaries" (including "Nested roots") and "Child Doc Shape" — before auditing.

If the user named a specific folder, scope every step below to that folder and its parents' chain only.

## Step 1 — Map

Map the folders (skip `node_modules`, `dist`, `build`, `target`, `.git`, `.svn`, and similar) and apply the boundary test to every folder at EVERY depth. Mark every descendant folder that carries the full root rules in `DOX.md` **or legacy `AGENTS.md`** as a **NESTED ROOT** — that covers git submodules, SVN externals, Perforce mapped paths, and any other independently versioned subproject. Stop traversal at that boundary and audit nothing inside it from the parent project.

## Step 2 — Check, in this order

1. **Coverage:** list any boundary — especially any submodule or subproject — that has no DOX.md, and any DOX.md sitting on a folder that is not a boundary. A recognizable legacy child `AGENTS.md` counts as covered-but-stale, not missing. The project-root `AGENTS.md` shim and unrelated harness instruction files are not DOX docs.
2. **Child DOX Index:** for every doc, check it lists every direct child doc (one line each, `(none)` at a leaf) with no missing, extra, or leftover "Not yet indexed" entries.
3. **Feature Map — file references:** for every listed feature, confirm its Start file and other files still exist; flag entries pointing to moved or deleted files, and any leftover "Not yet mapped" placeholder.
4. **Feature Map — orphaned entries:** for every listed feature, check that its Start file actually lives within the owning doc's subtree. If the code has moved to a different subtree, the entry is **orphaned** — flag it with the doc it should move to.
5. **Feature Map — locality:** flag features listed in a parent doc when all their code lives entirely within a single child's subtree (the entry should be in the child). Conversely, flag features in a child doc that span multiple sibling subtrees (the entry should be in the parent).
6. **Feature Map — unmapped features:** scan source files in each doc's subtree for features that have no Feature Map entry anywhere in the tree. Flag obvious omissions. This is best-effort — do not read every file exhaustively, but do flag clearly distinct features that have no entry.
7. **Shape:** flag docs that skip required sections, use them out of order, or that should be sub-roots but are not. Exception: a nested root correctly keeps the full DOX rules and root shape — never flag it as a shape violation.
8. **Contracts:** flag any child or sub-root rule that conflicts with or weakens a parent, and any rule describing behavior or files that no longer exist. Mark conflicts involving a nested root as "decide with the owner" — the fix may belong in the parent, not the nested project.
9. **Framework version (best-effort):** read the `DOX v` line under `# DOX framework` in the root doc (`DOX.md`, or legacy `AGENTS.md`) and compare it with the same line in the latest framework. Obtain that with git only — never a raw-file download — in a new temporary directory outside the project: `GIT_TERMINAL_PROMPT=0 git clone --depth 1 --filter=blob:none --sparse <remote> <tmp>/dox`, then read `<tmp>/dox/DOX.md` and delete `<tmp>`. Use the DOX remote the user names, otherwise `https://github.com/jpbaking/dox`. If the project's version is older or the line is missing, flag it (minor) and suggest the `dox-upgrade` skill. Also note any nested root on an older version (its upgrade runs in its own repo). If the clone fails, skip this check and say so in one line; never prompt for credentials.
10. **Legacy filenames:** flag only files confidently identified as DOX docs that are still named `AGENTS.md` instead of `DOX.md`. This is a **stale** finding—suggest the `dox-upgrade` skill, which handles the rename automatically. Never flag the project-root shim or an unrelated harness instruction file. A nested root using `AGENTS.md` is noted but not flagged as an error here—its upgrade belongs to its own project.
11. **Agent bridges:** confirm root `AGENTS.md` points to `DOX.md`, root `CLAUDE.md` either imports `AGENTS.md` or directly points to `DOX.md`, and root `.gemini/settings.json` lists `AGENTS.md` in `context.fileName` (Gemini CLI does not read `AGENTS.md` otherwise). Flag a missing or incomplete bridge as **broken/missing**, but preserve unrelated instructions when suggesting the repair.

## Step 3 — Report

Group findings by severity — **broken/missing**, **stale**, **minor** — each with the file path and a one-line suggested fix. Do not fix anything. End by offering `dox-fix` for the mechanical items, `dox-remap` for Feature Map improvements that require reading code, and `dox-upgrade` if the framework is outdated or in-scope legacy docs remain.
