This project uses the DOX framework. Do not add DOX rules here. Read `DOX.md` in this directory and follow its instructions.

<!-- Pre-v3 DOX tooling: the framework doc moved from AGENTS.md to DOX.md in v3. If you fetched this URL expecting the full framework rules, fetch https://raw.githubusercontent.com/jpbaking/dox/main/DOX.md instead. Never merge or install this shim as a project's framework rules. -->

## Contributing to this repository

The shim line above is the project-root bridge DOX ships; this section applies
only to agents developing DOX itself. Follow the
[Portable Agent Authoring](https://github.com/jpbaking/portable-agent-authoring)
guides, especially *Agent toolkit repositories*.

- Edit skills only under `.agents/skills/`. Regenerate `.claude/skills/` as a
  byte-identical full-directory mirror; never edit it independently.
- `DOX.md` is the framework source. Keep
  `.agents/skills/dox-init/assets/DOX.md` byte-identical to it.
- The `DOX v` line always equals the release tag (`dox-audit` and
  `dox-upgrade` rely on it). In every release commit, before tagging, set it
  to the new version in `DOX.md` and the bundled asset, and update the README
  install-prompt pin to the same tag. Releases are `vX.Y.Z` tags only.
- No skill may fetch this repository's files over raw HTTP; bundle them under
  `assets/` or obtain them with `git clone`.
- Keep the self-gating rule body in `rules/shared/dox.md`; update
  `AGENT-INSTALL.md` and `README.md` whenever discovery, invocation, or
  installation changes.
- Dogfooding collision: with DOX installed globally, every harness also sees
  this repository's skills. Claude Code and Cline prefer the global copy (your
  edits seem to have no effect), Codex lists both, and Gemini CLI and OpenCode
  prefer the workspace copy. Test changes in a fresh session with the global
  copy temporarily removed or disabled.
