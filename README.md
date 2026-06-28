<p align="center">
  <img src="./banner.jpg" alt="DOX" width="100%">
</p>

## How DOX works

DOX is a tiny AGENTS.md framework that gives an AI agent precise project context.

The agent keeps a hierarchy of AGENTS.md files as the project changes:

- root AGENTS.md contains project-wide instructions and the top-level index
- child AGENTS.md files contain local instructions for specific areas
- before any edit, the agent walks the docs tree from the root to the area it will touch
- the relevant docs give it exact local guidelines, so it does not edit blindly
- after meaningful changes, it updates the affected AGENTS.md files

The result is simple: traverse the docs, understand the local rules, make precise edits, keep the docs current. Less guessing. Less drift. Less "why did it touch that file?"

## How to use

Add DOX once, then use the prompt that fits your situation.

**Add DOX.** Copy the contents of [AGENTS.md](./AGENTS.md?plain=1) into an `AGENTS.md` file in your project root. That's it — no installation, no dependencies, no runtime. DOX is just a Markdown instruction, and works with any agent that reads AGENTS.md (Codex, Claude Code, OpenCode, and similar).

The prompts below are written out step by step on purpose. Smaller models follow numbered, explicit instructions far more reliably than short ones, so prefer these full versions.

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
2. Map the folders, skipping node_modules, dist, build, target, and .git.
3. Apply the boundary test to every folder at EVERY depth, not just the top level. Every submodule and subproject gets its own AGENTS.md (a sub-root); recurse into each one.
4. Write each AGENTS.md using Child Doc Shape.
5. Fill every Child DOX Index (one line per direct child; "(none)" at a leaf).
6. Fill every Feature Map: for each feature give its Start file and its other files.
7. Stop only when the "Done when" check in the Initialization procedure is satisfied, then show me the full tree.
```

<details>
<summary><strong>Short form</strong> — for capable / frontier models</summary>

```
Initialize the DOX tree for this project now: full depth, a sub-root AGENTS.md for every submodule/subproject, every Child DOX Index and Feature Map populated. Report the tree.
```

</details>

### New session on a DOX project (docs already exist)

Point the agent at the contract before it works:

```
This project uses DOX (a tree of AGENTS.md files). Before you change anything:
1. Read the root AGENTS.md.
2. Tell me which files you plan to touch.
3. For each one, read every AGENTS.md from the root down to it, including any sub-root on the way.
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
- Added a **Feature Map** section: each doc points its features to their entry and supporting source files, so an agent can start a feature with minimal code traversal and an architecture overview can be aggregated by walking the tree.
- Trimmed jargon on the procedural path, and reworked the README "How to use" with scenario-specific prompts.

**Why:** the original framework is principle-heavy — capable models infer the procedure from it, but weaker models struggle to comply. These changes turn the principles into explicit procedures so weaker models follow them reliably.
