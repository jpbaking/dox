<p align="center">
  <img src="./banner.jpg" alt="DOX" width="100%">
</p>

## How DOX works

DOX is a tiny documentation framework — a hierarchy of `DOX.md` files — that gives an AI agent precise project context.

The agent keeps a hierarchy of DOX.md files as the project changes:

- root DOX.md contains project-wide instructions, the project-level Feature Map, and the top-level index
- child DOX.md files contain local instructions for specific areas
- before any edit, the agent walks the docs tree from the root to the area it will touch
- the relevant docs give it exact local guidelines, so it does not edit blindly
- after meaningful changes, it updates the affected DOX.md files

The result is simple: traverse the docs, understand the local rules, make precise edits, keep the docs current. Less guessing. Less drift. Less "why did it touch that file?"

## Who this fork is for

This fork is tuned for **smaller / weaker models**. Where the original states principles and trusts the model to infer the procedure, this version spells everything out: numbered steps, mechanical tests, explicit exceptions repeated at the point of action. That reliability costs context.

**Overhead:** the root DOX.md alone is ~15 KB — roughly **3.5–4k tokens** loaded into context every session, before any child doc on the path to your work area is read.

**If you consistently run frontier models, use the original instead.** The [Agent Zero DOX](https://github.com/agent0ai/dox) framework this fork derives from is leaner and principle-based — a capable model follows it just as well at a fraction of the token cost. Pick this fork when cheaper or smaller models will be doing a meaningful share of the work.

## How to use

Add DOX once, then use the prompt that fits your situation.

**Add DOX.** Copy [DOX.md](./DOX.md?plain=1), the lightweight [AGENTS.md shim](./AGENTS.md?plain=1), and the [CLAUDE.md import](./CLAUDE.md?plain=1) into your project root. There are no dependencies or runtime: Codex, Antigravity, and Cline discover the `AGENTS.md` bridge, while Claude Code imports it through `CLAUDE.md`.

The prompts below are written out step by step on purpose. Smaller models follow numbered, explicit instructions far more reliably than short ones, so prefer these full versions.

### Install for Codex, Claude Code, Antigravity, and Cline

The core workflows are portable [Agent Skills](https://agentskills.io/) under [skills/shared/](./skills/shared/). One workspace installer configures them, plus the small instruction adapters each agent needs. Run it from your project root:

```sh
curl -fsSL https://raw.githubusercontent.com/jpbaking/dox/main/install.sh | sh
```

The installer is project-scoped. It writes each shared skill to `.agents/skills/` for Codex, Google Antigravity, and Cline, and to `.claude/skills/` for Claude Code. It also installs the same DOX rule in each host-specific rule directory and creates `AGENTS.md` / `CLAUDE.md` shims when those files do not already exist. Existing root instruction files are preserved and reported instead of overwritten. Re-run anytime to update DOX-owned files.

Separate workflow files are intentionally not installed: all four agents can use an Agent Skill as a reusable workflow, while their dedicated workflow directories and formats are not compatible with one another.

| Agent | Persistent project guidance | Installed skill location | Explicit invocation |
| --- | --- | --- | --- |
| [Codex](https://learn.chatgpt.com/docs/agent-configuration/agents-md) | `AGENTS.md` | `.agents/skills/` | Type `$` and select `dox-init`, or browse with `/skills` |
| [Claude Code](https://code.claude.com/docs/en/memory) | `CLAUDE.md` and `.claude/rules/` | `.claude/skills/` | `/dox-init` |
| [Google Antigravity](https://antigravity.google/docs/rules-workflows) | `.agents/rules/` | `.agents/skills/` | `/dox-init`, or browse with `/skills` |
| [Cline](https://docs.cline.bot/customization/cline-rules) | `AGENTS.md` and `.clinerules/` | `.agents/skills/` ([current Cline source](https://github.com/cline/cline/blob/main/CHANGELOG.md)) | `/dox-init` |

The shared `SKILL.md` files use only the portable `name` and `description` metadata. Host-only fields and host-only workflow formats stay out of the common source.

There is no universal command prefix or autocomplete UI. The portable instruction is plain language: **"Use the `dox-init` skill."** Each agent can also select the skill automatically from its description when the request matches.

Cline's skills page still lists `.cline/skills/`, `.clinerules/skills/`, and `.claude/skills/`, but Cline 3.67 moved its first-party PR skill to `.agents/skills/`; the installer follows that newer shared project convention. The `.clinerules/dox.md` adapter remains because Cline's rule discovery is separate from skill discovery.

<details>
<summary><strong>Windows / PowerShell</strong></summary>

```powershell
irm https://raw.githubusercontent.com/jpbaking/dox/main/install.ps1 | iex
```

This performs the same project-scoped installation on Windows. Override the source repository or ref with `$env:DOX_REPO` and `$env:DOX_REF` if needed.

</details>

The skills:

- **`dox-init`** — initialize the tree; the agent detects whether this is a new project (little or no code) or an existing codebase, and even fetches the framework DOX.md for you if it is missing.
- **`dox-child`** — give it a folder path; it runs the boundary test and either initializes that folder as a child doc (wired into the parent) or explains why it does not deserve one.
- **`dox-audit`** — read-only health check (lint); reports findings by severity, never edits. Now also catches orphaned, mislocated, and unmapped features.
- **`dox-fix`** — audit + auto-repair; fixes the mechanical problems (dead references, orphaned entries, locality violations, legacy filenames), leaves judgment calls and nested roots to you.
- **`dox-remap`** — deep code-reading pass that rebuilds and refines every Feature Map. Discovers unmapped features, retires defunct entries, improves descriptions and file lists. Best used with a strong model or after a large refactor.
- **`dox-upgrade`** — refresh the framework rules in the root DOX.md to the latest release, preserving all project content (User Preferences, Feature Map, Child DOX Index, imported rules), then reconcile the tree with `dox-fix`.

Agents can activate the skills when your request matches ("lint the docs", "repair the DOX tree"), or you can invoke a skill explicitly using that agent's UI. The skills defer to the procedures in your root DOX.md rather than duplicating them, so they stay correct as the framework evolves.

The [shared rule](./rules/shared/dox.md) makes each agent find an edited file's DOX root (a workspace can hold several independent projects, each with its own root) and comply with that chain when one exists. When none exists, it may suggest `dox-init` once, but it never initializes on its own.

### Migrating from DOX v2 (AGENTS.md → DOX.md)

DOX v3 renamed the doc file from `AGENTS.md` to `DOX.md` to avoid conflicts with other AI harnesses that now use `AGENTS.md` as a convention. If your project still has `AGENTS.md` files:

**Using the installed skills?** Run `dox-upgrade` — it renames confirmed legacy DOX docs to `DOX.md`, updates their internal references, upgrades the framework rules, and creates the lightweight `AGENTS.md` / `CLAUDE.md` bridges. It preserves unrelated harness instruction files and never edits a nested root from the parent project.

**Without the skills?** Use this prompt:

```
Upgrade this project's DOX framework. The root doc may still be named AGENTS.md (legacy, pre-v3).
1. Read the root doc (DOX.md or AGENTS.md, whichever exists) — look for the "# DOX framework" heading.
2. Fetch the latest framework from https://raw.githubusercontent.com/jpbaking/dox/main/DOX.md.
3. Merge: keep all project content (User Preferences, Feature Map, Child DOX Index, imported rules), replace only the framework text with the new version, and write the result as DOX.md. Delete the old AGENTS.md if it was renamed.
4. Walk the entire DOX tree, stopping at nested roots. Classify each AGENTS.md before editing: rename only confirmed legacy DOX docs (the framework root or a child using Child Doc Shape). Never rename a root shim, an unrelated harness instruction file, or an ambiguous file. Never overwrite an existing DOX.md; report conflicts instead.
5. Inside docs actually migrated, update legacy doc-filename references to DOX.md and fix "an DOX.md" → "a DOX.md". Do not blanket-replace AGENTS.md in current v3 docs because references to the shim are intentional.
6. Create or update an AGENTS.md shim in the project root with: "This project uses the DOX framework. Do not add DOX rules here. Read DOX.md in this directory and follow its instructions." Do not duplicate the direction or discard unrelated instructions.
7. Ensure Claude Code is bridged too: create CLAUDE.md containing `@AGENTS.md` if missing; if CLAUDE.md already imports AGENTS.md or points to DOX.md, leave it; otherwise prepend `@AGENTS.md` and preserve its existing instructions.
8. Do NOT touch files inside a nested root (a descendant folder with its own root DOX.md or legacy AGENTS.md containing full DOX rules) — note those for me instead.
9. Report every file renamed or changed, every ambiguous/conflicting file preserved, and confirm both bridges exist.
```

### New project (little or no code yet)

Nothing to scan, so seed the structure from your intent:

```
Set up DOX for a new project. Do this step by step:
1. Read the whole DOX.md in the project root, especially "Where a doc goes: boundaries" and "Child Doc Shape".
2. Here is what I am building: <one-line description>.
3. Create the root DOX.md with the project-wide rules.
4. Create a child DOX.md for each boundary we already know we need (each submodule, subproject, or area with its own build/run/test). Write each one using Child Doc Shape.
5. Fill every Child DOX Index, and fill the Feature Map for each area you can already describe.
6. Create an AGENTS.md shim in the project root pointing to DOX.md and a CLAUDE.md that imports it with `@AGENTS.md`.
7. Show me the tree you created.
```

<details>
<summary><strong>Short form</strong> — for capable / frontier models</summary>

```
Set up DOX for a new project: <one-line description>. Create the root DOX.md and the initial tree.
```

</details>

Then just build — the agent updates the DOX.md files as the project grows.

### Existing project (has code, no docs yet)

Have the agent build the tree from your codebase. Tell it to follow the procedure exactly and not skip steps:

```
Initialize DOX for this existing project by following the Initialization procedure in DOX.md exactly. Do not skip steps.
1. Read the full DOX.md first.
2. Map the folders, skipping node_modules, dist, build, target, .git, and .svn.
3. Apply the boundary test to every folder at EVERY depth, not just the top level. Every submodule and subproject gets its own DOX.md (a sub-root); recurse into each one. If any descendant folder already carries the full root rules in DOX.md or legacy AGENTS.md, it is a nested root: leave its whole doc tree unchanged and just index it as a child.
4. Write each DOX.md using Child Doc Shape.
5. Fill every Child DOX Index (one line per direct child; "(none)" at a leaf).
6. Fill every Feature Map, the root DOX.md's included: for each feature give its Start file and its other files.
7. Create an AGENTS.md shim in the project root pointing to DOX.md and a CLAUDE.md that imports it with `@AGENTS.md`.
8. Stop only when the "Done when" check in the Initialization procedure is satisfied, then show me the full tree.
```

<details>
<summary><strong>Short form</strong> — for capable / frontier models</summary>

```
Initialize the DOX tree for this project now: full depth, a sub-root DOX.md for every submodule/subproject. Leave any descendant folder with full root rules in DOX.md or legacy AGENTS.md untouched as a nested root. Populate every Child DOX Index and Feature Map, then report the tree.
```

</details>

### New session on a DOX project (docs already exist)

Point the agent at the contract before it works:

```
This project uses DOX (a tree of DOX.md files). Before you change anything:
1. Read the root DOX.md.
2. Tell me which files you plan to touch.
3. For each one, read every DOX.md from the root down to it, including any sub-root or nested root on the way.
4. Follow those docs as you work.
After you finish, do the Closeout pass: update the nearest owning DOX.md, refresh its Child DOX Index and Feature Map, and tell me what changed.
```

<details>
<summary><strong>Short form</strong> — for capable / frontier models</summary>

```
This project uses DOX. Read the root DOX.md and follow it this session: walk the doc chain before editing, and update the affected DOX.md (Child DOX Index + Feature Map) after.
```

</details>

**Already know the exact change and where it lives?** Skip the general orientation above and point the agent straight at that one area, so it reads only the docs on the path down to it instead of surveying the whole project. Replace `<path/area>` with the folder you'll work in and `<task>` with the change:

```
Read the DOX chain for <path/area> (root DOX.md down to that folder), then do: <task>. When done, update that area's DOX.md, its Child DOX Index, and its Feature Map.
```

For example, `<path/area>` = `services/auth` and `<task>` = "add rate limiting to the login endpoint".

### Check the health of the DOX tree (audit / lint)

Docs drift when a weaker model skips a step or someone edits the repo by hand. Run this **read-only** audit to catch misses before they bite. It reports; it does not fix:

```
Audit the health of this project's DOX docs. This is READ-ONLY — do not change any files, just report. Work step by step:
1. Read the root DOX.md, especially "Where a doc goes: boundaries" (including "Nested roots") and "Child Doc Shape".
2. Map the folders (skip node_modules, dist, build, target, .git, .svn) and apply the boundary test to every folder at EVERY depth. Mark every descendant folder that carries the full root rules in DOX.md or legacy AGENTS.md as a NESTED ROOT, and stop traversal there.
3. Coverage: list any boundary — especially any submodule or subproject — that has no DOX.md, and any DOX.md sitting on a folder that is not a boundary. Count a recognizable legacy child AGENTS.md as covered-but-stale; do not treat the root shim or unrelated harness instructions as DOX docs.
4. Child DOX Index: for every doc, check it lists every direct child doc (one line each, "(none)" at a leaf) with no missing, extra, or leftover "Not yet indexed" entries.
5. Feature Map: for every listed feature, confirm its Start file and other files still exist; flag entries pointing to moved or deleted files, obvious features that have no entry, and any leftover "Not yet mapped" placeholder.
6. Shape: flag docs that skip required sections, use them out of order, or that should be sub-roots but are not. Exception: a nested root correctly keeps the full DOX rules and root shape — never flag it as a shape violation.
7. Contracts: flag any child or sub-root rule that conflicts with or weakens a parent, and any rule describing behavior or files that no longer exist. Mark conflicts involving a nested root as "decide with the owner" — the fix may belong in the parent, not the nested project.
8. Agent bridges: confirm root AGENTS.md points to DOX.md and root CLAUDE.md imports AGENTS.md or directly points to DOX.md.
9. Report findings grouped by severity (broken/missing, stale, minor), each with the file path and a one-line suggested fix. Do not fix anything — ask me first.
```

<details>
<summary><strong>Short form</strong> — for capable / frontier models</summary>

```
Audit this project's DOX health (READ-ONLY, do not edit): check boundary coverage at every depth, Child DOX Index completeness, Feature Map files, Child Doc Shape, parent/child conflicts, and the AGENTS.md / CLAUDE.md bridges. A descendant project's full root rules in DOX.md or legacy AGENTS.md mark a valid nested root; stop traversal there. Do not treat the root AGENTS.md shim as a legacy doc. Report issues grouped by severity with paths and suggested fixes.
```

</details>

To audit just one area, scope it: `Audit the DOX health of <path/area> only (read-only): coverage, Child DOX Index, Feature Map file references, shape, and contract conflicts against its parents. Treat full root rules in DOX.md or legacy AGENTS.md as a nested-root boundary and leave it untouched. Report findings with paths and fixes.`

### Fix the DOX tree (auto-repair)

When you want the misses fixed and not just listed, use this. It runs the same audit, then repairs the safe problems and leaves the judgment calls to you:

```
Audit AND repair this project's DOX docs. Edit docs only — never change source code. Work step by step:
1. Run the full DOX health audit first: boundary coverage at every depth, Child DOX Index, Feature Map file references, Child Doc Shape, and parent/child contract conflicts.
2. NESTED ROOTS ARE OFF-LIMITS: never edit any file inside a descendant folder that carries the full root rules in DOX.md or legacy AGENTS.md. Stop traversal there; do not rename or rewrite anything inside it. List its problems for me instead.
3. Fix the safe, mechanical problems directly:
   - Create a missing DOX.md at every uncovered boundary using Child Doc Shape (write a submodule or subproject as a sub-root).
   - Rename only recognizable legacy child DOX docs named AGENTS.md, and only when DOX.md does not already exist in that folder. Never rename the root AGENTS.md shim, unrelated harness instructions, ambiguous files, or nested-root docs.
   - Repair every Child DOX Index: add missing children, drop entries for docs that no longer exist, mark leaves "(none)", and replace any "Not yet indexed" placeholder.
   - Fix Feature Map entries: correct paths to moved files, remove entries whose files are gone, add obvious missing features with their Start file, and replace any "Not yet mapped" placeholder.
   - Fix Child Doc Shape: restore missing sections and their order; convert a submodule/subproject doc into a sub-root where it should be one (but never a nested root — step 2).
   - Repair the root AGENTS.md / CLAUDE.md bridges without discarding unrelated instructions.
   - Delete text describing files or behavior that no longer exist.
4. Do NOT guess on judgment calls. For contract conflicts (a child weakening a parent), ambiguous ownership, or a rule you cannot tell is intentional, leave it unchanged and list it for me instead.
5. Follow the Closeout procedure in DOX.md to finish.
6. Report every file you created or changed (one line each), then separately list the judgment calls and nested-root fixes you left for me to decide.
```

<details>
<summary><strong>Short form</strong> — for capable / frontier models</summary>

```
Audit and auto-fix this project's DOX docs (edit docs only, never source): create missing boundary/sub-root docs, repair every Child DOX Index and Feature Map, fix Child Doc Shape, repair the root AGENTS.md / CLAUDE.md bridges, and remove stale text. Never edit inside a nested root identified by full root rules in DOX.md or legacy AGENTS.md. Never rename the root AGENTS.md shim or an unrelated/ambiguous harness file. List those items for me, run Closeout, then report every change.
```

</details>

To repair just one area, scope it: `Audit and fix the DOX docs under <path/area> only (docs only, never source). Repair coverage, Child DOX Index, Feature Map, and shape; never edit inside a nested root, and leave contract conflicts for me. Report what changed.`

## Credits

<p align="center">
  Original framework by <strong><a href="https://www.agent-zero.ai/">Agent Zero</a></strong><br>
  Open-source agentic AI framework<br>
  <a href="https://www.agent-zero.ai/">Website</a> · <a href="https://github.com/agent0ai/agent-zero">GitHub repository</a>
</p>

### Modifications

Modified by [jpbaking](https://github.com/jpbaking).

- Front-loaded the bootstrap path and added an explicit, numbered **Initialization** procedure with a "Done when" check, so the steps to build the tree are spelled out rather than inferred.
- Replaced the abstract "durable boundary" judgment with a concrete, mechanical boundary test that a weaker model can apply at every folder.
- Removed the shallow-first depth limit. The doc tree now follows the project's real structure: it recurses to any depth, gives every submodule/subproject its own doc, and treats those as "sub-roots" with their own child trees.
- Added a leaf example and a sub-root example child DOX.md, and decoupled the initialization trigger from the Child DOX Index placeholder.
- Added a **Feature Map** section: each doc — the root included, under the same rules — points its features to their entry and supporting source files, so an agent can start a feature with minimal code traversal and an architecture overview can be aggregated by walking the tree.
- Added **nested roots**: any descendant folder that carries full root rules in DOX.md or legacy AGENTS.md — a git submodule, SVN external, Perforce mapped path, or other independently versioned subproject — keeps its full rules, root shape, and current filename. The parent tree reads it as a local root but never rewrites it; conflicts are reported instead of "fixed."
- Added a **version marker** (`DOX vX.Y.Z`) at the top of the framework, so audits can detect an outdated framework and `dox-upgrade` can migrate a project's rules without losing its content.
- Trimmed jargon on the procedural path, and reworked the README "How to use" with scenario-specific prompts.
- **Renamed `AGENTS.md` → `DOX.md`** across the entire framework. The filename `AGENTS.md` is now a convention shared by multiple frontier AI coding harnesses (Codex, Claude Code, Copilot, Cursor, etc.), so using it for the DOX framework created conflicts. `DOX.md` is unique to this framework and avoids collisions. To ensure these harnesses still automatically follow DOX, the framework now creates and maintains a lightweight `AGENTS.md` shim pointing them to `DOX.md`.

**Why:** the original framework is principle-heavy — capable models infer the procedure from it, but weaker models struggle to comply. These changes turn the principles into explicit procedures so weaker models follow them reliably.
