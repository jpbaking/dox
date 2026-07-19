---
name: dox-init
description: Initialize the DOX documentation tree (hierarchy of DOX.md files) for this project. Use when the user asks to set up DOX, initialize DOX, bootstrap DOX.md docs, or index the project with a doc tree. Handles both brand-new projects (little or no code yet) and existing codebases with code but no docs. Do not use for checking or repairing an existing DOX tree — that is dox-audit / dox-fix.
---

# DOX Init

Build this project's DOX tree: one DOX.md per real boundary, from the root down.

## Step 0 — Ensure the framework is present

1. Open `DOX.md` in the project root.
2. If it exists and contains the heading `# DOX framework`, the framework is present — go to Step 1.
3. If `DOX.md` is missing but `AGENTS.md` exists and contains `# DOX framework`, the project uses the **legacy filename** (pre-v3). Suggest the `dox-upgrade` skill to migrate the filenames first, then re-run `dox-init` if needed. STOP.
4. If neither file has DOX rules, fetch the framework from
   `https://raw.githubusercontent.com/jpbaking/dox/main/DOX.md` and save it as `DOX.md` in the project root.
   - If a root `DOX.md` already existed with other content, keep that content: place the framework text at the top, and move the old content below it under a heading `## Project rules (imported)`. Tell the user to review that section.
   - If the fetch fails, STOP. Ask the user to copy `DOX.md` from https://github.com/jpbaking/dox into the project root, then run `dox-init` again.
5. Read the whole root DOX.md now. Every step below follows its rules exactly.

## Step 1 — Decide the mode

Look at the project and pick exactly one:

- **Already initialized** — child DOX.md files or recognizable legacy child AGENTS.md files already exist, or the root's Child DOX Index is filled. Do NOT re-initialize or create competing docs. Say so and suggest `dox-audit` (check), `dox-fix` (repair a v3 root), or `dox-upgrade` (migrate legacy filenames). STOP.
- **New project** — little or no code yet: empty repo, scaffolding only, no meaningful source files.
- **Existing project** — real code exists, but no DOX child docs yet.

## Step 2A — New project (little or no code)

1. Ask the user for a one-line description of what they are building, if they have not given one.
2. Fill the root DOX.md live sections (User Preferences, Feature Map, Child DOX Index) with the project-wide rules you can state from that description.
3. Create a child DOX.md for each boundary already known to be needed (each submodule, subproject, or area with its own build/run/test), using **Child Doc Shape** from the root DOX.md.
4. Fill every Child DOX Index, and fill the Feature Map for each area you can already describe.
5. **Shim agent harnesses.** Ensure root `AGENTS.md` points to DOX. If missing, create it with: `This project uses the DOX framework. Do not add DOX rules here. Read DOX.md in this directory and follow its instructions.` If it already points to DOX, leave it unchanged. Otherwise prepend that direction once while preserving unrelated harness instructions. Never overwrite a full legacy DOX framework as a shim. Then ensure Claude Code is bridged: create `CLAUDE.md` containing `@AGENTS.md` if missing; leave it unchanged if it already imports `AGENTS.md` or points to `DOX.md`; otherwise prepend `@AGENTS.md` and preserve its existing instructions.
6. Go to Step 3.

## Step 2B — Existing project (has code, no docs)

Follow the **Initialization** procedure in the root DOX.md exactly — all steps, no skipping. While doing so, enforce these points:

1. Apply the boundary test at EVERY depth, not just the top level. Every submodule and subproject gets its own DOX.md (a sub-root); recurse into each one.
2. Any descendant folder that carries the full root rules in `DOX.md` or legacy `AGENTS.md` is a **nested root**: leave its whole doc tree and current filename unchanged and just index it as a child. Never rewrite it or recurse into it.
3. Fill every Child DOX Index (one line per direct child; `(none)` at a leaf).
4. Fill every Feature Map — the root DOX.md's included — giving each feature its Start file and its other files.
5. **Shim agent harnesses.** Ensure root `AGENTS.md` points to DOX. If missing, create it with: `This project uses the DOX framework. Do not add DOX rules here. Read DOX.md in this directory and follow its instructions.` If it already points to DOX, leave it unchanged. Otherwise prepend that direction once while preserving unrelated harness instructions. Never overwrite a full legacy DOX framework as a shim. Then ensure Claude Code is bridged: create `CLAUDE.md` containing `@AGENTS.md` if missing; leave it unchanged if it already imports `AGENTS.md` or points to `DOX.md`; otherwise prepend `@AGENTS.md` and preserve its existing instructions.
6. Stop only when the "Done when" check in the Initialization procedure is satisfied.

## Step 3 — Report

Print the full tree of DOX.md files you created, name any folder you deliberately left without a doc, and list any nested roots you found and left untouched.
