<p align="center">
  <img src="./banner.jpg" alt="DOX" width="100%">
</p>

## How DOX works

DOX is a tiny AGENTS.md framework that gives an AI agent precise project context.

The agent keeps a hierarchy of AGENTS.md files as the project changes:

- root AGENTS.md contains project-wide instructions, the project-level Feature Map, and the top-level index
- child AGENTS.md files contain local instructions for specific areas
- before any edit, the agent walks the docs tree from the root to the area it will touch
- the relevant docs give it exact local guidelines, so it does not edit blindly
- after meaningful changes, it updates the affected AGENTS.md files

The result is simple: traverse the docs, understand the local rules, make precise edits, keep the docs current. Less guessing. Less drift. Less "why did it touch that file?"

## Who this fork is for

This fork is tuned for **smaller / weaker models**. Where the original states principles and trusts the model to infer the procedure, this version spells everything out: numbered steps, mechanical tests, explicit exceptions repeated at the point of action. That reliability costs context.

**Overhead:** the root AGENTS.md alone is ~15 KB — roughly **3.5–4k tokens** loaded into context every session, before any child doc on the path to your work area is read.

**If you consistently run frontier models, use the original instead.** The [Agent Zero DOX](https://github.com/agent0ai/dox) framework this fork derives from is leaner and principle-based — a capable model follows it just as well at a fraction of the token cost. Pick this fork when cheaper or smaller models will be doing a meaningful share of the work.

## How to use

Add DOX once, then use the prompt that fits your situation.

**Add DOX.** Copy the contents of [AGENTS.md](./AGENTS.md?plain=1) into an `AGENTS.md` file in your project root. That's it — no installation, no dependencies, no runtime. DOX is just a Markdown instruction, and works with any agent that reads AGENTS.md (Codex, Claude Code, OpenCode, and similar).

The prompts below are written out step by step on purpose. Smaller models follow numbered, explicit instructions far more reliably than short ones, so prefer these full versions.

### Using Cline? Install the skills instead

The core workflows are packaged as [Cline skills](https://docs.cline.bot/customization/skills) under [skills/cline/](./skills/cline/), plus an always-on rule. Install both from your project root:

```sh
curl -fsSL https://raw.githubusercontent.com/jpbaking/dox/main/install-cline.sh | sh
```

That drops the skills into `.cline/skills/` and the rule into `.clinerules/`. Append `-s -- --global` after `sh` to install for every project (`~/.cline/skills/` and `~/Documents/Cline/Rules`) instead. Re-run anytime to update; you can also just copy the folders by hand.

<details>
<summary><strong>Windows / PowerShell</strong></summary>

```powershell
irm https://raw.githubusercontent.com/jpbaking/dox/main/install-cline.ps1 | iex
```

That drops the skills into `.cline\skills\` and the rule into `.clinerules\`. Set `$env:DOX_GLOBAL = "1"` before running to install for every project (`~/.cline/skills/` and `~/Documents/Cline/Rules`) instead. Re-run anytime to update; you can also just copy the folders by hand.

</details>

The skills:

- **`/dox-init`** — initialize the tree; the agent detects whether this is a new project (little or no code) or an existing codebase, and even fetches the framework AGENTS.md for you if it is missing.
- **`/dox-child`** — give it a folder path; it runs the boundary test and either initializes that folder as a child doc (wired into the parent) or explains why it does not deserve one.
- **`/dox-audit`** — read-only health check (lint); reports findings by severity, never edits.
- **`/dox-fix`** — audit + auto-repair; fixes the mechanical problems, leaves judgment calls and nested roots to you.
- **`/dox-upgrade`** — refresh the framework rules in the root AGENTS.md to the latest release, preserving all project content (User Preferences, Feature Map, Child DOX Index, imported rules), then reconcile the tree with `/dox-fix`.

Cline also activates them automatically when your request matches ("lint the docs", "repair the DOX tree"). The skills defer to the procedures in your root AGENTS.md rather than duplicating them, so they stay correct as the framework evolves.

The [rule](./rules/cline/dox.md) (installed by the script above) makes Cline find each edited file's DOX root (a workspace can hold several independent projects, each with its own root) and comply with that chain when one exists, and merely *suggest* `/dox-init` (once, one sentence) when none does — it never initializes on its own.

### New project (little or no code yet)

Nothing to scan, so seed the structure from your intent:

```
Set up DOX for a new project. Do this step by step:
1. Read the whole AGENTS.md in the project root, especially "Where a doc goes: boundaries" and "Child Doc Shape".
2. Here is what I am building: <one-line description>.
3. Create the root AGENTS.md with the project-wide rules.
4. Create a child AGENTS.md for each boundary we already know we need (each submodule, subproject, or area with its own build/run/test). Write each one using Child Doc Shape.
5. Fill every Child DOX Index, and fill the Feature Map for each area you can already describe.
6. Show me the tree you created.
```

<details>
<summary><strong>Short form</strong> — for capable / frontier models</summary>

```
Set up DOX for a new project: <one-line description>. Create the root AGENTS.md and the initial tree.
```

</details>

Then just build — the agent updates the AGENTS.md files as the project grows.

### Existing project (has code, no docs yet)

Have the agent build the tree from your codebase. Tell it to follow the procedure exactly and not skip steps:

```
Initialize DOX for this existing project by following the Initialization procedure in AGENTS.md exactly. Do not skip steps.
1. Read the full AGENTS.md first.
2. Map the folders, skipping node_modules, dist, build, target, .git, and .svn.
3. Apply the boundary test to every folder at EVERY depth, not just the top level. Every submodule and subproject gets its own AGENTS.md (a sub-root); recurse into each one. If any folder already carries its own root AGENTS.md with the full DOX rules, it is a nested root: leave its whole doc tree unchanged and just index it as a child.
4. Write each AGENTS.md using Child Doc Shape.
5. Fill every Child DOX Index (one line per direct child; "(none)" at a leaf).
6. Fill every Feature Map, the root AGENTS.md's included: for each feature give its Start file and its other files.
7. Stop only when the "Done when" check in the Initialization procedure is satisfied, then show me the full tree.
```

<details>
<summary><strong>Short form</strong> — for capable / frontier models</summary>

```
Initialize the DOX tree for this project now: full depth, a sub-root AGENTS.md for every submodule/subproject (leave any folder that already has its own root AGENTS.md — a nested root — untouched), every Child DOX Index and Feature Map populated. Report the tree.
```

</details>

### New session on a DOX project (docs already exist)

Point the agent at the contract before it works:

```
This project uses DOX (a tree of AGENTS.md files). Before you change anything:
1. Read the root AGENTS.md.
2. Tell me which files you plan to touch.
3. For each one, read every AGENTS.md from the root down to it, including any sub-root or nested root on the way.
4. Follow those docs as you work.
After you finish, do the Closeout pass: update the nearest owning AGENTS.md, refresh its Child DOX Index and Feature Map, and tell me what changed.
```

<details>
<summary><strong>Short form</strong> — for capable / frontier models</summary>

```
This project uses DOX. Read the root AGENTS.md and follow it this session: walk the doc chain before editing, and update the affected AGENTS.md (Child DOX Index + Feature Map) after.
```

</details>

**Already know the exact change and where it lives?** Skip the general orientation above and point the agent straight at that one area, so it reads only the docs on the path down to it instead of surveying the whole project. Replace `<path/area>` with the folder you'll work in and `<task>` with the change:

```
Read the DOX chain for <path/area> (root AGENTS.md down to that folder), then do: <task>. When done, update that area's AGENTS.md, its Child DOX Index, and its Feature Map.
```

For example, `<path/area>` = `services/auth` and `<task>` = "add rate limiting to the login endpoint".

### Check the health of the DOX tree (audit / lint)

Docs drift when a weaker model skips a step or someone edits the repo by hand. Run this **read-only** audit to catch misses before they bite. It reports; it does not fix:

```
Audit the health of this project's DOX docs. This is READ-ONLY — do not change any files, just report. Work step by step:
1. Read the root AGENTS.md, especially "Where a doc goes: boundaries" (including "Nested roots") and "Child Doc Shape".
2. Map the folders (skip node_modules, dist, build, target, .git, .svn) and apply the boundary test to every folder at EVERY depth. Mark every folder that carries its own root AGENTS.md with the full DOX rules as a NESTED ROOT — that covers git submodules, SVN externals, Perforce mapped paths, and any other independently versioned subproject.
3. Coverage: list any boundary — especially any submodule or subproject — that has no AGENTS.md, and any AGENTS.md sitting on a folder that is not a boundary.
4. Child DOX Index: for every doc, check it lists every direct child doc (one line each, "(none)" at a leaf) with no missing, extra, or leftover "Not yet indexed" entries.
5. Feature Map: for every listed feature, confirm its Start file and other files still exist; flag entries pointing to moved or deleted files, obvious features that have no entry, and any leftover "Not yet mapped" placeholder.
6. Shape: flag docs that skip required sections, use them out of order, or that should be sub-roots but are not. Exception: a nested root correctly keeps the full DOX rules and root shape — never flag it as a shape violation.
7. Contracts: flag any child or sub-root rule that conflicts with or weakens a parent, and any rule describing behavior or files that no longer exist. Mark conflicts involving a nested root as "decide with the owner" — the fix may belong in the parent, not the nested project.
8. Report findings grouped by severity (broken/missing, stale, minor), each with the file path and a one-line suggested fix. Do not fix anything — ask me first.
```

<details>
<summary><strong>Short form</strong> — for capable / frontier models</summary>

```
Audit this project's DOX health (READ-ONLY, do not edit): check boundary coverage at every depth, Child DOX Index completeness, that Feature Map files still exist, Child Doc Shape conformance, and parent/child contract conflicts. A subproject's own root AGENTS.md (full DOX rules) is a valid nested root, not a shape violation. Report issues grouped by severity with paths and suggested fixes.
```

</details>

To audit just one area, scope it: `Audit the DOX health of <path/area> only (read-only): coverage, Child DOX Index, Feature Map file references, shape, and contract conflicts against its parents. A subproject's own root AGENTS.md (full DOX rules) is a valid nested root, not a shape violation. Report findings with paths and fixes.`

### Fix the DOX tree (auto-repair)

When you want the misses fixed and not just listed, use this. It runs the same audit, then repairs the safe problems and leaves the judgment calls to you:

```
Audit AND repair this project's DOX docs. Edit docs only — never change source code. Work step by step:
1. Run the full DOX health audit first: boundary coverage at every depth, Child DOX Index, Feature Map file references, Child Doc Shape, and parent/child contract conflicts.
2. NESTED ROOTS ARE OFF-LIMITS: never edit any file inside a folder that carries its own root AGENTS.md with the full DOX rules (a git submodule, SVN external, Perforce mapped path, or other independently versioned subproject). Do not rewrite its doc into Child Doc Shape and do not strip its DOX rules — that root shape is correct there. List its problems for me instead; fixes there must be committed in that project's own repository.
3. Fix the safe, mechanical problems directly:
   - Create a missing AGENTS.md at every uncovered boundary using Child Doc Shape (write a submodule or subproject as a sub-root).
   - Repair every Child DOX Index: add missing children, drop entries for docs that no longer exist, mark leaves "(none)", and replace any "Not yet indexed" placeholder.
   - Fix Feature Map entries: correct paths to moved files, remove entries whose files are gone, add obvious missing features with their Start file, and replace any "Not yet mapped" placeholder.
   - Fix Child Doc Shape: restore missing sections and their order; convert a submodule/subproject doc into a sub-root where it should be one (but never a nested root — step 2).
   - Delete text describing files or behavior that no longer exist.
4. Do NOT guess on judgment calls. For contract conflicts (a child weakening a parent), ambiguous ownership, or a rule you cannot tell is intentional, leave it unchanged and list it for me instead.
5. Follow the Closeout procedure in AGENTS.md to finish.
6. Report every file you created or changed (one line each), then separately list the judgment calls and nested-root fixes you left for me to decide.
```

<details>
<summary><strong>Short form</strong> — for capable / frontier models</summary>

```
Audit and auto-fix this project's DOX docs (edit docs only, never source): create missing boundary/sub-root docs, repair every Child DOX Index and Feature Map, fix Child Doc Shape, and remove stale text. Never edit files inside a nested root (any folder with its own root AGENTS.md) — list those fixes for me. Leave contract conflicts and other judgment calls for me too. Run Closeout, then report every changed file and every item left for me.
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
- Added a leaf example and a sub-root example child AGENTS.md, and decoupled the initialization trigger from the Child DOX Index placeholder.
- Added a **Feature Map** section: each doc — the root included, under the same rules — points its features to their entry and supporting source files, so an agent can start a feature with minimal code traversal and an architecture overview can be aggregated by walking the tree.
- Added **nested roots**: any folder that carries its own root AGENTS.md — a git submodule, SVN external, Perforce mapped path, or other independently versioned subproject — keeps its full DOX rules and root shape, so the same doc works whichever folder an engineer roots their workspace at. The parent tree reads it as a local root but never rewrites it; conflicts are reported instead of "fixed," and changes inside it are called out as belonging to that project's own repository.
- Added a **version marker** (`DOX vX.Y.Z`) at the top of the framework, so audits can detect an outdated framework and `/dox-upgrade` can migrate a project's rules without losing its content.
- Trimmed jargon on the procedural path, and reworked the README "How to use" with scenario-specific prompts.

**Why:** the original framework is principle-heavy — capable models infer the procedure from it, but weaker models struggle to comply. These changes turn the principles into explicit procedures so weaker models follow them reliably.
