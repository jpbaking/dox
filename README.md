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

### New project (little or no code yet)

Nothing to scan, so seed the structure from your intent:

```
Set up DOX for a new project. Here's what I'm building: <one-line description>. Create the root AGENTS.md and an initial tree for the structure we'll use.
```

Then just build — the agent updates the AGENTS.md files as the project grows.

### Existing project (has code, no docs yet)

Have the agent build the tree from your codebase:

```
Run the Initialization procedure in AGENTS.md: scan the repo, create the root and child AGENTS.md files at durable boundaries, populate every Child DOX Index, then report the tree.
```

Capable models also handle the short form: `Initialize DOX tree for this project now.`

### New session on a DOX project (docs already exist)

Point the agent at the contract before it works:

```
This project uses DOX. Read the root AGENTS.md and follow it this session: walk the doc chain before editing, and update the affected AGENTS.md files after.
```

For a focused task, narrow it: `Read the DOX chain for <path/area>, then <task>.`

## Credits

<p align="center">
  Original framework by <strong><a href="https://www.agent-zero.ai/">Agent Zero</a></strong><br>
  Open-source agentic AI framework<br>
  <a href="https://www.agent-zero.ai/">Website</a> · <a href="https://github.com/agent0ai/agent-zero">GitHub repository</a>
</p>

### Modifications

Modified by [jpbaking](https://github.com/jpbaking).

- Front-loaded the bootstrap path and added an explicit, numbered **Initialization** procedure with a "Done when" check, so the steps to build the tree are spelled out rather than inferred.
- Replaced the abstract "durable boundary" judgment with concrete heuristics, a bias toward fewer docs, and a shallow-first depth limit.
- Added an example child AGENTS.md and decoupled the initialization trigger from the Child DOX Index placeholder.
- Trimmed jargon on the procedural path, and reworked the README "How to use" with scenario-specific prompts.

**Why:** the original framework is principle-heavy — capable models infer the procedure from it, but weaker models struggle to comply. These changes turn the principles into explicit procedures so weaker models follow them reliably.
