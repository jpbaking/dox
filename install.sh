#!/bin/sh
# DOX universal workspace installer/updater.
#
# Installs portable Agent Skills for Codex, Google Antigravity, Cline, and
# Claude Code, plus small rule adapters for each host. Run from a project root:
#   curl -fsSL https://raw.githubusercontent.com/jpbaking/dox/main/install.sh | sh
#
# Existing DOX-owned skill and rule files are overwritten on update. Existing
# root AGENTS.md and CLAUDE.md files are never overwritten.
# Override the source with DOX_REPO (owner/repo) and DOX_REF (branch or tag).

set -eu

REPO="${DOX_REPO:-jpbaking/dox}"
REF="${DOX_REF:-main}"
BASE="https://raw.githubusercontent.com/$REPO/$REF"
SKILLS="dox-init dox-child dox-audit dox-fix dox-remap dox-upgrade"

fetch() {
  src="$BASE/$1"
  dest="$2"
  mkdir -p "$(dirname "$dest")"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$src" -o "$dest"
  elif command -v wget >/dev/null 2>&1; then
    wget -q "$src" -O "$dest"
  else
    echo "error: need curl or wget" >&2
    exit 1
  fi
  echo "  + $dest"
}

copy() {
  src="$1"
  dest="$2"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  echo "  + $dest"
}

has_text() {
  file="$1"
  text="$2"
  [ -f "$file" ] && grep -F "$text" "$file" >/dev/null 2>&1
}

GI_MARK="# DOX installer-managed agent adapters (generated; do not edit or commit)"

ensure_gitignore() {
  file=".gitignore"
  if has_text "$file" "$GI_MARK"; then
    echo "  = kept existing .gitignore DOX adapter block"
    return
  fi
  {
    [ -s "$file" ] && printf '\n'
    printf '%s\n' "$GI_MARK"
    for skill in $SKILLS; do
      printf '.agents/skills/%s/\n.claude/skills/%s/\n' "$skill" "$skill"
    done
    printf '.agents/rules/dox.md\n.claude/rules/dox.md\n.clinerules/dox.md\n'
  } >> "$file"
  echo "  + .gitignore (DOX adapter entries; AGENTS.md / CLAUDE.md bridges stay tracked)"
}

echo "DOX universal workspace install from $REPO@$REF"
echo "  into $(pwd)"

# Codex, Antigravity, and current Cline share the open .agents location.
# Claude Code uses the same skill format from its own discovery directory,
# so each skill is fetched once and copied there.
for skill in $SKILLS; do
  fetch "skills/shared/$skill/SKILL.md" ".agents/skills/$skill/SKILL.md"
  copy ".agents/skills/$skill/SKILL.md" ".claude/skills/$skill/SKILL.md"
done

# The rule text is shared; only its discovery path is host-specific.
fetch "rules/shared/dox.md" ".agents/rules/dox.md"
for rule_file in .claude/rules/dox.md .clinerules/dox.md; do
  copy ".agents/rules/dox.md" "$rule_file"
done

# Codex discovers AGENTS.md. Antigravity and Cline also understand it.
if [ ! -e AGENTS.md ]; then
  fetch "AGENTS.md" "AGENTS.md"
elif has_text "AGENTS.md" "# DOX framework"; then
  echo "  ! AGENTS.md is a legacy (pre-v3) DOX framework root; run the dox-upgrade skill to migrate it"
elif ! has_text "AGENTS.md" "DOX.md"; then
  echo "  ! kept existing AGENTS.md; make sure it tells agents to read DOX.md"
else
  echo "  = kept existing AGENTS.md"
fi

# Claude Code discovers CLAUDE.md and supports importing AGENTS.md.
if [ ! -e CLAUDE.md ]; then
  fetch "CLAUDE.md" "CLAUDE.md"
elif ! has_text "CLAUDE.md" "AGENTS.md" && ! has_text "CLAUDE.md" "DOX.md"; then
  echo "  ! kept existing CLAUDE.md; add @AGENTS.md or tell Claude to read DOX.md"
else
  echo "  = kept existing CLAUDE.md"
fi

# Installed adapters are generated files; keep them out of the target's history.
ensure_gitignore

echo "Done. Installed skills: $SKILLS"
echo "Next: ask your agent to use the dox-init skill to add the framework."
echo "Explicit syntax varies: Codex uses a \$ skill mention; Claude, Antigravity, and Cline support /dox-init."
