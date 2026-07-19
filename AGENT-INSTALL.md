# DOX — agent-guided install

You are an AI coding agent installing DOX into the project at the current
working directory. Follow these steps exactly. This procedure is merge-aware:
it never blindly overwrites files the project already owns, which is why it is
the preferred install path over the shell installer.

Source repository: `https://github.com/jpbaking/dox` (raw base:
`https://raw.githubusercontent.com/jpbaking/dox/main`). If the user named a
fork or a tag, substitute it in every URL below.

## 1. Survey before writing

1. Confirm you are at the target project's root.
2. Note whether these already exist: `AGENTS.md`, `CLAUDE.md`, `.gitignore`,
   `.agents/`, `.claude/`, `.clinerules/`, and any `DOX.md`.
3. Check for same-named skills that could collide: any `dox-*` directory under
   `.agents/skills/`, `.claude/skills/`, `.cline/skills/`, or the user-global
   `~/.agents/skills/`, `~/.claude/skills/`, `~/.cline/skills/`. Report any you
   find; a global skill with the same name can shadow the project copy.
4. If `AGENTS.md` contains a `# DOX framework` heading, it is a legacy (pre-v3)
   DOX root: stop and tell the user to run the `dox-upgrade` skill instead.

## 2. Install the skills

For each skill `dox-init`, `dox-child`, `dox-audit`, `dox-fix`, `dox-remap`,
`dox-upgrade`:

1. Fetch `skills/shared/<skill>/SKILL.md` from the raw base.
2. Write it to `.agents/skills/<skill>/SKILL.md` (Codex, Antigravity, current
   Cline) and an identical copy to `.claude/skills/<skill>/SKILL.md`
   (Claude Code). The two copies must be byte-identical.

Overwriting an existing file at those exact paths is correct — they are
DOX-owned generated adapters. Never touch other skills.

## 3. Install the rule adapters

1. Fetch `rules/shared/dox.md` from the raw base.
2. Write identical copies to `.agents/rules/dox.md`, `.claude/rules/dox.md`,
   and `.clinerules/dox.md`. Never write anything to `.codex/rules` — that
   directory holds command-execution policy, not guidance.

## 4. Bridge files — merge, never overwrite

- `AGENTS.md`: if missing, create it with exactly:
  `This project uses the DOX framework. Do not add DOX rules here. Read `
  `` `DOX.md` in this directory and follow its instructions.``
  If it exists and already mentions `DOX.md`, leave it unchanged. If it exists
  with unrelated instructions, append that single pointer sentence once and
  preserve everything else.
- `CLAUDE.md`: if missing, create it containing only `@AGENTS.md`. If it
  exists and already imports `AGENTS.md` or mentions `DOX.md`, leave it. If it
  exists with unrelated content, prepend the `@AGENTS.md` line once and
  preserve the rest.

## 5. Gitignore the generated adapters

The installed skill and rule copies are generated adapters and must stay out
of the target's git history. In `.gitignore` (create it if missing), add this
block once — skip it entirely if the marker line is already present:

```gitignore
# DOX installer-managed agent adapters (generated; do not edit or commit)
.agents/skills/dox-init/
.claude/skills/dox-init/
.agents/skills/dox-child/
.claude/skills/dox-child/
.agents/skills/dox-audit/
.claude/skills/dox-audit/
.agents/skills/dox-fix/
.claude/skills/dox-fix/
.agents/skills/dox-remap/
.claude/skills/dox-remap/
.agents/skills/dox-upgrade/
.claude/skills/dox-upgrade/
.agents/rules/dox.md
.claude/rules/dox.md
.clinerules/dox.md
```

Do NOT gitignore `AGENTS.md`, `CLAUDE.md`, or `DOX.md` — those are shared,
committable project files. Because the adapters are gitignored, a teammate's
fresh clone will not have them; the committed bridges still work on their own,
and re-running this procedure (or `install.sh`) regenerates the adapters. Never delete or rewrite existing ignore rules; if an existing
rule (for example one hiding `.agents/`) would stop a harness from reading the
adapters, warn the user with the exact pattern instead of changing it.

## 6. Validate and report

1. Verify every `.agents/skills/dox-*/SKILL.md` matches its `.claude` twin.
2. Verify the three rule copies are identical.
3. Verify `AGENTS.md` reaches `DOX.md` and `CLAUDE.md` reaches `AGENTS.md`.
4. Report every file you created, changed, or intentionally left alone, plus
   any collisions or ignore-file warnings from step 1.
5. Tell the user the next step: ask their agent to use the `dox-init` skill
   (Codex: type `$` and select it; Claude Code, Antigravity, Cline:
   `/dox-init`).
