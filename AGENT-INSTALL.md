# DOX — agent-guided install

You are an AI coding agent installing DOX. Follow these steps exactly. This
procedure is merge-aware — it never blindly overwrites files the user
already owns — and it is the only install path; there are no install
scripts.

DOX is a **user-global** toolkit: its skills and rule install once per user
into each harness's global discovery paths. This install never touches a
project (not even its `.gitignore`). The per-project footprint is created
later by the skills themselves — the committed `DOX.md` tree plus the root
`AGENTS.md` / `CLAUDE.md` anchors carrying the DOX shim, written or merged
by `dox-init` / `dox-upgrade` — and those are shared project truth in
version control.

Source repository: `https://github.com/jpbaking/dox`. If the user named a
fork or a tag, substitute it below.

## 1. Acquire the sources

Obtain the DOX sources in a temporary directory (never inside a project):

- `git clone --depth 1 https://github.com/jpbaking/dox <tmp>/dox`
  (add `--branch <tag>` if the user pinned a tag), or
- download and extract `https://github.com/jpbaking/dox/archive/refs/heads/main.zip`, or
- `gh repo clone jpbaking/dox <tmp>/dox`.

Copy from this staging directory below; delete it when done.

## 2. Survey before writing

Check for same-named `dox-*` skills in the global directories listed below
and, if you are inside a project, under its `.agents/skills/`,
`.claude/skills/`, `.cline/skills/`. Report anything you find; a
project-level copy with the same name can shadow or duplicate the global
install (old project-scoped DOX installs left gitignored adapters — suggest
removing them only with user approval).

## 3. Install the skills (byte-identical copies)

For each skill `dox-init`, `dox-child`, `dox-audit`, `dox-fix`, `dox-remap`,
`dox-upgrade`, copy `skills/shared/<skill>/SKILL.md` to each selected
harness's global skills directory (ask which harnesses if unclear; all four
is a safe default):

| Harness | Destination |
| --- | --- |
| Codex | `~/.agents/skills/<skill>/SKILL.md` |
| Claude Code | `~/.claude/skills/<skill>/SKILL.md` |
| Antigravity | `~/.gemini/config/skills/<skill>/SKILL.md` |
| Cline | `~/.cline/skills/<skill>/SKILL.md` |

Cursor needs **no separate copy**: it natively discovers `~/.agents/skills/`
(and `~/.claude/skills/` / `~/.codex/skills/` as compatibility paths). Do
not install to `~/.cursor/skills/` — that would create a duplicate.

All copies must be byte-identical across harnesses. Never touch other
skills.

## 4. Install the rule

The rule self-gates: it walks the current project for a DOX root (`DOX.md`
or legacy `AGENTS.md` carrying `# DOX framework`) and, in ungoverned
projects, limits itself to a one-sentence suggestion. It is safe to load
globally.

1. Copy `rules/shared/dox.md` to `~/.agents/rules/dox.md` (neutral shared
   location) and `~/.gemini/config/rules/dox.md` (auto-loaded by
   Antigravity).
2. Cline: copy it to `~/Cline/Rules/dox.md` on Linux, or
   `~/Documents/Cline/Rules/dox.md` on macOS/Windows (if both exist, use the
   populated one).
3. Codex and Claude Code load global guidance from user-owned files — merge,
   never overwrite. Append this marker-guarded block once (skip if the
   marker is present) to **both** `~/.codex/AGENTS.md` and
   `~/.claude/CLAUDE.md` (create either file if missing):

   ```markdown
   <!-- dox:global-rule -->
   Read and follow `~/.agents/rules/dox.md`. In short: before editing any
   file, find its DOX root (topmost ancestor whose `DOX.md` — or legacy
   `AGENTS.md` — contains `# DOX framework`) and comply with it; in projects
   with no DOX root, suggest the `dox-init` skill once, then proceed
   normally.
   <!-- /dox:global-rule -->
   ```

Cursor has no file-based global rules (User Rules are app settings). If
the user works in Cursor, print the pointer block above and ask them to
paste it into Cursor Settings → Rules once; committed project `AGENTS.md`
anchors (the DOX shim) are read by Cursor natively, root and nested.

Never write to `~/.codex/rules` or any `.codex/rules` — that path holds
command-execution policy, not guidance.

## 5. Validate and report

1. Verify every installed skill copy is byte-identical across the selected
   harness destinations and to the canonical source, and that the rule
   copies match.
2. Remove the temporary staging directory.
3. Report every file created, changed, or intentionally left alone, plus any
   collisions from step 2. Note the install is per-user and per-machine.
4. Tell the user the next step: in a project they want governed, ask their
   agent to use the `dox-init` skill (Codex: type `$` and select it;
   Claude Code, Antigravity, Cline: `/dox-init`). `dox-init` /
   `dox-upgrade` create or merge the committed root `AGENTS.md` /
   `CLAUDE.md` anchors (the DOX shim) and the `DOX.md` tree — those are
   shared project files that belong in version control, unlike this
   install's global adapters.

## Project-level adapter install (opt-in only)

Only on explicit user request: copy the six skills to the project's
`.agents/skills/` and `.claude/skills/`, and the rule to `.agents/rules/`,
`.claude/rules/`, and `.clinerules/` (byte-identical). Whether the team
commits or gitignores those adapters is the project's own policy — never
touch the project's `.gitignore` yourself; if existing ignore rules hide
the adapters from a harness, report the exact pattern instead of changing
it.
