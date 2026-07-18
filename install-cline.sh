#!/bin/sh
# DOX — installer/updater for the Cline skills and rule.
#
# Workspace install (run from your project root):
#   curl -fsSL https://raw.githubusercontent.com/jpbaking/dox/main/install-cline.sh | sh
# Global install (all projects):
#   curl -fsSL https://raw.githubusercontent.com/jpbaking/dox/main/install-cline.sh | sh -s -- --global
#
# Existing DOX skill/rule files are overwritten, so re-running updates them.
# Override the source with DOX_REPO (owner/repo) and DOX_REF (branch or tag).

set -eu

REPO="${DOX_REPO:-jpbaking/dox}"
REF="${DOX_REF:-main}"
BASE="https://raw.githubusercontent.com/$REPO/$REF"
SKILLS="dox-init dox-child dox-audit dox-fix dox-remap dox-upgrade"

MODE="workspace"
if [ "${1:-}" = "--global" ]; then
  MODE="global"
fi

if [ "$MODE" = "global" ]; then
  SKILLS_DIR="$HOME/.cline/skills"
  RULES_DIR="$HOME/Documents/Cline/Rules"
else
  SKILLS_DIR=".cline/skills"
  RULES_DIR=".clinerules"
fi

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

echo "DOX Cline install ($MODE) from $REPO@$REF"
if [ "$MODE" = "workspace" ]; then
  echo "  into $(pwd)"
fi

for s in $SKILLS; do
  fetch "skills/cline/$s/SKILL.md" "$SKILLS_DIR/$s/SKILL.md"
done
fetch "rules/cline/dox.md" "$RULES_DIR/dox.md"

echo "Done. Skills: /dox-init /dox-child /dox-audit /dox-fix /dox-remap /dox-upgrade"
echo "Note: this does not add the framework itself - run /dox-init in Cline"
echo "(or copy DOX.md from https://github.com/$REPO) to set up a project."
