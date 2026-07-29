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
`.claude/skills/`, `.cline/skills/`, `.clinerules/skills/`, and
`.pi/skills/`. Report anything you find; a
project-level copy with the same name can shadow or duplicate the global
install (old project-scoped DOX installs left gitignored adapters — suggest
removing them only with user approval).

Also check for this toolkit's legacy rule copies under
`~/.gemini/config/rules/` and the Cline Rules directories. Confirm which of
Antigravity CLI, Codex, Claude Code, Cline, and Pi the user wants; do not
infer consent from detected configuration directories.

## 3. Install the skills (byte-identical copies)

For each skill `dox-init`, `dox-child`, `dox-audit`, `dox-fix`, `dox-remap`,
`dox-upgrade`, copy the whole `.agents/skills/<skill>/` directory to each
selected harness's global skills directory:

| Harness | Destination |
| --- | --- |
| Antigravity CLI (`agy`) | `~/.gemini/antigravity-cli/skills/<skill>/` |
| Codex | `~/.agents/skills/<skill>/` |
| Claude Code | `~/.claude/skills/<skill>/` |
| Cline | `~/.cline/skills/<skill>/` |
| Pi | `~/.agents/skills/<skill>/` |

Codex and Pi share one physical `~/.agents/skills/` copy. If both are
selected, install it once.

All copies must be byte-identical across harnesses. Never touch other
skills.

## 4. Install the rule

The rule self-gates: it walks the current project for a DOX root (`DOX.md`
or legacy `AGENTS.md` carrying `# DOX framework`) and, in ungoverned
projects, limits itself to a one-sentence suggestion. It is safe to load
globally.

1. Copy `rules/shared/dox.md` to `~/.agents/rules/dox.md`.
2. For each selected harness, merge the marker-guarded block below into its
   user-owned global instruction file:

   | Harness | Instruction file |
   | --- | --- |
   | Antigravity CLI (`agy`) | `~/.gemini/GEMINI.md` |
   | Codex | `~/.codex/AGENTS.md` |
   | Claude Code | `~/.claude/CLAUDE.md` |
   | Cline | `~/.agents/AGENTS.md` |
   | Pi | `~/.pi/agent/AGENTS.md` |

   If the marker exists, replace that block with the current text. Otherwise
   append it once. Create a missing file, but never overwrite, reorder, or
   delete unrelated content.

   ```markdown
   <!-- dox:global-rule -->
   Read and follow `~/.agents/rules/dox.md`. In short: before editing any
   file, find its DOX root (topmost ancestor whose `DOX.md` — or legacy
   `AGENTS.md` — contains `# DOX framework`) and comply with it; in projects
   with no DOX root, suggest the `dox-init` skill once, then proceed
   normally.
   <!-- /dox:global-rule -->
   ```

Never write to `~/.codex/rules` or any `.codex/rules` — that path holds
command-execution policy, not guidance.

If a legacy same-tool rule exists in `~/.gemini/config/rules/` or a Cline
Rules directory, report it and ask before removing it. Do not leave both
routes active.

## 5. Validate and report

1. Verify every installed skill copy is byte-identical across the selected
   harness destinations and to the canonical source. Verify the shared rule
   body matches its source and every selected host has exactly one pointer.
2. Remove the temporary staging directory.
3. Report every file created, changed, or intentionally left alone, plus any
   collisions from step 2. Note the install is per-user and per-machine.
4. Tell the user the next step: in a project they want governed, ask their
   agent to use the `dox-init` skill (Codex: type `$` and select it;
   Antigravity CLI and Claude Code: `/dox-init`; Cline also has the project
   shim `/dox-init.md`; Pi: `/skill:dox-init` when enabled). The `dox-init`
   and `dox-upgrade` skills create or merge the committed root `AGENTS.md` /
   `CLAUDE.md` anchors (the DOX shim) and the `DOX.md` tree — those are
   shared project files that belong in version control, unlike this
   install's global adapters.

## Project-level adapter install (opt-in only)

Only on explicit user request: copy the six authoritative skills to the
project's `.agents/skills/`, mirror them byte-identically to
`.claude/skills/`, and copy the six thin shims from
`.clinerules/workflows/`. Merge the self-gating rule body from
`rules/shared/dox.md` once into `AGENTS.md`, preserving the DOX pointer and
all unrelated instructions; ensure `CLAUDE.md` imports `AGENTS.md` exactly
once. Do not duplicate the rule through host rule directories.

Commit the root files, both skill trees, and Cline shims together. Never touch
the project's `.gitignore`; report an exact ignore pattern if it hides an
adapter.
